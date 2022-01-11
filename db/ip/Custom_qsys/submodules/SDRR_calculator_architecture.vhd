--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity SDRR_calculator is
--	port(	clk, reset_n : in std_logic;
--			RR_time : in std_logic_vector(11 downto 0);
--			HRV : out std_logic_vector(11 downto 0)
--		 );
--end entity;


architecture structural of SDRR_calculator is
	component SDRR2_calculator is
		generic (use_samples : integer := 60);
		port (clk, reset_n : in std_logic;
				RR_time : in std_logic_vector(11 downto 0);
				SDRR2 : out std_logic_vector(23 downto 0)
				);
	end component; 
	
	component square_root_calculator IS
		PORT(	aclr		: IN STD_LOGIC ;
				clk		: IN STD_LOGIC ;
				radical		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
				q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
				remainder		: OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
			 );
	END component;
	
	signal reset : std_logic;
	signal SDRR2 : std_logic_vector(23 downto 0);
	
begin
	reset <= not(reset_n);
	
	sdrr2c1 : SDRR2_calculator generic map (use_samples => 60) port map (clk => clk, reset_n => reset_n, 
																								RR_time => RR_time, SDRR2 => SDRR2);
	src1 : square_root_calculator port map (clk => clk, aclr => reset, radical => SDRR2, q => HRV); -- remainder is discarded

end architecture;