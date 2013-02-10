library ieee;
use ieee.std_logic_1164.all;

entity mycputest is
	port ( 
			-- clock signal
			CLK							:		in	std_logic;
			-- reset for processor
			nReset					:		in	std_logic;
			-- halt for processor
			halt						:		out	std_logic;
            ramAddr : out std_logic_vector(15 downto 0);
            ramData : out std_logic_vector(31 downto 0);
            ramWen  : out std_logic;
            ramRen  : out std_logic;
            ramQ    : in  std_logic_vector(31 downto 0);
            ramState : in std_logic_vector(1 downto 0)
		);
end mycputest;


architecture structural of mycputest is
  
  component pipelinecontroller
    port(
    signal ExtType : out std_logic;
    signal EXC : out std_logic_vector(4 downto 0);
    signal MEMC : out std_logic_vector(4 downto 0);
    signal WBC : out std_logic_vector(2 downto 0);
  signal opcode :  in std_logic_vector(5 downto 0);
  signal  funct :  in std_logic_vector(5 downto 0)
  );
end component;
  
  component MemControl 
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
        q : in std_logic_vector(31 downto 0);
        memstate : in std_logic_vector(1 downto 0);
        
        --Stall
        stall : out std_logic);
      end component;
      
      component a32bitaddr 
  		port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	   end component;
	   
	    signal PC,nextPC,PCP4,Instruction,nInstruction,fInstruction,MemoryData,Daddress,writeData : std_logic_vector(31 downto 0);
	    signal over1,HaltI,ramRenI,ramRenf : std_logic;
      
      
      
     signal ExtType,stall :  std_logic;
    signal EXC :  std_logic_vector(4 downto 0);
    signal MEMC :  std_logic_vector(4 downto 0);
    signal WBC :  std_logic_vector(2 downto 0);
  
  
begin
  
  halt <= HaltI;
  
branchand :  process(Instruction)
begin
  IF(Instruction = x"FFFFFFFF") then
  HaltI <= '1';
else
  HaltI <= '0';
end if;
end process;
  
  
  
  with (HaltI or stall ) select
    nextPC <= PC when '1', PCP4 when others;
    
    
   ADDPC4 : a32bitaddr     
  Port map(PC,x"00000004",PCP4,over1);
    
    
     registers : process (CLK, nReset,HaltI)
     begin
         if (nReset = '0') then
			-- Reset here
			 PC <= x"00000000";
			 Instruction <= x"00000000";
			 elsif (rising_edge(CLK)) and  HaltI ='0'  then
			   PC <= nextPC;
			   Instruction <= fInstruction;
			   end if;
       
     end process;
     Daddress <= x"40004000";
     writeData <= x"00000000";
     with MEMC(2) select
        ramRenf <= '1' when '0', '0' when others;
      
      with HaltI select
        ramRen <= '0' when '1', ramRenf when others;
        
        
       with MEMC(2) and (not HaltI) select
      
        ramRenI <= '1' when '0', '0' when others;
        
        
      with HaltI select
      ramWen  <= MEMC(2) when '0', '0' when others;
      

     
     Arbitor : MemControl
     port map(PC,nInstruction,Daddress,writeData,MEMC(2),ramRenI,MemoryData,ramAddr,ramData,ramQ,ramState,stall);
       
      PCC : pipelinecontroller
      port map(ExtType,EXC,MEMC,WBC,Instruction(31 downto 26),Instruction(5 downto 0)); 
       
  with stall select
    fInstruction <= nInstruction when '0', Instruction when others;
    
    
   
   
  
     
end structural;