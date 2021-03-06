--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity HRV_Avalon is
--	port(	heartbeat_data : in std_logic_vector(15 downto 0);
--
--			csi_clock_clk : in std_logic;
--			csi_reset_reset : in std_logic;
--			
--			hrv_clock : in    std_logic;
--			
--			-- control & status registers (CSR) slave
--			avs_stress_level_address : in std_logic_vector (1 downto 0);
--			avs_stress_level_readdata : out std_logic_vector (15 downto 0);
--			avs_stress_level_write : in std_logic;
--			avs_stress_level_writedata : in std_logic_vector (15 downto 0)
--		 );
--end entity; 

-- Architecture combines the HRV Calculator and the MM Avalon slave
-- A buffer is implemented to hold the last calculated HRV value
architecture structural of HRV_Avalon is
	component HRV_calculator is
		port(	clk, reset_n : in std_logic;
				input : in std_logic_vector(15 downto 0);
				HRV : out std_logic_vector(11 downto 0)
			);
	end component; 
	
	component HRV_buffer is
		port (clk, reset_n : in std_logic;
				HRV_in : in std_logic_vector(11 downto 0);
				HRV_out : out std_logic_vector(11 downto 0)
				);
	end component; 
	
	signal hrv_output : std_logic_vector (11 downto 0);
	signal hrv_stable : std_logic_vector(11 downto 0);
	
	signal reset_n : std_logic;

begin
	-- send stable HRV value to MM slave
	avs_stress_level_readdata(15 downto 0) <= "0000" & hrv_stable;

	reset_n <= not(csi_reset_reset);

	hrvc1 : HRV_calculator port map (clk => hrv_clock, reset_n => reset_n, input => heartbeat_data, HRV => hrv_output);
	
	hrvb1 : HRV_buffer port map (clk => hrv_clock, reset_n => reset_n, HRV_in => hrv_output, HRV_out => hrv_stable);
end architecture;	