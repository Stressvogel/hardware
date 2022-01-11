library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity synchronizer is
	port (clk, reset_n : in std_logic;
			sig_1i, sig_2i : in std_logic_vector(15 downto 0);
			sig_1o, sig_2o : out std_logic_vector(15 downto 0)
		   );
end entity;