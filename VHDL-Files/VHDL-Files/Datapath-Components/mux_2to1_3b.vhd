library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity mux_2to1_3b is
 port(
 
     x0,x1:in STD_LOGIC_vector(2 downto 0);
     sel:in STD_LOGIC;
     y : out STD_LOGIC_vector(2 downto 0)
  );
end mux_2to1_3b;
 
architecture Behavioral of mux_2to1_3b is
--signal y :  STD_LOGIC_vector(2 downto 0) ;
begin
process (x0,x1,sel)
begin
case sel is
when '0'=>y<=x0;
when '1'=>y<=x1;

when others=> null;
end case;
end process;

--y_out <= y ;

end Behavioral;