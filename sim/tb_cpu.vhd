-- tb_cpu.vhd
-- Testbench del CPU de 8 bits: conecta CPU_8bit y memoria a un reloj directo
-- (sin el divisor CLK_1K) y corre el programa de mem_programa.vhd:
--   lee el bit 0 del puerto de entrada p_in_00 y escribe el LED en p_out_00.
--   entrada = '1' -> LED = x"00"
--   entrada = '0' -> LED = x"01"
-- Correr: cd sim && make

library ieee;
use ieee.std_logic_1164.all;

entity tb_cpu is
end entity;

architecture sim of tb_cpu is
    constant T : time := 10 ns;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';   -- reset activo en bajo
    signal wr          : std_logic;
    signal from_memory : std_logic_vector(7 downto 0);
    signal to_memory   : std_logic_vector(7 downto 0);
    signal address     : std_logic_vector(7 downto 0);

    signal p_in_00     : std_logic_vector(7 downto 0) := x"01";
    signal p_out_00    : std_logic_vector(7 downto 0);
    signal zeros       : std_logic_vector(7 downto 0) := x"00";

    signal done        : boolean := false;
begin
    clk <= not clk after T / 2 when not done;

    cpu : entity work.CPU_8bit
        port map(
            CLK => clk, RST => rst, wr => wr,
            from_memory => from_memory, to_memory => to_memory, address => address,
            IR_Load_out => open, MAR_Load_out => open, PC_Load_out => open,
            PC_Inc_out => open, A_Load_out => open, B_Load_out => open,
            ALU_Sel_out => open, CCR_Load_out => open, Bus1_sel_out => open,
            Bus2_sel_out => open, ALU_C_Load_out => open, IR_out => open,
            CCR_Result_out => open
        );

    mem : entity work.memoria
        port map(
            clk => clk, rst => rst, wr => wr,
            address => address, data_in => to_memory, data_out => from_memory,
            p_in_00 => p_in_00, p_in_01 => zeros, p_in_02 => zeros, p_in_03 => zeros,
            p_in_04 => zeros, p_in_05 => zeros, p_in_06 => zeros, p_in_07 => zeros,
            p_in_08 => zeros, p_in_09 => zeros, p_in_10 => zeros, p_in_11 => zeros,
            p_in_12 => zeros, p_in_13 => zeros, p_in_14 => zeros, p_in_15 => zeros,
            p_out_00 => p_out_00, p_out_01 => open, p_out_02 => open, p_out_03 => open,
            p_out_04 => open, p_out_05 => open, p_out_06 => open, p_out_07 => open,
            p_out_08 => open, p_out_09 => open, p_out_10 => open, p_out_11 => open,
            p_out_12 => open, p_out_13 => open, p_out_14 => open, p_out_15 => open
        );

    stimulus : process
        variable errors : natural := 0;

        procedure check(expected : std_logic_vector(7 downto 0); what : string) is
        begin
            if p_out_00 = expected then
                report "PASS: " & what;
            else
                report "FAIL: " & what severity error;
                errors := errors + 1;
            end if;
        end procedure;
    begin
        wait for 5 * T;
        rst <= '1';

        p_in_00 <= x"01";                -- entrada en 1
        wait for 400 * T;                -- varias vueltas del programa
        check(x"00", "input bit = 1 -> LED off");

        p_in_00 <= x"00";                -- entrada en 0
        wait for 400 * T;
        check(x"01", "input bit = 0 -> LED on");

        p_in_00 <= x"01";                -- entrada en 1 otra vez
        wait for 400 * T;
        check(x"00", "input bit = 1 again -> LED off");

        if errors = 0 then
            report "ALL TESTS PASSED";
        else
            report integer'image(errors) & " TEST(S) FAILED" severity failure;
        end if;
        done <= true;
        wait;
    end process;
end architecture;
