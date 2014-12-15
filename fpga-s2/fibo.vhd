--   __   _                _         _
--  / _(_) |__   _____   _| |__   __| |
-- | |_| | '_ \ / _ \ \ / / '_ \ / _` |
-- |  _| | |_) | (_) \ V /| | | | (_| |
-- |_| |_|_.__/ \___(_)_/ |_| |_|\__,_|

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

ENTITY fibo IS
  PORT(
    N : IN std_logic_vector (7 downto 0) :="00011110";  --nbre termes =30 ici
    RAZ,CLK : IN std_logic:='0';
    EN : IN std_logic :='1';
    suitefibo : OUT std_logic_vector (15 downto 0):=X"0000"; --sortie
    Overflow : OUT std_logic:='0'; --carry
    caract : OUT std_logic_vector (0 to 7) :=X"00");
            --caractère à envoyer à l'USART : B ou E
END fibo;

ARCHITECTURE behav OF fibo IS
      SIGNAL c :std_logic_vector (15 downto 0):=X"0000";
      SIGNAL b : std_logic_vector (15 downto 0):=X"0001" ;
      SIGNAL a : std_logic_vector (15 downto 0) :=X"0001" ;
  BEGIN
    PROCESS(CLK)
       VARIABLE cnt : std_logic_vector (7 downto 0):=X"00"; --nbre de termes
    BEGIN


    IF(CLK'EVENT and CLK ='1') THEN

        IF (RAZ='1') THEN
      --raz synchrone
          c<=(others=>'0'); --n-2
          a<=X"0001"; --n
          b<=X"0001";  --n-1
          cnt:=(others=>'0');
          Overflow <='0';
        END IF;   
    
        IF (c > b) THEN --c ne peut normalement être > à b
                       Overflow <='1';
                 --on encode le caractère à envoyer à l'USART
                      caract <= "01000101"; --E
                    
        ELSIF (b > c) THEN caract <= "01000010"; --pas d'overflow, caractère B
        END IF;

                IF (EN='1') THEN
              --comportement normal
                c<=b;
                b<=a;
                a<=a+b;
                
                cnt:=cnt+1; --nbre de termes calculés

                    IF (cnt=N) THEN --reinitialisation
                    a<=X"0001";
                    b<=X"0001";
                    c<=(others=>'0');
                    cnt:=(others=>'0');
                    Overflow <='0';
                    END IF;
                END IF;
     END IF;
    END PROCESS;

    suitefibo<=b;

END behav;

