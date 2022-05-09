library ieee;
use ieee.std_logic_1164.all;

entity Count_reg is
port (
		reset,clock: in std_logic;
		y:out std_logic_vector(2 downto 0)
		);
		
end entity Count_reg;

architecture behav of Count_reg is

signal state:std_logic_vector(2 downto 0);

constant s_6:std_logic_vector(2 downto 0):="010";
constant s_7:std_logic_vector(2 downto 0):="000";
constant s_0:std_logic_vector(2 downto 0):="110";
constant s_1:std_logic_vector(2 downto 0):="111";
constant s_2:std_logic_vector(2 downto 0):="001";
constant s_3:std_logic_vector(2 downto 0):="011";
constant s_4:std_logic_vector(2 downto 0):="101";
constant s_5:std_logic_vector(2 downto 0):="100";

begin 

reg_process: process(clock,reset)

begin
if(reset='1')then 
	state<= s_0 ; -- write the reset state
elsif(clock'event and clock='1')then                                                                                                                                                           

	case state is  
      when s_6=>
		state<=s_7;
		when s_7=>
		state<=s_0;
		when s_0=>
		state<=s_1;
		when s_1=>
		state<=s_2;
		when s_2=>
		state<=s_3;
		when s_3=>
		state<=s_4;
		when s_4=>
		state<=s_5;
		when s_5=>
		state<=s_6;

--this is needed  because std_logic can take values other than 0,1 i.e high imepedance
      when others=> 
        state<= s_0;
      end case; 
end if;
end process reg_process;
-- output logic concurrent statemet or one more process
y<=state;
end behav;