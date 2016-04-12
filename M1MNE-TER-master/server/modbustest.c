#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

#include <modbus.h>

int main(void)
{
    const uint16_t *src;
    float n=0;
    int socket;
    modbus_t *ctx;
    modbus_mapping_t *mb_mapping;

    ctx = modbus_new_tcp("192.168.1.100", 502);
     modbus_set_debug(ctx, TRUE); 

    mb_mapping = modbus_mapping_new(10, 10, 10, 10);
    if (mb_mapping == NULL) {
        fprintf(stderr, "Failed to allocate the mapping: %s\n",
                modbus_strerror(errno));
        modbus_free(ctx);
        return -1;
    }

    socket = modbus_tcp_listen(ctx, 1);
    modbus_tcp_accept(ctx, &socket);

    for (;;) {
        uint8_t query[MODBUS_TCP_MAX_ADU_LENGTH];
        int rc;
        rc = modbus_receive(ctx, query);
        if (rc != -1) {   
        modbus_reply(ctx, query, rc, mb_mapping);
        }else { break;}
    }
        n =  modbus_get_float(src);
    printf("Quit the loop: %s\n", modbus_strerror(errno));

    modbus_mapping_free(mb_mapping);
    modbus_close(ctx);
    modbus_free(ctx);

    return 0;
}

