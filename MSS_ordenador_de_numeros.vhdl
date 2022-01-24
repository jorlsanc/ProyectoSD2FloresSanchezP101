library ieee;
use ieee.std_logic_1164.all;
use work.componentes.all;

--controladora del ordenador de numero--
entity ordenador_de_numeros is
	generic(n: integer := 4);
	port( Clock, Resetn				:in std_logic;
			Start1,Start2, WrInit, Rd, RW1	:in std_logic;
			DataIn						:in std_logic_vector(3 downto 0);
			DataR1In  				:in std_logic_vector(3 downto 0);
			addR1XD						:buffer integer range 0 to 256;
			DataR2In						:buffer std_logic_vector(3 downto 0);
			DataR2OUTXD					:buffer std_logic_vector(3 downto 0);
			DataR3OUTXD					:buffer std_logic_vector(3 downto 0);
			NumMasRep					:buffer std_logic_vector(3 downto 0);
			Sg7DEC, Sg7UNI 			:buffer std_logic_vector(3 downto 0); 
			RepetMax						:buffer std_logic_vector(3 downto 0);				
			RAdd							:in integer range 0 to 14;
			DataOut						:buffer std_logic_vector(3 downto 0);
			Done1, Done2				:buffer std_logic);
end ordenador_de_numeros;

architecture comportamiento of ordenador_de_numeros is
	type estado is (s1A,s2A,s3A,s4A,s5A,s6A,s7A,s8A,s9A,s1B,s2B,s3B,s4B,s5B,s6B,s7B,s8B,s9B,s10B,s11B,s12B,s13B,s14B,s15B,s16B,s17B,s18B,s19B,s20B,s21B,s22B,s23B,s24B);
	signal y: estado;
	signal Ci, Cj: integer range 0 to 15; --cambio
	signal Rin: std_logic_vector(14 downto 0); --cambio
	type RegArray is array (14 downto 0) of std_logic_vector(n-1 downto 0); --cambio
	signal R: RegArray;
	signal RData: std_logic_vector(n-1 downto 0);
	signal ABMUX: std_logic_vector(n-1 downto 0); --cambio
	signal Int, CSel, Wr, BltA: std_logic;
	signal CMux, IMux : integer range 0 to 14;
	signal Ain, Bin, Aout, Bout: std_logic;
	signal Li, Ei, Lj, Ej, zi, zj: std_logic;
	signal zero: integer range 15 downto 0; --dato para cargar Ci=0 cambio
	signal A, B, ABData: std_logic_vector(n-1 downto 0);
	signal LR1, ER1, LR2, ER2, LR3, ER3, LRG, ERG: std_logic; 
	signal enRg1, enRg2, enRg3: std_logic;
	signal RW2, RW3: std_logic; --R/W de las rams
	signal addR1BIN, addR2BIN: std_logic_vector(n-1 downto 0);
	signal addR1, addR2, entRg1: integer range 0 to 256;
	signal R1lt15 : std_logic; --Se ha cumplido el recorrido de R1
	signal readR2, readR1, writeR2: std_logic;
	signal sum: std_logic;
	signal DataR3gtB: std_logic; --El dato presente en R3 es mayor que el valor en B
	signal entRg1eqaddR2: std_logic; --el numero de datos de R2 ha llegado a recorrer R2
	signal DataUnicos: integer range 0 to 256; --Cantidad de datos unicos
	signal DataR2Out, DataR3In, DataR3Out: std_logic_vector(n-1 downto 0);
	signal Repeticiones, RepeticionesMax, NumeroMasRep: std_logic_vector(n-1 downto 0);
	signal OutDEC, OutUNI: std_logic_vector(6 downto 0);
	signal Out7DEC, Out7UNI: std_logic_vector(3 downto 0);
	
	begin 
		--Transiciones de la MSS--
		MSS_Transiciones: process(Clock,Resetn)
		begin
			if Resetn = '0' then y<=s1A;
			elsif (Clock'event and Clock = '1') then 
				case y is 
					--Primera parte--
					when s1A => if Start1 = '0' then y<= s1A; else y<= s2A; end if;
					when s2A => y<= s3A;
					when s3A => y<= s4A;
					when s4A => y<= s5A;
					when s5A => if BltA = '1' then y<= s6A; else y<= s8A; end if;
					when s6A => y<= s7A;
					when s7A => y<= s8A;
					when s8A => if zj = '0' then y<=s4A; 
								  elsif zi ='0'then y<= s2A;
								  else y<= s9A; end if;
					when s9A => if Start1 = '1' then y<=s9A; else y<= s1B; end if;
					
					--Segunda parte--
					when s1B => if Start2 ='0' then y<=s1B; else y<=s2B;end if;
					when s2B => y<=s3B;
					when s3B => if readR2='1' then y<=s7B; else y<=s4B;end if;
					when s4B => if readR1='1' then y<=s8B; else y<=s5B; end if;
					when s5B => if writeR2='1' then y<=s6B; else y<=s8B; end if;
					when s6B => y<=s9B;
					when s7B => y<=s3B;
					when s8B => y<=s3B;
					when s9B => y<=s10B;
					when s10B => if R1lt15 ='1' then y<=s11B; else y<=s3B; end if;
					when s11B => y<=s12B;
					when s12B => y<=s13B;
					when s13B => if sum = '1' then y<=s14B; else y<=s16B;end if;
					when s14B => y<=s15B;
					when s15B => y<=s16B;
					when s16B => if R1lt15 ='1' then y<=s17B; else y<=s18B;end if;
					when s17B => if entRg1eqaddR2 = '1' then y<= s20B; else y<= s19B; end if;
					when s18B => y<=s13B;
					when s19B => y<=s13B;
					when s20B => y<=s21B;
					when s21B => if DataR3gtB='1' then y<=s23B; else y<=s22B;end if;
					when s22B => y<=s21B;
					when s23B =>	if entRg1eqaddR2='1' then y<=s24B; else y<=s22B; end if;	
					when s24B => if Start2 ='1' then y<= s24B; else y<=s1A; end if;				
				end case;
			end if;
		end process;
--Salidas generadas por la MSS
  Int<= '0' when (y = s1A OR y = s1B) else '1';
  Done1<= '1' when y = s9A else '0';
  DONE2<='1' when y=s24B else '0';

		MSS_salidas: process (y, zi, zj)
		begin
		Li<='0'; Ei<='0'; Lj<='0'; Ej<='0'; Csel<='0';
		Wr<='0'; Ain<='0'; Bin<='0'; Aout<='0'; Bout<='0';
		RW2<='0'; RW3<='0'; 
		LR1<='0'; ER1<='0'; LR2<='0'; ER2<='0'; LR3<='0'; ER3<='0'; LRG<='0'; ERG<='0';
		enRg1<='0'; enRg2<='0'; enRg3<='0';
		case y is
			--Primera parte--
			when s1A => Li<='1'; Ei<='1';
			when s2A => Ain<='1'; Lj<='1';Ej<='1';
			when s3A => Ej<='1';
			when s4A => Bin<='1'; Csel<='1';
			when s5A => --ninguna salida
			when s6A => Csel<='1'; Wr<='1';
			when s7A => Wr<='1'; Bout<='1';
			when s8A => Ain<='1';
						  if zj='0' then Ej<='1'; else Ej<='0';
						  if zi='0' then Ei<='1'; else Ei<='0';end if; end if;
			when s9A => --salida DONE ya asignada
			
			--Segunda parte--
			when s1B => --ninguna salida
			when s2B => LR1<='1'; LR2<='1'; LRG<='1';
			when s3B => --ninguna salida
			when s4B => --ninguna salida
			when s5B => --ninguna salida
			when s6B => RW2<= '1';
			when s7B => ER1<='1'; LR2<='1';
			when s8B => ER2<='1';
			when s9B => ER1<='1';
			when s10B => ERG<='1';LR2<='1';
			when s11B =>	enRg1<='1';  
			when s12B => LR1<='1';LR2<='1';LR3<='1'; 
			when s13B => --ninguna salida
			when s14B => ER3<='1';
			when s15B => RW3<='1'; 
			when s16B => --nada
			when s17B => LR1<='1';				
			when s18B => ER1<='1';
			when s19B => ER2<='1'; LR3<='1';
			when s20B => LR2<='1';
			when s21B => --XD
			when s22B => ER2<='1';
			when s23B => enRg2 <='1'; enRg3<='1';
			when s24B => --DONE			
		end case;
	end process;
	
	--Procesador de datos
	Zero<= 0;
	registros_datos: for i in 0 to 14 generate
	registros_datos: registro_sost port map (Resetn, Clock, Rin(i), RData , R(i));
	end generate; 
	
	registro_A: registro_sost port map (Resetn, Clock, Ain , ABData, A);
	
	registro_B: registro_sost port map (Resetn, Clock, Bin, ABData , B);
	
	BltA<= '1' when B<A else '0'; 
	ABMux <= A when Bout <='0' else B;
	RData <= ABMux when WrInit ='0' else DataIn;
	
		
	C_i: contador_up port map (Resetn, Clock, Ei, Li, zero, Ci);
	
	C_j: contador_up port map (Resetn, Clock, Ej, Lj, Ci, Cj);
				
	CMux<= Ci when Csel = '0' else Cj;
	IMux<= CMux when Int = '1' else RAdd;
	with IMux select
		ABData <= R(0) when 0,
					 R(1) when 1,
					 R(2) when 2,
					 R(3) when 3,
					 R(4) when 4,
					 R(5) when 5,
					 R(6) when 6,
					 R(7) when 7,
					 R(8) when 8,
					 R(9) when 9,
					 R(10) when 10,
					 R(11) when 11,
					 R(12) when 12,
					 R(13) when 13,
					 R(14) when others;
	Rin_decodificador: process (WrInit, Wr, Imux)
	begin
		if (WrInit or Wr) = '1' then 
			case IMux is 
				when 0 => Rin<= 	"000000000000001";
				when 1 => Rin<= 	"000000000000010";
				when 2 => Rin<= 	"000000000000100";
				when 3 => Rin<= 	"000000000001000";
				when 4 => Rin<= 	"000000000010000";
				when 5 => Rin<= 	"000000000100000";
				when 6 => Rin<= 	"000000001000000";
				when 7 => Rin<= 	"000000010000000";
				when 8 => Rin<= 	"000000100000000";
				when 9 => Rin<= 	"000001000000000";
				when 10 => Rin<=	"000010000000000";
				when 11 => Rin<=	"000100000000000";
				when 12 => Rin<=	"001000000000000";
				when 13 => Rin<=	"010000000000000";
				when others => Rin<=	"100000000000000";
			end case; 
		else Rin<="000000000000000";
		end if;
	end process;
	
	zi<= '1' when Ci= 13 else '0';
	zj<= '1' when Cj= 14 else '0';
	
	--Decoder--
		addR1X: process(addR1)
		begin 
			case addR1 is 
				when 0 => addR1BIN<= "0000";
				when 1 => addR1BIN<= "0001";
				when 2 => addR1BIN<= "0010";
				when 3 => addR1BIN<= "0011";
				when 4 => addR1BIN<= "0100";
				when 5 => addR1BIN<= "0101";
				when 6 => addR1BIN<= "0110";
				when 7 => addR1BIN<= "0111";
				when 8 => addR1BIN<= "1000";
				when 9 => addR1BIN<= "1001";
				when 10 => addR1BIN<= "1010";
				when 11 => addR1BIN<= "1011";
				when 12 => addR1BIN<= "1100";
				when 13 => addR1BIN<= "1101";
				when 14 => addR1BIN<= "1110";
				when 15 => addR1BIN<= "1111";
				when others=> addR1BIN<="1111";
			end case;
		end process;
		
		addR2XD: process(addR2)
		begin 
			case addR2 is 
				when 0 => addR2BIN<= "0000";
				when 1 => addR2BIN<= "0001";
				when 2 => addR2BIN<= "0010";
				when 3 => addR2BIN<= "0011";
				when 4 => addR2BIN<= "0100";
				when 5 => addR2BIN<= "0101";
				when 6 => addR2BIN<= "0110";
				when 7 => addR2BIN<= "0111";
				when 8 => addR2BIN<= "1000";
				when 9 => addR2BIN<= "1001";
				when 10 => addR2BIN<= "1010";
				when 11 => addR2BIN<= "1011";
				when 12 => addR2BIN<= "1100";
				when 13 => addR2BIN<= "1101";
				when 14 => addR2BIN<= "1110";
				when 15 => addR2BIN<= "1111";
				when others => addR2BIN<="1111";
			end case;
		end process;
		
		--Contadores--
		C_R1: contador_upINT port map(Resetn, Clock, ER1, LR1, zero, addR1);--Bien
		C_R2: contador_upINT port map(Resetn, Clock, ER2, LR2, zero, addR2); --Bien
		C_R3: contador_upBIN port map(Resetn, Clock, ER3, LR3, "0000", Repeticiones);--Bien
		C_RG: contador_upINT port map(Resetn, Clock, ERG, LRG, zero, entRg1);--Bien
		
		--Registros--
		registroUnicos: registro_sostInt port map(Resetn, Clock, enRg1, entRg1, DataUnicos);--Bien
		registroRepMax: registro_sostBIN port map(Resetn, Clock, enRg2, DataR3Out, RepeticionesMax);--Bien	
		registroNumMasRep: registro_sostBIN port map(Resetn, Clock, enRg3, DataR2Out, NumeroMasRep);--Bien
		
		--Rams-
		ram_Data: ram_datos port map(addR1BIN, Clock, DataR1In, RW1, DataR2In);--Bien
		ram_Uni: ram port map(addR2BIN, Clock, DataR2In, RW2, DataR2Out);--Bien
		ram_Repeticiones: ram port map(addR2BIN, Clock, Repeticiones, RW3, DataR3Out);--Bien
		
		--Decoders Programados--
		decDECENAS: decDEC port map(NumeroMasRep, OutDEC);
		decUNIDADES: decUNI port map(NumeroMasRep, OutUNI);
		dec7DEC: dec7seg port map(OutDEC, Out7DEC);
		dec7UNI: dec7seg port map(OutUNI, Out7UNI);
		
		--Comparadores--
		readR2<= '1' when DataR2In = DataR2Out else '0';
		readR1<= '1' when DataR2In < DataR2Out else '0';
		writeR2<= '1' when DataR2Out="0000" else '0'; 
		sum<= '1' when DataR2Out = DataR2In  else '0'; 
		DataR3gtB<= '1' when DataR3Out > RepeticionesMax else '0';
		entRg1eqaddR2<= '1' when (entRg1-1)= addR2   else '0';
		R1lt15<= '1' when addR1BIN="1110" else '0';
			
		DataR2OutXD<= DataR2Out;
		DataR3OUTXD<= DataR3Out;
		addR1XD<= addR1;
		NumMasRep<= NumeroMasRep;
		RepetMax<= RepeticionesMax;
		Sg7DEC<= Out7DEC;
		Sg7UNI<= Out7UNI;
	
		DataOut<= (others=> 'Z') when Rd='0' else ABData;
end comportamiento; 
		
