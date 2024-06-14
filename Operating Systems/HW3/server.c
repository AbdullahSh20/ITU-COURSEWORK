/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "blg312e.h"
#include "request.h"
#include <stdlib.h>

struct THREADS_TYPE // struct to hold the threads and the size of the threads
{
  pthread_t *threads;
  int number_of_threads;
};

struct THREADS_TYPE threads_instance;    // instance of the struct
int *connection_file_descriptors = NULL; // connection file descriptors
sem_t num_of_threads;                    // semaphore to keep track of the number of threads
sem_t connection_top;                    // semaphore to keep track of the top of the connection
sem_t buffer_mutex;                      // semaphore to keep track of the buffer
int buffer_size_G;                       // buffer size

void getargs(int *port, int *threads, int *buffers, char *argv[]) // get the arguments from the command line
{
  *port = atoi(argv[1]);
  *threads = atoi(argv[2]);
  *buffers = atoi(argv[3]);
}

void semaphore_initialize(sem_t *buffer_mutex, sem_t *connection_top, sem_t *num_of_threads, int no_threads) // initialize the semaphores
{
  sem_init(buffer_mutex, 0, 1);            // initialize the buffer mutex
  sem_init(connection_top, 0, 0);          // initialize the connection top
  sem_init(num_of_threads, 0, no_threads); // initialize the number of threads
}

void *worker() // worker function that will be called by the threads
{
  while (1)
  {
    sem_wait(&connection_top);                                       // wait for the connection top
    sem_wait(&buffer_mutex);                                         // wait for the buffer mutex
    int connection_file_descriptor = connection_file_descriptors[0]; // get the connection file descriptor
    int i = 0;
    while (i < buffer_size_G - 1)
    {
      connection_file_descriptors[i] = connection_file_descriptors[i + 1];
      i++;
    }
    buffer_size_G -= 1;
    sem_post(&buffer_mutex);                   // post the buffer mutex
    requestHandle(connection_file_descriptor); // handle the request
    Close(connection_file_descriptor);         // close the connection file descriptor
  }
  return NULL;
}

void thread_check() // thread check function that will be called at the exit of the program to cancel the threads if they are still running
{
  int i = 0;
  while (i < threads_instance.number_of_threads)
  {
    pthread_cancel(threads_instance.threads[i]);
    pthread_join(threads_instance.threads[i], NULL);
    i++;
  }
}

// handle exiting function
void handle_exiting(void (*empty)())
{
  signal(SIGINT, empty);  // to exit the server usually SIGINT is used, and to ensure no memory leaks, the empty function is called
  signal(SIGTERM, empty); // to exit the server if SIGTERM is used, and to ensure no memory leaks, the empty function is called
}

void empty() // empty function that will be called at the exit of the program
{
  thread_check();
  printf("\nshutting down....\n");
  free(threads_instance.threads);
  free(connection_file_descriptors);
  sem_destroy(&num_of_threads);
  sem_destroy(&connection_top);
  sem_destroy(&buffer_mutex);
  exit(EXIT_SUCCESS);
}

void create_threads(int no_threads) // create the threads
{
  int i = 0;
  while (i < no_threads)
  {
    pthread_create(&threads_instance.threads[i], NULL, worker, NULL);
    i++;
  }
}

int main(int argc, char *argv[])
{
  if (argc != 4)
  {
    fprintf(stderr, "Usage: %s <port> <threads> <buffers>\n", argv[0]);
    exit(1);
  }

  int listenfd, connfd, clientlen;
  int port, no_threads, buffers;
  struct sockaddr_in clientaddr;

  getargs(&port, &no_threads, &buffers, argv);                        // get the arguments from the command line
  connection_file_descriptors = (int *)malloc(buffers * sizeof(int)); // allocate memory for the connection file descriptors

  semaphore_initialize(&buffer_mutex, &connection_top, &num_of_threads, no_threads);

  threads_instance.threads = (pthread_t *)malloc(no_threads * sizeof(pthread_t));
  threads_instance.number_of_threads = no_threads;
  buffer_size_G = 0;

  handle_exiting(empty);      // handle the shutting down of the server to ensure no memory leaks
  create_threads(no_threads); // create the threads

  listenfd = Open_listenfd(port);
  while (1)
  {
    clientlen = sizeof(clientaddr);
    connfd = Accept(listenfd, (SA *)&clientaddr, (socklen_t *)&clientlen);

    sem_wait(&buffer_mutex);
    connection_file_descriptors[buffer_size_G] = connfd;
    buffer_size_G++;
    sem_post(&connection_top);
    sem_post(&buffer_mutex);
  }
}
