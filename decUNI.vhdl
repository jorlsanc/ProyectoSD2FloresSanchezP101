library ieee;
use ieee.std_logic_1164.all;

entity decUNI is
port( Entrada			:in std_logic_vector(3 downto 0);
		Q					:out std_logic_vector(6 downto 0));
end decUNI;

architecture comportamiento of decUNI is 
begin 
	process(Entrada)
	begin 
		case Entrada is 
			when "0000" => Q<= "0111111"; --0
			when "0001" => Q<= "1001111"; --1
			when "0010" => Q<= "1111101"; --2
			when "0011" => Q<= "1101111"; --3 
			when "0100" => Q<= "1011011";	--4
			when "0101" => Q<= "1101101"; --5
			when "0110" => Q<= "1111111"; --6
			when "0111" => Q<= "0000110"; --7
			when "1000" =>	Q<= "1100110"; --8
			when "1001" => Q<= "0000111"; --9
			when others => Q<= "0111111"; --XD
		end case;
	end process; 
end comportamiento;