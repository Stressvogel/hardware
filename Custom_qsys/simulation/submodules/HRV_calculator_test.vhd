library IEEE;
use IEEE.std_logic_1164.all;

entity HRV_calculator_test is
	port (CLOCK_50 : in std_logic;
			KEY	: in std_logic_vector(0 downto 0);
			LEDG	: out std_logic_vector(11 downto 0)
			);
end entity; 