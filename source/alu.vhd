library ieee;
use ieee.std_logic_1164.all;
entity alu is
  port ( opcode:         IN STD_LOGIC_VECTOR (2 downto 0);
         A, B:           IN STD_LOGIC_VECTOR (31 downto 0);
         aluout:         OUT STD_LOGIC_VECTOR (31 downto 0);
         negative:       OUT STD_LOGIC;
         overflow, zero: OUT STD_LOGIC);
end alu;

architecture structural of alu is
  
  component a32bitaddr is
    	port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	      end component;
	component a32bitsubr is
	  	port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
	 end component;
	 component shifter is
	    port( A : in std_logic_vector(31 downto 0);
          B : in std_logic_vector(4 downto 0);
          shiftout : out std_logic_vector(31 downto 0);
          mode : in std_logic);
	   
	   end component;
	 
	 signal internal_sum,internal_sub,shiftoutL,shiftoutR : std_logic_vector(31 downto 0);
	 signal add_overflow,sub_overflow : std_logic;
	 
	 begin

	   
	   Addr: a32bitaddr port map(
	                     A => A,
	                     B => B,
	                     SUM => internal_sum,
	                     V => add_overflow);
	  	Subr: a32bitsubr port map(
	                     A => A,
	                     B => B,
	                     SUM => internal_sub,
	                     V => sub_overflow);
	    ShifterL : shifter port map( A => A,
          B => B(10 downto 6),
          shiftout => shiftoutL,
          mode => '1');
 	    ShifterR:  shifter port map( A => A,
          B => B(10 downto 6),
          shiftout => shiftoutR,
          mode => '0');
	                     
	   mux : process(A,B,opcode,internal_sum,internal_sub,add_overflow,sub_overflow,shiftoutL,shiftoutR)
	   begin
	     overflow <= '0';

	     zero <= '0';
	     negative <= '0';
	     --select output from corresponding compoenent base on opcode
	     --if output is ever zero, change zero flag.
	  
	     case opcode is
	         when "000" =>
	           aluout <= shiftoutL;
	           if(shiftoutL = x"00000000") then
	             zero <= '1';
	            end if;
	         when "001" =>
	           aluout <= shiftoutR;
	           if(shiftoutR = x"00000000") then
	             zero <= '1';
	            end if;
	         when "010" =>
	           aluout <= internal_sum;
	           overflow <= add_overflow;
	           if(internal_sum = x"00000000") then
	               zero <= '1';
	           end if;
	           if(internal_sum(31) = '1') then
	             negative <= '1';
	           end if;
	         when "011" =>
	            aluout <= internal_sub;
	           overflow <= sub_overflow;
	           if(internal_sub = x"00000000") then
	               zero <= '1';
	           end if;
	           if(internal_sub(31) = '1') then
	             negative <= '1';
	           end if;
	         when "100" =>
	           aluout <= A and B;
	           if((A and B) = x"00000000") then
	             zero <= '1';
	           end if;
	         when "101" =>
	           aluout <= A nor B;
	           if((A nor B) = x"00000000") then
	             zero <= '1';
	           end if;
	         when "110" =>
	           aluout <= A or B;
	           if((A or B) = x"00000000") then
	             zero <= '1';
	           end if;
	         when "111" =>
	           aluout <= A xor B;
	           if((A xor B) = x"00000000") then
	             zero <= '1';
	           end if;
	         when others =>
	           	     aluout <= x"00000000";
	           	     zero <= '1';
	     

end case;
	 
	     
	   end process mux;
	 end structural;
  