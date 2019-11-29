// M_MidiOut.ck
// ---
// MIDI Out class
// 
// @author         Mario Buoninfante
// @copyright      2019 

public class M_MidiOut extends MidiOut
{
    MidiMsg _msg;

    "" => string device_name;
    -1 => int device_id;

    function void send(int msg[])
    {
        /*
            this deals with array of bytes
            useful to send sysex msg
        */
        for(0 => int c; c < msg.size(); c++)
        {
            if(c % 3 == 0)
            {
                msg[c] => this._msg.data1;
                if(c == msg.size() - 1)
                {
                    this.send(this._msg);
                }
            }
            else if(c % 3 == 1)
            {
                msg[c] => this._msg.data1;
                if(c == msg.size() - 1)
                {
                    this.send(this._msg);
                }
            }
            else if(c % 3 == 2)
            {
                msg[c] => this._msg.data1;
                this.send(this._msg);
            }
        }
        
    }

    function int connect(string s)
    {
        s => this.device_name;

        if(!this.open(this.device_name))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            return 0;
        }

        return 1;
    }

    function int connect(int p)
    {
        p => this.device_id;

        if(!this.open(this.device_id))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            return 0;
        }
        return 1;
    }

}
