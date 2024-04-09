//Example of a C++ program calling asm functions

//The asm file and the C++ file cannot have the same name
//otherwise you will get a linking error

//you should put the asm file and the C++ file under
//source files in your VC++ project.

#include <iostream>

using namespace std;

//use the syntax below to declare the assembly routine prototype.
//If more than one argument, arguments are pushed right to left.

//parameters are pushed right to left

//asm function to multiply 2 ints
extern "C" int __stdcall multiply(int,int);  //prototype for asm function

//asm function to display int to console
extern "C" void __stdcall DspDword(int);    //prototype for asm function

int main()
{
    int num1 = 256;                      //operand 1 for multiply function below
    int num2 = 5;                        //operand 2 for multiply function below
    int product;                         //var to store result

    product = multiply(num1,num2);       // Call ASM function to multiply num1*num2
    
    cout << product << endl;             //call c++ cout to display result to screen
    
    DspDword(product);                   //call asm function, DspDword, to display result to screen

    return 0;                            //return to dos with success code
}

