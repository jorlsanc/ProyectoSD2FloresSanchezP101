library ieee;
use ieee.std_logic_1164.all;

entity registro_sostInt is
generic (n: integer:= 4);
port( Resetn, Clock			:in std_logic;
		En							:in std_logic;
		Entrada					:in integer range 0 to 256;
		Q							:buffer integer range 0 to 256);
end registro_sostInt;

architecture comportamiento of registro_sostInt is 
begin 
	process(Resetn, Clock)
	begin
		if Resetn = '0' then Q <= 0;
		elsif (Clock'event and Clock = '1') then
			if En = '1' then
				Q <= Entrada;
		end if; end if;
	end process;
end comportamiento;
