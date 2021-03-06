--library IEEE;
--use IEEE.std_logic_1164.all;
--
--ENTITY MAX30102_driver IS
--  PORT(
--    clk       : IN     STD_LOGIC;                    		--system clock
--    reset_n   : IN     STD_LOGIC;                    		--active low reset
--    ena       : OUT     STD_LOGIC;                    	--latch in command
--    addr      : OUT     STD_LOGIC_VECTOR(6 DOWNTO 0); 	--address of target slave
--    rw        : OUT     STD_LOGIC;                    	--'0' is write, '1' is read
--    data_wr   : OUT     STD_LOGIC_VECTOR(7 DOWNTO 0); 	--data to write to slave
--    busy      : IN    STD_LOGIC;                    		--indicates transaction in progress
--    data_rd   : IN    STD_LOGIC_VECTOR(7 DOWNTO 0); 		--data read from slave
--		data_sample : out std_logic_vector(15 downto 0);
--END i2c_master;

-- VHDL driver for the MAX30102 sensor
architecture rtl of MAX30102_driver is

	-- Build an enumerated type for the state machine
	type state_type is (set_registers, polling, get_data);

	-- holds all tasks for setting registers
	type set_registers_tasks is (	send_reset_reg,
											send_reset_data,
											disable_after_reset,
											send_fifo_reg, 			
											send_fifo_data, 
											send_mode_data, 
											send_spo_data,
											disable,
											send_led_pulse_reg,
											send_led_pulse_data1,
											send_led_pulse_data2,
											finished
										);

	type polling_tasks is (	send_wr_ptr_address,
									read_wr_ptr_data,
									disable,
									check_available
								 );
								 
	type get_data_tasks is (write_fifo_data_reg,
									send_read_request,
									wait_for_data,
									read_data,
									disable,
									output_data
									);
									
									
	
	-- Register to hold the current state
	signal state   : state_type;
	signal registers_set : std_logic;
	signal data_available : std_logic;
	
	constant SLAVE_ADDRESS : std_logic_vector(6 downto 0) := "1010111";
	constant MAX_RDWR_PTR : integer := 32;
	constant BYTES_PER_SAMPLE : integer := 3;

begin
	-- slave addr is always 1010111
	addr <= SLAVE_ADDRESS;

	-- Logic to advance to the next state
	process (clk, reset_n)
	begin
		if reset_n = '0' then
			state <= set_registers;
		elsif (rising_edge(clk)) then
			case state is
				when set_registers =>
					-- proceed to polling if registers are set, else stay in set_registers
					if registers_set = '1' then
						state <= polling;
					else
						state <= set_registers;
					end if;
				when polling=>
					-- proceed to get_data if data is available to be read
					if data_available = '1' then
						state <= get_data;
					else
						state <= polling;
					end if;
				when get_data=>
					-- return to polling is data is read
					if data_available = '0' then
						state <= polling;
					else
						state <= get_data;
					end if;
			end case;
		end if;
	end process;

	process (clk, reset_n)

		variable polling_next : polling_tasks;	-- holds next to execute task for polling						
		variable rd_ptr, wr_ptr  : integer range 0 to MAX_RDWR_PTR;
		variable num_data_available : integer range 0 to MAX_RDWR_PTR*3;
		
		variable set_registers_next : set_registers_tasks;		-- holds next to execute task for set registers
		
		variable get_data_next : get_data_tasks;
		
		variable prev_busy : std_logic;								-- variable holds previous busy input value
		
		variable byte_position : integer range 0 to 2;
		
		variable output_temp : std_logic_vector(15 downto 0);
		
	begin
		if reset_n = '0' then
			set_registers_next := send_reset_reg;
			polling_next := send_wr_ptr_address;
			get_data_next := write_fifo_data_reg;
			rd_ptr := 0;
			wr_ptr := 0;
			num_data_available := 0;
			ena <= '0';
			data_wr <= "00000000";
			prev_busy := '1';
			registers_set <= '0';
			data_available <= '0';
			output_temp := (others => '0');
			data_sample <= (others => '0');
			
		elsif rising_edge(clk) then

			case state is
				when set_registers =>
					-- when not busy, start with sending reset register address 
					if busy = '0' and set_registers_next = send_reset_reg then
						rw <= '0';
						data_wr <= "00001001";
						ena <= '1';
						set_registers_next := send_reset_data;
						
					-- when not busy, start with sending register address 0x08
					elsif busy = '0' and set_registers_next = send_fifo_reg then
						rw <= '0';
						data_wr <= "00001000";
						ena <= '1';
						set_registers_next := send_fifo_data;
					
					-- when not busy after disable, send register address 0x0C
					elsif busy = '0' and set_registers_next = send_led_pulse_reg then
						rw <= '0';
						data_wr <= "00001100";
						ena <= '1';
						set_registers_next := send_led_pulse_data1;
			
					-- on rising edge set I2C control lines for next task
					elsif prev_busy = '0' and busy = '1' then
						case set_registers_next is	
							-- send data in order to reset MAX30102
							when send_reset_data =>
								data_wr <= "01000000";
								set_registers_next := disable_after_reset;
							
							-- set enable to '0' so new register address can be send
							when disable_after_reset =>
								ena <= '0';
								set_registers_next := send_fifo_reg;
								
							-- send data for fifo register
							when send_fifo_data =>
								data_wr <= "00010001";
								set_registers_next := send_mode_data;

							-- send data for mode register
							when send_mode_data =>
								data_wr <= "00000010";
								set_registers_next := send_spo_data;

							-- send data for spo register
							when send_spo_data =>
								data_wr <= "01101101";
								set_registers_next := disable;

							-- set enable = '0' so new register address can be send
							when disable =>
								ena <= '0';
								set_registers_next := send_led_pulse_reg;
								
							-- send data for led pulse register 1
							when send_led_pulse_data1 =>
								data_wr <= "10010110";
								set_registers_next := send_led_pulse_data2;
								
							-- send data for led pulse register 2
							when send_led_pulse_data2 =>
								data_wr <= "10010110";
								set_registers_next := finished;

							-- set enable = '0' and set registers_set = '1' so state proceeds to polling
							when finished =>
								registers_set <= '1';
								ena <= '0';
								set_registers_next := send_reset_reg;
								
							when others => null;
						end case;
					end if;
				when polling =>				
					-- send the register address of wr_ptr
					if busy = '0' and polling_next = send_wr_ptr_address then
						rw <= '0';
						data_wr <= "00000100";
						ena <= '1';
						polling_next := read_wr_ptr_data;
					
					-- read the value of wr_ptr
					elsif busy = '1' and prev_busy = '0' and polling_next = read_wr_ptr_data then
						rw <= '1';
						polling_next := disable;
						
					-- disable the I2C output
					elsif busy = '1' and prev_busy = '0' and polling_next = disable then
						ena <= '0';
						polling_next := check_available;
					
					-- read the incoming wr_ptr value
					elsif busy = '0' and prev_busy = '1' and polling_next = check_available then		
						wr_ptr := to_integer(unsigned(data_rd(4 downto 0)));
							
						-- calculate difference, + 32 for wrap around
						num_data_available := (wr_ptr + MAX_RDWR_PTR) - rd_ptr;
						
						if num_data_available >= MAX_RDWR_PTR then 
							num_data_available := num_data_available - MAX_RDWR_PTR;
						end if;
						
						-- if no data is available, stay 
						if num_data_available = 0 then
								data_available <= '0';
								polling_next := send_wr_ptr_address;
						else
						-- if data is available, make state get_data and the number of bytes = samples * 3
							data_available <= '1';
							num_data_available := num_data_available * BYTES_PER_SAMPLE;
							get_data_next := write_fifo_data_reg;
						end if;
					
					end if;
				when get_data =>				
					case get_data_next is
						-- send the fifo_data register address
						when write_fifo_data_reg => 
							if busy = '0' then
								rw <= '0';
								data_wr <= "00000111";
								ena <= '1';
								
								get_data_next := send_read_request;
							end if;
							
						-- send the read request for fifo_data
						when send_read_request =>
							if busy = '1' and prev_busy = '0' then
								rw <= '1';
								get_data_next := wait_for_data;
							end if;
							
						-- waits until the fifo data read request has been send
						when wait_for_data => 
							if busy = '1' and prev_busy = '0' then
								get_data_next := read_data;
							end if;
						
						-- reads data on falling edge and places it the corrisponding bits of the output
						when read_data =>
				
							if busy = '0' and prev_busy = '1' then
							
								byte_position := num_data_available mod BYTES_PER_SAMPLE;
								
								-- two most LSB of first byte of the sample are the two MSB bits of output
								-- second byte fills output bits 13 downto 6
								-- six MSB of third byte fill the 6 LSB of output
								if byte_position = 0 then
									output_temp(15 downto 14) := data_rd(1 downto 0);
								elsif byte_position = 2 then
									output_temp(13 downto 6) := data_rd;
								elsif byte_position = 1 then
									output_temp(5 downto 0) := data_rd(7 downto 2);
								end if;
								
								-- decrease number of bytes to be received
								num_data_available := num_data_available - 1;
								
								-- if the next byte will be the last, already disable I2C on rising edge
								if num_data_available = 1 then
									get_data_next := disable;
								-- if the byte_position is one, a full sample has been received. So output this sample. 
								elsif byte_position = 1 then
									get_data_next := output_data;
								else 
									get_data_next := read_data;
								end if;
								
							end if;
							
						-- disable I2C on rising edge
						when disable =>
							if busy = '1' and prev_busy = '0' then
								ena <= '0';
								get_data_next := read_data;
							end if;
							
						-- output the sample and if no more data available, start polling
						-- also update rd_ptr to new position
						when output_data =>
							data_sample <= output_temp;
							
							if num_data_available = 0 then
								rd_ptr := wr_ptr;
								polling_next := send_wr_ptr_address;
								data_available <= '0';
							else
								get_data_next := read_data;
							end if;
						when others => null;
					end case;
			end case;

			prev_busy := busy;
			
		end if;
	end process;
end rtl;
