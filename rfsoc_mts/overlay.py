__author__ = "Ryan Provan"
__organisation__ = "The Univeristy of Strathclyde"
__support__ = "https://github.com/strath-sdr/rfsoc-mts"

import pynq
from pynq import Overlay, PL
from .hierarchies import SignalPlayer, SignalCapture
from .mts import MultiTileSynchronisation
import xrfclk
import xrfdc
import numpy as np
import matplotlib.pyplot as plt
import os

SAMPLE_FREQ = 4000

class Overlay(Overlay):
    """
    This overlay demonstrates RFSoC Multi-Tile Synchronization (MTS), enabling latency
    alignment across multiple RF-ADC and RF-DAC tiles. It supports synchronization of
    the RF Data Converter (RFDC) blocks, including NCO-enabled operation, by implementing
    digital feature synchronization. This is a key aspect of MTS when the data converters
    are operating in non-bypass mode.
    """
    def __init__(self,
                 lmx_freq,
                 lmk_freq,
                 dac_mts_reftile,
                 adc_mts_reftile,
                 dac_mts_tiles,
                 adc_mts_tiles,
                 bitfile_name=None,
                 sync_on_init=True,
                 **kwargs):
        
        # -- Identify board and set constants --
        board = os.getenv('BOARD')
        
        if board not in ['RFSoC4x2', 'ZCU208']:
            assert False, f"This board ({board}) is NOT supported"
            
        # -- Generate default bitfile name --
        if bitfile_name is None:
            this_dir = os.path.dirname(__file__)
            bitfile_name = os.path.join(this_dir, 'rfsoc_mts', 'bitstream', 'mts.xsa')

            if not os.path.isdir(bitfile_name):
                raise ValueError("Please provide a valid .xsa file for the hardware overlay.")
            
            

        # -- Load bitstream/xsa --
        PL.reset()
        super().__init__(bitfile_name, **kwargs)
        
        # -- Setup RF clks & RFDCs for Multi-Tile Synchronisation (MTS) --
        xrfclk.set_ref_clks(
            lmk_freq = lmk_freq,
            lmx_freq = lmx_freq
        )
        
        self.rfdc.dac_tiles[dac_mts_reftile].DynamicPLLConfig(1, lmx_freq, SAMPLE_FREQ)
        self.rfdc.adc_tiles[adc_mts_reftile].DynamicPLLConfig(1, lmx_freq, SAMPLE_FREQ)
        
        self.mts = MultiTileSynchronisation(
            rfdc = self.rfdc,
            clkwiz = self.sysref_capture.clkwiz,
            dac_active = dac_mts_tiles,
            adc_active = adc_mts_tiles,
            dac_reftile = dac_mts_reftile,
            adc_reftile = adc_mts_reftile,
            DigitalFeatureSynch=True,
            sync_on_init=sync_on_init,
        )
        
        # -- Insert your functionality below! --
        
    def configure_rfdcs(self, dac_freq, adc_freq, nyquist_zone=1):
        """Configure all MTS ADC/DAC tiles and their enabled blocks. This configuration demonstrates the misalignment when no MTS is used.
        """        
        for t, blocks in self.mts.rfdc_dict["DAC"].items():
            tile = self.rfdc.dac_tiles[t]
            for b in blocks:
                block = tile.blocks[b]
                block.NyquistZone = nyquist_zone
                block.MixerSettings = {
                    'CoarseMixFreq': xrfdc.COARSE_MIX_OFF,
                    'EventSource': xrfdc.EVNT_SRC_IMMEDIATE, # Initially EVNT_SRC_IMMEDIATE
                    'FineMixerScale': xrfdc.MIXER_SCALE_1P0,
                    'Freq': dac_freq,
                    'MixerMode': xrfdc.MIXER_MODE_C2R,
                    'MixerType': xrfdc.MIXER_TYPE_FINE,
                    'PhaseOffset': 0.0
                }
                block.UpdateEvent(xrfdc.EVENT_MIXER)
                tile.SetupFIFO(True)

        for t, blocks in self.mts.rfdc_dict["ADC"].items():
            tile = self.rfdc.adc_tiles[t]
            for b in blocks:
                block = tile.blocks[b]
                block.NyquistZone = nyquist_zone
                block.MixerSettings = {
                    'CoarseMixFreq': xrfdc.COARSE_MIX_OFF,
                    'EventSource': xrfdc.EVNT_SRC_TILE, # Initially EVNT_SRC_TILE
                    'FineMixerScale': xrfdc.MIXER_SCALE_1P0,
                    'Freq': -adc_freq,
                    'MixerMode': xrfdc.MIXER_MODE_R2C,
                    'MixerType': xrfdc.MIXER_TYPE_FINE,
                    'PhaseOffset': 0.0
                }
                block.UpdateEvent(xrfdc.EVENT_MIXER)
                tile.SetupFIFO(True)
                
    def plot_adc(self, sample_matrix, window, title="Signal Comparison"):
        
        adc_names = [name.capitalize() for name in self.signal_capture.bram_hierarchies]
                 
        signals = sample_matrix[:, 0:window]          
        x = np.arange(window)

        fig, axes = plt.subplots(2, 1, sharex=True, figsize=(12, 6))

        styles = ['m-^', '-o', 'r-x', 'g-s', 'c-d', 'k-*']

        # -- Real part --
        for i, sig in enumerate(signals):
            style = styles[i % len(styles)]
            axes[0].plot(x, sig.real, style, markersize=3, label=adc_names[i])

        axes[0].set_title(f"Real ({title})")
        axes[0].set_ylabel("Amplitude")
        axes[0].legend()

        # -- Imag part --
        for i, sig in enumerate(signals):
            style = styles[i % len(styles)]
            axes[1].plot(x, sig.imag, style, markersize=3, label=adc_names[i])

        axes[1].set_title(f"Imag ({title})")
        axes[1].set_xlabel("Sample Index")
        axes[1].set_ylabel("Amplitude")
        axes[1].legend()

        plt.tight_layout()
        plt.show()