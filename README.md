# Project Overview: OuroborOS

## Overview
**Project OuroborOS** is a "security-by-suicide" Linux distribution. It is a high-paranoia, ephemeral environment designed to monitor its own system logs and immediately initiate a "Self-Destruct" sequence—wiping the filesystem and triggering a kernel panic—if unauthorized activity or forbidden commands are detected. Basically Ouroboros, but in Linux!

**Goals and Motivation:**
* **System Integrity:** Implementing a real-time watchdog that monitors `/var/log/messages`.
* **Automated Destruction:** Creating a robust sequence that executes a recursive wipe of the root filesystem.
* **Kernel Interfacing:** Using the `SysRq` interface to force a hardware-level crash once the data is destroyed.
* **Motivation:** To explore the depths of Linux system administration and kernel-user space triggers through a technically challenging (and intentionally absurd) use case.

### Hardware Block Diagram
There isn't one, really, as everything happens in software. The hardware would be a computer (or in our case a QEMU x86_64 vm).

---

## Target Build System
**Buildroot**
Buildroot was chosen for its ability to generate a minimal, high-performance root filesystem, which is essential for a project that needs to run primarily in RAM to facilitate its own destruction without hanging on disk I/O errors.

---

## Hardware Platform
* **Platform:** QEMU x86_64 (Standard PC)
* **Support Detail:** This platform is natively supported by Buildroot via the `qemu_x86_64_defconfig`. 
* **Sourcing:** I will be sourcing the hardware virtually via QEMU; no physical boards are requested, but this can all run on one.

---

## Open Source Projects Used
* **BusyBox:** For the lightweight `syslogd` implementation and standard shell utilities (rm, echo, cat).
* **Standard C Library (glibc/uClibc-ng):** For the watchdog daemon implementation.
* **Procps-ng:** To monitor system processes during the destruction sequence.

---

## Previously Discussed Content
* **Assignment 4 (Socket Programming):** The `aesdsocket` logic will be adapted to create a "Kill-Switch" listener that allows the system to be triggered remotely via a specific TCP packet.
* **Buildroot Integration:** Custom packages and rootfs overlay techniques learned in Assignments 4-7 (prob. 8 and 9 too, in a way) to bundle the daemon and destruction scripts.
* **Init Scripts:** Using SystemV init scripts to ensure the watchdog daemon starts immediately upon boot.

---

## New Content
* **Magic SysRq Interface:** Interacting with `/proc/sysrq-trigger` to force an immediate kernel panic or reboot from userspace.
* **Log Parsing in C:** Implementing an efficient tail-style log parser that watches for keywords (e.g., "sudo", "failed login") in `/var/log/messages`.
* **In-Memory Execution:** Configuring the system to run from `initramfs` (ramfs) to ensure the OS remains functional enough to complete the deletion of the virtual disk.

---

## Shared Material
None. This project is entirely specific to this course and is not being leveraged from other coursework.

---

## Source Code Organization
* **Buildroot Repository:** Hosted in this main student repository, including custom configurations and overlays.
* **Watchdog Application:** Source code for the Ouroboros Daemon will be hosted in the `src/` directory of this repository.
* **Additional Repositories:** None requested.

---

## Team Members and Roles
* **Individual Contributor:** Uh, me, happysmaran
* **Role:** Lead Architect, Kernel Configuration, Daemon Developer, and Professional Saboteur.
* tldr it's just me.
