			+-------------------------+
			|        EC 440           |
			| PROJECT 0: Getting Real |
			|     DESIGN DOCUMENT     |
			+-------------------------+
				   
---- AUTHOR ----

Anthony Nguyen thonyngu@bu.edu


---- PRELIMINARIES ----

>> If you have any preliminary comments on your submission, notes for the
>> TAs, or extra credit, please give them here.

I've created a setup.sh file where if you source it, it should export the necessary BXSHARE for utilizing BOCHS. I've also setup a little name for the docker bash too. I've created an bashrc file in /p0 that creates a VcXsrv server to run the graphical components of QEMU. It won't work inside the docker image obviously. I think it's useful for anyone on a Windows machine to have instead of having to type out those commands. 

>> Please cite any offline or online sources you consulted while
>> preparing your submission, other than the Pintos documentation, course
>> text, lecture notes, and course staff.

			     Booting Pintos
			     ==============

---- QUESTIONS ---- 
>> Put the screenshots of Pintos running in src/p0.
>> A1: Is there any particular issue that you would like us to know?
  Getting BOCHS to run is a headache because the docker image still points to the PKUOS directory instead of the BUOS one. Also downloading X11 alternatives like VcXsrv works with opening QEMU's GUI. Too many issues.

			     Debugging
			     =========

---- QUESTIONS: BIOS ---- 
>> B1: What is the first instruction that gets executed?
The first instruction that gets executed is ljmp.

>> B2: At which physical address is this instruction located?
The physical address of this instruction is 0xfff0

>> B3: Can you guess why the first instruction is like this?
ljmp stands for long jump and the instruction allows it to jump to where the BIOS is loaded.

>> B4: What are the next three instructions?
cmpw		-compare
jne			-jump if not equal
xor			-xor operation

I think what its doing is comparing the CPU's place in memory to where the BIOS is and jumps to that place in memory if its not equal.

---- QUESTIONS: BOOTLOADER ---- 
>> B5: How does the bootloader read disk sectors? In particular, what BIOS interrupt is used?
It reads the partition table on each system hard disk and utilizes type 0x20 partitions to load the Pintos Kernel. in the read_sector function it uses int $0x13 to throw an error. Also in the no_boot_partition function if the boot fails it uses int $0x18 to throw an error.

>> B6: How does the bootloader decides whether it successfully finds the Pintos kernel?
In the check_partition, it tries to determine if its a unused partition, a pintos kernal partition and whether it is bootable. 

>> B7: What happens when the bootloader could not find the Pintos kernel?
If the current partition doesn't contain the Pintos kernel it jumps to the next_partition. If all partitions do not contain the kernel then it prints the string "Not found" and interupts.

>> B8: At what point and how exactly does the bootloader transfer control to the Pintos kernel?
If the partition is bootable it will jump to the load_kernel function. It reads the starting address out of the ELF header and converts it from 32-bit address to 16:16 segment, then it jumpt to the converted address.

---- QUESTIONS: KERNEL ---- 
>> B9: At the entry of pintos_init(), what is the value of expression init_page_dir[pd_no(ptov(0))] in hexadecimal format?
The value of the expression is 0x72002c27

>> B10: When palloc_get_page() is called for the first time,

>> B10.1 what does the call stack look like?
palloc_get_page --> paging_init --> pintos_init --> start.S


>> B10.2 what is the return value in hexadecimal format?
The return value is 0xc002311a

>> B10.3 what is the value of expression init_page_dir[pd_no(ptov(0))] in hexadecimal format?
The value of the expression is 0x0

>> B11: When palloc_get_page() is called for the third time,


>> B11.1 what does the call stack look like?
thread_start --> pintos_init --> Start.S

>> B11.2 what is the return value in hexadecimal format?
The return value is 0xc0023114

>> B11.3 what is the value of expression init_page_dir[pd_no(ptov(0))] in hexadecimal format?
The value is 0x102027

			     Kernel Monitor
			     ==============

---- DATA STRUCTURES ----

>> C1: Copy here the declaration of each new or changed `struct' or
>> `struct' member, global or static variable, `typedef', or
>> enumeration.  Identify the purpose of each in 25 words or less.
defined CMD_BUFFER_SIZE which determines how large the buffer size can be.
char cmd_buffer is my buffer and temporarily stores the line typed in.
char *p is my pointer to the buffer.
char c constantly reads a character from my keyboard.

---- ALGORITHMS ----
>> C2: Explain how you read and write to the console for the kernel monitor.
I defined a command buffer that acts as my "container" for storing my keyboard inputs. I send the characters to the console using putchar so that it displays on the kernel monitor. I used strcmp to compare the buffer with the new commands "whoami" and "exit" in order to execute these functions. 

>> C3: Any additional enhancement you implement?
I implemented the ability to use backspace instead of having to retype the command. I plan to implement arrow key functionality to traverse the buffer instead of having to utilize backspace. 