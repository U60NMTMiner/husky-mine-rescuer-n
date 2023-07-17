#include "control/message.h"
#include "control/serial.h"

namespace message {
    void makeMsg(uint8_t* msg,
        uint8_t* payload,
        size_t payload_len,
        uint16_t type)
    {
        // Check Length
        size_t total_len = payload_len + HEADER_LENGTH + CRC_LENGTH;
        if (total_len > MAX_MSG_LENGTH)
        {
            //TODO throw error
        }

        // Zero message and copy in data
        memset(msg, 0, MAX_MSG_LENGTH);
        memcpy(msg + PAYLOAD_OFST, payload, payload_len);
        
        // Header
        msg[SOH_OFST] = SOH;
        msg[STX_OFST] = STX;
        msg[LENGTH_OFST] = total_len;
        msg[LENGTH_COMP_OFST] = ~total_len;
        utob(msg + TYPE_OFST, 2, type);
        // data[FLAGS_OFST] = flags;
        // data[VERSION_OFST] = version;
        // utob(msg + TIMESTAMP_OFST, 4, timestamp);
        
        // Checksum
        size_t crc_ofst = total_len - CRC_LENGTH;
        uint16_t checksum = serial::crc16(crc_ofst, CRC_INIT_VAL, msg);
        serial::utob(msg + crc_ofst, 2, checksum);
    }

    void ackermannOutput(uint8_t* msg,
        double steer,
        double throt,
        double brake)
    {
        size_t payload_len = 6;
        uint8_t payload[payload_len];

        ftob(payload, 2, steer, 100);
        ftob(payload + 2, 2, throt, 100);
        ftob(payload + 4, 2, brake, 100);

        makeMsg(msg,
            payload,
            payload_len,
            SET_ACKERMANN_SETPT);
    }
    
    void differentialControl(uint8_t* msg,
        double p,
        double i,
        double d,
        double feedfwd,
        double stic,
        double int_lim)
    {
        differentialControl(msg, p, i, d, feedwd, stic, int_lim,
            p, i, d, feedwd, stic, int_lim)
    }
    
    void differentialControl(uint8_t* msg,
        double left_p,
        double left_i,
        double left_d,
        double left_feedfwd,
        double left_stic,
        double left_int_lim,
        double right_p,
        double right_i,
        double right_d,
        double right_feedfwd,
        double right_stic,
        double right_int_lim)
    {
        size_t payload_len = 24;
        uint8_t payload[payload_len];
        
        ftob(payload, 2, left_p, 100);
        ftob(payload + 2, 2, left_i, 100);
        ftob(payload + 4, 2, left_d, 100);
        ftob(payload + 6, 2, left_feedfwd, 100);
        ftob(payload + 8, 2, left_stic, 100);
        ftob(payload + 10, 2, left_int_lim, 100);
        
        ftob(payload + 12, 2, right_p, 100);
        ftob(payload + 14, 2, right_i, 100);
        ftob(payload + 16, 2, right_d, 100);
        ftob(payload + 18, 2, right_feedfwd, 100);
        ftob(payload + 20, 2, right_stic, 100);
        ftob(payload + 22, 2, right_int_lim, 100);
        
        makeMsg(msg,
            payload,
            payload_len,
            SET_DIFFERENTIAL_CONSTS);
    }
    
    void differentialOutput(uint8_t* msg, double left, double right)
    {
        size_t payload_len = 4;
        uint8_t payload[payload_len];

        ftob(payload, 2, left, 100);
        ftob(payload + 2, 2, right, 100);

        makeMsg(msg,
            payload,
            payload_len,
            SET_DIFFERENTIAL_WHEEL_SETPTS);
    }
    
    void differentialSpeed(uint8_t* msg,
        double left_spd,
        double right_speed,
        double left_accel,
        double right_accel)
    {
        size_t payload_len = 8;
        uint8_t payload[payload_len];

        ftob(payload, 2, left_spd, 100);
        ftob(payload + 2, 2, left_accel, 100);
        ftob(payload + 4, 2, right_spd, 100);
        ftob(payload + 6, 2, right_accel, 100);

        makeMsg(msg,
            payload,
            payload_len,
            SET_DIFFERENTIAL_WHEEL_SPEEDS);
    }
    
    void maxAccel(uint8_t* msg, double max_fwd, double max_rev)
    {
        size_t payload_len = 4;
        uint8_t payload[payload_len];

        ftob(payload, 2, max_fwd, 100);
        ftob(payload + 2, 2, max_rev, 100);

        makeMsg(msg,
            payload,
            payload_len,
            SET_MAX_ACCEL);
    }
    
    void maxSpeed(uint8_t* msg, double max_fwd, double max_rev)
    {
        size_t payload_len = 4;
        uint8_t payload[payload_len];

        ftob(payload, 2, max_fwd, 100);
        ftob(payload + 2, 2, max_rev, 100);

        makeMsg(msg,
            payload,
            payload_len,
            SET_MAX_SPEED);
    }
}

#endif
