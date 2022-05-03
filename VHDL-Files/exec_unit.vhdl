----------------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------
entity exec_unit is ---input is decoded control signals, output is IRE and Flags
	port(
    --alu control-3
    alu_op,alu_b_s0,alu_b_s1,
	 --inv control-2
	 inv_en,inv_s                 --JUST INVERTER ENABLE IS ENOUGH
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
    --Memory comm-3
	 dout_en,mem_s,mem_wr_en,
	 --count register control-2                  --WHERE WERE THESE USED?????
	 count_rst,inc_sig,
	 --clock,reset global
	 clock,reset: in std_logic;
	 --ov is from Count reg, LS for Load Multiple and Store Multiple instructions
	 c,z,ov,LS: out std_logic; 
	 ire_inst: out std_logic_vector(15 downto 0)
	);
end entity;

architecture behave of exec_unit is
---------------------------------------------------
------------------COMPONENT-INSTANTIATION----------
component memory IS
generic
(
    mem_a_width	: integer := 16; --bytes of storage
    data_width	: integer := 16
);
port
(
    clock			: in  std_logic;
    din				: in  std_logic_vector(data_width - 1 DOWNTO 0);
    mem_a			: in  std_logic_vector(mem_a_width - 1 DOWNTO 0);
    wr_en				: in  std_logic;
    dout			: OUT std_logic_vector(data_width - 1 DOWNTO 0)
);
end component memory;


component ALU is
    port(
           alu_a   : in STD_LOGIC_VECTOR(15 downto 0);
           alu_b   : in STD_LOGIC_VECTOR(15 downto 0);
           op_code : in STD_LOGIC; --2 types fo alu instruction(ADD and NAND)
           alu_out : out STD_LOGIC_VECTOR(15 downto 0);
           z_out   : out STD_LOGIC;
           c_out   : out STD_LOGIC);
end component ALU;


component CCR is  
port
  (clock,reset,en : in std_logic;
     C_in,Z_in   	  : in std_logic;  
     C,Z  	      : out std_logic
);  
end component CCR;


component sign_extend_9_16 is
    port (ir_8_0 : in std_logic_vector(8 downto 0) ;
           dout	: out std_logic_vector(15 downto 0) 
              ) ;
end component sign_extend_9_16;


component sign_extend_6_16 is
    port (ir_5_0 : in std_logic_vector(5 downto 0) ;
           dout	: out std_logic_vector(15 downto 0) 
              ) ;
  end component sign_extend_6_16;

  
component shifter7 is
    port (ir_8_0 : in std_logic_vector(8 downto 0) ;
           dout	: out std_logic_vector(15 downto 0) 
              ) ;
end component shifter7 ;


component reg is  
  port(clock,reset,en : in std_logic;
       din   		 : in std_logic_vector(15 downto 0);  
       dout  	    : out std_logic_vector(15 downto 0)
      );  
end component reg;


component reg_file is
    port
    ( do1,do2       : out std_logic_vector(15 downto 0);----- Read outputs bus
      din          : in  std_logic_vector(15 downto 0);	----- Write Input bus
      write_en 	: in  std_logic;
      reset    	: in  std_logic;
      ao1,ao2,ain    : in  std_logic_vector(2 downto 0);			----- Addresses
      clk         : in  std_logic );
end component reg_file;


component mux_8to1_1b is
    Port ( 
        x:in STD_LOGIC_VECTOR (7 downto 0);
        sel:in STD_LOGIC_VECTOR (2 downto 0);
        y : out STD_LOGIC);
end component mux_8to1_1b ;


component mux_4to1_16b  is
    port(
    
        x0,x1,x2,x3:in STD_LOGIC_VECTOR (15 downto 0);
        sel:in STD_LOGIC_VECTOR (1 downto 0);
        y : out STD_LOGIC_VECTOR (15 downto 0)
        );
end component mux_4to1_16b ;


component mux_4to1_3b is
 port(
 
     x0,x1,x2,x3:in STD_LOGIC_VECTOR (2 downto 0);
     sel:in STD_LOGIC_VECTOR (1 downto 0);
     y : out STD_LOGIC_VECTOR (2 downto 0)
     );
end component mux_4to1_3b;


component mux_2to1_16b is
    port(
    
        x0,x1:in STD_LOGIC_vector(15 downto 0);
        sel:in STD_LOGIC;
        y : out STD_LOGIC_vector(15 downto 0)
     );
end component mux_2to1_16b ;


component mux_2to1_3b is
 port(
 
     x0,x1:in STD_LOGIC_vector(2 downto 0);
     sel:in STD_LOGIC;
     y : out STD_LOGIC_vector(2 downto 0)
  );
end component mux_2to1_3b;


component mux_8to1_16 is
	Port ( x0,x1,x2,x3,x4,x5,x6,x7:in STD_LOGIC_VECTOR (15 downto 0);
			sel:in STD_LOGIC_VECTOR (2 downto 0);
			y : out STD_LOGIC_VECTOR (15 downto 0)
			);
end component mux_8to1_16;


component inverter_16 is  
port(en : in std_logic;
     din   		 : in std_logic_vector(15 downto 0);  
     dout  	    : out std_logic_vector(15 downto 0)
    );  
end component inverter_16;

component Count_reg is
port (
		reset,clock: in std_logic;
		y:out std_logic_vector(2 downto 0)
		);
		
end component Count_reg;

---------------------------------------------------
------------------SIGNALS-INSTANTIATION------------
---------------------------------------------------
mem_store, mem_a_in, mem_load, alu_out, t1, alu_b, z_out, c_out, c, z, invRb, two, sign_ex6, sign_ex9, do1, do2, din, ao1, ao2, ain, count_out, shifted,
rg_sel, din_sel,
rA, rB, rC, r7, 
--WHAT EXACTLY ARE RA, RB, RC (are these addresses from ire_inst? which one is a,b,c?)
--WHERE ARE C AND Z FROM CCR GOING?
signal c_in,c_out_s,z_out_s, z_in : std_logic ;
signal rf_a3_inp, decode_in, rf_a1_inp: std_logic_vector(2 downto 0);
signal rf_d1_s,rf_d2_s, mem_d,decode_out, t1,t2,t3,alu_out_s,din_inp,t4_in,mem_a_in, xor_a_in, xor_b_in, 
xor_out,alu_b_final_in, t4,t5,t2_inp,t3_inp,pc_inp, pc_out, rf_d3_inp,se6_s, se9_s, alu_a_in,alu_b_in, tz7_out, ir_out :std_logic_vector(15 downto 0);
signal alu_a12, alu_b12,t4_co,t3_co, rfa3_co,rfd3_co, xor_b_co : std_logic_vector(1 downto 0);
---------------------------------------------------
---------------------------------------------------
begin
---Memory
store_reg: reg port map(clock, reset, dout_en, rA, mem_store);
memory_block: memory port map(clock, mem_store, mem_a_in, mem_wr_en, mem_load);
mem_demux: mux_2to1 port map(pc_out, t3, mem_a_co,mem_a_in); --[use my netlist, push]

---ALU and friends
t1_block: reg port map(clock,reset,t1_en, alu_out,t1);
ALunit: ALU port map(rA, alu_b, alu_op, alu_out, z_out, c_out);               --over here rA = value stored in reg A
flag_unit: CCR port map(clock, reset, C_en, Z_en, C_out, Z_out, c, z);
alu_b_sel(0)<= alu_b_s0;
alu_b_sel(1)<= alu_b_s1;
Balu_mux: mux_4to1_16 port map(invRb, two, sign_ex6, sign_ex9, alu_b_sel, alu_b); 

inv1: inverter_16 port map(inv_en, ("0000000000000010"), minus2);
inv2: inverter_16 port map(inv_en, rB, invR);
sign_ex6_16: sign_extend_6_16 port map(ire_inst(5 downto 0), sign_ex6);
sign_ex9_16: sign_extend_9_16 port map(ire_inst(8 downto 0), sign_ex9);

--IRE
ir: reg port map(clock, reset, ir_en, mem_load, ire_inst); --is mem_load right?

--Temp Reg
t2_block: reg port map(clock,reset,t2_en, --alu_out,t1); WHAT HERE (for LM, SM...?)

--Register File
----WHAT ARE RA, RB, RC. HOW WILL WE PICK R7?
RegisterFile: reg_file port map(do1, do2, din, RF_we, reset, ao1, ao2, ain, clock);
ao1_mux: mux_2to1_3b port map(r7, rA, ao1_s, ao1);                                     --here, rA = address of reg A...?
ao2_mux: mux_2to1_3b port map(rB, count_out, ao2_s, ao2); 
ain_mux: mux_2to1_3b port map(count_out, rg, LS_e, ain);
r7<="111"
rg_sel(0)<=ain_s0;
rg_sel(1)<=ain_s1;
rg_mux: mux_4to1_3b port map(rA, rB, rC, r7, rg_sel, rg);
din_sel(0)<=din_s0;
din_sel(1)<=din_s1;
din_mux: mux_4to1_16b port map(t1, shifted, do1, do2, din_sel, din);
count: count_reg port map(clock, reset, count_out)                       --doesn't this need ov? what's LS in output???
shft: shifter7 port map(ire_inst(8 downto 0), shifted);














---Temp_Registers and Flag Registers
t1_block: reg port map(clock,reset,t1_en, alu_out,t1);
t2_mux: mux_2to1 port map(rf_d2_s, mem_d,t2_co,t2_inp);
t2_block: reg port map(clock,reset,t2_en,t2_inp,t2);

--t3_mux: mux_2to1 port map(alu_out_s, mem_d,t3_co,t3_inp);
t3_co(0)<= t3_co2;
t3_co(1)<=t3_co1;
t3_mux: mux_4to1 port map(alu_out_s, mem_d,t1,t1,t3_co,t3_inp);

t3_block: reg port map(clock,reset,t3_en,t3_inp,t3);

t4_co(0)<= t4_co2;
t4_co(1)<=t4_co1;
t4_mux: mux_4to1 port map(rf_d1_s,xor_out,se9_s,se9_s,t4_co,t4_in);
t4_block: reg port map(clock,reset,t4_en,t4_in,t4);

t5_block: reg port map(clock,reset,t5_en,decode_out,t5);

--------------Signals for mux
alu_a12(0)<=alu_a1;
alu_a12(1)<=alu_a2;
alu_b12(0)<=alu_b1;
alu_b12(1)<=alu_b2;
-- ALU
alu_a_mux: mux_4to1 port map(se6_s,t1, pc_out, t3, alu_a12, alu_a_in );
alu_b_mux: mux_4to1 port map(se9_s, se6_s, t1, t2, alu_b12, alu_b_in );

--XOR Block
xor_b_co(0)<=xor_b_co1;
xor_b_co(1)<=xor_b_co2;
xorblock: xor_block port map(xor_a_in,xor_b_in,xor_out);
xor_a_mux: mux_2to1 port map(t1,t4,xor_a_co,xor_a_in);
xor_b_mux: mux_4to1 port map(t2,t5,("0000000000000000"),("0000000000000000"),xor_b_co,xor_b_in);
xor_out_final<=xor_out;

rfa3_co(0)<= rfa3_co2;
rfa3_co(1)<=rfa3_co1;

rfd3_co(0)<= rfd3_co2;
rfd3_co(1)<=rfd3_co1;

--Reg File
reg_1_mux: mux_4to1_3bit port map(ir_out(5 downto 3), ir_out(11 downto 9), decode_in,decode_in, rfa3_co, rf_a3_inp);
reg_2_mux: mux_4to1 port map(t3, tz7_out,t2,pc_out, rfd3_co, rf_d3_inp);

reg_file_block: Reg_file port map (rf_a1_inp,ir_out(8 downto 6),rf_a3_inp,rf_d1_s,rf_d2_s,rf_d3_inp,rf_wren, clock,reset);
reg_3_mux: mux_2to1_3bit port map(ir_out(11 downto 9), decode_in, rf_a1_co,rf_a1_inp);

---TZ7
Trail_block : TrailZeroes7 port map ( ir_out(8 downto 0), tz7_out) ;
ir_data<= ir_out  ;
z_out <= z_out_s ;
c_out <= c_out_s ;

--ALU block
al_b_mux: mux_2to1 port map(alu_b_in, ("0000000000000001"), bit_en, alu_b_final_in);
alu_unit: alu port map(alu_a_in, alu_b_final_in,alu_code, alu_out_s,z_in,c_in );

end behave;