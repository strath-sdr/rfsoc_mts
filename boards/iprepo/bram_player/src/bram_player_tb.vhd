----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2026 11:53:00
-- Design Name: 
-- Module Name: bram_player_tb - rtl
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


entity bram_player_tb is
    generic (
        DATAWIDTH : integer := 32;
        MEM_SIZE_BYTES : integer := 256
    );
    -- port ( )
end bram_player_tb;

architecture rtl of bram_player_tb is

    -- =====================
    -- Component delcaration
    -- =====================
    component bram_player is
        generic (
            DATAWIDTH       : integer := DATAWIDTH;
            MEM_SIZE_BYTES  : integer := MEM_SIZE_BYTES
        );
        port (
            -- AXI4-Stream interface
            m_axis_tdata    : out std_logic_vector(DATAWIDTH-1 downto 0);
            m_axis_tvalid   : out std_logic;
            m_axis_tready   : in std_logic;
            
            -- BRAM interface
            din             : out std_logic_vector(DATAWIDTH-1 downto 0);
            we              : out std_logic_vector(DATAWIDTH/8-1 downto 0);
            en              : out std_logic;
            dout            : in  std_logic_vector(DATAWIDTH-1 downto 0);
            addr            : out std_logic_vector(31 downto 0);
            clk             : out std_logic;
            rst             : out std_logic;
            
            -- Clocking and resets
            axis_aclk       : in std_logic;
            axis_resetn     : in std_logic;
            
            -- Independent signals and probes
            enable          : in std_logic
        );
    end component;
    
    -- ======================
    -- Signal Initialisations
    -- ======================
    
    -- Port declarations
    signal m_axis_tdata_tb      : std_logic_vector(DATAWIDTH-1 downto 0) := (others=>'0');
    signal m_axis_tvalid_tb     : std_logic := '0';
    signal m_axis_tready_tb     : std_logic := '1';
    
    signal din_tb               : std_logic_vector(DATAWIDTH-1 downto 0);
    signal we_tb                : std_logic_vector(DATAWIDTH/8-1 downto 0);
    signal en_tb                : std_logic;
    signal dout_tb              : std_logic_vector(DATAWIDTH-1 downto 0);
    signal addr_tb              : std_logic_vector(31 downto 0);
    signal clk_tb               : std_logic;
    signal rst_tb               : std_logic;
    
    signal axis_aclk_tb         : std_logic := '1';
    signal axis_resetn_tb       : std_logic := '1';
        
    signal enable_tb            : std_logic := '0';
    
    -- Signal declarations
    
    -- Constant declarations
    constant CLK_PERIOD : time := 2 ns;  -- 500 MHz

begin
    
    -- =============================
    -- Testbench signal manipulation
    -- =============================
    stimuli_proc : process
    begin
        axis_resetn_tb <= '0';
        wait for CLK_PERIOD;
        axis_resetn_tb <= '1';
        
    
    
        wait for CLK_PERIOD*7;
        enable_tb <= '1';
        wait for CLK_PERIOD*((MEM_SIZE_BYTES)/(DATAWIDTH/8)+(MEM_SIZE_BYTES)/(DATAWIDTH/8)/2);
        enable_tb <= '0';
        
        wait for CLK_PERIOD*7;
        enable_tb <= '1';
        wait for CLK_PERIOD*((MEM_SIZE_BYTES/4)/(DATAWIDTH/8));
        enable_tb <= '0';
    
        wait;
    end process;


    -- =====================================
    -- This process simulates the BRAM block
    -- =====================================
    data_proc : process(clk_tb)
    begin
        if rising_edge(clk_tb) then
        
            if en_tb = '1' then
                dout_tb <= std_logic_vector(unsigned(addr_tb)/(DATAWIDTH/8));
            else
                dout_tb <= (others => '0');
            end if;
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
    bram_player_inst : bram_player
        port map (
            -- AXI4-Stream interface
            m_axis_tdata    => m_axis_tdata_tb,
            m_axis_tvalid   => m_axis_tvalid_tb,
            m_axis_tready   => m_axis_tready_tb,
            
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
            enable             => enable_tb
        );


end rtl;
