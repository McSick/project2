library ieee;
use ieee.std_logic_1164.all;
entity a32bitaddr is
	port( A : in std_logic_vector(31 downto 0);
	      B : in std_logic_vector(31 downto 0);
	      SUM : out std_logic_vector(31 downto 0);
	      V : out std_logic);
end a32bitaddr;
architecture COMBINATIONAL of a32bitaddr is
	component a1bitaddr is
	port(
		A : in std_logic;
		B : in std_logic;
		Cin : in std_logic;
		Cout: out std_logic;
		SUM : out std_logic);
	end component;
	signal couts : std_logic_vector(31 downto 0); --Couts of each addr
	signal internal_sum : std_logic_vector(31 downto 0); -- internal sum register
	signal overflow : std_logic;
	
begin
	--init bit
	IB:
	a1bitaddr port map( A=> A(0),
			   B => B(0),
			   Cin => '0',
			   Cout => couts(0),
			   SUM => internal_sum(0)); 
	--bits 1-31
GENI:
	for i in 1 to 31 generate
			BI: a1bitaddr port map( A => A(i),
				   B => B(i),
				   Cin => couts(i-1),
				   Cout => couts(i),
				   SUM => internal_sum(i));
	
	end generate GENI;
	overflow <= couts(31) xor couts(30);
	V <=  overflow; --overflow
	SUM <= internal_sum; --signed sum

end COMBINATIONAl;
