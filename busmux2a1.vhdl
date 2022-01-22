library ieee;
use ieee.std_logic_1164.all;

entity busmux2a1 is
generic (n: integer:= 4);
port(	sel				:in std_logic;
		ent0, ent1		:in std_logic_vector(n-1 downto 0);
		s					:out std_logic_vector(n-1 downto 0));
end busmux2a1;

architecture comportamiento of busmux2a1 is 
begin 
	with sel select
		s<=	ent0 when '0',
				ent1 when others;
end comportamiento;
