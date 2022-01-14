
--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--
--entity moving_average_calculator is
--	generic(data_size : integer := 61);
--	port (clk : in std_logic;
--			reset_n : in std_logic;
--			data_in : in std_logic_vector(15 downto 0);
--			data_out : out std_logic_vector(15 downto 0)
--		   );
--end entity;

-- moving_average_calculator calculates the moving average of x of points based on data_size
architecture behavioural of moving_average_calculator is
	constant SENSOR_DATA_SIZE : integer := 16;				
begin
	process (clk, reset_n)
		variable data : std_logic_vector(SENSOR_DATA_SIZE*data_size-1 downto 0) := (others => '0');	-- holds data buffer
		variable sum : integer range 0 to (2**SENSOR_DATA_SIZE)*data_size-1;								-- used to calculate sum of datapoints 
	begin
		if reset_n = '0' then 
			data := (others => '0');
		elsif rising_edge(clk) then
			-- only execute when data_in is not zero
			if to_integer(unsigned(data_in)) /= 0 then
				-- put data_in in the data buffer at lowest index
				data := data(data'LEFT-SENSOR_DATA_SIZE downto 0) & data_in;
				sum := 0;
				
				-- if the buffer is filled with 61 datapoints, calculate the sum
				if to_integer(unsigned(data(data'LEFT downto data'LEFT-15))) /= 0 then
					for i in 0 to data_size-1 loop
						sum := sum + to_integer(unsigned(data(i*SENSOR_DATA_SIZE+15 downto i*SENSOR_DATA_SIZE)));
					end loop;
				end if;
				
				-- data out is the mean of the input
				data_out <= std_logic_vector(to_unsigned(sum / data_size, SENSOR_DATA_SIZE));
			end if;
		end if;
	end process;

end architecture;