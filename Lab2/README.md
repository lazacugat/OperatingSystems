In this laboratory, a User-Space Semaphore System will be implemented, serving as a synchronization mechanism between processes. This system will be implemented in the RISC-V version of XV6, an educational operating system, in the kernel space and should provide syscalls accessible from user space.

We will implement only one style of semaphores in this lab, known as named semaphores, inspired by the named semaphores defined in POSIX.

Characteristics of named semaphores:

They are managed by the kernel.
They are available globally for all processes in the operating system (i.e., there are no 'private' semaphores).
Their state is preserved while the operating system is active (i.e., they are not lost between reboots).
Each semaphore has a 'name' that identifies it with the kernel, and in our case, the names are integer numbers between 0 and a maximum limit (similar to file descriptors).