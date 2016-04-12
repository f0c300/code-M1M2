#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <modbus.h>

int main(void) // the program returns nothing
{
int test, rc;
modbus_t *ctx; 
uint16_t tab_reg[32];

ctx = modbus_new_tcp("192.168.1.100", 502); 
rc = modbus_connect(ctx);

printf("allumer/éteindre la LED, taper 1/0\n");
while(rc != -1)    {
scanf("%d",&test);

if( test == 1){
modbus_write_bit(ctx, 1, 1); //write 1 in coil 1 : on
}
else if( test == 0 )  {
modbus_write_bit(ctx, 1, 0); //write 0 in coil 1 : off
}
           }
modbus_close(ctx);
modbus_free(ctx);
}
