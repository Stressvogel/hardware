library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SDRR2_calculator is
	generic (use_samples : integer := 60);
	port (clk, reset_n : in std_logic;
			RR_time : in std_logic_vector(11 downto 0);
			SDRR2 : out std_logic_vector(23 downto 0)
			);
end entity; 