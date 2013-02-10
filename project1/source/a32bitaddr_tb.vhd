library ieee;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;
use ieee.std_logic_1164.all;

use ieee.std_logic_arith.all;


entity a32bitaddr_tb is
end a32bitaddr_tb;

architecture testbench_arch of a32bitaddr_tb is
	component a32bitaddr
		port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	end component;
	component a32bitsubr
		port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	end component;
	signal A,B,SUM,SUB : std_logic_vector(31 downto 0);
	signal V,Y : std_logic;
	
	
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
	
	DUT : a32bitaddr		port map(
			A => A,
			B => B,
			SUM => SUM,
			V => V);
			
	DUT2 : a32bitsubr port map(
			A => A,
			B => B,
			SUM => SUB,
			V => Y);

	process
	  
	begin
	   println("");
    println("Starting Test");
     A <= x"00000000";
  B <= x"00000000"; 
  
	wait for 10 ns;
	
	println("Vectors Change");
  A <= x"00000008";
  B <= x"00000001"; 
  wait for 10 ns; 
    A <= x"00000001";
  B <= x"00000008"; 
  wait for 10 ns;
    A <= x"10000008";
  B <= x"10000001"; 
  wait for 10 ns;
  
    A <= "01111111111111111111111111111111";
  B <= x"00000001"; 
  wait for 10 ns;


		end process;
		
end testbench_arch;