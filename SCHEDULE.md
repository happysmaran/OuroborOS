# Project Schedule: Project Ouroboros
## Sprint Schedule

| Sprint | Start Date | End Date | Focus Area |
| :--- | :--- | :--- | :--- |
| **Sprint 1** | Jan 11 | Jan 13 | Environment & Base Monitoring |
| **Sprint 2** | Jan 14 | Jan 16 | The Destruction Engine |
| **Sprint 3** | Jan 17 | Jan 19 | Remote Triggers & Final Polish |

---

## Detailed Daily Timeline

(all issues for each sub-bullet can be found in the "Issues" tab)

### Sprint 1: Foundation & Log Watcher
* **Jan 11:** Finalize Project Proposal, Wiki setup, and GitHub Project Board initialization.
* **Jan 12:** Configure Buildroot for `qemu_x86_64`. Enable `syslogd` and verify log generation in `/var/log/messages`.
* **Jan 13:** Develop the `ouroboros-watchdog` C application. 
    * Must be able to "tail" a file and detect the string "sudo".

### Sprint 2: The Self-Destruct Sequence
* **Jan 14:** Research and implement the "Nuclear Wipe" script. 
    * Script must recursively delete `/` excluding essential runtime paths like `/proc` and `/sys` to prevent immediate kernel hang.
* **Jan 15:** Implement the Magic SysRq trigger.
    * Write a C utility to echo 'c' to `/proc/sysrq-trigger` to force a kernel panic.
* **Jan 16:** Integration testing. Ensure the watchdog can successfully call the wipe script and trigger the crash.

### Sprint 3: Networking & Hardening
* **Jan 17:** Integrate Networking. 
    * Adapt `aesdsocket` code to listen for a specific encrypted or plain-text "Kill Packet" to trigger destruction remotely.
* **Jan 18:** Optimization & Edge Cases. Ensure the system runs from RAM (initramfs) so the destruction process isn't interrupted by disk I/O errors.
* **Jan 19 (Today):** Final Documentation, Peer Review preparation, and project submission.

---

## Sprint 1 Deliverables (Definition of Done)

### Issue #1: Base OS Boot & Log Monitoring
* **Description:** Successfully boot a minimal Buildroot image in QEMU and demonstrate a C program reading system logs.
* **Definition of Done:**
    1.  Buildroot completes compilation without errors.
    2.  QEMU boots to a login prompt.
    3.  A C program running as a background daemon can detect a "forbidden" word appended to `/var/log/messages` and print an alert to the console.

### Issue #2: Build Automation (The Ouroboros Package)
* **Description:** Create a formal Buildroot package for the watchdog application.
* **Definition of Done:**
    1.  Create `package/ouroboros/Config.in` and `package/ouroboros/ouroboros.mk`.
    2.  Application is cross-compiled and included in the final `.img` file automatically.
    3.  An S-script (init script) in `/etc/init.d/` starts the daemon automatically on boot.

---

## Blocker List
* **Rootfs persistence:** If the system is not running in RAM, the `rm -rf` command will destroy the `rm` binary before it finishes, which defeats the point. 
    * *Mitigation, hopefully:* Use `cp` to move essential binaries to a `tmpfs` before execution or use a static build of a "wipe" utility.
