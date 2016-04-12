#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <modbus.h>

int main (void){

int i=0,rc;

modbus_t *ctx;
uint16_t tab_reg[32];
uint8_t dest[8];
ctx = modbus_new_tcp("192.168.1.100",502);
modbus_connect(ctx);


modbus_write_register(ctx, 4, 5 );  // write 5 in register 4
rc = modbus_read_registers(ctx, 0, 8,tab_reg); // lit 

modbus_write_bit(ctx, 0, 1); //write 1 in coil 0
modbus_read_bits(ctx,0,8,dest);
printf("coil[%d] is at %d \n ", 0,dest[0]);

for (i=0; i < rc; i++)  {
                printf("reg[%d]=%d (0x%X)\n", i, tab_reg[i], tab_reg[i]);   
                                       }
modbus_close(ctx);
modbus_free(ctx);
}
