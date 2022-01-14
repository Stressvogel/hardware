library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- VHDL driver for the MAX30102 sensor
ENTITY MAX30102_driver IS
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
END MAX30102_driver;