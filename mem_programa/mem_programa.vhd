-- Nombre del archivo: mem_programa.vhd
-- Descripción: Memoria ROM del CPU, instrucciones y programa instanciado
-- Dependencias: 
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mem_programa is
	port(
		clk 		: in std_logic;
		address	: in std_logic_vector(7 downto 0);
		data_out : out std_logic_Vector(7 downto 0)
	);
end entity;

architecture RTL of mem_programa is

type instmem is array (0 to 127) of std_logic_vector(7 downto 0);

--Instruction set architecture

--Data transfer
constant LOAD_INM_A 		: STD_LOGIC_VECTOR(7 downto 0) := x"86"; -- Carga inmediata en A
constant LOAD_INM_B		: STD_LOGIC_VECTOR(7 downto 0) := x"87"; -- Carga inmediata en B
constant LOAD_DIR_A		: STD_LOGIC_VECTOR(7 downto 0) := x"88"; -- Carga dirección en A
constant LOAD_DIR_B 		: STD_LOGIC_VECTOR(7 downto 0) := x"89"; -- Carga direccion en B
constant STORE_A 			: STD_LOGIC_VECTOR(7 downto 0) := x"96"; -- Guarda A en direccion
constant STORE_B			: STD_LOGIC_VECTOR(7 downto 0) := x"97"; -- Guarda B en direccion

--Operaciones Aritmetico-Lógicas
constant ADD_AB			: STD_LOGIC_VECTOR(7 downto 0) := x"40"; -- Suma A + B
constant SUB_AB			: STD_LOGIC_VECTOR(7 downto 0) := x"41"; -- Resta A + B
constant AND_AB			: STD_LOGIC_VECTOR(7 downto 0) := x"42"; -- A AND B
constant OR_AB				: STD_LOGIC_VECTOR(7 downto 0) := x"43"; -- A OR B
constant XOR_AB			: STD_LOGIC_VECTOR(7 downto 0) := x"44"; -- A XOR B
constant INC_A				: STD_LOGIC_VECTOR(7 downto 0) := x"45"; -- INC A | A = A + 1
constant INC_B				: STD_LOGIC_VECTOR(7 downto 0) := x"46"; -- INC B | B = B + 1
constant DEC_A				: STD_LOGIC_VECTOR(7 downto 0) := x"47"; -- DEC A | A = A - 1
constant DEC_B				: STD_LOGIC_VECTOR(7 downto 0) := x"48"; -- DEC B | B = B - 1
constant NOT_A				: STD_LOGIC_VECTOR(7 downto 0) := x"50"; -- NEG A => COMP1 A
constant NOT_B				: STD_LOGIC_VECTOR(7 downto 0) := x"51"; -- NEG B => COMP1 B

--Saltos
constant JMP 				: STD_LOGIC_VECTOR(7 downto 0) := x"20"; -- Salto incondicional a direccion
constant JN 				: STD_LOGIC_VECTOR(7 downto 0) := x"21"; -- Salto a direccion si N = 1
constant JNN				: STD_LOGIC_VECTOR(7 downto 0) := x"22"; -- Salto a direccion si N = 0
constant JZ					: STD_LOGIC_VECTOR(7 downto 0) := x"23"; -- Salto a direccion si Z = 1 / JE
constant JNZ 				: STD_LOGIC_VECTOR(7 downto 0) := x"24"; -- Salto a direccion si Z = 1 / JE
constant JOV 				: STD_LOGIC_VECTOR(7 downto 0) := x"25"; -- Salto a direccion si V = 1
constant JNOV 				: STD_LOGIC_VECTOR(7 downto 0) := x"26"; -- Salto a direccion si V = 0
constant JC					: STD_LOGIC_VECTOR(7 downto 0) := x"27"; -- Salto a direccion si C = 1
constant JNC 				: STD_LOGIC_VECTOR(7 downto 0) := x"28"; -- Salto a direccion si C = 0


--------------------------

signal ROM : instmem := (
    -- Inicio del bucle principal
    0 => LOAD_DIR_A,   -- Leer p_in_00 (entrada del botón)
    1 => x"E0",
    
    2 => LOAD_INM_B,   -- B <- mascara 00000001
    3 => x"01",
    
    4 => AND_AB,       -- A <- A AND B (aísla el bit 0)
    
    5 => JZ,           -- Si bit 0 es 0, salta a encender LED
    6 => x"0B",
    
    -- Si bit 0 es 1, apaga el LED
    7 => LOAD_INM_A,   -- A <- 0 (para apagar el LED)
    8 => x"00",
    9 => JMP,          -- Salta para almacenar el valor
    10 => x"0D",
    
    -- Si bit 0 es 0, enciende el LED
    11 => LOAD_INM_A,  -- A <- 1 (para encender el LED)
    12 => x"01",
    
    -- Almacena el estado en la salida del LED
    13 => STORE_A,     -- LED 0 <- valor de A
    14 => x"F0",
    
    -- Vuelve al inicio del bucle
    15 => JMP,
    16 => x"00",
    
    others => x"00"
);

-----------------------------------

begin
process(clk)
begin
	if(clk'event and clk = '1') then
		-- Enviar programa 
		data_out <= ROM(conv_integer(unsigned(address)));
	end if;
end process;
end architecture;
