From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
Date: Fri, 25 Mar 2011 11:28:40 +0300
Message-ID: <AANLkTik1rofX+kHTjyxPeW5oqahBo_x7uPbUh6ok2Vfx@mail.gmail.com>
References: <1300977587-8218-1-git-send-email-piastry@etersoft.ru>
	<20110324171536.36fbc94f@tlielax.poochiereds.net>
	<AANLkTinnQXjDfJ6yghEmKarXNFqbwk-YVc4ew9coUiii@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinnQXjDfJ6yghEmKarXNFqbwk-YVc4ew9coUiii-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/25 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> 2011/3/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> On Thu, 24 Mar 2011 17:39:47 +0300
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>>> Base of approach for splitting all calls that uses cifs_invalidate_=
mapping
>>> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
>>> 1) aware about -EBUSY error code and report it back (cifs_d_revalid=
ate,
>>> cifs_strict_fsync, cifs_file_strict_mmap);
>>> 2) don't do it (cifs_getattrs, cifs_lseek).
>>>
>>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifsfs.c | =A0 =A08 +++++++-
>>> =A0fs/cifs/cifsfs.h | =A0 =A02 +-
>>> =A0fs/cifs/file.c =A0 | =A0 18 ++++++++++++++----
>>> =A0fs/cifs/inode.c =A0| =A0 30 ++++++++++++++++++------------
>>> =A04 files changed, 40 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>>> index de49fbb..b275d76 100644
>>> --- a/fs/cifs/cifsfs.c
>>> +++ b/fs/cifs/cifsfs.c
>>> @@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *file, l=
off_t offset, int origin)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(file->f_path.dentry->d_inode)->t=
ime =3D 0;
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(file);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* We only need to get right file lengt=
h and don't need to
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* aware about busy pages (-EBUSY error=
 code).
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval =3D=3D -EBUSY)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D 0;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (retval < 0)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval;
>>> =A0 =A0 =A0 }
>>> =A0 =A0 =A0 return generic_file_llseek_unlocked(file, offset, origi=
n);
>>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>>> index bb64313..f4391ff 100644
>>> --- a/fs/cifs/cifsfs.h
>>> +++ b/fs/cifs/cifsfs.h
>>> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct den=
try *, struct inode *,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *);
>>> =A0extern int cifs_revalidate_file(struct file *filp);
>>> =A0extern int cifs_revalidate_dentry(struct dentry *);
>>> -extern void cifs_invalidate_mapping(struct inode *inode);
>>> +extern int cifs_invalidate_mapping(struct inode *inode);
>>> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, stru=
ct kstat *);
>>> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>>>
>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>>> index b9731c9..d99cf48 100644
>>> --- a/fs/cifs/file.c
>>> +++ b/fs/cifs/file.c
>>> @@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file, int=
 datasync)
>>> =A0 =A0 =A0 cFYI(1, "Sync file - name: %s datasync: 0x%x",
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 file->f_path.dentry->d_name.name, datas=
ync);
>>>
>>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 }
>>>
>>
>> Hmm...this put us in danger of reporting writeback errors twice? Not=
e
>> that cifs_invalidate_mapping resets the error on the mapping if
>> writeback fails. So imagine:
>>
>> t1: do the regular filemap_write_and_wait in vfs_fsync
>> t2: another thread dirties pages on the inode
>> t1: call cifs_invalidate_mapping which does filemap_write_and_wait.
>> =A0 =A0That fails, so fsync returns an error.
>> t2: now it does an fsync and the error is reported again
>
> why does the last line report the error again? what does it prevent t=
o
> return OK?
>
>>
>>> =A0 =A0 =A0 tcon =3D tlink_tcon(smbfile->tlink);
>>> =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
>>> @@ -1916,8 +1921,13 @@ int cifs_file_strict_mmap(struct file *file,=
 struct vm_area_struct *vma)
>>>
>>> =A0 =A0 =A0 xid =3D GetXid();
>>>
>>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 }
>>>
>>> =A0 =A0 =A0 rc =3D generic_file_mmap(file, vma);
>>> =A0 =A0 =A0 FreeXid(xid);
>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>>> index adb6324..d3abfc5 100644
>>> --- a/fs/cifs/inode.c
>>> +++ b/fs/cifs/inode.c
>>> @@ -1683,27 +1683,25 @@ cifs_inode_needs_reval(struct inode *inode)
>>> =A0/*
>>> =A0 * Zap the cache. Called when invalid_mapping flag is set.
>>> =A0 */
>>> -void
>>> +int
>>> =A0cifs_invalidate_mapping(struct inode *inode)
>>> =A0{
>>> - =A0 =A0 int rc;
>>> + =A0 =A0 int rc =3D 0;
>>> =A0 =A0 =A0 struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
>>>
>>> - =A0 =A0 cifs_i->invalid_mapping =3D false;
>>> -
>>> =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D =
0) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_=
mapping);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc)=
;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i=
_mapping);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could not =
invalidate inode %p", __func__,
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping =3D=
 true;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: could not in=
validate inode %p", __func__,
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping =3D (rc !=3D 0) ?=
 true : false;
>>
>> This is racy. You could end up writing back, invalidating pages, etc=
=2E
>> successfully. Another thread could come along afterward and then set
>> invalid_mapping =3D true. Then you go and set it to false, thinking =
that
>> everything is OK.
>>
>> I think what you really want to do is mapping to false first, then
>> reset it to true if writeback or page invalidation fails.
>>
>
> But in your case it's racy again:
> 1) t1 sets it to false
> 2) t2 sets it to false
> 3) t1 does filemap_write and invalidate - OK
> 4) t2 does filemap_write and invalidate - ERROR (!)
> 5) t2 marks invalid_mapping as true
> 6) t1 marks invalid_mapping as false - and we miss a ERROR from the 4=
rd line.
>
> May be we should protect it through =A0a special mapping lock?

Sorry, you are right - there are no problems with it because on the
line 6 we don't set anything as you suggest. So - this question is
over.

>
>>> =A0 =A0 =A0 }
>>>
>>> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
>>> + =A0 =A0 return rc;
>>> =A0}
>>>
>>> =A0int cifs_revalidate_file(struct file *filp)
>>> @@ -1722,7 +1720,7 @@ int cifs_revalidate_file(struct file *filp)
>>>
>>> =A0check_inval:
>>> =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>>
>>> =A0 =A0 =A0 return rc;
>>> =A0}
>>> @@ -1764,7 +1762,7 @@ int cifs_revalidate_dentry(struct dentry *den=
try)
>>>
>>> =A0check_inval:
>>> =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>>
>>> =A0 =A0 =A0 kfree(full_path);
>>> =A0 =A0 =A0 FreeXid(xid);
>>> @@ -1776,7 +1774,15 @@ int cifs_getattr(struct vfsmount *mnt, struc=
t dentry *dentry,
>>> =A0{
>>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
>>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb)=
;
>>> - =A0 =A0 int err =3D cifs_revalidate_dentry(dentry);
>>> + =A0 =A0 int err;
>>> +
>>> + =A0 =A0 err =3D cifs_revalidate_dentry(dentry);
>>> + =A0 =A0 /*
>>> + =A0 =A0 =A0* We only need to get file attributes and don't need t=
o
>>> + =A0 =A0 =A0* aware about busy pages (-EBUSY error code).
>>> + =A0 =A0 =A0*/
>>> + =A0 =A0 if (err =3D=3D -EBUSY)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
>>>
>>> =A0 =A0 =A0 if (!err) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_fillattr(dentry->d_inode, stat)=
;
>>
>
> --
> Best regards,
> Pavel Shilovsky.
>



--=20
Best regards,
Pavel Shilovsky.
