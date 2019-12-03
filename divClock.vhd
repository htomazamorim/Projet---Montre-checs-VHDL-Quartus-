library ieee;
use ieee.std_logic_1164.all;


entity divClock is
	generic ( 
		-- Por exemplo, max1 = 2000 pois a cada mudança de NIVEL
		-- do clock de 1000 Hz soma-se um ao contador responsavel por gerar o clock
		-- de 1 hz. Por fim, quando detectou-se 2000 mudanças de nivel (1000 bordas)
		-- muda-se o o estado do clk de 1 Hz.
		
		max1 : integer := 1001;	 -- Vou usar múltiplos aqui
		max100 : integer := 11;  -- Vou usar múltiplos aqui
		max1000 : integer := 25000;
		max440 : integer := 5;
		max1760 : integer := 14205
	);
	port(
		clk50Mhz : in std_logic;
		clk1 : out std_logic;
		clk100 : out std_logic;
		clk1000 : out std_logic;
		clk440 : out std_logic;
		clk1760 : out std_logic
);
end divClock;

architecture div of divClock is

signal tmp1 : std_logic := '0';
signal tmp100 : std_logic := '0';
signal tmp1000 : std_logic := '0';
signal tmp440 : std_logic := '0';
signal tmp1760 : std_logic := '0';

signal count1 : integer range 1 to (max1):= 1;
signal count100 : integer range 1 to (max100):= 1;
signal count1000 : integer range 1 to (max1000):= 1;
signal count440 : integer range 1 to (max440):= 1;
signal count1760 : integer range 1 to (max1760):= 1;

begin

process (clk50Mhz)
	begin
	
	if(clk50Mhz'event and clk50Mhz='1') then
		count1000 <= count1000 + 1;
		count1760 <= count1760 + 1;
		
		if ( count1000 = (max1000) ) then
			tmp1000 <= not tmp1000;
			count1000 <= 1;
			
			count1 <= count1 + 1;
			count100 <= count100 + 1;
		end if;
		
		if ( count1 = (max1) ) then
			tmp1 <= not tmp1;
			count1 <= 1;
		end if;
		
		if ( count100 = (max100) ) then
			tmp100 <= not tmp100;
			count100 <= 1;
		end if;
		
		if ( count1760 = (max1760) ) then
			tmp1760 <= not tmp1760;
			count1760 <= 1;
			
			count440 <= count440 + 1;
		end if;
		
		if ( count440 = (max440) ) then
			tmp440 <= not tmp440;
			count440 <= 1;
		end if;
	end if;
	
end process;

clk1 <= tmp1;
clk100 <= tmp100;
clk1000 <= tmp1000;
clk1760 <= tmp1760;
clk440 <= tmp440;

end div;