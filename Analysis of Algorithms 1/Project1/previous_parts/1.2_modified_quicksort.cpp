// Author: Abdullah Jafar Mansour Shamout
// Student ID: 150200919
// Implementation of QuickSort using varying pivoting strategies
#include <iostream>
#include <cstdlib> // for rand() and srand()
#include <ctime>   // for time()

// datatype of the array is int which is sufficient for now, but later I use vectors with a specific datatype
// function declarations to ease user interface readability
void last_element_quicksort(int arr[], const int &left, const int &right);
int last_element_partition(int arr[], const int &left, const int &right);

void randomized_quicksort(int arr[], const int &left, const int &right);
int randomized_partition(int arr[], const int &left, const int &right);

void median_3_quicksort(int arr[], const int &left, const int &right);
int median_3_partition(int arr[], const int &left, const int &right);

void swap(int &a, int &b);

int main()
{
    int arr1[] = {3, 4, 10, 5, 1, 2, 9, 8, 7, 6}; // random arrays for testing
    int arr2[] = {3, 4, 10, 5, 1, 2, 9, 8, 7, 6};
    int arr3[] = {3, 4, 10, 5, 1, 2, 9, 8, 7, 6};
    last_element_quicksort(arr1, 0, 9); // function calls for each of the three quicksorts for testing
    randomized_quicksort(arr2, 0, 9);
    median_3_quicksort(arr3, 0, 9);

    std::cout << "arr1 from last_element_quicksort: "; // printing the arrays to see the output
    for (int i = 0; i < 10; i++)
    {
        std::cout << arr1[i] << " ";
        std::flush(std::cout);
    }
    std::cout << std::endl;

    std::cout << "arr2 from randomized_quicksort: ";
    for (int i = 0; i < 10; i++)
    {
        std::cout << arr2[i] << " ";
        std::flush(std::cout);
    }
    std::cout << std::endl;

    std::cout << "arr3 from median_3_quicksort: ";
    for (int i = 0; i < 10; i++)
    {
        std::cout << arr3[i] << " ";
        std::flush(std::cout);
    }
    std::cout << std::endl;

    return 0;
}

void last_element_quicksort(int arr[], const int &left, const int &right)
{
    if (left < right)
    {
        const int pivotIndex = last_element_partition(arr, left, right);
        last_element_quicksort(arr, left, pivotIndex - 1);
        last_element_quicksort(arr, pivotIndex + 1, right);
    }
}
void randomized_quicksort(int arr[], const int &left, const int &right)
{
    if (left < right)
    {
        const int pivotIndex = randomized_partition(arr, left, right);
        last_element_quicksort(arr, left, pivotIndex - 1);
        last_element_quicksort(arr, pivotIndex + 1, right);
    }
}
void median_3_quicksort(int arr[], const int &left, const int &right)
{
    if (left < right)
    {
        const int pivotIndex = median_3_partition(arr, left, right);
        last_element_quicksort(arr, left, pivotIndex - 1);
        last_element_quicksort(arr, pivotIndex + 1, right);
    }
}

int last_element_partition(int arr[], const int &left, const int &right)
{
    const int pivot = arr[right];
    int i = left - 1;

    for (int j = left; j <= right - 1; j++)
    {
        if (arr[j] <= pivot)
        {
            i++;
            swap(arr[i], arr[j]);
        }
    }

    swap(arr[i + 1], arr[right]);
    return i + 1;
}

int randomized_partition(int arr[], const int &left, const int &right)
{
    srand(time(NULL));
    const int pivotIndex = left + rand() % (right - left + 1);
    swap(arr[pivotIndex], arr[right]);

    return last_element_partition(arr, left, right);
}

int median_3_partition(int arr[], const int &left, const int &right)
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
            if (arr[pivotIndices[j]] > arr[pivotIndices[j + 1]])
            {
                swap(pivotIndices[j], pivotIndices[j + 1]);
            }
        }
    }
    const int pivotIndex = pivotIndices[1]; // Median of the three elements

    swap(arr[pivotIndex], arr[right]);

    return last_element_partition(arr, left, right);
}

void swap(int &a, int &b)
{
    const int temp = a;
    a = b;
    b = temp;
}