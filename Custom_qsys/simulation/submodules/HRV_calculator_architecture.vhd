--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity HRV_calculator is
-- port(clk, reset_n : in std_logic;
--		input : in std_logic_vector(15 downto 0);
--		HRV : out std_logic_vector(11 downto 0)
--		);
--end entity; 

-- Calculates HRV value based on heartrate data
architecture structural of HRV_calculator is

	component signal_smoother is
		port(	clk, reset_n : in std_logic;
				input : in std_logic_vector(15 downto 0);
				smoothed_input, baseline : out std_logic_vector(15 downto 0)
				);
	end component;
	
	component RR_calculator is
		port (clk_400hz, clk_1000hz, reset_n : in std_logic;
				smoothed_signal, baseline : in std_logic_vector(15 downto 0);
				RR_time : out std_logic_vector(11 downto 0)
				);
	end component; 

	component SDRR_calculator is
		port(	clk, reset_n : in std_logic;
				RR_time : in std_logic_vector(11 downto 0);
				HRV : out std_logic_vector(11 downto 0)
			 );
	end component;
	
	component clock_divider is
		generic(	clock_in_hz : integer := 50000000;
				clock_out_hz : integer := 400);
		port (clk,reset_n: in std_logic;
				clock_out: out std_logic);
	end component;
	
	signal clk_400hz, clk_1000hz : std_logic;
	signal smoothed_signal, baseline : std_logic_vector(15 downto 0);
	signal RR_time : std_logic_vector(11 downto 0);
begin
	cd1 : clock_divider generic map(clock_out_hz => 400) port map (clk => clk, reset_n => reset_n, clock_out => clk_400hz);
	cd2 : clock_divider generic map(clock_out_hz => 1000) port map (clk => clk, reset_n => reset_n, clock_out => clk_1000hz);
	
	ss1 : signal_smoother port map  (clk => clk_400hz, reset_n => reset_n, input => input, 
												smoothed_input => smoothed_signal, baseline => baseline);
	rrc1 : RR_calculator port map   (clk_400hz => clk_400hz, clk_1000hz => clk_1000hz, reset_n => reset_n,
												smoothed_signal => smoothed_signal, baseline => baseline, RR_time => RR_time);
	sddrc1 : SDRR_calculator port map (clk => clk, reset_n => reset_n, RR_time => RR_time, HRV => HRV);
end architecture; 