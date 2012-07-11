From: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs multiuser w/o =?UTF-8?Q?krb5=3F_How=3F?=
Date: Wed, 11 Jul 2012 21:06:36 +0200
Message-ID: <cone.1342033596.416709.10432.1000@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

sorry, sent from a wrong email address and probably silently rejected =20
by Majordomo...
-------- P=C5=99eposlan=C3=A1 zpr=C3=A1va --------
P=C5=99edm=C4=9Bt: Re: mount.cifs multiuser w/o krb5? How?
Datum: Tue, 10 Jul 2012 23:05:21 +0200

Jeff Layton writes:

> Ok, that at least gives us something to go on. Running this under
> strace might give us some sort of clue as to the problem as well.
>

Here it is:

[root@client ~]# su - zmrzlinka
[zmrzlinka@client ~]$ strace cifscreds add toillet
execve("/usr/bin/cifscreds", ["cifscreds", "add", "toillet"], [/* 27 va=
rs =20
*/]) =3D 0
brk(0)                                  =3D 0x64e000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed93000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or =
=20
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D256357, ...}) =3D 0
mmap(NULL, 256357, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f4eaed54000
close(3)                                =3D 0
open("/usr/lib/libkeyutils.so.1", O_RDONLY|O_CLOEXEC) =3D 3
read(3, =20
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\21\0\0\0\0\0\0"...,=
 832) =20
=3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D14480, ...}) =3D 0
mmap(NULL, 2109608, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, =
0) =3D =20
0x7f4eae96f000
mprotect(0x7f4eae972000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4eaeb71000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|=
=20
MAP_DENYWRITE, 3, 0x2000) =3D 0x7f4eaeb71000
close(3)                                =3D 0
open("/lib/libc.so.6", O_RDONLY|O_CLOEXEC) =3D 3
read(3, =20
"\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\30\2\0\0\0\0\0"..., =
832) =20
=3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1997041, ...}) =3D 0
mmap(NULL, 3816528, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, =
0) =3D =20
0x7f4eae5cb000
mprotect(0x7f4eae766000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4eae965000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED=
|=20
MAP_DENYWRITE, 3, 0x19a000) =3D 0x7f4eae965000
mmap(0x7f4eae96b000, 15440, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED=
|=20
MAP_ANONYMOUS, -1, 0) =3D 0x7f4eae96b000
close(3)                                =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed53000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed52000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed51000
arch_prctl(ARCH_SET_FS, 0x7f4eaed52700) =3D 0
mprotect(0x7f4eae965000, 16384, PROT_READ) =3D 0
mprotect(0x7f4eaeb71000, 4096, PROT_READ) =3D 0
mprotect(0x602000, 4096, PROT_READ)     =3D 0
mprotect(0x7f4eaed94000, 4096, PROT_READ) =3D 0
munmap(0x7f4eaed54000, 256357)          =3D 0
getuid()                                =3D 1001
brk(0)                                  =3D 0x64e000
brk(0x66f000)                           =3D 0x66f000
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 3
connect(3, {sa_family=3DAF_FILE, sun_path=3D"/var/run/nscd/socket"}, 11=
0) =3D -1 =20
ENOENT (No such file or directory)
close(3)                                =3D 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 3
connect(3, {sa_family=3DAF_FILE, sun_path=3D"/var/run/nscd/socket"}, 11=
0) =3D -1 =20
ENOENT (No such file or directory)
close(3)                                =3D 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D274, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
read(3, "# Begin /etc/nsswitch.conf\n\npass"..., 4096) =3D 274
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D256357, ...}) =3D 0
mmap(NULL, 256357, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f4eaed54000
close(3)                                =3D 0
open("/lib/libnss_files.so.2", O_RDONLY|O_CLOEXEC) =3D 3
read(3, =20
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\"\0\0\0\0\0\0"..., 8=
32) =3D =20
832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D52112, ...}) =3D 0
mmap(NULL, 2148136, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, =
0) =3D =20
0x7f4eae3be000
mprotect(0x7f4eae3ca000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4eae5c9000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|=
=20
MAP_DENYWRITE, 3, 0xb000) =3D 0x7f4eae5c9000
close(3)                                =3D 0
mprotect(0x7f4eae5c9000, 4096, PROT_READ) =3D 0
munmap(0x7f4eaed54000, 256357)          =3D 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D1439, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
read(3, "root:x:0:0:root client:/root:/bi"..., 4096) =3D 1439
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
socket(PF_NETLINK, SOCK_RAW, 0)         =3D 3
bind(3, {sa_family=3DAF_NETLINK, pid=3D0, groups=3D00000000}, 12) =3D 0
getsockname(3, {sa_family=3DAF_NETLINK, pid=3D18164, groups=3D00000000}=
, [12]) =3D 0
sendto(3, "\24\0\0\0\26\0\1\3^\227\374O\0\0\0\0\0\0\0\0", 20, 0, =20
{sa_family=3DAF_NETLINK, pid=3D0, groups=3D00000000}, 12) =3D 20
recvmsg(3, {msg_name(12)=3D{sa_family=3DAF_NETLINK, pid=3D0, groups=3D0=
0000000}, =20
msg_iov(1)=3D[{"0\0\0\0\24\0\2\0^\227\374O\364F\0\0\2\10\200\376\1\0\0\=
0\10\0\1\0\177\0\0\1"..., =20
4096}], msg_controllen=3D0, msg_flags=3D0}, 0) =3D 224
recvmsg(3, {msg_name(12)=3D{sa_family=3DAF_NETLINK, pid=3D0, groups=3D0=
0000000}, =20
msg_iov(1)=3D[{"@\0\0\0\24\0\2\0^\227\374O\364F\0\0\n\200\200\376\1\0\0=
\0\24\0\1\0\0\0\0\0"..., =20
4096}], msg_controllen=3D0, msg_flags=3D0}, 0) =3D 192
recvmsg(3, {msg_name(12)=3D{sa_family=3DAF_NETLINK, pid=3D0, groups=3D0=
0000000}, =20
msg_iov(1)=3D[{"\24\0\0\0\3\0\2\0^\227\374O\364F\0\0\0\0\0\0", 4096}], =
=20
msg_controllen=3D0, msg_flags=3D0}, 0) =3D 20
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 4
connect(4, {sa_family=3DAF_FILE, sun_path=3D"/var/run/nscd/socket"}, 11=
0) =3D -1 =20
ENOENT (No such file or directory)
close(4)                                =3D 0
close(3)                                =3D 0
socket(PF_FILE, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 3
connect(3, {sa_family=3DAF_FILE, sun_path=3D"/var/run/nscd/socket"}, 11=
0) =3D -1 =20
ENOENT (No such file or directory)
close(3)                                =3D 0
open("/etc/host.conf", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D63, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
read(3, "#\n# /etc/host.conf\n#\n\norder host"..., 4096) =3D 63
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
getpid()                                =3D 18164
open("/etc/resolv.conf", O_RDONLY|O_CLOEXEC) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D63, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
read(3, "nameserver 127.0.0.1\nnameserver "..., 4096) =3D 63
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
uname({sys=3D"Linux", node=3D"client", ...}) =3D 0
open("/etc/hosts", O_RDONLY|O_CLOEXEC)  =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D622, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
read(3, "#\n# /etc/hosts: static lookup ta"..., 4096) =3D 622
read(3, "", 4096)                       =3D 0
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
keyctl(0xa, 0xfffffffd, 0x4021c2, 0x7fff300084d0, 0) =3D -1 ENOKEY (Req=
uired =20
key not available)
open("/dev/tty", O_RDWR|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) =3D 3
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS=
, =20
{B38400 opost isig icanon echo ...}) =3D 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF, =20
{B38400 opost -isig icanon -echo ...}) =3D 0
fstat(3, {st_mode=3DS_IFCHR|0666, st_rdev=3Dmakedev(5, 0), ...}) =3D 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS=
, =20
{B38400 opost -isig icanon -echo ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0=
) =3D =20
0x7f4eaed92000
write(3, "Password: ", 10Password: )              =3D 10
read(3, "\33[B\33[C\33[B\33[D\n", 4096) =3D 13
write(3, "\n", 1
)                       =3D 1
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF, =20
{B38400 opost isig icanon echo ...}) =3D 0
close(3)                                =3D 0
munmap(0x7f4eaed92000, 4096)            =3D 0
add_key(0x4021c2, 0x7fff30008410, 0x7fff30008450, 0x17, 0xfffffffd) =3D=
 =20
588748510
keyctl(0x5, 0x231796de, 0xd0d0000, 0xffffffffffffffff, 0xfffffffd) =3D =
0
exit_group(0)                           =3D ?
+++ exited with 0 +++
