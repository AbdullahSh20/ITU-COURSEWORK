#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <ctype.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
/*
Author: Abdullah Shamout
Student Number: 150200919
*/

#define PROMPT "ShamoutShell> "
#define PROMPT_MODE 0
#define BATCH_MODE 1

#define BUFFER_SIZE 256 // buffer size for the input commands is 256 characters as metioned in the assignment

typedef enum
{
    REDIRECT_NONE,
    REDIRECT_INPUT,
    REDIRECT_OUTPUT,
    REDIRECT_APPEND,
    REDIRECT_PIPE,
    REDIRECT_HERE_DOCUMENT
} RedirectionType;

void print_ERROR(char *message);
char *trim(char *str);
void write_to_history(char *command);
void remove_history_file();
void clear_history_file();
void execute_command_set(char *command, bool redirect);
RedirectionType get_redirection_type(char *command);
void execute_commands(char *command, bool redirect);
void execute(char *command);