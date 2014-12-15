--     _                     _                        _         _
--    | |__   __ _ _   _  __| | __ _  ___ _ __ __   _| |__   __| |
--    | '_ \ / _` | | | |/ _` |/ _` |/ _ \ '_ \\ \ / / '_ \ / _` |
--    | |_) | (_| | |_| | (_| | (_| |  __/ | | |\ V /| | | | (_| |
--    |_.__/ \__,_|\__,_|\__,_|\__, |\___|_| |_(_)_/ |_| |_|\__,_|
--                             |___/                              

LIBRARY ieee  ;
USE ieee.std_logic_1164.all  ;
USE IEEE.std_logic_unsigned.all;

ENTITY baudgen IS
PORT(vit : IN STD_LOGIC :='1';
CLK : IN STD_LOGIC;
 baudclk : OUT STD_LOGIC);
END baudgen;

ARCHITECTURE archbaud OF baudgen IS
SIGNAL tmp : STD_LOGIC;
SIGNAL counter : INTEGER range 0 to 50000000 :=0;

BEGIN
PROCESS (CLK)
BEGIN
IF (CLK'EVENT AND CLK='1') THEN

        IF vit='0' THEN   --9600 bauds

        if rising_edge(CLK) then
                        if (counter = 5208) then
                                        tmp <= NOT(tmp);
                                        counter <= 0;
                        else
                counter <= counter + 1;
                        end if;
        end if;
    --    baudclk <= tmp;

        ELSIF vit='1' THEN  --19200 bauds

                if rising_edge(CLK) then
                        if (counter = 2604) then
                                        tmp <= NOT(tmp);
                                        counter <= 0;
                        else
                counter <= counter + 1;
                        end if;
        end if;
  --      baudclk <= tmp;

        END IF;
END IF;
END PROCESS;
baudclk <= tmp;
END archbaud;

