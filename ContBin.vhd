--! Contador Binario com sinal Count_until

--! Henrique Tomaz Amorim NUSP 9837775
--! Jose Luiz Carvalho de Sousa NUSP 9017273

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ContBin is
	port(
		input : in std_logic_vector(14 downto 0);
		clk : in std_logic;
		count_til : in std_logic;
		enable : in std_logic;
		output : out std_logic_vector(14 downto 0);
		rco : out std_logic);
end ContBin;

architecture contador of ContBin is

--! Declaracao dos sinais

signal numero_atual : std_logic_vector(14 downto 0);

begin

process (clk)
		--variable um : std_logic_vector(14 downto 0) := "000000000000001";
		--variable zero : std_logic_vector(14 downto 0) := "000000000000000";
		--variable fim : std_logic_vector(14 downto 0) := "111111111111111";
	
	begin
		if (clk='1' and clk'event) then
		 
			if enable = '1' then
				if (count_til = '1' and numero_atual = input) then
					numero_atual <= "000000000000000";
				else
					numero_atual <= numero_atual + "000000000000001";
				end if;
			end if;
		end if;
		
end process;

rco <= '1' when ((count_til = '0' and numero_atual = "111111111111111") or (count_til = '1' and numero_atual = input)) else '0';

output <= numero_atual;

end contador;