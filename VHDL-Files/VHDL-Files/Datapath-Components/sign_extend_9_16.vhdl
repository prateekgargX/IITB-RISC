library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity sign_extend_9_16 is
  port (ir_8_0 : in std_logic_vector(8 downto 0) ;
         dout	: out std_logic_vector(15 downto 0) 
			) ;
end entity sign_extend_9_16 ;

architecture Struct of sign_extend_9_16 is
begin 
  dout(8 downto 0) <= ir_8_0 ;
  dout(15 downto 9) <= (others =>ir_8_0(7));
 --   dout <= std_logic_vector(resize(unsigned(ir_5_0), dout'length));
end Struct;