// Square.ck  
// ---
// Draw square on LP X 
// 
// @author         Mario Buoninfante
// @copyright      2019 



public class Square
{
    LPX LPX;

    int pad_ids[0];             // store pads in use and their status - ie pairs of pad_nr, status (0-1) 

    120 => int SELECTED;        // color for selected pads - RED
    24  => int DEFAULT;         // default color / not-selected
    0  => int current_pad_id;
    0  => int prev_pad_id;

    function void link(LPX ExtLPX)
    {
        /*
            link to external LPX
        */
        ExtLPX @=> this.LPX;
    }

    function void create(int xpos, int ypos, int size, int color)
    {
        /*
            draw a square on LP X surface (pads only)
            xpos and ypos limits are dictated by the size of the square
        */

        color => this.DEFAULT;
        0 => int mode;      // static color
        Math.min(8, Math.max(1,size)) $ int => size;
        Math.min(8-size, Math.max(0,xpos)) $ int => xpos;
        Math.min(8-size, Math.max(0,ypos)) $ int => ypos;
        size*size => int sq_size;
        
        for(0 => int c; c < sq_size; c++)
        {
            (c % size) + xpos   => int x;
            ((c / size)+ypos)*8 => int y;
            this.LPX.set_led(this.LPX.pads[x+y], color, mode);
            this.pad_ids << this.LPX.pads[x+y];    // store pad in use
            this.pad_ids << 0;      // store pad status
        }
    }

    function int press()
    {
        // highlight pressed pad if part of the square - return 1 when press occurs, otherwise return 0


        // if NOTE ON
        if(this.LPX.msg_in.data1 >> 4 == 9)
        {
            for(0 => int c; c < this.pad_ids.size()/2; c++)
            {
                // check if the msg matches with any of the pad ids
                if(this.LPX.msg_in.data2 == this.pad_ids[c*2])
                {
                    c*2 => this.current_pad_id;

                    // flip the status
                    this.pad_ids[(this.current_pad_id)+1] => int status;
                    (status + 1) % 2 => status;
                    status => this.pad_ids[(this.current_pad_id)+1];

                    // set pad color
                    if(status)
                        this.LPX.set_led(this.LPX.msg_in.data2, this.SELECTED, 0);
                    else
                        this.LPX.set_led(this.LPX.msg_in.data2, this.DEFAULT, 0);

                    // if pad pressed is different from last one pressed, set the previous one to DEFAULT color
                    if(this.current_pad_id != this.prev_pad_id)
                    {
                        this.LPX.set_led(this.pad_ids[this.prev_pad_id], this.DEFAULT, 0);
                        0 => this.pad_ids[this.prev_pad_id + 1];
                    }
                    
                    this.current_pad_id => this.prev_pad_id;
                    return 1;
                }
            }
        }

        return 0;
    }

    function int get()
    {
        /*
            return select pad id - return 0 if none is selected
        */

        if(this.pad_ids[this.current_pad_id + 1])
            return (this.current_pad_id / 2) + 1;
        else
            return 0;
    }
}