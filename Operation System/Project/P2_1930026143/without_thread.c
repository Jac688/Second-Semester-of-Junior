#include<stdio.h>
#include<pthread.h>
#include<unistd.h>
#include<stdlib.h>
#include<time.h>
#define N 10000


typedef struct { 
    int startIndex; 
    int stopIndex; 
} parameters;

int list[N];

int main() {
    clock_t start, finish; 
    start = clock();
    pthread_t pid1, pid2;
    /* create 10000 random integers (value <10000) saved in a list */
    for(int i = 0; i < N; i++)
        list[i] = rand() % 10000;

    parameters *data1 = (parameters *) malloc(sizeof(parameters));
    data1->startIndex = 0;
    data1->stopIndex = (N/2)-1;
    for (int i = data1->startIndex; i < data1->stopIndex+1; i++) {
        for(int j = data1->startIndex; j < data1->stopIndex; j++) {
            if(list[i] < list[j]){
                int temp = list[i];
                list[i] = list[j];
                list[j] = temp;
            }
        }
    }
    printf("\n\n================ Worker 1 Thread ================\n");
    for (int i = data1->startIndex; i < data1->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data1->stopIndex-10; i < data1->stopIndex; i++) {
        printf("%d ", list[i]);
    }

    parameters *data2 = (parameters *) malloc(sizeof(parameters));
    data2->startIndex = N/2;
    data2->stopIndex = N-1;
    for (int i = data2->startIndex; i < data2->stopIndex+1; i++) {
        for(int j = data2->startIndex; j < data2->stopIndex; j++) {
            if(list[i] < list[j]){
                int temp = list[i];
                list[i] = list[j];
                list[j] = temp;
            }
        }
    }
    printf("\n\n================ Worker 2 Thread ================\n");
    for (int i = data2->startIndex; i < data2->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data2->stopIndex-10; i < data2->stopIndex; i++) {
        printf("%d ", list[i]);
    }


    // merge together
    parameters *data3 = (parameters *) malloc(sizeof(parameters));
    data3->startIndex = 0;
    data3->stopIndex = N-1;

    printf("\n\n================ Merge Thread ================\n");
    for (int i = data3->startIndex; i < data3->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data3->stopIndex-10; i < data3->stopIndex; i++) {
        printf("%d ", list[i]);
    }

    int i, j = 0;
    int temp = 0;
    for(i = 1; i < (data3->stopIndex - data3->startIndex); i++){
        temp = list[i];  // Recond the right(insertion) values
        j = i-1;
        while(j >= 0 && list[j] > temp){
            list[j+1] = list[j];  // If left one is bigger than insertion one 
            j--;  // Move forward
        }
        list[j+1] = temp;  // Insertion values
    }
    printf("\n\n================ Merge Thread ================\n");
    for (int i = data3->startIndex; i < data3->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data3->stopIndex-10; i < data3->stopIndex; i++) {
        printf("%d ", list[i]);
    }

    finish = clock();
    double total_time = (double)(finish-start);
    printf("\n\nTotal time of the two threads: %f seconds.\n", total_time / CLOCKS_PER_SEC);
    return 0; 
}

void* worker1(void* arg) {
    parameters* data = (parameters*)arg;
    // printf("%d %d\n", data->startIndex, data->stopIndex);
    for (int i = data->startIndex; i < data->stopIndex+1; i++) {
        for(int j = data->startIndex; j < data->stopIndex; j++) {
            if(list[i] < list[j]){
                int temp = list[i];
                list[i] = list[j];
                list[j] = temp;
            }
        }
    }
    printf("================ Worker 1 Thread ================\n");
    for (int i = data->startIndex; i < data->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data->stopIndex-10; i < data->stopIndex; i++) {
        printf("%d ", list[i]);
    }
}

void* worker2(void* arg){
    parameters* data = (parameters*)arg;
    // printf("%d %d\n", data->startIndex, data->stopIndex);
    for (int i = data->startIndex; i < data->stopIndex+1; i++) {
        for(int j = data->startIndex; j < data->stopIndex; j++) {
            if(list[i] < list[j]){
                int temp = list[i];
                list[i] = list[j];
                list[j] = temp;
            }
        }
    }
    printf("\n\n================ Worker 2 Thread ================\n");
    for (int i = data->startIndex; i < data->startIndex+10; i++) {
        printf("%d ", list[i]);
    }
    printf("... ");
    for (int i = data->stopIndex-10; i < data->stopIndex; i++) {
        printf("%d ", list[i]);
    }
}
