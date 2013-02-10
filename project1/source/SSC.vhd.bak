library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity SSC is
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
    Jump : out std_logic;
    BNE : out std_logic;
    LUI : out std_logic
  
  );
end SSC;

architecture Behavioral of SSC is



begin
 
 
 OpSelect : process(opcode,funct)
 begin
   --1 when signed
    ExtType <= '0';
    
    --1 when write to Registerfile
    WriteEnable <= '0';
    --1 when using rd (r-type)
    RegDst <= '1';
    --1 when rd type
    AluSrc <= '0';
    --3 bit alu controler
    ALU_cntrl <= "000";
    --1 when writing to memory
    MemWrite <= '0';
    --0 when when memory is saved in register
    MemOut <= '1';
    --1 when branching
    Branch <= '0';
    --when when jumping
    Jump <= '0';
    --Branch when not equal
    BNE <= '0';
   --Load upper immediate
   LUI <= '0';

    
      case opcode is
        --Special Function
        when  "000000" =>
           case funct is
              --ADDU
              when "100001" =>
                ALU_cntrl <= "010";
                WriteEnable <= '1';
              --AND
              when "100100" =>
                ALU_cntrl <= "100";
                WriteEnable <= '1';
              --JR
              when  "001000" =>
              --NOR
              when  "100111" =>
                ALU_cntrl <= "101";
                WriteEnable <= '1';
              --OR
              when  "100101" =>
                ALU_cntrl <= "110";
                WriteEnable <= '1';
              --SLT 
              when  "101010" =>
    
              --SLTU 
              when  "101011" =>
              --SLL 
              when  "000000" =>
                ALU_cntrl <= "000";
                WriteEnable <= '1';
              --SRL
              when  "000010" =>
                ALU_cntrl <= "001";
                WriteEnable <= '1';
              --SUBU 
              when  "100011" =>
                ALU_cntrl <= "011";
                WriteEnable <= '1';
              --XOR
              when  "100110" =>
                ALU_cntrl <= "111";
                WriteEnable <= '1';
              
              when others =>
           end case;
      --I Type
      --ADDIU
      when  "001001" =>
        ALU_cntrl <= "010";
        RegDst <= '0';
        AluSrc <= '1';
        WriteEnable <= '1';
        
      --ANDI
      when  "001100" =>
        ALU_cntrl <= "100";
        RegDst <= '0';
        AluSrc <= '1';
        WriteEnable <= '1';
      --BEQ
      when  "000100" =>
        ALU_cntrl <= "011";
        Branch <= '1';
      --BNE
      when "000101" =>
        ALU_cntrl <= "011";
        BNE <= '1';
      --LUI
      when  "001111" =>
         LUI <= '1';
        WriteEnable <= '1';
        AluSrc <= '1';
        ExtType <= '1';
        ALU_cntrl <= "010";
          RegDst <= '0';
      --LW
      when  "100011" =>
        AluSrc <= '1';
        ExtType <= '1';
        ALU_cntrl <= "010";
        MemOut <= '0';
        WriteEnable <= '1';
        RegDst <= '0';
      
        
      --ORI
      When  "001101" =>
        ALU_cntrl <= "110";
        RegDst <= '0';
        AluSrc <= '1';
        WriteEnable <= '1';
      --SLTI  
      when  "001010" =>

      --SLTIU
      when "001011" =>
      --SW
      when  "101011" =>
        AluSrc <= '1';
        ExtType <= '1';
        ALU_cntrl <= "010";
        MemWrite <= '1';
        WriteEnable <= '0';
          RegDst <= '0';
      --XORI
      when "001110" =>
        ALU_cntrl <= "111";
        RegDst <= '0';
        AluSrc <= '1';
        WriteEnable <= '1';
      
      --JType
      --J
      when  "000010" =>
        Jump <= '1';
      --JAL
      when  "000011" =>
        Jump <= '1';
      when others =>
        
        
        
      end case;
    end process;

end Behavioral;    