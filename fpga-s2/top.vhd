--   _                      _       _
--  | |_ ___ _ __      __ _| |_  __| |
--  |  _/ _ \ '_ \  _  \ V / ' \/ _` |
--  \__\___/ .__/ (_)  \_/|_||_\__,_|
--          |_|      

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;

ENTITY top IS
PORT(RAZ, CLK, vitesse, starttr :	IN STD_LOGIC;
        N:				IN STD_LOGIC_VECTOR(7 downto 0);
        unite, dizaine, centaine, millier :	OUT	STD_LOGIC_VECTOR(0 to 6);
        OEF, Trans:		OUT STD_LOGIC);
END top;

ARCHITECTURE struct OF top IS
    SIGNAL data : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL clk_en, baudclk : STD_LOGIC;
    SIGNAL message : STD_LOGIC_VECTOR(7 downto 0);
	
COMPONENT fibo
    port(CLK, RAZ, EN :	IN STD_LOGIC;
	N : IN STD_LOGIC_VECTOR (7 downto 0);
    suitefibo : OUT STD_LOGIC_VECTOR(15 downto 0);
    caract : OUT STD_LOGIC_VECTOR(7 downto 0);
	Overflow : OUT STD_LOGIC);
END COMPONENT;

COMPONENT seven_seg
	PORT(
	in4 : IN STD_LOGIC_VECTOR(3 downto 0);  
	seg7 : OUT STD_LOGIC_VECTOR(0 to 6));
END COMPONENT;

COMPONENT clkdiv
    PORT(CLK, RAZ :	IN STD_LOGIC;
    clk_out : 	OUT STD_LOGIC);
END COMPONENT;

COMPONENT baudgen
    PORT( vit, CLK : IN STD_LOGIC;
    baudclk : OUT STD_LOGIC);
END COMPONENT;

COMPONENT usart
	PORT( DataIN : IN STD_LOGIC_VECTOR(7 downto 0);
    CLK, RAZ, starttr, baudclk : IN STD_LOGIC;
    TxD : OUT std_logic);
END COMPONENT;

BEGIN --description
clk1: clkdiv PORT MAP(CLK => CLK,
                    RAZ => RAZ,
                    clk_out => clk_en);
baud1: baudgen PORT MAP (vit => vitesse, CLK => CLK, baudclk => baudclk);
fib1: fibo PORT MAP(CLK => CLK,RAZ => RAZ, EN => clk_en,
                    N => N, suitefibo => data, caract => message,
                    Overflow => OEF);
dec_0: seven_seg PORT MAP(data(3 downto 0),unite);
dec_1: seven_seg PORT MAP(data(7 downto 4),dizaine);
dec_2: seven_seg PORT MAP(data(11 downto 8),centaine);
dec_3: seven_seg PORT MAP(data(15 downto 12),millier);
usart1: usart PORT MAP(TxD => Trans, CLK => CLK,
                       RAZ => RAZ, starttr => starttr,
                       baudclk => baudclk,
                       dataIN => message);

END struct;
