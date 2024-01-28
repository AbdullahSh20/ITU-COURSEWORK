#include <iostream>
#include "Computer.h"
#include <string>

int main(){

    Computer myComputer{}; // instance of a computer
    
    CPU myCPU{6};    // instance of a CPU with 6 ALUs per each core.
    GPU myGPU{1344};    // instance of a GPU with 1344 cuda cores.
    myComputer + myCPU;
    myComputer + myGPU;  

    CPU myCPU2{10};    // instance of a CPU with 10 ALUs per each core.
    GPU myGPU2{2000};  // instance of a GPU with 2000 cuda cores.

    myComputer + myCPU; 
    myComputer + myGPU; 

    // Testing operations
    // There are 5 operations at all
    const size_t numberOfOperations{ 5 };
    std::string operations[numberOfOperations]{"subtract","render", "trainModel","add", "multiply"};

    for (size_t i = 0; i < numberOfOperations; i++)
    {
        // loop iterating over batches of operations
       std::string currentOperation = operations[i];
       std::cout<<"Operation type is:"<<std::endl;
       std::cout<<currentOperation<<std::endl;
       myComputer.execute(currentOperation);
    }    
}
