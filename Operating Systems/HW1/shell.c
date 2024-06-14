#include "shell.h"
/*
Author: Abdullah Shamout
Student Number: 150200919
*/

void print_ERROR(char *message)
{
    fprintf(stderr, "%s", message);
    return;
}

char *trim(char *str)
{
    // Trim leading spaces and tabs
    while (isspace((unsigned char)*str))
        str++;

    if (*str == 0) // All spaces?
        return str;

    // Trim trailing spaces and tabs
    char *end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char)*end))
        end--;

    // Write new null terminator
    *(end + 1) = '\0';

    return str;
}

void write_to_history(char *command)
{
    char history_path[BUFFER_SIZE];
    const char *history_file = ".history.txt";
    const char *home_dir = getenv("HOME");

    if (home_dir == NULL)
    {
        print_ERROR("Error: HOME environment variable not set\n");
        return;
    }

    snprintf(history_path, BUFFER_SIZE, "%s/%s", home_dir, history_file);

    FILE *file = fopen(history_path, "a");
    if (file == NULL)
    {
        print_ERROR("Error: Could not open history file\n");
        return;
    }

    command = trim(command);
    fprintf(file, "%s\n", command);
    fclose(file);
}

RedirectionType get_redirection_type(char *command)
{
    size_t length = strlen(command);
    for (size_t i = 0; i < length; i++)
    {
        switch (command[i])
        {
        case '>':
            if (i < length - 1 && command[i + 1] == '>')
            {
                return REDIRECT_APPEND;
            }
            return REDIRECT_OUTPUT;
        case '<':
            return REDIRECT_INPUT;
        case '|':
            return REDIRECT_PIPE;
        case '&':
            if (i < length - 1 && command[i + 1] == '>')
            {
                return REDIRECT_OUTPUT;
            }
            break;
        default:
            continue;
        }
    }
    return REDIRECT_NONE;
}

void execute_command_set(char *command, bool redirect)
{
    command = trim(command);
    if (strncmp(command, "cd", 2) == 0)
    {
        char *arg = command + 3; // Skip "cd "
        if (*arg == '\0')
        {
            printf("Usage: cd <directory>\n");
        }
        else
        {
            if (chdir(arg) != 0)
            {
                perror("chdir");
            }
        }
    }
    else
    {
        RedirectionType type = get_redirection_type(command);
        if (type == REDIRECT_NONE)
        {
            execute_commands(command, redirect);
        }
        else if (type == REDIRECT_PIPE)
        {
            char *pipe_pos = strchr(command, '|');
            char *start = command;
            char *end = pipe_pos + 1;

            int pipefd[2];
            if (pipe(pipefd) == -1)
            {
                print_ERROR("Error: Pipe failed\n");
                perror("failed to create a pipe");
                exit(EXIT_FAILURE);
            }
            pid_t pid = fork();
            if (pid == -1)
            {
                print_ERROR("Error: Fork failed\n");
                perror("failed to fork");
                exit(EXIT_FAILURE);
            }
            else if (pid == 0)
            {
                close(pipefd[0]);
                dup2(pipefd[1], STDOUT_FILENO);
                close(pipefd[1]);
                char *temp = malloc(pipe_pos - start + 1);
                strncpy(temp, start, pipe_pos - start);
                temp[pipe_pos - start] = '\0';
                execute_commands(temp, redirect);
                exit(EXIT_SUCCESS);
            }
            else
            {
                wait(NULL);
            }

            pid = fork();
            if (pid == 0)
            {
                dup2(pipefd[0], STDIN_FILENO);
                close(pipefd[0]);

                execute_commands(end, 1); // execute the next command set with redirection
                exit(EXIT_SUCCESS);
            }
            else
            {
                wait(NULL);
            }
        }
        else
        {
            print_ERROR("Error: Unsupported redirection type for now since it was not required in the assignment\n");
        }
    }
}

void execute_commands(char *command, bool redirect)
{
    char *commands[BUFFER_SIZE];
    char *semicolon = strtok(command, ";");
    int i = 0;
    int length = -1;

    long max_buffer_size = sysconf(_SC_PAGESIZE); // Get the maximum buffer size for IPC since the buffer size is not specified in the assignment
    char BUFFER[max_buffer_size];                 // Buffer for Inter-Process Communication
    bool should_quit = false;                     // Termination flag
    if (redirect)
    {
        length = read(STDIN_FILENO, BUFFER, sizeof(BUFFER));
        if (length == -1)
        {
            perror("failed to read from STDIN to the BUFFER");
            exit(EXIT_FAILURE);
        }
    }

    while (semicolon != NULL)
    {
        commands[i] = semicolon;
        i++;
        semicolon = strtok(NULL, ";");
    }
    commands[i] = NULL;

    pid_t pids[i];
    for (int j = 0; j < i; j++)
    {
        if (strcmp(trim(commands[j]), "quit") == 0)
        {
            should_quit = true;
            continue;
        }
        pid_t pid = fork();
        if (pid == -1)
        {
            print_ERROR("Error: Fork failed\n");
            perror("failed to fork");
            exit(EXIT_FAILURE);
        }
        else if (pid == 0)
        {
            if (redirect)
            {
                int fd[2];
                if (pipe(fd) == -1)
                {
                    print_ERROR("Error: Pipe failed\n");
                    perror("Pipe failed");
                    exit(EXIT_FAILURE);
                }

                write(fd[1], BUFFER, length);
                close(fd[1]);

                dup2(fd[0], STDIN_FILENO);
                close(fd[0]);
            }
            execute(commands[j]);
        }
        else
        {
            pids[j] = pid;
        }
    }

    for (int j = 0; j < i; j++)
    {
        waitpid(pids[j], NULL, 0);
    }

    if (should_quit)
    {
        remove_history_file();
        exit(EXIT_SUCCESS);
    }
}

void execute(char *commands)
{
    char *args[BUFFER_SIZE];
    char *token = strtok(commands, " ");
    int i = 0;
    while (token != NULL)
    {
        args[i] = token;
        i++;
        token = strtok(NULL, " ");
    }
    args[i] = NULL;

    if (strcmp(trim(args[0]), "history") == 0)
    {
        const char *history_file = ".history.txt";
        const char *home_dir = getenv("HOME");

        if (home_dir == NULL)
        {
            print_ERROR("Error: HOME environment variable not set\n");
            return;
        }

        // Concatenate home directory path and history file name
        char history_path[strlen(home_dir) + strlen(history_file) + 2]; // +2 for '/' and '\0'
        snprintf(history_path, sizeof(history_path), "%s/%s", home_dir, history_file);

        FILE *file = fopen(history_path, "r");
        if (file == NULL)
        {
            print_ERROR("Error: Could not open history file\n");
            return;
        }

        char line[BUFFER_SIZE];
        while (fgets(line, BUFFER_SIZE, file) != NULL)
        {
            printf("%s", line);
        }

        fclose(file);
        exit(EXIT_SUCCESS);
        return;
    }
    else if (execvp(args[0], args) == -1)
    {
        print_ERROR("Error: Command not found\n");
        perror("failed to execute command");
        exit(EXIT_FAILURE);
    }
    return;
}

void remove_history_file()
{
    const char *history_file = ".history.txt";
    const char *home_dir = getenv("HOME");

    if (home_dir == NULL)
    {
        print_ERROR("Error: HOME environment variable not set\n");
        return;
    }

    // Concatenate home directory path and history file name
    char history_path[strlen(home_dir) + strlen(history_file) + 2]; // +2 for '/' and '\0'
    snprintf(history_path, sizeof(history_path), "%s/%s", home_dir, history_file);

    if (remove(history_path) != 0)
    {
        print_ERROR("Error: Could not remove history file\n");
        return;
    }
}
void clear_history_file()
{
    const char *history_file = ".history.txt";
    const char *home_dir = getenv("HOME");

    if (home_dir == NULL)
    {
        print_ERROR("Error: HOME environment variable not set\n");
        return;
    }

    // Concatenate home directory path and history file name
    char history_path[strlen(home_dir) + strlen(history_file) + 2]; // +2 for '/' and '\0'
    snprintf(history_path, sizeof(history_path), "%s/%s", home_dir, history_file);

    FILE *file = fopen(history_path, "w");
    if (file == NULL)
    {
        print_ERROR("Error: Could not open history file for writing\n");
        return;
    }

    fclose(file);
}