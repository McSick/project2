library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity shifter is
    port( A : in std_logic_vector(31 downto 0);
          B : in std_logic_vector(4 downto 0);
          shiftout : out std_logic_vector(31 downto 0);
          mode : in std_logic); --1 is left 0 is right);
end shifter;

architecture combinational of shifter is
   signal m1o, m2o,m3o,m4o,m5o : std_logic_vector(31 downto 0);
    begin
      
      --mux1
      M1 : process(A,B(0), mode)
      begin
        if(mode = '1') then
          if(B(0) = '1') then
            m1o <=std_logic_vector( UNSIGNED( A) sll 1);
          else
            m1o <= A;
          end if;
        
      else
        if(B(0) = '1') then
            m1o <= std_logic_vector( UNSIGNED( A) srl 1);
          else
            m1o <= A;
          end if;
      end if;
    end process M1;
    --mux2
  M2 : process(m1o,B(1), mode)
      begin
        if(mode = '1') then
          if(B(1) = '1') then
            m2o <= std_logic_vector( UNSIGNED( m1o) sll 2 );
          else
            m2o <= m1o;
          end if;
        
      else
        if(B(1) = '1') then
            m2o <= std_logic_vector( UNSIGNED( m1o) srl 2);
          else
            m2o <= m1o;
          end if;
      end if;
    end process M2;
    --mux4
     M3: process(m2o,B(2), mode)
      begin
        if(mode = '1') then
          if(B(2) = '1') then
            m3o <= std_logic_vector( UNSIGNED( m2o) sll 4 );
          else
            m3o <= m2o;
          end if;
        
      else
        if(B(2) = '1') then
            m3o <= std_logic_vector( UNSIGNED( m2o) srl 4);
          else
            m3o <= m2o;
          end if;
      end if;
    end process M3;
    
      M4 : process(m3o,B(3), mode)
      begin
        if(mode = '1') then
          if(B(3) = '1') then
            m4o <= std_logic_vector( UNSIGNED( m3o) sll 8);
          else
            m4o <= m3o;
          end if;
        
      else
        if(B(3) = '1') then
            m4o <= std_logic_vector( UNSIGNED( m3o) srl 8);
          else
            m4o <= m3o;
          end if;
      end if;
    end process M4;
    --mux5
     M5: process(m4o,B(4), mode)
      begin
        if(mode = '1') then
          if(B(4) = '1') then
            shiftout <= std_logic_vector( UNSIGNED( m4o) sll 16) ;
          else
            shiftout <= m4o;
          end if;
        
      else
        if(B(4) = '1') then
            shiftout <= std_logic_vector( UNSIGNED( m4o) srl 16);
          else
            shiftout <= m4o;
          end if;
      end if;
    end process M5;
  end combinational;
    
    