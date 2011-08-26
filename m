From: Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org>
Subject: touch: setting times of `file4': Permission denied
Date: Fri, 26 Aug 2011 09:19:05 -0400
Message-ID: <CAHyifnRoqZPUTF0GFGpygMrktmFCPahEHrnBSjR6Bk1a6p+oPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Linux-cifs:

The file "file4" gets created when using the touch command, but the
error message "touch: setting times of `file4': Permission denied" is
returned.

Seems like it is having an issue with the utimensat() call to set the
timestamp?  Why is this?  How is it solved?

Thanks in advance for any assistance.

Tim

# modinfo cifs
filename:       /lib/modules/2.6.32-131.6.1.el6.x86_64/kernel/fs/cifs/cifs.ko
version:        1.68
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     6BE0EB6FED154E567A97675
depends:
vermagic:       2.6.32-131.6.1.el6.x86_64 SMP mod_unload modversions
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 50 Range: 2 to 256 (int)

# mount.cifs -V
mount.cifs version: 4.8.1

# uname -r
2.6.32-131.6.1.el6.x86_64

# rpm -qa | grep samba
samba-client-3.5.6-86.el6.x86_64
samba-common-3.5.6-86.el6.x86_64
samba-winbind-clients-3.5.6-86.el6.x86_64

/etc/fstab entry:
//fileserver/testshare /testmount cifs
rw,file_mode=0775,dir_mode=0775,uid=4051,gid=4053,credentials=/etc/credentials.txt,_netdev
0 0

/etc/passwd entry:
appuser:x:4051:4051:Application user:/home/appuser:/bin/bash

/etc/group entry:
isperms:x:4053:appuser

# cat /etc/credentials.txt
username=WINDOWSUSER
password=<NONEOFYOURBUSINESS>


# strace touch file4
execve("/bin/touch", ["touch", "file4"], [/* 26 vars */]) = 0
brk(0)                                  = 0x17d5000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f886e77f000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=27750, ...}) = 0
mmap(NULL, 27750, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f886e778000
close(3)                                = 0
open("/lib64/librt.so.1", O_RDONLY)     = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0@!\0\202?\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=47072, ...}) = 0
mmap(0x3f82000000, 2128816, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3f82000000
mprotect(0x3f82007000, 2093056, PROT_NONE) = 0
mmap(0x3f82206000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0x3f82206000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\355\201\0061\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1912928, ...}) = 0
mmap(0x3106800000, 3737768, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3106800000
mprotect(0x3106987000, 2097152, PROT_NONE) = 0
mmap(0x3106b87000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x187000) = 0x3106b87000
mmap(0x3106b8c000, 18600, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x3106b8c000
close(3)                                = 0
open("/lib64/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\20\\\0\237;\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=145672, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f886e777000
mmap(0x3b9f000000, 2212768, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3b9f000000
mprotect(0x3b9f017000, 2097152, PROT_NONE) = 0
mmap(0x3b9f217000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x3b9f217000
mmap(0x3b9f219000, 13216, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x3b9f219000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f886e776000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f886e775000
arch_prctl(ARCH_SET_FS, 0x7f886e776700) = 0
mprotect(0x3f82206000, 4096, PROT_READ) = 0
mprotect(0x3106b87000, 16384, PROT_READ) = 0
mprotect(0x3b9f217000, 4096, PROT_READ) = 0
mprotect(0x310621f000, 4096, PROT_READ) = 0
munmap(0x7f886e778000, 27750)           = 0
set_tid_address(0x7f886e7769d0)         = 5363
set_robust_list(0x7f886e7769e0, 0x18)   = 0
futex(0x7fff60c86b4c, FUTEX_WAKE_PRIVATE, 1) = 0
futex(0x7fff60c86b4c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME,
1, NULL, 7f886e776700) = -1 EAGAIN (Resource temporarily unavailable)
rt_sigaction(SIGRTMIN, {0x3b9f005a90, [], SA_RESTORER|SA_SIGINFO,
0x3b9f00f520}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x3b9f005b20, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x3b9f00f520}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=10240*1024, rlim_max=RLIM_INFINITY}) = 0
brk(0)                                  = 0x17d5000
brk(0x17f6000)                          = 0x17f6000
open("/usr/lib/locale/locale-archive", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=99158752, ...}) = 0
mmap(NULL, 99158752, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f88688e4000
close(3)                                = 0
open("file4", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = 3
dup2(3, 0)                              = 0
close(3)                                = 0
utimensat(0, NULL, NULL, 0)             = -1 EACCES (Permission denied)
close(0)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY) = 0
fstat(0, {st_mode=S_IFREG|0644, st_size=2512, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f886e77e000
read(0, "# Locale name alias data base.\n#"..., 4096) = 2512
read(0, "", 4096)                       = 0
close(0)                                = 0
munmap(0x7f886e77e000, 4096)            = 0
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/coreutils.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = 0
fstat(0, {st_mode=S_IFREG|0644, st_size=435, ...}) = 0
mmap(NULL, 435, PROT_READ, MAP_PRIVATE, 0, 0) = 0x7f886e77e000
close(0)                                = 0
write(2, "touch: ", 7touch: )                  = 7
write(2, "setting times of `file4'", 24setting times of `file4') = 24
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT
(No such file or directory)
write(2, ": Permission denied", 19: Permission denied)     = 19
write(2, "\n", 1
)                       = 1
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
