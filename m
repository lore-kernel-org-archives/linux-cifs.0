From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on
 2.6.37-rc1
Date: Mon, 8 Nov 2010 06:12:27 -0500
Message-ID: <20101108061227.051706ff@tlielax.poochiereds.net>
References: <484246.91210.qm@web27103.mail.ukl.yahoo.com>
	<20101107211202.3b3468dd@corrin.poochiereds.net>
	<AANLkTikzTztJUP5-zHCKr4nzuG=bSzmZ+ga7dU0r3QPU@mail.gmail.com>
	<4CD7B637.1070004@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD7B637.1070004-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 08 Nov 2010 14:05:03 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 11/08/2010 10:21 AM, Steve French wrote:
>=20
> > On Sun, Nov 7, 2010 at 8:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> >> On Sun, 7 Nov 2010 16:44:46 +0000 (GMT)
> >> Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org> wrote:
> >>
> >>> After upgrading from 2.6.36 for other reasons, starting certain a=
pps like wine utorrent.exe will cause a kernel oops. I run the x86_64 v=
ersion of Ubuntu 10.10 with various modified packages all around and th=
e 2.6.37-rc1 kernel from the kernel PPA team. I experienced the same wi=
th a kernel I tried compiling myself too.
> >>>
> >>> Nov =FD7 17:25:50 wodan kernel: [77498.450787] BUG: unable to han=
dle kernel NULL pointer dereference at 0000000000000040
> >>> Nov =FD7 17:25:50 wodan kernel: [77498.450883] IP: [<ffffffffa039=
5729>] cifs_ioctl+0x39/0x2f0 [cifs]
>=20
> Does the below patch fixes your problem?
>=20
>=20
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH] cifs: fix a NULL pointer dereference in cifs_ioctl()=
 when the fd is bad
>=20
> The commit ba00ba modified cifs_ioctl() to use tcon pointer in cifsFi=
leInfo
> via tlink instead of cifs_sb->tcon. When the file handle is not valid=
 the
> cifsFileInfo->tlink will be NULL. Fix this by getting the tcon pointe=
r by
> calling cifs_sb_master_tcon().
>=20
> Here's a hackish reproducer:
>=20
> #include  <fcntl.h>
> #include  <sys/ioctl.h>
> #include  <sys/stat.h>
> #include  <sys/types.h>
> #include  <unistd.h>
>=20
> #define CIFS_IOC_CHECKUMOUNT    _IO(0xCF, 2)
>=20
> int main  (int argc, char* argv[])
>  {
>     int fd =3D open (argv[1], O_RDWR);
>=20
>     ioctl(fd, CIFS_IOC_CHECKUMOUNT);
>=20
>     close(fd);
>     return 0;
> }
>=20
> This program will cause an oops when called with cifs mount point as =
an
> argument. I have tested the fix with the reproducer and it no longer =
oopses.
>=20
> Reported-by: Kjell Rune <kjella79-eZNTXLQAfP4@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=20
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/ioctl.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 2fa22f2..b8f680a 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -35,10 +35,10 @@ long cifs_ioctl(struct file *filep, unsigned int =
command, unsigned long arg)
>  	struct inode *inode =3D filep->f_dentry->d_inode;
>  	int rc =3D -ENOTTY; /* strange error - but the precedent */
>  	int xid;
> -	struct cifs_sb_info *cifs_sb;
> +	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>  #ifdef CONFIG_CIFS_POSIX
>  	struct cifsFileInfo *pSMBFile =3D filep->private_data;
> -	struct cifsTconInfo *tcon =3D tlink_tcon(pSMBFile->tlink);
> +	struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cifs_sb);
>  	__u64	ExtAttrBits =3D 0;
>  	__u64	ExtAttrMask =3D 0;
>  	__u64   caps =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
> @@ -48,8 +48,6 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
> =20
>  	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
> =20
> -	cifs_sb =3D CIFS_SB(inode->i_sb);
> -
>  	switch (command) {
>  		case CIFS_IOC_CHECKUMOUNT:
>  			cFYI(1, "User unmount attempted");

NAK. This will mean that you're allowing people to do ioctls against
files using other people's credentials. If this is the problem then the
correct fix is to make sure that a cifsFileInfo is allocated during
the open.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
