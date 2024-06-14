# Code Report

This report provides an overview of the code in `main.c`, `shell.c`, and `shell.h`.

## shell.h

`shell.h` is the header file for `shell.c` which is used in my `main.c` file. It holds the function prototypes, some definitions, and any necessary includes.

### Key Definitions

- `#define BUFFER_SIZE 256`: used to define the maximum length of a command.

- ```c
      typedef enum
    {
        REDIRECT_NONE,
        REDIRECT_INPUT,
        REDIRECT_OUTPUT,
        REDIRECT_APPEND,
        REDIRECT_PIPE,
        REDIRECT_HERE_DOCUMENT
    } RedirectionType;

  ```

  This enum is used to define the different types of redirections that can be used in the shell. Currently, the shell supports only the pipe redirection.

- ```c
  void print_ERROR(char *message);
  ```

  This function is used to print an error message to the console.

- ```c
  char *trim(char *str);
  ```

  This function is used to remove leading and trailing whitespaces from a string. To clean up the command for saving in the history.

- ```c
  void write_to_history(char *command);
  ```

  This function is used to write the command to the history file.

- ```c
  void remove_history_file();
  ```

  This function is used to remove the history file.

- ```c
  void clear_history_file();
  ```

  This function is used to clear the history file.

- ```c
  void execute_command_set(char *command, bool redirect);
  ```

  This function is used to execute a set of commands. It takes the command and a boolean value to check if the command has some redirection of the output/input differently.

- ```c
  RedirectionType get_redirection_type(char *command);
  ```

  This function is used to get the type of redirection used in the command if any.

- ```c
  void execute_commands(char *command, bool redirect);
  ```

  This function is used to execute the commands that are separated by `;` concurrently. It takes the command and a boolean value to check if the command has some redirection of the output/input differently.

- ```c
    void execute(char *command);
  ```
  This function is used to execute the command. It takes the command and executes it.

## main.c

`main.c` is the entry point of our program.

### Explanation of parts of the code that might be confusing

- ```c
  fclose(fopen(".history.txt", "w"));
  ```

  This line is used to clear the history file every time the shell is started. To make sure that each session has a clean history.

- Besides that the code is pretty straightforward and easy to understand with the help of the comments.

## shell.c

`shell.c` has the implementation of the functions declared in `shell.h`.

### Functionality

The implementations of the following functions are straight forward so I will not discuss them or why they are needed.

- `print_ERROR`
- `trim`
- `write_to_history`
- `remove_history_file`
- `clear_history_file`
- `get_redirection_type`

As for the other functions, I will discuss parts in them that might be confusing in the following section:

### Key Functions

- ```c
   void execute_command_set(char *command, bool redirect)
  ```

  I start by trimming the command set, then I handle if its a built in CD command before doing any forks since if I handle it afterwords quitting the shell will not work properly. Then I check if the command has any redirection and handle it accordingly. If the command has a pipe redirection, I parse the command set on the pipe symbol and execute each batch of commands separatly through a recursive call to the execute commands function. Before that, to ensure that data is redirected to the correct streams, I create a pipe and then fork to ensure the child has the same file descriptors, then I do the proper stream handling of the file descriptors and call on the execute commands function.

- ```c
    void execute_commands(char *command, bool redirect)
  ```

  This function is used to execute the commands that are separated by `;` concurrently. It takes the command and a boolean value to check if the command has some redirection of the output/input differently. I start by creating a buffer to store the outputs/inputs of the command(s) if there was any redirection. I used the following code to do so
  `long max_buffer_size = sysconf(_SC_PAGESIZE);` I based this line of my code based on this paper that I found on the internet [here](https://www.idc-online.com/technical_references/pdfs/information_technology/How_Linux_pipes_work_under_the_hood.pdf). Then I used the buffer to store the output of the command(s). I handle the quit built-in command at this stage, write and read from the buffer according to the need by checking the redirect. Then I fork the process to execute the command(s) by calling the execute function for all of them in parallel and wait for all of them in the parent by checking their PIDS.

- ```c
    void execute(char *command)
  ```
  This function is pretty straight forward. I start by tokenizing the command to get the arguments if it has any, then I check if its the history built in command, if it is I read the history file and print it to the console. If it is not I execute the command using the execvp function. If the command is not found I print an error message.

## video Demonstration

### Prompt Mode

<video controls src="prompt_mode.mp4" title="Title"></video>

### Batch Mode

<video controls src="batch_mode.mp4" title="Title"></video>

### CTRL + D

<video controls src="CTRL+D.mp4" title="Title"></video>
