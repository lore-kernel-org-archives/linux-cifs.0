From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Add cifs_set_oplock_level
Date: Tue, 2 Nov 2010 13:41:49 -0500
Message-ID: <AANLkTimpaVMTPm_kmqCby2rV-ytxh_7+qK1N=QiOJkPL@mail.gmail.com>
References: <AANLkTin1ZFcZoC3A4iRrWaFpHghdG2hkbyEopQnJpA2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin1ZFcZoC3A4iRrWaFpHghdG2hkbyEopQnJpA2f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The below patch looked fine - but showed up line wrapped in two places
so had to hand edit a few lines to get it to merge.

On Tue, Nov 2, 2010 at 4:00 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Simplify many places when we need to set oplock level on an inode.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A01 +
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 38 +++++++++----------------------=
-------
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 23 ++++++++++++++++++++---
> =A03 files changed, 30 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index edb6d90..7f050f4 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -104,6 +104,7 @@ extern struct timespec cifs_NTtimeToUnix(__le64
> utc_nanoseconds_since_1601);
> =A0extern u64 cifs_UnixTimeToNT(struct timespec);
> =A0extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_ti=
me,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0int offset);
> +extern void cifs_set_oplock_level(struct inode *inode, __u32 oplock)=
;
>
> =A0extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 file *file, struct tcon_link *tlink,
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5d06eb3..a566f15 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -146,12 +146,7 @@ client_can_cache:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info(&inode, ful=
l_path, buf, inode->i_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 xid, NULL);
>
> - =A0 =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on in=
ode %p", inode);
> - =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> + =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -253,12 +248,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file =
*file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&pCifsFile->flist, &pCif=
sInode->openFileList);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_file_list_lock);
>
> - =A0 =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock inode %p", in=
ode);
> - =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> + =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
>
> =A0 =A0 =A0 =A0file->private_data =3D pCifsFile;
> =A0 =A0 =A0 =A0return pCifsFile;
> @@ -271,8 +261,10 @@ cifs_new_fileinfo(__u16 fileHandle, struct file =
*file,
> =A0*/
> =A0void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> =A0{
> + =A0 =A0 =A0 struct inode *inode =3D cifs_file->dentry->d_inode;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D tlink_tcon(cifs_file->tl=
ink);
> - =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(cifs_file->dentr=
y->d_inode);
> + =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct cifsLockInfo *li, *tmp;
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
> @@ -288,8 +280,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile)
> =A0 =A0 =A0 =A0if (list_empty(&cifsi->openFileList)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "closing last open instance fo=
r inode %p",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file->dentry->d_i=
node);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->clientCanCacheRead =3D false;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsi->clientCanCacheAll =A0=3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_oplock_level(inode, 0);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_file_list_lock);
>
> @@ -607,8 +598,6 @@ reopen_success:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D filemap_write_and_wait(inode->i=
_mapping);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mapping_set_error(inode->i_mapping, rc=
);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D fals=
e;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (tcon->unix_ext)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_=
info_unix(&inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0full_p=
ath, inode->i_sb, xid);
> @@ -622,18 +611,9 @@ reopen_success:
> =A0 =A0 =A0 =A0 =A0 =A0 invalidate the current end of file on the ser=
ver
> =A0 =A0 =A0 =A0 =A0 =A0 we can not go to the server to get the new in=
od
> =A0 =A0 =A0 =A0 =A0 =A0 info */
> - =A0 =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D true;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on in=
ode %p",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsFile->dentry->d=
_inode);
> - =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D true=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false=
;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheRead =3D fals=
e;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsInode->clientCanCacheAll =3D false=
;
> - =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 cifs_set_oplock_level(inode, oplock);
> +
> =A0 =A0 =A0 =A0cifs_relock_file(pCifsFile);
>
> =A0reopen_error_exit:
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index c4e296f..d3b9dde 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -569,10 +569,9 @@ is_valid_oplock_break(struct smb_hdr *buf, struc=
t
> TCP_Server_Info *srv)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1=
, "file id match, oplock break");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pCifsI=
node =3D CIFS_I(netfile->dentry->d_inode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pCifsIn=
ode->clientCanCacheAll =3D false;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pSM=
B->OplockLevel =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pCifsInode->clientCanCacheRead =3D false;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_se=
t_oplock_level(netfile->dentry->d_inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->OplockLevel);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * cif=
s_oplock_break_put() can't be called
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * fro=
m here. =A0Get reference after queueing
> @@ -722,3 +721,21 @@ cifs_autodisable_serverino(struct cifs_sb_info *=
cifs_sb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb_master_tc=
on(cifs_sb)->treeName);
> =A0 =A0 =A0 =A0}
> =A0}
> +
> +void cifs_set_oplock_level(struct inode *inode, __u32 oplock)
> +{
> + =A0 =A0 =A0 struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> +
> + =A0 =A0 =A0 if ((oplock & 0xF) =3D=3D OPLOCK_EXCLUSIVE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheAll =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheRead =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Exclusive Oplock granted on in=
ode %p", inode);
> + =A0 =A0 =A0 } else if ((oplock & 0xF) =3D=3D OPLOCK_READ) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheAll =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheRead =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Level II Oplock granted on ino=
de %p", inode);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheAll =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cinode->clientCanCacheRead =3D false;
> + =A0 =A0 =A0 }
> +}
> --
> 1.7.2.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
