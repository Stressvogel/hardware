library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity peak_detector is
	port(	clk, reset_n : in std_logic;
			in_1, in_2 : in std_logic_vector(15 downto 0);
			peak_detected : out std_logic
		 );
end entity;