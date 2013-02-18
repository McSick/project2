
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity MemControl is 
    port(
		nReset : in std_logic;
        --IMemory
        PC : in std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0);
        irden : in std_logic;
               
        --DMemory
        Daddress : in std_logic_vector(31 downto 0);
        writeData : in std_logic_vector(31 downto 0);
        wren : in std_logic;
        rden : in std_logic;
        MemoryData : out std_logic_vector(31 downto 0);
        
        
        --to Ram
        address : out std_logic_vector(15 downto 0);
        data : out std_logic_vector(31 downto 0);
        q : in std_logic_vector(31 downto 0);
        memstate : in std_logic_vector(1 downto 0);
        wrenO : out std_logic;
        rdenO : out std_logic;
        --Stall
        stall : out std_logic); 
end MemControl;

architecture behavioral of MemControl is
  --TYPE STATE_TYPE IS ( MEMFREE,MEMBUSY,MEMACCESS,MEMERROR);
  --Signal state,nextstate : STATE_TYPE;.
  
  constant MEMFREE        : std_logic_vector              := "00";
  constant MEMBUSY        : std_logic_vector              := "01";
  constant MEMACCESS      : std_logic_vector              := "10";
  constant MEMERROR       : std_logic_vector              := "11";
  signal lastMemData,lastInstruction,MemoryDataI,InstructionI : std_logic_vector(31 downto 0);


begin
     

MemoryData <= q;
Instruction <= q;
wrenO <= wren;
rdenO <= (irden or rden) and (not wren);
nextstatelogic : process(wren,rden,memstate,nReset)
begin
  stall <= '0';
  address <= PC(15 downto 0);
  data <= PC;

  
	if(nReset='1') then
    case memstate is
    when MEMFREE => 
      if(wren = '1' or rden ='1') then
          address <= Daddress (15 downto 0);
          data <= writeData;
 
      
      end if; 
    when MEMBUSY =>
     
      if(wren = '1' or rden = '1') then
          address <= Daddress (15 downto 0);
          data <= writeData;

    

      end if; 
      stall <= '1';
	when MEMACCESS =>
      if(wren = '1' or rden ='1') then
          address <= Daddress (15 downto 0);
          data <= writeData;

       
 
      end if; 
    when MEMERROR =>
      address <= x"0000";
      data <= x"00000000";
    when OTHERS =>
	

 
end case;

end if;
  
end process;

end behavioral;
  
        