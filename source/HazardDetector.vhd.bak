library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity HazardDetector is
  port(
  nReset : in std_logic;
  clk : in std_logic;
  IdRE : in std_logic;
  IdRt : in std_logic_vector(4 downto 0);
  IfRs : in std_logic_vector(4 downto 0);
  IfRt : in std_logic_vector(4 downto 0);
  PCSTALL : out std_logic;
  IFSTALL : out std_logic;
  Hazard : out std_logic);
end HazardDetector;

architecture behavioral of HazardDetector is
  --Stalling2 is just added since no forwarding is implemented just yet.
  TYPE STATE_TYPE IS (waiting ,stalling,stalling2);
  Signal state,nextstate : STATE_TYPE;
begin
    
    


twocycle : process(clk,nReset)
begin
  if(nReset = '0') then
    state <= waiting;
elsif(rising_edge(CLK)) then
  state <= nextstate;
end if;
end process;

detect : process(state,IdRE,IdRt,IfRs,IfRt)
begin
  Hazard <= '0';
  case state is
  when waiting =>
     IF(IdRE ='1' and ((IdRt = IfRs) or (IdRt = IfRt))) then
    nextstate <= stalling;
    PCStall <= '1';
    IFSTALL <= '1';
    Hazard <= '1';
  else
    PCStall <= '0';
    IFSTALL <= '0';
    nextstate <= waiting;
  end if;
   when stalling =>
   nextstate <= stalling2;
   PCStall <= '1';
   IFSTALL <= '1';
   Hazard <= '1';
   when stalling2  =>
   nextstate <= waiting;
   PCStall <= '0';
   IFSTALL <= '0';
   Hazard <= '0';
   end case;
 
end process;
    
end behavioral;
  