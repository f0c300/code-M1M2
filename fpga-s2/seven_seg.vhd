library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;

entity seven_seg is 
	PORT(
		in4 : in std_logic_vector (3 downto 0);
		seg7 : OUT std_logic_vector(0 to 6));
	END seven_seg;
	
architecture behav of seven_seg is

BEGIN

PROCESS (in4)
	variable seg : std_logic_vector(0 to 6);
	BEGIN
	
IF (in4=b"0000") THEN
seg:=b"0000001" ;
ELSIF(in4=b"0001") THEN
seg:=b"1001111";
ELSIF(in4=b"0010") THEN
seg:=b"0010010";
ELSIF(in4=b"0011") THEN
seg:=b"0000110";
ELSIF(in4=b"0100") THEN
seg:=b"1001100";
ELSIF(in4=b"0101") THEN
seg:=b"0100100";
ELSIF(in4=b"0110") THEN
seg:=b"0100000";
ELSIF(in4=b"0111") THEN
seg:=b"0001111";
ELSIF(in4=b"1000") THEN
seg:=b"0000000";
ELSIF(in4=b"1001") THEN
seg:=b"0000100";
ELSIF(in4=b"1010") THEN
seg:=b"0001000";
ELSIF(in4=b"1011") THEN
seg:=b"1100000";
ELSIF(in4=b"1100") THEN
seg:=b"0110001";
ELSIF(in4=b"1101") THEN
seg:=b"1000010";
ELSIF(in4=b"1110") THEN
seg:=b"0110000";
ELSIF(in4=b"1111") THEN
seg:=b"0111000";
ELSE seg:=b"0000001";
END IF;

seg7<=seg;

END PROCESS;

END behav;
