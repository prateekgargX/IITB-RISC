library ieee;
use ieee.std_logic_1164.all;

entity state_control is
port (
		reset,clk,c,z,ov,LS: in std_logic; 
	   ire_inst: in std_logic_vector(15 downto 0);
		y:out std_logic_vector(25 downto 0)
		);
		
end entity state_control ;

architecture behav of state_control is

signal state:std_logic_vector(25 downto 0);
--fsm_op,alu_a_s,alu_b_s0,alu_b_s1,alu_c(state machine or ir),
--inv_en,inv_s
--c_en,z_en,
--t1_en,
--t2_en,
--ir_en,
--RF_we,din_s0,din_s1,LS_e,ain_s0,ain_s1,ao1_s,ao2_s,
--dout_en,mem_s,mem_wr_en,mem_a_sel,
--count_rst,inc_sig
constant rst :std_logic_vector(25 downto 0):="00000000000000000000000000"; --reset state

constant s0 :std_logic_vector(25 downto 0):="00000001100100000010000000"; --OP1
--Ra and Rb to ALU, opcode from ire
constant s1 :std_logic_vector(25 downto 0):="00000000010110001000000000"; --OP2
--t1 to Rc
constant s2 :std_logic_vector(25 downto 0):="10001011100000000000001100"; --HKT1
--r7 to ao, alu; +2 to alu; add opcode; edb to din
constant s3 :std_logic_vector(25 downto 0):="00000000010010001100000000"; --HKT2
--t1 to r7; din to ire
constant s4 :std_logic_vector(25 downto 0):="00000000000000000000000000"; --L0
--ire(8-16) to shift7 to ra
constant s5 :std_logic_vector(25 downto 0):="11101001110100000000000000"; --L1
--rb to alu; imm6 to sign6 to alu
constant s6 :std_logic_vector(25 downto 0):="00000000010011100000110000"; --L2
--t1 to ao; edb to din
constant s7 :std_logic_vector(25 downto 0):="00000000000000000100000000"; --L3
--din to ra
constant s8 :std_logic_vector(25 downto 0):="00000000000000100000000000"; --SW1
--rb to alu; imm6 to sign6 to alu; ra to dout
constant s9 :std_logic_vector(25 downto 0):="00000000000000000000000000"; --SW2
--t1 to ao; dout to edb
constant s10 :std_logic_vector(25 downto 0):="00000000000000000000000000"; --B1
--inv-rb ra to alu with add
constant s11:std_logic_vector(25 downto 0):="00000000000000000000000000"; --B2
--r7 to alu; -2 to alu
constant s12:std_logic_vector(25 downto 0):="00000000000000000000000000"; --B3
--t1 to alu, imm-ext-alu
constant s13:std_logic_vector(25 downto 0):="00000000000000000000000000"; --B4
--t1 to ao, r7; edb to din
constant s14:std_logic_vector(25 downto 0):="00000000000000000000000000"; --B5
--din to ire
constant s15:std_logic_vector(25 downto 0):="00000000000000000000000000"; --J1
--r7 to ra, alu; -2 to alu
constant s16:std_logic_vector(25 downto 0):="00000000000000000000000000"; --J2
--r7 to ra
constant s17:std_logic_vector(25 downto 0):="00000000000000000000000000"; --J3
--rb to ao, r7; edb to din
constant s18:std_logic_vector(25 downto 0):="00000000000000000000000000"; --J4
--ext to alu; ra to alu
constant s19:std_logic_vector(25 downto 0):="00000000000000000000000000"; --LS1
--ra to t2
constant s20:std_logic_vector(25 downto 0):="00000000000000000000000000"; --LS2
--t2 to ao; edb to din
constant s21:std_logic_vector(25 downto 0):="00000000000000000000000000"; --LS3
--din to rc; t2 to alu, +2 to alu
constant s22:std_logic_vector(25 downto 0):="00000000000000000000000000"; --LS4
--t1 to t2
constant s23:std_logic_vector(25 downto 0):="00000000000000000000000000"; --LS5
--count++


begin 

cpu_process: process(clk,reset,ire_inst)

begin
if(reset='1')then 
	state<= rst; -- write the reset state
elsif(clk'event and clk='1')then                                                                                                                                                           

	case state is  
      
		when s0=>
		state<=s1;
		when s1=>
		state<=s2;
		when s2=>
		state<=s3;
		when s3=>
		state<=s4;
		when s4=> 
		state<=s5;
		when s5=>
		state<=s6;
      when s6=>
		state<=s7;
		when s7=>
		state<=s8;
      when others=> 
      state<= rst;
      end case; 
end if;

end process cpu_process;
y<=state;
end behav;