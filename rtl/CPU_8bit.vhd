-- Nombre del archivo: CPU_8bit.vhd
-- Descripción: Entidad del CPU de 8 bits con señales de control expuestas
-- Dependencias: datapath.vhd, control_unit.vhd
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CPU_8bit is
    port(
        CLK, RST                    : in std_logic;
        wr                          : out std_logic;
        from_memory                 : in std_logic_vector(7 downto 0);
        to_memory, address          : out std_logic_vector(7 downto 0);
        
        IR_Load_out                 : out std_logic;
        MAR_Load_out                : out std_logic;
        PC_Load_out                 : out std_logic;
        PC_Inc_out                  : out std_logic;
        A_Load_out                  : out std_logic;
        B_Load_out                  : out std_logic;
        ALU_Sel_out                 : out std_logic_vector(3 downto 0);
        CCR_Load_out                : out std_logic;
        Bus1_sel_out                : out std_logic_vector(1 downto 0);
        Bus2_sel_out                : out std_logic_vector(1 downto 0);
        ALU_C_Load_out              : out std_logic;
        IR_out                      : out std_logic_vector(7 downto 0);
        CCR_Result_out              : out std_logic_vector(3 downto 0)
    );
end entity;

architecture RTL of CPU_8bit is

    component control_unit is
        port(
            CLK, RST            : in std_logic;
            wr                  : out std_logic;
            IR                  : in std_logic_vector(7 downto 0);
            CCR_Result          : in std_logic_vector(3 downto 0);
            IR_Load, MAR_Load, PC_Load, PC_Inc: out std_logic;
            A_Load, B_Load      : out std_logic;
            ALU_Sel             : out std_logic_vector(3 downto 0);
            CCR_Load            : out std_logic;
            Bus1_sel, Bus2_sel  : out std_logic_vector(1 downto 0);
            ALU_C_Load          : out std_logic
        );
    end component;

    component datapath is
        port(
            CLK, RST                            : in std_logic;
            IR_Load, MAR_Load, PC_Load, ALU_C_Load    : in std_logic;
            A_Load, B_Load, CCR_Load    : in std_logic;
            PC_Inc                          : in std_logic;
            ALU_Sel                         : in std_logic_vector(3 downto 0);
            Bus1_Sel, Bus2_Sel          : in std_logic_vector(1 downto 0);
            from_memory                     : in std_logic_vector(7 downto 0);
            IR, address, to_memory      : out std_logic_vector(7 downto 0);
            CCR_Result                      : out std_logic_vector(3 downto 0)
        );
    end component;

    signal IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load    : std_logic;
    signal ALU_Sel, CCR_Result          : std_logic_vector(3 downto 0);
    signal Bus1_sel, Bus2_sel           : std_logic_vector(1 downto 0);
    signal IR                           : std_logic_vector(7 downto 0);
    signal ALU_C_Load                   : std_logic;

begin
    I0 : control_unit port map(
        CLK => CLK, 
        RST => RST, 
        wr => wr, 
        IR => IR, 
        CCR_Result => CCR_Result, 
        IR_Load => IR_Load, 
        MAR_Load => MAR_Load, 
        PC_Load => PC_Load, 
        PC_Inc => PC_Inc, 
        A_Load => A_Load, 
        B_Load => B_Load, 
        ALU_Sel => ALU_Sel, 
        CCR_Load => CCR_Load, 
        Bus1_sel => Bus1_sel, 
        Bus2_sel => Bus2_sel, 
        ALU_C_Load => ALU_C_Load
    );
	 
    I1 : datapath port map(
        CLK => CLK, 
        RST => RST, 
        IR_Load => IR_Load, 
        MAR_Load => MAR_Load, 
        PC_Load => PC_Load, 
        ALU_C_Load => ALU_C_Load, 
        A_Load => A_Load, 
        B_Load => B_Load, 
        CCR_Load => CCR_Load, 
        PC_Inc => PC_Inc, 
        ALU_Sel => ALU_Sel, 
        Bus1_Sel => Bus1_sel, 
        Bus2_Sel => Bus2_sel, 
        from_memory => from_memory, 
        IR => IR, 
        address => address, 
        to_memory => to_memory, 
        CCR_Result => CCR_Result
    );

    IR_Load_out     <= IR_Load;
    MAR_Load_out    <= MAR_Load;
    PC_Load_out     <= PC_Load;
    PC_Inc_out      <= PC_Inc;
    A_Load_out      <= A_Load;
    B_Load_out      <= B_Load;
    ALU_Sel_out     <= ALU_Sel;
    CCR_Load_out    <= CCR_Load;
    Bus1_sel_out    <= Bus1_sel;
    Bus2_sel_out    <= Bus2_sel;
    ALU_C_Load_out  <= ALU_C_Load;
    IR_out          <= IR;
    CCR_Result_out  <= CCR_Result;

end architecture;