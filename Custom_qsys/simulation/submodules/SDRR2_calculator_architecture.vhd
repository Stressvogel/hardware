--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity SDRR2_calculator is
--	generic (use_samples : integer := 60);
--	port (clk, reset_n : in std_logic;
--			RR_time : in std_logic_vector(11 downto 0);
--			SDRR2 : out std_logic_vector(15 downto 0)
--			);
--end entity; 

-- calculates SDRR value to the power of 2 of incoming signal
architecture behavioural of SDRR2_calculator is

begin

	process (clk, reset_n)
		variable data : unsigned(use_samples*12-1 downto 0);																-- holds input data
		variable sum : integer;																										-- holds sum, range of maximum sum to the power of two 
		variable mean : integer;																									-- used to hold mean 
		variable data_temp : integer range 0 to 2**12-1;																	-- temporary holds integer form of datapoint
		variable SDRR2_temp : unsigned(23 downto 0);																			-- holds SDDR2 value to output
		variable prev_RR_time : unsigned (11 downto 0);																		-- holds previous RR time for comparison
	begin
		
		if reset_n = '0' then
			data := (others => '0');
			prev_RR_time := (others => '0');
		
		elsif rising_edge(clk) then
			SDRR2_temp := (others => '0');
			
			-- only execute when input is new RR time
			if prev_RR_time /= unsigned(RR_time) and prev_RR_time = 0 then
				-- put input in the buffer
				data := data((use_samples-1)*12-1 downto 0) & unsigned(RR_time);
				
				-- only execute if buffer is filled
				if to_integer(data(use_samples*12-1 downto use_samples*12-12)) /= 0 then
					sum := 0;
					
					-- calculate sum of all datapoints
					for i in 0 to use_samples-1 loop
						sum := sum + to_integer(data((i*12)+11 downto i*12));
					end loop;
					
					-- calculate the mean 
					mean := sum / use_samples;
					sum := 0;
					
					-- calculate sum of (RRi - mean)^2
					for i in 0 to use_samples-1 loop
						data_temp := to_integer(data((i*12)+11 downto i*12));
						
						if data_temp >= mean then
							sum := sum + (data_temp - mean)**2;
						else
							sum := sum + (mean - data_temp)**2;
						end if;
					end loop;
			
					-- divide by N-1
					sum := sum / (use_samples-1);
					SDRR2_temp := to_unsigned(sum, 24);
				end if;
			end if;
			
			-- output SDRR2 and update prev_RR_time by current input
			SDRR2 <= std_logic_vector(SDRR2_temp);
			prev_RR_time := unsigned(RR_time);
		end if;
		
	end process;
	
end architecture; 