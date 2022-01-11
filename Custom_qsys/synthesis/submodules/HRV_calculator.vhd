library IEEE;
use IEEE.std_logic_1164.all;

entity HRV_calculator is
 port(clk, reset_n : in std_logic;
		input : in std_logic_vector(15 downto 0);
		HRV : out std_logic_vector(11 downto 0)
		);
end entity; 