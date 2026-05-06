__author__ = "Ryan Provan"
__organisation__ = "The Univeristy of Strathclyde"
__support__ = "https://github.com/strath-sdr/rfsoc-mts"

import pynq
from pynq import Overlay, PL
from rfsoc_mts.hierarchies import SignalPlayer, SignalCapture
from rfsoc_mts.mts import MultiTileSynchronisation
import xrfclk
import xrfdc
import numpy as np
import matplotlib.pyplot as plt
import os

SAMPLE_FREQ = 4000

DAC_REFERENCE_TILE = 2 # DAC Tile 230
ADC_REFERENCE_TILE = 2 # ADC Tile 226

RFSOC4X2_LMK_FREQ = 500.0
RFSOC4X2_LMX_FREQ = 500.0
RFSOC4X2_DAC_TILES = 0b0101
RFSOC4X2_ADC_TILES = 0b0101

ZCU208_LMK_FREQ = 500.0
ZCU208_LMX_FREQ = 4000.0
ZCU208_DAC_TILES = 0b0011
ZCU208_ADC_TILES = 0b0011

ADC_MAP = {
    "ADC_A": 0,
    "ADC_B": 1,
    "ADC_C": 2,
    "ADC_D": 3,
}

class Overlay(Overlay):
    """
    This overlay demonstrates RFSoC Multi-Tile Synchronization (MTS), enabling latency
    alignment across multiple RF-ADC and RF-DAC tiles. It supports synchronization of
    the RF Data Converter (RFDC) blocks, including NCO-enabled operation, by implementing
    digital feature synchronization. This is a key aspect of MTS when the data converters
    are operating in non-bypass mode.
    """
    def __init__(self, bitfile_name=None, sync_on_init=True, **kwargs):
        
        # -- Identify board and set constants --
        board = os.getenv('BOARD')
        
        if board == 'RFSoC4x2':
            lmk_freq = RFSOC4X2_LMK_FREQ
            lmx_freq = RFSOC4X2_LMX_FREQ
            active_dac_tiles = RFSOC4X2_DAC_TILES
            active_adc_tiles = RFSOC4X2_ADC_TILES
        elif board == 'ZCU208':
            lmk_freq = ZCU208_LMK_FREQ
            lmx_freq = ZCU208_LMX_FREQ
            active_dac_tiles = ZCU208_DAC_TILES
            active_adc_tiles = ZCU208_ADC_TILES
        else:
            assert false, f"This board ({board}) is NOT supported"
            
        # -- Generate default bitfile name --
        if bitfile_name is None:
            this_dir = os.path.dirname(__file__)
            bitfile_name = os.path.join(this_dir, 'rfsoc_mts', 'bitstream', 'mts.xsa')

        # -- Load bitstream/xsa --
        PL.reset()
        super().__init__(bitfile_name, **kwargs)
        
        # -- Setup RF clks & RFDCs for Multi-Tile Synchronisation (MTS) --
        xrfclk.set_ref_clks(
            lmk_freq = lmk_freq,
            lmx_freq = lmx_freq
        )
        
        self.rfdc.dac_tiles[DAC_REFERENCE_TILE].DynamicPLLConfig(1, lmx_freq, SAMPLE_FREQ)
        self.rfdc.adc_tiles[ADC_REFERENCE_TILE].DynamicPLLConfig(1, lmx_freq, SAMPLE_FREQ)
        
        self.mts = MultiTileSynchronisation(
            rfdc = self.rfdc,
            clkwiz = self.sysref_capture.clkwiz,
            dac_active = active_dac_tiles,
            adc_active = active_adc_tiles,
            dac_reftile = DAC_REFERENCE_TILE,
            adc_reftile = ADC_REFERENCE_TILE,
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

                
                
                

def plot_adc(sample_matrix, adc_names, window, title="Signal Comparison"):
    if len(adc_names) == 0:
        raise ValueError("adc_names must contain at least one ADC")

    # -- Extract signals --
    signals = []
    for adc in adc_names:
        if adc not in ADC_MAP:
            raise ValueError(f"Unknown ADC name: {adc}")
        idx = ADC_MAP[adc]
        signals.append(sample_matrix[idx][0:window-1])

    x = np.arange(len(signals[0]))

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