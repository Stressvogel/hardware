library IEEE;
use IEEE.std_logic_1164.all;


-- 7 segment decoder
-- input: binary number 0 to 9
-- output: 7 led segments
entity seg7dec is
  port ( C : in std_logic_vector(3 downto 0);
         display : out std_logic_vector(6 downto 0)
       );
end entity seg7dec;
