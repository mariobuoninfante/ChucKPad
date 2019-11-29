public class M_MidiIn extends MidiIn
{
    /*
     *  M_MidiIn.ck
     *  ---
     *  MIDI In class
     *
     *  @author         Mario Buoninfante
     *  @copyright      2019 
    */

    "" => string device_name;
    -1 => int device_id;    // if opening MIDI port using int

    function int connect(string s)
    {
        s => this.device_name;

        if( !this.open(this.device_name) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            // me.exit();
            return 0;
        }

        return 1;
    }

    function int connect(int p)
    {
        p => this.device_id;
        if( !this.open(this.device_id) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            // me.exit();
            return 0;
        }
        return 1;
    }

    function MidiIn get_midi_port()
    {
        return this;
    }
}
