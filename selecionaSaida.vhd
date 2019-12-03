library ieee;
use ieee.std_logic_1164.all;

entity selecionaSaida is
	port(
		muxSelector : in std_logic_vector(1 downto 0);
		out_C0_1_cent, out_C1_1_cent, out_C0_2_cent, out_C1_2_cent : in std_logic_vector(3 downto 0); 
		out_C0_1, out_C1_1, out_C0_2, out_C1_2 : in std_logic_vector(3 downto 0);
		inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6 : out std_logic_vector(3 downto 0)
	);
end selecionaSaida;

architecture selecao of selecionaSaida is

begin

-- Seleção das saída em função do modo de jogo e do jogador selecionado
with muxSelector select
	inp_D1 <=	out_C1_2 when "11",
					out_C1_1 when others;

with muxSelector select
	inp_D2 <=	out_C0_2 when "11",
					out_C0_1 when others;

with muxSelector select
	inp_D3 <=	"1111" 			when "00",
					out_C1_1_cent 	when "01",
					"1111" 			when "10",
					out_C1_2_cent 	when "11";
					
with muxSelector select
	inp_D4 <=	"1111" 			when "00",
					out_C0_1_cent 	when "01",
					"1111" 			when "10",
					out_C0_2_cent 	when "11";

with muxSelector select
	inp_D5 <=	out_C1_2 		when "00",
					"1111" 			when "01",
					out_C1_2 		when "10",
					"1111" 			when "11";
					
with muxSelector select
	inp_D6 <=	out_C0_2 		when "00",
					"0001" 			when "01",
					out_C0_2			when "10",
					"0010" 			when "11";


end selecao;