--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity HRV_buffer is
--	port (clk, reset_n : in std_logic;
--			HRV_in : in std_logic_vector(11 downto 0);
--			HRV_out : out std_logic_vector(11 downto 0)
--			);
--end entity; 

-- HRV_buffer holds last calculated HRV value
architecture behavioural of HRV_buffer is
	constant MAX_HRV : integer := 500;

begin

	process (clk, reset_n)
		variable HRV_temp : std_logic_vector(11 downto 0);				-- Holds latest real HRV value
	begin
	
		if reset_n = '0' then
			HRV_temp := (others => '0');
		
		elsif rising_edge(clk) then
		
			-- filter the data and only replace value if within limits
			if unsigned(HRV_in) > 0 and unsigned(HRV_in) < MAX_HRV then
				HRV_temp := HRV_in;
			end if;
			
			HRV_out <= HRV_temp;
		end if;
	
	end process;

end architecture;