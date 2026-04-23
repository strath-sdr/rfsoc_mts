----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2026 15:57:01
-- Design Name: 
-- Module Name: bram_player - rtl
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


entity bram_player is
    generic (
        DATAWIDTH : integer := 32;
        MEM_SIZE_BYTES : integer := 512
    );
    port (
        -- AXI4-Stream interface
        m_axis_tdata : out std_logic_vector(DATAWIDTH-1 downto 0);
        m_axis_tvalid : out std_logic;
        m_axis_tready : in std_logic;
        
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
--        resync          : in std_logic
    );
end bram_player;

architecture rtl of bram_player is
    
    -- Type & constant initialisations
    type state_type is (WAIT_EN, BRAM_RE);
    constant ADDR_INC : integer := DATAWIDTH/8;
    
    -- Signal initialisations
    signal sig_addr : unsigned(31 downto 0) := (others => '0');
    signal rd_pending  : std_logic := '0';

begin

    -- Default assignments
    din <= (others => '0');
    we <= (others => '0');
    clk <= axis_aclk;
    rst <= not axis_resetn;
    
    -- Internal signal assignements
    addr <= std_logic_vector(sig_addr);
    
    
    
    

    proc_bram_interface : process(axis_aclk)
    begin
        if rising_edge(axis_aclk) then
        
            if axis_resetn = '0' then
                sig_addr <= (others => '0');
                en <= '0';
                rd_pending    <= '0';
                m_axis_tvalid <= '0';
                m_axis_tdata <= (others => '0');
                
            else
                -- default
                m_axis_tvalid <= '0';
                en            <= '0';
        
                -- If last->cycle requested a read, this->cycle dout is valid
                if rd_pending = '1' then
                  m_axis_tdata  <= dout;
                  m_axis_tvalid <= '1';
                end if;
                
                
                -- Decide whether to request the next read
                if enable = '1' then
                    if m_axis_tready = '1' then
                        en         <= '1';
                        rd_pending <= '1';
                        if (sig_addr = MEM_SIZE_BYTES - ADDR_INC) then
                            sig_addr <= (others => '0');
                        else
                            sig_addr <= sig_addr + ADDR_INC;
                        end if;
                    end if;
                    
                else
                    rd_pending <= '0';
                    sig_addr <= (others =>'0');
                end if;
            
            end if;
        
        end if;
    
    end process;


end rtl;
