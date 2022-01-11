--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity peak_detector is
--	port(	clk, reset_n : in std_logic;
--			in_1, in_2 : in std_logic_vector(15 downto 0);
--			peak_detected : out std_logic
--		 );
--end entity;

-- peak detector detects peak in incoming signal, using the baseline and multiple rules 
architecture behavioural of peak_detector is

begin

	process (clk, reset_n)
		variable in_1_buffer : std_logic_vector(201*16-1 downto 0);	-- buffer for first signal
		variable in_2_buffer : std_logic_vector(101*16-1 downto 0);	-- buffer for second signal
		
		variable b_local_past : integer range 0 to (2**16)*100-1;	-- used to calculate average of past neighbours
		variable b_local_future : integer range 0 to (2**16)*100-1;	-- used to calculated average of future neighbours
		
		variable peak_detected_temp : std_logic;							-- holds value for peak_detected
		
		variable bigger_neighbour : std_logic;								-- boolean set if neighbours of datapoint are bigger than datapoint
		
	begin
		if reset_n = '0' then
			in_1_buffer := (others => '0');
			in_2_buffer := (others => '0');
			
		elsif rising_edge(clk) then
			peak_detected_temp := '0';
			bigger_neighbour := '0';
			
			-- only execute when valid data received
			if unsigned(in_1) /= 0 and unsigned(in_2) /= 0 then
				in_1_buffer := in_1_buffer(in_1_buffer'LEFT-16 downto 0) & in_1;
				in_2_buffer := in_2_buffer(in_2_buffer'LEFT-16 downto 0) & in_2;
				
				-- only execute when first buffer is filled with data
				if unsigned(in_1_buffer(in_1_buffer'LEFT downto in_1_buffer'LEFT-15)) /= 0 then
					b_local_past := 0;
					b_local_future := 0;
				
					-- calculate the sum of neighbours
					for i in 0 to 99 loop
						b_local_past := b_local_past + to_integer(unsigned(in_1_buffer(i*16+15 downto i*16)));
						b_local_future := b_local_future + to_integer(unsigned(in_1_buffer(in_1_buffer'LEFT-i*16 downto in_1_buffer'LEFT-i*16-15)));
					
						-- meanwhile check if datapoint is greater than closest neighbours, if not than set bigger_neighbour
						if i >= 80 then
							if 	to_integer(unsigned(in_1_buffer(i*16+15 downto i*16))) > to_integer(unsigned(in_1_buffer(100*16+15 downto 100*16))) or
								to_integer(unsigned(in_1_buffer(in_1_buffer'LEFT-i*16 downto in_1_buffer'LEFT-i*16-15))) > to_integer(unsigned(in_1_buffer(100*16+15 downto 100*16))) then
									bigger_neighbour := '1';
							end if;
						end if;
					end loop;
					
					-- calculate means
					b_local_past := b_local_past / 100;
					b_local_future := b_local_future / 100;
					
					-- check if data point is bigger than average of 100 neighbouring datapoints
					-- and if data point is bigger than every close 20 neighbour
					-- and if data point is bigger than baseline
					if unsigned(in_1_buffer(100*16+15 downto 100*16)) > b_local_past and
						unsigned(in_1_buffer(100*16+15 downto 100*16)) > b_local_future and
						unsigned(in_1_buffer(100*16+15 downto 100*16)) > unsigned(in_2_buffer(in_2_buffer'LEFT downto in_2_buffer'LEFT-15)) and
						bigger_neighbour = '0' then
							peak_detected_temp := '1';
					end if;
				end if;
			end if;
			
			peak_detected <= peak_detected_temp;
		end if;
	end process;

end architecture;