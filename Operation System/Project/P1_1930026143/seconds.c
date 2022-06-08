#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <asm/uaccess.h>
#define BUFFER_SIZE 128
#define PROC_NAME "seconds"
long int start_time;

//#define HAVE_PROC_OPS
ssize_t proc_read(struct file *file, char *usr_buf, size_t count, loff_t *pos);

#ifdef HAVE_PROC_OPS
static struct proc_ops ops = {
    .proc_read = proc_read,
};
#else
static struct file_operations ops = {
    .owner = THIS_MODULE,
    .read = proc_read,
};
#endif

int proc_init(void){
    /* creates the /proc/seconds entry */
    start_time = jiffies;
    proc_create(PROC_NAME, 0666, NULL, &ops);
    return 0;
}

/* Function is called when the module is removed. */
void proc_exit(void){
/* removes the /proc/seconds entry */
    remove_proc_entry(PROC_NAME, NULL);
}

ssize_t proc_read(struct file *file, char *usr_buf, size_t count, loff_t *pos) {
    int rv = 0; 
    char buffer[BUFFER_SIZE];

    static int completed = 0;
    if (completed) {
        completed = 0;
        return 0;
    }
    completed = 1;
    rv = sprintf(buffer, "seconds[%ld]\n", (jiffies-start_time)/HZ);
    /* copies kernel space buffer to user space usr buf */
    raw_copy_to_user(usr_buf, buffer, rv);
    return rv;
}
module_init(proc_init);
module_exit(proc_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Hello Module");
MODULE_AUTHOR("SGG");
