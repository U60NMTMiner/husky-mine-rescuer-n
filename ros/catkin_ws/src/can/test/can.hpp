#ifndef CAN_H
#define CAN_H

#include <linux/can.h>
#include <string>

namespace CAN {
    int E_STOP_FRAME_ID = 0x000;
    int DRAWER_FRAME_ID = 0x001;
    int NODE_FRAME_ID = 0x002;

    struct Stepper {
        int id;
        int speed;
        bool dir;
    };

    struct Servo {
        int id;
        int pos;
    };

    // Basic file descriptor wrapper. Not really intended for use outside
    // SocketCAN.
    class fd {
        int id;

      public:
        fd();
        fd(int n);
        fd(fd &&other);
        ~fd();

        void operator=(fd &&other);
        int operator*();

        int into_raw();
    };

    // CAN socket.
    class SocketCAN {
        fd sock;

      public:
        SocketCAN();
        SocketCAN(const std::string &interface);

        void transmit(const struct can_frame &cf);
        void transmit(int can_id, uint8_t data[8]);
    };

    void estop(SocketCAN& can);
    void drawer_open(SocketCAN& can);
    void drawer_close(SocketCAN& can);
    void drop_node(SocketCAN& can);
};

#endif
