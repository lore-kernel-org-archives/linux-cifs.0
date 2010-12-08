From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify non-posix open stuff (try #2)
Date: Wed, 8 Dec 2010 23:44:08 +0300
Message-ID: <AANLkTimJ6xHKByjqUQRjBZWtuvtfchNLZsJRyMhu+b0w@mail.gmail.com>
References: <1291818480-3681-1-git-send-email-piastryyy@gmail.com>
	<AANLkTi=yZ28Be5HvdrgNcmdTRQ1MKoVyOhMtQiZ9R8WX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=yZ28Be5HvdrgNcmdTRQ1MKoVyOhMtQiZ9R8WX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/8 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Wed, Dec 8, 2010 at 8:28 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>> Delete cifs_open_inode_helper and move non-posix open related things
>> to cifs_nt_open function.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0189 ++++++++++++++++++++++-------------------=
---------------
>> =A01 files changed, 73 insertions(+), 116 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index b857ce5..8f6a084 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -104,53 +104,6 @@ static inline int cifs_get_disposition(unsigned=
 int flags)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return FILE_OPEN;
>> =A0}
>>
>> -static inline int cifs_open_inode_helper(struct inode *inode,
>> - =A0 =A0 =A0 struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INF=
O *buf,
>> - =A0 =A0 =A0 char *full_path, int xid)
>> -{
>> - =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode =3D CIFS_I(inode);
>> - =A0 =A0 =A0 struct timespec temp;
>> - =A0 =A0 =A0 int rc;
>> -
>> - =A0 =A0 =A0 if (pCifsInode->clientCanCacheRead) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we have the inode open somewhere el=
se
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0no need to discard cache data *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto client_can_cache;
>> - =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 /* BB need same check in cifs_create too? */
>> - =A0 =A0 =A0 /* if not oplocked, invalidate inode pages if mtime or=
 file
>> - =A0 =A0 =A0 =A0 =A0size changed */
>> - =A0 =A0 =A0 temp =3D cifs_NTtimeToUnix(buf->LastWriteTime);
>> - =A0 =A0 =A0 if (timespec_equal(&inode->i_mtime, &temp) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(inode->i_size =
=3D=3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)le64_t=
o_cpu(buf->EndOfFile))) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "inode unchanged on server");
>> - =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB no need to lock =
inode until after invalidate
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 since namei code shoul=
d already have it locked? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_a=
nd_wait(inode->i_mapping);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inod=
e->i_mapping, rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "invalidating remote inode sin=
ce open detected it "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"changed");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
>> - =A0 =A0 =A0 }
>> -
>> -client_can_cache:
>> - =A0 =A0 =A0 if (pTcon->unix_ext)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode=
, full_path, inode->i_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid);
>> - =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, ful=
l_path, buf, inode->i_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0xid, NULL);
>> -
>> - =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>> -
>> - =A0 =A0 =A0 return rc;
>> -}
>> -
>> =A0int cifs_posix_open(char *full_path, struct inode **pinode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct super_block *s=
b, int mode, unsigned int f_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *poplock, __u16=
 *pnetfid, int xid)
>> @@ -213,6 +166,76 @@ posix_open_ret:
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>>
>> +static int
>> +cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_i=
nfo *cifs_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0struct cifsTconInfo *tcon, unsigned int f_f=
lags, __u32 *poplock,
>> + =A0 =A0 =A0 =A0 =A0 =A0__u16 *pnetfid, int xid)
>> +{
>> + =A0 =A0 =A0 int rc;
>> + =A0 =A0 =A0 int desiredAccess;
>> + =A0 =A0 =A0 int disposition;
>> + =A0 =A0 =A0 FILE_ALL_INFO *buf;
>> +
>> + =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(f_flags);
>> +
>> +/******************************************************************=
***
>> + * =A0open flag mapping table:
>> + *
>> + * =A0 =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
>> + * =A0 =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
>> + * =A0 =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
>> + * =A0 =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
>> + * =A0 =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
>> + * =A0 =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
>> + * =A0 =A0 none of the above =A0 =A0 FILE_OPEN
>> + *
>> + * =A0 =A0 Note that there is not a direct match between dispositio=
n
>> + * =A0 =A0 FILE_SUPERSEDE (ie create whether or not file exists alt=
hough
>> + * =A0 =A0 O_CREAT | O_TRUNC is similar but truncates the existing
>> + * =A0 =A0 file rather than creating a new file as FILE_SUPERSEDE d=
oes
>> + * =A0 =A0 (which uses the attributes / metadata passed in on open =
call)
>> + *?
>> + *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
>> + *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
>> + *? =A0is irrelevant because largefile support is always used
>> + *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
>> + * =A0 =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investi=
gation
>> + ******************************************************************=
***/
>> +
>> + =A0 =A0 =A0 disposition =3D cifs_get_disposition(f_flags);
>> +
>> + =A0 =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. B=
B */
>> +
>> + =A0 =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>> + =A0 =A0 =A0 if (!buf)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREA=
TE_NOT_DIR, pnetfid, poplock, buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls,=
 cifs_sb->mnt_cifs_flags
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& C=
IFS_MOUNT_MAP_SPECIAL_CHR);
>> + =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_p=
ath, disposition,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE_=
NOT_DIR, pnetfid, poplock, buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, ci=
fs_sb->mnt_cifs_flags
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIFS=
_MOUNT_MAP_SPECIAL_CHR);
>> +
>> + =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 =A0 if (tcon->unix_ext)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode=
, full_path, inode->i_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid);
>> + =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, ful=
l_path, buf, inode->i_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0xid, pnetfid);
>> +
>
> Just a nit-picking, we probably do not expect a non-posix function
> calling a function for unix!
>

If the server broke posix open but still supports unix extensions we
should use unix specific function, I think.

--=20
Best regards,
Pavel Shilovsky.
