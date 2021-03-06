library ieee;
use ieee.std_logic_1164.all;

entity registro_sost is
generic (n: integer:= 4);
port( Resetn, Clock	:in std_logic;
		En					:in std_logic;
		Entrada			:in std_logic_vector(n-1 downto 0);
		Q					:out std_logic_vector(n-1 downto 0));
end registro_sost;

architecture comportamiento of registro_sost is 
begin 
	process(Resetn, Clock)
	begin
		if Resetn = '0' then Q <= (others => '0');
		elsif (Clock'event and Clock = '1') then
			if En = '1' then
				Q <= Entrada;
		end if; end if;
	end process;
end comportamiento;
