library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- source: https://allaboutfpga.com/vhdl-code-for-clock-divider/
  
entity clock_divider is
	generic(	clock_in_hz : integer := 50000000;
				clock_out_hz : integer := 400);
	port (clk,reset_n: in std_logic;
			clock_out: out std_logic);
end clock_divider;
  
architecture behavioural of clock_divider is
  
	signal count: integer range 0 to (clock_in_hz + 2*clock_out_hz - 1) / (2*clock_out_hz) :=1;
	signal tmp : std_logic := '0';
  
begin
  
	process(clk,reset_n)
	begin
		if(reset_n='0') then
			count<=1;
			tmp<='0';
		elsif(clk'event and clk='1') then
			count <=count+1;
			if (count = (clock_in_hz + 2*clock_out_hz - 1) / (2*clock_out_hz)) then
				tmp <= NOT tmp;
				count <= 1;
			end if;
		end if;
		clock_out <= tmp;
	end process;
  
end behavioural;
