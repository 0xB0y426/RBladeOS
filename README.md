# Usage
`chmod +x build-linux.sh`

`./build-linux.sh`

Use qemu or Virtualbox to emulate the OS

Soon I will create a builder for windows.

# RBladeOS

RBladeOS is a simple operating system built in Assembly, designed for learning and compatible with older computers. It offers an easy-to-understand foundation, perfect for those who want to study how a system works or use it on legacy PCs. Additionally, RBladeOS allows you to create your own distribution based on its kernel, where you can add drivers, commands, and other components. Whether for learning or building something new, RBladeOS is a practical and customizable platform for developers.

# RBladeOS 0.1

Date: 02/10/2024

Integration of simple commands into your kernel such as echo, clear, reboot, shutdown, and help. 

![RBladeOS](0.1.png)

Demonstration: https://www.youtube.com/watch?v=V4AOGu0INVw

# RBladeOS 0.2

Date: 15/10/2024

1. Change in Layout, now the background is blue and the banner is more prominent.

2. All commands like, echo, cls, reboot etc... were changeds and echo changed to "PRINT"

3. The "Unknown command" error message unfortunately has an error that is not displaying it, this will be fixed in future versions.

4. Now the kernel has a new command called "loop" that allows you to type things and they appear in a loop until you turn the system off and on.

5. The "help" command has been removed in this release and now all kernel commands are listed below the RBladeOS banner

6. ![RBladeOS](0.2.png)

