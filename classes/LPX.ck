/*
     *  LPX.ck
     *  ---
     *  Novation LP X Class
     *
     *  @author         Mario Buoninfante
     *  @copyright      2019 
*/

public class LPX extends MidiLib
{
    M_MidiIn    from_LP;
    M_Msg       msg_in;
    M_MidiOut   to_LP;
    M_Msg       msg_out;

    "Launchpad X MIDI 2" => string device_name_linux;
    "Launchpad X LPX MIDI Out" => string device_name_mac_out;
    "Launchpad X LPX MIDI In" => string device_name_mac_in;

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
    19 => this.buttons["record_arm"];
    29 => this.buttons["solo"];
    39 => this.buttons["mute"];
    49 => this.buttons["stop_clip"];
    59 => this.buttons["send_b"];
    69 => this.buttons["send_a"];
    79 => this.buttons["pan"];
    89 => this.buttons["volume"];
    91 => this.buttons["arrow_up"];
    92 => this.buttons["arrow_down"];
    93 => this.buttons["arrow_left"];
    94 => this.buttons["arrow_right"];
    95 => this.buttons["session"];
    96 => this.buttons["note"];
    97 => this.buttons["custom"];
    98 => this.buttons["capture"];

    99 => int logo;

    function void connect()
    {
        /*
            connect MIDI in/out
        */

        if(!this.from_LP.connect(this.device_name_mac_out))
        {
            if(!this.from_LP.connect(this.device_name_linux))
            {
                chout <= "issue connecting LP X - INPUT";
                me.exit();
            }
        }

        if(!this.to_LP.connect(this.device_name_mac_in))
        {
            if(!this.to_LP.connect(this.device_name_linux))
            {
                chout <= "issue connecting LP X - INPUT";
                me.exit();
            }
        }
    }

    function void set_led(int id, int color, int mode)
    {
        /*
            set specific LED
            mode: 0.static, 1.flash, 2.pulse
        */

        if(id % 10 != 9)
            this.msg_out.note_on(id, color, mode+1);
        else
            this.msg_out.cc(color, id, mode+1);
        this.to_LP.send(this.msg_out);
    }

    function void set_led(string name, int color, int mode)
    {
        /*
            set specific LED
            mode: 0.static, 1.flash, 2.pulse
        */

        this.msg_out.cc(color, this.buttons[name], mode+1);
        this.to_LP.send(this.msg_out);
    }

    function void set_leds(int list[])
    {
        /*
            set specific LED
            pairs of id, color - ie [11, 120, 35, 100] where index 0 and 3 are IDs and index 1 and 3 are colors
        */

        for(0 => int c; c < list.size()/2; c++)
        {
            list[c*2]       => int id;
            list[(c*2) + 1] => int color;
            if(id % 10 != 9)
                this.msg_out.note_on(id, color, 1);
            else
                this.msg_out.cc(color, id, 1);
            this.to_LP.send(this.msg_out);
        }
    }

    function void set_row(int row, int color, int mode)
    {
        /*
            set entire row
        */

        row % 9 => row;
        (row*10) + 11 => int offset;
        for(0 => int c; c < 9; c++)
        {
            this.set_led(c+offset, color, mode);
        }
    }

    function void set_column(int column, int color, int mode)
    {
        /*
            set entire column
        */

        column%9 => column;
        11+column => int offset;
        for(0 => int c; c < 9; c++)
        {
            this.set_led((c*10)+offset, color, mode);
        }
    }

    function void set_all(int color, int mode)
    {
        /*
            set all pads
        */

        for(0 => int c; c < 100; c++)
        {
            this.set_led(c, color, mode);
        }
    }

    function void clear()
    {
        /*
            clear whole surface
        */

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
        this.to_LP.send([240, 0, 32, 41, 2, 12, 14, status, 247]);
    }
}