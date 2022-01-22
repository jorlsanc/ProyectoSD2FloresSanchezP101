library ieee;
use ieee.std_logic_1164.all;

entity decDEC is
port( Entrada			:in std_logic_vector(3 downto 0);
		Q					:out std_logic_vector(6 downto 0));					
end decDEC;

architecture comportamiento of decDEC is 
begin 
	process(Entrada)
	begin 
		case Entrada is 
			when "0000" => Q<= "0111111"; --0
			when "0001" => Q<= "0111111"; --1
			when "0010" => Q<= "0111111"; --2
			when "0011" => Q<= "0111111"; --3 
			when "0100" => Q<= "0000110";	--4
			when "0101" => Q<= "0000110"; --5
			when "0110" => Q<= "0000110"; --6
			when "0111" => Q<= "1011011"; --7
			when "1000" =>	Q<= "1011011"; --8
			when "1001" => Q<= "1011011"; --9
			when others => Q<= "1011011"; --XD
		end case;
	end process;
end comportamiento;