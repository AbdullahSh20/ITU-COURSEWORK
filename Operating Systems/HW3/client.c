/*
Abdullah Jafar Mansour Shamout
150200919
*/
#include "blg312e.h"
#include <unistd.h>

void clientSend(int fd, char *filename)
{
  char buf[MAXLINE];
  char hostname[MAXLINE];

  Gethostname(hostname, MAXLINE);

  /* Form and send the HTTP request */
  sprintf(buf, "GET %s HTTP/1.1\n", filename);
  snprintf(buf + strlen(buf), sizeof(buf) - strlen(buf), "Host: %s\r\n\r\n", hostname); // fixed an error here
  Rio_writen(fd, buf, strlen(buf));
}

void clientPrint(int fd)
{
  rio_t rio;
  char buf[MAXBUF];
  int length = 0;
  int n;

  Rio_readinitb(&rio, fd);

  /* Read and display the HTTP Header */
  n = Rio_readlineb(&rio, buf, MAXBUF);
  while (strcmp(buf, "\r\n") && (n > 0))
  {
    printf("Header: %s", buf);
    n = Rio_readlineb(&rio, buf, MAXBUF);

    /* If you want to look for certain HTTP tags... */
    if (sscanf(buf, "Content-Length: %d ", &length) == 1)
    {
      printf("Length = %d\n", length);
    }
  }

  /* Read and display the HTTP Body */
  n = Rio_readlineb(&rio, buf, MAXBUF);
  while (n > 0)
  {
    printf("%s", buf);
    n = Rio_readlineb(&rio, buf, MAXBUF);
  }
}

void *request(void **args) // the request function that will be called by the threads to send the request to the server
{
  char *host = (char *)args[0];     // host name
  int port = atoi((char *)args[1]); // port number
  char *filename = (char *)args[2]; // requested file name
  int clientfd;                     // client file descriptor

  clientfd = Open_clientfd(host, port); // open the client file descriptor
  clientSend(clientfd, filename);       // send the request to the server
  clientPrint(clientfd);                // print the response from the server
  Close(clientfd);                      // close the client file descriptor

  return NULL;
}

int main(int argc, char *argv[])
{
  char *host, *filename, *port; // host name, file name, port number

  if (argc != 4) // if the number of arguments is not 4
  {
    fprintf(stderr, "Usage: %s <host> <port> <filename>\n", argv[0]);
    exit(1);
  }

  host = argv[1];     // get the host name from the command line arguments
  port = argv[2];     // get the port number from the command line arguments
  filename = argv[3]; // get the file name from the command line arguments

  int no_threads = sysconf(_SC_NPROCESSORS_ONLN); // get the number of processors online to determine the number of threads to be created
  if (no_threads < 1)                             // if the number of processors is less than 1
  {
    no_threads = 1;
    printf("Number of threads is set to 1 due to sysconf error\n"); // print an error message
  }

  pthread_t threads[no_threads]; // create an array of threads with the size of the number of threads
  char *args[3] = {host, port, filename};
  for (int i = 0; i < no_threads; ++i)
  {
    printf("Creating thread %d\n", i);                                // print a message
    pthread_create(&threads[i], NULL, (void *)request, (void *)args); // create a thread with the request function and the arguments
  }

  for (int i = 0; i < no_threads; ++i) // for each thread
  {
    printf("Joining thread %d\n", i); // print a message
    pthread_join(threads[i], NULL);   // join the thread
  }

  exit(0);
}
