----------------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------
entity exec_unit is ---input is decoded control signals, output is IRE and Flags
	port(
    --alu control-4
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
  (clock,reset,C_en,Z_en : in std_logic;
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
		count_rst,inc_sig: in std_logic;
		y:out std_logic_vector(3 downto 0)
		);
		
end component Count_reg;

component demux_2to1_16b is 
port ( 
		x:in STD_LOGIC_vector(15 downto 0);
     sel:in STD_LOGIC;
     y0, y1 : out STD_LOGIC_vector(15 downto 0)
  );
 end component demux_2to1_16b;
 
component mux_2to1_1b is
port (x0,x1:in STD_LOGIC;
		sel:in STD_LOGIC;
		y : out STD_LOGIC
		);
end component mux_2to1_1b ;

---------------------------------------------------
------------------SIGNALS-INSTANTIATION------------
---------------------------------------------------
signal z_out, c_out, alu_op : std_logic;
signal rA, rB, rC, r7,rg, count_out, ao1, ao2, ain : std_logic_vector(2 downto 0);
signal mem_store, mem_a_in, mem_load, alu_out, t1, alu_a, alu_b, sign_ex6, sign_ex9,ire_in,ire_inst, do1, do2, din,t2_out, shifted,addr, inv_choice, inverted : std_logic_vector(15 downto 0);
signal rg_sel,alu_b_sel, din_sel : std_logic_vector(1 downto 0);
signal cnt_out :std_logic_vector(3 downto 0);
 

---------------------------------------------------
---------------------------------------------------
begin
---Memory
store_reg: reg port map(clock, reset, dout_en, addr, mem_store);
mem_a_mux: mux_2to1_16b port map(t2_out, do1, mem_a_sel, addr);
memory_block: memory port map(clock, mem_store, mem_a_in, mem_wr_en, mem_load);
mem_demux: demux_2to1_16b port map(mem_load, mem_s, ire_in, din); 

---ALU and friends
t1_block: reg port map(clock,reset,t1_en, alu_out,t1);
ALunit: ALU port map(alu_a, alu_b, alu_op, alu_out, z_out, c_out);
opmux: mux_2to1_1b port map(ire_inst(3), fsm_op, alu_c, alu_op);              
flag_unit: CCR port map(clock, reset, C_en, Z_en, c_out, z_out, c, z);
alu_b_sel(0) <= alu_b_s0;
alu_b_sel(1) <= alu_b_s1;
Aalu_mux: mux_2to1_16b port map(do1, do2, alu_a_s, alu_a);
Balu_mux: mux_4to1_16b port map(inverted, t2_out, sign_ex6, sign_ex9, alu_b_sel, alu_b); 
inv_mux: mux_2to1_16b port map(do2, ("0000000000000010"), inv_s, inv_choice);      --rb vs +2
inv1: inverter_16 port map(inv_en, inv_choice, inverted);
ire_instr <= ire_inst;
sign_ex6_16: sign_extend_6_16 port map(ire_inst(5 downto 0), sign_ex6);
sign_ex9_16: sign_extend_9_16 port map(ire_inst(8 downto 0), sign_ex9);

--IRE
ir: reg port map(clock, reset, ir_en, ire_in, ire_inst);

--Temp Reg
t2_block: reg port map(clock,reset,t2_en, do1, t2_out);

--Register File
r7<= "111";
rA<=ire_inst(6 downto 4);
rB<=ire_inst(9 downto 7);
rC<=ire_inst(12 downto 10);
RegisterFile: reg_file port map(do1, do2, din, RF_we, reset, ao1, ao2, ain, clock);
ao1_mux: mux_2to1_3b port map(r7, rA, ao1_s, ao1);                                     
ao2_mux: mux_2to1_3b port map(rB, count_out, ao2_s, ao2); 
ain_mux: mux_2to1_3b port map(rg, count_out, LS_e, ain);
r7<="111";
rg_sel(0)<=ain_s0;
rg_sel(1)<=ain_s1;
rg_mux: mux_4to1_3b port map(rA, rB, rC, r7, rg_sel, rg);
din_sel(0)<=din_s0;
din_sel(1)<=din_s1;
din_mux: mux_4to1_16b port map(t1, shifted, do1, din, din_sel, din);
count: count_reg port map(count_rst, inc_sig, cnt_out);
ov<=cnt_out(3);
count_out<= cnt_out(2 downto 0);                       
shft: shifter7 port map(ire_inst(8 downto 0), shifted);

--Bits for LS
LSbit: mux_8to1_1b port map(ire_inst(15 downto 8), count_out, LS);


end behave;