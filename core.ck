/*
    ChucKPad
    --------
    ChucK Programming Language + Novation Launchpad
*/

chout <= "\nChucKPad\n--------\nChucK Programming Language + Novation Launchpad\n" <= IO.nl();

MidiLib MidiLib;
LPX LPX;

LPX.connect();
LPX.programmer_mode(1);

// MAIN
while(true)
{
    LPX.from_LP => now;
    while(LPX.from_LP.recv(LPX.msg_in))
    {
        LPX.set_pad(LPX.msg_in.data2, LPX.msg_in.data3);
        <<< LPX.msg_in.data1, LPX.msg_in.data2, LPX.msg_in.data3 >>>;
    }
}