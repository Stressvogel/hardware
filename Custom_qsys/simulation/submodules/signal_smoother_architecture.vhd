--library IEEE;
--use IEEE.std_logic_1164.all;
--
--entity signal_smoother is
--	port(	clk, reset_n : in std_logic;
--			input : in std_logic_vector(15 downto 0);
--			smoothed_input, baseline : out std_logic_vector(15 downto 0)
--			);
--end entity;

-- signal smoother implements two moving_average_calculators whose signals are synchronized by the synchronizer
architecture structural of signal_smoother is
	component moving_average_calculator is
		generic (data_size : integer := 61);
		port 	  (clk : in std_logic;
					reset_n : in std_logic;
					data_in : in std_logic_vector(15 downto 0);
					data_out : out std_logic_vector(15 downto 0)
					);
	end component;
	
	component synchronizer is
		port (clk, reset_n : in std_logic;
				sig_1i, sig_2i : in std_logic_vector(15 downto 0);
				sig_1o, sig_2o : out std_logic_vector(15 downto 0)
				);
	end component;
	
	-- output signals for both moving average calculators
	signal sig_mac1, sig_mac2 : std_logic_vector(15 downto 0);
	
begin
	mac1 : moving_average_calculator generic map (data_size => 61) 
												port map (clk => clk, reset_n => reset_n, data_in => input, data_out => sig_mac1);
	mac2 : moving_average_calculator generic map (data_size => 801)
												port map (clk => clk, reset_n => reset_n, data_in => input, data_out => sig_mac2);
	
	syn1 : synchronizer port map (clk => clk, reset_n => reset_n, sig_1i => sig_mac1, 
											sig_1o => smoothed_input, sig_2i => sig_mac2, sig_2o => baseline);

end architecture;