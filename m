From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify non-posix open stuff (try #2)
Date: Wed, 8 Dec 2010 11:39:26 -0600
Message-ID: <AANLkTi=yZ28Be5HvdrgNcmdTRQ1MKoVyOhMtQiZ9R8WX@mail.gmail.com>
References: <1291818480-3681-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291818480-3681-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 8, 2010 at 8:28 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Delete cifs_open_inode_helper and move non-posix open related things
> to cifs_nt_open function.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0189 ++++++++++++++++++++++--------------------=
--------------
> =A01 files changed, 73 insertions(+), 116 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b857ce5..8f6a084 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -104,53 +104,6 @@ static inline int cifs_get_disposition(unsigned =
int flags)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return FILE_OPEN;
> =A0}
>
> -static inline int cifs_open_inode_helper(struct inode *inode,
> - =A0 =A0 =A0 struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO=
 *buf,
> - =A0 =A0 =A0 char *full_path, int xid)
> -{
> - =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode =3D CIFS_I(inode);
> - =A0 =A0 =A0 struct timespec temp;
> - =A0 =A0 =A0 int rc;
> -
> - =A0 =A0 =A0 if (pCifsInode->clientCanCacheRead) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we have the inode open somewhere els=
e
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0no need to discard cache data */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto client_can_cache;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* BB need same check in cifs_create too? */
> - =A0 =A0 =A0 /* if not oplocked, invalidate inode pages if mtime or =
file
> - =A0 =A0 =A0 =A0 =A0size changed */
> - =A0 =A0 =A0 temp =3D cifs_NTtimeToUnix(buf->LastWriteTime);
> - =A0 =A0 =A0 if (timespec_equal(&inode->i_mtime, &temp) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(inode->i_size =3D=
=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)le64_to=
_cpu(buf->EndOfFile))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "inode unchanged on server");
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB no need to lock i=
node until after invalidate
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 since namei code should=
 already have it locked? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_an=
d_wait(inode->i_mapping);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode=
->i_mapping, rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "invalidating remote inode sinc=
e open detected it "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"changed");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
> - =A0 =A0 =A0 }
> -
> -client_can_cache:
> - =A0 =A0 =A0 if (pTcon->unix_ext)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode,=
 full_path, inode->i_sb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full=
_path, buf, inode->i_sb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0xid, NULL);
> -
> - =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
> -
> - =A0 =A0 =A0 return rc;
> -}
> -
> =A0int cifs_posix_open(char *full_path, struct inode **pinode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct super_block *sb=
, int mode, unsigned int f_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *poplock, __u16 =
*pnetfid, int xid)
> @@ -213,6 +166,76 @@ posix_open_ret:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static int
> +cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_in=
fo *cifs_sb,
> + =A0 =A0 =A0 =A0 =A0 =A0struct cifsTconInfo *tcon, unsigned int f_fl=
ags, __u32 *poplock,
> + =A0 =A0 =A0 =A0 =A0 =A0__u16 *pnetfid, int xid)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int desiredAccess;
> + =A0 =A0 =A0 int disposition;
> + =A0 =A0 =A0 FILE_ALL_INFO *buf;
> +
> + =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(f_flags);
> +
> +/*******************************************************************=
**
> + * =A0open flag mapping table:
> + *
> + * =A0 =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
> + * =A0 =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
> + * =A0 =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
> + * =A0 =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
> + * =A0 =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
> + * =A0 =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
> + * =A0 =A0 none of the above =A0 =A0 FILE_OPEN
> + *
> + * =A0 =A0 Note that there is not a direct match between disposition
> + * =A0 =A0 FILE_SUPERSEDE (ie create whether or not file exists alth=
ough
> + * =A0 =A0 O_CREAT | O_TRUNC is similar but truncates the existing
> + * =A0 =A0 file rather than creating a new file as FILE_SUPERSEDE do=
es
> + * =A0 =A0 (which uses the attributes / metadata passed in on open c=
all)
> + *?
> + *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
> + *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
> + *? =A0is irrelevant because largefile support is always used
> + *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
> + * =A0 =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investig=
ation
> + *******************************************************************=
**/
> +
> + =A0 =A0 =A0 disposition =3D cifs_get_disposition(f_flags);
> +
> + =A0 =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. BB=
 */
> +
> + =A0 =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
> + =A0 =A0 =A0 if (!buf)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path=
, disposition,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREAT=
E_NOT_DIR, pnetfid, poplock, buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, =
cifs_sb->mnt_cifs_flags
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CI=
=46S_MOUNT_MAP_SPECIAL_CHR);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_pa=
th, disposition,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE_N=
OT_DIR, pnetfid, poplock, buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, cif=
s_sb->mnt_cifs_flags
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIFS_=
MOUNT_MAP_SPECIAL_CHR);
> +
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 if (tcon->unix_ext)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode,=
 full_path, inode->i_sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full=
_path, buf, inode->i_sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0xid, pnetfid);
> +

Just a nit-picking, we probably do not expect a non-posix function
calling a function for unix!

> +out:
> + =A0 =A0 =A0 kfree(buf);
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0struct cifsFileInfo *
> =A0cifs_new_fileinfo(__u16 fileHandle, struct file *file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct tcon_link *tlink, __u32 opl=
ock)
> @@ -317,10 +340,7 @@ int cifs_open(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0struct cifsFileInfo *pCifsFile =3D NULL;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *pCifsInode;
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> - =A0 =A0 =A0 int desiredAccess;
> - =A0 =A0 =A0 int disposition;
> =A0 =A0 =A0 =A0__u16 netfid;
> - =A0 =A0 =A0 FILE_ALL_INFO *buf =3D NULL;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -385,71 +405,9 @@ int cifs_open(struct inode *inode, struct file *=
file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 or DFS errors */
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(file->f_flags);
> -
> -/*******************************************************************=
**
> - * =A0open flag mapping table:
> - *
> - * =A0 =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
> - * =A0 =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
> - * =A0 =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
> - * =A0 =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
> - * =A0 =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
> - * =A0 =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
> - * =A0 =A0 none of the above =A0 =A0 FILE_OPEN
> - *
> - * =A0 =A0 Note that there is not a direct match between disposition
> - * =A0 =A0 FILE_SUPERSEDE (ie create whether or not file exists alth=
ough
> - * =A0 =A0 O_CREAT | O_TRUNC is similar but truncates the existing
> - * =A0 =A0 file rather than creating a new file as FILE_SUPERSEDE do=
es
> - * =A0 =A0 (which uses the attributes / metadata passed in on open c=
all)
> - *?
> - *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
> - *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
> - *? =A0is irrelevant because largefile support is always used
> - *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
> - * =A0 =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investig=
ation
> - *******************************************************************=
**/
> -
> - =A0 =A0 =A0 disposition =3D cifs_get_disposition(file->f_flags);
> -
> - =A0 =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. BB=
 */
> -
> - =A0 =A0 =A0 /* Also refresh inode by passing in file_info buf retur=
ned by SMBOpen
> - =A0 =A0 =A0 =A0 =A0and calling get_inode_info with returned buf (at=
 least helps
> - =A0 =A0 =A0 =A0 =A0non-Unix server case) */
> -
> - =A0 =A0 =A0 /* BB we can not do this if this is the second open of =
a file
> - =A0 =A0 =A0 =A0 =A0and the first handle has writebehind data, we mi=
ght be
> - =A0 =A0 =A0 =A0 =A0able to simply do a filemap_fdatawrite/filemap_f=
datawait first */
> - =A0 =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
> - =A0 =A0 =A0 if (!buf) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path=
, disposition,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREAT=
E_NOT_DIR, &netfid, &oplock, buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, =
cifs_sb->mnt_cifs_flags
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CI=
=46S_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no NT SMB support fall =
into legacy open below */
> -
> - =A0 =A0 =A0 if (rc =3D=3D -EIO) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Old server, try legacy style OpenX *=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_pa=
th, disposition,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE_N=
OT_DIR, &netfid, &oplock, buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, cif=
s_sb->mnt_cifs_flags
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIFS_=
MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_open returned 0x%x", rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 rc =3D cifs_open_inode_helper(inode, tcon, oplock, buf,=
 full_path, xid);
> - =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 rc =3D cifs_nt_open(full_path, inode, cifs_sb, tcon, fi=
le->f_flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &oplock, &netfid, x=
id);
> + =A0 =A0 =A0 if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> =A0 =A0 =A0 =A0pCifsFile =3D cifs_new_fileinfo(netfid, file, tlink, o=
plock);
> @@ -481,7 +439,6 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0}
>
> =A0out:
> - =A0 =A0 =A0 kfree(buf);
> =A0 =A0 =A0 =A0kfree(full_path);
> =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0cifs_put_tlink(tlink);
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
