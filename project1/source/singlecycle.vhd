library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.STD_LOGIC;
entity singlecycle is 
  port(
    clk : in std_logic;
    nReset : in std_logic;
    halt : out std_logic);
  end singlecycle;
  
architecture behavioral of singlecycle is
  
   	component a32bitaddr 
  		port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	   end component;
	   
	   component alu is
     port ( opcode:         IN STD_LOGIC_VECTOR (2 downto 0);
         A, B:           IN STD_LOGIC_VECTOR (31 downto 0);
         aluout:         OUT STD_LOGIC_VECTOR (31 downto 0);
         negative:       OUT STD_LOGIC;
         overflow, zero: OUT STD_LOGIC);
    end component;
      
	   component RegisterFile
	   port
	   (
		-- Write data input port
		wdat		:	in	std_logic_vector (31 downto 0);
		-- Select which register to write
		wsel		:	in	std_logic_vector (4 downto 0);
		-- Write Enable for entire register file
		wen			:	in	std_logic;
		-- clock, positive edge triggered
		clk			:	in	std_logic;
		-- REMEMBER: nReset-> '0' = RESET, '1' = RUN
		nReset	:	in	std_logic;
		-- Select which register to read on rdat1 
		rsel1		:	in	std_logic_vector (4 downto 0);
		-- Select which register to read on rdat2
		rsel2		:	in	std_logic_vector (4 downto 0);
		-- read port 1
		rdat1		:	out	std_logic_vector (31 downto 0);
		-- read port 2
		rdat2		:	out	std_logic_vector (31 downto 0)
		);
		end component;
		
		component  Extender
		 port(
    Instruction : in std_logic_vector(15 downto 0);
    ExtType : in std_logic;
    Im32 : out std_logic_vector(31 downto 0));
end component;
  	    
 	component SSC is
  port(
    opcode : in std_logic_vector(5 downto 0);
    funct : in std_logic_vector(5 downto 0);
    ExtType : out std_logic;
    WriteEnable : out std_logic;
    RegDst : out std_logic;
    AluSrc : out std_logic;
    ALU_cntrl : out std_logic_vector(2 downto 0);
    MemWrite : out std_logic; 
    MemOut : out std_logic;
    Branch : out std_logic;
    Jump : out std_logic
  );
end component;

component ramd IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	
	component rami IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;

  signal PC,Instruction,MemoryData : std_logic_vector(31 downto 0);

--Internal Signal declarations
signal addressFake : std_logic_vector(15 downto 0);
signal wrenFake : std_logic;
signal ExtType : std_logic;
signal WriteEnable : std_logic;
signal RegDst : std_logic;
signal AluSrc : std_logic;
signal ALUcntr : std_logic_vector(2 downto 0);
signal MemWrite,MemOutMux : std_logic;
signal Branch : std_logic;
signal Jump,HaltI : std_logic;
Signal WriteDataReg : std_logic_vector(31 downto 0);
signal zero,overflow,over1,over2 : std_logic;
signal negative : std_logic;
signal BusA, BusB,Im32,Bsel, PCP4,PCJmp,JumpAddress,BranchAddress,AlmostPC,nextPC,ALUout,shifted: std_logic_vector(31 downto 0);
signal rs,rt,rd,rtd : std_logic_vector(4 downto 0);

begin
  
  
  rs <= Instruction(15 downto 11);
  rt <= Instruction(20 downto 16);
  rd <= Instruction(25 downto 21);
  
  --Mux Regdst
  with RegDst select
    rtd <= rs when '1', rt when '0',"00000" when others;
    
    
  ExBlock : Extender
  Port map(Instruction(15 downto 0),ExtType,Im32);
  
  
  --Mux AluSrc
  with AluSrc select
    BSel <= Im32 when '1', BusB when others;
    
   AluBlock : alu
   Port map(ALUcntr,BusA,Bsel,ALUout,negative, overflow,zero);
 

   
   
   with MemOutMux select
    WriteDataReg <= ALUout when '1', MemoryData when others;
    
    
    
  RegisterBlock : registerFile
  Port map(WriteDataReg,rtd,WriteEnable,clk,nReset,rd,rt,BusA,BusB);
  
  ControllerBlock : SSC
  Port map(Instruction(31 downto 26),Instruction(5 downto 0),ExtType,WriteEnable,RegDst,AluSrc,ALUcntr,MemWrite,MemOutMux,Branch,Jump);
 
branchand :  process(Instruction)
begin
  IF(Instruction = x"FFFFFFFF") then
  HaltI <= '1';
else
  HaltI <= '0';
end if;
end process;
  
 
 
 Halt <= HaltI;
 with HaltI select
    NextPC <= PC when '1', AlmostPC when others;
    
  
  ADDPC4 : a32bitaddr
  Port map(PC,x"00000004",PCP4,over1);
    
  shifted <=Im32(29 downto 0) & "00";
    
  ADDBR : a32bitaddr
  Port map(PCP4,shifted, PCJmp,over2);
    
  
  with (Branch AND zero) select
   BranchAddress <= PCJmp when '1', PCP4 when others;
   
   with Jump select
    AlmostPC <= PCP4(31 downto 28) & Instruction(25 downto 0) & "00" when '1', BranchAddress when others;
    
     registers : process (clk, nReset)
     begin
         if (nReset = '0') then
			-- Reset here
			 PC <= x"00000000";
			 elsif (rising_edge(clk)) then
			   PC <= nextPC;
			   end if;
       
     end process;
    
    --RAM D
  DataMemory : ramd
	PORT Map	( ALUout,clk,BusB,MemWrite,MemoryData);

  InstructionMemory : rami
  Port map (addressFake,clk,PC,wrenFake,Instruction);
   

  
end behavioral;