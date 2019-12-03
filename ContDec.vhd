--! Contador Decada Crescente-Descrescente

--! Henrique Tomaz Amorim NUSP 9837775
--! Jose Luiz Carvalho de Sousa NUSP 9017273

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ContDec is
	port(
		input : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		load_n : in std_logic;
		clear_n : in std_logic;
		enable : in std_logic;
		crescente : in std_logic;
		output : out std_logic_vector(3 downto 0);
		rco : out std_logic);
end ContDec;

architecture contador of ContDec is

--! Declaracao dos sinais

signal numero_atual : std_logic_vector(3 downto 0);
--signal um : std_logic_vector(3 downto 0) := "0001";

--(numero_atual = "1001" and crescente = '1')
signal expressionRCO1 : std_logic := numero_atual(3) and not(numero_atual(2)) and not(numero_atual(1))
												and numero_atual(0) and crescente; 

--(numero_atual = "0000" and crescente = '0')
signal expressionRCO2 : std_logic := numero_atual(3) or numero_atual(2) or numero_atual(1)
												or numero_atual(0) or crescente;
												
												
signal caiuBCDInvalido : std_logic := (input(3) and input(2)) or (input(3) and input(1));

begin

	process (clk, clear_n, load_n)

	begin
		if clear_n = '0' then
			numero_atual <= "0000";
	
		elsif (clk='1' and clk'event) then
				if load_n = '0' then
					if (caiuBCDInvalido = '1') then
						numero_atual <= "1001";
					else
						numero_atual <= input;						
					end if;			
				elsif enable = '1' then
					if crescente = '1' then
						if numero_atual = "1001" then
							numero_atual <= "0000";
						else
							numero_atual <= numero_atual + "0001";
						end if;
					else
						if numero_atual = "0000" then
							numero_atual <= "1001";
						else
							numero_atual <= numero_atual - "0001";
						end if;
					end if;
				end if;
		end if;
	
	end process;

	rco <= expressionRCO1 or not(expressionRCO2);
	
	output <= numero_atual;

end contador;