From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify non-posix open stuff
Date: Wed, 8 Dec 2010 17:20:00 +0300
Message-ID: <AANLkTikn=D47tCf+V48EGY7iR8pfkUb-H7Pk9tpsdbLq@mail.gmail.com>
References: <1290696298-5204-1-git-send-email-piastryyy@gmail.com>
	<AANLkTimd-f-X4Y6QZOOKZyg4mDhYezyRuyW_1j6ffZbP@mail.gmail.com>
	<AANLkTiknMpTb1CEVrBA7mg1b0onK_r+ATwtZhP+NmMht@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiknMpTb1CEVrBA7mg1b0onK_r+ATwtZhP+NmMht-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/8 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Sat, Nov 27, 2010 at 8:49 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Nov 25, 2010 at 8:44 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>> Delete cifs_open_inode_helper and move non-posix open related thing=
s
>>> to cifs_nt_open function.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifsproto.h | =A0 =A04 +
>>> =A0fs/cifs/file.c =A0 =A0 =A0| =A0184 +++++++++++++++++++----------=
----------------------
>>> =A02 files changed, 72 insertions(+), 116 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>>> index 6ed59af..09d048c 100644
>>> --- a/fs/cifs/cifsproto.h
>>> +++ b/fs/cifs/cifsproto.h
>>> @@ -113,6 +113,10 @@ extern int cifs_posix_open(char *full_path, st=
ruct inode **pinode,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct super_block *sb,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
mode, unsigned int f_flags,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u3=
2 *poplock, __u16 *pnetfid, int xid);
>>> +extern int cifs_nt_open(char *full_path, struct inode **pinode,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *=
cifs_sb, struct cifsTconInfo *tcon,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int f_flags,=
 __u32 *poplock, __u16 *pnetfid,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int xid);
>>> =A0void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fatt=
r *fattr);
>>> =A0extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 FILE_UNIX_BASIC_INFO *info,
>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>>> index b857ce5..c7d642f 100644
>>> --- a/fs/cifs/file.c
>>> +++ b/fs/cifs/file.c
>>> @@ -104,53 +104,6 @@ static inline int cifs_get_disposition(unsigne=
d int flags)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return FILE_OPEN;
>>> =A0}
>>>
>>> -static inline int cifs_open_inode_helper(struct inode *inode,
>>> - =A0 =A0 =A0 struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_IN=
=46O *buf,
>>> - =A0 =A0 =A0 char *full_path, int xid)
>>> -{
>>> - =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode =3D CIFS_I(inode);
>>> - =A0 =A0 =A0 struct timespec temp;
>>> - =A0 =A0 =A0 int rc;
>>> -
>>> - =A0 =A0 =A0 if (pCifsInode->clientCanCacheRead) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we have the inode open somewhere e=
lse
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0no need to discard cache data =
*/
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto client_can_cache;
>>> - =A0 =A0 =A0 }
>>> -
>>> - =A0 =A0 =A0 /* BB need same check in cifs_create too? */
>>> - =A0 =A0 =A0 /* if not oplocked, invalidate inode pages if mtime o=
r file
>>> - =A0 =A0 =A0 =A0 =A0size changed */
>>> - =A0 =A0 =A0 temp =3D cifs_NTtimeToUnix(buf->LastWriteTime);
>>> - =A0 =A0 =A0 if (timespec_equal(&inode->i_mtime, &temp) &&
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(inode->i_size=
 =3D=3D
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (loff_t)le64_=
to_cpu(buf->EndOfFile))) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "inode unchanged on server");
>>> - =A0 =A0 =A0 } else {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB no need to lock=
 inode until after invalidate
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 since namei code shou=
ld already have it locked? */
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_=
and_wait(inode->i_mapping);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(ino=
de->i_mapping, rc);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "invalidating remote inode si=
nce open detected it "
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"changed");
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
>>> - =A0 =A0 =A0 }
>>> -
>>> -client_can_cache:
>>> - =A0 =A0 =A0 if (pTcon->unix_ext)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inod=
e, full_path, inode->i_sb,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid);
>>> - =A0 =A0 =A0 else
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, fu=
ll_path, buf, inode->i_sb,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0xid, NULL);
>>> -
>>> - =A0 =A0 =A0 cifs_set_oplock_level(pCifsInode, oplock);
>>> -
>>> - =A0 =A0 =A0 return rc;
>>> -}
>>> -
>>> =A0int cifs_posix_open(char *full_path, struct inode **pinode,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct super_block *=
sb, int mode, unsigned int f_flags,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *poplock, __u1=
6 *pnetfid, int xid)
>>> @@ -213,6 +166,71 @@ posix_open_ret:
>>> =A0 =A0 =A0 =A0return rc;
>>> =A0}
>>>
>>> +int cifs_nt_open(char *full_path, struct inode **pinode,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb, stru=
ct cifsTconInfo *tcon,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int f_flags, __u32 *poplo=
ck, __u16 *pnetfid, int xid)
>>> +{
>>> + =A0 =A0 =A0 int rc;
>>> + =A0 =A0 =A0 int desiredAccess;
>>> + =A0 =A0 =A0 int disposition;
>>> + =A0 =A0 =A0 FILE_ALL_INFO *buf;
>>> +
>>> + =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(f_flags);
>>> +
>>> +/*****************************************************************=
****
>>> + * =A0open flag mapping table:
>>> + *
>>> + * =A0 =A0 POSIX Flag =A0 =A0 =A0 =A0 =A0 =A0CIFS Disposition
>>> + * =A0 =A0 ---------- =A0 =A0 =A0 =A0 =A0 =A0----------------
>>> + * =A0 =A0 O_CREAT =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OPEN_IF
>>> + * =A0 =A0 O_CREAT | O_EXCL =A0 =A0 =A0FILE_CREATE
>>> + * =A0 =A0 O_CREAT | O_TRUNC =A0 =A0 FILE_OVERWRITE_IF
>>> + * =A0 =A0 O_TRUNC =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_OVERWRITE
>>> + * =A0 =A0 none of the above =A0 =A0 FILE_OPEN
>>> + *
>>> + * =A0 =A0 Note that there is not a direct match between dispositi=
on
>>> + * =A0 =A0 FILE_SUPERSEDE (ie create whether or not file exists al=
though
>>> + * =A0 =A0 O_CREAT | O_TRUNC is similar but truncates the existing
>>> + * =A0 =A0 file rather than creating a new file as FILE_SUPERSEDE =
does
>>> + * =A0 =A0 (which uses the attributes / metadata passed in on open=
 call)
>>> + *?
>>> + *? =A0O_SYNC is a reasonable match to CIFS writethrough flag
>>> + *? =A0and the read write flags match reasonably. =A0O_LARGEFILE
>>> + *? =A0is irrelevant because largefile support is always used
>>> + *? =A0by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
>>> + * =A0 =A0 =A0O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further invest=
igation
>>> + *****************************************************************=
****/
>>> +
>>> + =A0 =A0 =A0 disposition =3D cifs_get_disposition(f_flags);
>>> +
>>> + =A0 =A0 =A0 /* BB pass O_SYNC flag through on file attributes .. =
BB */
>>> +
>>> + =A0 =A0 =A0 buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>>> + =A0 =A0 =A0 if (!buf)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>> +
>>> + =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_pa=
th, disposition,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CRE=
ATE_NOT_DIR, pnetfid, poplock, buf,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls=
, cifs_sb->mnt_cifs_flags
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& =
CIFS_MOUNT_MAP_SPECIAL_CHR);
>>> + =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBLegacyOpen(xid, tcon, full_=
path, disposition,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE=
_NOT_DIR, pnetfid, poplock, buf,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIF=
S_MOUNT_MAP_SPECIAL_CHR);
>>> +
>>> + =A0 =A0 =A0 if (rc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>> +
>>> + =A0 =A0 =A0 rc =3D cifs_get_inode_info(pinode, full_path, buf, (*=
pinode)->i_sb,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xi=
d, NULL);
>>
>> I think netfid should be passed to cifs_get_inode_info.
>>
>
> Pavel, were you planning on re-posting this patch?
> Would like to get this specific code change in.
> I can post a separate patch with just this change to the
> existing functions if it would be a while before could
> you re-spin your patch.
>


Yes, I have right variant of this patch. The reason that I don't post
it yet - is I want to finish with strict cache io before posting any
other patches. But if it needs to be posted now, I am ready to do it
:)

--=20
Best regards,
Pavel Shilovsky.
