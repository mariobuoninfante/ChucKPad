/*
     *  VM_Status.ck
     *  ---
     *  constantly print virtual machine status to the console
     *
     *  @author         Mario Buoninfante
     *  @copyright      2019 
*/


while(true)
{
    Machine.status();
    5::second => now;
}