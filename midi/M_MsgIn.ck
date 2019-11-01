public class M_MsgIn extends MidiMsg
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

    "" => string msg_type;      // ie note on, cc, real time, etc.

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
}
