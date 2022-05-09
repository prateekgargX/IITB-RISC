library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity sign_extend_6_16 is
  port (ir_5_0 : in std_logic_vector(5 downto 0) ;
         dout	: out std_logic_vector(15 downto 0) 
			) ;
end entity sign_extend_6_16 ;

architecture Struct of sign_extend_6_16 is
begin 
  dout(5 downto 0) <= ir_5_0 ;
  dout(15 downto 6) <= (others =>ir_5_0(5));
 --   dout <= std_logic_vector(resize(unsigned(ir_5_0), dout'length));
end Struct;