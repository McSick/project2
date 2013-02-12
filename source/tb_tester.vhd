-- $Id: $
-- File name:   tb_tester.vhd
-- Created:     2/12/2013
-- Author:      Michael Sickles
-- Lab Section: Wednesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_tester is
generic (Period : Time := 5 ns);
end tb_tester;

architecture TEST of tb_tester is

  function INT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
    variable RES : STD_LOGIC_VECTOR(NumBits-1 downto 0);
    variable tmp : INTEGER;
  begin
    tmp := X;
    for i in 0 to NumBits-1 loop
      if (tmp mod 2)=1 then
        res(i) := '1';
      else
        res(i) := '0';
      end if;
      tmp := tmp/2;
    end loop;
    return res;
  end;

  component tester
    PORT(
         clk : in std_logic;
         nReset : in std_logic;
         IDRT : in std_logic_vector(4 downto 0);
         IFRT : in std_logic_vector(4 downto 0);
         IFRS : in std_logic_vector(4 downto 0);
         REGOUT : out std_logic_vector(32 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal nReset : std_logic;
  signal IDRT : std_logic_vector(4 downto 0);
  signal IFRT : std_logic_vector(4 downto 0);
  signal IFRS : std_logic_vector(4 downto 0);
  signal REGOUT : std_logic_vector(32 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: tester port map(
                clk => clk,
                nReset => nReset,
                IDRT => IDRT,
                IFRT => IFRT,
                IFRS => IFRS,
                REGOUT => REGOUT
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    nReset <= '0';

    IDRT <= "00000";

    IFRT <= "00000";

    IFRS <= "00000";
    
    
    wait for 5 ns;
    
    nReset <= '1';
    
    wait for 20 ns;
    
    IDRT <= "00001";
    wait for 20 ns;
    
    

  end process;
end TEST;