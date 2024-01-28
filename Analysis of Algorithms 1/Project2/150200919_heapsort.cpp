// Author: Abdullah Jafar Mansour Shamout
// Student ID: 150200919
// Project 2
#include <iostream> // needed for input and output
#include <vector>   // needed for vector
#include <cstring>  // needed for strlen for parsing optional arguments
#include <fstream>  // needed for file input and output
#include <sstream>  // needed for file input and output
#include <chrono>   // needed for timing
#include <string>   // needed for parsing optional for population name and population number
#include <cmath>    // needed for calculating height of d-ary heap using log

//////////////////////////////////////////////////////// data definitions ////////////////////////////////////////////////////////
// population struct to hold the data of each population from the input file

struct Population
{
    std::string name = "";
    int population = 0;
};

// enum to hold the operation name
enum Operation
{
    MAX_HEAPIFY,
    BUILD_MAX_HEAP,
    HEAPSORT,
    MAX_HEAP_INSERT,
    HEAP_EXTRACT_MAX,
    HEAP_INCREASE_KEY,
    HEAP_MAXIMUM,
    DARY_CALCULATE_HEIGHT,
    DARY_EXTRACT_MAX,
    DARY_INSERT_ELEMENT,
    DARY_INCREASE_KEY,
    UNKNOWN_OPERATION
};

//////////////////////////////////////////////////////// function definitions ////////////////////////////////////////////////////////

////////////////////////////////////////////////////////// Heap Operations ///////////////////////////////////////////////////////////

// Utilizes last index as array size because it uses it to check if the child is out of bounds so must be called with array.size() - 1
void max_heapify(std::vector<Population> &array, const int &i, const int &array_size); // getting array, index of element, and array size

// I do the needed editions to the function to make it work with the array starting from 0 and not 1 so calling it with array.size() is fine
void build_max_heap(std::vector<Population> &array, const int &array_size); // getting array and size of array

// heap-sort(A) I do the needed editions to the function to make it work with the array starting from 0 and not 1 so calling it with array.size() is fine
void heapsort(std::vector<Population> &array, const int &array_size); // getting array and size of array

//////////////////////////////////////////////////////// Priority Queue Operations ////////////////////////////////////////////////////////

// the key here is a population struct so in the command line it must be given as k_YYYY_XXXX where YYYY is the population name and XXXX is the population number
void max_heap_insert(std::vector<Population> &array, const Population &key);

// does extraction by deleting the last element and calling max-heapify on the first element
Population heap_extract_max(std::vector<Population> &array);

// Utilizes the i and k inputs from the command line. K would be given as KXXXX where XXXX is the new key. I is the index of the element to increase the key of
// I am assuming the index refers to the index of the element in the heap after it is built and not the index of the element in the array before it is built
void heap_increase_key(std::vector<Population> &array, int i, const int &key);

// prints the maximum element without deleting it
Population heap_maximum(std::vector<Population> &array);

////////////////////////////////////////////////////// d-ary Heap Operations //////////////////////////////////////////////////////

// Eventhough this function is not requested, it is needed to create the functions below so I created it
void dary_max_heapify(std::vector<Population> &array, const int &i, const int &array_size, const int &d);

// Eventhough this function is not requested, it is needed to create the functions below so I created it
void dary_build_max_heap(std::vector<Population> &array, const int &array_size, const int &d);

// height of d-ary heap
int dary_calculate_height(const int &array_size, const int &d); // getting array size and d

// extract max from d-ary heap
Population dary_extract_max(std::vector<Population> &array, const int &d); // getting array and d

// insert into d-ary heap
void dary_insert_element(std::vector<Population> &array, const Population &key, const int &d); // getting array, key, and d

// increase key of d-ary heap
// I am assuming the index refers to the index of the element in the heap after it is built and not the index of the element in the array before it is built
void dary_increase_key(std::vector<Population> &array, int i, const int &key, const int &d); // getting array, index of element, key, and d

// d-ary heapsort
// added the function in case it is wanted, but it is not callable since it was not requested
void dary_heapsort(std::vector<Population> &array, const int &array_size, const int &d); // getting array and size of array and d

//////////////////////////////////////////////////////// Helper functions ////////////////////////////////////////////////////////

// function to process optional arguments
int processOptionalArguments(const int &argc, char **argv, int &numChildren, int &index, int &key_population, std::string &key_name);

// read file
int read_file(const std::string &file_name, std::vector<Population> &population);

// write file
int write_file(const std::string &output_file_name, const std::vector<Population> &population);

// function to convert function name to operation
Operation function_name_to_operation(const std::string &function_name);

// swap array values
void swap_array_value(std::vector<Population> &array, const int &i, const int &j);

// print the array for debugging
void printArray(const std::vector<Population> &arr);

int main(int argc, char **argv)
{
    if (argc < 4) // if there are less than 4 arguments, then we are missing either file name, function name, or output file name since first argument is always the program name and the rest of the arguments after 4 are optional
    {
        std::cerr << "Missing arguments" << std::endl;
        return 1;
    }

    const std::string file_name = argv[1];
    const std::string function_name = argv[2];
    const std::string output_file_name = argv[3];

    int numChildren = -1;      // -1 indicating that the user did not specify a value through the arguments at the start
    int index = -1;            // -1 indicating that the user did not specify a value through the arguments at the start
    int key_population = -1;   // -1 indicating that the user did not specify a value through the arguments at the start
    std::string key_name = ""; // empty string indicating that the user did not specify a value through the arguments at the start
    int output_method = -1;    // -1 initial value. Used to determine what to output, could be a single value in case of using max functions or entire array in case of using other functions
    Population max;            // used to store the max value in case of using max functions
    int height;                // used to store the height in case of using height function

    // process optional arguments
    if (processOptionalArguments(argc, argv, numChildren, index, key_population, key_name) != 0)
    {
        std::cerr << "Error processing optional arguments" << std::endl;
        return 1;
    }

    // convert function name to operation to use in switch case since switch case does not work with strings
    Operation operation = function_name_to_operation(function_name);

    // vector to hold the data from the input file
    std::vector<Population> population;

    // read the file and store the data in the vector
    if (read_file(file_name, population) != 0)
    {
        std::cerr << "Error reading file" << std::endl;
        return 1;
    }

    // start timing
    const auto start{std::chrono::steady_clock::now()};

    // switch case to call the function based on the operation
    switch (operation)
    {
    case Operation::MAX_HEAPIFY:
        if (index == -1) // if index is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing index" << std::endl;
            return 1;
        }
        max_heapify(population, index, population.size() - 1); // subtract 1 because array starts from 0 and not 1 and max_heapify takes last index as array size because it uses it to check if the child is out of bounds, also used index from the optional arguments
        break;
    case Operation::BUILD_MAX_HEAP:
        build_max_heap(population, population.size()); // no need for optional argument here because it is not used
        break;
    case Operation::HEAPSORT:
        heapsort(population, population.size()); // no need for optional argument here because it is not used
        break;
    case Operation::MAX_HEAP_INSERT:
        if (key_population == -1 || key_name == "") // if key_population is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing key population or name or both" << std::endl;
            return 1;
        }
        max_heap_insert(population, Population{key_name, key_population}); // using optional arguments here to insert the key. utilized k_YYYY_XXXX structure
        break;
    case Operation::HEAP_EXTRACT_MAX:
        max = heap_extract_max(population); // no need for optional argument here because it is not used
        if (max.population == -1)           // if max.population is -1, then the function returned an error
        {
            return 1;
        }
        break;
    case Operation::HEAP_INCREASE_KEY:
        if (index == -1 || key_population == -1) // if index or key_population is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing index or key population or both" << std::endl;
            return 1;
        }
        heap_increase_key(population, index, key_population); // using optional arguments here to increase the key. utilized KXXXX structure
        break;
    case Operation::HEAP_MAXIMUM:
        max = heap_maximum(population); // no need for optional argument here because it is not used
        if (max.population == -1)       // if max.population is -1, then the function returned an error
        {
            return 1;
        }
        break;
    case Operation::DARY_CALCULATE_HEIGHT:
        if (numChildren == -1) // if numChildren is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing number of children" << std::endl;
            return 1;
        }
        else if (numChildren == 1)
        {
            height = population.size() - 1; // subtract 1 because array starts from 0 and not 1
        }
        else
        {
            height = dary_calculate_height(population.size(), numChildren); // using optional argument numChildren here to calculate the height
        }
        break;
    case Operation::DARY_EXTRACT_MAX:
        if (numChildren == -1) // if numChildren is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing number of children" << std::endl;
            return 1;
        }
        max = dary_extract_max(population, numChildren); // using optional argument numChildren here to extract the max
        if (max.population == -1)                        // if max.population is -1, then the function returned an error
        {
            return 1;
        }
        break;
    case Operation::DARY_INSERT_ELEMENT:
        if (numChildren == -1 || key_population == -1 || key_name == "") // if numChildren or key_population is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing number of children or key population or name or any combination of them" << std::endl;
            return 1;
        }
        dary_insert_element(population, Population{key_name, key_population}, numChildren); // using optional arguments numChildren and key_population here to insert the key. utilized k_YYYY_XXXX structure
        break;
    case Operation::DARY_INCREASE_KEY:
        if (numChildren == -1 || index == -1 || key_population == -1) // if numChildren or index or key_population is -1, then the user did not specify a value through the arguments at the start
        {
            std::cerr << "Missing number of children or index or key population or any combination of them" << std::endl;
            return 1;
        }
        dary_increase_key(population, index, key_population, numChildren); // needs editing
        break;
    default:
        std::cerr << "Invalid operation" << std::endl;
        return 1;
    }

    const auto end{std::chrono::steady_clock::now()};                                                 // end timing
    const auto time = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);              // calculate time taken
    std::cout << "Time taken by " << function_name << " is: " << time.count() << " ns." << std::endl; // print time taken

    // write the data to the output file
    if (operation == Operation::HEAP_MAXIMUM || operation == Operation::HEAP_EXTRACT_MAX) // if the operation is max functions, then we only need to output the max value
    {
        std::vector<Population> max_vector;
        max_vector.push_back(max);
        if (write_file(output_file_name, max_vector) != 0)
        {
            std::cerr << "Error writing file" << std::endl;
            return 1;
        }
    }
    else if (operation == Operation::DARY_CALCULATE_HEIGHT) // if the operation is height function, then we only need to output the height
    {
        std::vector<Population> height_vector;
        height_vector.push_back(Population{"height is", height});
        if (write_file(output_file_name, height_vector) != 0)
        {
            std::cerr << "Error writing file" << std::endl;
            return 1;
        }
    }
    else // if the operation is not max functions or height function, then we need to output the entire array
    {
        if (write_file(output_file_name, population) != 0)
        {
            std::cerr << "Error writing file" << std::endl;
            return 1;
        }
    }

    return 0;
}
////////////////////////////////////////////////////////// Heap Operations ///////////////////////////////////////////////////////////

void max_heapify(std::vector<Population> &array, const int &i, const int &array_size) // getting array, index of element, and array size
{
    int left = 2 * i + 1;  // left child
    int right = 2 * i + 2; // right child
    int largest;
    if (left < array_size && array[left].population > array[i].population) // checking if left child is larger than parent.
        largest = left;                                                    // if so, largest is left child
    else
        largest = i;                                                               // else, largest is parent
    if (right < array_size && array[right].population > array[largest].population) // checking if right child is larger than largest which will overwrite the largest whether it was parent or left child
        largest = right;                                                           // if so, largest is right child
    if (largest != i)                                                              // if largest is not parent, swap parent with largest
    {
        swap_array_value(array, i, largest);
        max_heapify(array, largest, array_size);
    }
}

void build_max_heap(std::vector<Population> &array, const int &array_size) // getting array and size of array
{
    for (int i = (array_size / 2) - 1; i >= 0; i--) // starting from the last internal node with array_size/2 - 1, casting to int effectively floors the value. used i >= 0 because array starts from 0 and not 1
        max_heapify(array, i, array_size);          // call max-heapify on all internal nodes
}

void heapsort(std::vector<Population> &array, const int &array_size) // getting array and size of array
{
    build_max_heap(array, array_size);       // build max heap
    for (int i = array_size - 1; i > 0; i--) // starting from the last element, swap it with the first element which is index 0 here and call max-heapify on the first element
    {
        swap_array_value(array, 0, i);
        max_heapify(array, 0, i);
    }
}

//////////////////////////////////////////////////////// Priority Queue Operations ////////////////////////////////////////////////////////

void max_heap_insert(std::vector<Population> &array, const Population &key) // getting array and key to insert
{
    build_max_heap(array, array.size());       // since max_heap_insert requires the array to be a max heap, we call build_max_heap to create a max heap
    array.push_back(Population{key.name, -1}); // add the key to the end of the array with a population of -1 which is represented by -ve infinity in the pseudo code taught in class
    // heap_increase_key(array, array.size() - 1, key.population); // increase the key of the last element
    // usually I would call the function above, but since heap_increase_key should also function seperately it would need to have a build_max_heap inside it which would make the function not work properly
    // so I just copied the code from heap_increase_key here
    int i = array.size() - 1;
    if (key.population < array[i].population) // if key is less than the current key, error
    {
        std::cerr << "new key is smaller than current key" << std::endl;
        return;
    }
    array[i].population = key.population;
    while (i > 0 && array[(i - 1) / 2].population < array[i].population) // while i is not the root and the parent is less than the child, swap the parent with the child
    {
        swap_array_value(array, i, (i - 1) / 2); // swap the parent with the child
        i = (i - 1) / 2;                         // set i to the parent
    }
}

Population heap_extract_max(std::vector<Population> &array) // getting array
{
    if (array.size() < 1)
    {
        std::cerr << "heap underflow" << std::endl; // if array size is less than 1, heap underflow
        return Population{"", -1};
    }
    build_max_heap(array, array.size());     // since heap_extract_max requires the array to be a max heap, we call build_max_heap to create a max heap
    Population max = array[0];               // max is the first element at the root
    array[0] = array[array.size() - 1];      // swap the first element with the last element
    array.pop_back();                        // remove the last element
    max_heapify(array, 0, array.size() - 1); // call max-heapify on the first element
    return max;                              // return the max
}

void heap_increase_key(std::vector<Population> &array, int i, const int &key) // getting array, index of element, and key
{
    build_max_heap(array, array.size());
    if (key < array[i].population) // if key is less than the current key, error
    {
        std::cerr << "new key is smaller than current key" << std::endl;
        return;
    }
    array[i].population = key;                                           // since heap_extract_max requires the array to be a max heap, we call build_max_heap to create a max heap
    while (i > 0 && array[(i - 1) / 2].population < array[i].population) // while i is not the root and the parent is less than the child, swap the parent with the child
    {
        swap_array_value(array, i, (i - 1) / 2); // swap the parent with the child
        i = (i - 1) / 2;                         // set i to the parent
    }
}

Population heap_maximum(std::vector<Population> &array) // getting array
{
    if (array.size() < 1)
    {
        std::cout << "heap underflow" << std::endl; // if array size is less than 1, heap underflow
        return Population{"", -1};
    }
    build_max_heap(array, array.size()); // since heap_extract_max requires the array to be a max heap, we call build_max_heap to create a max heap
    Population max = array[0];           // max is the first element at the root
    return max;                          // return the max
}

//////////////////////////////////////////////////////// d-ary Heap Operations //////////////////////////////////////////////////////

void dary_max_heapify(std::vector<Population> &array, const int &i, const int &array_size, const int &d) // getting array, index of element, array size, and d which is the number of children
{
    int largest = i;             // largest is the parent initially
    for (int j = 1; j <= d; j++) // loop through all children
    {
        int child = d * i + j; // loop through all children by index = d * parent + j. In normal binary heap, j would be 1 and 2 but here it is 1 to d
        if (child < array_size && array[child].population > array[largest].population)
            largest = child; // if child is less than array size and child is larger than parent, largest is child
    }
    if (largest != i) // if largest is not parent, swap parent with largest
    {
        swap_array_value(array, i, largest);
        dary_max_heapify(array, largest, array_size, d);
    }
}

void dary_build_max_heap(std::vector<Population> &array, const int &array_size, const int &d) // getting array and size of array
{
    for (int i = (array_size / d) - 1; i >= 0; i--) // starting from the last internal node with array_size/d - 1, casting to int effectively floors the value. used i >= 0 because array starts from 0 and not 1
        dary_max_heapify(array, i, array_size, d);  // call dary_max-heapify on all internal nodes
}

// height of d-ary heap
int dary_calculate_height(const int &array_size, const int &d) // getting array size and d
{
    // int height = 0;
    // int temp = array_size; // temp is array size and having it as int makes it effectively floor the value

    // while (temp > 0) // acts as log base d of array_size but since using external libraries is not allowed, I used this method
    // {
    //     temp = (temp) / d;
    //     height++;
    // }

    // return height;

    return std::ceil(std::log(array_size) / std::log(d)); // log base d of array_size
}

// extract max from d-ary heap
Population dary_extract_max(std::vector<Population> &array, const int &d) // getting array and d
{
    if (array.size() < 1)
    {
        std::cerr << "heap underflow" << std::endl; // if array size is less than 1, heap underflow
        return Population{"", -1};
    }
    dary_build_max_heap(array, array.size(), d);     // since dary_extract_max requires the array to be a max heap, we call dary_build_max_heap to create a dary_max heap
    Population max = array[0];                       // max is the first element at the root
    array[0] = array[array.size() - 1];              // swap the first element with the last element
    array.pop_back();                                // remove the last element
    dary_max_heapify(array, 0, array.size() - 1, d); // call dary-max-heapify on the first element
    return max;                                      // return the max
}

// insert into d-ary heap
void dary_insert_element(std::vector<Population> &array, const Population &key, const int &d) // getting array, key, and d
{
    dary_build_max_heap(array, array.size(), d); // since dary_insert_element requires the array to be a max heap, we call dary_build_max_heap to create a max heap
    array.push_back(Population{key.name, -1});   // add the key to the end of the array with a population of -1 which is represented by -ve infinity in the pseudo code taught in class
    // dary_increase_key(array, array.size() - 1, key.population, d); // increase the key of the last element
    // usually I would call the function above, but since dary_increase_key should also function seperately it would need to have a dary_build_max_heap inside it which would make the function not work properly
    // so I just copied the code from heap_increase_key here
    int i = array.size() - 1;
    if (key.population < array[i].population) // if key is less than the current key, error
    {
        std::cerr << "new key is smaller than current key" << std::endl;
        return;
    }
    array[i].population = key.population;
    while (i > 0 && array[(i - 1) / d].population < array[i].population) // while i is not the root and the parent is less than the child, swap the parent with the child
    {
        swap_array_value(array, i, (i - 1) / d); // swap the parent with the child
        i = (i - 1) / d;                         // set i to the parent
    }
}

// increase key of d-ary heap
void dary_increase_key(std::vector<Population> &array, int i, const int &key, const int &d) // getting array, index of element, key, and d
{
    dary_build_max_heap(array, array.size(), d); // since heap_extract_max requires the array to be a max heap, we call build_max_heap to create a max heap
    if (key < array[i].population)               // if key is less than the current key, error
    {
        std::cerr << "new key is smaller than current key" << std::endl;
        return;
    }
    array[i].population = key;
    while (i > 0 && array[(i - 1) / d].population < array[i].population) // while i is not the root and the parent is less than the child, swap the parent with the child
    {
        swap_array_value(array, i, (i - 1) / d); // swap the parent with the child
        i = (i - 1) / d;                         // set i to the parent
    }
}

// d-ary heapsort
void dary_heapsort(std::vector<Population> &array, const int &array_size, const int &d) // getting array and size of array and d
{
    dary_build_max_heap(array, array_size, d); // build max heap
    for (int i = array_size - 1; i > 0; i--)   // starting from the last element, swap it with the first element which is index 0 here and call max-heapify on the first element
    {
        swap_array_value(array, 0, i);
        dary_max_heapify(array, 0, i, d);
    }
}

//////////////////////////////////////////////////////// Helper functions ////////////////////////////////////////////////////////

// function to process optional arguments
int processOptionalArguments(const int &argc, char **argv, int &numChildren, int &index, int &key_population, std::string &key_name)
{
    for (int i = 4; i < argc; ++i) // loop through the optional arguments to see if they exist and are valid
    {
        const char *arg = argv[i];

        // Check if the argument starts with 'd', 'i', or 'k'
        if (std::strlen(arg) > 1 && (arg[0] == 'd' || arg[0] == 'i')) // if the argument is more than 1 character and the first character is d, i, or k
        {
            // Extract the value after the letter
            const int value = std::atoi(arg + 1);

            // Assign the value to the corresponding variable
            switch (arg[0])
            {
            case 'd':
                numChildren = value;
                break;
            case 'i':
                index = value - 1; // subtract 1 because array starts from 0 and not 1
                break;
            default:
                std::cerr << "Invalid optional argument: " << arg << std::endl;
                return 1;
            }
        }
        else if (std::strlen(arg) > 1 && arg[0] == 'k' && arg[1] == '_')
        {
            const std::string withoutPrefix = arg + 2;         // Discarding "k_"
            const int underscorePos = withoutPrefix.find('_'); // Finding the position of the second underscore

            key_name = withoutPrefix.substr(0, underscorePos);                   // Extracting the population name to key_name
            key_population = std::stoi(withoutPrefix.substr(underscorePos + 1)); // Extract the population number to key_population
        }
        else if (std::strlen(arg) > 1 && arg[0] == 'k' && arg[1] != '_')
        {
            key_population = std::atoi(arg + 1);
        }
        else
        {
            std::cerr << "Invalid optional argument: " << arg << std::endl;
            return 1;
        }
    }
    return 0;
}

// function to read file
int read_file(const std::string &file_name, std::vector<Population> &population)
{
    std::ifstream input_file(file_name);
    if (!input_file.is_open())
        return 1;
    std::string line;
    while (std::getline(input_file, line))
    {
        Population instance;
        std::string number;
        std::istringstream ss(line);
        std::getline(ss, instance.name, ';');
        std::getline(ss, number, ';');
        instance.population = std::stoi(number);
        population.push_back(instance);
    }
    return 0;
}

// function to write file
int write_file(const std::string &output_file_name, const std::vector<Population> &population)
{
    std::ofstream output_file(output_file_name);
    if (!output_file.is_open())
        return 1;

    for (const Population &instance : population)
    {
        std::string line = instance.name + ";" + std::to_string(instance.population);
        output_file << line << '\n';
    }
    return 0;
}

// swap array values
void swap_array_value(std::vector<Population> &array, const int &i, const int &j)
{
    Population temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}

// Function to print the array
void printArray(const std::vector<Population> &arr)
{
    for (const Population &pop : arr)
    {
        std::cout << pop.name << " " << pop.population << std::endl;
    }
    std::cout << std::endl;
}

// Function to convert function name to operation
Operation function_name_to_operation(const std::string &function_name)
{
    if (function_name == "max_heapify")
        return Operation::MAX_HEAPIFY;
    else if (function_name == "build_max_heap")
        return Operation::BUILD_MAX_HEAP;
    else if (function_name == "heapsort")
        return Operation::HEAPSORT;
    else if (function_name == "max_heap_insert")
        return Operation::MAX_HEAP_INSERT;
    else if (function_name == "heap_extract_max")
        return Operation::HEAP_EXTRACT_MAX;
    else if (function_name == "heap_increase_key")
        return Operation::HEAP_INCREASE_KEY;
    else if (function_name == "heap_maximum")
        return Operation::HEAP_MAXIMUM;
    else if (function_name == "dary_calculate_height")
        return Operation::DARY_CALCULATE_HEIGHT;
    else if (function_name == "dary_extract_max")
        return Operation::DARY_EXTRACT_MAX;
    else if (function_name == "dary_insert_element")
        return Operation::DARY_INSERT_ELEMENT;
    else if (function_name == "dary_increase_key")
        return Operation::DARY_INCREASE_KEY;
    else
    {
        std::cerr << "Invalid function name" << std::endl;
        exit(1);
    }
}