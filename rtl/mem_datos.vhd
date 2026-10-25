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
		-- La RAM ocupa x"80" a x"DF": el indice son los 7 bits bajos (0 a 95)
		if (wr = '1') then
			--Escribe, solo si la direccion cae dentro de la RAM
			if (address >= x"80" and address < x"E0") then
				RAM(conv_integer(unsigned(address(6 downto 0)))) <= data_in;
			end if;
		else 
			--Lee, manda a data_out lo que tiene en RAM
			if (address >= x"80" and address < x"E0") then
				data_out <= RAM(conv_integer(unsigned(address(6 downto 0))));
			else
				data_out <= (others => '0');
			end if;
		end if;
	end if;
	end process;


end architecture;