From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
 (try #3)
Date: Wed, 30 Mar 2011 16:06:11 -0500
Message-ID: <AANLkTik8EWOj5TOaEjwwm760mM670E7PK4QZOTNBBfiN@mail.gmail.com>
References: <1301336153-10193-1-git-send-email-piastry@etersoft.ru>
	<20110330165522.5fc6dc1c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110330165522.5fc6dc1c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 30, 2011 at 3:55 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 28 Mar 2011 22:15:53 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Base of approach for splitting all calls that uses cifs_invalidate_m=
apping
>> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
>> 1) aware about -EBUSY error code and report it back (cifs_d_revalida=
te,
>> cifs_file_strict_mmap);
>> 2) don't do it (cifs_getattrs, cifs_strict_fsync, cifs_lseek).
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 =A08 +++++++-
>> =A0fs/cifs/cifsfs.h | =A0 =A02 +-
>> =A0fs/cifs/file.c =A0 | =A0 24 ++++++++++++++++++++----
>> =A0fs/cifs/inode.c =A0| =A0 23 ++++++++++++++++-------
>> =A04 files changed, 44 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index de49fbb..b76d992 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -634,7 +634,13 @@ static loff_t cifs_llseek(struct file *file, lo=
ff_t offset, int origin)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(file->f_path.dentry->d_inode)->ti=
me =3D 0;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(file);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* We only need to get right file length=
 and should not aware
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* about busy pages (-EBUSY error code).
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval =3D=3D -EBUSY)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (retval < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval;
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 return generic_file_llseek_unlocked(file, offset, origin=
);
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index bb64313..f4391ff 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct dent=
ry *, struct inode *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *);
>> =A0extern int cifs_revalidate_file(struct file *filp);
>> =A0extern int cifs_revalidate_dentry(struct dentry *);
>> -extern void cifs_invalidate_mapping(struct inode *inode);
>> +extern int cifs_invalidate_mapping(struct inode *inode);
>> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, struc=
t kstat *);
>> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index b9731c9..329081f 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1448,8 +1448,19 @@ int cifs_strict_fsync(struct file *file, int =
datasync)
>> =A0 =A0 =A0 cFYI(1, "Sync file - name: %s datasync: 0x%x",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 file->f_path.dentry->d_name.name, datasy=
nc);
>>
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* We only need to flush all dirty pages=
 and should not aware
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* if some of them are busy (-EBUSY erro=
r code).
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EBUSY)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 tcon =3D tlink_tcon(smbfile->tlink);
>> =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
>> @@ -1916,8 +1927,13 @@ int cifs_file_strict_mmap(struct file *file, =
struct vm_area_struct *vma)
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>>
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 rc =3D generic_file_mmap(file, vma);
>> =A0 =A0 =A0 FreeXid(xid);
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index adb6324..7b3a078 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1683,10 +1683,10 @@ cifs_inode_needs_reval(struct inode *inode)
>> =A0/*
>> =A0 * Zap the cache. Called when invalid_mapping flag is set.
>> =A0 */
>> -void
>> +int
>> =A0cifs_invalidate_mapping(struct inode *inode)
>> =A0{
>> - =A0 =A0 int rc;
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
>>
>> =A0 =A0 =A0 cifs_i->invalid_mapping =3D false;
>> @@ -1697,13 +1697,14 @@ cifs_invalidate_mapping(struct inode *inode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i_=
mapping);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could not i=
nvalidate inode %p", __func__,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: could not inv=
alidate inode %p", __func__,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping =
=3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0int cifs_revalidate_file(struct file *filp)
>> @@ -1722,7 +1723,7 @@ int cifs_revalidate_file(struct file *filp)
>>
>> =A0check_inval:
>> =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -1764,7 +1765,7 @@ int cifs_revalidate_dentry(struct dentry *dent=
ry)
>>
>> =A0check_inval:
>> =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>>
>> =A0 =A0 =A0 kfree(full_path);
>> =A0 =A0 =A0 FreeXid(xid);
>> @@ -1776,7 +1777,15 @@ int cifs_getattr(struct vfsmount *mnt, struct=
 dentry *dentry,
>> =A0{
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>> - =A0 =A0 int err =3D cifs_revalidate_dentry(dentry);
>> + =A0 =A0 int err;
>> +
>> + =A0 =A0 err =3D cifs_revalidate_dentry(dentry);
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We only need to get inode attributes and should not a=
ware about busy
>> + =A0 =A0 =A0* pages (-EBUSY error code).
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (err =3D=3D -EBUSY)
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
>>
>> =A0 =A0 =A0 if (!err) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_fillattr(dentry->d_inode, stat);
>
> I really dislike this special casing for EBUSY. That seems like a rea=
l
> red flag that this is the wrong approach.
>
> I think the right solution will involve implementing a launder_page
> operation. With that you shouldn't ever get an EBUSY as long as the
> launder_page succeeds. If it doesn't then you probably want to return
> an error in the above cases anyway.

I am not convinced that launder page is needed (it might make it
easier but hard to tell) but I agree that special casing one
rc out of:

               rc =3D invalidate_inode_pages2(inode->i_mapping);

is odd.   Seems like the problem is that some callers of
invalidate_mapping don't care about the rc, some care
about the rc from filemap_fdatawrite so they can return
write errors (disk full, server down etc.) to the user and
some may even care whether all pages are freed
this time around (ie whether invalidate_inode_page2
partially vs. totally succeeded).

--=20
Thanks,

Steve
