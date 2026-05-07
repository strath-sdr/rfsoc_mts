from pynq import DefaultHierarchy, MMIO
import numpy as np
import re



def _ip_to_view(ip_obj, dtype=np.int16):
    """ Configures access to internal memory via MMIO"""
    return ip_obj.mmio.array.view(dtype)


class SignalPlayer(DefaultHierarchy):
    
    def __init__(self, description):
        
        
        super().__init__(description)
        
        # -- Map MMIO array to signal_player & declare its length --
        self._mmio_array = _ip_to_view(self.bram_ctrl)
        self.length = self._mmio_array.shape[0]
        
        # -- Ensure enable is defaulted to off --
        self.disable()
        
    """
    def _memdict_to_view(self, ip, dtype='int16'):
        
        baseAddress = self.mem_dict[ip]["phys_addr"]
        mem_range = self.mem_dict[ip]["addr_range"]
        ipmmio = MMIO(baseAddress, mem_range)
        return ipmmio.array[0:ipmmio.length].view(dtype)
    """
    
    def enable(self):
        self.gpio_enable.channel1[0].on()
        
    def disable(self):
        self.gpio_enable.channel1[0].off()
        
    def load_signal(self, signal):
        signal_array = np.zeros(self.length)
        signal_array[0::2] = signal.real
        signal_array[1::2] = signal.imag
        
        self._mmio_array[:] = np.int16(signal_array)
        
    
    @staticmethod
    def checkhierarchy(description):
        """
        Check for hierarchy with bram_ctrl and gpio_enable IPs
        """
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
            self._mmio_arrays[hier_name] = _ip_to_view(adc_hierarchy.bram_ctrl)
            
        # Assume all BRAM captures have same length
        self.length = self._mmio_arrays[self.bram_hierarchies[0]].shape[0]
        
        # -- Ensure trigger is off by default --
        self.signal_capture_trigger.channel1[0].off()
        
        
        
        """
        # -- ADC Capture Memories --
        self.chA_mmio_array = _ip_to_view(self.adc_a.bram_ctrl)
        self.chB_mmio_array = _ip_to_view(self.adc_b.bram_ctrl)
        self.chC_mmio_array = _ip_to_view(self.adc_c.bram_ctrl)
        self.chD_mmio_array = _ip_to_view(self.adc_d.bram_ctrl)
        
        self.length = self.chA_mmio_array.shape[0]
        
        # -- Ensure trigger is defaulted to off --
        self.signal_capture_trigger.channel1[0].off()
        """
    
    def trigger(self):
        self.signal_capture_trigger.channel1[0].on()
        self.signal_capture_trigger.channel1[0].off()
    
    def capture_adc(self):
        """ Captures ADC samples from three channels and stores to internal memories """
        buffer = np.zeros(
            (self.num_channels, int(self.length/2)),
            dtype=np.complex64
        )

        self.trigger()
        """
        buffer[0] = self.chA_mmio_array[0::2] + 1j*self.chA_mmio_array[1::2]
        buffer[1] = self.chB_mmio_array[0::2] + 1j*self.chB_mmio_array[1::2]
        buffer[2] = -1*(self.chC_mmio_array[0::2] + 1j*self.chC_mmio_array[1::2])
        buffer[3] = -1*(self.chD_mmio_array[0::2] + 1j*self.chD_mmio_array[1::2])
        """
        
        for channel, hier_name in enumerate(self.bram_hierarchies):
            mmio_array = self._mmio_arrays[hier_name]

            buffer[channel] = mmio_array[0::2] + 1j * mmio_array[1::2]
        
        # correct for the RFSoC4x2 polarity swap of Tile224 ADC_D & ADC_C - tile 226 ADC_B, ADC_A are fine
        
        return buffer
    
    @staticmethod
    def checkhierarchy(description):
        # -- Identify signal_capture_trigger IP --
        if 'signal_capture_trigger' not in description.get('ip', {}):
            return False
        
        # -- Search for hierarchies starting with "adc_" containing bram_ctrl memory --
        adc_with_bram = SignalCapture.get_bram_hierarchies(description)
        
        # -- If at least one exists: bind this driver to the parent hierarchy --
        return len(adc_with_bram) > 0
    
    @staticmethod
    def get_bram_hierarchies(description):
        """Find hierarchies starting with "adc_" containing bram_ctrl memory.
        """
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