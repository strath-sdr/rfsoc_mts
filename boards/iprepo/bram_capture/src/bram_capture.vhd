----------------------------------------------------------------------------------
-- Company: StrathSDR
-- Engineer: Ryan Provan
-- 
-- Create Date: 23.02.2026 23:05:29
-- Design Name: BRAM Capture
-- Module Name: bram_capture - rtl
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

entity bram_capture is
    generic (
        DATAWIDTH           : integer := 32;
        MEM_SIZE_BYTES      : integer := 65536
    );
    port (
        -- AXI4-Stream interface
        s_axis_tdata    : in std_logic_vector(DATAWIDTH-1 downto 0);
        s_axis_tvalid   : in std_logic;
        s_axis_tready   : out std_logic;
        
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
        trigger         : in std_logic;
        
        probe_state     : out std_logic;
        probe_trigger_re   : out std_logic 
  );
end bram_capture;

architecture rtl of bram_capture is
    
    -- Type & constant initialisations
    type state_type is (WAIT_TRIG, BRAM_WR);
    constant ADDR_INC : integer := DATAWIDTH/8;
    
    -- Signal initialisations
    signal trigger_prev : std_logic := '0';
    signal trigger_re : std_logic := '0';
    signal triggered_flag : std_logic := '0';
    
    signal sig_addr : unsigned(31 downto 0) := (others => '0');
    signal sig_en : std_logic := '0';
    
    -- State initialisations
    signal state : state_type := WAIT_TRIG;
    
begin

    s_axis_tready <= '1';
    
    -- BRAM rst and clk inherit from the axis clk
    clk <= axis_aclk;
    rst <= not axis_resetn;
    
    -- Internal signal assignments
    addr <= std_logic_vector(sig_addr);
    
    -- Probes
    probe_trigger_re <= trigger_re;
    
    
    
    -- BRAM address control
    proc_bram_interface : process(axis_aclk)
    begin
        if rising_edge(axis_aclk) then
        
            if axis_resetn = '0' then
                en <= '0';
                sig_addr <= (others => '0');
                we <= (others => '0');
                din <= (others => '0');
            else
                -- Risisng edge detector for CDCed trigger
                trigger_prev <= trigger;
                trigger_re <= trigger and not trigger_prev;
                
                if trigger_re = '1' then
                    triggered_flag <= '1';
                end if;
                
                din <= s_axis_tdata;
                
                -- ==========================
                -- Finite State Machine (FSM)
                -- ==========================
                case state is
                    when WAIT_TRIG =>
                        probe_state <= '0';
                        
                        sig_addr <= (others => '0');
                        
                        -- If rising edge has been detected ->
                        --      enable bram & write first valid sample to the first block of addresses.
                        if (trigger_re or triggered_flag) = '1' then
                            if s_axis_tvalid = '1' then
                                en <= '1';
                                we <= (others => '1');
                                state <= BRAM_WR;
                                triggered_flag <= '0';
                            end if;
                            
                        else
                            en <= '0';
                            we <= (others => '0');
                            state <= WAIT_TRIG;
                        end if;
                        
                        
                    when BRAM_WR =>
                        probe_state <= '1';
                        -- If valid detected ->
                        --      Enable we and increment the address. Disable BRAM and switch state once memory is full
                        if s_axis_tvalid = '1' then
                            if (sig_addr < MEM_SIZE_BYTES-ADDR_INC) then
                                we <= (others => '1');
                                sig_addr <= sig_addr + ADDR_INC;
                            else
                                we <= (others => '0');
                                state <= WAIT_TRIG;
                            end if;
                            
                        end if;
                end case;

            end if;
        end if;
    end process;


end rtl;
