# obj-m specifie we're a kernel module.
# obj-m += greeter.o
obj-m += hello.o
obj-m += simple.o
obj-m += startstop.o
startstop-objs := src/start.o src/stop.o
BUILD_DIR ?= $(PWD)

# Set the path to the Kernel build utils.
KBUILD=/lib/modules/$(shell uname -r)/build/
 
default:
	$(MAKE) -C $(KBUILD) M=$(BUILD_DIR) src=$(PWD) modules

clean:
	$(MAKE) -C $(KBUILD) M=$(BUILD_DIR) src=$(PWD) clean

