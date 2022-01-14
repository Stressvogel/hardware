library IEEE;
use IEEE.std_logic_1164.all;

-- Architecture combines the HRV Calculator and the MM Avalon slave
-- A buffer is implemented to hold the last calculated HRV value
entity HRV_Avalon is
	port(	heartbeat_data : in std_logic_vector(15 downto 0);

			csi_clock_clk : in std_logic;
			csi_reset_reset : in std_logic;
			
			hrv_clock : in    std_logic;
			
			-- control & status registers (CSR) slave
			avs_stress_level_address : in std_logic_vector (1 downto 0);
			avs_stress_level_readdata : out std_logic_vector (15 downto 0);
			avs_stress_level_write : in std_logic;
			avs_stress_level_writedata : in std_logic_vector (15 downto 0)
		 );
end entity; 