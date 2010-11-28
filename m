From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify non-posix open stuff
Date: Sun, 28 Nov 2010 13:16:33 +0300
Message-ID: <AANLkTimLHX5hH5SjaRLMMTFLHb4Tw9OogZEcgmpWcu_4@mail.gmail.com>
References: <1290696298-5204-1-git-send-email-piastryyy@gmail.com>
	<20101127073753.44e1f20b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101127073753.44e1f20b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 25 Nov 2010 17:44:57 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Delete cifs_open_inode_helper and move non-posix open related things
>> to cifs_nt_open function.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsproto.h | =A0 =A04 +
>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0184 +++++++++++++++++++-----------=
---------------------
>> =A02 files changed, 72 insertions(+), 116 deletions(-)
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 6ed59af..09d048c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -113,6 +113,10 @@ extern int cifs_posix_open(char *full_path, str=
uct inode **pinode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct s=
uper_block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int mode=
, unsigned int f_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *p=
oplock, __u16 *pnetfid, int xid);
>> +extern int cifs_nt_open(char *full_path, struct inode **pinode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_=
sb, struct cifsTconInfo *tcon,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int f_flags, __u3=
2 *poplock, __u16 *pnetfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int xid);
>
> If the only place this gets called is in file.c then you can drop the
> above and make the function static.
>
>> =A0void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr=
 *fattr);
>> =A0extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0FILE_UNIX_BASIC_INFO *info,
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index b857ce5..c7d642f 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -104,53 +104,6 @@ static inline int cifs_get_disposition(unsigned=
 int flags)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FILE_OPEN;
>> =A0}
>>
>> -static inline int cifs_open_inode_helper(struct inode *inode,
>> - =A0 =A0 struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *b=
uf,
>> - =A0 =A0 char *full_path, int xid)
>> -{
>> - =A0 =A0 struct cifsInodeInfo *pCifsInode =3D CIFS_I(inode);
>> - =A0 =A0 struct timespec temp;
>> - =A0 =A0 int rc;
>> -
>> - =A0 =A0 if (pCifsInode->clientCanCacheRead) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* we have the inode open somewhere else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0no need to discard cache data */
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto client_can_cache;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* BB need same check in cifs_create too? */
>> - =A0 =A0 /* if not oplocked, invalidate inode pages if mtime or fil=
e
>> - =A0 =A0 =A0 =A0size changed */
>> - =A0 =A0 temp =3D cifs_NTtimeToUnix(buf->LastWriteTime);
>> - =A0 =A0 if (timespec_equal(&inode->i_mtime, &temp) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(inode->i_size =3D=3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)le64_to_cp=
u(buf->EndOfFile))) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "inode unchanged on server");
>> - =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB no need to lock inod=
e until after invalidate
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 since namei code should al=
ready have it locked? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_w=
ait(inode->i_mapping);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i=
_mapping, rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "invalidating remote inode since o=
pen detected it "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"changed");
>> - =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
>> - =A0 =A0 }
>> -
>> -client_can_cache:
>> - =A0 =A0 if (pTcon->unix_ext)
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode, fu=
ll_path, inode->i_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 xid);
>> - =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full_pa=
th, buf, inode->i_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0xid, NULL);
>> -
>> - =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>> -
>> - =A0 =A0 return rc;
>> -}
>> -
>> =A0int cifs_posix_open(char *full_path, struct inode **pinode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct super_block *sb, =
int mode, unsigned int f_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *poplock, __u16 *p=
netfid, int xid)
>> @@ -213,6 +166,71 @@ posix_open_ret:
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +int cifs_nt_open(char *full_path, struct inode **pinode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb, struct ci=
fsTconInfo *tcon,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int f_flags, __u32 *poplock, _=
_u16 *pnetfid, int xid)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 int desiredAccess;
>> + =A0 =A0 int disposition;
>> + =A0 =A0 FILE_ALL_INFO *buf;
>> +
>> + =A0 =A0 desiredAccess =3D cifs_convert_flags(f_flags);
>> +
>> +/******************************************************************=
***
>> + * =A0open flag mapping table:
>> + *
>> + * =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
>> + * =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
>> + * =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
>> + * =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
>> + * =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
>> + * =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
>> + * =A0 none of the above =A0 =A0 FILE_OPEN
>> + *
>> + * =A0 Note that there is not a direct match between disposition
>> + * =A0 FILE_SUPERSEDE (ie create whether or not file exists althoug=
h
>> + * =A0 O_CREAT | O_TRUNC is similar but truncates the existing
>> + * =A0 file rather than creating a new file as FILE_SUPERSEDE does
>> + * =A0 (which uses the attributes / metadata passed in on open call=
)
>> + *?
>> + *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
>> + *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
>> + *? =A0is irrelevant because largefile support is always used
>> + *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
>> + * =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investigati=
on
>> + ******************************************************************=
***/
>> +
>> + =A0 =A0 disposition =3D cifs_get_disposition(f_flags);
>> +
>> + =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. BB */
>> +
>> + =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>> + =A0 =A0 if (!buf)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path, d=
isposition,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREATE_N=
OT_DIR, pnetfid, poplock, buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, cif=
s_sb->mnt_cifs_flags
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CIFS_=
MOUNT_MAP_SPECIAL_CHR);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_path,=
 disposition,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE_NOT_=
DIR, pnetfid, poplock, buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, cifs_s=
b->mnt_cifs_flags
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIFS_MOU=
NT_MAP_SPECIAL_CHR);
>> +
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 rc =3D cifs_get_inode_info(pinode, full_path, buf, (*pinod=
e)->i_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xid, NU=
LL);
>> +
>
> Can "*pinode" ever be NULL here? If not, then it would be clearer to
> pass in a "struct inode *" rather than a "struct inode **". If it can
> be NULL, then the above is going to cause an oops.

I think no, at least because we have "cifs_sb =3D CIFS_SB(inode->i_sb);=
"
at the top of cifs_open code. I will replace it with struct inode *.

>
>> +out:
>> + =A0 =A0 kfree(buf);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0struct cifsFileInfo *
>> =A0cifs_new_fileinfo(__u16 fileHandle, struct file *file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct tcon_link *tlink, __u32 oploc=
k)
>> @@ -317,10 +335,7 @@ int cifs_open(struct inode *inode, struct file =
*file)
>> =A0 =A0 =A0 struct cifsFileInfo *pCifsFile =3D NULL;
>> =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode;
>> =A0 =A0 =A0 char *full_path =3D NULL;
>> - =A0 =A0 int desiredAccess;
>> - =A0 =A0 int disposition;
>> =A0 =A0 =A0 __u16 netfid;
>> - =A0 =A0 FILE_ALL_INFO *buf =3D NULL;
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>>
>> @@ -385,71 +400,9 @@ int cifs_open(struct inode *inode, struct file =
*file)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0or DFS errors */
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 desiredAccess =3D cifs_convert_flags(file->f_flags);
>> -
>> -/******************************************************************=
***
>> - * =A0open flag mapping table:
>> - *
>> - * =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
>> - * =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
>> - * =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
>> - * =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
>> - * =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
>> - * =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
>> - * =A0 none of the above =A0 =A0 FILE_OPEN
>> - *
>> - * =A0 Note that there is not a direct match between disposition
>> - * =A0 FILE_SUPERSEDE (ie create whether or not file exists althoug=
h
>> - * =A0 O_CREAT | O_TRUNC is similar but truncates the existing
>> - * =A0 file rather than creating a new file as FILE_SUPERSEDE does
>> - * =A0 (which uses the attributes / metadata passed in on open call=
)
>> - *?
>> - *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
>> - *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
>> - *? =A0is irrelevant because largefile support is always used
>> - *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
>> - * =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investigati=
on
>> - ******************************************************************=
***/
>> -
>> - =A0 =A0 disposition =3D cifs_get_disposition(file->f_flags);
>> -
>> - =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. BB */
>> -
>> - =A0 =A0 /* Also refresh inode by passing in file_info buf returned=
 by SMBOpen
>> - =A0 =A0 =A0 =A0and calling get_inode_info with returned buf (at le=
ast helps
>> - =A0 =A0 =A0 =A0non-Unix server case) */
>> -
>> - =A0 =A0 /* BB we can not do this if this is the second open of a f=
ile
>> - =A0 =A0 =A0 =A0and the first handle has writebehind data, we might=
 be
>> - =A0 =A0 =A0 =A0able to simply do a filemap_fdatawrite/filemap_fdat=
await first */
>> - =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>> - =A0 =A0 if (!buf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path, d=
isposition,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREATE_N=
OT_DIR, &netfid, &oplock, buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, cif=
s_sb->mnt_cifs_flags
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CIFS_=
MOUNT_MAP_SPECIAL_CHR);
>> - =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no NT SMB support fall int=
o legacy open below */
>> -
>> - =A0 =A0 if (rc =3D=3D -EIO) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* Old server, try legacy style OpenX */
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_path,=
 disposition,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE_NOT_=
DIR, &netfid, &oplock, buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, cifs_s=
b->mnt_cifs_flags
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIFS_MOU=
NT_MAP_SPECIAL_CHR);
>> - =A0 =A0 }
>> - =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_open returned 0x%x", rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 rc =3D cifs_open_inode_helper(inode, tcon, oplock, buf, fu=
ll_path, xid);
>> - =A0 =A0 if (rc !=3D 0)
>> + =A0 =A0 rc =3D cifs_nt_open(full_path, &inode, cifs_sb, tcon, file=
->f_flags,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &oplock, &netfid, xid)=
;
>> + =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> =A0 =A0 =A0 pCifsFile =3D cifs_new_fileinfo(netfid, file, tlink, opl=
ock);
>> @@ -481,7 +434,6 @@ int cifs_open(struct inode *inode, struct file *=
file)
>> =A0 =A0 =A0 }
>>
>> =A0out:
>> - =A0 =A0 kfree(buf);
>> =A0 =A0 =A0 kfree(full_path);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
