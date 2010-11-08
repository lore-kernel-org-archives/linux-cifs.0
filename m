From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on 2.6.37-rc1
Date: Mon, 08 Nov 2010 14:05:03 +0530
Message-ID: <4CD7B637.1070004@suse.de>
References: <484246.91210.qm@web27103.mail.ukl.yahoo.com>	<20101107211202.3b3468dd@corrin.poochiereds.net> <AANLkTikzTztJUP5-zHCKr4nzuG=bSzmZ+ga7dU0r3QPU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikzTztJUP5-zHCKr4nzuG=bSzmZ+ga7dU0r3QPU-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/08/2010 10:21 AM, Steve French wrote:

> On Sun, Nov 7, 2010 at 8:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
>> On Sun, 7 Nov 2010 16:44:46 +0000 (GMT)
>> Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org> wrote:
>>
>>> After upgrading from 2.6.36 for other reasons, starting certain app=
s like wine utorrent.exe will cause a kernel oops. I run the x86_64 ver=
sion of Ubuntu 10.10 with various modified packages all around and the =
2.6.37-rc1 kernel from the kernel PPA team. I experienced the same with=
 a kernel I tried compiling myself too.
>>>
>>> Nov =FD7 17:25:50 wodan kernel: [77498.450787] BUG: unable to handl=
e kernel NULL pointer dereference at 0000000000000040
>>> Nov =FD7 17:25:50 wodan kernel: [77498.450883] IP: [<ffffffffa03957=
29>] cifs_ioctl+0x39/0x2f0 [cifs]

Does the below patch fixes your problem?


=46rom: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix a NULL pointer dereference in cifs_ioctl() w=
hen the fd is bad

The commit ba00ba modified cifs_ioctl() to use tcon pointer in cifsFile=
Info
via tlink instead of cifs_sb->tcon. When the file handle is not valid t=
he
cifsFileInfo->tlink will be NULL. Fix this by getting the tcon pointer =
by
calling cifs_sb_master_tcon().

Here's a hackish reproducer:

#include  <fcntl.h>
#include  <sys/ioctl.h>
#include  <sys/stat.h>
#include  <sys/types.h>
#include  <unistd.h>

#define CIFS_IOC_CHECKUMOUNT    _IO(0xCF, 2)

int main  (int argc, char* argv[])
 {
    int fd =3D open (argv[1], O_RDWR);

    ioctl(fd, CIFS_IOC_CHECKUMOUNT);

    close(fd);
    return 0;
}

This program will cause an oops when called with cifs mount point as an
argument. I have tested the fix with the reproducer and it no longer oo=
pses.

Reported-by: Kjell Rune <kjella79-eZNTXLQAfP4@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=20
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/ioctl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 2fa22f2..b8f680a 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -35,10 +35,10 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
 	struct inode *inode =3D filep->f_dentry->d_inode;
 	int rc =3D -ENOTTY; /* strange error - but the precedent */
 	int xid;
-	struct cifs_sb_info *cifs_sb;
+	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
 #ifdef CONFIG_CIFS_POSIX
 	struct cifsFileInfo *pSMBFile =3D filep->private_data;
-	struct cifsTconInfo *tcon =3D tlink_tcon(pSMBFile->tlink);
+	struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cifs_sb);
 	__u64	ExtAttrBits =3D 0;
 	__u64	ExtAttrMask =3D 0;
 	__u64   caps =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
@@ -48,8 +48,6 @@ long cifs_ioctl(struct file *filep, unsigned int comm=
and, unsigned long arg)
=20
 	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
=20
-	cifs_sb =3D CIFS_SB(inode->i_sb);
-
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
 			cFYI(1, "User unmount attempted");
