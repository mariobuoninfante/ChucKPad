public class M_Msg extends MidiMsg
{
    /*
     *  M_Msg.ck
     *  ---
     *  MIDI msg class
     *
     *  @author         Mario Buoninfante
     *  @copyright      2019 
    */


    /*
        In ChucK MIDI msg have 3 bytes only - a workaround is implemented in M_MidiOut.ck to send sysex msg

        The various 'send msg' functions have arguments in a 'Pure Data' style
        ie cc() would be the same that [ctlout] in Pd
        where the args are: 1. value, 2. CC nr, 3. MIDI Channel (1-16)
    */
    
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

    "" => string msg_type;      // ie note on, cc, real time, etc.

    int sysex_data[0];


    //-----------------------------
    //-----------MSG-IN------------
    //-----------------------------


    function int msg_midi_channel()
    {
        // take the last 4 bits out of the 1st byte
        return this.data1 & 15;
    }

    function int[] msg_array()
    {
        // return last 3 bytes as int[] also if the last msg is NRPN or CC-14
        return([this.data1, this.data2, this.data3]);
    }

    function void print()
    {
        <<< this.type(), this.data1, this.data2, this.data3 >>>;
    }

    function string type()
    {
        if(this.data1 < this.NOTE_ON)
        {
            "NOTE_OFF" => this.msg_type;
            return this.msg_type;
        }
        else if(this.data1 >= this.NOTE_ON && this.data1 < this.POLY_PRESS)
        {
            "NOTE_ON" => this.msg_type;
            return this.msg_type;
        }
        else if(this.data1 >= this.CTRL_CHANGE && this.data1 < this.PROG_CHANGE)
        {
            "CC" => this.msg_type;
            return this.msg_type;
        }
        else if(this.data1 >= this.CHAN_PRESS && this.data1 < this.PITCHBEND)
        {
            "AFTERTOUCH" => this.msg_type;
            return this.msg_type;
        }
        else if(this.data1 >= this.POLY_PRESS && this.data1 < this.CTRL_CHANGE)
        {
            "POLYTOUCH" => this.msg_type;
            return this.msg_type;
        }
        else
        {
            return "OTHER";
        }
    }
    
    
    
    //-----------------------------
    //-----------MSG-OUT-----------
    //-----------------------------
    

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

    function int[] sysex(int sys_msg[])
    {
        sys_msg @=> this.sysex_data;

        return this.sysex_data;
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
}
