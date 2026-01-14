#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define LOG_FILE "/var/log/messages"
#define TRIGGER_WORD "sudo"

void self_destruct_sequence() {
    printf("\n!!! [OUROBOROS] UNAUTHORIZED ACTIVITY DETECTED !!!\n");
    printf("!!! [OUROBOROS] INITIATING SELF-DESTRUCT SEQUENCE !!!\n");
    system("/usr/bin/nuclear_wipe.sh");
    
    // Exit the C program so it stops reading logs 
    // while the system is being deleted.
    exit(0); 
}

int main() {
    FILE *fp;
    char buffer[1024];
    long last_pos = 0;

    printf("OuroborOS Watchdog started. Monitoring %s...\n", LOG_FILE);

    while (1) {
        fp = fopen(LOG_FILE, "r");
        if (fp) {
            fseek(fp, last_pos, SEEK_SET);
            
            while (fgets(buffer, sizeof(buffer), fp)) {
                if (strstr(buffer, TRIGGER_WORD)) {
                    self_destruct_sequence();
                }
            }
            
            last_pos = ftell(fp);
            fclose(fp);
        }
        sleep(1); 
    }
    return 0;
}
