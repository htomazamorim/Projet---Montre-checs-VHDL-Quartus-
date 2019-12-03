library ieee;
use ieee.std_logic_1164.all;

entity contadorSeg is
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
end entity;

architecture contadores of contadorSeg is

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

signal RCO_C0 : std_logic;
signal RCO_C1 : std_logic;
signal RCO_C0_cent : std_logic;
signal RCO_C1_cent : std_logic;

signal enable_C0_cent : std_logic := jogadores and enable_all;
signal enable_C1_cent : std_logic := enable_C0_cent and RCO_C0_cent;
signal enable_C0 : std_logic := RCO_C1_cent and enable_C1_cent;
signal enable_C1 : std_logic := enable_C0 and RCO_C0;

begin

C0_cent : ContDec port map("0000", clk, preset_global, clear_all_n, enable_C0_cent, '0', out_C0_cent, RCO_C0_cent);
C1_cent : ContDec port map("0000", clk, preset_global, clear_all_n, enable_C1_cent, '0', out_C1_cent, RCO_C1_cent);
C0 : ContDec port map(input_LS, clk, preset_n, clear_all_n, enable_C0, '0', out_C0, RCO_C0);
C1 : ContDec port map(input_MS, clk, preset_n, clear_all_n, enable_C1, '0', out_C1, RCO_C1);




end contadores;