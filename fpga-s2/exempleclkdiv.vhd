elsif rising_edge(CLK) then
                        if (counter = 49999999) then
                                        tmp <= '1';
                                        counter <= counter + 1;
                        elsif (counter = 50000000) then    --on veut une            
                        --impulsion de courte durée, on repasse à 0 au front 
                        --d'horloge suivant.
                        tmp <= '0';
                        counter <= 0;
                        else
                counter <= counter + 1;
            end if;

