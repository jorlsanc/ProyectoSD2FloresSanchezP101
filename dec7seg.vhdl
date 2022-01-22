library ieee;
use ieee.std_logic_1164.all;

entity dec7seg is
port( Entrada			:in std_logic_vector(6 downto 0);
		Q					:out std_logic_vector(3 downto 0));
end dec7seg;

architecture comportamiento of dec7seg is 
	begin 
		process(Entrada)
		 begin 
			case Entrada is 
				when "0111111" => Q<= "0000"; --0
				when "0000110" => Q<= "0001"; --1
				when "1011011" => Q<= "0010"; --2
				when "1001111" => Q<= "0011"; --3 
				when "1100110" => Q<= "0100";	--4
				when "1101101" => Q<= "0101"; --5
				when "1111101" => Q<= "0110"; --6
				when "0000111" => Q<= "0111"; --7
				when "1111111" =>	Q<= "1000"; --8
				when "1101111" => Q<= "1001"; --9
				when others => Q<= "0000"; --XD
			end case;
		end process; 
end comportamiento;