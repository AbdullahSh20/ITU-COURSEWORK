# ShamoutShell - A Simple Unix Shell - OS Project 1

**Author:** Abdullah Shamout  
**Student ID:** 150200919

ShamoutShell is a simple Unix shell implementation written in C. It provides basic shell functionalities such as executing commands, handling redirection for pipes only currently, and managing history.

## Features

- **Interactive Mode:** Accepts commands from the user interactively via the command line.
- **Batch Mode:** Reads commands from a file specified as a command-line argument.
- **Command Execution:** Executes user-entered commands or commands read from a file.
- **Redirection:** Supports input/output redirection (<, >, >>).
- **Parallel commands execution:** Supports parallel commands using ;.
- **Piping:** Allows for command piping using the | symbol.
- **History:** Maintains a history of executed commands.

## Prerequisites

- GCC Compiler
- Unix-like operating system (Linux, macOS)

## Usage

To compile the shell, run the following command:

```bash
gcc -o shamoutshell main.c shell.c -Wall -Werror
```

### Interactive Mode

To run ShamoutShell in interactive mode, simply execute the compiled binary:

```bash
./shamoutshell
```

### Batch Mode

To run ShamoutShell in batch mode and execute commands from a file, specify the filename as a command-line argument:

```bash
./shamoutshell batch_commands.txt
```

Replace batch_commands.txt with the name of your batch file containing commands.

## Supported Commands

ShamoutShell supports the following buit-in commands in addition to the standard Unix commands:

- `cd [directory]`: Change the current working directory.
- `history`: Display the commands executed in the current session.
- `quit`: Exit the shell.

## Limitations

- The shell does not support all redirections, only pipes.

## Detailed Report

For a detailed report on the implementation and design of ShamoutShell, please refer to the [Project Report](REPORT.md)
