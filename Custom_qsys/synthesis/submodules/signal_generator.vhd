library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signal_generator is
	port (clock, reset_n : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			addr : out std_logic_vector(11 downto 0)
			);
end entity;

-- requests new data from rom every clock tick 
architecture behavioural of signal_generator is

begin
	data_out <= data_in;
	
	process (clock, reset_n)
		variable address : unsigned(11 downto 0);
		
	begin
		if reset_n = '0' then
			address := (others => '0');
		elsif rising_edge(clock) then
			-- request data from address and increase address variable
			addr <= std_logic_vector(address);
			if address = 4095 then
				address := (others => '0');
			else address := address + 1;
			end if;
		end if;
	end process;
end architecture; 
			
		