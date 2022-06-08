#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

#define PAGE_TABLE_SIZE  256 
#define ADDRESS_SIZE 16
#define PAGE_SIZE 8 

typedef struct TLB_table {
	unsigned char frame[ADDRESS_SIZE]; // main memory 
	unsigned char page[ADDRESS_SIZE];
	int index;
}tlb;

int memoryAddress;
int current = 0;
int pageFault = 0;
char PageTable[PAGE_TABLE_SIZE];
char PhysicalMemory[PAGE_TABLE_SIZE][PAGE_TABLE_SIZE];  // must 2 dimension

int total_memory = 0;
int hits = 0;  // Backing store hit


struct TLB_table table;

int readMemoryAddress(char* PhysicalMemory, int* pageOffset, int pageAddress) {
	char memory[PAGE_TABLE_SIZE];
	FILE* fd;
	fd = fopen("BACKING_STORE.bin", "rb");
	memset(memory, 0, sizeof(memory));

	if (fseek(fd, pageAddress * PAGE_TABLE_SIZE, SEEK_SET) != 0)
		return 0;
	if (fread(memory, sizeof(char), PAGE_TABLE_SIZE, fd) == 0)
		return 0;

	int index = 0;
	while (index < PAGE_TABLE_SIZE) {
		int address = (*pageOffset) * PAGE_TABLE_SIZE + index;
		*(PhysicalMemory + address) = memory[index];
		index++;
	}
	(*pageOffset)++;

	return (*pageOffset) - 1;
}

int printPhysicalAddress(int  address, unsigned char pageOffset, char* PhysicalMemory) {
	int index = ((unsigned char)address * PAGE_TABLE_SIZE) + pageOffset;
	int value = *(PhysicalMemory + index);
	printf("Physical address: %d\t Value: %d\n", index, value);
	return index;
}

// important!
int initialize() {
	memset(PageTable, -1, sizeof(PageTable));
	memset(table.page, -1, sizeof(table.page));
	memset(table.frame, -1, sizeof(table.frame));
	table.index = 0;
	return 0;
}

int Statistics(int pageFault, int total_memory, int hits) {
	float FaultRate;
	float HitRate;
	FaultRate = 100 * ((float)pageFault / (float)total_memory);
	HitRate = 100 * ((float)hits / (float)total_memory);
	printf("Number of addresses translated %d\n", total_memory);
	printf("Page Faults Rate = %.4f\n", FaultRate);
	printf("TLB Hit Rate= %.4f\n", HitRate);

	return 0;
}

int main(int argc, char* argv[]) {
	initialize();
	FILE* fd;
	FILE* fd2;
	fd = fopen(argv[1], "r");
	fd2 = fopen("correct.txt", "r");

	// Use to store the correct.txt
	int int1;
	int int2_result;  // The real physical address we get
	int int3;
	char char1[15]; // 2^4
	char char2[15];
	char char3[15];
	char char4[15];
	char char5[15];
	int err_cnt = 0; 
	while (fscanf(fd, "%d", &memoryAddress) == 1) {
		unsigned char pageNumber;
		bool isHit = false;
		unsigned char bitMasking = 0xFF;
		unsigned char pageOffset;
		int n = 0;
		int back_out = 0;
		printf("Virtual adress: %d\t", memoryAddress); 
		pageNumber = (memoryAddress >> 8) & bitMasking;
		pageOffset = memoryAddress & bitMasking;
		int i = 0;
		// judge the digits number
		while (i < ADDRESS_SIZE) {
			if (table.page[i] == pageNumber) {
				n = table.frame[i];
				isHit = true;
				hits++;
			}
			i++;
		}
		if (isHit == false) {
			if (PageTable[pageNumber] != -1) {
			}
			else { 
				// The page number matches the page table residing in main memory
				back_out = readMemoryAddress((char*)PhysicalMemory, &current, pageNumber);
				PageTable[pageNumber] = back_out;
				pageFault++;
			}
			n = PageTable[pageNumber];
			// To find the page
			table.page[table.index] = pageNumber;
			table.frame[table.index] = PageTable[pageNumber];
			table.index = (table.index + 1) % ADDRESS_SIZE;

		}
		int index; // Store the transfer result
		fscanf(fd2, "%s %s %d %s %s %d %s %d\n", char1, char2, &int1, char3, char4, &int2_result, char5, &int3);
		index = printPhysicalAddress(n, pageOffset, (char*)PhysicalMemory);
		if (index != int2_result) {
			err_cnt++;  // Error count plus 1
		}
		total_memory++;
	}

	Statistics(pageFault, total_memory, hits);
	printf("There are %d transfer error.", err_cnt);
	return 0;

}
