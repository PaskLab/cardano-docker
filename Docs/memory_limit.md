# Memory limits on container
### Ubuntu

Since docker container as no memory limit by default, if something goes south, your node could
take all of your host memory resources for itself. Adding memory limits on your container should
help prevent that your container brings your host system down.

Docker uses **cgroups** to limit memory resources.

First, you can check if your system support **cgroup memory and swap accounting** by running the following command:

    docker info
    
If you can see one or all of the following notice at the output ends, it means that some cgroups behaviors
are missing on your system:

    WARNING: No memory limit support
    WARNING: No swap limit support
    WARNING: No kernel memory limit support
    WARNING: No kernel memory TCP limit support
    WARNING: No oom kill disable support

## Boot with "cgroups" Memory accounting

On most system, you'll add the following line in your `/etc/default/grub` file:

    GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory cgroup_memory=1 swapaccount=1"

If you're running on Raspberry Pi, add the following at the end of your `/boot/firmware/cmdline.txt` file:

    cgroup_enable=memory cgroup_memory=1 swapaccount=1

** NOTE: The `cmdline.txt` file **MUST** contain only one line.
