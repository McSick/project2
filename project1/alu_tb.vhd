library ieee;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;
use ieee.std_logic_1164.all;


entity alu_tb is
end alu_tb;

architecture testbench_arch of alu_tb is
  component alu
   port ( opcode:         IN STD_LOGIC_VECTOR (2 downto 0);
         A, B:           IN STD_LOGIC_VECTOR (31 downto 0);
         aluout:         OUT STD_LOGIC_VECTOR (31 downto 0);
         negative:       OUT STD_LOGIC;
         overflow, zero: OUT STD_LOGIC);
  end component;

  signal A,B,aluout             : std_logic_vector (31 downto 0);
  signal opcode             : std_logic_vector (2 downto 0);

  signal negative,overflow,zero : OUT STD_LOGIC;

  constant zero : std_logic_vector := "00000000000000000000000000000000";
  constant v1   : std_logic_vector := "00000000000000000000000000000001";
  constant v2   : std_logic_vector := "00000000000000000001001001110001";
  constant v3   : std_logic_vector := "00000000000000000110001000011111";

  procedure println( output_string : in string ) is
    variable lout                  :    line;
  begin
    WRITE(lout, output_string);
    WRITELINE(OUTPUT, lout);
  end println;

  procedure printlv( output_bv : in std_logic_vector ) is
    variable lout              :    line;
  begin
    WRITE(lout, output_bv);
    WRITELINE(OUTPUT, lout);
  end printlv;


begin
  DUT : registerFile
    port map (
     A => A,
     B => B,
     aluout => aluout,
     negative => negative,
     overflow => overflow,
     zero => zero
      );


  process

  begin

    println("");
    println("Starting Test");