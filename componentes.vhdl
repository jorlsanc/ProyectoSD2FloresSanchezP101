library ieee;
use ieee.std_logic_1164.all;

package componentes is 
component registro_sost
	generic (n: integer:= 4);
	port( Resetn, Clock	:in std_logic;
			En					:in std_logic;
			Entrada			:in std_logic_vector(n-1 downto 0);
			Q					:out std_logic_vector(n-1 downto 0));
end component;

component busmux2a1
	generic (n: integer:= 4);
	port(	sel				:in std_logic;
			ent0, ent1		:in std_logic_vector(n-1 downto 0);
			s					:out std_logic_vector(n-1 downto 0));
end component;

component contador_up 
	generic (n: integer:= 4);
	port( Resetn, Clock, En, Ld	:in std_logic;
			Ent							:in integer range 0 to 15;
			Q								:buffer integer range 0 to 15);								
end component;

component registro_sostBIN
	generic (n: integer:= 4);
	port( Resetn, Clock			:in std_logic;
			En					:in std_logic;
			Entrada				:in std_logic_vector(n-1 downto 0);
			Q					:out std_logic_vector(n-1 downto 0));
end component;

component registro_sostInt is
	generic (n: integer:= 4);
	port( Resetn, Clock			:in std_logic;
			En					:in std_logic;
			Entrada				:in integer range 0 to 256;
			Q					:buffer integer range 0 to 256);
end component;

component contador_upBIN is
	generic (n: integer:= 4);
	port( Resetn, Clock, En, Ld	:in std_logic;
		Ent								:in std_logic_vector(n-1 downto 0);
		Q									:buffer std_logic_vector(n-1 downto 0));
end component;

component contador_upINT is
	generic (n: integer:= 4);
	port( Resetn, Clock, En, Ld	:in std_logic;
			Ent							:in integer range 0 to 256;
			Q								:buffer integer range 0 to 256);								
end component;

component ram is 
	port( address	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		   clock		: IN STD_LOGIC  := '1';
		   data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		   wren		: IN STD_LOGIC ;
		   q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
end component;

component ram_datos is
	port( address	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		   clock		: IN STD_LOGIC  := '1';
		   data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		   wren		: IN STD_LOGIC ;
		   q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
end component;

component decUNI is
port( Entrada			:in std_logic_vector(3 downto 0);
		Q					:out std_logic_vector(6 downto 0));
end component;

component decDEC is
port( Entrada			:in std_logic_vector(3 downto 0);
		Q					:out std_logic_vector(6 downto 0));
end component;

component dec7seg is
port( Entrada			:in std_logic_vector(6 downto 0);
		Q					:out std_logic_vector(3 downto 0));
end component;
end componentes;	
