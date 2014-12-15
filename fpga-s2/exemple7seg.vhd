PROCESS (in4)
        variable seg : std_logic_vector(0 to 6);
        BEGIN

IF (in4=b"0000") THEN
seg:=b"0000001" ;
ELSIF(in4=b"0001") THEN
seg:=b"1001111";
ELSIF(in4=b"0010") THEN
seg:=b"0010010";
