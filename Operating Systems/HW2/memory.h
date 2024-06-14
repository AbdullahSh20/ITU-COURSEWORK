/*
Author: Abdullah Shamout
Student ID: 150200919
*/
#ifndef MYMEM_H
#define MYMEM_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <sys/wait.h>

struct HeadBlock // Structure to represent the block header
{
    size_t size;
    struct HeadBlock *next;
    bool empty;
};

struct HeadBlock *list;            // Pointer to the first block in the free list
void *Head;                        // Pointer to the start of the heap
size_t heap_size;                  // Size of the heap
struct HeadBlock *Continue = NULL; // Pointer to the last block in the free list

int InitMyMalloc(int HeapSize);
void *MyMalloc(int size, int strategy);
int MyFree(void *ptr);
void DumpFreeList();
void PrintError(char *msg);

#endif
