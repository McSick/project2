
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity MemControl is 
    port(

        --IMemory
        PC : in std_logic_vector(31 downto 0);
        Instruction : out std_logic_vector(31 downto 0);

               
        --DMemory
        Daddress : in std_logic_vector(31 downto 0);
        writeData : in std_logic_vector(31 downto 0);
        wren : in std_logic;
        rden : in std_logic;
        MemoryData : out std_logic_vector(31 downto 0);
        
        
        --to Ram
        address : out std_logic_vector(15 downto 0);
        data : out std_logic_vector(31 downto 0);
        wrenO : out std_logic;
        rdenO : out std_logic;
        q : in std_logic_vector(31 downto 0);
        memstate : in std_logic_vector(1 downto 0);
        
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

begin
  


Instruction <= q;
MemoryData <= q;
nextstatelogic : process(wren,rden,memstate)
begin
  stall <= '0';
  address <= PC(15 downto 0);
  data <= PC;
  wrenO <= '0';
  rdenO <= '0';
  
  
    case memstate is
    when MEMFREE => 
      if(wren = '1' or rden = '1') then
          address <= Daddress (15 downto 0);
          data <= writeData;
          wrenO <= wren;
          rdenO <= rden;
 
      
      end if; 
    when MEMBUSY =>
     
      if(wren = '1' or rden = '1') then
          address <= Daddress (15 downto 0);
          data <= writeData;
          wrenO <= wren;
          rdenO <= rden;
    

      end if; 
      stall <= '1';
  when MEMACCESS =>
      if(wren = '1' or rden = '1') then
          address <= Daddress (15 downto 0);
          data <= writeData;
          wrenO <= wren;
          rdenO <= rden;
       
 
      end if; 
    when MEMERROR =>
    when OTHERS =>

 
end case;


  
end process;

end behavioral;
  
        