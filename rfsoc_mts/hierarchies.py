__author__ = "Ryan Provan"
__organisation__ = "The Univeristy of Strathclyde"
__support__ = "https://github.com/strath-sdr/rfsoc-mts"

from pynq import DefaultHierarchy, MMIO
import numpy as np
from time import sleep



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
        # -- ADC Capture Memories --
        self.chA_mmio_array = _ip_to_view(self.adc_a.bram_ctrl)
        self.chB_mmio_array = _ip_to_view(self.adc_b.bram_ctrl)
        self.chC_mmio_array = _ip_to_view(self.adc_c.bram_ctrl)
        self.chD_mmio_array = _ip_to_view(self.adc_d.bram_ctrl)
        
        self.length = self.chA_mmio_array.shape[0]
        
        # -- Ensure trigger is defaulted to off --
        self.gpio_trigger.channel1[0].off()
    
    def trigger(self):
        self.gpio_trigger.channel1[0].on()
        self.gpio_trigger.channel1[0].off()
        
    def capture_dac(self):
        """ Captures ADC samples from three channels and stores to internal memories """
        self.trigger()
        buffer = self.dac_mmio_array[0::2] + 1j*self.dac_mmio_array[1::2]
        return buffer.astype(np.complex64)
    
    def capture_adc(self):
        """ Captures ADC samples from three channels and stores to internal memories """
        buffer = np.zeros((4, int(self.length/2)), dtype=np.complex64)

        self.trigger()
        sleep(0.1)

        buffer[0] = self.chA_mmio_array[0::2] + 1j*self.chA_mmio_array[1::2]
        buffer[1] = self.chB_mmio_array[0::2] + 1j*self.chB_mmio_array[1::2]
        buffer[2] = -1*(self.chC_mmio_array[0::2] + 1j*self.chC_mmio_array[1::2])
        buffer[3] = -1*(self.chD_mmio_array[0::2] + 1j*self.chD_mmio_array[1::2])
        
        # correct for the RFSoC4x2 polarity swap of Tile224 ADC_D & ADC_C - tile 226 ADC_B, ADC_A are fine
        
        return buffer
        
    
    @staticmethod
    def checkhierarchy(description):
        """
        Check for hierarchy with gpio_trigger (IP) and adc_a, adc_b, adc_c, adc_d (hierarchies).
        """
        if 'gpio_trigger' in description['ip'] \
        and 'adc_a' in description['hierarchies'] \
        and 'adc_b' in description['hierarchies'] \
        and 'adc_c' in description['hierarchies'] \
        and 'adc_d' in description['hierarchies']:
                return True
        return False