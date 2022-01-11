--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--
--entity synchronizer is
--	port (clk, reset_n : in std_logic;
--			sig_1i, sig_2i : in std_logic_vector(15 downto 0);
--			sig_1o, sig_2o : out std_logic_vector(15 downto 0)
--		   );
--end entity;

-- synchronizer is used to synchronize both moving_average_calculator outputs
architecture behavioural of synchronizer is
begin
	process(clk, reset_n)
		variable next_index : integer range 0 to 1602;						-- pointer to next empty of sig_1_buffer
		variable sig_1_buffer : std_logic_vector(16*1602-1 downto 0);	-- buffer to hold datapoints from first signal
		variable counter : integer range 0 to 370;							-- counter to discard first datapoints
	begin
		if reset_n = '0' then
			next_index := 0;
			counter := 0;
			sig_1_buffer := (others => '0');
		elsif rising_edge(clk) then
			-- only execute when first 370 data points are discarded 
			if unsigned(sig_1i) /= 0 and counter >= 370 then
				-- put datapoint at the next free place in the buffer
				sig_1_buffer(next_index*16+15 downto next_index*16) := sig_1i;
				-- update next_index, in case of overflow newest datapoint overwrites most significant position
				if next_index < 1602 then
					next_index := next_index + 1;
				end if;
			else 
				counter := counter + 1;
			end if;
			
			-- if second signal is not null, release first datapoint from signal 
			if unsigned(sig_2i) /= 0 then
				sig_1o <= sig_1_buffer(15 downto 0);
				sig_2o <= sig_2i;
				-- remove datapoint from buffer and lower index
				sig_1_buffer := "0000000000000000" & sig_1_buffer(sig_1_buffer'LEFT downto 16);
				if next_index > 0 then
					next_index := next_index - 1;
				end if;
			end if;
		end if;
	end process;
end architecture; 