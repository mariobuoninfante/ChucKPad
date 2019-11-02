public class LPX extends MidiLib
{
    /*
        Novation LP X
    */

    M_MidiIn    from_LP;
    M_MsgIn     msg_in;
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
    81,82,83,84,85,86,87,88] @=> int pads[];

    [19,29,39,49,59,69,79,89,91,92,93,94,95,96,97,98] @=> int buttons[];
    int button_names[0];
    19 => this.button_names["record_arm"];
    29 => this.button_names["solo"];
    39 => this.button_names["mute"];
    49 => this.button_names["stop_clip"];
    59 => this.button_names["send_b"];
    69 => this.button_names["send_a"];
    79 => this.button_names["pan"];
    89 => this.button_names["volume"];
    91 => this.button_names["arrow_up"];
    92 => this.button_names["arrow_down"];
    93 => this.button_names["arrow_left"];
    94 => this.button_names["arrow_right"];
    95 => this.button_names["session"];
    96 => this.button_names["note"];
    97 => this.button_names["custom"];
    98 => this.button_names["capture"];

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

    function void set_led(int id, int color, int mode)
    {
        // mode: 0.static, 1.flash, 2.pulse
        if(id % 10 != 9)
            this.msg_out.note_on(id, color, mode+1);
        else
            this.msg_out.cc(color, id, mode+1);
        this.msg_out.send();
    }

    function void set_led(string name, int color, int mode)
    {
        this.msg_out.cc(color, this.button_names[name], mode+1);
        this.msg_out.send();
    }

    function void set_leds(int list[])
    {
        // pairs of id, color
        for(0 => int c; c < list.size()/2; c++)
        {
            list[c*2]       => int id;
            list[(c*2) + 1] => int color;
            if(id % 10 != 9)
            this.msg_out.note_on(id, color, 1);
            else
                this.msg_out.cc(color, id, 1);
            this.msg_out.send();
        }
    }

    function void set_row(int row, int color, int mode)
    {
        row % 9 => row;
        (row*10) + 11 => int offset;
        for(0 => int c; c < 9; c++)
        {
            this.set_led(c+offset, color, mode);
        }
    }

    function void set_column(int column, int color, int mode)
    {
        column%9 => column;
        11+column => int offset;
        for(0 => int c; c < 9; c++)
        {
            this.set_led((c*10)+offset, color, mode);
        }
    }

    function void set_all(int color, int mode)
    {
        for(0 => int c; c < 100; c++)
        {
            this.set_led(c, color, mode);
        }
    }

    function void clear()
    {
        for(0 => int c; c < 100; c++)
        {
            this.set_led(c, 0, 0);
        }
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