#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <modbus.h>


/* this program does nothing else than read some registers */

int main(void) // the program returns nothing
{
FILE* fichier_sortie = NULL;

int i,j;
int temp;
float data = 28.0; 
float pas = 0.0;
int rc,connect ;	//received

modbus_t *ctx; //initialisation context modbus

uint16_t tab_reg[32];
uint8_t dest[8];

/* we use TCP  */
ctx = modbus_new_tcp("192.168.1.100", 502); // normally modbus connexions are on port 502 but port 1502 can be used by a normal user


printf("ctx = %d \n",ctx);
connect = modbus_connect(ctx);
//on indique quelle fonction on veut utiliser : 3
modbus_write_register(ctx,3,3);


printf("connect = %d \n",connect);


fichier_sortie = fopen("temperature.dat", "w");
fprintf(fichier_sortie, "%f %f  \n", pas, data);
fclose(fichier_sortie);

system("gnuplot -p -e \"plot 'temperature.dat'\" loop.plt &");
for(j=0; j<300; j++){
//modbus_write_register(ctx, 3, 5 );  // ecrit 5 dans le registre 3
rc = modbus_read_registers(ctx, 0, 2,tab_reg); // lit 
printf("rc = %d \n",rc);
//modbus_write_bit(ctx, 3, 1); //write 1 in coil 3
//modbus_read_bits(ctx,0,8,dest);
//printf("coil[%d] is at %d \n ", 3,dest[3]);
pas = pas +1.0;

for (i=0; i < rc; i++) {

printf("reg[%d]=%d (0x%X)\n", i, tab_reg[i], tab_reg[i]);   }

temp = ((tab_reg[0] <<8) |( tab_reg[1]));
temp >>=4;
	if (temp & (1 << 11)){
		temp |= 0xF800;
	} 
data = temp * 0.0625;
printf("%04f  \n",data);
fichier_sortie = fopen("temperature.dat", "a");
fprintf(fichier_sortie, "%f %f  \n", pas, data);
fclose(fichier_sortie);

usleep(1000000);
}
fichier_sortie = fopen("temperature.dat", "a");
fprintf(fichier_sortie, "&");
fclose(fichier_sortie);
//scanf("%d", &fin);
modbus_close(ctx);
modbus_free(ctx);
}

