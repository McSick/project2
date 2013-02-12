-- $Id: $
-- File name:   tb_MemControl.vhd
-- Created:     2/10/2013
-- Author:      Michael Sickles
-- Lab Section: Wednesday 2:30-5:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_MemControl is
end tb_MemControl;

architecture TEST of tb_MemControl is

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

  component MemControl
    PORT(
         PC : in std_logic_vector(31 downto 0);
         Instruction : out std_logic_vector(31 downto 0);
         Daddress : in std_logic_vector(31 downto 0);
         writeData : in std_logic_vector(31 downto 0);
         wren : in std_logic;
         rden : in std_logic;
         MemoryData : out std_logic_vector(31 downto 0);
         address : out std_logic_vector(15 downto 0);
         data : out std_logic_vector(31 downto 0);
         wrenO : out std_logic;
         rdenO : out std_logic;
         q : in std_logic_vector(31 downto 0);
         memstate : in std_logic_vector(1 downto 0);
         stall : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal PC : std_logic_vector(31 downto 0);
  signal Instruction : std_logic_vector(31 downto 0);
  signal Daddress : std_logic_vector(31 downto 0);
  signal writeData : std_logic_vector(31 downto 0);
  signal wren : std_logic;
  signal rden : std_logic;
  signal MemoryData : std_logic_vector(31 downto 0);
  signal address : std_logic_vector(15 downto 0);
  signal data : std_logic_vector(31 downto 0);
  signal wrenO : std_logic;
  signal rdenO : std_logic;
  signal q : std_logic_vector(31 downto 0);
  signal memstate : std_logic_vector(1 downto 0);
  signal stall : std_logic;

-- signal <name> : <type>;

begin
  DUT: MemControl port map(
                PC => PC,
                Instruction => Instruction,
                Daddress => Daddress,
                writeData => writeData,
                wren => wren,
                rden => rden,
                MemoryData => MemoryData,
                address => address,
                data => data,
                wrenO => wrenO,
                rdenO => rdenO,
                q => q,
                memstate => memstate,
                stall => stall
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    PC <= x"00000000";

    Daddress <=  x"11111111";

    writeData <=  x"22222221";

    wren <= '0';
    rden <= '0';

    q <= x"33333333";

    memstate <= "00";
    
    wait for 20 ns;
    
    memstate <= "01";
    
    wait for 40 ns;
    
    memstate <= "10";
    
    wait for 40 ns;
    
    memstate <= "00";
    
    wait for 40 ns;
        PC <= x"00000004";

    Daddress <=  x"11111112";

    writeData <=  x"22222222";

    wren <= '0';
    rden <= '1';

    q <= x"44444444";

    memstate <= "00";
    
    wait for 20 ns;
    
    memstate <= "01";
    
    wait for 40 ns;
    
    memstate <= "10";
    
    wait for 40 ns;
    
    memstate <= "00";
    
    wait for 40 ns;
    PC <= x"00000008";

    Daddress <=  x"11111113";

    writeData <=  x"22222223";

    wren <= '1';
    rden <= '0';

    q <= x"33333333";

    memstate <= "00";
    
    wait for 20 ns;
    
    memstate <= "01";
    
    wait for 40 ns;
    
    memstate <= "10";
    
    wait for 40 ns;
    
    memstate <= "00";
    
    wait for 40 ns;
    PC <= x"0000000C";

    Daddress <=  x"11111114";

    writeData <=  x"22222224";

    wren <= '1';
    rden <= '1';

    q <= x"55555555";

    memstate <= "00";
    
    wait for 20 ns;
    
    memstate <= "01";
    
    wait for 40 ns;
    
    memstate <= "10";
    
    wait for 40 ns;
    
    memstate <= "00";
    
    wait for 40 ns;
  PC <= x"00000040";

    Daddress <=  x"11111115";

    writeData <=  x"22222225";

    wren <= '0';
    rden <= '0';

    q <= x"66666666";

    memstate <= "00";
    
    wait for 20 ns;
    
    memstate <= "01";
    
    wait for 40 ns;
    
    memstate <= "10";
    
    wait for 40 ns;
    
    memstate <= "00";
    
    wait for 40 ns;



  end process;
end TEST;