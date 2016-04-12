#client: tempclient.c
#	gcc -o temp tempclient.c `pkg-config --libs --cflags libmodbus`

#client: modbusclient.c
#	gcc -o modbustest modbusclient.c `pkg-config --libs --cflags libmodbus`

client: ledclient.c
	gcc -o led ledclient.c `pkg-config --libs --cflags libmodbus`
