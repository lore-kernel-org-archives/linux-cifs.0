From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: clean up some compiler warnings
Date: Mon, 31 Jan 2011 15:42:01 +0300
Message-ID: <AANLkTim+EXv36df1SpKPGxE0ruyWK=3iBW57QpjUyv8e@mail.gmail.com>
References: <1295968605-21687-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295968605-21687-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> New compiler warnings that I noticed when building a patchset based
> on recent Fedora kernel:
>
> fs/cifs/cifssmb.c: In function =91CIFSSMBSetFileSize=92:
> fs/cifs/cifssmb.c:4813:8: warning: variable =91data_offset=92 set but=
 not used
> [-Wunused-but-set-variable]
>
> fs/cifs/file.c: In function =91cifs_open=92:
> fs/cifs/file.c:349:24: warning: variable =91pCifsInode=92 set but not=
 used
> [-Wunused-but-set-variable]
> fs/cifs/file.c: In function =91cifs_partialpagewrite=92:
> fs/cifs/file.c:1149:23: warning: variable =91cifs_sb=92 set but not u=
sed
> [-Wunused-but-set-variable]
> fs/cifs/file.c: In function =91cifs_iovec_write=92:
> fs/cifs/file.c:1740:9: warning: passing argument 6 of =91CIFSSMBWrite=
2=92 from
> incompatible pointer type [enabled by default]
> fs/cifs/cifsproto.h:337:12: note: expected =91unsigned int *=92 but a=
rgument is
> of type =91size_t *=92
>
> fs/cifs/readdir.c: In function =91cifs_readdir=92:
> fs/cifs/readdir.c:767:23: warning: variable =91cifs_sb=92 set but not=
 used
> [-Wunused-but-set-variable]
>
> fs/cifs/cifs_dfs_ref.c: In function =91cifs_dfs_d_automount=92:
> fs/cifs/cifs_dfs_ref.c:342:2: warning: =91rc=92 may be used uninitial=
ized in
> this function [-Wuninitialized]
> fs/cifs/cifs_dfs_ref.c:278:6: note: =91rc=92 was declared here
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_dfs_ref.c | =A0 =A09 ++++-----
> =A0fs/cifs/cifssmb.c =A0 =A0 =A0| =A0 =A03 ---
> =A0fs/cifs/file.c =A0 =A0 =A0 =A0 | =A0 =A08 ++------
> =A0fs/cifs/readdir.c =A0 =A0 =A0| =A0 =A03 ---
> =A04 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index f1c6862..0a265ad 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -282,8 +282,6 @@ static struct vfsmount *cifs_dfs_do_automount(str=
uct dentry *mntpt)
> =A0 =A0 =A0 =A0cFYI(1, "in %s", __func__);
> =A0 =A0 =A0 =A0BUG_ON(IS_ROOT(mntpt));
>
> - =A0 =A0 =A0 xid =3D GetXid();
> -
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * The MSDFS spec states that paths in DFS referral re=
quests and
> =A0 =A0 =A0 =A0 * responses must be prefixed by a single '\' characte=
r instead of
> @@ -293,7 +291,7 @@ static struct vfsmount *cifs_dfs_do_automount(str=
uct dentry *mntpt)
> =A0 =A0 =A0 =A0mnt =3D ERR_PTR(-ENOMEM);
> =A0 =A0 =A0 =A0full_path =3D build_path_from_dentry(mntpt);
> =A0 =A0 =A0 =A0if (full_path =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_xid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cdda_exit;
>
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(mntpt->d_inode->i_sb);
> =A0 =A0 =A0 =A0tlink =3D cifs_sb_tlink(cifs_sb);
> @@ -303,9 +301,11 @@ static struct vfsmount *cifs_dfs_do_automount(st=
ruct dentry *mntpt)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ses =3D tlink_tcon(tlink)->ses;
>
> + =A0 =A0 =A0 xid =3D GetXid();
> =A0 =A0 =A0 =A0rc =3D get_dfs_path(xid, ses, full_path + 1, cifs_sb->=
local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&num_referrals, &referrals,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags & CIFS_MOUNT_M=
AP_SPECIAL_CHR);
> + =A0 =A0 =A0 FreeXid(xid);
>
> =A0 =A0 =A0 =A0cifs_put_tlink(tlink);
>
> @@ -338,8 +338,7 @@ success:
> =A0 =A0 =A0 =A0free_dfs_info_array(referrals, num_referrals);
> =A0free_full_path:
> =A0 =A0 =A0 =A0kfree(full_path);
> -free_xid:
> - =A0 =A0 =A0 FreeXid(xid);
> +cdda_exit:
> =A0 =A0 =A0 =A0cFYI(1, "leaving %s" , __func__);
> =A0 =A0 =A0 =A0return mnt;
> =A0}
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 32378f2..0ad5bab 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4810,7 +4810,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTc=
onInfo *tcon, __u64 size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid, __u32 pid_of_opener, b=
ool SetAllocation)
> =A0{
> =A0 =A0 =A0 =A0struct smb_com_transaction2_sfi_req *pSMB =A0=3D NULL;
> - =A0 =A0 =A0 char *data_offset;
> =A0 =A0 =A0 =A0struct file_end_of_file_info *parm_data;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0__u16 params, param_offset, offset, byte_count, count;
> @@ -4834,8 +4833,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTc=
onInfo *tcon, __u64 size,
> =A0 =A0 =A0 =A0param_offset =3D offsetof(struct smb_com_transaction2_=
sfi_req, Fid) - 4;
> =A0 =A0 =A0 =A0offset =3D param_offset + params;
>
> - =A0 =A0 =A0 data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset=
;
> -
> =A0 =A0 =A0 =A0count =3D sizeof(struct file_end_of_file_info);
> =A0 =A0 =A0 =A0pSMB->MaxParameterCount =3D cpu_to_le16(2);
> =A0 =A0 =A0 =A0/* BB find exact max SMB PDU from sess structure BB */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5a659f9..113c775 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -346,7 +346,6 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> =A0 =A0 =A0 =A0struct tcon_link *tlink;
> =A0 =A0 =A0 =A0struct cifsFileInfo *pCifsFile =3D NULL;
> - =A0 =A0 =A0 struct cifsInodeInfo *pCifsInode;
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> =A0 =A0 =A0 =A0bool posix_open_ok =3D false;
> =A0 =A0 =A0 =A0__u16 netfid;
> @@ -361,8 +360,6 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
>
> - =A0 =A0 =A0 pCifsInode =3D CIFS_I(file->f_path.dentry->d_inode);
> -
> =A0 =A0 =A0 =A0full_path =3D build_path_from_dentry(file->f_path.dent=
ry);
> =A0 =A0 =A0 =A0if (full_path =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> @@ -1146,7 +1143,6 @@ static int cifs_partialpagewrite(struct page *p=
age, unsigned from, unsigned to)
> =A0 =A0 =A0 =A0char *write_data;
> =A0 =A0 =A0 =A0int rc =3D -EFAULT;
> =A0 =A0 =A0 =A0int bytes_written =3D 0;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct inode *inode;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
>
> @@ -1154,7 +1150,6 @@ static int cifs_partialpagewrite(struct page *p=
age, unsigned from, unsigned to)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EFAULT;
>
> =A0 =A0 =A0 =A0inode =3D page->mapping->host;
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(inode->i_sb);
>
> =A0 =A0 =A0 =A0offset +=3D (loff_t)from;
> =A0 =A0 =A0 =A0write_data =3D kmap(page);
> @@ -1667,7 +1662,8 @@ static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> - =A0 =A0 =A0 size_t total_written =3D 0, written =3D 0;
> + =A0 =A0 =A0 size_t total_written =3D 0;
> + =A0 =A0 =A0 unsigned int written =3D 0;
> =A0 =A0 =A0 =A0unsigned long num_pages, npages;
> =A0 =A0 =A0 =A0size_t copied, len, cur_len, i;
> =A0 =A0 =A0 =A0struct kvec *to_send;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 7f25cc3..f8e4cd2 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -764,7 +764,6 @@ int cifs_readdir(struct file *file, void *direntr=
y, filldir_t filldir)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int xid, i;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifsTconInfo *pTcon;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cifsFile =3D NULL;
> =A0 =A0 =A0 =A0char *current_entry;
> @@ -775,8 +774,6 @@ int cifs_readdir(struct file *file, void *direntr=
y, filldir_t filldir)
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> -
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Ensure FindFirst doesn't fail before doing filldir(=
) for '.' and
> =A0 =A0 =A0 =A0 * '..'. Otherwise we won't be able to notify VFS in c=
ase of failure.
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>


--=20
Best regards,
Pavel Shilovsky.
