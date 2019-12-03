library ieee;
use ieee.std_logic_1164.all;

entity clkSelecao is
	port(
		clkSelector : in std_logic_vector(1 downto 0);
		clkBotao_NEG, clk100 : in std_logic;
		clk_C1, clk_C2 : out std_logic
	);
end clkSelecao;

architecture selecao of clkSelecao is

begin 

with clkSelector select
clk_C1 <= 	clkBotao_NEG		when "11",
				clk100				when others;

with clkSelector select
clk_C2 <= 	clkBotao_NEG		when "10", 
				clk100				when others;


end selecao;