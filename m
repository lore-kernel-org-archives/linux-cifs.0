From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify cifs_open code
Date: Wed, 8 Dec 2010 23:46:13 +0300
Message-ID: <AANLkTi=5Fixa9piVpqWc5ZmNA0ZeTwRRXsUZQwU=b-9h@mail.gmail.com>
References: <1290696298-5204-1-git-send-email-piastryyy@gmail.com>
	<1290696298-5204-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290696298-5204-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/25 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Make the code more general for use in posix and non-posix open.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 54 +++++++++++++++++++++++-------------------=
------------
> =A01 files changed, 23 insertions(+), 31 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c7d642f..2e21cd1 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -335,6 +335,7 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0struct cifsFileInfo *pCifsFile =3D NULL;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *pCifsInode;
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> + =A0 =A0 =A0 bool posix_open_ok =3D false;
> =A0 =A0 =A0 =A0__u16 netfid;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -373,17 +374,7 @@ int cifs_open(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->=
f_flags, &oplock, &netfid, xid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "posix open su=
cceeded");
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsFile =3D cifs_new_=
fileinfo(netfid, file, tlink,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 oplock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pCifsFile =3D=3D NU=
LL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMB=
Close(xid, tcon, netfid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_fscache_set_inode_=
cookie(inode, file);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_open_ok =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if ((rc =3D=3D -EINVAL) || (rc =
=3D=3D -EOPNOTSUPP)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (tcon->ses->serverN=
OS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "server %s of type %s returned"
> @@ -400,37 +391,38 @@ int cifs_open(struct inode *inode, struct file =
*file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 or DFS errors */
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D cifs_nt_open(full_path, &inode, cifs_sb, tcon, f=
ile->f_flags,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &oplock, &netfid, x=
id);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 if (!posix_open_ok) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_nt_open(full_path, &inode, =
cifs_sb, tcon,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fil=
e->f_flags, &oplock, &netfid, xid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0pCifsFile =3D cifs_new_fileinfo(netfid, file, tlink, o=
plock);
> =A0 =A0 =A0 =A0if (pCifsFile =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClose(xid, tcon, netfid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cifs_fscache_set_inode_cookie(inode, file);
>
> - =A0 =A0 =A0 if (oplock & CIFS_CREATE_ACTION) {
> + =A0 =A0 =A0 if ((oplock & CIFS_CREATE_ACTION) && !posix_open_ok && =
tcon->unix_ext) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* time to set mode which we can not s=
et earlier due to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 problems creating new read-only f=
iles */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->unix_ext) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_unix_set_in=
fo_args args =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0=
 =3D inode->i_mode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .uid =A0=
 =A0=3D NO_CHANGE_64,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .gid =A0=
 =A0=3D NO_CHANGE_64,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ctime =
=A0=3D NO_CHANGE_64,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .atime =
=A0=3D NO_CHANGE_64,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mtime =
=A0=3D NO_CHANGE_64,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .device=
 =3D 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 };
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetPathInfo(=
xid, tcon, full_path, &args,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_unix_set_info_args args =3D=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0 =3D inode->i_=
mode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .uid =A0 =A0=3D NO_CHAN=
GE_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .gid =A0 =A0=3D NO_CHAN=
GE_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ctime =A0=3D NO_CHANGE=
_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .atime =A0=3D NO_CHANGE=
_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mtime =A0=3D NO_CHANGE=
_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .device =3D 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 };
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetPathInfo(xid, tcon, full_=
path, &args,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_sb->local_nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_sb->mnt_cifs_flags &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0}
>
> =A0out:
> --
> 1.7.0.4
>
>

Since I have reviewed patch number 1 ([PATCH 1/2] CIFS: Simplify
non-posix open stuff (try #2)) could you review this one, please?

--=20
Best regards,
Pavel Shilovsky.
