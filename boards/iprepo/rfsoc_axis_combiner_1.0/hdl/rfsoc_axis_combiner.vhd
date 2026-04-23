library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rfsoc_axis_combiner is
	generic (
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S02_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S10_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S12_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S20_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S22_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S30_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_S32_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		s0_axis_aclk	: in std_logic;
		s1_axis_aclk	: in std_logic;
		s2_axis_aclk	: in std_logic;
		s3_axis_aclk	: in std_logic;
		
		s0_axis_aresetn	: in std_logic;
		s1_axis_aresetn	: in std_logic;
		s2_axis_aresetn	: in std_logic;
		s3_axis_aresetn	: in std_logic;
		
		-- Channel 0
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tvalid	: in std_logic;
		
		s01_axis_tready	: out std_logic;
		s01_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s01_axis_tvalid	: in std_logic;
		
		-- Channel 1
		s02_axis_tready	: out std_logic;
		s02_axis_tdata	: in std_logic_vector(C_S02_AXIS_TDATA_WIDTH-1 downto 0);
		s02_axis_tvalid	: in std_logic;
		
		s03_axis_tready	: out std_logic;
		s03_axis_tdata	: in std_logic_vector(C_S02_AXIS_TDATA_WIDTH-1 downto 0);
		s03_axis_tvalid	: in std_logic;
		
		-- Channel 2
		s10_axis_tready	: out std_logic;
		s10_axis_tdata	: in std_logic_vector(C_S10_AXIS_TDATA_WIDTH-1 downto 0);
		s10_axis_tvalid	: in std_logic;
		
		s11_axis_tready	: out std_logic;
		s11_axis_tdata	: in std_logic_vector(C_S10_AXIS_TDATA_WIDTH-1 downto 0);
		s11_axis_tvalid	: in std_logic;
		
		-- Channel 3
		s12_axis_tready	: out std_logic;
		s12_axis_tdata	: in std_logic_vector(C_S12_AXIS_TDATA_WIDTH-1 downto 0);
		s12_axis_tvalid	: in std_logic;
		
		s13_axis_tready	: out std_logic;
		s13_axis_tdata	: in std_logic_vector(C_S12_AXIS_TDATA_WIDTH-1 downto 0);
		s13_axis_tvalid	: in std_logic;
		
		-- Channel 4
		s20_axis_tready	: out std_logic;
		s20_axis_tdata	: in std_logic_vector(C_S20_AXIS_TDATA_WIDTH-1 downto 0);
		s20_axis_tvalid	: in std_logic;
		
		s21_axis_tready	: out std_logic;
		s21_axis_tdata	: in std_logic_vector(C_S20_AXIS_TDATA_WIDTH-1 downto 0);
		s21_axis_tvalid	: in std_logic;
		
		-- Channel 5
		s22_axis_tready	: out std_logic;
		s22_axis_tdata	: in std_logic_vector(C_S22_AXIS_TDATA_WIDTH-1 downto 0);
		s22_axis_tvalid	: in std_logic;
		
		s23_axis_tready	: out std_logic;
		s23_axis_tdata	: in std_logic_vector(C_S22_AXIS_TDATA_WIDTH-1 downto 0);
		s23_axis_tvalid	: in std_logic;
		
		-- Channel 6
		s30_axis_tready	: out std_logic;
		s30_axis_tdata	: in std_logic_vector(C_S30_AXIS_TDATA_WIDTH-1 downto 0);
		s30_axis_tvalid	: in std_logic;
		
		s31_axis_tready	: out std_logic;
		s31_axis_tdata	: in std_logic_vector(C_S30_AXIS_TDATA_WIDTH-1 downto 0);
		s31_axis_tvalid	: in std_logic;
		
		-- Channel 7
		s32_axis_tready	: out std_logic;
		s32_axis_tdata	: in std_logic_vector(C_S32_AXIS_TDATA_WIDTH-1 downto 0);
		s32_axis_tvalid	: in std_logic;
		
		s33_axis_tready	: out std_logic;
		s33_axis_tdata	: in std_logic_vector(C_S32_AXIS_TDATA_WIDTH-1 downto 0);
		s33_axis_tvalid	: in std_logic;

        -- Out Channel 0
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_S00_AXIS_TDATA_WIDTH*2-1 downto 0);
		m00_axis_tready	: in std_logic;
		
		-- Out Channel 1
		m02_axis_tvalid : out std_logic;
		m02_axis_tdata  : out std_logic_vector(C_S02_AXIS_TDATA_WIDTH*2-1 downto 0);
		m02_axis_tready : in std_logic;
		
		-- Out Channel 2
		m10_axis_tvalid	: out std_logic;
		m10_axis_tdata	: out std_logic_vector(C_S10_AXIS_TDATA_WIDTH*2-1 downto 0);
		m10_axis_tready	: in std_logic;
		
		-- Out Channel 3
		m12_axis_tvalid	: out std_logic;
		m12_axis_tdata	: out std_logic_vector(C_S12_AXIS_TDATA_WIDTH*2-1 downto 0);
		m12_axis_tready	: in std_logic;
		
		-- Out Channel 4
		m20_axis_tvalid	: out std_logic;
		m20_axis_tdata	: out std_logic_vector(C_S20_AXIS_TDATA_WIDTH*2-1 downto 0);
		m20_axis_tready	: in std_logic;
		
		-- Out Channel 5
		m22_axis_tvalid	: out std_logic;
		m22_axis_tdata	: out std_logic_vector(C_S22_AXIS_TDATA_WIDTH*2-1 downto 0);
		m22_axis_tready	: in std_logic;
		
		-- Out Channel 6
		m30_axis_tvalid	: out std_logic;
		m30_axis_tdata	: out std_logic_vector(C_S30_AXIS_TDATA_WIDTH*2-1 downto 0);
		m30_axis_tready	: in std_logic;
		
		-- Out Channel 7
		m32_axis_tvalid	: out std_logic;
		m32_axis_tdata	: out std_logic_vector(C_S32_AXIS_TDATA_WIDTH*2-1 downto 0);
		m32_axis_tready	: in std_logic
	);
end rfsoc_axis_combiner;

architecture arch of rfsoc_axis_combiner is

begin

s00_process : process(s0_axis_aclk, s0_axis_aresetn)
begin
    if s0_axis_aresetn = '0' then
        m00_axis_tvalid <= '0';
        m00_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s0_axis_aclk) then
            if m00_axis_tready = '1' then
                m00_axis_tvalid <= s01_axis_tvalid and s00_axis_tvalid;
                m00_axis_tdata  <= s01_axis_tdata & s00_axis_tdata;
            end if;
        end if;
    end if;
end process;

s02_process : process(s0_axis_aclk, s0_axis_aresetn)
begin
    if s0_axis_aresetn = '0' then
        m02_axis_tvalid <= '0';
        m02_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s0_axis_aclk) then
            if m02_axis_tready = '1' then
                m02_axis_tvalid <= s03_axis_tvalid and s02_axis_tvalid;
                m02_axis_tdata  <= s03_axis_tdata & s02_axis_tdata;
            end if;
        end if;
    end if;
end process;

s10_process : process(s1_axis_aclk, s1_axis_aresetn)
begin
    if s1_axis_aresetn = '0' then
        m10_axis_tvalid <= '0';
        m10_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s1_axis_aclk) then
            if m10_axis_tready = '1' then
                m10_axis_tvalid <= s11_axis_tvalid and s10_axis_tvalid;
                m10_axis_tdata  <= s11_axis_tdata & s10_axis_tdata;
            end if;
        end if;
    end if;
end process;

s12_process : process(s1_axis_aclk, s1_axis_aresetn)
begin
    if s1_axis_aresetn = '0' then
        m12_axis_tvalid <= '0';
        m12_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s1_axis_aclk) then
            if m12_axis_tready = '1' then
                m12_axis_tvalid <= s13_axis_tvalid and s12_axis_tvalid;
                m12_axis_tdata  <= s13_axis_tdata & s12_axis_tdata;
            end if;
        end if;
    end if;
end process;

s20_process : process(s2_axis_aclk, s2_axis_aresetn)
begin
    if s2_axis_aresetn = '0' then
        m20_axis_tvalid <= '0';
        m20_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s2_axis_aclk) then
            if m20_axis_tready = '1' then
                m20_axis_tvalid <= s21_axis_tvalid and s20_axis_tvalid;
                m20_axis_tdata  <= s21_axis_tdata & s20_axis_tdata;
            end if;
        end if;
    end if;
end process;

s22_process : process(s2_axis_aclk, s2_axis_aresetn)
begin
    if s2_axis_aresetn = '0' then
        m22_axis_tvalid <= '0';
        m22_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s2_axis_aclk) then
            if m22_axis_tready = '1' then
                m22_axis_tvalid <= s23_axis_tvalid and s22_axis_tvalid;
                m22_axis_tdata  <= s23_axis_tdata & s22_axis_tdata;
            end if;
        end if;
    end if;
end process;

s30_process : process(s3_axis_aclk, s3_axis_aresetn)
begin
    if s3_axis_aresetn = '0' then
        m30_axis_tvalid <= '0';
        m30_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s3_axis_aclk) then
            if m30_axis_tready = '1' then
                m30_axis_tvalid <= s31_axis_tvalid and s30_axis_tvalid;
                m30_axis_tdata  <= s31_axis_tdata & s30_axis_tdata;
            end if;
        end if;
    end if;
end process;

s32_process : process(s3_axis_aclk, s3_axis_aresetn)
begin
    if s3_axis_aresetn = '0' then
        m32_axis_tvalid <= '0';
        m32_axis_tdata  <= (others=>'0');
    else
        if rising_edge(s3_axis_aclk) then
            if m32_axis_tready = '1' then
                m32_axis_tvalid <= s33_axis_tvalid and s32_axis_tvalid;
                m32_axis_tdata  <= s33_axis_tdata & s32_axis_tdata;
            end if;
        end if;
    end if;
end process;

s00_axis_tready <= m00_axis_tready;
s01_axis_tready <= m00_axis_tready;
s02_axis_tready <= m02_axis_tready;
s03_axis_tready <= m02_axis_tready;
s10_axis_tready <= m10_axis_tready;
s11_axis_tready <= m10_axis_tready;
s12_axis_tready <= m12_axis_tready;
s13_axis_tready <= m12_axis_tready;
s20_axis_tready <= m20_axis_tready;
s21_axis_tready <= m20_axis_tready;
s22_axis_tready <= m22_axis_tready;
s23_axis_tready <= m22_axis_tready;
s30_axis_tready <= m30_axis_tready;
s31_axis_tready <= m30_axis_tready;
s32_axis_tready <= m32_axis_tready;
s33_axis_tready <= m32_axis_tready;

end arch;
