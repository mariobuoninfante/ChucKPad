public class M_MidiIn extends MidiIn
{
    /*
        MIDI INPUT
    */

    "" => string device_name;
    -1 => int device_id;    // if opening MIDI port using int

    function void connect(string s)
    {
        s => this.device_name;

        if( !this.open(this.device_name) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            me.exit();
        }
    }

    function void connect(int p)
    {
        p => this.device_id;

        if( !this.open(this.device_id) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            me.exit();
        }
    }

    function MidiIn get_midi_port()
    {
        return this;
    }

}
