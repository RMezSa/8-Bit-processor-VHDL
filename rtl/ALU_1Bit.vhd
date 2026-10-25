-- Nombre del archivo: ALU_1Bit.vhd
-- Descripción: ALU de 1 bit para instanciar
-- Dependencias: HA.vhd
-- Autor: Roberd Otoniel Meza Sainz

library ieee;
use ieee.std_logic_1164.all;

entity ALU_1Bit is
	port(
		A 		: in std_logic;
		B		: in std_logic;
		Cont	: in std_logic_vector(3 downto 0);
		Cin	: in std_logic;
		S		: out std_logic;
		Cout 	: out std_logic
	);

end entity;

architecture RTL of ALU_1Bit is
	component HA is 
		port(A, B: in std_logic; 
		S, Co: out std_logic);
	end component;
	
	-- Control --
	signal NA : std_logic;
	signal NB : std_logic;
	signal AandB: std_logic;
	signal notB : std_logic;
	signal notA : std_logic;
	signal AxorB: std_logic;
	signal AorB: std_logic;
	signal ApB: std_logic;
	--signal AmB: std_logic;
	signal IA : std_logic;
	signal IB : std_logic;
	signal DA : std_logic;
	signal DB : std_logic;
	
	-- Suma y Carry de los HA
	signal S_HA_1 : std_logic;
	signal C_HA_1 : std_logic;
	signal S_HA_2 : std_logic;
	signal C_HA_2 : std_logic;
	
	begin
	--Eleccion de operacion
		with Cont select
		NA    <= '1' when "0000", '0' when others;
	with Cont select
		NB    <= '1' when "0001", '0' when others;
	with Cont select
		AandB   <= '1' when "0010", '0' when others;
	with Cont select
		notB <= '1' when "0011", '0' when others;
	with Cont select
		notA    <= '1' when "0100", '0' when others;
	with Cont select
		AxorB    <= '1' when "0101", '0' when others;
	with Cont select
		AorB <= '1' when "0110", '0' when others;
	with Cont select
		ApB  <= '1' when "0111", '0' when others;
	with Cont select 
		IA <= '1' when "1000", '0' when others;
	with Cont select 
		IB <= '1' when "1001", '0' when others;
	with Cont select 
		DA <= '1' when "1010", '0' when others;
	with Cont select 
		DB <= '1' when "1011", '0' when others;
	--with Cont select
		--AmB <= '1' when "1100", '0' when others;
		
	
	-- Half Adders
	I0 : HA port map(A xor NA, B xor NB, S_HA_1, C_HA_1);
	I1 : HA port map(NA or NB or Cin, S_HA_1, S_HA_2, C_HA_2);
	Cout <= C_HA_1 or C_HA_2;
	
--	S <= (ApB and S_HA_2) or ((C_HA_1 and AandB) or (  notB and not(B xor NB)) or ( notA and not (A xor NA)) or (AxorB and S_HA_1) or (AorB and ((A xor NA) or (B xor NB))));
	
	
	--Eleccion del resultado en S (suma) según la operacion elegida
	S <= (ApB and S_HA_2) or 
     ((C_HA_1 and AandB) or 
     (notB and not(B xor NB)) or 
     (notA and not(A xor NA)) or 
     (AxorB and S_HA_1) or 
     (AorB and ((A xor NA) or (B xor NB))) or
     (IA and (A xor '0' xor Cin)) or
     (IB and (B xor '0' xor Cin)) or
     (DA and (A xor '1' xor Cin)) or
     (DB and (B xor '1' xor Cin)));
	  
end architecture;