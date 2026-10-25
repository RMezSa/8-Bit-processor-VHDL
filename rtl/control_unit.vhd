-- Nombre del archivo: control_unit.vhd
-- Descripción: Unidad de control del CPU, máquina de estados
-- Dependencias: 
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
	port(
		CLK, RST			: in std_logic;
		wr 				: out std_logic;
		IR 				: in std_logic_vector(7 downto 0);
		CCR_Result 		: in std_logic_vector(3 downto 0);
		IR_Load, MAR_Load, PC_Load, PC_Inc: out std_logic;
		A_Load, B_Load : out std_logic;
		ALU_Sel 			: out std_logic_vector(3 downto 0);
		CCR_Load			: out std_logic;
		Bus1_sel, Bus2_sel 	: out std_logic_vector(1 downto 0);
		ALU_C_Load 		: out std_logic
	);
end entity;

architecture RTL of control_unit is
Type FSM is (	IDLE,											--IDLE de la maquina de estados
					F0, F1, F2, DS,							--CICLO FETCH Y DECODE
					Op86A, Op86B, Op86C,						--LDA_INM
					Op87A, Op87B, Op87C, 					--LDB_INM
					Op88A, Op88B, Op88C, Op88D, Op88E, 	--LDA_DIR
					Op89A, Op89B, Op89C, Op89D, Op89E, 	--LDB_DIR
					Op96A, Op96B, Op96C, Op96D, --STORE_A
					Op97A, Op97B, Op97C, Op97D, --STORE_B
					Op40,					--ADD_AB
					Op41, Op41B,		--SUB_AB
					Op42,		--AND_AB
					Op43,		--OR_AB
					Op44,		--XOR_AB
					Op45,		--INC_A
					Op46,		--INC_B
					Op47,		--DEC_A
					Op48,		--DEC_B
					Op50,		--NOT_A
					Op51,		--NOT_B
					--Op52,		--SHL_A
					--Op53,		--SHR_A
					Op20, Op20A, Op20B,			--JMP
					Op21, Op21A, Op21B, Op21C, --JN
					Op22, Op22A, Op22B, Op22C, --JNN
					Op23, Op23A, Op23B, Op23C, --JZ
					Op24, Op24A, Op24B, Op24C, --JNZ
					Op25, Op25A, Op25B, Op25C, --JOV
					Op26, Op26A, Op26B, Op26C, --JNOV
					Op27, Op27A, Op27B, Op27C,  --JC
					Op28, Op28A, Op28B, Op28C); --JNC
				
	signal EDO, EDOF: FSM;
	signal N, Z, O, C : std_logic;
	
	begin
	--Flags
    N <= CCR_Result(3);
    Z <= CCR_Result(2);
    O <= CCR_Result(0);
    C <= CCR_Result(1);
	
	process(clk, rst)
		begin
		 if rst = '0' then
			  EDO <= IDLE;
		 elsif rising_edge(clk) then
			  EDO <= EDOF;
		 end if;
	end process;

	
	P0: process (EDO, IR, N, Z, O, C)
		BEGIN
		EDOF <= EDO;
			case EDO is
				when IDLE =>
					EDOF <= F0;
				when F0 => 
					EDOF <= F1;
				when F1 =>
					EDOF <= F2;
				when F2 => 
					EDOF <= DS;
				when DS =>
				if (IR = x"86") then
					EDOF <= Op86A;
				elsif (IR = x"87") then
					EDOF <= Op87A;
				elsif (IR = x"88") then
					EDOF <= Op88A;
				elsif (IR = x"89") then
					EDOF <= Op89A;
				elsif (IR = x"96") then
					EDOF <= Op96A;
				elsif (IR = x"97") then
					EDOF <= Op97A;
				elsif (IR = x"40") then
					EDOF <= Op40;
				elsif (IR = x"41") then
					EDOF <= Op41;
				elsif (IR = x"42") then
					EDOF <= Op42;
				elsif (IR = x"43") then
					EDOF <= Op43;
				elsif (IR = x"44") then
					EDOF <= Op44;
				elsif (IR = x"45") then
					EDOF <= Op45;
				elsif (IR = x"46") then
					EDOF <= Op46;
				elsif (IR = x"47") then
					EDOF <= Op47;
				elsif (IR = x"48") then
					EDOF <= Op48;
				elsif (IR = x"50") then
					EDOF <= Op50;
				elsif (IR = x"51") then
					EDOF <= Op51;
				elsif (IR = x"20") then
					EDOF <= Op20;
				elsif (IR = x"21") then
					if (N = '0') then
						EDOF <= Op21;
					else
						EDOF <= Op21A;
					end if;
				elsif (IR = x"22") then
					if (N = '0') then
						EDOF <= Op22;
					else
						EDOF <= Op22A;
					end if;
				elsif (IR = x"23") then
					if (Z = '0') then 
						EDOF <= Op23;
					else
						EDOF <= Op23A;
					end if;
				elsif (IR = x"24") then
					if(Z = '0') then
						EDOF <= Op24;
					else
						EDOF <= Op24A;
					end if;
				elsif (IR = x"25") then
					if(O = '0') then
						EDOF <= Op25;
					else
						EDOF <= Op25A;
					end if;
				elsif (IR = x"26") then
					if(O = '0') then
						EDOF <= Op26;
					else
						EDOF <= Op26A;
					end if;
				elsif (IR = x"27") then
					if(C = '0') then
						EDOF <= Op27;
					else
						EDOF <= Op27A;
					end if;
				elsif (IR = x"28") then
					if(C = '0') then
						EDOF <= Op28;
					else
						EDOF <= Op28A;
					end if;
				end if;
				
				when Op20 =>
					EDOF <= Op20A;
					
				when Op21 =>
					EDOF <= IDLE;
					
				when Op22 =>
					EDOF <= IDLE;
					
				when Op23 =>
					EDOF <= IDLE;
					
				when Op24 =>
					EDOF <= IDLE;
					
				when Op25 =>
					EDOF <= IDLE;
					
				when Op26 =>
					EDOF <= IDLE;
					
				when Op27 =>
					EDOF <= IDLE;
					
				when Op28 =>
					EDOF <= IDLE;
					
				

				when Op20A =>
					EDOF <= Op20B;
				
				when Op21A =>
					EDOF <= Op21B;
				
				when Op22A =>
					EDOF <= Op22B;
				
				when Op23A =>
					EDOF <= Op23B;
				
				when Op24A =>
					EDOF <= Op24B;
				
				when Op25A =>
					EDOF <= Op25B;
				
				when Op26A =>
					EDOF <= Op26B;
				
				when Op27A =>
					EDOF <= Op27B;
				
				when Op28A =>
					EDOF <= Op28B;
				
				when Op20B =>
					EDOF <= IDLE;
					
				when Op21B =>
					EDOF <= Op21C;
				
				when Op22B =>
					EDOF <= Op22C;
					
				when Op23B =>
					EDOF <= Op23C;
					
				when Op24B =>
					EDOF <= Op24C;
				
				when Op25B =>
					EDOF <= Op25C;
				
				when Op26B =>
					EDOF <= Op26C;
				
				when Op27B =>
					EDOF <= Op27C;
				
				when Op28B =>
					EDOF <= Op28C;
				
				
				when Op21C =>
					EDOF <= IDLE;
					
				when Op22C =>
					EDOF <= IDLE;
				
				when Op23C =>
					EDOF <= IDLE;
				
				when Op24C =>
					EDOF <= IDLE;
				
				when Op25C =>
					EDOF <= IDLE;
				
				when Op26C =>
					EDOF <= IDLE;
				
				when Op27C =>
					EDOF <= IDLE;
				
				when Op28C =>
					EDOF <= IDLE;
				
				
				when Op86A =>
					EDOF <= Op86B;
					
				when Op87A =>
					EDOF <= Op87B;
					
				when Op88A =>
					EDOF <= Op88B;
					
				when Op89A =>
					EDOF <= Op89B;
					
				when Op96A =>
					EDOF <= Op96B;
					
				when Op97A =>
					EDOF <= Op97B;
					
				
				when Op86B =>
					EDOF <= Op86C;
					
				when Op87B =>
					EDOF <= Op87C;
					
				when Op88B =>
					EDOF <= Op88C;
					
				when Op89B =>
					EDOF <= Op89C;
					
				when Op96B =>
					EDOF <= Op96C;
					
				when Op97B =>
					EDOF <= Op97C;
					
					
				when Op86C =>
					EDOF <= IDLE;
					
				when Op87C =>
					EDOF <= IDLE;
				
				when Op88C =>
					EDOF <= Op88D;
					
				when Op89C =>
					EDOF <= Op89D;
					
				when Op96C =>
					EDOF <= Op96D;
					
				when Op97C =>
					EDOF <= Op97D;
				
				
				when Op88D =>
					EDOF <= Op88E;
					
				when Op89D =>
					EDOF <= Op89E;
					
				when Op96D =>
					EDOF <= IDLE;
					
				when Op97D =>
					EDOF <= IDLE;
					
				
				when Op40 =>
					EDOF <= IDLE;
					
				when Op41 =>
					EDOF <= Op41B;
					
				when Op41B =>
					EDOF <= IDLE;
					
				when Op42 =>
					EDOF <= IDLE;
					
				when Op43 =>
					EDOF <= IDLE;
					
				when Op44 =>
					EDOF <= IDLE;
					
				when Op45 =>
					EDOF <= IDLE;
					
				when Op46 =>
					EDOF <= IDLE;
					
				when Op47 =>
					EDOF <= IDLE;
					
				when Op48 =>
					EDOF <= IDLE;
					
				when Op50 =>
					EDOF <= IDLE;
					
				when Op51 =>
					EDOF <= IDLE;
					
				when Op88E =>
					EDOF <= IDLE;
    
				when Op89E =>
					EDOF <= IDLE;
					
				when others =>
					EDOF <= IDLE;
					
			end case;
	
	end process;

	P1: process(EDO) 
	
	begin 
	case EDO is
		
	--	when F0 => -- Fetch 1
	--						IR_Load  <= '0';
	--						MAR_Load <= '0';
	--						PC_Load 	<= '0';
	--						PC_Inc 	<= '0';
	--						A_Load	<= '0';
	--						B_Load 	<= '0';
	--						ALU_Sel 	<= "0000";
	--						CCR_Load <= '0';
	--						Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
	--						Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
	--						WR       <= '0';
	--	
	
		when IDLE => -- IDLE DE LA MAQUINA DE CONTROL
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when F0 => --IDLE DE LA MAQUINA DE ESTADOS 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when F1 => -- Fetch 1
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
			
		when F2 => -- Fetch 1
							IR_Load  <= '1';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		-------------	
		-- Decode----
		-------------
		when DS => -- PARA DECODE
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		------------
		--LDA_INM A, B, C
		----
		when Op86A => -- LDA_INM A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';

		when Op86B => -- LDA_INM B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op86C => -- LDA_INM C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		----------------
		----LDB_INM
		----------------
		when Op87A => -- LDB_INM A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';

		when Op87B => -- LDB_INM B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op87C => -- LDB_INM C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '1';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		----------
		-- LDA_DIR
		----------
		
		when Op88A => -- LDA_DIR A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op88B => -- LDA_DIR B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op88C => -- LDA_DIR C
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op88D => -- LDA_DIR D
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op88E => -- LDA_DIR E
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		----------
		-- LDB_DIR
		----------
		
		when Op89A => -- LDB_DIR A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op89B => -- LDB_DIR B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op89C => -- LDB_DIR C
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op89D => -- LDB_DIR D
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op89E => -- LDB_DIR E
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '1';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		----------
		--- STOREA
		----------
		
		when Op96A => -- STORE_A A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op96B => -- STORE_A B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op96C => -- STORE_A C
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op96D => -- STORE_A D
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '1';
							ALU_C_Load <= '0';
		
		----------
		--- STORE_B
		----------
		
		when Op97A => -- STORE_B A
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op97B => -- STORE_B B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op97C => -- STORE_B C
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		when Op97D => -- STORE_B D
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "10"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '1';
							ALU_C_Load <= '0';
		
		-------------
		--- ADD_AB
		-------------
		
		when Op40 => -- ADD_AB
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "0111";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		----------
		--- SUB_AB
		----------
	
		
		when Op41 => -- Negar B
							 IR_Load  <= '0';
							 MAR_Load <= '0';
							 PC_Load  <= '0';
							 PC_Inc   <= '0';
							 A_Load   <= '0';    -- 
							 B_Load   <= '1';    -- 
							 ALU_Sel  <= "0011"; -- Operación NOT B (ver tu ALU: notB <= '1' cuando Cont="0011")
							 CCR_Load <= '0';    -- No actualizar flags aún
							 Bus1_Sel <= "10";   -- "10"= B (para negarlo)
							 Bus2_Sel <= "00";   -- "00"= ALU (resultado de NOT B)
							 WR       <= '0';
							 ALU_C_Load <= '0';
							 
		when Op41B => -- A-B
							 IR_Load  <= '0';
							 MAR_Load <= '0';
							 PC_Load  <= '0';
							 PC_Inc   <= '0';
							 A_Load   <= '1';    
							 B_Load   <= '0';
							 ALU_Sel  <= "0111"; 
							 CCR_Load <= '1';    
							 Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							 Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory  
							 WR       <= '0';
							 ALU_C_Load <= '1';
							
		------------
		-- AND_AB
		------------
		
		when Op42 => -- AND AB
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '1';
							ALU_Sel 	<= "0010";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		------------
		-- OR_AB
		------------
		
		when Op43 => -- OR AB
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '1';
							ALU_Sel 	<= "0110";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		------------
		-- XOR_AB
		------------
		
		when Op44 => -- XOR AB
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '1';
							ALU_Sel 	<= "0101";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';	
							ALU_C_Load <= '0';
			
		------------
		-- INC_A
		------------
		
		when Op45 => -- INC A
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "1000";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '1';
		
		
		------------
		-- INC_B
		------------
		
		when Op46 => -- INC B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '1';
							ALU_Sel 	<= "1001";
							CCR_Load <= '1';
							Bus1_Sel <= "10"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '1';
							
		------------
		--- DEC_A
		------------
		when Op47 => -- DEC A
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "1010";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '1';
							
		------------
		--- DEC_B
		------------
		when Op48 => -- DEC B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '1';
							ALU_Sel 	<= "1011";
							CCR_Load <= '1';
							Bus1_Sel <= "10"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '1';
		
		
		
		
		-----------
		--- NOT_A
		-----------
			
		when Op50 => -- negar A
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '1';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '1';
							Bus1_Sel <= "01"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-----------
		--- NOT_B
		-----------
			
		when Op51 => -- negar B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '1';
							ALU_Sel 	<= "0001";
							CCR_Load <= '1';
							Bus1_Sel <= "10"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		--------------
		--- JMP - A, B
		--------------
		when Op20 => -- JMP
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
			
		when Op20A => -- JMP A
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
			
			
		when Op20B => -- JMP B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		-----------
		---- JN-  Salta si N = 1
		-----------
		when Op21 => -- JN N = 0
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		when Op21A => -- JNA  N = 1
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op21B => -- JMP B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op21C => -- JMP B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
							
		-----------
		---- JNN- Salta si N = 0
		-----------
		when Op22 => -- JN N = 1
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		-- Cuando N = 0
		when Op22A =>
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op22B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op22C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		-----------
		---- JZ- Salta si Z = 1
		-----------
		when Op23 => -- JZ Z = 0
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando Z = 1
		when Op23A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op23B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op23C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
							
		-----------
		---- JNZ- Salta si Z = 0
		-----------
		when Op24 => -- JNZ   Z = 1
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando Z = 0
		when Op24A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op24B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op24C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		
		-----------
		---- JOV- Salta si V = 1
		-----------
		when Op25 => -- JOV V = 0
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando V = 1
		when Op25A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op25B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op25C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		
		-----------
		---- JNOV- Salta si V = 0
		-----------
		when Op26 => -- JOV V = 1
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando V = 0
		when Op26A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op26B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op26C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		-----------
		---- JC- Salta si C = 1
		-----------
		when Op27 => -- JC C = 0
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando C = 1
		when Op27A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op27B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op27C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		
		-----------
		---- JNC- Salta si C = 0
		-----------
		when Op28 => -- JNC C = 1
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '1';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		
		-- Cuando C = 0
		when Op28A => -- 
							IR_Load  <= '0';
							MAR_Load <= '1';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "01"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op28B => -- JNN B
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '0';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "00"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
							
		when Op28C => -- JNN C
							IR_Load  <= '0';
							MAR_Load <= '0';
							PC_Load 	<= '1';
							PC_Inc 	<= '0';
							A_Load	<= '0';
							B_Load 	<= '0';
							ALU_Sel 	<= "0000";
							CCR_Load <= '0';
							Bus1_Sel <= "00"; -- "00"= PC, "01"= A, "10"= B
							Bus2_Sel <= "10"; -- "00"= ALU, "01"= Bus1, "10"= from_memory
							WR       <= '0';
							ALU_C_Load <= '0';
		
		
			
	end case;
	end process P1;

end architecture;