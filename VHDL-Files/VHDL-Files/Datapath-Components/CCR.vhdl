LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity CCR is  
  port
    (clock,reset,C_en, Z_en : in std_logic;
       C_in,Z_in   	  : in std_logic;  
       C,Z  	      : out std_logic
);  
end CCR;

architecture struct of CCR is  
  begin  
	
    process (clock,reset,C_en, Z_en )  
      begin  
		  if(reset = '1') then
			C <= '0';
            Z <= '0';
      elsif ((rising_edge(clock)) and (C_en = '1')) then  
            C <= C_in;
            if(Z_en='1') then
            Z <= Z_in;   
            end if; 
      end if;  
    end process;  
end struct;                      