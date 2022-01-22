library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity contador_upBIN is
generic (n: integer:= 4);
port( Resetn, Clock, En, Ld	:in std_logic;
		Ent							:in std_logic_vector(n-1 downto 0);
		Q								:buffer std_logic_vector(n-1 downto 0));
end contador_upBIN;

architecture comportamiento of contador_upBIN is 
begin 
	process(Resetn, Clock)
	begin
		if Resetn = '0' then Q <= (others=>'0');
		elsif (Clock'event and Clock = '1') then
			if En = '1' then Q<= Q+'1';
			elsif Ld = '1' then Q<= Ent;
			end if;
		end if;	
	end process;
end comportamiento;