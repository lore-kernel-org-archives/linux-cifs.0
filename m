From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Sat, 23 Apr 2011 09:16:55 -0500
Message-ID: <BANLkTi=J7oNsf=Yixzhp1eU7+=WRW=wB=A@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303565417-3653-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With this patch do you still measure a slight performance degradation
(e.g. with dbench) and how much?

On Sat, Apr 23, 2011 at 8:30 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> Simplify many places when we call cifs_revalidate/invalidate to make
> it do what it exactly needs.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 33 +++++++++++-----
> =A0fs/cifs/cifsfs.h | =A0 =A04 +-
> =A0fs/cifs/file.c =A0 | =A0 16 ++++++--
> =A0fs/cifs/inode.c =A0| =A0117 ++++++++++++++++++++++++++++++++++----=
---------------
> =A04 files changed, 113 insertions(+), 57 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 30fc505..e4185ae 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -618,16 +618,29 @@ static loff_t cifs_llseek(struct file *file, lo=
ff_t offset, int origin)
> =A0{
> =A0 =A0 =A0 =A0/* origin =3D=3D SEEK_END =3D> we must revalidate the =
cached file length */
> =A0 =A0 =A0 =A0if (origin =3D=3D SEEK_END) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int retval;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* some applications poll for the file =
length in this strange
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0way so we must seek to end on no=
n-oplocked files by
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0setting the revalidate time to z=
ero */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(file->f_path.dentry->d_inode)->t=
ime =3D 0;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_revalidate_file(file);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)retval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode =3D file->f_path.de=
ntry->d_inode;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to be sure that all dirty =
pages are written and the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* server has the newest file length.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead =
&& inode->i_mapping &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_mapping->nrpages !=3D =
0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawai=
t(inode->i_mapping);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode=
->i_mapping, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Some applications poll for the fil=
e length in this strange
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* way so we must seek to end on non-=
oplocked files by
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* setting the revalidate time to zer=
o.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->time =3D 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_revalidate_file_attr(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (loff_t)rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return generic_file_llseek_unlocked(file, offset, orig=
in);
> =A0}
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 371d021..e005dfd 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -59,9 +59,11 @@ extern int cifs_mkdir(struct inode *, struct dentr=
y *, int);
> =A0extern int cifs_rmdir(struct inode *, struct dentry *);
> =A0extern int cifs_rename(struct inode *, struct dentry *, struct ino=
de *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dentry *);
> +extern int cifs_revalidate_file_attr(struct file *filp);
> +extern int cifs_revalidate_dentry_attr(struct dentry *);
> =A0extern int cifs_revalidate_file(struct file *filp);
> =A0extern int cifs_revalidate_dentry(struct dentry *);
> -extern void cifs_invalidate_mapping(struct inode *inode);
> +extern int cifs_invalidate_mapping(struct inode *inode);
> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, struct=
 kstat *);
> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 00b466e..3bb68c4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1534,8 +1534,13 @@ int cifs_strict_fsync(struct file *file, int d=
atasync)
> =A0 =A0 =A0 =A0cFYI(1, "Sync file - name: %s datasync: 0x%x",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0file->f_path.dentry->d_name.name, data=
sync);
>
> - =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "rc: %d during =
invalidate phase", rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0; /* don't care=
 about it in fsync */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(smbfile->tlink);
> =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> @@ -2002,8 +2007,11 @@ int cifs_file_strict_mmap(struct file *file, s=
truct vm_area_struct *vma)
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0rc =3D generic_file_mmap(file, vma);
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index fbe7d58..0cc7edd 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1683,18 +1683,15 @@ cifs_inode_needs_reval(struct inode *inode)
> =A0/*
> =A0* Zap the cache. Called when invalid_mapping flag is set.
> =A0*/
> -void
> +int
> =A0cifs_invalidate_mapping(struct inode *inode)
> =A0{
> - =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
>
> =A0 =A0 =A0 =A0cifs_i->invalid_mapping =3D false;
>
> =A0 =A0 =A0 =A0if (inode->i_mapping && inode->i_mapping->nrpages !=3D=
 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_=
mapping);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D invalidate_inode_pages2(inode->=
i_mapping);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: could n=
ot invalidate inode %p", __func__,
> @@ -1704,56 +1701,52 @@ cifs_invalidate_mapping(struct inode *inode)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cifs_fscache_reset_inode_cookie(inode);
> + =A0 =A0 =A0 return rc;
> =A0}
>
> -int cifs_revalidate_file(struct file *filp)
> +int cifs_revalidate_file_attr(struct file *filp)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0struct inode *inode =3D filp->f_path.dentry->d_inode;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cfile =3D (struct cifsFileInfo *)=
 filp->private_data;
>
> =A0 =A0 =A0 =A0if (!cifs_inode_needs_reval(inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>
> =A0 =A0 =A0 =A0if (tlink_tcon(cfile->tlink)->unix_ext)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_file_info_unix(filp);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_file_info(filp);
>
> -check_inval:
> - =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> -
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -/* revalidate a dentry's inode attributes */
> -int cifs_revalidate_dentry(struct dentry *dentry)
> +int cifs_revalidate_dentry_attr(struct dentry *dentry)
> =A0{
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 char *full_path =3D NULL;
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
> =A0 =A0 =A0 =A0struct super_block *sb =3D dentry->d_sb;
> + =A0 =A0 =A0 char *full_path =3D NULL;
>
> =A0 =A0 =A0 =A0if (inode =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOENT;
>
> - =A0 =A0 =A0 xid =3D GetXid();
> -
> =A0 =A0 =A0 =A0if (!cifs_inode_needs_reval(inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 xid =3D GetXid();
>
> =A0 =A0 =A0 =A0/* can not safely grab the rename sem here if rename c=
alls revalidate
> =A0 =A0 =A0 =A0 =A0 since that would deadlock */
> =A0 =A0 =A0 =A0full_path =3D build_path_from_dentry(dentry);
> =A0 =A0 =A0 =A0if (full_path =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto check_inval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%=
p d_time %ld "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"jiffies %ld", full_path, inode, ino=
de->i_count.counter,
> + =A0 =A0 =A0 cFYI(1, "Update attributes: %s inode 0x%p count %d dent=
ry: 0x%p d_time "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"%ld jiffies %ld", full_path, inode,=
 inode->i_count.counter,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry, dentry->d_time, jiffies);
>
> =A0 =A0 =A0 =A0if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> @@ -1762,41 +1755,81 @@ int cifs_revalidate_dentry(struct dentry *den=
try)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info(&inode, ful=
l_path, NULL, sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 xid, NULL);
>
> -check_inval:
> - =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_invalidate_mapping(inode);
> -
> +out:
> =A0 =A0 =A0 =A0kfree(full_path);
> =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +int cifs_revalidate_file(struct file *filp)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct inode *inode =3D filp->f_path.dentry->d_inode;
> +
> + =A0 =A0 =A0 rc =3D cifs_revalidate_file_attr(filp);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +/* revalidate a dentry's inode attributes */
> +int cifs_revalidate_dentry(struct dentry *dentry)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> +
> + =A0 =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 if (CIFS_I(inode)->invalid_mapping)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_invalidate_mapping(inode);
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> =A0{
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb)=
;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D cifs_sb_master_tcon(cifs=
_sb);
> - =A0 =A0 =A0 int err =3D cifs_revalidate_dentry(dentry);
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 int rc;
>
> - =A0 =A0 =A0 if (!err) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_fillattr(dentry->d_inode, stat)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->blksize =3D CIFS_MAX_MSGSIZE;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->ino =3D CIFS_I(dentry->d_inode)->=
uniqueid;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We need to be sure that all dirty pages are writte=
n and the server
> + =A0 =A0 =A0 =A0* has actual ctime, mtime and file length.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheRead && inode->i_mapp=
ing &&
> + =A0 =A0 =A0 =A0 =A0 inode->i_mapping->nrpages !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawait(inode->i_mappi=
ng);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If on a multiuser mount without un=
ix extensions, and the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* admin hasn't overridden them, set =
the ownership to the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fsuid/fsgid of the current process=
=2E
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_MULTIUSER) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs=
_flags & CIFS_MOUNT_OVERR_UID))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->u=
id =3D current_fsuid();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs=
_flags & CIFS_MOUNT_OVERR_GID))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->g=
id =3D current_fsgid();
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 generic_fillattr(inode, stat);
> + =A0 =A0 =A0 stat->blksize =3D CIFS_MAX_MSGSIZE;
> + =A0 =A0 =A0 stat->ino =3D CIFS_I(inode)->uniqueid;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If on a multiuser mount without unix extensions, a=
nd the admin hasn't
> + =A0 =A0 =A0 =A0* overridden them, set the ownership to the fsuid/fs=
gid of the current
> + =A0 =A0 =A0 =A0* process.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
> + =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_OVERR_UID))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =3D current_f=
suid();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_OVERR_GID))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =3D current_f=
sgid();
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 return rc;
> =A0}
>
> =A0static int cifs_truncate_page(struct address_space *mapping, loff_=
t from)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
