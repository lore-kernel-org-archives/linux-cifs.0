From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part
Date: Tue, 12 Apr 2011 22:27:09 +0400
Message-ID: <BANLkTin+iG0zsvxnjb20FTDXtJNpdh9JrA@mail.gmail.com>
References: <1302249408-8971-1-git-send-email-piastry@etersoft.ru>
	<1302249408-8971-2-git-send-email-piastry@etersoft.ru>
	<20110412100616.4af653ab@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110412100616.4af653ab-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/12 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, =A08 Apr 2011 11:56:48 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Simplify many places when we call cifs_revalidate/invalidate to make
>> it does what it exactly needs.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 =A02 +-
>> =A0fs/cifs/cifsfs.h | =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 | =A0 16 ++++++--
>> =A0fs/cifs/inode.c =A0| =A0114 ++++++++++++++++++++++++++++++++++---=
-----------------
>> =A04 files changed, 88 insertions(+), 48 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index fb6a2ad..7b29274 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -630,7 +630,7 @@ static loff_t cifs_llseek(struct file *file, lof=
f_t offset, int origin)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0setting the revalidate time to ze=
ro */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(file->f_path.dentry->d_inode)->ti=
me =3D 0;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(file);
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file_attr(file)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval;
>> =A0 =A0 =A0 }
>
> This looks good overall, I think. I'll note though that on getattr,
> you're writing back data, presumably to make sure that you get a
> correct file size from the server.
>
> Here though in llseek, you're not. Isn't an updated file size importa=
nt
> for the llseek case? If not, then why bother refreshing the attribute=
s
> at all?

It's my bug - you are right. I think we definitely need to flush all
dirty pages before - I will fix it and resend the patch.

>
>> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
>> index bb64313..d304584 100644
>> --- a/fs/cifs/cifsfs.h
>> +++ b/fs/cifs/cifsfs.h
>> @@ -59,9 +59,11 @@ extern int cifs_mkdir(struct inode *, struct dent=
ry *, int);
>> =A0extern int cifs_rmdir(struct inode *, struct dentry *);
>> =A0extern int cifs_rename(struct inode *, struct dentry *, struct in=
ode *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dentry *);
>> +extern int cifs_revalidate_file_attr(struct file *filp);
>> +extern int cifs_revalidate_dentry_attr(struct dentry *);
>> =A0extern int cifs_revalidate_file(struct file *filp);
>> =A0extern int cifs_revalidate_dentry(struct dentry *);
>> -extern void cifs_invalidate_mapping(struct inode *inode);
>> +extern int cifs_invalidate_mapping(struct inode *inode);
>> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, struc=
t kstat *);
>> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 20a95bb..b1ab963 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1442,8 +1442,13 @@ int cifs_strict_fsync(struct file *file, int =
datasync)
>> =A0 =A0 =A0 cFYI(1, "Sync file - name: %s datasync: 0x%x",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 file->f_path.dentry->d_name.name, datasy=
nc);
>>
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "rc: %d during inv=
alidate phase", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0; /* don't care ab=
out it in fsync */
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 tcon =3D tlink_tcon(smbfile->tlink);
>> =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
>> @@ -1928,8 +1933,11 @@ int cifs_file_strict_mmap(struct file *file, =
struct vm_area_struct *vma)
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>>
>> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> + =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 rc =3D generic_file_mmap(file, vma);
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index adb6324..5f71e11 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1683,18 +1683,15 @@ cifs_inode_needs_reval(struct inode *inode)
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
>>
>> =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D 0=
) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_map=
ping);
>> - =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i_=
mapping);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could not=
 invalidate inode %p", __func__,
>> @@ -1704,56 +1701,52 @@ cifs_invalidate_mapping(struct inode *inode)
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
>> + =A0 =A0 return rc;
>> =A0}
>>
>> -int cifs_revalidate_file(struct file *filp)
>> +int cifs_revalidate_file_attr(struct file *filp)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct inode *inode =3D filp->f_path.dentry->d_inode;
>> =A0 =A0 =A0 struct cifsFileInfo *cfile =3D (struct cifsFileInfo *) f=
ilp->private_data;
>>
>> =A0 =A0 =A0 if (!cifs_inode_needs_reval(inode))
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 if (tlink_tcon(cfile->tlink)->unix_ext)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_file_info_unix(filp);
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_file_info(filp);
>>
>> -check_inval:
>> - =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> -
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -/* revalidate a dentry's inode attributes */
>> -int cifs_revalidate_dentry(struct dentry *dentry)
>> +int cifs_revalidate_dentry_attr(struct dentry *dentry)
>> =A0{
>> =A0 =A0 =A0 int xid;
>> =A0 =A0 =A0 int rc =3D 0;
>> - =A0 =A0 char *full_path =3D NULL;
>> =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
>> =A0 =A0 =A0 struct super_block *sb =3D dentry->d_sb;
>> + =A0 =A0 char *full_path =3D NULL;
>>
>> =A0 =A0 =A0 if (inode =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>>
>> - =A0 =A0 xid =3D GetXid();
>> -
>> =A0 =A0 =A0 if (!cifs_inode_needs_reval(inode))
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 xid =3D GetXid();
>>
>> =A0 =A0 =A0 /* can not safely grab the rename sem here if rename cal=
ls revalidate
>> =A0 =A0 =A0 =A0 =A0since that would deadlock */
>> =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
>> =A0 =A0 =A0 if (full_path =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d=
_time %ld "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0"jiffies %ld", full_path, inode, inode-=
>i_count.counter,
>> + =A0 =A0 cFYI(1, "Update attributes: %s inode 0x%p count %d dentry:=
 0x%p d_time "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0"%ld jiffies %ld", full_path, inode, in=
ode->i_count.counter,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dentry, dentry->d_time, jiffies);
>>
>> =A0 =A0 =A0 if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
>> @@ -1762,41 +1755,78 @@ int cifs_revalidate_dentry(struct dentry *de=
ntry)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full_=
path, NULL, sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0xid, NULL);
>>
>> -check_inval:
>> - =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
>> -
>> +out:
>> =A0 =A0 =A0 kfree(full_path);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> +int cifs_revalidate_file(struct file *filp)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct inode *inode =3D filp->f_path.dentry->d_inode;
>> +
>> + =A0 =A0 rc =3D cifs_revalidate_file_attr(filp);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 return rc;
>> +}
>> +
>> +/* revalidate a dentry's inode attributes */
>> +int cifs_revalidate_dentry(struct dentry *dentry)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct inode *inode =3D dentry->d_inode;
>> +
>> + =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kstat *stat)
>> =A0{
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>> - =A0 =A0 int err =3D cifs_revalidate_dentry(dentry);
>> -
>> - =A0 =A0 if (!err) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 generic_fillattr(dentry->d_inode, stat);
>> - =A0 =A0 =A0 =A0 =A0 =A0 stat->blksize =3D CIFS_MAX_MSGSIZE;
>> - =A0 =A0 =A0 =A0 =A0 =A0 stat->ino =3D CIFS_I(dentry->d_inode)->uni=
queid;
>> + =A0 =A0 struct inode *inode =3D dentry->d_inode;
>> + =A0 =A0 int rc;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* If on a multiuser mount without unix =
extensions, and the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* admin hasn't overridden them, set the=
 ownership to the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0* fsuid/fsgid of the current process.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_=
MULTIUSER) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_fl=
ags & CIFS_MOUNT_OVERR_UID))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =
=3D current_fsuid();
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_fl=
ags & CIFS_MOUNT_OVERR_GID))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =
=3D current_fsgid();
>> + =A0 =A0 if (inode && inode->i_mapping && inode->i_mapping->nrpages=
 !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_map=
ping);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i=
_mapping, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> - =A0 =A0 return err;
>> +
>> + =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 generic_fillattr(dentry->d_inode, stat);
>> + =A0 =A0 stat->blksize =3D CIFS_MAX_MSGSIZE;
>> + =A0 =A0 stat->ino =3D CIFS_I(dentry->d_inode)->uniqueid;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* If on a multiuser mount without unix extensions, and =
the admin hasn't
>> + =A0 =A0 =A0* overridden them, set the ownership to the fsuid/fsgid=
 of the current
>> + =A0 =A0 =A0* process.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
>> + =A0 =A0 =A0 =A0 !tcon->unix_ext) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_OVERR_UID))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =3D current_fsui=
d();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT=
_OVERR_GID))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =3D current_fsgi=
d();
>> + =A0 =A0 }
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0static int cifs_truncate_page(struct address_space *mapping, loff=
_t from)
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
