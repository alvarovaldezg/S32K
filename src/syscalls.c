#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>

// Minimal _exit implementation for bare-metal
void _exit(int status) {
    while (1) {
        // Infinite loop to prevent further execution
    }
}

// Minimal _kill implementation
int _kill(int pid, int sig) {
    errno = EINVAL;
    return -1;
}

// Minimal _getpid implementation
int _getpid(void) {
    return 1; // Return a dummy PID
}

// Minimal write implementation
int _write(int file, const char *ptr, int len) {
    return len;
}

// Minimal fstat implementation
int _fstat(int file, struct stat *st) {
    st->st_mode = S_IFCHR;
    return 0;
}

// Minimal isatty implementation
int _isatty(int file) {
    return 1;
}

// Minimal lseek implementation
int _lseek(int file, int ptr, int dir) {
    return 0;
}

// Minimal read implementation
int _read(int file, char *ptr, int len) {
    return 0;
}

// Minimal close implementation
int _close(int file) {
    return -1;
}

// Minimal open implementation
int _open(const char *name, int flags, int mode) {
    return -1;
}
