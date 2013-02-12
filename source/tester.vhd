library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.STD_LOGIC;

entity tester is 
  port(
    clk : in std_logic;
    nReset : in std_logic;
    IDRT : in std_logic_vector(4 downto 0);
    IFRT : in std_logic_vector(4 downto 0);
    IFRS : in std_logic_vector(4 downto 0);
    REGOUT : out std_logic_vector(32 downto 0)
  );
end tester;


architecture structural of tester is
  
 	component a32bitaddr 
  	port( 
		     A : in std_logic_vector(31 downto 0);
	      	B : in std_logic_vector(31 downto 0);
	      	SUM : out std_logic_vector(31 downto 0);
	      	V : out std_logic);
	end component;
	
	
	component HazardDetector 
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
end component;
	
	
	signal PC,NextPC, IFREG,PC4,IF4,NextIFREG : std_logic_vector(31 downto 0);
	signal EXREG :std_logic_vector(32 downto 0);
	signal control,over,over1,hazard,PCSTALL,IFSTALL : std_logic;
	
  
  
begin
  
  
PCREGX : process(clk,nReset)
begin
  if(nReset = '0') then
    PC <= x"00000000";
elsif(rising_edge(clk)) then
  PC <= NextPC;
end if;
  
end process;
IFREGX : process(clk,nReset)
begin
  if(nReset = '0') then
    IFREG <= x"00000000";
elsif(rising_edge(clk)) then
  IFREG <= NextIFREG;
end if;
  
end process;

  
  
  
EXREGX : process(clk,nReset)
begin
  if(nReset = '0') then
    EXREG <= '0' & x"00000000";
elsif(rising_edge(clk)) then
  EXREG <= control & IFREG;
end if;

end process;
  
  
ADDPC: a32bitaddr
  Port map(PC,x"00000001", PC4,over);    
    
   
ADDIF: a32bitaddr
  Port map(IFREG,x"00000001", IF4,over1);
  
  
  
WITH PCSTALL select
  NextPC <= PC when '1', PC4 when others;
  
WITH IFSTALL select
  NextIFREG <= IFREG when '1', IF4 when others; 
  

  WITH hazard select
    control <= '1' when '0', '0' when others;
    
    
  HazardDET : HazardDetector
  Port Map(nReset,clk,EXREG(0),IDRT,IFRS,IFRT,PCSTALL,IFSTALL,hazard);
  
  REGOUT <= EXREG;
end structural;

