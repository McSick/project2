library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity Extender is
  port(
    Instruction : in std_logic_vector(15 downto 0);
    ExtType : in std_logic;
    Im32 : out std_logic_vector(31 downto 0));
end Extender;

architecture behavioral of Extender is 
begin
  
  extend : process(Instruction , ExtType)
  begin
    IF( ExtType = '0') then
      Im32 <= "0000000000000000" & Instruction;
    ELSE
      IF(Instruction(15) = '1') then
        Im32 <= "1111111111111111" & Instruction;
      ELSE
        Im32 <= "0000000000000000" & Instruction;
      end if;
  end if;
end process;
  

  
  
end behavioral;