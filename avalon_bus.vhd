library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity avalon_bus is
  port (
	-- clock interface
	csi_clock_clk : in std_logic;
	csi_reset_reset : in std_logic;
	
	-- control & status registers (CSR) slave
	avs_stress_level_address : in std_logic_vector (1 downto 0);
	avs_stress_level_readdata : out std_logic_vector (15 downto 0);
	avs_stress_level_write : in std_logic;
	avs_stress_level_writedata : in std_logic_vector (15 downto 0)
  );
end entity ; -- avalon_bus

architecture arch of avalon_bus is
	component HRV_calculator is
		port(clk, reset_n : in std_logic;
			input : in std_logic_vector(15 downto 0);
			HRV : out std_logic_vector(11 downto 0)
		);
	end component; 

	signal sensor_data : std_logic_vector(15 downto 0);
	signal fake_data: unsigned(15 downto 0);
begin

	u0 : component HRV_calculator
		port map (
				clk 	=> csi_clock_clk,
				reset_n => csi_reset_reset,
				HRV 	=> avs_stress_level_readdata(11 downto 0),
				input 	=> sensor_data
			);

	clock: process (csi_clock_clk, csi_reset_reset)
      begin
          if csi_reset_reset = '1' then
              sensor_data <= (others => '0');
          elsif rising_edge(csi_clock_clk) then
          	fake_data <= fake_data + 1;
          end if;
          sensor_data <= std_logic_vector(fake_data);
  end process;

end architecture ; -- arch
