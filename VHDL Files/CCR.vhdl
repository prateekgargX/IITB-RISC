LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity CCR is  
  port
    (clock,reset,en : in std_logic;
       C_in,Z_in   	  : in std_logic;  
       C,Z  	      : out std_logic
);  
end CCR;

architecture struct of CCR is  
  begin  
	
    process (clock,reset,en)  
      begin  
		if(reset = '1') then
			C <= '0';
            Z <= '0';
      elsif ((rising_edge(clock)) and (en = '1')) then  
            C <= C_in;
            Z <= Z_in;  
      end if;  
    end process;  
end struct;                      