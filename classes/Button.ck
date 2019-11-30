// Button.ck  
// ---
// Button/Toggle Class
// 
// @author         Mario Buoninfante
// @copyright      2019 


public class Button
{
    LPX LPX;

    0   => int type;            // 0. momentary button, 1. toggle
    0   => int status;
    0   => int pad_midi;        // 0. note on/off, 1. ctrl change
    -1  => int id;
    0   => int OFF_COLOR;       // replaced in create()
    120 => int ON_COLOR;        // RED


    function void link(LPX ExtLPX)
    {
        // link to external LPX
        
        ExtLPX @=> this.LPX;
    }

    function void create(int pad_id, int col, int b_type)
    {
        // initialize Button object

        col & 127       => this.OFF_COLOR;
        pad_id & 127    => this.id;
        ((this.id % 10) == 9) => this.pad_midi;   // check whether we're dealing with note on/off or control change
        b_type != 0     => this.type;
        this.LPX.set_led(this.id, this.OFF_COLOR, 0);   // 3rd arg is LED mode: 0 is for static
    }

    function int press()
    {
        // highlight pressed pad if part of the square - return 1 when press happens, 0 otherwise (since this can be called but no press takes place)
        
        // if we're dealing with note on/off
        if(!this.pad_midi)
        {
            // if type is TOGGLE
            if(this.type)
            {
                // if NOTE ON - pad press
                if(this.LPX.msg_in.data1 >> 4 == 9)
                {
                    if(this.LPX.msg_in.data2 == this.id)
                    {
                        // flip 'status' value
                        (this.status + 1) & 1 => this.status;
                        if(!this.status)
                            this.LPX.set_led(this.id, this.ON_COLOR, 0);
                        else
                            this.LPX.set_led(this.id, this.OFF_COLOR, 0);
                        
                        return 1;
                    }
                }
            }
            // if type is MOMENTARY
            else
            {
                // if NOTE ON - pad press
                if(this.LPX.msg_in.data1 >> 4 == 9)
                {
                    if(this.LPX.msg_in.data2 == this.id && this.LPX.msg_in.data3 != 0)
                    {
                        1 => this.status;
                        this.LPX.set_led(this.id, this.ON_COLOR, 0); 
                        return 1;
                    }
                }
                // if NOTE OFF - pad release
                else if(this.LPX.msg_in.data1 >> 4 == 8)
                {
                    if(this.LPX.msg_in.data2 == this.id)
                    {
                        0 => this.status;
                        this.LPX.set_led(this.id, this.OFF_COLOR, 0);
                        return 1;
                    }
                }
            }
        }

        else
        {
            // if type is TOGGLE
            if(this.type)
            {
                // if CTRL CH
                if(this.LPX.msg_in.data1 >> 4 == 11)
                {
                    if(this.LPX.msg_in.data2 == this.id && this.LPX.msg_in.data3 != 0)
                    {
                        // flip 'status' value
                        (this.status + 1) & 1 => this.status;
                        if(!this.status)
                            this.LPX.set_led(this.id, this.OFF_COLOR, 0);
                        else
                            this.LPX.set_led(this.id, this.ON_COLOR, 0);
                        
                        return 1;
                    }
                }
            }

            // if type is MOMENTARY
            else
            {
                // if CTRL CH
                if(this.LPX.msg_in.data1 >> 4 == 11)
                {
                    if(this.LPX.msg_in.data2 == this.id)
                    {
                        if(this.LPX.msg_in.data3 != 0)
                        {
                            1 => this.status;
                            this.LPX.set_led(this.id, this.ON_COLOR, 0);
                        } 
                        else 
                        {
                            0 => this.status;
                            this.LPX.set_led(this.id, this.OFF_COLOR, 0);
                        }
                        return 1;
                    }
                }
            } 
        }
        return 0;
    }


    function int get()
    {
        // return Button's 'status'

        return this.status;
    }
}