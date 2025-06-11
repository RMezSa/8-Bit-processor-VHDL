-- Nombre del archivo: Top_Level_Entity.vhd
-- Descripción: Top Level Entity del CPU de 8 bits con señales de control expuestas
-- Dependencias: CPU_8bit.vhd (modificado), memoria.vhd, etc.
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Top_Level_Entity is 
    port(
        -- Entradas básicas
        CLK_10, RST            : in std_logic;
        
        -- Puertos entrada
        p_in_00, p_in_01, p_in_02, p_in_03     : in std_logic_vector(7 downto 0);
        p_in_04, p_in_05, p_in_06, p_in_07     : in std_logic_vector(7 downto 0);
        p_in_08, p_in_09, p_in_10, p_in_11     : in std_logic_vector(7 downto 0);
        p_in_12, p_in_13, p_in_14, p_in_15     : in std_logic_vector(7 downto 0);
    
        -- Puertos salida
        p_out_00, p_out_01, p_out_02, p_out_03  : out std_logic_vector(7 downto 0);
        p_out_04, p_out_05, p_out_06, p_out_07  : out std_logic_vector(7 downto 0);
        p_out_08, p_out_09, p_out_10, p_out_11  : out std_logic_vector(7 downto 0);
        p_out_12, p_out_13, p_out_14, p_out_15  : out std_logic_vector(7 downto 0);
        
        to_memory_s, from_memory_s, address_s   : out std_logic_vector(7 downto 0);
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
        CCR_Result_out              : out std_logic_vector(3 downto 0);
        wr_out                      : out std_logic
    );
end entity;

architecture RTL of Top_Level_Entity is
		component CPU_8bit is
			port(
            CLK, RST                    : in std_logic;
            wr                          : out std_logic;
            from_memory                 : in std_logic_vector(7 downto 0);
            to_memory, address          : out std_logic_vector(7 downto 0);
            -- Señales para comprobar las salidas
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
		end component;

		component memoria is
			port(
            clk, rst, wr               : in std_logic;
            address                    : in std_logic_vector(7 downto 0);
            data_in                    : in std_logic_vector(7 downto 0);
            data_out                   : out std_logic_vector(7 downto 0);
            
            p_in_00, p_in_01, p_in_02, p_in_03     : in std_logic_vector(7 downto 0);
            p_in_04, p_in_05, p_in_06, p_in_07     : in std_logic_vector(7 downto 0);
            p_in_08, p_in_09, p_in_10, p_in_11     : in std_logic_vector(7 downto 0);
            p_in_12, p_in_13, p_in_14, p_in_15     : in std_logic_vector(7 downto 0);
        
            p_out_00, p_out_01, p_out_02, p_out_03  : out std_logic_vector(7 downto 0);
            p_out_04, p_out_05, p_out_06, p_out_07  : out std_logic_vector(7 downto 0);
            p_out_08, p_out_09, p_out_10, p_out_11  : out std_logic_vector(7 downto 0);
            p_out_12, p_out_13, p_out_14, p_out_15  : out std_logic_vector(7 downto 0)
        );
		end component;
	 
		component CLK_1K is
			Port (clk_50  : in  std_logic;  
					RST  : in  std_logic;  
					clk : out std_logic); 
		end component;

    signal CLK                         : std_logic;
    signal address                     : std_logic_vector(7 downto 0);
    signal wr                          : std_logic;
    signal to_memory, from_memory      : std_logic_vector(7 downto 0);

    -- Señales internas para conectar con el CPU
    signal IR_Load_int                 : std_logic;
    signal MAR_Load_int                : std_logic;
    signal PC_Load_int                 : std_logic;
    signal PC_Inc_int                  : std_logic;
    signal A_Load_int                  : std_logic;
    signal B_Load_int                  : std_logic;
    signal ALU_Sel_int                 : std_logic_vector(3 downto 0);
    signal CCR_Load_int                : std_logic;
    signal Bus1_sel_int                : std_logic_vector(1 downto 0);
    signal Bus2_sel_int                : std_logic_vector(1 downto 0);
    signal ALU_C_Load_int              : std_logic;
    signal IR_int                      : std_logic_vector(7 downto 0);
    signal CCR_Result_int              : std_logic_vector(3 downto 0);

begin
    --CLK <= CLK_10;
	
		CLOCK : CLK_1K port map(CLK_10, RST, CLK);
    
		I0 : CPU_8bit port map(
			  CLK => CLK, 
			  RST => RST, 
			  wr => wr, 
			  from_memory => from_memory, 
			  to_memory => to_memory, 
			  address => address,
			  
			  -- Señales
			  IR_Load_out => IR_Load_int,
			  MAR_Load_out => MAR_Load_int,
			  PC_Load_out => PC_Load_int,
			  PC_Inc_out => PC_Inc_int,
			  A_Load_out => A_Load_int,
			  B_Load_out => B_Load_int,
			  ALU_Sel_out => ALU_Sel_int,
			  CCR_Load_out => CCR_Load_int,
			  Bus1_sel_out => Bus1_sel_int,
			  Bus2_sel_out => Bus2_sel_int,
			  ALU_C_Load_out => ALU_C_Load_int,
			  
			  -- Señales
			  IR_out => IR_int,
			  CCR_Result_out => CCR_Result_int
		 );

		-- Memoria
		 I1 : memoria port map(
			  clk => CLK, 
			  rst => RST, 
			  wr => wr, 
			  address => address, 
			  data_in => to_memory, 
			  data_out => from_memory,
			  
			  p_in_00 => p_in_00, p_in_01 => p_in_01, p_in_02 => p_in_02, p_in_03 => p_in_03,
			  p_in_04 => p_in_04, p_in_05 => p_in_05, p_in_06 => p_in_06, p_in_07 => p_in_07,
			  p_in_08 => p_in_08, p_in_09 => p_in_09, p_in_10 => p_in_10, p_in_11 => p_in_11,
			  p_in_12 => p_in_12, p_in_13 => p_in_13, p_in_14 => p_in_14, p_in_15 => p_in_15,
			  
			  p_out_00 => p_out_00, p_out_01 => p_out_01, p_out_02 => p_out_02, p_out_03 => p_out_03,
			  p_out_04 => p_out_04, p_out_05 => p_out_05, p_out_06 => p_out_06, p_out_07 => p_out_07,
			  p_out_08 => p_out_08, p_out_09 => p_out_09, p_out_10 => p_out_10, p_out_11 => p_out_11,
			  p_out_12 => p_out_12, p_out_13 => p_out_13, p_out_14 => p_out_14, p_out_15 => p_out_15
		 );
    
		 to_memory_s <= to_memory;
		 address_s <= address;
		 from_memory_s <= from_memory;
		 wr_out <= wr;
		 --
		 IR_Load_out <= IR_Load_int;
		 MAR_Load_out <= MAR_Load_int;
		 PC_Load_out <= PC_Load_int;
		 PC_Inc_out <= PC_Inc_int;
		 A_Load_out <= A_Load_int;
		 B_Load_out <= B_Load_int;
		 ALU_Sel_out <= ALU_Sel_int;
		 CCR_Load_out <= CCR_Load_int;
		 Bus1_sel_out <= Bus1_sel_int;
		 Bus2_sel_out <= Bus2_sel_int;
		 ALU_C_Load_out <= ALU_C_Load_int;
		 --
		 IR_out <= IR_int;
		 CCR_Result_out <= CCR_Result_int;

end architecture;