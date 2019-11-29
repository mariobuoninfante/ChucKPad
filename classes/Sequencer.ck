// Sequencer.ck  
//
// Basic Multi Track Euclidean Sequencer Class
//
// @author         Mario Buoninfante
// @copyright      2019 


public class Sequencer
{
    Shred SHRED;
    Pattern Track[0];

    96                      =>      int TICKS;           // MIDI ticks per bar
    0                       =>      int STATUS;          // == 0 stop, != 0 play
    87                      =>      float bpm;
    bpm2ms(this.bpm)        =>      float quarter_ms;
    this.quarter_ms / 24.   =>      float tick_ms;


    function void play(int x)
    {
        x => this.STATUS;

        if(x)
            spork ~ _run(x) @=> SHRED;
        else
            Machine.remove(SHRED.id());
    }

    function void _run(int x)
    {
        if(x)
        {
            for(0 => int c; c < this.Track.size(); c++)
            {
                Track[c].reset_pointer();
            }
        }

        0 => int c;

        while(STATUS)
        {
            for(0 => int c; c < this.Track.size(); c++)
            {
                Track[c].advance();
            }

            this.quarter_ms*0.25::ms => now;    // advance in 16th
        }
    }

    function void set_track(int t_nr, int steps, int ones, int offset)
    {
        this.Track[t_nr].set_sequence(steps, ones, offset);
    }

    function float set_bpm(float x)
    {
        x                       => this.bpm;
        bpm2ms(bpm)             => this.quarter_ms;
        this.quarter_ms / 24.   => this.tick_ms;
    }

    function float bpm2ms(float x)
    {
        (60000. / x) => this.quarter_ms;
        return this.quarter_ms;
    }

    function void loadsample(int t_nr, string sample_name)
    {
        this.Track[t_nr].loadsample(sample_name);
    }

    function void smart_offset(int t_nr, int x)
    {
        this.Track[t_nr].set_smart_offset(x);
    }

    function void track_nr(int nr)
    {
        this.Track.clear();
        repeat(nr)
        {
            this.Track << new Pattern;
        }
    }
}

private class Pattern
{
    //--------------
    // pattern-track
    //--------------

    SndBuf sample => dac;
    this.sample.rate(0);
    this.sample.gain(0.2);

    Euclidean Euclidean;

    0 => int pointer;
    int sequence[0];

    function void loadsample(string sample_name)
    {
        this.sample.read(sample_name);
    }

    function void reset_pointer()
    {
        -1 => this.pointer;
    }

    function void advance()
    {
        // advance in time
        if(this.sequence.size() > 0)
        {
            (this.pointer + 1) % this.sequence.size() => this.pointer;
            if(this.sequence[this.pointer] != 0)
                this.trigger();
        }
    }

    function void set_sequence(int steps, int ones, int offset)
    {
        // set sequence

        this.Euclidean.set(steps, ones, offset) @=> this.sequence;
    }

    function void set_smart_offset(int x)
    {
        this.Euclidean.set_smart_offset(x);
    }

    function void trigger()
    {
        // trigger sample

        this.sample.rate(0);
        this.sample.pos(0);
        this.sample.rate(1);
    }
}

private class Euclidean
{
    0 => int offset;
    int steps;
    int ones;
    0 => int smart_offset;
    int pattern[0];

    fun int[] set(int st, int on, int off)
    {        
        /*
            euclidean rhythm generator
        */

        st   => this.steps;
        on    => this.ones;

        if(!this.smart_offset)
        {
            // if offset argument is -1 don't change this.offset 
            if(off >= 0)
                off => this.offset;
        }
        else
        {
            if(this.ones < 4)
                4 => this.offset;
            else if(this.steps >= 4)
                2 => this.offset;
        }

        this.pattern.clear();
        this.pattern.size(this.steps);

        if(this.steps < this.ones)
        {               
            // create the Euclidean Rhythm
            this.steps => this.ones;
            chout <= "ATTENTION: (ones > steps)" <= IO.nl();
        }

        if(ones != 0)
        {
            this.steps/(this.ones $ float) => float increment;
            for(0 => int c; c < this.ones; c++)
            {
                1 => this.pattern[((Math.round(c*increment) $ int) + offset) % this.steps];
            }
        }
        
        this.print();
        
        return pattern;
    }

    function void set_smart_offset(int x)
    {
        x => this.smart_offset;
    }


    fun int get(int x)
    {
        /*
            return value at position 'x'
        */

        return pattern[((x + this.offset) % this.steps)];
    }


    fun void print()
    {
        /*
            print rhythm / array
        */

        for(0 => int c; c < this.pattern.size(); c++)
        {
            if(this.pattern[c])
            {
                chout <= " X ";
            }
            else
            {
                chout <= " - ";
            }
        }
        chout <= IO.nl();
    }
}
