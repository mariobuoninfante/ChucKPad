public class M_MidiOut
{
    /*
        MIDI DEVICE
    */

    MidiOut m_out;
    MidiMsg msg_out;

    "" => string device_name;
    -1 => int device_id;


    function void send(MidiMsg msg)
    {
        m_out.send(msg);
    }

    function void connect(string s)
    {
        s => this.device_name;

        if(!this.m_out.open(this.device_name))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            me.exit();
        }
    }

    function void connect(int p)
    {
        p => this.device_id;

        if(!this.m_out.open(this.device_id))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            me.exit();
        }
    }

}
