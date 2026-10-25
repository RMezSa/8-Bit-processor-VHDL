-- Nombre del archivo: ALU_NBit
-- Descripción: Unidad Logica Aritmetica del CPU
-- Dependencias: ALU_1Bit
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
entity ALU_NBit is
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
end entity;
architecture RTL of ALU_NBit is
component ALU_1Bit is
	port(
		A 		: in std_logic;
		B		: in std_logic;
		Cont	: in std_logic_vector(3 downto 0);
		Cin	: in std_logic;
		S		: out std_logic;
		Cout 	: out std_logic
	);

end component;

signal C : std_logic_vector(N downto 0);
signal Zero_aux : std_logic;
signal S_interna : std_logic_vector(N-1 downto 0);
begin
	C(0) <= Cin;
	
	-- Instanciación de las ALUs de 1 Bit
	ALU_MOD: for i in 0 to N-1 generate
		ALU_i: ALU_1Bit
			port map(A(i), B(i), Cont, C(i), S_interna(i), C(i+1));
	end generate;
	
	
	--Asignacion de banderas obtenidas
	process(S_interna, C)
		variable overflow : std_logic;
		variable ceros : std_logic_vector(N-1 downto 0);
	begin
		ceros := (others => '0');
		-- Carry
		Flags(1) <= C(N);
	
		-- Overflow 
		overflow := C(N) xor C(N-1);
		Flags(0) <= overflow;
	
		if overflow = '0' then
			Flags(3) <= S_interna(N-1);
		else
			Flags(3) <= '0';
		end if;
	
		-- Zero
		if S_interna = ceros then
			Flags(2) <= '1';
		else
			Flags(2) <= '0';
		end if;
	end process;
	
	-- Asignar la S obtenida dentro del process
	S <= S_interna;
	
end architecture;