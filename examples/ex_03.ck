//-------------------------
// playback an audio sample
//-------------------------


// SndBuf is used to playback monophonic audio files
// SndBuf2 deals with stereo files 
SndBuf sample => dac;

// audio file name (includes its location)
me.dir(1) + "/audio/kick.wav" => string filename;

<<< "LOADING: " + filename >>>;

// load audio file in SndBuf UGen
sample.read(filename);

// playback speed - 1. original, 2. twice as fast, 0.5. half the rate
1 => float playback_rate;

sample.rate(playback_rate);

while(true)
{
    // reset playback head to initial position
    sample.pos(0);

    400::ms => now;
}

