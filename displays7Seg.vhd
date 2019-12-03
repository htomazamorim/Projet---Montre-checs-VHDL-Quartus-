library ieee;
use ieee.std_logic_1164.all;

entity displays7Seg is
	port(
		inp_D1, inp_D2, inp_D3, inp_D4, inp_D5, inp_D6 : in std_logic_vector(3 downto 0);
		out_D1, out_D2, out_D3, out_D4, out_D5, out_D6 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture displays of displays7Seg is

component setesegmentos is
	port(
		entrada: in std_logic_vector(3 downto 0);
		saida:  out std_logic_vector(6 downto 0)
	);
end component;

begin

D1 : setesegmentos port map(inp_D1, out_D1);
D2 : setesegmentos port map(inp_D2, out_D2);
D3 : setesegmentos port map(inp_D3, out_D3);
D4 : setesegmentos port map(inp_D4, out_D4);
D5 : setesegmentos port map(inp_D5, out_D5);
D6 : setesegmentos port map(inp_D6, out_D6);

end displays;