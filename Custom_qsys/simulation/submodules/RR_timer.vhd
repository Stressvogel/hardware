library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- counts every ms until peak is detected, then releases counter value
entity RR_timer is
	port (clk, peak_detected, reset_n : in std_logic;
			RR_time : out std_logic_vector(11 downto 0)
			);
end entity; 