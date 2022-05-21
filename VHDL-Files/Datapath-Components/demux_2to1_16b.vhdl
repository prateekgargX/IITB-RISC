library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity demux_2to1_16b is
 port(
     x:in STD_LOGIC_vector(15 downto 0);
     sel:in STD_LOGIC;
     y0, y1 : out STD_LOGIC_vector(15 downto 0)
  );
end demux_2to1_16b ;
 
architecture Behavioral of demux_2to1_16b  is
--signal y :  STD_LOGIC_vector(15 downto 0) ;
begin
process (x,sel)
begin
case sel is
when '0'=>y0<=x; y1<=("0000000000000000");
when '1'=>y1<=x; y0<=("0000000000000000");

when others=> null;
end case;
end process;

--y <= yout ;
end Behavioral;