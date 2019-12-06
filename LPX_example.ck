//---------------------------------
// load LPX_example_libraries first
//---------------------------------



// create a Launchpad X Object
LPX LPX;

// ChucK <=> Launchpad X
LPX.connect();
// enter programmer mode
LPX.programmer_mode(1);

//-----------------
//-----------------
// clear the surface - in case we were already in programmer mode and pads were lit already
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// set a single LED to green - static
LPX.set_led(34, 24, 0);
3::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// set a single LED to green - flash
LPX.set_led(64, 24, 1);
3::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// set a single LED to yellow - pulse
LPX.set_led(12, 13, 2);
3::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// set a multiple LEDs - stating
LPX.set_leds([12,120, 71,24, 99,78]);
3::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// set all LEDs to 'blue' - stating
LPX.set_all(48, 0);
2::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// light up columns
for(0 => int c; c < 9; c++)
{
    // set all LEDs to 'blue' - stating
	LPX.set_column(c, Math.random2(1, 127), 0);
	100::ms => now;
}
2::second => now;
// clear the surface
LPX.clear();
0.1::second => now;


//-----------------
//-----------------
// light up rows
for(0 => int c; c < 9; c++)
{
    // set all LEDs to 'blue' - stating
    LPX.set_row(c, Math.random2(1, 127), 0);
    100::ms => now;
}
2::second => now;
// clear the surface
LPX.clear();
0.1::second => now;