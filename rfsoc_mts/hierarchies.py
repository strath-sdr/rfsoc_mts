__author__ = "Ryan Provan"
__organisation__ = "The Univeristy of Strathclyde"
__support__ = "https://github.com/strath-sdr/rfsoc_mts"

from pynq import DefaultHierarchy, MMIO
import numpy as np
from time import sleep


class SignalPlayer(DefaultHierarchy):
    
    def __init__(self, description):
        
        
        super().__init__(description)
        
        # -- Map MMIO array to signal_player & declare its length --
        self._mmio_array = self.bram_ctrl.mmio.array.view(np.int16)
        self.length = self._mmio_array.shape[0]
        
        # -- Ensure enable is defaulted to off --
        self.disable()
    
    def enable(self):
        """Enable reading from Signal Player's BRAM, thus signal generation."""
        self.gpio_enable.channel1[0].on()
        
    def disable(self):
        """Disable reading from Signal Player's BRAM, thus signal generation."""
        self.gpio_enable.channel1[0].off()
        
    def load_signal(self, signal):
        """Load a PS generated signal into the Signal Player's BRAM"""
        signal_array = np.zeros(self.length)
        signal_array[0::2] = signal.real
        signal_array[1::2] = signal.imag
        
        self._mmio_array[:] = np.int16(signal_array)
        
    
    @staticmethod
    def checkhierarchy(description):
        """Check for hierarchy with bram_ctrl and gpio_enable IPs."""
        return description["fullpath"].split("/")[-1] == "signal_player"
    
    
class SignalCapture(DefaultHierarchy):
    
    def __init__(self, description):
        
        super().__init__(description)
        
        # -- Find ADC hierarchies containing bram_ctrl --
        self.bram_hierarchies = self.get_bram_hierarchies(description)
        self.num_channels = len(self.bram_hierarchies)
        
        # -- Map MMIO for each ADC bram --
        self._mmio_arrays = {}

        for hier_name in self.bram_hierarchies:
            adc_hierarchy = getattr(self, hier_name)
            self._mmio_arrays[hier_name] = adc_hierarchy.bram_ctrl.mmio.array.view(np.int16)
            
        # -- Assume all BRAM captures have same length --
        self.length = self._mmio_arrays[self.bram_hierarchies[0]].shape[0]
        
        # -- Ensure trigger is off by default --
        self.signal_capture_trigger.channel1[0].off()
    
    def trigger(self):
        """Invoke AXI GPIO IP core to produce rising edge and begin a BRAM Signal Capture write."""
        self.signal_capture_trigger.channel1[0].on()
        self.signal_capture_trigger.channel1[0].off()
    
    def capture_adc(self):
        """Captures samples from all detected sub-hierarchies and writes them to their respective Signal Capture BRAM."""
        buffer = np.zeros(
            (self.num_channels, int(self.length/2)),
            dtype=np.complex64
        )

        self.trigger()
        
        for channel, hier_name in enumerate(self.bram_hierarchies):
            mmio_array = self._mmio_arrays[hier_name]

            buffer[channel] = mmio_array[0::2] + 1j * mmio_array[1::2]
            
        return buffer
    
    @staticmethod
    def checkhierarchy(description):
        """Bind to hierarchy containing 'signal_capture_trigger' IP and atleast one sub-hierarchy containing bram_ctrl"""
        # -- Identify signal_capture_trigger IP --
        if 'signal_capture_trigger' not in description.get('ip', {}):
            return False
        
        # -- Search for hierarchies starting with "adc_" containing bram_ctrl memory --
        adc_with_bram = SignalCapture.get_bram_hierarchies(description)
        
        # -- If at least one hierarchy containing bram_ctrl exists; bind this driver to the parent hierarchy --
        return len(adc_with_bram) > 0
    
    @staticmethod
    def get_bram_hierarchies(description):
        """Find hierarchies starting with "adc_" containing bram_ctrl memory."""
        hierarchies = description.get('hierarchies', {})

        adc_with_bram = []

        for hier_name, hier_desc in hierarchies.items():
            # Only consider hierarchies starting with "adc_"
            if not hier_name.startswith('adc_'):
                continue

            # Check if this hierarchy contains bram_ctrl in memory field
            ip_dict = hier_desc.get('memories', {})
            if 'bram_ctrl' in ip_dict:
                adc_with_bram.append(hier_name)

        return sorted(adc_with_bram)
