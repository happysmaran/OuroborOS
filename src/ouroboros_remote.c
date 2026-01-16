#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 9000
#define KILL_CODE "EXTERMINATE"

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    // Create socket file descriptor
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    // Forcefully attaching socket to port 9000
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 3);

    printf("[OUROBOROS-REMOTE] Listening on port %d for Kill Code...\n", PORT);

    while(1) {
        new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen);
        read(new_socket, buffer, 1024);
        
        if (strncmp(buffer, KILL_CODE, strlen(KILL_CODE)) == 0) {
            printf("\n!!! [OUROBOROS] REMOTE KILL COMMAND RECEIVED !!!\n");
            system("/usr/bin/nuclear_wipe.sh");
            exit(0);
        }
        close(new_socket);
        memset(buffer, 0, 1024);
    }
    return 0;
}
