library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity mux_2to1_1b is
 port(
 
     x0,x1:in STD_LOGIC;
     sel:in STD_LOGIC;
     y : out STD_LOGIC
  );
end mux_2to1_1b ;
 
architecture Behavioral of mux_2to1_1b  is

begin
process (x0,x1,sel)
begin
case sel is
when '0'=>y<=x0;
when '1'=>y<=x1;

when others=> null;
end case;
end process;

--y <= yout ;
end Behavioral;