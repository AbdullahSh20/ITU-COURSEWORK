// Author: Abdullah Jafar Mansour Shamout
// Student ID: 150200919
// Naive implementation of QuickSort
#include <iostream>

// datatype of the array is int which is sufficient for now, but later I use vectors with a specific datatype
// function declarations to ease user interface readability
void naive_quicksort(int arr[], const int &left, const int &right);
int naive_partition(int arr[], const int &left, const int &right);
void swap(int &a, int &b);

int main()
{
    int arr[] = {3, 4, 10, 5, 1, 2, 9, 8, 7, 6}; // array to be sorted "randomly created"
    naive_quicksort(arr, 0, 9);                  // function call

    for (int i = 0; i < 10; i++) // printing the array with flush to see output during debugging
    {
        std::cout << arr[i] << " ";
        std::flush(std::cout);
    }

    return 0;
}

void naive_quicksort(int arr[], const int &left, const int &right)
{
    if (left < right)
    {
        const int pivotIndex = naive_partition(arr, left, right);
        naive_quicksort(arr, left, pivotIndex - 1);
        naive_quicksort(arr, pivotIndex + 1, right);
    }
}

int naive_partition(int arr[], const int &left, const int &right)
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

void swap(int &a, int &b)
{
    const int temp = a;
    a = b;
    b = temp;
}