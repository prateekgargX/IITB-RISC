library ieee;
use ieee.std_logic_1164.all;

entity state_control is
port (
		reset,clk,c,z,ov,LS: in std_logic; 
	   ire_inst: in std_logic_vector(15 downto 0);
		y:out std_logic_vector(22 downto 0)
		);
		
end entity state_control ;

architecture behav of state_control is

signal state:std_logic_vector(23 downto 0);
--alu_op,alu_b_s0,alu_b_s1,alu_c(state machine or ir),
--inv_en1,inv_env2
--c_en,z_en,
--t1_en,
--t2_en,
--ir_en,
--RF_we,din_s0,din_s1,LS_e,ain_s0,ain_s1,ao1_s,ao2_s,
--dout_en,mem_s,mem_wr_en,
--count_rst,inc_sig
constant rst :std_logic_vector(23 downto 0):="000000000000000000000000"; --reset state
constant s_0 :std_logic_vector(23 downto 0):="000000000000000000000000"; --OP1
constant s_1 :std_logic_vector(23 downto 0):="000000000000000000000000"; --OP2
constant s_2 :std_logic_vector(23 downto 0):="000000000000000000000000"; --HKT1
constant s_3 :std_logic_vector(23 downto 0):="000000000000000000000000"; --HKT2
constant s_4 :std_logic_vector(23 downto 0):="000000000000000000000000"; --L1
constant s_5 :std_logic_vector(23 downto 0):="000000000000000000000000"; --L2
constant s_6 :std_logic_vector(23 downto 0):="000000000000000000000000"; --L3
constant s_7 :std_logic_vector(23 downto 0):="000000000000000000000000"; --SW1
constant s_8 :std_logic_vector(23 downto 0):="000000000000000000000000"; --SW2
constant s_9 :std_logic_vector(23 downto 0):="000000000000000000000000"; --B1
constant s_10:std_logic_vector(23 downto 0):="000000000000000000000000"; --B2
constant s_11:std_logic_vector(23 downto 0):="000000000000000000000000"; --B3
constant s_12:std_logic_vector(23 downto 0):="000000000000000000000000"; --B4
constant s_13:std_logic_vector(23 downto 0):="000000000000000000000000"; --B5
constant s_14:std_logic_vector(23 downto 0):="000000000000000000000000"; --J2
constant s_15:std_logic_vector(23 downto 0):="000000000000000000000000"; --J3
constant s_16:std_logic_vector(23 downto 0):="000000000000000000000000"; --J4
constant s_17:std_logic_vector(23 downto 0):="000000000000000000000000"; --LS1
constant s_18:std_logic_vector(23 downto 0):="000000000000000000000000"; --LS2
constant s_19:std_logic_vector(23 downto 0):="000000000000000000000000"; --LS3
constant s_20:std_logic_vector(23 downto 0):="000000000000000000000000"; --LS4
constant s_21:std_logic_vector(23 downto 0):="000000000000000000000000"; --LS5
constant s_22:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_23:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_24:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_25:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_26:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_27:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_28:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_29:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_30:std_logic_vector(23 downto 0):="000000000000000000000000";
constant s_31:std_logic_vector(23 downto 0):="000000000000000000000000";

begin 

cpu_process: process(clk,reset,ire_inst)

begin
if(reset='1')then 
	state<= rst; -- write the reset state
elsif(clk'event and clk='1')then                                                                                                                                                           

	case state is  
      
		when s_0=>
		state<=s_1;
		when s_1=>
		state<=s_2;
		when s_2=>
		state<=s_3;
		when s_3=>
		state<=s_
		when s_4=;> 
		state<=s_5;
		when s_5=>
		state<=s_6;
      when s_6=>
		state<=s_7;
		when s_7=>
		state<=s_0;
      when others=> 
      state<= rst;
      end case; 
end if;

end process cpu_process;
y<=state;
end behav;