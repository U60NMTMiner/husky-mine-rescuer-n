#include "can.hpp"
#include <cstring>


int main(int argc, char** argv)
{
    CAN::SocketCAN socket("vcan0");
    uint8_t msg[8];
    memset(msg, 0, sizeof(msg));
    socket.transmit(0x000, msg);
    return 0;
}