library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_8to1_16 is
	Port ( x0,x1,x2,x3,x4,x5,x6,x7:in STD_LOGIC_VECTOR (15 downto 0);
			sel:in STD_LOGIC_VECTOR (2 downto 0);
			y : out STD_LOGIC_VECTOR (15 downto 0)
			);
end mux_8to1_16;

architecture Behavioral of mux_8to1_16 is
begin
	process (x0,x1,x2,x3,x4,x5,x6,x7,sel)
begin
	case sel is
	when "000"=>y<=x0;
	when "001"=>y<=x1;
	when "010"=>y<=x2;
	when "011"=>y<=x3;
	when "100"=>y<=x4;
	when "101"=>y<=x5;
	when "110"=>y<=x6;
	when "111"=>y<=x7;
	when others=> null;
	end case;
end process;
end Behavioral;