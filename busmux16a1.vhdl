library ieee;
use ieee.std_logic_1164.all;

entity busmux16a1 is
generic (n: integer:= 4);
port(	sel				:in std_logic_vector(n-1 downto 0);
		ent0, ent1, ent2, ent3, ent4, ent5, ent6, ent7, ent8, ent9, ent10, ent11, ent12, ent13, ent14, ent15:in std_logic_vector(n-1 downto 0);
		s					:out std_logic_vector(n-1 downto 0));
end busmux16a1;

architecture comportamiento of busmux16a1 is 
begin 
	with sel select
		s<=	ent0 when "0000",
				ent1 when "0001",
				ent2 when "0010",
				ent3 when "0011",
				ent4 when "0100",
				ent5 when "0101",
				ent6 when "0110",
				ent7 when "0111",
				ent8 when "1000",
				ent9 when "1001",
				ent10 when "1010",
				ent11 when "1011",
				ent12 when "1100",
				ent13 when "1101",
				ent14 when "1110",
				ent15 when others;
					             
end comportamiento;        
