library IEEE;
use IEEE.std_logic_1164.all;

-- Calculates the SDRR value based on RR time
entity SDRR_calculator is
	port(	clk, reset_n : in std_logic;
			RR_time : in std_logic_vector(11 downto 0);
			HRV : out std_logic_vector(11 downto 0)
		 );
end entity;