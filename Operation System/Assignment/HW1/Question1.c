// #include <stdio.h>
#include<string.h>
#define SIZE 1024
int main(void) {
    char prompt[] = "Type a command: ";
    char buf[SIZE];
    // Ask the user to type a command:
    write(1, prompt, strlen(prompt));
    // Read from the standard input the command typed by the user (note
    // that fgets also puts into the array buf the ’\n’ character typed
    // by the user when the user presses the Enter key on the keyboard):

    // fgets(buf, SIZE, stdin);
    read(0, buf, SIZE);
    // Replace the Enter key typed by the user with ’\0’:
    for(int i = 0; i < SIZE; i++) {
        if(buf[i] == '\n' || buf[i] == '\r') {
            buf[i] = '\0';
            break;
        }
    }
    write(1, "Executing command: ", strlen("Executing command: "));
    // Execute the command typed by the user (only prints it for now):
    write(1, buf, SIZE);
    write(1, "\n", strlen("\n"));
    return 0;
}
