#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include </usr/include/linux/fcntl.h>
#include </usr/include/linux/i2c-dev.h>
#include <modbus.h>
#include "/home/root/iofunc/iolib.h"

int main(void)
{	
	
	int tmp102;
	float data;
	int temp;
	int adress ;
	int LIMIT = 37;
	char registre_lecture[1] = {0};
	
	printf("adresse \n");
	scanf("%d", &adress);
	
	if(( tmp102 = open("/dev/i2c-1", O_RDWR)) <0){
		perror("failed to open the i2c bus \n");
		exit(1);
		}
	
	if((ioctl( tmp102,I2C_SLAVE,adress))<0){
		printf("n'arrive pas a communiquer avec le bus ou l'esclave \n");
	}	
//gpio init part
    iolib_init();
     iolib_setdir(9,12, DIR_OUT);
       
	while(1){       
    const uint16_t *src;
    float n=0;
    int socket ;
    modbus_t *ctx;
    modbus_mapping_t *mb_mapping;
	
	
    ctx = modbus_new_tcp("192.168.1.100", 502);
     modbus_set_debug(ctx, TRUE); 

    mb_mapping = modbus_mapping_new(10,10, 10, 10);
    if (mb_mapping == NULL) {
        fprintf(stderr, "Failed to allocate the mapping: %s\n",
                modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }

//int t=0;

	printf("mapping bien");
    socket = modbus_tcp_listen(ctx, 1);
    modbus_tcp_accept(ctx, &socket);
	printf("tcp acceptÃ");
    for (;;) {

    printf("test temperature\n");

    if(read(tmp102, registre_lecture,2)!=2){
		perror("read error");
		}	
	if (registre_lecture[0] > LIMIT) 
                            {
        pin_high(9,12);     //allume la LED
                            }
    else{
        pin_low(9,12);      //eteint la LED
                            }

        uint8_t query[MODBUS_TCP_MAX_ADU_LENGTH];
        int rc ;
    (*mb_mapping).tab_registers[0] = registre_lecture[0];
    (*mb_mapping).tab_registers[1] = registre_lecture[1];
    
        rc = modbus_receive(ctx, query);
  	if (rc != -1) {   
  	modbus_reply(ctx, query, rc, mb_mapping);
	}else { 
	printf("Failed to pouet\n");
	break;
	}
        }	

    //(*mb_mapping).tab_registers[4] = reg1;


    //n =  modbus_get_float(src);

    printf("Quit the loop: %s\n", modbus_strerror(errno));
    //printf("byte=%d\n",n);

    modbus_mapping_free(mb_mapping);
 	modbus_close(ctx);
    modbus_free(ctx);
	
    }
    return 0;
}   
