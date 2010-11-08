From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Kernel oops: NULL pointer dereference in cifs_ioctl on
 2.6.37-rc1
Date: Mon, 8 Nov 2010 06:30:20 -0500
Message-ID: <20101108063020.3b453eb8@tlielax.poochiereds.net>
References: <484246.91210.qm@web27103.mail.ukl.yahoo.com>
	<20101107211202.3b3468dd@corrin.poochiereds.net>
	<AANLkTikzTztJUP5-zHCKr4nzuG=bSzmZ+ga7dU0r3QPU@mail.gmail.com>
	<4CD7B637.1070004@suse.de>
	<20101108061227.051706ff@tlielax.poochiereds.net>
	<4CD7DD1E.3030601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD7DD1E.3030601-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 08 Nov 2010 16:51:02 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 11/08/2010 04:42 PM, Jeff Layton wrote:
> > On Mon, 08 Nov 2010 14:05:03 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >=20
> >> On 11/08/2010 10:21 AM, Steve French wrote:
> >>
> >>> On Sun, Nov 7, 2010 at 8:12 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> >>>> On Sun, 7 Nov 2010 16:44:46 +0000 (GMT)
> >>>> Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org> wrote:
> >>>>
> >>>>> After upgrading from 2.6.36 for other reasons, starting certain=
 apps like wine utorrent.exe will cause a kernel oops. I run the x86_64=
 version of Ubuntu 10.10 with various modified packages all around and =
the 2.6.37-rc1 kernel from the kernel PPA team. I experienced the same =
with a kernel I tried compiling myself too.
> >>>>>
> >>>>> Nov =EF=BF=BD7 17:25:50 wodan kernel: [77498.450787] BUG: unabl=
e to handle kernel NULL pointer dereference at 0000000000000040
> >>>>> Nov =EF=BF=BD7 17:25:50 wodan kernel: [77498.450883] IP: [<ffff=
ffffa0395729>] cifs_ioctl+0x39/0x2f0 [cifs]
> >>
> >> Does the below patch fixes your problem?
> >>
> >>
> >> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> Subject: [PATCH] cifs: fix a NULL pointer dereference in cifs_ioct=
l() when the fd is bad
> >>
> >> The commit ba00ba modified cifs_ioctl() to use tcon pointer in cif=
sFileInfo
> >> via tlink instead of cifs_sb->tcon. When the file handle is not va=
lid the
> >> cifsFileInfo->tlink will be NULL. Fix this by getting the tcon poi=
nter by
> >> calling cifs_sb_master_tcon().
> >>
> >> Here's a hackish reproducer:
> >>
> >> #include  <fcntl.h>
> >> #include  <sys/ioctl.h>
> >> #include  <sys/stat.h>
> >> #include  <sys/types.h>
> >> #include  <unistd.h>
> >>
> >> #define CIFS_IOC_CHECKUMOUNT    _IO(0xCF, 2)
> >>
> >> int main  (int argc, char* argv[])
> >>  {
> >>     int fd =3D open (argv[1], O_RDWR);
> >>
> >>     ioctl(fd, CIFS_IOC_CHECKUMOUNT);
> >>
> >>     close(fd);
> >>     return 0;
> >> }
> >>
> >> This program will cause an oops when called with cifs mount point =
as an
> >> argument. I have tested the fix with the reproducer and it no long=
er oopses.
> >>
> >> Reported-by: Kjell Rune <kjella79-eZNTXLQAfP4@public.gmane.org>
> >> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=20
> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> ---
> >>  fs/cifs/ioctl.c |    6 ++----
> >>  1 files changed, 2 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> >> index 2fa22f2..b8f680a 100644
> >> --- a/fs/cifs/ioctl.c
> >> +++ b/fs/cifs/ioctl.c
> >> @@ -35,10 +35,10 @@ long cifs_ioctl(struct file *filep, unsigned i=
nt command, unsigned long arg)
> >>  	struct inode *inode =3D filep->f_dentry->d_inode;
> >>  	int rc =3D -ENOTTY; /* strange error - but the precedent */
> >>  	int xid;
> >> -	struct cifs_sb_info *cifs_sb;
> >> +	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> >>  #ifdef CONFIG_CIFS_POSIX
> >>  	struct cifsFileInfo *pSMBFile =3D filep->private_data;
> >> -	struct cifsTconInfo *tcon =3D tlink_tcon(pSMBFile->tlink);
> >> +	struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cifs_sb);
> >>  	__u64	ExtAttrBits =3D 0;
> >>  	__u64	ExtAttrMask =3D 0;
> >>  	__u64   caps =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
> >> @@ -48,8 +48,6 @@ long cifs_ioctl(struct file *filep, unsigned int=
 command, unsigned long arg)
> >> =20
> >>  	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
> >> =20
> >> -	cifs_sb =3D CIFS_SB(inode->i_sb);
> >> -
> >>  	switch (command) {
> >>  		case CIFS_IOC_CHECKUMOUNT:
> >>  			cFYI(1, "User unmount attempted");
> >=20
> > NAK. This will mean that you're allowing people to do ioctls agains=
t
>=20
> I missed this.. though I was not quite sure about this patch..
>=20
> > files using other people's credentials. If this is the problem then=
 the
>=20
> I'm sure the problem is pSMBFile->tlink is NULL. And this is because
> open() fails and the test program didn't check for the error and
> continues using the return value (in this case -1 which will be
> UNSIGNED_INT_MAX) in the ioctl. Since the file is actually not open,
> cifs_new_fileinfo() won't have a chance to setup pSMBFile->tlink prop=
erly.
>=20

That doesn't sound right. The VFS shouldn't allow an ioctl on an
invalid file descriptor...

It seems more likely that pSMBFile is actually NULL here. cifs doesn't
have f_op->open routine for directories, so that's entirely handled at
the VFS layer. The right fix is probably to add one, and make sure that
filp->private_data is appropriately populated on the open call for
directories.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
