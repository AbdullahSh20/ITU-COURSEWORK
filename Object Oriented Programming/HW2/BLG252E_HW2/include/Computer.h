//Abdullah Jafar Mansour Shamout
//150200919
class ALU{
    public:
        ALU(const int NUM);    //constructor of the ALU is called by CPU to set the NUM_PER_CORES
        //since the following operations are short and fast, I think making them inline is better than writing them outside the declaration of the body as writing them outside would be inefficient
        const int add(const int Operand1, const int Operand2) const { return Operand1 + Operand2; };    //add function; adds two operands and returns the sum, since no variable is being changed everything is a const
        const int subtract(const int Operand1, const int Operand2) const { return Operand1 - Operand2; };   //subtract function; subtracts two operands and returns the difference, since no variable is being changed everything is a const
        const int multiply(const int Operand1, const int Operand2) const { return Operand1 * Operand2; };   //multiply function; multiplies two operands and returns the result, since no variable is being changed everything is a const

    private:
        const int NUM_PER_CORES{};  //const variable set from the CPU through the ALU's constructor
};

class CUDA{
    public:
        CUDA(const int NUM);    //constructor of the CUDA is called by the GPU to set the NUM_CORES 
        //since the following operations are short and fast, I think making them inline is better than writing them outside the declaration of the body as writing them outside would be inefficient
        const std::string render() const { return "Video is rendered"; };   //render function; returns the string video is rendered
        const std::string trainModel() const { return "AI Model is trained"; };    //train model funtion; returns the ai model is trained

    private:
        const int NUM_CORES{};  //const variable set from the GPU through the CUDA's constructor
};

class CPU{
    public:
        CPU(const int NUM);    //CPU constructor takes a const int to set the NUM_PER_CORES of the ALU through its constructor
        const int execute(const std::string& operation) const;    //execute function of the CPU that deligates the operation to the responsible function of the ALU

    private:
        const ALU ALU_OBJ;    //ALU object of the CPU
};

class GPU{
    public:
        GPU(const int NUM);    //GPU constructor takes a const int to set the NUM_CORES of the CUDA through its constructor
        const std::string execute(const std::string& operation) const;      //execute function of the GPU that deligates the operation to the responsible function of the GPU

    private:
        const CUDA CUDA_OBJ;    //CUDA object of the GPU 
};

class Computer{
    public:
        Computer();    //constructor used to print that the computer is ready

        void operator+(const CPU& ATTACHMENT);    //an overload for the + operator that attaches a CPU ATTACHMENT to the computer, takes a refrence to a constant CPU ATTACHMENT
        void operator+(const GPU& ATTACHMENT);    //an overload for the + operator that attaches a GPU ATTACHMENT to the computer, takes a refrence to a constant GPU ATTACHMENT
        
        void execute(const std::string& operation) const;   //execute function decides which ATTACHMENT should have the operation delegated to (CPU or GPU) it also does the printing as it gets the values from the ATTACHMENTs' own execute functions

    private:    //My setters and getters are both inline functions because their code is very short and having them as inline would be more effictive
        void set_ATTACHED_CPU(const CPU& ATTACHMENT) { this->ATTACHED_CPU = &ATTACHMENT; };    //setter that takes a constant refrance to a CPU attacment and sets the ATTACHED_CPU pointer to the ATTACHMENT's address
        void set_ATTACHED_GPU(const GPU& ATTACHMENT) { this->ATTACHED_GPU = &ATTACHMENT; };    //setter that takes a constant refrance to a GPU attacment and sets the ATTACHED_GPU pointer to the ATTACHMENT's address
        //My getters are const functions as they dont change any attribute data
        const CPU *get_ATTACHED_CPU() const{ return this->ATTACHED_CPU; };    //getter that returns the address of the attached CPU object 
        const GPU *get_ATTACHED_GPU() const{ return this->ATTACHED_GPU; };    //getter that returns the address of the attached CPU object
        
        const CPU *ATTACHED_CPU{nullptr};    //pointer to the attached CPU, initialized as nullptr, the object pointed to is a const as it must not be changed
        const GPU *ATTACHED_GPU{nullptr};    //pointer to the attached GPU, initialized as nullptr, the object pointed to is a const as it must not be changed
};