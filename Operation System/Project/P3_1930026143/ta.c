#include <stdio.h>
#include <ctype.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>
#include <string.h>
#include <stdbool.h>		
#define chair_number 3
#define student_number 5

int chair_count = 0;
int current_id = 0;

void *ta_action();
void *stu_action(void *threadID);


pthread_t *students;		
pthread_t TA;				
sem_t ta_sem;
sem_t stu_sem;
sem_t chair_sem[chair_number];
pthread_mutex_t chair_available;

int main(int argc, char* argv[])
{	
	int stu_id;
	srand(time(NULL));


	sem_init(&ta_sem, 0, 0);
	sem_init(&stu_sem, 0, 0);
	for(stu_id = 0; stu_id < chair_number; ++stu_id)			
		sem_init(&chair_sem[stu_id], 0, 0);
	pthread_mutex_init(&chair_available, NULL);
		

	students = (pthread_t*) malloc(sizeof(pthread_t)*student_number);

	pthread_create(&TA, NULL, ta_action, NULL);	
	for(stu_id = 0; stu_id < student_number; stu_id++)
		pthread_create(&students[stu_id], NULL, stu_action,(void*) (long)stu_id);

	// wait and join all the students threads together.
	pthread_join(TA, NULL);
		pthread_join(students[stu_id], NULL);

	// free memory
	free(students); 
	return 0;
}

void *ta_action()
{
	while(1)
	{
		sem_wait(&ta_sem);		//TA is currently sleeping.

		while(1)
		{
			// lock the chair_available
			pthread_mutex_lock(&chair_available);
			if(chair_count == 0) 
			{
				pthread_mutex_unlock(&chair_available);
				break;
			}

            
			sem_post(&chair_sem[current_id]);
            printf("TA is serving student\n");
			chair_count--;

            int help_time = rand() % 10 ;
            printf("Helping a student for %d seconds waiting students = %d\n", help_time, chair_count);
			current_id = (current_id + 1) % chair_number;

            
            // unlock the chair_available
			pthread_mutex_unlock(&chair_available);

			sleep(help_time);
			sem_post(&stu_sem);
			usleep(1000);
		}
	}
}

void *stu_action(void *threadID) 
{
	int ProgrammingTime;

	while(1)
	{   
        // let this students hanging out to programming
        ProgrammingTime = rand() % 10 ;
        printf("\tStudent %ld hanging out for programming for %d seconds\n", (long)threadID, ProgrammingTime);

		// Sleep(Programming) for a random time period.
		sleep(ProgrammingTime);		

		
		pthread_mutex_lock(&chair_available);
		int count = chair_count;
		pthread_mutex_unlock(&chair_available);

		if(count < chair_number) {
			if(count == 0){		
				sem_post(&ta_sem);
            }
			else
				printf("\t\tStudent %ld takes a seat  waiting students = %d\n", (long)threadID, count);


			// lock
			pthread_mutex_lock(&chair_available);
			int index = (current_id + chair_count) % chair_number;
			chair_count++;

            // unlock
			pthread_mutex_unlock(&chair_available);


			sem_wait(&chair_sem[index]);		
			printf("Student %ld receiving help.\n", (long)threadID);
			sem_wait(&stu_sem);		
		}
		else 
			printf("\t\tStudent %ld will try later. \n", (long)threadID);
			//If student didn't find any chair to sit on.
	}
}