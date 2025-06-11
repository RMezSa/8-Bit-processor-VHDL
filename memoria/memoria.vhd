-- Nombre del archivo: memoria.vhd
-- Descripción: memoria de Top Level Entity
-- Dependencias: mem_datos.vhd, mem_programa.vhd, puertos_salida.vhd
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity memoria is
	port(
		clk, rst, wr: in std_logic;
		address 		: in std_logic_vector(7 downto 0);
		data_in		: in std_logic_vector(7 downto 0);
		data_out 	: out std_logic_vector(7 downto 0);
		--Puertos de entrada
		p_in_00, p_in_01, p_in_02, p_in_03		:  in std_logic_vector(7 downto 0);
		p_in_04, p_in_05, p_in_06, p_in_07		: 	in std_logic_vector(7 downto 0);
		p_in_08, p_in_09, p_in_10, p_in_11		: 	in std_logic_vector(7 downto 0);
		p_in_12, p_in_13, p_in_14, p_in_15		: 	in std_logic_vector(7 downto 0);
		--Puertos de salida
		p_out_00, p_out_01, p_out_02, p_out_03		:  out std_logic_vector(7 downto 0);
		p_out_04, p_out_05, p_out_06, p_out_07		: 	out std_logic_vector(7 downto 0);
		p_out_08, p_out_09, p_out_10, p_out_11		: 	out std_logic_vector(7 downto 0);
		p_out_12, p_out_13, p_out_14, p_out_15		: 	out std_logic_vector(7 downto 0)
	
	);

end entity;



architecture RTL of memoria is

component mem_datos is
	port(
		clk, wr	: in std_logic;
		address	: in std_logic_vector(7 downto 0);
		data_in	: in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(7 downto 0)
	
	);
end component;

component mem_programa is
	port(
		clk 		: in std_logic;
		address	: in std_logic_vector(7 downto 0);
		data_out : out std_logic_Vector(7 downto 0)
	);
end component;

component puertos_salida is
	port(
		clk, rst, wr	: in std_logic;
		address 			: in std_logic_vector(7 downto 0);
		data_in 			: in std_logic_vector(7 downto 0);
		p_out_00, p_out_01, p_out_02, p_out_03		:  out std_logic_vector(7 downto 0);
		p_out_04, p_out_05, p_out_06, p_out_07		: 	out std_logic_vector(7 downto 0);
		p_out_08, p_out_09, p_out_10, p_out_11		: 	out std_logic_vector(7 downto 0);
		p_out_12, p_out_13, p_out_14, p_out_15		: 	out std_logic_vector(7 downto 0)
	);
end component;

	signal data_out_ROM : std_logic_vector(7 downto 0);
	signal data_out_RAM : std_logic_vector(7 downto 0);
	signal output_port_addr : std_logic_vector(3 downto 0);
	signal ram_address, rom_address: std_logic_vector(7 downto 0);
	
	signal ps_in_00, ps_in_01, ps_in_02, ps_in_03 : std_logic_vector(7 downto 0);
	signal ps_in_04, ps_in_05, ps_in_06, ps_in_07 : std_logic_vector(7 downto 0);
	signal ps_in_08, ps_in_09, ps_in_10, ps_in_11 : std_logic_vector(7 downto 0);
	signal ps_in_12, ps_in_13, ps_in_14, ps_in_15 : std_logic_vector(7 downto 0);
	
	begin
	-- Asignacion de señales internas a los inputs de la entidad
	ps_in_00 <= p_in_00; 
	ps_in_01 <= p_in_01;
	ps_in_02 <= p_in_02;
	ps_in_03 <= p_in_03;
	ps_in_04 <= p_in_04;
	ps_in_05 <= p_in_05;
	ps_in_06 <= p_in_06;
	ps_in_07 <= p_in_07;
	ps_in_08 <= p_in_08;
	ps_in_09 <= p_in_09;
	ps_in_10 <= p_in_10;
	ps_in_11 <= p_in_11;
	ps_in_12 <= p_in_12;
	ps_in_13 <= p_in_13; 
	ps_in_14 <= p_in_14;
	ps_in_15 <= p_in_15;
	
	-- de x"00" a x"7F" ROM, de x"80" a x"DF" mem_datos, de x"E0" a x"EF" inputs y de x"F0" a x"FF" outputs
	rom_address <= '0' & address(6 downto 0) when (address(7) = '0') else (others => '0');
	ram_address <= '0' & address(6 downto 0) when (address(7) = '1') else (others => '0');
	output_port_addr <= address(3 downto 0) when (address(7 downto 4) = x"F") else "0000";
	
	--Instanciar ROM, mem_datos y outputs
	I0 : mem_programa port map(clk, address, data_out_ROM);
	I1 : mem_datos port map (clk, wr, address, data_in, data_out_RAM);
	I2 : puertos_salida port map (clk, rst, wr, address, data_in, p_out_00, p_out_01, p_out_02, p_out_03, p_out_04, p_out_05, p_out_06, p_out_07, p_out_08, p_out_09, p_out_10, p_out_11, p_out_12, p_out_13, p_out_14, p_out_15 );
			
	--Multiplexor dependiendo de lo que viene de bus1 y vamos a mandar a bus2, ROM, RAM, o inputs directo a outputs
	data_out <= data_out_ROM 	when address < x"80" else
					data_out_RAM 	when address < x"E0" else
					ps_in_00 			when address = x"E0" else
					ps_in_01 			when address = x"E1" else
					ps_in_02 			when address = x"E2" else
					ps_in_03 			when address = x"E3" else
					ps_in_04 			when address = x"E4" else
					ps_in_05 			when address = x"E5" else
					ps_in_06 			when address = x"E6" else
					ps_in_07 			when address = x"E7" else
					ps_in_08 			when address = x"E8" else
					ps_in_09 			when address = x"E9" else
					ps_in_10 			when address = x"EA" else
					ps_in_11 			when address = x"EB" else
					ps_in_12 			when address = x"EC" else
					ps_in_13 			when address = x"ED" else
					ps_in_14 			when address = x"EE" else
					ps_in_15 			when address = x"EF" else
					x"00";
	

end architecture;