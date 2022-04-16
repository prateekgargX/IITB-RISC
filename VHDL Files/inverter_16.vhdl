LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity instr_reg is  
  port(en : in std_logic;
       din   		 : in std_logic_vector(15 downto 0);  
       dout  	    : out std_logic_vector(15 downto 0)
      );  
end instr_reg;

architecture struct of instr_reg is  
  begin    
		if( en = '1') then
			dout <= not(din);
        else  
          dout <= din;  
        end if;    
end struct;
