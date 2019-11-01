public class M_MsgOut extends MidiMsg
{
    //-------------GLOBAL-VARIABLES-------------
    0x80 => int NOTE_OFF;
    0x90 => int NOTE_ON;
    0xA0 => int POLY_PRESS;
    0xB0 => int CTRL_CHANGE;
    0xC0 => int PROG_CHANGE;
    0xD0 => int CHAN_PRESS;
    0xE0 => int PITCHBEND;
    0x7B => int ALLNOTESOFF;
    0x00 => int CHANNEL;    // device MIDI channel
    0xF8 => int CLOCK;
    0xFA => int START;
    0xFB => int CONTINUE;
    0xFC => int STOP;

    M_MidiOut m_out;

    /*
        the various 'send msg' functions have arguments in a 'Pure Data' style
        ie cc() would be the same that [ctlout] in Pd
        where the args are: 1. value, 2. CC nr, 3. MIDI Channel (1-16)
    */
    
    function void note_on(int note, int vel, int channel)
    {
        this.NOTE_ON + (channel-1)  => this.data1;
        note                        => this.data2;
        vel                         => this.data3;
    }

    function void note_off(int note, int vel, int channel)
    {
        this.NOTE_OFF + (channel-1)  => this.data1;
        note                         => this.data2;
        vel                          => this.data3;
    }

    function void cc(int value, int cc_nr, int channel)
    {
        this.CTRL_CHANGE + (channel-1)  => this.data1;
        cc_nr                           => this.data2;
        value                           => this.data3;
    }

    // 14 bit messages
    // function void cc_14(int value, int addr_1, int addr_2, int channel)
    // {
    //     value >> 7      => int v_1;
    //     value & 0x7F    => int v_2;

    //     this.CTRL_CHANGE + (channel-1)  => this.data1;
    //     addr_1 & 0x7F                   => this.data2;
    //     v_1                             => this.data3;
    //     this.send_msg(this.msg_out);

    //     this.CTRL_CHANGE + (channel-1)  => this.data1;
    //     addr_2 & 0x7F                   => this.data2;
    //     v_2                             => this.data3;
    //     this.send_msg(this.msg_out);
    // }

    // function void send_nrpn( int value, int addr_1, int addr_2, int channel, int bit_nr )
    // {
    //     0 => int v_1 => int v_2 => int length;
    //     [99, 98, 6, 38] @=> int nrpn_cc_nr[];

    //     if( bit_nr == 0 )
    //     {
    //         // 7 bit
    //         value & 0x7F => v_1;
    //         3 => length;
    //     }
    //     else
    //     {
    //         // 14 bit
    //         value >> 7 => v_1;
    //         value & 0x7F => v_2;
    //         4 => length;
    //     }

    //     [addr_1, addr_2, v_1, v_2] @=> int bytes[];

    //     for(0 => int c; c < length; c++)
    //     {
    //         this.CTRL_CHANGE + (channel-1)  => this.data1;
    //         (nrpn_cc_nr[c] & 0x7F)  => this.data2;
    //         (bytes[c] & 0x7F)       => this.data3;
    //         this.send_msg(this.msg_out);
    //     }
    // }

    function void set_msg(int b_1, int b_2, int b_3)
    {
        b_1 => this.data1;
        b_2 => this.data2;
        b_3 => this.data3;
    }

    function void set_msg(int b[])
    {
        b[0] => this.data1;
        b[1] => this.data2;
        b[2] => this.data3;
    }

    function void set_msg(MidiMsg msg)
    {
        msg.data1 => this.data1;
        msg.data2 => this.data2;
        msg.data3 => this.data3;
    }

    function void send()
    {
        this.m_out.send(this);
    }

    function void connect_to_midi_out(M_MidiOut out)
    {
        out @=> this.m_out;
    }

    function void sysex(int sys_msg[])
    {
        for(0 => int c; c < sys_msg.size(); c++)
        {
            if(c % 3 == 0)
            {
                sys_msg[c] => this.data1;
                if(c == sys_msg.size() - 1)
                {
                    this.send();
                    // <<< this.data1, this.data2, this.data3 >>>;
                }
            }
            else if(c % 3 == 1)
            {
                sys_msg[c] => this.data2;
                if(c == sys_msg.size() - 1)
                {
                    this.send();
                    // <<< this.data1, this.data2, this.data3 >>>;
                }
            }
            else if(c % 3 == 2)
            {
                sys_msg[c] => this.data3;
                this.send();
                // <<< this.data1, this.data2, this.data3 >>>;
            }
        }
    }
}
