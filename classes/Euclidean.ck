//  *  Euclidean.ck  
//  *
//  *  Ecuclidean Rhythm Generator
//  *
//  *  @author         Mario Buoninfante
//  *  @copyright      2019 


public class Euclidean
{
    0       => int offset;
    int steps;
    int ones;
    int pattern[0];

    fun void set(int steps, int ones)
    {        
        /*
            generate euclidean rhythm - set steps and ones and fill the array
        */

        steps   => this.steps;
        ones    => this.ones;

        this.pattern.size(this.steps);

        if(this.steps < this.ones)
        {               
            // create the Euclidean Rhythm
            this.steps => this.ones;
            chout <= "ATTENTION: (ones > steps)" <= IO.nl();
        }

        for(0 => int c; c <= this.ones; c++)
        {
            Math.round(c*(this.steps/this.ones)) $ int => int ones_index;
            1 => this.pattern[((ones_index) % this.steps) $ int];
        }
    }


    fun int play(int c)
    {
        /*
            return value at position 'c'
        */

        return pattern[((c+this.offset) % this.steps) $ int];
    }


    fun void print()
    {
        /*
            print rhythm / array
        */

        chout <= "------------------------NEW PATTERN-----------------------\n";
        for( 0 => int c; c < this.steps; c++ )
        {
            chout <= this.pattern[c] <= " ";
        }
        chout <= IO.nl();
    }
}
