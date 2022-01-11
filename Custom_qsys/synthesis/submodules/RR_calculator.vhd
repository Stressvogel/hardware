library IEEE;
use IEEE.std_logic_1164.all;

entity RR_calculator is
	port (clk_400hz, clk_1000hz, reset_n : in std_logic;
			smoothed_signal, baseline : in std_logic_vector(15 downto 0);
			RR_time : out std_logic_vector(11 downto 0)
		  );
end entity; 