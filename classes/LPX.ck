public class LPX extends MidiLib
{
    /*
        Novation LP X
    */

    MidiIn      from_LP;
    MidiMsg     msg_in;
    M_MidiOut   to_LP;
    M_MsgOut    msg_out;

    "Launchpad X MIDI 2" => string device_name;

    // HW layout - pads/buttons/logo mapping
    [11,12,13,14,15,16,17,18,
    21,22,23,24,25,26,27,28,
    31,32,33,34,35,36,37,38,
    41,42,43,44,45,46,47,48,
    51,52,53,54,55,56,57,58,
    61,62,63,64,65,66,67,68,
    71,72,73,74,75,76,77,78,
    81,82,83,84,85,86,87,88,
    91,92,93,94,95,96,97,98] @=> int pads[];

    [19,29,39,49,59,69,79,89] @=> int buttons[];

    99 => int logo;

    function void connect()
    {
        /*
            connect MIDI in/out
        */
        if(!this.from_LP.open(this.device_name))
        {
            chout <= "issue connecting LP X - INPUT";
            me.exit();
        }

        this.to_LP.connect(this.device_name);

        this.msg_out.connect_to_midi_out(this.to_LP);
    }

    function void set_pad(int id, int color)
    {
        this.msg_out.note_on(id, color, 1);
        this.msg_out.send(this.msg_out);
    }

    function void set_button(int id, int color)
    {
        this.msg_out.cc(color, id, 1);
        this.msg_out.send(this.msg_out);
    }

    function void programmer_mode(int status)
    {
        /*
            turn OFF/ON "programmer mode"
        */
        status & 127 => status;
        this.msg_out.sysex([240, 0, 32, 41, 2, 12, 14, status, 247]);
    }
}