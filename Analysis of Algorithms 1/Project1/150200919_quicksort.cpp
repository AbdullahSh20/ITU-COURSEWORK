// Author: Abdullah Jafar Mansour Shamout
// Student ID: 150200919
// Implementation of QuickSort.cpp using varying pivoting strategies depending on the input from the command line
#include <iostream>
#include <cstdlib> // for rand() and srand()
#include <ctime>   // for time()
#include <vector>  //used to create vectors for the data given to be sorted
#include <fstream> //used to read and write files
#include <sstream> //used to read and write files
#include <chrono>  // for timing the sorting algorithm

// population struct to hold the data of each population from the input file
struct Population
{
    std::string name = "";
    int population = 0;
};

// function declarations to ease user interface readability

void hybrid_quicksort(std::vector<Population> &population, const int &left, const int &right, const int &K, const char &pivot_strategy, std::vector<std::string> &log, const bool &verbose);
int last_element_partition(std::vector<Population> &population, const int &left, const int &right);
int randomized_partition(std::vector<Population> &population, const int &left, const int &right);
int median_3_partition(std::vector<Population> &population, const int &left, const int &right);

void swap(Population &a, Population &b);
void swap_int(int &a, int &b);
void insertion_sort(std::vector<Population> &population, const int &left, const int &right);
int read_file(const std::string &file_name, std::vector<Population> &population);
int write_file(const std::string &output_file_name, const std::vector<Population> &population);
void log_data(const std::vector<Population> &population, const int &left, const int &right, const int &pivotIndex, std::vector<std::string> &log);

int main(int argc, char *argv[])
{
    if (argc < 5)
    {
        return 1;
    }
    const std::string file_name = argv[1];
    const char pivot_strategy = argv[2][0];
    const int K = std::stoi(argv[3]); // if K is 1 naive sort should be used "which in this case is last_element_partitioned sort", we are also told to assume that K is 1 or greater
    const std::string output_file_name = argv[4];
    std::vector<std::string> log;

    bool verbose = false;
    if (argc >= 6 && std::string(argv[5]) == "v")
        verbose = true;

    std::vector<Population> population;

    // reading data from file
    if (read_file(file_name, population) == 1)
        return 1;

    const auto start{std::chrono::steady_clock::now()};

    hybrid_quicksort(population, 0, population.size() - 1, K, pivot_strategy, log, verbose);

    const auto end{std::chrono::steady_clock::now()};
    const auto time = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);

    std::cout << "Time taken by QuickSort with pivot strategy '" << pivot_strategy << "' and threshhold: " << K << " is: " << time.count() << " ns." << std::endl;

    // write sorted data to output file
    if (write_file(output_file_name, population) == 1)
        return 1;

    if (verbose)
    {
        std::ofstream log_file("log.txt");
        if (!log_file.is_open())
        {
            return 1;
        }
        for (const std::string line : log)
            log_file << line << '\n';
    }

    return 0;
}

void insertion_sort(std::vector<Population> &population, const int &left, const int &right)
{
    for (int i = left + 1; i <= right; i++)
    {
        Population key = population[i];
        int j = i - 1;
        while (j >= left && population[j].population > key.population)
        {
            population[j + 1] = population[j];
            j--;
        }
        population[j + 1] = key;
    }
}

void hybrid_quicksort(std::vector<Population> &population, const int &left, const int &right, const int &K, const char &pivot_strategy, std::vector<std::string> &log, const bool &verbose)
{
    int pivotIndex;
    if (K == 1) // implementing naive sort using last element partitioning, note: since this is the first condition checked, the others wont be entered if this is true
    {
        if (left < right)
        {
            pivotIndex = last_element_partition(population, left, right);
            if (verbose)
            {
                log_data(population, left, right, pivotIndex, log);
            }
            hybrid_quicksort(population, left, pivotIndex - 1, K, pivot_strategy, log, verbose);
            hybrid_quicksort(population, pivotIndex + 1, right, K, pivot_strategy, log, verbose);
        }
        return;
    }
    else if (right - left + 1 <= K) // implementing insertion sort when the size of the array is less than or equal to K if K is greater than 1
    {
        insertion_sort(population, left, right);
    }
    else // implementing quicksort using the chosen pivot strategy if the size of the array is greater than K and K is greater than 1
    {
        switch (pivot_strategy)
        {
        case 'l': // last element pivot
            pivotIndex = last_element_partition(population, left, right);
            if (verbose)
            {
                log_data(population, left, right, pivotIndex, log);
            }
            hybrid_quicksort(population, left, pivotIndex - 1, K, pivot_strategy, log, verbose);
            hybrid_quicksort(population, pivotIndex + 1, right, K, pivot_strategy, log, verbose);
            break;
        case 'r': // randomized
            pivotIndex = randomized_partition(population, left, right);
            if (verbose)
            {
                log_data(population, left, right, pivotIndex, log);
            }
            hybrid_quicksort(population, left, pivotIndex - 1, K, pivot_strategy, log, verbose);
            hybrid_quicksort(population, pivotIndex + 1, right, K, pivot_strategy, log, verbose);
            break;
        case 'm': // median of 3 partition
            pivotIndex = median_3_partition(population, left, right);
            if (verbose)
            {
                log_data(population, left, right, pivotIndex, log);
            }
            hybrid_quicksort(population, left, pivotIndex - 1, K, pivot_strategy, log, verbose);
            hybrid_quicksort(population, pivotIndex + 1, right, K, pivot_strategy, log, verbose);
            break;
        default: // default case is to use last element partitioning whic is the naive approach
            pivotIndex = last_element_partition(population, left, right);
            if (verbose)
            {
                log_data(population, left, right, pivotIndex, log);
            }
            hybrid_quicksort(population, left, pivotIndex - 1, K, pivot_strategy, log, verbose);
            hybrid_quicksort(population, pivotIndex + 1, right, K, pivot_strategy, log, verbose);
            break;
        }
    }
}

int last_element_partition(std::vector<Population> &population, const int &left, const int &right)
{
    const Population pivot = population[right];
    int i = left - 1;

    for (int j = left; j <= right - 1; j++)
    {
        if (population[j].population <= pivot.population)
        {
            i++;
            swap(population[i], population[j]);
        }
    }

    swap(population[i + 1], population[right]);
    return i + 1;
}

int randomized_partition(std::vector<Population> &population, const int &left, const int &right)
{
    srand(time(NULL));
    const int pivotIndex = left + rand() % (right - left + 1);
    swap(population[pivotIndex], population[right]);
    return last_element_partition(population, left, right); // using last element partitioning since the pivot is randomized and the pivot is placed as the last element
}

int median_3_partition(std::vector<Population> &population, const int &left, const int &right)
{
    srand(time(NULL));
    int pivotIndices[3];
    for (int i = 0; i < 3; i++)
    {
        pivotIndices[i] = left + rand() % (right - left + 1);
    }

    // Sorting the pivot indices to find the median using bubble sort, but since its 3 elements, it will be done in O(1) time
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 2 - i; j++)
        {
            if (population[pivotIndices[j]].population > population[pivotIndices[j + 1]].population)
            {
                swap_int(pivotIndices[j], pivotIndices[j + 1]);
            }
        }
    }
    const int pivotIndex = pivotIndices[1]; // Median of the three elements

    swap(population[pivotIndex], population[right]);
    return last_element_partition(population, left, right); // using last element partitioning since the pivot is randomized by getting the median of 3 random values and the pivot is placed as the last element
}

void swap(Population &a, Population &b)
{
    Population temp = a;
    a = b;
    b = temp;
}

void swap_int(int &a, int &b)
{
    int temp = a;
    a = b;
    b = temp;
}

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

void log_data(const std::vector<Population> &population, const int &left, const int &right, const int &pivotIndex, std::vector<std::string> &log)
{
    std::string output_array = "[";
    for (int i = 0; i < population.size() - 1; i++)
        output_array += std::to_string(population[i].population) + ", ";
    output_array += std::to_string(population[population.size() - 1].population) + "]";
    log.push_back("pivot: " + std::to_string(pivotIndex) + " Array: " + output_array + " left index: " + std::to_string(left) + " right index: " + std::to_string(right) + ";");
}