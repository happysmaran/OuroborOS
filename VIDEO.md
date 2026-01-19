# Project OuroborOS: Self-Destructing Linux Environment
**Final Demo Documentation**

## Project Overview
This project demonstrates a hardened, minimal Linux environment built from scratch using **Buildroot**. The system features a custom security suite ("OuroborOS") designed for a "One-Man Army" scenario. 

The core functionality consists of a C-based watchdog daemon that monitors system logs for unauthorized activity. Upon detecting a specific trigger—in this case, any attempt to use `sudo`—the system initiates an immediate "Nuclear Wipe" of the filesystem, renders binaries unusable, and forces a kernel panic.

## Demonstration Video
The video showcases the kernel booting into the custom environment, the watchdog service initializing, and the subsequent total system failure following a simulated breach.

**Watch the Demo:** [OuroborOS System Wipe Video](https://drive.google.com/file/d/1QVLMtw0hisHSZabnIy2f_ijYL9Q8Ttpv/view?usp=sharing)

### Video Highlights:
1.  **Boot Sequence:** The Buildroot-built kernel initializes and starts the `ouroboros_watchdog` service via a custom `S99` init script.
2.  **Detection:** A user injects a "sudo" command into the logs using the `logger` utility.
3.  **The Wipe:** The watchdog detects the string, triggers `nuclear_wipe.sh`, and begins unlinking critical system binaries.
4.  **System Collapse:** Commands like `ps` and `ls` cease to function, and the `init` process enters a failure loop as it tries to respawn a deleted `getty` login prompt.

---

## Technical Challenges
The most significant hurdle during development involved the **Init System configuration**. 

During the integration phase, I created a corrupted `inittab` file. In an attempt to reset the configuration, I inadvertently deleted the file entirely. This caused the kernel to reach a "dead end" during boot; without `inittab`, the kernel was unable to initialize user-space services or spawn a login shell. This resulted in a hang at the `Run /sbin/init as init process` stage, requiring a deep dive into manual filesystem mounting and `inittab` syntax to restore system functionality.

---

## Lessons Learned

### 1. Buildroot Efficiency vs. Persistence
I discovered that **Buildroot is efficient, but as such "lazy."** If a source file does not appear to have been modified based on its timestamp, Buildroot will not recompile it—even if a recompilation is necessary to link new dependencies or apply changes in the rootfs-overlay. I learned that manually forcing a rebuild (using `make linux-rebuild` or `make <pkg>-rebuild`) is often necessary to ensure the final image reflects the current state of the code.

### 2. The Significance of Multiple System Config Files
The Buildroot directory structure often contains multiple versions of similar configuration files (such as `inittab`). I learned that **just because multiple versions of a file exist throughout the tree does not mean any of them are redundant.** Each serves a specific purpose at different stages of the build process (skeleton, target, and output). Ditching or ignoring one can break the chain of inheritance that results in a functional root filesystem.

---

### Project Metadata
* **Target Architecture:** x86_64 (QEMU)
* **Build System:** Buildroot 2024.x
* **Security Suite:** OuroborOS Watchdog (C), Remote Trigger (C), Nuclear Wipe (Shell)
* **Submission Date:** January 20, 2026
