library IEEE;
use IEEE.std_logic_1164.all;

entity DE2_115 is
	port(	I2C_GPIO : inout std_logic_vector(1 downto 0);
			LEDR_signal : out std_logic_vector(15 downto 0);
			LEDG_signal : out std_logic_vector(0 downto 0);
			HEX0_signal, HEX1_signal, HEX2_signal : out std_logic_vector (6 downto 0);

			-- clock interface
			csi_clock_clk : in std_logic;
			csi_reset_reset : in std_logic;
			
			-- control & status registers (CSR) slave
			avs_stress_level_address : in std_logic_vector (1 downto 0);
			avs_stress_level_readdata : out std_logic_vector (15 downto 0);
			avs_stress_level_write : in std_logic;
			avs_stress_level_writedata : in std_logic_vector (15 downto 0)
		 );
end entity; 

architecture structural of DE2_115 is

	component i2c_master IS
	  GENERIC(
		 input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
		 bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
	  PORT(
		 clk       : IN     STD_LOGIC;                    --system clock
		 reset_n   : IN     STD_LOGIC;                    --active low reset
		 ena       : IN     STD_LOGIC;                    --latch in command
		 addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
		 rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
		 data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
		 busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
		 data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
		 ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowLEDG_signale from slave
		 sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
		 scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
	END component;
	
	component i2c_controller IS
	  PORT(
		 clk       : IN     STD_LOGIC;                    		--system clock
		 reset_n   : IN     STD_LOGIC;                    		--active low reset
		 ena       : OUT     STD_LOGIC;                    	--latch in command
		 addr      : OUT     STD_LOGIC_VECTOR(6 DOWNTO 0); 	--address of target slave
		 rw        : OUT     STD_LOGIC;                    	--'0' is write, '1' is read
		 data_wr   : OUT     STD_LOGIC_VECTOR(7 DOWNTO 0); 	--data to write to slave
		 busy      : IN    STD_LOGIC;                    		--indicates transaction in progress
		 data_rd   : IN    STD_LOGIC_VECTOR(7 DOWNTO 0); 		--data read from slave
		 data_sample : out std_logic_vector(15 downto 0)
		 );
	END component;

	
	component HRV_calculator is
		port(	clk, reset_n : in std_logic;
				input : in std_logic_vector(15 downto 0);
				HRV : out std_logic_vector(11 downto 0)
			);
	end component; 
	
	component seg7dec is
		port ( C : in std_logic_vector(3 downto 0);
				display : out std_logic_vector(6 downto 0)
				);
	end component;
	
	component HRV_buffer is
		port (clk, reset_n : in std_logic;
				HRV_in : in std_logic_vector(11 downto 0);
				HRV_out : out std_logic_vector(11 downto 0)
				);
	end component; 
	
	signal i2c_ena : std_logic;
	signal i2c_addr : std_logic_vector(6 downto 0);
	signal i2c_rw : std_logic;
	signal i2c_data_wr : std_logic_vector(7 downto 0);
	signal i2c_busy : std_logic;
	signal i2c_data_rd : std_logic_vector(7 downto 0);
	
	signal data_sample : std_logic_vector(15 downto 0);
	signal hrv_output : std_logic_vector (11 downto 0);
	signal hrv_stable : std_logic_vector(11 downto 0);
begin
	avs_stress_level_readdata(11 downto 0) <= hrv_stable;

	LEDR_signal <= data_sample;

	i2c : i2c_master port map (clk => csi_clock_clk, 
										reset_n => csi_reset_reset, 
										ena => i2c_ena, 
										addr => i2c_addr, 
										rw => i2c_rw, 
										data_wr => i2c_data_wr, 
										busy => i2c_busy, 
										data_rd => i2c_data_rd, 
										sda => I2C_GPIO(0), 
										scl => I2C_GPIO(1),
										ack_error => LEDG_signal(0)
										);
										
	controller : i2c_controller port map (	clk => csi_clock_clk,
														reset_n => csi_reset_reset,
														ena => i2c_ena, 
														addr => i2c_addr, 
														rw => i2c_rw, 
														data_wr => i2c_data_wr,
														busy => i2c_busy,
														data_rd => i2c_data_rd,
														data_sample => data_sample
														);
	hrvc1 : HRV_calculator port map (clk => csi_clock_clk, reset_n => csi_reset_reset, input => data_sample, HRV => hrv_output);
	
	hrvb1 : HRV_buffer port map (clk => csi_clock_clk, reset_n => csi_reset_reset, HRV_in => hrv_output, HRV_out => hrv_stable);
	
	s7d1 : seg7dec port map (c => hrv_stable(3 downto 0), display => HEX0_signal);
	s7d2 : seg7dec port map (c => hrv_stable(7 downto 4), display => HEX1_signal);
	s7d3 : seg7dec port map (c => hrv_stable(11 downto 8), display => HEX2_signal);

	
end architecture;	