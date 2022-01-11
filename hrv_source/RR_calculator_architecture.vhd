--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity RR_calculator is
--	port (clk_400hz, clk_1000hz, reset_n : in std_logic;
--			smoothed_signal, baseline : in std_logic_vector(15 downto 0);
--			RR_time : out std_logic_vector(11 downto 0)
--		  );
--end entity; 

architecture structural of RR_calculator is 

	component peak_detector is
		port(	clk, reset_n : in std_logic;
				in_1, in_2 : in std_logic_vector(15 downto 0);
				peak_detected : out std_logic
			 );
	end component;
	
	component RR_timer is
		port (clk, peak_detected, reset_n : in std_logic;
				RR_time : out std_logic_vector(11 downto 0)
				);
	end component; 

	signal peak_detected : std_logic;
	
begin

	pd1 : peak_detector port map (clk => clk_400hz, reset_n => reset_n, in_1 => smoothed_signal, 
											in_2 => baseline, peak_detected => peak_detected);
	rrt1 : RR_timer port map (clk => clk_1000hz, reset_n => reset_n, peak_detected => peak_detected, RR_time => RR_time);


end architecture; 