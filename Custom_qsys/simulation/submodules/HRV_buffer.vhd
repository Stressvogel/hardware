library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- HRV_buffer holds last calculated HRV value
entity HRV_buffer is
	port (clk, reset_n : in std_logic;
			HRV_in : in std_logic_vector(11 downto 0);
			HRV_out : out std_logic_vector(11 downto 0)
			);
end entity; 
