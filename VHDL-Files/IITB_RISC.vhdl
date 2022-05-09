----------------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------
entity IITB_RISC is 
	port( clock,reset: in std_logic);
end entity;
------------------------------
architecture struct of IITB_RISC is
signal c,z,ov,LS: std_logic; 
signal ire: std_logic_vector(15 downto 0);
signal fsm_v: std_logic_vector(25 downto 0);
		

component exec_unit is 
	port( --alu control-4
    fsm_op,alu_a_s,alu_b_s0,alu_b_s1, alu_c,
	 --inv control-2
	 inv_en,inv_s,                 
	 --ccr control-2
	 c_en,z_en,
    --t1 control-1
    t1_en,
	 --t2 control-1
	 t2_en,
	 --ir control-1
	 ir_en,
    --RF control-8
    RF_we,din_s0,din_s1,LS_e,ain_s0,ain_s1,ao1_s,ao2_s,
    --Memory comm-4
	 dout_en,mem_s,mem_wr_en, mem_a_sel,
	 --count register control-2                  
	 count_rst,inc_sig,
	 --clock,reset global
	 clock,reset: in std_logic;
	 --ov is from Count reg, LS for Load Multiple and Store Multiple instructions
	 c,z,ov,LS: out std_logic; 
	 ire_instr: out std_logic_vector(15 downto 0)
	);
end component exec_unit;

component state_control is port (
      reset,clk,c,z,ov,LS: in std_logic; 
	   ire_inst: in std_logic_vector(15 downto 0);
		y:out std_logic_vector(25 downto 0)
		);
end component state_control;

begin
Datapath : exec_unit port map(fsm_v(0), fsm_v(1), fsm_v(2), fsm_v(3), fsm_v(4), 
										fsm_v(5), fsm_v(6), fsm_v(7), fsm_v(8), fsm_v(0), 
										fsm_v(10), fsm_v(11), fsm_v(12), fsm_v(13), fsm_v(14), 
										fsm_v(15), fsm_v(16), fsm_v(17), fsm_v(18), fsm_v(19), 
										fsm_v(20), fsm_v(21), fsm_v(22), fsm_v(23), fsm_v(24), 
										fsm_v(25), clock, reset, c, z, ov, LS, ire) ;

FSM_control: state_control port map (reset,clock, c, z, ov, LS, ire, fsm_v);


end struct;
