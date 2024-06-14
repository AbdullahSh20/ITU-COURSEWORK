/*
Author: Abdullah Shamout
Student ID: 150200919
*/
#include "memory.c"

int main()
{
    /*Requesting the size of the heap from the user*/
    int HeapSize;
    printf("Please enter the size of the heap:");
    scanf("%d", &HeapSize);

    /*Doing the 4 processes per requested in the assignment*/
    for (int i = 0; i < 4; i++)
    {
        pid_t pid = fork(); // Creating a child process
        if (pid == 0)
        {
            printf("\n#############################################\n");
            printf("Child Process %d, PID: %d\n", i + 1, getpid()); // Printing the child process number and its PID

            if (InitMyMalloc(HeapSize) == -1)
            {
                PrintError("Memory allocation failed!"); // Printing an error message if the memory allocation failed
                exit(1);
            }
            printf("The free list before any allocations are done:\n"); // Printing the free list before allocation
            DumpFreeList();

            void *ptr1 = MyMalloc(512, i);
            void *ptr2 = MyMalloc(2048, i);

            if (ptr1 == NULL || ptr2 == NULL)
            {
                printf("Memory allocation failed!\n");
                return 1;
            }
            printf("ptr1: %p, size: %lu\n", ptr1, ((struct HeadBlock *)((char *)ptr1 - sizeof(struct HeadBlock)))->size);
            printf("ptr2: %p, size: %lu\n", ptr2, ((struct HeadBlock *)((char *)ptr2 - sizeof(struct HeadBlock)))->size);
            DumpFreeList();
            printf("removing the memory reserved for ptr1\n");
            MyFree(ptr1);
            DumpFreeList();
            void *ptr3 = MyMalloc(256, i);
            printf("ptr3: %p, size: %lu\n", ptr3, ((struct HeadBlock *)((char *)ptr3 - sizeof(struct HeadBlock)))->size);
            DumpFreeList();
            printf("removing the memory reserved for ptr2\n");
            MyFree(ptr2);
            DumpFreeList();
            printf("removing the memory reserved for ptr3\n");
            MyFree(ptr3);
            DumpFreeList();
            if (munmap(Head, heap_size) == -1)
            {
                printf("Memory deallocation failed!\n");
                return 1;
            }
            return 0;
        }
        else if (pid > 0)
        {
            wait(NULL);
        }
        else
        {
            printf("Fork failed!\n");
            return 1;
        }
    }

    return 0;
}
