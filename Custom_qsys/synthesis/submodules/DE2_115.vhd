library IEEE;
use IEEE.std_logic_1164.all;

entity DE2_115 is
	port(	heartbeat_data : in std_logic_vector(15 downto 0);
			LEDR_signal : out std_logic_vector(15 downto 0);
			LEDG_signal : out std_logic_vector(0 downto 0);
			HEX0_signal, HEX1_signal, HEX2_signal : out std_logic_vector (6 downto 0);

			-- clock interface
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

architecture structural of DE2_115 is
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
	
	signal hrv_output : std_logic_vector (11 downto 0);
	signal hrv_stable : std_logic_vector(11 downto 0);
begin
	avs_stress_level_readdata(15 downto 0) <= "0000" & hrv_stable;

	LEDR_signal <= heartbeat_data;

	hrvc1 : HRV_calculator port map (clk => hrv_clock, reset_n => '1', input => heartbeat_data, HRV => hrv_output);
	
	hrvb1 : HRV_buffer port map (clk => hrv_clock, reset_n => '1', HRV_in => hrv_output, HRV_out => hrv_stable);
	
	s7d1 : seg7dec port map (c => hrv_stable(3 downto 0), display => HEX0_signal);
	s7d2 : seg7dec port map (c => hrv_stable(7 downto 4), display => HEX1_signal);
	s7d3 : seg7dec port map (c => hrv_stable(11 downto 8), display => HEX2_signal);

end architecture;	