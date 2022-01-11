--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity HRV_calculator_test is
--	port (CLOCK_50 : in std_logic;
--			KEY	: in std_logic_vector(0 downto 0);
--			LEDG	: out std_logic_vector(11 downto 0)
--			);
--end entity; 

-- generates test signal and outputs to LEDS
architecture structural of HRV_calculator_test is
	component HRV_calculator is
		port(clk, reset_n : in std_logic;
			input : in std_logic_vector(15 downto 0);
			HRV : out std_logic_vector(11 downto 0)
			);
	end component; 
	
	component rom IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END component;
	
	component signal_generator is
		port (clock, reset_n : in std_logic;
				data_in : in std_logic_vector(15 downto 0);
				data_out : out std_logic_vector(15 downto 0);
				addr : out std_logic_vector(11 downto 0)
				);
	end component;
	
	component clock_divider is
		generic(	clock_in_hz : integer := 50000000;
				clock_out_hz : integer := 400);
		port (clk,reset_n: in std_logic;
				clock_out: out std_logic);
	end component;
	
	signal data_address : std_logic_vector(11 downto 0);
	signal data_from_rom : std_logic_vector(15 downto 0);
	signal HRV_sensordata : std_logic_vector(15 downto 0);
	signal clk_400hz : std_logic;
begin
	hrvc1 : HRV_calculator port map (clk => CLOCK_50, reset_n => KEY(0), input => HRV_sensordata, HRV => LEDG);
	rom1 : rom port map (clock => CLOCK_50, address => data_address, q => data_from_rom);
	sg1 : signal_generator port map (clock => clk_400hz, reset_n => KEY(0), data_in => data_from_rom, data_out => HRV_sensordata, addr => data_address);
	cd1 : clock_divider generic map(clock_out_hz => 400) port map (clk => CLOCK_50, reset_n => KEY(0), clock_out => clk_400hz);
end architecture; 