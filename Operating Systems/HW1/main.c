#include "shell.h"
/*
Author: Abdullah Shamout
Student Number: 150200919
*/

int main(int argc, char *argv[])
{
    FILE *file = NULL;  // file pointer to read the commands from the file/stdin
    char *input = NULL; // input buffer to store the commands
    size_t len = 0;     // length of the input buffer
    int read = 0;       // number of characters read
    void clear_history_file();
    int mode = -1; // 1: BATCH mode, 0: PROMPT mode

    if (argc == 1) // if there is no command line argument then it is in PROMPT mode
    {
        mode = PROMPT_MODE;
        file = stdin; // set the file to stdin
    }
    else if (argc == 2) // if there is a command line argument then it is in BATCH mode; it should be a file name
    {
        mode = BATCH_MODE;

        file = fopen(argv[1], "r"); // open the file and read the commands
        if (file == NULL)
        {
            print_ERROR("Error: File not found\n");
            return 1;
        }
    }
    else
    {
        print_ERROR("Invalid command line arguments\n");
        return 1; // might need to change this to EXIT_FAILURE since returning might cause problems with processes
    }
    while (1)
    {
        if (mode == PROMPT_MODE)
        {
            printf("%s", PROMPT); // printing my custom prompt variable
        }

        read = getline(&input, &len, file);
        if (read == 1 && input[0] == '\n') // if the input is empty
        {
            continue;
        }
        else if (read > 0) // if the input is not empty, execute the commands
        {
            if (input[read - 1] == '\n')
            {
                input[read - 1] = '\0'; // remove the newline character and replace it with the null character to terminate the string
            }
            else
            {
                input = realloc(input, read + 1); // if the input is not empty, reallocate the memory to the correct size
                input[read] = '\0';               // terminate the string
            }
            if (mode == BATCH_MODE) // if the program is in BATCH mode, print the line being executed per requested by the assignment
            {
                printf("Executing command(s): %s\n", input);
            }
            write_to_history(input);           // write the command to the history file
            execute_command_set(input, false); // execute the command without redirection (for now)
        }
        else if (feof(file) != 0) // if I am at the end of the file
        {
            free(input);  // free the memory allocated for the input
            fclose(file); // close the file
            remove_history_file();
            return 0; // exit the program
        }
        else // if there is an error
        {
            print_ERROR("Error: Could not read the input\n");
            free(input);  // free the memory allocated for the input
            fclose(file); // close the file
            remove_history_file();
            return 1; // exit the program with an error
        }
    }
    free(input);
    fclose(file);
    remove_history_file();
    return 0;
}