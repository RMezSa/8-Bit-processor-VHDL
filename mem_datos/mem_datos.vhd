-- Nombre del archivo: mem_datos.vhd
-- Descripción: Memoria de datos, RAM
-- Dependencias: 
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mem_datos is
	port(
		clk, wr	: in std_logic;
		address	: in std_logic_vector(7 downto 0);
		data_in	: in std_logic_vector(7 downto 0);
		data_out	: out std_logic_vector(7 downto 0)
	
	);

end entity;


architecture arc of mem_datos is
-- Memoria RAM para guardar o recuperar datos, 96 direcciones
type mem_dato is array(0 to 95) of std_logic_vector(7 downto 0);
	signal RAM : mem_dato := (
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"78", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00",
			x"00", x"00", x"00", x"00"
	);
	begin
	process(clk) 
	begin
	if (clk'event and clk = '1') then
		if (wr = '1') then
			--Escribe, guarda lo que llega de data_in en RAM
			RAM(conv_integer(unsigned(address))) <= data_in;
		else 
			--Lee, manda a data_out lo que tiene en RAM
			data_out <= RAM(conv_integer(unsigned(address)));
		end if;
	end if;
	end process;


end architecture;