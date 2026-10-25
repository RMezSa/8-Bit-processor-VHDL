-- Nombre del archivo: datapath.vhd
-- Descripción: Datapath del CPU
-- Dependencias: ALU_NBit.vhd
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
	port(
		CLK, RST							: in std_logic;
		IR_Load, MAR_Load, PC_Load, ALU_C_Load	: in std_logic;
		A_Load, B_Load, CCR_Load	: in std_logic;
		PC_Inc							: in std_logic;
		ALU_Sel							: in std_logic_vector(3 downto 0);
		Bus1_Sel, Bus2_Sel			: in std_logic_vector(1 downto 0);
		from_memory						: in std_logic_vector(7 downto 0);
		IR, address, to_memory		: out std_logic_vector(7 downto 0);
		CCR_Result 						: out std_logic_vector(3 downto 0)
		
	);

end entity;

architecture RTL of datapath is
 
	component ALU_NBit is
		generic(N : integer := 8);
		port(
			A 		: in std_logic_vector(N-1 downto 0);
			B		: in std_logic_vector(N-1 downto 0);
			Cont	: in std_logic_vector(3 downto 0);
			Cin 	: in std_logic;
			S		: out std_logic_vector(N-1 downto 0);
			-- Negativo, Zero, Carry, Overflow
			Flags   : out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	-- Buses
	signal Bus1: std_logic_vector(7 downto 0);
	signal Bus2: std_logic_vector(7 downto 0);
	--Resultado de la ALU
	signal ALU_Result : std_logic_vector(7 downto 0);
	-- Program Counter, registros A y B
	signal PC, A, B : std_logic_vector(7 downto 0);
	-- Banderas
	signal NZVC : std_logic_vector(3 downto 0);
	
	begin
	
	--Intruction Register
	process(CLK, RST)
	begin
		if (RST = '0') then
			IR <= (others => '0');
		elsif rising_edge(CLK) then
			if (IR_Load = '1') then
				IR <= Bus2;
			end if;
		end if;
	end process;

	
	--Memory Adress Register
	process(CLK, RST)
	begin
		if (RST = '0') then
			address <= (others => '0');
		elsif rising_edge(CLK) then
			if (MAR_Load = '1') then
				address <= Bus2;
			end if;
		end if;
	end process;
		
	--Aumentar o asignar Program Counter
	process(CLK, RST)
	begin
		if (RST = '0') then
			PC <= (others => '0');
		elsif rising_edge(CLK) then
			if (PC_Load = '1') then
				PC <= Bus2;
			end if;
			if (PC_Inc = '1') then
				PC <= PC + x"01";
			end if;
			
		end if;
	end process;

	-- LOAD A
	process(CLK, RST)
	begin
		if (RST = '0') then
			A <= (others => '0');
		elsif rising_edge(CLK) then
			if (A_Load = '1') then
				 A <= Bus2;
			end if;
		end if;
	end process;
	
	-- LOAD B
	process(CLK, RST)
	begin
		if (RST = '0') then
			B <= (others => '0');
		elsif rising_edge(CLK) then
			if (B_Load = '1') then
				 B <= Bus2;
			end if;
		end if;
	end process;
	
	--Multiplexor para el input del Bus 1
				
	Bus1 <= 	PC when Bus1_Sel = "00" else
				A 	when Bus1_Sel = "01" else
				B 	when Bus1_Sel = "10" else
				x"00";

	--instancia a la ALU
	ALU_I : ALU_NBit generic map(N => 8) port map(B, Bus1, ALU_Sel, ALU_C_Load, ALU_Result, NZVC);
		
	
	--CCR (Flag Register): Almacenar las flags obtenidas de la ALU
	process(CLK, RST)
	begin
		if(RST = '0') then
			CCR_Result <= (others => '0');
		elsif rising_edge(CLK) then
			if(CCR_Load = '1') then
				CCR_Result <= NZVC;
			end if;
		end if;
	end process;
	
	
	
	--Multiplexor para Bus 2
	Bus2 <= 	ALU_Result 	when Bus2_Sel = "00" else
				Bus1 			when Bus2_Sel = "01" else
				from_memory when Bus2_Sel = "10" else
				x"00";
			
	to_memory <= Bus1;
	
	
end architecture;
