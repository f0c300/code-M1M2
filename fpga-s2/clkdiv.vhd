library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clkdiv is
    Port (
        CLK : in  STD_LOGIC;
        RAZ  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end clkdiv;

architecture behav of clkdiv is
    signal tmp: STD_LOGIC;
    signal counter : integer range 0 to 50000000 := 0;

BEGIN
    PROCESS (RAZ, CLK) 
    BEGIN
        if (RAZ = '1') then
            tmp <= '0';
            counter <= 0;
        elsif rising_edge(CLK) then
			if (counter = 49999999) then
					tmp <= '1';
					counter <= counter + 1;
			elsif (counter = 50000000) then			--on veut une impulsion de courte durée, donc au clk suivant on repasse la valeur de sortie à 0
			tmp <= '0';
			counter <= 0;
			else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= tmp;
end behav;
