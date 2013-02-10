library ieee;
use ieee.std_logic_1164.all;

entity a1bitaddr is
	port(
		A : in std_logic;
		B : in std_logic;
		Cin : in std_logic;
		Cout: out std_logic;
		SUM : out std_logic);
end a1bitaddr;

architecture COMBINATIONAL of a1bitaddr is
begin 
	SUM <= A xor B xor Cin;
	Cout <= (A and B) or (A and Cin) or (B and Cin);
end COMBINATIONAL;
