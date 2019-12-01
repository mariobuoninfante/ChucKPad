//-------------------------------------
// playback several samples in parallel
//-------------------------------------



// audio file name (includes its location)
me.dir(1) + "/audio/kick.wav" => string file1;
me.dir(1) + "/audio/snare.wav" => string file2;


// launch parallel 'shreds' (ChucK equivalent of threads)
spork ~ loop(file1, [1.,0.,1.,0.], 250::ms);
spork ~ loop(file2, [0.,0.,1.,0.], 250::ms);


// MAIN LOOP - needed to keep all the shreds alive
while(true)
{
    second => now;
}



//---------------------------
//---------FUNCTIONS---------
//---------------------------

// functions are piece of reusable code

function void loop(string filename, float patt[], dur patt_rate)
{
    SndBuf sample => dac;
    sample.read(filename);

    // set playback rate to 0 so that SndBuf doesn't play by default
    0 => float playback_rate;
    sample.rate(playback_rate);

    patt @=> float pattern[];

    // equivalent of the 'tape head' on tape machines
    // this is used to 'scan' the 'pattern' array
    0 => int pointer;

    // endless loop
    while(true)
    {
        // reset playback head to initial position
        sample.pos(0);
        sample.rate(pattern[pointer]);

        patt_rate => now;

        // increase the read head by one and make sure
        // it wraps when reaching the end of the 'pattern' array 
        (pointer + 1) % pattern.size() => pointer;
    }
}
