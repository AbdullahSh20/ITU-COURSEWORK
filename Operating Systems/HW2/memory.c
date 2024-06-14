/*
Author: Abdullah Shamout
Student ID: 150200919
*/
#include "memory.h"

void PrintError(char *msg)
{
    perror(msg);
    exit(1);
}

int roundUpToPageSize(int size)
{
    long page_size = sysconf(_SC_PAGESIZE);           // Get the page size
    return (size + page_size - 1) & ~(page_size - 1); // Round up to the nearest page size
}

int InitMyMalloc(int HeapSize) // Function to initialize the heap
{
    if (Head != NULL || HeapSize <= 0) // Check if the heap is already initialized or the size is invalid
    {
        return -1;
    }

    heap_size = roundUpToPageSize(HeapSize + sizeof(struct HeadBlock)); // Round up to the nearest page size

    printf("Heap size: %lu\n", heap_size);
#ifdef MAP_ANONYMOUS                                                                         // Check if the system supports MAP_ANONYMOUS, I have a dual boot system and the other OS does not support it so when coding when I realized this I added it here
    Head = mmap(NULL, heap_size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0); // Allocate memory
#else
#define MAP_ANONYMOUS 0x1000
    Head = mmap(NULL, heap_size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0); // Allocate memory
#endif
    if (Head == MAP_FAILED) // Check if memory allocation failed
    {
        return -1;
    }

    // Initialize the free list
    list = (struct HeadBlock *)Head;
    list->empty = true;
    list->next = NULL;
    list->size = heap_size - sizeof(struct HeadBlock);

    return 0;
}

void *MyMalloc(int size, int strategy)
{
    if (Head == NULL || size <= 0) // Check if the heap is not initialized or the size is invalid
    {
        return NULL;
    }

    struct HeadBlock *CurrentBlock = list;
    struct HeadBlock *BestFit = NULL;
    struct HeadBlock *PreviousBlock = NULL;

    if (strategy == 3 && Continue != NULL && Continue->next != NULL)
    {
        CurrentBlock = Continue->next;
    }
    bool lap = false;

    while (CurrentBlock != NULL)
    {
        if (CurrentBlock->empty && CurrentBlock->size >= size) // Check if the block is free and has enough space
        {
            if (strategy == 0) // Best Fit
            {
                if (BestFit == NULL || CurrentBlock->size < BestFit->size)
                {
                    BestFit = CurrentBlock;
                }
            }
            else if (strategy == 1) // worst Fit
            {
                if (BestFit == NULL || CurrentBlock->size > BestFit->size)
                {
                    BestFit = CurrentBlock;
                }
            }
            else if (strategy == 2 || strategy == 3) // First Fit or Next Fit
            {
                BestFit = CurrentBlock;
                break;
            }
            else
            {
                return NULL;
            }
        }
        PreviousBlock = CurrentBlock;
        CurrentBlock = CurrentBlock->next;
    }

    if (strategy == 3 && CurrentBlock == NULL && !lap)
    {
        CurrentBlock = list;
        lap = true;
    }

    if (BestFit->size > size) // Split the block if it has more space than needed
    {
        struct HeadBlock *new_block = (struct HeadBlock *)((char *)BestFit + sizeof(struct HeadBlock) + size);
        new_block->next = BestFit->next;
        new_block->empty = true;
        new_block->size = BestFit->size - size - sizeof(struct HeadBlock);
        Continue = new_block;
        BestFit->next = new_block;
        BestFit->empty = false;
        BestFit->size = size;
    }

    return (void *)((char *)BestFit + sizeof(struct HeadBlock)); // Return the pointer to the allocated block
}

int MyFree(void *ptr) // Function to free a block
{
    if (ptr == NULL || Head == NULL) // Check if the pointer is NULL or the heap is not initialized
    {
        return -1;
    }

    struct HeadBlock *FreePtr = (struct HeadBlock *)((char *)ptr - sizeof(struct HeadBlock)); // Get the block header

    FreePtr->empty = true;

    struct HeadBlock *CurrentBlock = list; // Merge the free blocks
    while (CurrentBlock != NULL)           // Traverse the free list
    {

        if ((CurrentBlock->empty && CurrentBlock->next != NULL && CurrentBlock->next->empty) && (char *)CurrentBlock + CurrentBlock->size + sizeof(struct HeadBlock) == (char *)CurrentBlock->next)
        {
            CurrentBlock->size += CurrentBlock->next->size + sizeof(struct HeadBlock);
            if (Continue == CurrentBlock->next)
            {
                Continue = CurrentBlock;
            }
            CurrentBlock->next = CurrentBlock->next->next;
        }
        else
        {
            CurrentBlock = CurrentBlock->next;
        }
    }

    return 0;
}

void DumpFreeList()
{
    struct HeadBlock *CurrentBlock = list;
    printf("Addr\tSize\tStatus\n");
    while (CurrentBlock != NULL)
    {
        if (CurrentBlock->empty)
        {
            printf("%p\t%lu\tFree\n", CurrentBlock, CurrentBlock->size);
        }
        else
        {
            printf("%p\t%lu\tAllocated\n", CurrentBlock, CurrentBlock->size);
        }
        CurrentBlock = CurrentBlock->next;
    }

    printf("\n");
}
