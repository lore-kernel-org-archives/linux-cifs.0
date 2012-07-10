From: knizek-VIXq6x/3rUk@public.gmane.org
Subject: Re: mount.cifs multiuser w/o =?UTF-8?Q?krb5=3F_How=3F?=
Date: Tue, 10 Jul 2012 23:05:21 +0200
Message-ID: <cone.1341954321.486934.13606.1000@athlon>
References: <1341427937.3252.6.camel@athlon.garagome> <20120706141543.1b564c11@tlielax.poochiereds.net> <1341612593.26748.9.camel@athlon.garagome> <20120709062608.3a67445f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton writes:

> Ok, that at least gives us something to go on. Running this under
> strace might give us some sort of clue as to the problem as well.
>

Here it is:

[root@client ~]# su - zmrzlinka
[zmrzlinka@client ~]$ strace cifscreds add toillet
execve("/usr/bin/cifscreds", ["cifscreds", "add", "toillet"], [/* 27 vars  
*/]) = 0
brk(0)                                  = 0x64e000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed93000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or  
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=256357, ...}) = 0
mmap(NULL, 256357, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4eaed54000
close(3)                                = 0
open("/usr/lib/libkeyutils.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3,  
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\21\0\0\0\0\0\0"..., 832)  
= 832
fstat(3, {st_mode=S_IFREG|0755, st_size=14480, ...}) = 0
mmap(NULL, 2109608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =  
0x7f4eae96f000
mprotect(0x7f4eae972000, 2093056, PROT_NONE) = 0
mmap(0x7f4eaeb71000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED| 
MAP_DENYWRITE, 3, 0x2000) = 0x7f4eaeb71000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3,  
"\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\30\2\0\0\0\0\0"..., 832)  
= 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1997041, ...}) = 0
mmap(NULL, 3816528, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =  
0x7f4eae5cb000
mprotect(0x7f4eae766000, 2093056, PROT_NONE) = 0
mmap(0x7f4eae965000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED| 
MAP_DENYWRITE, 3, 0x19a000) = 0x7f4eae965000
mmap(0x7f4eae96b000, 15440, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED| 
MAP_ANONYMOUS, -1, 0) = 0x7f4eae96b000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed53000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed52000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed51000
arch_prctl(ARCH_SET_FS, 0x7f4eaed52700) = 0
mprotect(0x7f4eae965000, 16384, PROT_READ) = 0
mprotect(0x7f4eaeb71000, 4096, PROT_READ) = 0
mprotect(0x602000, 4096, PROT_READ)     = 0
mprotect(0x7f4eaed94000, 4096, PROT_READ) = 0
munmap(0x7f4eaed54000, 256357)          = 0
getuid()                                = 1001
brk(0)                                  = 0x64e000
brk(0x66f000)                           = 0x66f000
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, sun_path="/var/run/nscd/socket"}, 110) = -1  
ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, sun_path="/var/run/nscd/socket"}, 110) = -1  
ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=274, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
read(3, "# Begin /etc/nsswitch.conf\n\npass"..., 4096) = 274
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=256357, ...}) = 0
mmap(NULL, 256357, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4eaed54000
close(3)                                = 0
open("/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3,  
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\"\0\0\0\0\0\0"..., 832) =  
832
fstat(3, {st_mode=S_IFREG|0755, st_size=52112, ...}) = 0
mmap(NULL, 2148136, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =  
0x7f4eae3be000
mprotect(0x7f4eae3ca000, 2093056, PROT_NONE) = 0
mmap(0x7f4eae5c9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED| 
MAP_DENYWRITE, 3, 0xb000) = 0x7f4eae5c9000
close(3)                                = 0
mprotect(0x7f4eae5c9000, 4096, PROT_READ) = 0
munmap(0x7f4eaed54000, 256357)          = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1439, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
read(3, "root:x:0:0:root client:/root:/bi"..., 4096) = 1439
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
socket(PF_NETLINK, SOCK_RAW, 0)         = 3
bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(3, {sa_family=AF_NETLINK, pid=18164, groups=00000000}, [12]) = 0
sendto(3, "\24\0\0\0\26\0\1\3^\227\374O\0\0\0\0\0\0\0\0", 20, 0,  
{sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000},  
msg_iov(1)=[{"0\0\0\0\24\0\2\0^\227\374O\364F\0\0\2\10\200\376\1\0\0\0\10\0\1\0\177\0\0\1"...,  
4096}], msg_controllen=0, msg_flags=0}, 0) = 224
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000},  
msg_iov(1)=[{"@\0\0\0\24\0\2\0^\227\374O\364F\0\0\n\200\200\376\1\0\0\0\24\0\1\0\0\0\0\0"...,  
4096}], msg_controllen=0, msg_flags=0}, 0) = 192
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000},  
msg_iov(1)=[{"\24\0\0\0\3\0\2\0^\227\374O\364F\0\0\0\0\0\0", 4096}],  
msg_controllen=0, msg_flags=0}, 0) = 20
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 4
connect(4, {sa_family=AF_FILE, sun_path="/var/run/nscd/socket"}, 110) = -1  
ENOENT (No such file or directory)
close(4)                                = 0
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_FILE, sun_path="/var/run/nscd/socket"}, 110) = -1  
ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/host.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=63, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
read(3, "#\n# /etc/host.conf\n#\n\norder host"..., 4096) = 63
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
getpid()                                = 18164
open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=63, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
read(3, "nameserver 127.0.0.1\nnameserver "..., 4096) = 63
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
uname({sys="Linux", node="client", ...}) = 0
open("/etc/hosts", O_RDONLY|O_CLOEXEC)  = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=622, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
read(3, "#\n# /etc/hosts: static lookup ta"..., 4096) = 622
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
keyctl(0xa, 0xfffffffd, 0x4021c2, 0x7fff300084d0, 0) = -1 ENOKEY (Required  
key not available)
open("/dev/tty", O_RDWR|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,  
{B38400 opost isig icanon echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,  
{B38400 opost -isig icanon -echo ...}) = 0
fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(5, 0), ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,  
{B38400 opost -isig icanon -echo ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =  
0x7f4eaed92000
write(3, "Password: ", 10Password: )              = 10
read(3, "\33[B\33[C\33[B\33[D\n", 4096) = 13
write(3, "\n", 1
)                       = 1
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,  
{B38400 opost isig icanon echo ...}) = 0
close(3)                                = 0
munmap(0x7f4eaed92000, 4096)            = 0
add_key(0x4021c2, 0x7fff30008410, 0x7fff30008450, 0x17, 0xfffffffd) =  
588748510
keyctl(0x5, 0x231796de, 0xd0d0000, 0xffffffffffffffff, 0xfffffffd) = 0
exit_group(0)                           = ?
+++ exited with 0 +++
