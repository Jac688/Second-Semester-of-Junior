// #include <stdio.h>
#include<string.h>
#include <unistd.h>
#include <sys/wait.h>

#define SIZE 1024
int main(void) {
    char prompt[] = "Type a command: ";
    char buf[SIZE];
    // Ask the user to type a command:
    write(1, prompt, strlen(prompt));
    // Read from the standard input the command typed by the user (note
    // that fgets also puts into the array buf the ’\n’ character typed
    // by the user when the user presses the Enter key on the keyboard):

    read(0, buf, SIZE);
    // Replace the Enter key typed by the user with ’\0’:
    for(int i = 0; i < SIZE; i++) {
        if(buf[i] == '\n' || buf[i] == '\r') {
            buf[i] = '\0';
            break;
        }
    }

    // Execute the command typed by the user (only prints it for now):
    pid_t pid;  
    pid = fork();
    int status;
    if(pid < 0) { 
        // No child process created.
        write(1, "Fork Failed!\n", strlen("Fork Failed!\n"));
        return 1; 
    }
    else if(pid == 0) {
	write(1, "In the child process!\n", strlen("In the child process\n!"));
        execlp(buf, buf, NULL);
        // Execute the command typed by the user (only prints it for now):
        write(1, buf, strlen(buf));
	write(1, "\n", strlen("\n"));
    } else {
        // Code only executed by the parent process.
        wait(&status);
        return 0;
    }
    return 0;
}
