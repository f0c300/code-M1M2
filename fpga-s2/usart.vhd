--                            _         _         _
--       _   _ ___  __ _ _ __| |___   _| |__   __| |
--      | | | / __|/ _` | '__| __\ \ / / '_ \ / _` |
--      | |_| \__ \ (_| | |  | |_ \ V /| | | | (_| |
--      \__,_|___/\__,_|_|   \__(_)_/ |_| |_|\__,_|

LIBRARY ieee  ;
USE ieee.std_logic_1164.all  ;
USE IEEE.std_logic_unsigned.all;

ENTITY USART IS
port(dataIN : IN std_logic_vector(0 to 7);
clk : IN std_logic;
raz : IN std_logic;
starttr : IN std_logic :='1';
baudclk : IN std_logic;
TxD : OUT std_logic);
END ENTITY;
--on ne s'occupe que de la partie transmission
ARCHITECTURE USARTarch of USART is

signal tx_reg   :std_logic_vector (7 downto 0);
signal tx_full  :std_logic;
signal tx_out   :std_logic;
signal tx_count :integer range 0 to 16;
signal start 	:std_logic;
BEGIN
PROCESS(clk) BEGIN


if ( clk'EVENT AND clk='1') then     --attention, horloge 50Mhz
	if (raz = '0') then


        if (baudclk = '1') then     --cadence choisie
        start <= starttr;
            if (tx_full = '0' AND start = '1')  then
                tx_count <= tx_count +1;

                if (tx_count = 0) then          --start bit
                tx_out <= '0';
                end if;
                if (tx_count >=1 and tx_count <=8) then --données sur 8 bits
                tx_out <= dataIN(tx_count - 1);
                end if;
                if (tx_count =9) then           -- stop bit
                tx_out <= '1';
                tx_count <= 0;
                tx_full <= '0';
                end if;
            end if;
		end if;
        
	else 
		start <= '0';
        tx_full <= '0';
        tx_count <= 0;
        tx_out <= '0';        
   end if;
end if;
END PROCESS;
TxD <= tx_out;
END ARCHITECTURE;
