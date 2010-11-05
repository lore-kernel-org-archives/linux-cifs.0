From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: make cifs_set_oplock_level() take a cifsInodeInfo pointer
Date: Fri, 5 Nov 2010 07:55:33 +0300
Message-ID: <AANLkTinTyu61Da=q0EGjhUeTW0fPpN7rNrSuk5_-HsP+@mail.gmail.com>
References: <1288769214-11113-1-git-send-email-sjayaraman@suse.de>
	<1288771137-5458-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288771137-5458-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/3 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> All the callers already have a pointer to struct cifsInodeInfo. Use i=
t.
>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A03 +--
> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A08 ++++----
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 16 +++++++++-------
> =A04 files changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 38526a6..9c37897 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -321,8 +321,7 @@ cifs_alloc_inode(struct super_block *sb)
> =A0 =A0 =A0 =A0/* Until the file is open and we have gotten oplock
> =A0 =A0 =A0 =A0info back from the server, can not assume caching of
> =A0 =A0 =A0 =A0file data or metadata */
> - =A0 =A0 =A0 cifs_inode->clientCanCacheRead =3D false;
> - =A0 =A0 =A0 cifs_inode->clientCanCacheAll =3D false;
> + =A0 =A0 =A0 cifs_set_oplock_level(cifs_inode, 0);
> =A0 =A0 =A0 =A0cifs_inode->delete_pending =3D false;
> =A0 =A0 =A0 =A0cifs_inode->invalid_mapping =3D false;
> =A0 =A0 =A0 =A0cifs_inode->vfs_inode.i_blkbits =3D 14; =A0/* 2**14 =3D=
 CIFS_MAX_MSGSIZE */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 7f050f4..7ed69b6 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -104,7 +104,7 @@ extern struct timespec cifs_NTtimeToUnix(__le64 u=
tc_nanoseconds_since_1601);
> =A0extern u64 cifs_UnixTimeToNT(struct timespec);
> =A0extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_ti=
me,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0int offset);
> -extern void cifs_set_oplock_level(struct inode *inode, __u32 oplock)=
;
> +extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u3=
2 oplock);
>
> =A0extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 file *file, struct tcon_link *tlink,
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 71185d1..a0d13c7 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -146,7 +146,7 @@ client_can_cache:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info(&inode, ful=
l_path, buf, inode->i_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 xid, NULL);
>
> - =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
> + =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -248,7 +248,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *=
file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&pCifsFile->flist, &pCif=
sInode->openFileList);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_file_list_lock);
>
> - =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
> + =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>
> =A0 =A0 =A0 =A0file->private_data =3D pCifsFile;
> =A0 =A0 =A0 =A0return pCifsFile;
> @@ -279,7 +279,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile)
> =A0 =A0 =A0 =A0if (list_empty(&cifsi->openFileList)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "closing last open instance fo=
r inode %p",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file->dentry->d_i=
node);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_oplock_level(inode, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_oplock_level(cifsi, 0);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_file_list_lock);
>
> @@ -611,7 +611,7 @@ reopen_success:
> =A0 =A0 =A0 =A0 =A0 =A0 we can not go to the server to get the new in=
od
> =A0 =A0 =A0 =A0 =A0 =A0 info */
>
> - =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
> + =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>
> =A0 =A0 =A0 =A0cifs_relock_file(pCifsFile);
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index d3b9dde..43f1028 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -570,7 +570,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1=
, "file id match, oplock break");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsI=
node =3D CIFS_I(netfile->dentry->d_inode);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_se=
t_oplock_level(netfile->dentry->d_inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_se=
t_oplock_level(pCifsInode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->OplockLevel);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * cif=
s_oplock_break_put() can't be called
> @@ -722,18 +722,20 @@ cifs_autodisable_serverino(struct cifs_sb_info =
*cifs_sb)
> =A0 =A0 =A0 =A0}
> =A0}
>
> -void cifs_set_oplock_level(struct inode *inode, __u32 oplock)
> +void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oploc=
k)
> =A0{
> - =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> + =A0 =A0 =A0 oplock &=3D 0xF;
>
> - =A0 =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> + =A0 =A0 =A0 if (oplock =3D=3D OPLOCK_EXCLUSIVE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheAll =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheRead =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on in=
ode %p", inode);
> - =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on in=
ode %p",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&cinode->vfs_inode);
> + =A0 =A0 =A0 } else if (oplock =3D=3D OPLOCK_READ) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheAll =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheRead =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock granted on ino=
de %p", inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock granted on ino=
de %p",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cinode->vfs_inode);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheAll =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cinode->clientCanCacheRead =3D false;
> --
> 1.7.2.3
>
>

What's about this patch?


--=20
Best regards,
Pavel Shilovsky.
