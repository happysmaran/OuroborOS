# Project Overview: OuroborOS

Schedule can be found in SCHEDULE.MD
https://github.com/happysmaran/OuroborOS/blob/main/SCHEDULE.md

Video demonstration can be found in VIDEO.MD
https://github.com/happysmaran/OuroborOS/blob/main/VIDEO.md

## Overview
**Project OuroborOS** is a "security-by-suicide" Linux distribution. It is a high-paranoia, ephemeral environment designed to monitor its own system logs and immediately initiate a "Self-Destruct" sequence—wiping the filesystem and triggering a kernel panic—if unauthorized activity or forbidden commands are detected. Basically Ouroboros, but in Linux!

**Goals and Motivation:**
* **System Integrity:** Implementing a real-time watchdog that monitors `/var/log/messages`.
* **Automated Destruction:** Creating a robust sequence that executes a recursive wipe of the root filesystem.
* **Kernel Interfacing:** Using the `SysRq` interface to force a hardware-level crash once the data is destroyed.
* **Motivation:** To explore the depths of Linux system administration and kernel-user space triggers through a technically challenging (and intentionally absurd) use case.
* **Diagram for system plan:** That diagram can be found in the next section, titled "Hardware Block Diagram." Keep in mind, *this is all software, so temper expectations.*

### Hardware Block Diagram
There isn't one, really, as everything happens in software. The hardware would be a computer (or in our case a QEMU x86_64 vm). But if you so do want one:

<img width="683" height="384" alt="image" src="https://github.com/user-attachments/assets/dd67885a-1e13-4bfa-a51b-5451bfac3cb3" />

* Do not say that the hardware diagram is incomplete. There *is* no hardware element in the first place.
---

## Target Build System
**Buildroot**
Buildroot was chosen for its ability to generate a minimal, high-performance root filesystem, which is essential for a project that needs to run primarily in RAM to facilitate its own destruction without hanging on disk I/O errors.

---

## Hardware Platform
* **Platform:** QEMU x86_64 (Standard PC)
* **Support Detail:** This platform is natively supported by Buildroot via the `qemu_x86_64_defconfig`. 
* **Sourcing:** I will be sourcing the hardware virtually via QEMU; no physical boards are requested, but this can all run on one.
In other words, this hardware platform just uses the Buildroot system we have been using in all of the previous assignments so far, just x64 based rather than arm64 based.
Furthermore, even if it officially is not included in the course's hardware lists for Buildroot, this entire setup can be remade one-to-one on the Raspberry Pi system, which _is_ included in the system, as the code can be transplanted without any changes onto an arm64 system.
---

## Open Source Projects Used
* **Buildroot:** The entire thing is based on its tools it comes with, including GNU GCC. https://github.com/buildroot/buildroot

---

## Previously Discussed Content
* **Socket Programming:** The `aesdsocket` logic will be heavily adapted to create a "Kill-Switch" listener that allows the system to be triggered remotely via a specific TCP packet.
* **Buildroot Integration:** Custom packages and rootfs overlay techniques learned in Assignments 4-7 to bundle the daemon and destruction scripts.
* **Init Scripts:** Using SystemV init scripts to ensure the watchdog daemon starts immediately upon boot.

---

## New Content
* **Magic SysRq Interface:** Interacting with `/proc/sysrq-trigger` to force an immediate kernel panic or reboot from userspace.
* **Log Parsing in C:** Implementing an efficient tail-style log parser that watches for keywords (e.g., "sudo", "failed login") in `/var/log/messages`.
* **In-Memory Execution:** This is important. Configuring the system to run from `initramfs` (ramfs) to ensure the OS remains functional enough to complete the deletion of the virtual disk.

---

## Shared Material
None. This project is entirely specific to this course and is not being leveraged from other coursework.

---

## Source Code Organization
* **Buildroot Repository:** Hosted in this main student repository, including custom configurations and overlays. https://github.com/buildroot/buildroot
* **Watchdog Application:** Source code for the Ouroboros Daemon will be hosted in the `src/` and `/rootfs-overlay` directories of this repository. https://github.com/happysmaran/OuroborOS
* **Additional Repositories:** None required.

---

## Team Members and Roles
* **Individual Contributor:** Uh, me, happysmaran
* **Role:** Lead Architect, Kernel Configuration, Daemon Developer, and Professional Saboteur.
* tldr it's just me.
There is only one member on this entire project, this is an individual thing (which means there are no missing members).
