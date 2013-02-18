library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.STD_LOGIC;
entity mycpu is
	port ( 			
		CLK	: in std_logic;			
		nReset	: in std_logic;			
		halt	: out std_logic;
        ramAddr : out std_logic_vector(15 downto 0);
        ramData : out std_logic_vector(31 downto 0);
        ramWen  : out std_logic;
        ramRen  : out std_logic;
        ramQ    : in  std_logic_vector(31 downto 0);
        ramState : in std_logic_vector(1 downto 0));	
	end mycpu;

architecture behavioral of mycpu is
  
   	component a32bitaddr 
  	port( 
		     A : in std_logic_vector(31 downto 0);
	      	B : in std_logic_vector(31 downto 0);
	      	SUM : out std_logic_vector(31 downto 0);
	      	V : out std_logic);
	end component;

	component alu is
     	port( 
		      opcode:         IN STD_LOGIC_VECTOR (2 downto 0);
	        A, B:           IN STD_LOGIC_VECTOR (31 downto 0);
	        aluout:         OUT STD_LOGIC_VECTOR (31 downto 0);
	        negative:       OUT STD_LOGIC;
	        overflow, zero: OUT STD_LOGIC);
	end component;
      
	component registerFile
	port(
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

	component  Extender is
	port(
    	Instruction : in std_logic_vector(15 downto 0);
	   	ExtType : in std_logic;
		Im32 : out std_logic_vector(31 downto 0));
	end component;

	component pipelinecontroller is
	port(
		nReset : std_logic;
		ExtType : out std_logic;
		EXC : out std_logic_vector(4 downto 0);
		MEMC : out std_logic_vector(4 downto 0);
		WBC : out std_logic_vector(2 downto 0);
		opcode :  in std_logic_vector(5 downto 0);
		funct :  in std_logic_vector(5 downto 0)
	);
	end component;

	component MemControl is 
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
	        stall : out std_logic
	);
	end component;

	component icache is 
	port(
		clk       : in  std_logic;
		nReset    : in  std_logic;
		iMemRead  : in  std_logic;                       -- CPU side
		iMemWait  : out std_logic;                       -- CPU side
		iMemAddr  : in  std_logic_vector (31 downto 0);  -- CPU side
		iMemData  : out std_logic_vector (31 downto 0);  -- CPU side
		aiMemWait : in  std_logic;                       -- arbitrator side
		aiMemRead : out std_logic;                       -- arbitrator side
		aiMemAddr : out std_logic_vector (31 downto 0);  -- arbitrator side
		aiMemData : in  std_logic_vector (31 downto 0)   -- arbitrator side
    	);
	end component;

	component dcache is
	port(
    		clk            : in  std_logic;
    		nReset         : in  std_logic;

    		dMemRead       : in  std_logic;                       -- CPU side
    		dMemWrite      : in  std_logic;                       -- CPU side
    		dMemWait       : out std_logic;                       -- CPU side
    		dMemAddr       : in  std_logic_vector (31 downto 0);  -- CPU side
    		dMemDataRead   : out std_logic_vector (31 downto 0);  -- CPU side
    		dMemDataWrite  : in  std_logic_vector (31 downto 0);  -- CPU side

    		adMemRead      : out std_logic;                       -- arbitrator side
    		adMemWrite     : out std_logic;                       -- arbitrator side
    		adMemWait      : in  std_logic;                       -- arbitrator side
    		adMemAddr      : out std_logic_vector (31 downto 0);  -- arbitrator side
    		adMemDataRead  : in  std_logic_vector (31 downto 0);  -- arbitrator side
    		adMemDataWrite : out std_logic_vector (31 downto 0)   -- arbitrator side
    	);
	end component;
	
	component HazardDetector is
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

component ForwardUnit is
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
  
end component;

signal PC,Instruction,dmemAddr: std_logic_vector(31 downto 0);

--Internal Signal declarations
signal VarLatRAMAddress : std_logic_vector(15 downto 0);
signal VarLatRAMData,dmemDataWrite,dmemDataRead,dmemAddrArb,dmemDataWriteArb,PCArb,InstructionArb,dmemDataReadArb,ramQarb : std_logic_vector (31 downto 0);
signal ExtType,iMemWait,aiMemWait,dMemWait,adMemWait,iRden,iRdenArb: std_logic;
signal RegWriteEnable,Rden,Wren,RdenArb,WrenArb,wrenArbO,rdenArbO : std_logic;
signal RegDst : std_logic;
signal AluSrc : std_logic;
signal ALUcntr : std_logic_vector(2 downto 0);
signal MemOutMux,lui : std_logic;
signal Branch : std_logic;
signal Jump,HaltI,BNE : std_logic;
Signal WriteDataReg : std_logic_vector(31 downto 0);
signal zero,overflow : std_logic;
signal negative : std_logic;
signal BusA, BusB,Im32,Bsel,PCP4,PCJmp,PCJmp_stg4,JumpAddress,BranchAddress,AlmostPC,nextPC,ALUout,shifted,WriteDataReg2: std_logic_vector(31 downto 0);
signal rs,rt,rtd : std_logic_vector(4 downto 0);
-- Stage 1
signal PCSTALL,IF_IDSTALL,Hazard : std_logic;
-- Stage 2
signal PCP4_stg2, Instruction_stg2 : std_logic_vector(31 downto 0);
signal EXC,MEMC,EXC_Hazard,MEMC_Hazard :std_logic_vector( 4 downto 0);
signal WBC,WBC_Hazard : std_logic_vector(2 downto 0);
-- Stage 3
signal BusA_stg3,BusB_stg3,BusA_stg3_00,BusB_stg3_00,PCP4_stg3, Instruction_stg3,Im32_stg3 : std_logic_vector(31 downto 0);
signal EXC_stg3,MEMC_stg3 :std_logic_vector( 4 downto 0);
signal WBC_stg3 : std_logic_vector(2 downto 0);

--Forwarding Unit

signal ForwardA,ForwardB : std_logic_vector(1 downto 0);

-- Stage 4
signal rtd_stg4 : std_logic_vector (4 downto 0);
signal Instruction_stg4,PCP4_stg4,ALUout_stg4,BusB_stg4,Forward_stg4 : std_logic_vector(31 downto 0);
signal zero_stg4 : std_logic;
signal MEMC_stg4 :std_logic_vector( 4 downto 0);
signal WBC_stg4 : std_logic_vector(2 downto 0);
-- Stage 5
signal rtd_stg5 : std_logic_vector(4 downto 0);
signal Instruction_stg5,MemoryData_stg5,ALUout_stg5 : std_logic_vector(31 downto 0);
signal Stall, Stall_S12,Stall_S23,Stall_S34,Stall_S45 : std_logic;
signal WBC_stg5 : std_logic_vector(2 downto 0);
signal nResetSynch_S12,nResetSynch_S23,nResetSynch_S34,nResetSynch_S45 : std_logic;

--TYPE STATE_TYPE IS (s0 ,s1);
--  Signal state,nextstate : STATE_TYPE;

begin



  FWDUNIT : ForwardUnit
  Port map(rtd_stg5,rtd_stg4,WBC_stg5(2),WBC_stg4(2),Instruction_stg3(20 downto 16),Instruction_stg3(25 downto 21),ForwardA,ForwardB);
    
  HDetector : HazardDetector
  Port map(nReset,clk,MEMC_stg3(1),Instruction_stg3(20 downto 16),rs,rt,PCSTALL,IF_IDSTALL,Hazard);
    
  AluBlock : alu
  Port map(ALUcntr,BusA_stg3,Bsel,ALUout,negative, overflow,zero); 

  RegisterBlock : registerFile
  Port map(WriteDataReg2,rtd_stg5,RegWriteEnable,clk,nReset,rs,rt,BusA,BusB);

  PipelineControllerBlock: pipelinecontroller
  Port map (nReset,ExtType,EXC_Hazard,MemC_Hazard,WBC_Hazard,Instruction_stg2(31 downto 26),Instruction_stg2(5 downto 0));
 
  ADDPC4 : a32bitaddr
  Port map(PC,x"00000004",PCP4);

  ADDBR : a32bitaddr
  Port map(PCP4_stg3,shifted, PCJmp);    
    
  ExBlock : Extender
  Port map(Instruction_stg2(15 downto 0),ExtType,Im32);
  
  DataCache: dcache
  Port map(CLK,nReset,Rden,Wren,dMemWait,dmemAddr,dmemDataRead,dmemDataWrite,RdenArb,WrenArb,adMemWait,dmemAddrArb,dmemDataReadArb,dmemDataWriteArb);
  
  InstructionCache: icache
  Port map(CLK,nReset,iRden,iMemWait,PC,Instruction,aiMemWait,iRdenArb,PCArb,InstructionArb);
  
  MemoryControllerBlock: MemControl 
  Port map(nReset,PCArb,InstructionArb,iRdenArb,dmemAddrArb,dmemDataWriteArb,WrenArb,RdenArb,dmemDataReadArb,VarLatRAMAddress,VarLatRAMData,ramQarb,ramState,wrenArbO,rdenArbO,Stall);
  
  --Mux Regdst
  with RegDst select
    rtd <= Instruction_stg3(15 downto 11) when '1', Instruction_stg3(20 downto 16) when '0',"00000" when others;
  
  --Mux AluSrc
  with AluSrc select
    BSel <= Im32_stg3 when '1', BusB_stg3 when others;    
   
  with MemOutMux select
    WriteDataReg <= ALUout_stg5 when '1', MemoryData_stg5 when others;
        
  with lui select
    WriteDataReg2 <= Instruction_stg5(15 downto 0) & x"0000" when  '1', WriteDataReg when others;
    
  with WBC_stg4(2) select
    Forward_stg4 <= Instruction_stg4(15 downto 0) & x"0000" when '1', ALUout_stg4 when others;

  --with (HaltI or memwait) select
  with (HaltI or Stall or PCSTALL or Rden or Wren) select
   NextPC <= PC when '1', AlmostPC when others;  
   
  with ((Branch AND zero_stg4) or (BNE AND (not zero_stg4))) select
   BranchAddress <= PCJmp_stg4 when '1', PCP4 when others;
   
  with Jump select
    AlmostPC <=  JumpAddress when '1', BranchAddress when others;
    

  --Hazard Muxes
  with Hazard select
    EXC <= "00000" when '1', EXC_Hazard when others;
  
  with Hazard select
    MEMC <="00000" when '1', MEMC_Hazard when others;
    
  with Hazard select
    WBC <= "000" when '1', WBC_Hazard when others;
    
    
 
  --Forwarding Muxes
    with ForwardA select
      BusA_stg3 <=  Forward_stg4 when "10",WriteDataReg2 when "01",BusA_stg3_00 when others;
    
   --Forwarding Muxes
    with ForwardB select
      BusB_stg3 <=  Forward_stg4 when "10",WriteDataReg2 when "01",BusB_stg3_00 when others;
	
  branchand :  process(Instruction_stg5)
	begin
	IF(Instruction_stg5 = x"FFFFFFFF") then
	  HaltI <= '1';
	else
	  HaltI <= '0';
	end if;
  end process;
    
     ProgramCounter : process (CLK, nReset,Stall)
     begin
         if (nReset = '0') then		 
		-- Reset here		
		PC <= x"00000000";
	 elsif ((rising_edge(CLK))and(Stall = '0')) then
		PC <= nextPC;
	end if;       
     end process;
     IFIDRegister: process(CLK,nReset,nResetSynch_S12,Stall_S12)		--Stage 1-2
	begin
	if (nReset = '0') then

		Instruction_stg2 <=  x"00000000";
		PCP4_stg2 <= x"00000000";
	elsif (rising_edge(CLK))and(Stall_S12 = '0') then
		if(nResetSynch_S12 = '0') then

			Instruction_stg2 <=  x"00000000";
			PCP4_stg2 <= x"00000000";
		else

			Instruction_stg2 <= Instruction;
			PCP4_stg2 <= PCP4;				
		end if;
	end if;
     end process;
     IDEXRegister: process(CLK,nReset,nResetSynch_S23,Stall_S23)		--Stage 2-3
	begin
	if (nReset = '0') then
		BusA_stg3_00 <= x"00000000";
	 	BusB_stg3_00 <= x"00000000";
		Im32_stg3 <= x"00000000";
		EXC_stg3 <= "00000";
		WBC_stg3 <= "000";				
		MEMC_stg3 <= "00000";		
		Instruction_stg3 <=  x"00000000";		
		PCP4_stg3 <=  x"00000000";
	elsif (rising_edge(CLK))and(Stall_S23 = '0') then
		if(nResetSynch_S23 = '0') then
			BusA_stg3_00 <= x"00000000";
		 	BusB_stg3_00 <= x"00000000";
			Im32_stg3 <= x"00000000";
			EXC_stg3 <= "00000";
			WBC_stg3 <= "000";				
			MEMC_stg3 <= "00000";		
			Instruction_stg3 <=  x"00000000";		
			PCP4_stg3 <=  x"00000000";
		else
			BusA_stg3_00 <= BusA;
		 	BusB_stg3_00 <= BusB;
			Im32_stg3 <= Im32;
			EXC_stg3 <= EXC;
			WBC_stg3 <= WBC;
			MEMC_stg3 <= MEMC;
			Instruction_stg3 <= Instruction_stg2;
			PCP4_stg3 <= PCP4_stg2;
		end if;
	end if;
     end process;
     EXMEMRegister: process(CLK,nReset,nResetSynch_S34,Stall_S34)		--Stage 3-4
	begin
	if (nReset = '0') then
		PCP4_stg4 <= x"00000000";
		zero_stg4 <= '0';	
		WBC_stg4 <= "000";
		Instruction_stg4 <=  x"00000000";
		MEMC_stg4 <= "00000";
		BusB_stg4 <= x"00000000";
		rtd_stg4 <= "00000";
		ALUout_stg4 <= x"00000000";
		PCJmp_stg4 <= x"00000000";
	elsif (rising_edge(CLK))and(Stall_S34 = '0') then
		if(nResetSynch_S34 = '0') then
			PCP4_stg4 <= x"00000000";
			zero_stg4 <= '0';
			WBC_stg4 <= "000";
			Instruction_stg4 <=  x"00000000";
			MEMC_stg4 <= "00000";
			BusB_stg4 <= x"00000000";
			rtd_stg4 <= "00000";
			ALUout_stg4 <= x"00000000";
			PCJmp_stg4 <= x"00000000";
		else
			PCP4_stg4 <= PCP4_stg3;
			zero_stg4 <= zero;
			WBC_stg4 <= WBC_stg3;
			Instruction_stg4 <= Instruction_stg3;
			MEMC_stg4 <= MEMC_stg3;
			BusB_stg4 <= BusB_stg3;
			rtd_stg4 <= rtd;
			ALUout_stg4 <= ALUout;
			PCJmp_stg4 <= PCJmp;
		end if;
	end if;
     end process;
     MEMWBRegister: process(CLK,nReset,nResetSynch_S45,Stall_S45)		--Stage 4-5
	begin
	if (nReset = '0') then	--asynch reset
		WBC_stg5 <= "000";
		MemoryData_stg5 <= x"00000000";
		ALUout_stg5 <= x"00000000";
		Instruction_stg5 <=  x"00000000";
		rtd_stg5 <= "00000";
	elsif (rising_edge(CLK))and(Stall_S45 = '0') then
		if(nResetSynch_S45 = '0') then	--synch reset	
			WBC_stg5 <= "000";
			MemoryData_stg5 <= x"00000000"; 
			ALUout_stg5 <= x"00000000";
			Instruction_stg5 <=  x"00000000";
			rtd_stg5 <= "00000";
		else	
		  	WBC_stg5 <= WBC_stg4;
			MemoryData_stg5 <= dmemDataRead;
			ALUout_stg5 <= ALUout_stg4;
			Instruction_stg5 <= Instruction_stg4;
			rtd_stg5 <= rtd_stg4;
		end if;
	end if;
     end process;
     
  Stall_S12<=Stall or HaltI or IF_IDSTALL;
  Stall_S23<=Stall or HaltI;
  Stall_S34<=Stall or HaltI;
  Stall_S45<=HaltI;
  nResetSynch_S12<='1';
  nResetSynch_S23<='1';
  nResetSynch_S34<='1';
  nResetSynch_S45<='1';
  ramAddr <= VarLatRAMAddress;
  ramData <= VarLatRAMData;    
  dmemDataWrite <= BusB_stg4;
  dmemAddr <= ALUout_stg4;
  JumpAddress <= PCP4_stg4(31 downto 28) & Instruction_stg4(25 downto 0) & "00";
  rt <= Instruction_stg2(20 downto 16);
  rs <= Instruction_stg2(25 downto 21);
  Halt <= HaltI;
  shifted <=Im32_stg3(29 downto 0) & "00";  
  ramQarb<=ramQ;
  --EXC
  RegDst <= EXC_stg3(4);
  AluSrc <= EXC_stg3(3);
  ALUcntr <=EXC_stg3(2 downto 0);
  --MEMC
  Branch <= MEMC_stg4(4);
  BNE <= MEMC_stg4(3);
  Wren <= MEMC_stg4(2);
  Rden <= MEMC_stg4(1);
  Jump <= MEMC_stg4(0);
  iRden <= '1'; -- not (Stall or Wren or Rden);
  ramWen <= wrenArbO;
  ramRen <= rdenArbO;
  --WBC
  RegWriteEnable <= WBC_stg5(2);
  MemOutMux <= WBC_stg5(1);
  lui <=WBC_stg5(0);
  
end behavioral;
