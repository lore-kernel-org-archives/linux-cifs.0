From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 22/36] fs/cifs: Remove unnecessary casts of private_data
Date: Wed, 14 Jul 2010 21:41:24 -0500
Message-ID: <AANLkTikkXoqO8WsMDSbuzTwxaKeT2N4o-ocV9lzIMoT4@mail.gmail.com>
References: <cover.1278967120.git.joe@perches.com>
	<50f719e6afc5504af06be41c057062f625615a0b.1278967121.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50f719e6afc5504af06be41c057062f625615a0b.1278967121.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Mon, Jul 12, 2010 at 3:50 PM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c =A0| =A0 24 ++++++++++--------------
> =A0fs/cifs/inode.c | =A0 =A04 ++--
> =A0fs/cifs/ioctl.c | =A0 =A03 +--
> =A03 files changed, 13 insertions(+), 18 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 409e4f5..b5fb2a0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -427,7 +427,7 @@ static int cifs_reopen_file(struct file *file, bo=
ol can_flush)
> =A0 =A0 =A0 =A0__u16 netfid;
>
> =A0 =A0 =A0 =A0if (file->private_data)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsFile =3D (struct cifsFileInfo *)fi=
le->private_data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsFile =3D file->private_data;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EBADF;
>
> @@ -565,8 +565,7 @@ int cifs_close(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0int xid, timeout;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 struct cifsFileInfo *pSMBFile =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct cifsFileInfo *)file->private_da=
ta;
> + =A0 =A0 =A0 struct cifsFileInfo *pSMBFile =3D file->private_data;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -641,8 +640,7 @@ int cifs_closedir(struct inode *inode, struct fil=
e *file)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int xid;
> - =A0 =A0 =A0 struct cifsFileInfo *pCFileStruct =3D
> - =A0 =A0 =A0 =A0 =A0 (struct cifsFileInfo *)file->private_data;
> + =A0 =A0 =A0 struct cifsFileInfo *pCFileStruct =3D file->private_dat=
a;
> =A0 =A0 =A0 =A0char *ptmp;
>
> =A0 =A0 =A0 =A0cFYI(1, "Closedir inode =3D 0x%p", inode);
> @@ -863,8 +861,7 @@ int cifs_lock(struct file *file, int cmd, struct =
file_lock *pfLock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0length, pfLock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0posix_lock_type, wait_flag);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsFileInfo *fid =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct cifsFileInfo *)=
file->private_data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsFileInfo *fid =3D file->priv=
ate_data;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (numLock) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBLock(xid=
, tcon, netfid, length,
> @@ -965,7 +962,7 @@ ssize_t cifs_user_write(struct file *file, const =
char __user *write_data,
>
> =A0 =A0 =A0 =A0if (file->private_data =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EBADF;
> - =A0 =A0 =A0 open_file =3D (struct cifsFileInfo *) file->private_dat=
a;
> + =A0 =A0 =A0 open_file =3D file->private_data;
>
> =A0 =A0 =A0 =A0rc =3D generic_write_checks(file, poffset, &write_size=
, 0);
> =A0 =A0 =A0 =A0if (rc)
> @@ -1067,7 +1064,7 @@ static ssize_t cifs_write(struct file *file, co=
nst char *write_data,
>
> =A0 =A0 =A0 =A0if (file->private_data =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EBADF;
> - =A0 =A0 =A0 open_file =3D (struct cifsFileInfo *)file->private_data=
;
> + =A0 =A0 =A0 open_file =3D file->private_data;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -1651,8 +1648,7 @@ int cifs_fsync(struct file *file, int datasync)
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> - =A0 =A0 =A0 struct cifsFileInfo *smbfile =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct cifsFileInfo *)file->private_da=
ta;
> + =A0 =A0 =A0 struct cifsFileInfo *smbfile =3D file->private_data;
> =A0 =A0 =A0 =A0struct inode *inode =3D file->f_path.dentry->d_inode;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -1756,7 +1752,7 @@ ssize_t cifs_user_read(struct file *file, char =
__user *read_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 open_file =3D (struct cifsFileInfo *)file->private_data=
;
> + =A0 =A0 =A0 open_file =3D file->private_data;
>
> =A0 =A0 =A0 =A0if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempting read on write only=
 file instance");
> @@ -1837,7 +1833,7 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 open_file =3D (struct cifsFileInfo *)file->private_data=
;
> + =A0 =A0 =A0 open_file =3D file->private_data;
>
> =A0 =A0 =A0 =A0if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempting read on write only=
 file instance");
> @@ -1968,7 +1964,7 @@ static int cifs_readpages(struct file *file, st=
ruct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 open_file =3D (struct cifsFileInfo *)file->private_data=
;
> + =A0 =A0 =A0 open_file =3D file->private_data;
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> =A0 =A0 =A0 =A0pTcon =3D cifs_sb->tcon;
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 107c84d..ee08248 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -288,7 +288,7 @@ int cifs_get_file_info_unix(struct file *filp)
> =A0 =A0 =A0 =A0struct inode *inode =3D filp->f_path.dentry->d_inode;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D cifs_sb->tcon;
> - =A0 =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *) =
filp->private_data;
> + =A0 =A0 =A0 struct cifsFileInfo *cfile =3D filp->private_data;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0rc =3D CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, =
&find_data);
> @@ -515,7 +515,7 @@ int cifs_get_file_info(struct file *filp)
> =A0 =A0 =A0 =A0struct inode *inode =3D filp->f_path.dentry->d_inode;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D cifs_sb->tcon;
> - =A0 =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *) =
filp->private_data;
> + =A0 =A0 =A0 struct cifsFileInfo *cfile =3D filp->private_data;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0rc =3D CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &fin=
d_data);
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 505926f..9d38a71 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -41,8 +41,7 @@ long cifs_ioctl(struct file *filep, unsigned int co=
mmand, unsigned long arg)
> =A0 =A0 =A0 =A0__u64 =A0 ExtAttrMask =3D 0;
> =A0 =A0 =A0 =A0__u64 =A0 caps;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> - =A0 =A0 =A0 struct cifsFileInfo *pSMBFile =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct cifsFileInfo *)filep->private_d=
ata;
> + =A0 =A0 =A0 struct cifsFileInfo *pSMBFile =3D filep->private_data;
> =A0#endif /* CONFIG_CIFS_POSIX */
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> --
> 1.7.1.337.g6068.dirty
>
>



--=20
Thanks,

Steve
