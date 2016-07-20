From: <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org>
Subject: filenames with special chars and posix path caps enabled -
 regression?
Date: Wed, 20 Jul 2016 16:43:41 +0100
Message-ID: <20160720164341.1c3a518b@alice.paese.meraviglie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi all,

Recently I've upgraded an older linux box that was still happily
running a 3.10.17 kernel; with the new kernel (4.4.14) I can no longer
access files on a cifs filesystem if the filenames contain special
characters (question mark, in my test case; unix extensions enabled on
the samba server).

I'm not sure it's a bug, but I haven't been able to find out anything in
the kernel changelogs that pointed to a change in behaviour (e.g. a new
parameter).

To reproduce the problem, I set up a minimal environment with a
cut-down smb.conf and mount a samba share that contains a file named
"file?" (no quotes, but trailing question mark). The test environment is
the same, the only difference is the kernel I boot (same
kernel .config).

Whereas older kernels behave as I would expect (I can "ls", "stat" and
"cat" the oddly-named file), newer ones do mount, ls, stat just
fine, but fail on cat 'file?' > /dev/null with a "No such file or
directory" error.

After trying out a clean build from the latest 4.6.4 kernel to no avail,
I narrowed down the large version gap between 3.10.17 and 4.4.14 and
found out that something must have changed between 4.0.9 (works ok) and
4.1.1 (doesn't work anymore).

Checked kernel changelogs and even diff'ed the two source trees but my
untrained eye didn't spot anything obvious.

Question. Am I missing something here? With a default samba
configuration (unix extensions = yes, mangled names = yes), am I not
expected to be able to use filenames containing DOS-reserved characters
(such as ? and ") from a unix client without problems?

Here's the traced output of my test script on a 4.1.1 kernel (this
machine is both the samba server and the cifs client; whitespace
sequences shortened):

+ uname -a
Linux darkstar 4.1.1 #1 SMP Wed Jul 20 13:21:28 IST 2016 x86_64
  Intel(R) Core(TM) i5-3337U CPU @ 1.80GHz GenuineIntel GNU/Linux
+ mount.cifs -V
mount.cifs version: 5.5
+ samba --version
Version 4.2.12
+ grep . /proc/fs/cifs/LinuxExtensionsEnabled
1
+ cat /etc/samba/smb.conf
[global]$
workgroup = MYWORKGROUP
netbios name = MYSERVER
server string = myserver.myworkgroup
security = user
syslog = 0
printing = bsd
load printers = no
disable spoolss = yes
#unix extensions = yes   # default setting anyway
#mangled names = yes     # default setting anyway

[shared]
path = /tmp/shared
read only = no
+ ls -l /tmp/shared/
total 12
-rw-r--r-- 1 root root 24 Jul 20 09:53 "file"
-rw-r--r-- 1 root root 22 Jul 20 09:53 file
-rw-r--r-- 1 root root 23 Jul 20 09:53 file?
+ mount -t cifs -o username=user,password=pass //localhost/shared /mnt
+ cd /mnt
+ ls
"file"  file  file?
+ stat 'file?'
  File: 'file?'
  Size: 23              Blocks: 8          IO Block: 16384  regular file
Device: 19h/25d Inode: 1328306     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2016-07-20 09:53:16.608205000 +0100
Modify: 2016-07-20 09:53:10.214392400 +0100
Change: 2016-07-20 09:53:10.214392400 +0100
 Birth: -
+ cat 'file?'
cat: file?: No such file or directory

^^ note how stat succeeds, but cat fails (and yes, the argument is
properly shell-quoted). Rebooting into a 4.0.9 kernel (same .config)
gives me the expected:

+ cat 'file?'
hello, this is <file?>

I've also captured pcaps for 4.0.9 and 4.1.1 and loaded them up in
wireshark, but found no visible difference (except for the final
response from samba).

If I set /proc/fs/cifs/cifsFYI to 7, the only difference between a good
run (4.0.9 and below) and a bad one (4.1.1+) is a line that reads:

Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT_FOUND

Thinking of a problem with my smb.conf, I tried the userspace tool
smbclient to browse the share and retrieve the offending file; works as
expected -- both with posix disabled + mangled names, and posix enabled
+ unmangled names:

+ smbclient -U user //localhost/shared pass -c 'dir; stat FP5AFZ~2; get
FP5AFZ~2 /dev/stdout'
Domain=[MYWORKGROUP] OS=[Windows 6.1]
Server=[Samba 4.2.12]
.         D      0  Wed Jul 20 09:51:14 2016
..        D      0  Wed Jul 20 14:40:56 2016
file      N     22  Wed Jul 20 09:53:10 2016
FP5AFZ~2  N     23  Wed Jul 20 09:53:10 2016
_WHSTP~N  N     24  Wed Jul 20 09:53:10 2016
  41152832 blocks of size 1024. 10022996 blocks available
File: \FP5AFZ~2
Size: 23                Blocks: 8       regular file
Inode: 1328306  Links: 1
Access: (0644/-rw-r--r--)       Uid: 0  Gid: 0
Access: 2016-07-20 09:53:17 +0100
Modify: 2016-07-20 09:53:10 +0100
Change: 2016-07-20 09:53:10 +0100
getting file \FP5AFZ~2 of size 23 as /dev/stdout (22.5 KiloBytes/sec)
hello, this is <file?>

+ smbclient -U user //localhost/shared pass -c 'posix; dir; stat file?;
get file? /dev/stdout'
Domain=[MYWORKGROUP] OS=[Windows 6.1]
Server=[Samba 4.2.12] Server supports CIFS extensions 1.0 Server
supports CIFS capabilities locks acls pathnames posix_path_operations
large_read posix_encrypt
.        D       0  Wed Jul 20 09:51:14 2016
..       D       0  Wed Jul 20 14:40:56 2016
file     N      22  Wed Jul 20 09:53:10 2016
file?    N      23  Wed Jul 20 09:53:10 2016
"file"   N      24  Wed Jul 20 09:53:10 2016
  41152832 blocks of size 1024. 10022996 blocks available
File: /file?
Size: 23                Blocks: 8       regular file
Inode: 1328306  Links: 1
Access: (0644/-rw-r--r--)       Uid: 0  Gid: 0
Access: 2016-07-20 09:53:17 +0100
Modify: 2016-07-20 09:53:10 +0100
Change: 2016-07-20 09:53:10 +0100
getting file /file? of size 23 as /dev/stdout (22.5 KiloBytes/sec)
hello, this is <file?>

I am at a loss. Is this a bug?

Thanks,
Andrea.
