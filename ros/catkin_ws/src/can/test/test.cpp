#include "can.h"

CAN::SocketCan socket("can0");

int main(int argc, char** argv)
{
    uint8_t msg[8];
    memset(msg, 0, sizeof(msg));
    socket.transmit(0x000, msg);
    return 0;
}