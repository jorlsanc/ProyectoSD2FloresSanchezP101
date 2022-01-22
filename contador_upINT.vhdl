library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity contador_upINT is
generic (n: integer:= 4);
port( Resetn, Clock, En, Ld	:in std_logic;
		Ent							:in integer range 0 to 256;
		Q								:buffer integer range 0 to 256);
end contador_upINT;

architecture comportamiento of contador_upINT is 
begin 
	process(Resetn, Clock)
	begin
		if Resetn = '0' then Q <= 0;
		elsif (Clock'event and Clock = '1') then
			if En = '1' then Q<=Q+1;
			elsif Ld = '1' then Q<= Ent;
			end if;
		end if;	
	end process;
end comportamiento;
