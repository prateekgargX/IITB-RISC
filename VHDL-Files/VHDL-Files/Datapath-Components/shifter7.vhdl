library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity shifter7 is
  port (ir_8_0 : in std_logic_vector(8 downto 0) ;
         dout	: out std_logic_vector(15 downto 0) 
			) ;
end entity shifter7 ;

architecture Struct of shifter7 is
begin 
  dout(6 downto 0) <= (others =>'0') ;
  dout(15 downto 7) <= ir_8_0;
 --   dout <= std_logic_vector(resize(unsigned(ir_5_0), dout'length));
end Struct;