library IEEE;
use IEEE.STD_LOGIC_1164.all;      
use ieee.numeric_std.all;
-- ALU 
-- INPUTS: alu_a, alu_b, op_code
-- OUTPUTS: C-out,Z_out,alu_out

entity ALU is
     port(
            alu_a   : in STD_LOGIC_VECTOR(15 downto 0);
			alu_b   : in STD_LOGIC_VECTOR(15 downto 0);
			op_code : in STD_LOGIC; --2 types fo alu instruction(ADD and NAND)
			alu_out : out STD_LOGIC_VECTOR(15 downto 0);
			z_out   : out STD_LOGIC;
			c_out   : out STD_LOGIC);
end ALU;

architecture behave of ALU is

signal c: STD_LOGIC_VECTOR(16 downto 0);
     
begin

alu_proc : process (alu_a,alu_b,op_code,c) is
    begin
        if (op_code='1') then --add
		  c <= std_logic_vector(resize(unsigned(alu_a),17) + resize(unsigned(alu_b),17));
		  c_out<=c(16);
		  z_out<= not( c(0) or c(1) or c(2) or c(3) or c(4) or c(5) or c(6) or c(7) or c(8) or c(9) or c(10) or c(11) or c(12) or c(13) or c(14) or c(15));
          --z_out<=std_logic(resize(unsigned(c),1));
		  else --NAnd
          c(16)<='0';
		  array_2: for j in 0 to 15 loop
		  c(j)<= ( alu_a(j) nand alu_b(j) );
		  end loop array_2;
		  z_out<= not( c(0) or c(1) or c(2) or c(3) or c(4) or c(5) or c(6) or c(7) or c(8) or c(9) or c(10) or c(11) or c(12) or c(13) or c(14) or c(15));
        end if;
    end process alu_proc;
	alu_out <= c(15 downto 0) ;    
end behave;
