-- Reloj de 250HZ, NO de 1KHZ

-- Nombre del archivo: CLK_1K.vhd
-- Descripción: CLOCK DE 250 HZ
-- Dependencias: 
-- Autor: Roberd Otoniel Meza Sainz


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLK_1K is
    Port ( clk_50  : in  std_logic;  
           RST  : in  std_logic;  
           clk : out std_logic); 
end CLK_1K;

architecture RTL of CLK_1K is
    signal clk_div : std_logic := '0'; 
    signal counter : unsigned(14 downto 0) := (others => '0');
begin
    process(clk_50, RST)
    begin
        if RST = '0' then
            clk_div <= '0'; 
            counter <= (others => '0');
        elsif rising_edge(clk_50) then
            if counter = 19999 then
				--if counter = 5 then
                counter <= (others => '0');
                clk_div <= not clk_div;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk <= clk_div;
end architecture;