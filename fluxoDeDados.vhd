library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fluxoDeDados is
	port(
		clk50, clk_botao: in std_logic;
		preset_global : in std_logic;
		habilitaSoma : in std_logic;
		zeraBrons : in std_logic;
		enable_all : in std_logic;
		clear_all_n : in std_logic;
		switch_counter : in std_logic;
		switch_mode : in std_logic;
		FB : in std_logic;
		out_D1, out_D2, out_D3, out_D4, out_D5, out_D6 : out std_logic_vector(6 downto 0)
		);
end entity;


architecture reg of fluxoDeDados is

component divClock is
	port(
		clk50Mhz : in std_logic;
		clk1 : out std_logic;
		clk100 : out std_logic;
		clk1000 : out std_logic;
		clk440 : out std_logic;
		clk1760 : out std_logic
);
end component;

component ContDec is
	port(
		input : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		load_n : in std_logic;
		clear_n : in std_logic;
		enable : in std_logic;
		crescente : in std_logic;
		output : out std_logic_vector(3 downto 0);
		rco : out std_logic);
end component;

component displays7Seg is
	port(
		inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6 : in std_logic_vector(3 downto 0);
		out_D1, out_D2, out_D3, out_D4, out_D5, out_D6 : out std_logic_vector(6 downto 0)
	);
end component;

component somador4b is
port(
	cin : in std_logic;
	a,b : in std_logic_vector(3 downto 0);
	s : out std_logic_vector(3 downto 0);
	cout : out std_logic
);
end component;

component contadorSeg is
	port(
		clk : in std_logic;
		preset_global : in std_logic;
		preset_n : in std_logic;
		input_LS, input_MS : in std_logic_vector(3 downto 0);
		jogadores : in std_logic;
		enable_all : in std_logic;
		clear_all_n : in std_logic;
		out_C0_cent, out_C1_cent, out_C0, out_C1 : out std_logic_vector(3 downto 0)
		);
end component;

component selecionaSaida is
	port(
		muxSelector : in std_logic_vector(1 downto 0);
		out_C0_1_cent, out_C1_1_cent, out_C0_2_cent, out_C1_2_cent : in std_logic_vector(3 downto 0); 
		out_C0_1, out_C1_1, out_C0_2, out_C1_2 : in std_logic_vector(3 downto 0);
		inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6 : out std_logic_vector(3 downto 0)
	);
end component;

component clkSelecao is
	port(
		clkSelector : in std_logic_vector(1 downto 0);
		clkBotao_NEG, clk100 : in std_logic;
		clk_C1, clk_C2 : out std_logic
	);
end component;

component regn IS
	PORT (R : IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	Rin, Clock: IN STD_LOGIC ;
	Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) ) ;
end component ;

-- Sinais auxiliares
signal habilitaSoma_NEG : std_logic := not(habilitaSoma);
signal switch_counter_NEG : std_logic := not(switch_counter);

-- Clocks
signal clk1 : std_logic;
signal clk100 : std_logic;
signal clk_C1 : std_logic;
signal clk_C2 : std_logic;
signal clkBotao_Neg : std_logic := not(clk_botao);

-- Saídas dos contadores do jogador 1
signal out_C0_1_cent : std_logic_vector(3 downto 0);
signal out_C1_1_cent : std_logic_vector(3 downto 0);
signal out_C0_1 : std_logic_vector(3 downto 0);
signal out_C1_1 : std_logic_vector(3 downto 0);

-- Saídas dos contadores do jogador 2
signal out_C0_2_cent : std_logic_vector(3 downto 0);
signal out_C1_2_cent : std_logic_vector(3 downto 0);
signal out_C0_2 : std_logic_vector(3 downto 0);
signal out_C1_2 : std_logic_vector(3 downto 0);

-- Entradas dos displays de 7 segmentos
signal inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6 : std_logic_vector(3 downto 0);

-- Seletor = escolha de Jogador + Modo de jogo
signal muxSelector : std_logic_vector(1 downto 0) := switch_counter&switch_mode;

-- Seleçção do modo Fischer ou Bronstein
--signal FB : std_logic := '1';

-- Entradas e saidas do somador (valor a ser somado)
signal delta : std_logic_vector(3 downto 0);
signal cOut_MS, cOut_LS : std_logic;
signal out_C_LS, out_C_MS : std_logic_vector(3 downto 0);
signal MS_out, LS_out : std_logic_vector(3 downto 0);

-- Entradas dos Contadores principais
signal input_LS : std_logic_vector(3 downto 0);
signal input_MS : std_logic_vector(3 downto 0);

-- Presets dos contadores principais
signal preset_n_1 : std_logic := (habilitaSoma_NEG or not (switch_counter) ) and preset_global;
signal preset_n_2 : std_logic := (habilitaSoma_NEG or switch_counter) and preset_global;

-- Entradas e saidas dos contadores paralelos
signal paralelo1MenorQueDelta : std_logic;
signal paralelo2MenorQueDelta : std_logic;

signal enb_ParaleloCont1 : std_logic := paralelo1MenorQueDelta and not(switch_counter);
signal out_ParaleloCont1 : std_logic_vector(3 downto 0);

signal enb_ParaleloCont2 : std_logic := paralelo2MenorQueDelta and switch_counter;
signal out_ParaleloCont2 : std_logic_vector(3 downto 0);

signal out_ParaleloCont : std_logic_vector(3 downto 0);

signal clkSelector : std_logic_vector(1 downto 0) := preset_global&switch_counter;

begin

paralelo1MenorQueDelta <= '1' when (out_ParaleloCont1 < "0101") else '0';
paralelo2MenorQueDelta <= '1' when (out_ParaleloCont2 < "0101") else '0';

div : divClock port map(clk50, clk1, clk100, open, open, open);

contador_paralelo1 : ContDec port map("0101", clk1, '1', not(zeraBrons), enb_ParaleloCont1, '1', out_ParaleloCont1, open);
contador_paralelo2 : ContDec port map("0101", clk1, '1', zeraBrons, enb_ParaleloCont2, '1', out_ParaleloCont2, open);

-- Seleção do contador
with switch_counter select
out_ParaleloCont <= out_ParaleloCont2 when '0', out_ParaleloCont1 when '1';

-- Decisão do valor de delta
with FB select
delta <= "0101"					when '0', 
			out_ParaleloCont		when '1';


-- Definição das entradas do somador
with switch_counter select
out_C_LS <= out_C0_2 when '0',
				out_C0_1 when '1';
				
with switch_counter select
out_C_MS <= out_C1_2 when '0',
				out_C1_1 when '1';


s_LS : somador4b port map('0', out_C_LS, delta, LS_out, cOut_LS);
s_MS : somador4b port map(cOut_LS, out_C_MS, "0000", MS_out, cOut_MS);


-- Definição das entradas de load dos contadores
with preset_global select
input_LS <= "0000"	when '0', 
				LS_out	when '1';


with preset_global select
input_MS <= MS_out	when '1', 
				"0001"	when '0';

-- Seleção de clock : clk100 ou preset_global ou clk_botao(para o Fiscer/Bronstein)
clkSelect : clkSelecao port map (clkSelector, clkBotao_NEG, clk100, clk_C1, clk_C2);

Cont1 : contadorSeg port map(clk_c1, preset_global, preset_n_1, input_LS, input_MS, not(switch_counter), enable_all, clear_all_n, out_C0_1_cent, out_C1_1_cent, out_C0_1, out_C1_1);
Cont2 : contadorSeg port map(clk_c2, preset_global, preset_n_2, input_LS, input_MS, switch_counter, enable_all, clear_all_n, out_C0_2_cent, out_C1_2_cent, out_C0_2, out_C1_2);			

muxSaida : selecionaSaida port map(muxSelector, out_C0_1_cent, out_C1_1_cent, out_C0_2_cent, out_C1_2_cent,
out_C0_1, out_C1_1, out_C0_2, out_C1_2, inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6);

displays : displays7Seg port map(inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6,
											out_D1, out_D2, out_D3, out_D4, out_D5, out_D6);
											
end architecture;