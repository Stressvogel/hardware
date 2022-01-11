library IEEE;
use IEEE.std_logic_1164.all;

entity signal_smoother is
	port(	clk, reset_n : in std_logic;
			input : in std_logic_vector(15 downto 0);
			smoothed_input, baseline : out std_logic_vector(15 downto 0)
			);
end entity;