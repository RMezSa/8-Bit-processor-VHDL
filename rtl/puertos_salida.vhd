-- Nombre del archivo: puertos_salida.vhd
-- Descripción: Puertos de salida del CPU
-- Dependencias: 
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity puertos_salida is
    port(
        clk, rst, wr    : in std_logic;
        address         : in std_logic_vector(7 downto 0);
        data_in         : in std_logic_vector(7 downto 0);

        p_out_00, p_out_01, p_out_02, p_out_03     : out std_logic_vector(7 downto 0);
        p_out_04, p_out_05, p_out_06, p_out_07     : out std_logic_vector(7 downto 0);
        p_out_08, p_out_09, p_out_10, p_out_11     : out std_logic_vector(7 downto 0);
        p_out_12, p_out_13, p_out_14, p_out_15     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture arc of puertos_salida is

    type mem_dato is array (0 to 15) of std_logic_vector(7 downto 0); 

    signal RAM: mem_dato := (
        x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", -- 0x00 - 0x07
        x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"  -- 0x08 - 0x0F
    );

begin
    process(clk, rst)
    begin
        if(rst = '0') then
            RAM <= (others => (others => '0'));
            
        elsif rising_edge(clk) then
            if (wr = '1') then
                RAM(conv_integer(unsigned(address(3 downto 0)))) <= data_in;
            end if;
        end if;
    end process;

    p_out_00 <= RAM(0);
    p_out_01 <= RAM(1);
    p_out_02 <= RAM(2);
    p_out_03 <= RAM(3);
    p_out_04 <= RAM(4);
    p_out_05 <= RAM(5);
    p_out_06 <= RAM(6);
    p_out_07 <= RAM(7);
    p_out_08 <= RAM(8);
    p_out_09 <= RAM(9);
    p_out_10 <= RAM(10);
    p_out_11 <= RAM(11);
    p_out_12 <= RAM(12);
    p_out_13 <= RAM(13);
    p_out_14 <= RAM(14);
    p_out_15 <= RAM(15);

end architecture;