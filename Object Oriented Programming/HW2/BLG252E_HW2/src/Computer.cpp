//Abdullah Jafar Mansour Shamout
//150200919

#include <iostream>
#include "Computer.h"

ALU::ALU(const int NUM): NUM_PER_CORES{NUM} {     //using an initializer list to initialize NUM_PER_CORES in the ALU constructor (as its a constant), also im printing that the ALU is ready
    std::cout << "ALU is ready" << std::endl;
};

CUDA::CUDA(const int NUM): NUM_CORES{NUM} {      //using an initializer list to initialize NUM_CORES in the CUDA constructor (as its a constant), also im printing that the CUDA is ready
    std::cout << "CUDA is ready" << std::endl;
};


CPU::CPU(const int NUM): ALU_OBJ{NUM}{          //CPU constructor that utilizes the ALU constructor to initialize its NUM_PER_CORES, also prints that the CPU is ready
    std::cout << "CPU is ready" << std::endl;
};

const int CPU::execute(const std::string& operation) const {    //CPU execute function takes a constant refrence to string as we dont change it and its more efficient, I also return a const int as the value wont be changed
    std::cout << "Enter two integers" << std::endl;             //asks for two integers to send them to the ALU functions responsible for them
    int temp1, temp2, result;
    std::cin >> temp1 >> temp2;                 //takes input for the operands
    if (operation == "add") {                   //controling the operation using if, else if, and else statements 
        result = ALU_OBJ.add(temp1, temp2);         
    }
    else if(operation == "subtract") {
        result = ALU_OBJ.subtract(temp1, temp2);
    }
    else {                                      //here I didnt put an else if as for the program required and according to the main function there is only three operations that can be sent, thus there is no need for checking after I checked for addition and subtraction
        result = ALU_OBJ.multiply(temp1, temp2);    
    }
    return result;
};

GPU::GPU(const int NUM): CUDA_OBJ{NUM} {        //GPU constructor that utilizes the CUDA constructor to initialize its NUM_CORES, also prints that the GPU is ready
    std::cout << "GPU is ready" << std::endl;
};

const std::string GPU::execute(const std::string &operation) const {    //GPU execute function takes a constant refrence to string as we dont change it and its more efficient, I also return a const string as the value wont be changed
    if(operation == "render"){                                          //check for whether the function is render or train model, only one check is enough since input will be either render or train model since other inputs were not defined in main and no error input condition was givin in the assignment
        return CUDA_OBJ.render();
    }
    else{
        return CUDA_OBJ.trainModel();
    }
};

Computer::Computer()
{
    std::cout << "Computer is ready" << std::endl;             //constructor used to print that the computer is ready
};

void Computer::operator+(const CPU& ATTACHMENT) {              //Operator overload function to attach my CPU
    if(get_ATTACHED_CPU() == nullptr){                         //I check if my CPU ATTACHMENT slot is empty by checking the address for nullptr
        set_ATTACHED_CPU(ATTACHMENT);                          //if it is I use my setter function
        std::cout << "CPU is attached" << std::endl;           //and print that the ATTACHMENT was successful
    }
    else{
        std::cout << "There is already a CPU" << std::endl;    //if not, I print that there is already an ATTACHMENT 
    }
    return;
};

void Computer::operator+(const GPU& ATTACHMENT) {               //Operator overload function to attach my GPU
    if(get_ATTACHED_GPU() == nullptr){                          //I check if my GPU ATTACHMENT slot is empty by checking the address for nullptr
        set_ATTACHED_GPU(ATTACHMENT);                           //if it is I use my setter function
        std::cout << "GPU is attached" << std::endl;            // and print that the ATTACHMENT was successful
    }
    else{
        std::cout << "There is already a GPU" << std::endl;    //if not, I print that there is already an ATTACHMENT 
    }
    return;
};

void Computer::execute(const std::string& operation) const {    //execute function of the computer that decides which execute function is going to be called according to the operation given to it
    if(operation == "add" || operation == "subtract" || operation == "multiply"){
        std::cout << get_ATTACHED_CPU()->execute(operation) << std::endl;   //the get function gets the address of the attached CPU then using -> operator I can access that objects execute function
    }
    else{
        std::cout << get_ATTACHED_GPU()->execute(operation) << std::endl;   // the get function gets the address of the attached GPU then using -> operator I can access that objects execute function
    }
    return;
};