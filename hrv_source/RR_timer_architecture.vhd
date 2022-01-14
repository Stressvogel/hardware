--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity RR_timer is
--	port (clk, peak_detected, reset_n : in std_logic;
--			RR_time : out std_logic_vector(11 downto 0)
--			);
--end entity; 

-- counts every ms until peak is detected, then releases counter value
architecture behavioural of RR_timer is
	constant MIN_COUNTER : integer := 250;
	constant MAX_COUNTER : integer := 2000;
begin

	process (clk, reset_n)
		variable counter : unsigned(11 downto 0);						-- counter holds time since last peak
		variable RR_time_temp : std_logic_vector (11 downto 0);	-- holds RR time value for output
		variable prev_peak : std_logic := '0';							-- holds last input
	begin
		if reset_n = '0' then
			counter := (others => '0');
			prev_peak := '0';
		elsif rising_edge(clk) then
			RR_time_temp := (others => '0');

			-- if counter is not max, increase
			-- does not overflow so result can be discarded if counter is maxxed out
			if counter /= 2**(counter'LENGTH)-1 then
				counter := counter + 1;
			end if;
				
			-- if peak detected, check if counter holds realistic value between 30 BPM and 240 BPM
			if prev_peak = '0' and peak_detected = '1' then 
				if counter > MIN_COUNTER and counter < MAX_COUNTER then
						RR_time_temp := std_logic_vector(counter);
						counter := (others => '0');
				-- if counter is not realistic, only reset it
				elsif counter > MAX_COUNTER then
						counter := (others => '0');
				end if;
			end if;
			
			-- output time and update prev_peak with current input
			RR_time <= RR_time_temp;
			prev_peak := peak_detected;
		end if;	
	end process;
end architecture; 