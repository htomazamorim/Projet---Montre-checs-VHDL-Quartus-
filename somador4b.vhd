library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity somador4b is

port(
	cin : in std_logic;
	a,b : in std_logic_vector(3 downto 0);
	s : out std_logic_vector(3 downto 0);
	cout : out std_logic
);


end somador4b;

architecture circuito of somador4b is

signal somaParcial : std_logic_vector(4 downto 0);
signal aParcial : std_logic_vector(4 downto 0) := '0'&a;
signal bParcial : std_logic_vector(4 downto 0) := '0'&b;
signal carryIn : std_logic_vector(4 downto 0);

signal caiuBCDInvalido : std_logic := (somaParcial(3) and somaParcial(2)) or (somaParcial(3) and somaParcial(1));
signal carryOut : std_logic := somaParcial(4);

signal muxSelect : std_logic := carryOut or caiuBCDInvalido;

signal somaAB : std_logic_vector(3 downto 0) := somaParcial(3 downto 0);

begin

with cin select
carryIn <=  "00000" when '0',
				"00001" when '1';

somaParcial <= aParcial + bParcial + carryIn;

cout <= muxSelect;

with muxSelect select
s <= somaAB when '0', somaAB + "0110" when '1';

end circuito;