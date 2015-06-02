From: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Subject: Copy from CIFS mount blocks until straced
Date: Tue, 2 Jun 2015 09:15:38 -0500 (CDT)
Message-ID: <1610749440.24537.1433254538285.JavaMail.zimbra@xes-inc.com>
References: <1518270014.24528.1433254527447.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518270014.24528.1433254527447.JavaMail.zimbra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I am running a server with cifs-utils 6.0 on Ubuntu 14.04 trusty with a CIFS
mount as follows:
//server/share /mnt/Share cifs rw,relatime,vers=1.0,cache=strict,username=myuser,domain=EXAMPLE,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.0.8,unix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1 0 0

I am using perl's File::Copy function to copy several hundred files from the
share to the local ext4 filesystem:
cp($src, $dst, 32128);

This works fine for almost all of the files, however the perl script always
blocks in uninterruptable sleep on one file in particular. If I strace it, I see
this result:

open("/mnt/Share/file.odt", O_RDONLY) = 7
ioctl(7, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0x7fff3cdd9f20) = -1 ENOTTY (Inappropriate ioctl for device)
lseek(7, 0, SEEK_CUR)                   = 0
fstat(7, {st_mode=S_IFREG|0644, st_size=131018, ...}) = 0
fcntl(7, F_SETFD, FD_CLOEXEC)           = 0
open("/usr/local/share/dest.odt", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 8
ioctl(8, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 0x7fff3cdd9f20) = -1 ENOTTY (Inappropriate ioctl for device)
lseek(8, 0, SEEK_CUR)                   = 0
fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
fcntl(8, F_SETFD, FD_CLOEXEC)           = 0
read(7,

Thus it appears to be blocking on the read(2) command. If I kill this strace, 
the process then "wakes up" and continues processing. It seems that inspecting 
the process causes it to return from its blocking I/O. This behavior is 
reproducible on this one same file (one out of hundreds) from perl, however 
running "cp" or "md5sum" from the command line always returns instantly on 
said file.

It is worth noting that perl's File::Copy function uses 2MB sized buffers when
calling read(2); this does not appear to work over CIFS - it returns an
Input/Output Error. However I have compensated for this by tuning the buffer
size to 32k (as noted above). Could this issue be related (or is this expected
behavior)?

Do you have any ideas what is causing this behavior, or what is causing this
read(2) to block?

Thanks,

Andrew Martin
