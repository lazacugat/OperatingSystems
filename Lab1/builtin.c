#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "builtin.h"
#include "command.h"
#include "strextra.h"
#include <unistd.h>
#include <libgen.h>
#include "tests/syscall_mock.h"

#define SIZE 1024

const char *internal_commands[] = {"cd", "help", "exit"};
const unsigned int NUM_INTERNAL_COMMANDS = 3;

bool builtin_is_internal(scommand cmd)
{
    assert(cmd != NULL);
    bool is_internal_command = false;
    for(unsigned int i = 0; i < NUM_INTERNAL_COMMANDS; i++){
        if(strcmp(scommand_front(cmd), internal_commands[i]) == 0){
            is_internal_command = true;
        }
    }
    return is_internal_command;
}

bool builtin_alone(pipeline p)
{
    assert(p != NULL);
    return ((pipeline_length(p) == 1) && (builtin_is_internal(pipeline_front(p))));
}

void builtin_run_cd(scommand cmd)
{
    assert(cmd != NULL);
    char *cwd = NULL;
    char *path_dir = NULL;
    cwd = getcwd(cwd, SIZE);

    scommand_pop_front(cmd);
    if (scommand_is_empty(cmd))
    {
        path_dir = getenv("HOME"); /* es lo mismo que "/"*/
    }
    else
    {
        path_dir = scommand_front(cmd);
        if (path_dir[0] != '/')
        {
            path_dir = strmerge("/", path_dir);
            path_dir = strcat(cwd, path_dir);        
        }
    }
    int error = chdir(path_dir);
    if (error != 0 )
    {
        perror("Error al cambiar de directorio");
        return;
    }
}

void builtin_run_help()
{
    printf("Welcome to out Shell");   
    printf("Shell Name: Mybash\n");
    printf("Authors: [Celoria Simon, Cugat Lazaro, Morales Santigo, Lauret Ezequiel, Verzini Maximo]\n\n");
    printf("Internal Commands:\n");
    printf("1. `cd` - Change the current directory.\n");
    printf("   Usage: cd [path]\n\n");
    printf("2. `help` - Show information about available commands.\n");
    printf("   Usage: help\n\n");
    printf("3. `exit` - Exit the shell.\n");
    printf("   Usage: exit\n\n");
}

void builtin_run_exit()
{
    printf("Leaving the terminal.\n");
    printf("It was great having you here! Have a wonderful day.\n");
    exit(0);
}

void builtin_run(scommand cmd)
{
    assert(builtin_is_internal(cmd));
    char *command_name = scommand_front(cmd);
    if (strcmp(command_name, "cd") == 0)
    {
        builtin_run_cd(cmd);
    }
    else if (strcmp(command_name, "exit") == 0)
    {
        builtin_run_exit();
    }
    else
    {
        builtin_run_help();
    }
}