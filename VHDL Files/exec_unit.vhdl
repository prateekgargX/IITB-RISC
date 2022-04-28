----------------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------
entity exec_unit is ---input is decoded control signals, output is IRE and Flags
	port(
    --alu control
    alu_a,alu_b,alu_c,B_1,B_0,
    --t1 control
    t1_a,t1_b,
    --RF control
    RF_a,RF_b,RF_c,
    --ao control
    ao_a,ao_b,
    din_e,dout_e,
    ,clock,reset: in std_logic; --9
	c,z: out std_logic;
	ire_inst: out std_logic_vector(15 downto 0)
	);
end entity;

architecture behave of exec_unit is
---------------------------------------------------
------------------COMPONENT-INSTANTIATION----------
component ALU is
    port(
           alu_a   : in STD_LOGIC_VECTOR(15 downto 0);
           alu_b   : in STD_LOGIC_VECTOR(15 downto 0);
           op_code : in STD_LOGIC; --2 types fo alu instruction(ADD and NAND)
           alu_out : out STD_LOGIC_VECTOR(15 downto 0);
           z_out   : out STD_LOGIC;
           c_out   : out STD_LOGIC);
end component ALU;

component  CCR is  
port
  (clock,reset,en : in std_logic;
     C_in,Z_in   	  : in std_logic;  
     C,Z  	      : out std_logic
);  
end component CCR;

component instr_reg is  
  port(clock,reset,en : in std_logic;
       din   		 : in std_logic_vector(15 downto 0);  
       dout  	    : out std_logic_vector(15 downto 0)
      );  
end component instr_reg;

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

component mux_8to1 is
    Port ( 
        x:in STD_LOGIC_VECTOR (7 downto 0);
        sel:in STD_LOGIC_VECTOR (2 downto 0);
        y : out STD_LOGIC);
end component mux_8to1;

component mux_4to1 is
    port(
    
        x0,x1,x2,x3:in STD_LOGIC_VECTOR (15 downto 0);
        sel:in STD_LOGIC_VECTOR (1 downto 0);
        y : out STD_LOGIC_VECTOR (15 downto 0)
        );
end component mux_4to1;

component mux_2to1 is
    port(
    
        x0,x1:in STD_LOGIC_vector(15 downto 0);
        sel:in STD_LOGIC;
        y : out STD_LOGIC_vector(15 downto 0)
     );
end component mux_2to1;

component memory IS
generic
(
    mem_a_width	: integer := 7; --bytes of storage
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

component inverter_16 is  
port(en : in std_logic;
     din   		 : in std_logic_vector(15 downto 0);  
     dout  	    : out std_logic_vector(15 downto 0)
    );  
end component inverter_16;

---------------------------------------------------

---------------------------------------------------
signal c_in,c_out_s,z_out_s, z_in : std_logic ;
signal rf_a3_inp, decode_in, rf_a1_inp: std_logic_vector(2 downto 0);
signal rf_d1_s,rf_d2_s, mem_d,decode_out, t1,t2,t3,alu_out_s,din_inp,t4_in,mem_a_in, xor_a_in, xor_b_in, xor_out,alu_b_final_in, t4,t5,t2_inp,t3_inp,pc_inp, pc_out, rf_d3_inp,se6_s, se9_s, alu_a_in,alu_b_in, tz7_out, ir_out :std_logic_vector(15 downto 0);
signal alu_a12, alu_b12,t4_co,t3_co, rfa3_co,rfd3_co, xor_b_co : std_logic_vector(1 downto 0);
---------------------------------------------------
begin
--Encoder and Decoder
decoder_block: Decoder port map(decode_in, decode_out);
pre_encoder: Priority_Encoder port map(t4, decode_in);
---Memory
din_mux: mux_2to1 port map(t1,rf_d1_s,din_co,din_inp);
memory_block: memory port map(clock, din_inp,mem_a_in,wr_en,mem_d);
mem_mux: mux_2to1 port map(pc_out, t3, mem_a_co,mem_a_in);
---Temp_Registers and Flag Registers
t1_block: reg port map(clock,reset,t1_en,rf_d1_s,t1);
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
c_flag_block: reg_1b port map(clock, reset, c_en,c_in,c_out_s);
z_flag_block: reg_1b port map(clock, reset, z_en,z_in,z_out_s);


---IR and PC
ir_block: ir port map (clock,reset,ir_en,mem_d,ir_out);
pc_block: reg port map(clock,reset,pc_en,pc_inp,pc_out);
pc_mux: mux_2to1 port map(alu_out_s, t2,pc_co,pc_inp);


--SE6 and SE9
SE6_block: SE6 port map(ir_out(5 downto 0), se6_s);
SE9_block: SE9 port map(ir_out(8 downto 0), se9_s);

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