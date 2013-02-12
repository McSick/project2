
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ForwardUnit is
    port(
    MemRD : in std_logic_vector(4 downto 0);
    ExRD : in std_logic_vector(4 downto 0);
    MemWE : in std_logic;
    ExWE  : in std_logic;
    IdRT : in std_logic_vector(4 downto 0);
    IdRS : in std_logic_vector(4 downto 0);
    ForwardA : out std_logic_vector(1 downto 0);
    ForwardB : out std_logic_vector(1 downto 0)
  );
  
end ForwardUnit;

architecture behavioral of ForwardUnit is
  


begin
  

detectionA : process(MemRD,ExRD,MemWE,ExWE,IdRT,IdRS)
begin
  
  
--EX hazard
if(ExWE = '1' and (not (ExRD = "00000")) and (ExRD = IdRS)) then
  ForwardA <= "10

--MEM Hazard  
elsif(MemWE = '1' and ( not (MemRD = "00000")) and not (ExWE and (not (ExRD = "00000"))) and ( not (ExRD = IdRS) ) and (MemRD = IdRS)) then
    ForwardA <= "01";
else
  --No Hazard Detected
    ForwardA <= "00";
end if;
  
  
  
end process;


detectionB : process(MemRD,ExRD,MemWE,ExWE,IdRT,IdRS)
begin
  
  
--EX hazard
if(ExWE = '1' and (not (ExRD = "00000")) and (ExRD = IdRT)) then
  ForwardB <= "10

--MEM Hazard  
elsif(MemWE = '1' and ( not (MemRD = "00000")) and not (ExWE and (not (ExRD = "00000"))) and ( not (ExRD = IdRT) ) and (MemRD = IdRT)) then
    ForwardB <= "01";
else
  --No Hazard Detected
    ForwardB <= "00";
end if;
  
  
  
end process;
end behavioral;