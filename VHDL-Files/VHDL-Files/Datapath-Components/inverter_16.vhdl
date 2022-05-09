LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity inverter_16 is  
  port(en : in std_logic;
       din   		 : in std_logic_vector(15 downto 0);  
       dout  	    : out std_logic_vector(15 downto 0)
      );  
end inverter_16;

architecture struct of inverter_16 is  
  begin
		dout(0) <= en xor din(0);
		dout(1) <= en xor din(1);
		dout(2) <= en xor din(2);
		dout(3) <= en xor din(3);
		dout(4) <= en xor din(4);
		dout(5) <= en xor din(5);
		dout(6) <= en xor din(6);
		dout(7) <= en xor din(7);
		dout(8) <= en xor din(8);
		dout(9) <= en xor din(9);
		dout(10) <= en xor din(10);
		dout(11) <= en xor din(11);
		dout(12) <= en xor din(12);
		dout(13) <= en xor din(13);
		dout(14) <= en xor din(14);
		dout(15) <= en xor din(15);
end struct;
