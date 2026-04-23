----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2026 13:58:03
-- Design Name: 
-- Module Name: bram_capture_tb - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram_capture_tb is
    generic(
            DATAWIDTH           : integer := 32;
            MEM_SIZE_BYTES      : integer := 512
        );
--  Port ( );
end bram_capture_tb;

architecture rtl of bram_capture_tb is

    -- Component declaration
    component bram_capture is
        generic(
            DATAWIDTH           : integer := DATAWIDTH;
            MEM_SIZE_BYTES      : integer := MEM_SIZE_BYTES
        );
        Port (
            -- AXI4-Stream interface
            s_axis_tdata        : in std_logic_vector(DATAWIDTH-1 downto 0);
            s_axis_tvalid       : in std_logic;
            s_axis_tready       : out std_logic;
            
            -- BRAM interface
            din                 : out std_logic_vector(DATAWIDTH-1 downto 0);
            we                  : out std_logic_vector(DATAWIDTH/8-1 downto 0);
            en                  : out std_logic;
            dout                : in  std_logic_vector(DATAWIDTH-1 downto 0);
            addr                : out std_logic_vector(31 downto 0);
            clk                 : out std_logic;
            rst                 : out std_logic;
            
            -- Clocking and resets
            axis_aclk           : in std_logic;
            axis_resetn         : in std_logic;
            
            -- Independent signals and probes
            trigger             : in std_logic;
            
            probe_state         : out std_logic;
            probe_trigger_re    : out std_logic
      );
    end component;
    
    -- Testbench port declarations
    signal s_axis_tdata_tb : std_logic_vector(DATAWIDTH-1 downto 0) := (others=>'0');
    signal s_axis_tvalid_tb : std_logic := '0';
    signal s_axis_tready_tb : std_logic;
    
    signal din_tb               : std_logic_vector(DATAWIDTH-1 downto 0);
    signal we_tb                : std_logic_vector(DATAWIDTH/8-1 downto 0);
    signal en_tb                : std_logic;
    signal dout_tb              :  std_logic_vector(DATAWIDTH-1 downto 0);
    signal addr_tb              : std_logic_vector(31 downto 0);
    signal clk_tb               : std_logic;
    signal rst_tb               : std_logic;
    
    signal axis_aclk_tb         : std_logic := '1';
    signal axis_resetn_tb       : std_logic := '1';
        
    signal trigger_tb           : std_logic := '0';
    signal probe_state_tb       : std_logic;
    signal probe_trigger_re_tb  : std_logic;
    
    -- Testbench signal delcarations
    signal counter : unsigned (31 downto 0) := (others => '0');
    
    -- Constant declarations
    constant CLK_PERIOD : time := 2 ns;  -- 500 MHz
    
    type mode_t is (CONTINUOUS_VALID, ALTERNATING_VALID);
    constant testbench_mode : mode_t := CONTINUOUS_VALID;
    
begin

    -- =============================
    -- Testbench signal manipulation
    -- =============================
    stimuli : process
    begin
        wait for CLK_PERIOD*32;
        trigger_tb <= '1';
        wait for CLK_PERIOD*2;
        trigger_tb <= '0';
        
        -- test to ensure an additional trigger doesnt impact writing
        wait for CLK_PERIOD*100;
        trigger_tb <= '1';
        wait for CLK_PERIOD;
        trigger_tb <= '0';
        
        wait;
    end process;
    

    -- =========================================================
    -- This drives an incrementing AXI-Stream Slave tdata signal
    -- =========================================================
    data_proc : process(axis_aclk_tb)
        variable alt_valid : std_logic := '0';
    begin
        if rising_edge(axis_aclk_tb) then
            case testbench_mode is
                when CONTINUOUS_VALID =>
                    -- continuous stream of valid data
                    s_axis_tvalid_tb <= '1';    -- Always valid
                    s_axis_tdata_tb  <= std_logic_vector(unsigned(s_axis_tdata_tb) + 1);
    
                when ALTERNATING_VALID =>
                    -- Toggle valid every other clock
                    alt_valid := not alt_valid;
                    s_axis_tvalid_tb <= alt_valid;
                    
                    s_axis_tdata_tb <= std_logic_vector(unsigned(s_axis_tdata_tb) + 1);
    
                when others =>
                    s_axis_tvalid_tb <= '0';
            end case;
        end if;
    end process;
    
    -- =============
    -- Clock process
    -- =============
    clock_gen : process
    begin
        wait for CLK_PERIOD/2;
        axis_aclk_tb <= not axis_aclk_tb;
    end process;
    
    -- =======================
    -- Component instantiation
    -- =======================
    bram_capture_inst : bram_capture
        port map(
            -- AXI4-Stream interface
            s_axis_tdata        => s_axis_tdata_tb,
            s_axis_tvalid       => s_axis_tvalid_tb,
            s_axis_tready       => s_axis_tready_tb,
            
            -- BRAM interface
            din                 => din_tb,
            we                  => we_tb,
            en                  => en_tb,
            dout                => dout_tb,
            addr                => addr_tb,
            clk                 => clk_tb,
            rst                 => rst_tb,
            
            -- Clocking and resets
            axis_aclk           => axis_aclk_tb,
            axis_resetn         => axis_resetn_tb,
            
            -- Independent signals and probes
            trigger             => trigger_tb,
            
            probe_state         => probe_state_tb,
            probe_trigger_re    => probe_trigger_re_tb
            
        );

end rtl;
