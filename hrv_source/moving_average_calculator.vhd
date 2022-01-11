library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moving_average_calculator is
	generic(data_size : integer := 61);
	port (clk : in std_logic;
			reset_n : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0)
		   );
end entity;