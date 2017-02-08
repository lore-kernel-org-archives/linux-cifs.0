From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Introduce cifs_copy_file_range()
Date: Wed, 8 Feb 2017 15:44:53 -0800
Message-ID: <CAKywueSujBajRf1_-_Fq8fTum6ALWWKs6exUqFCa1bnBch2H1g@mail.gmail.com>
References: <20170207113311.11474-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170207113311.11474-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-07 3:33 GMT-08:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The patch introduces the file_operations helper cifs_copy_file_range().
>
> The vfs helper vfs_copy_file_range() first calls clone_file_range
> which for cifs uses
> SMB2_ioctl(.., FSCTL_DUPLICATE_EXTENTS_TO_FILE, ..)
> to do a server side copy of the file. This ioctl is only supported on
> SMB3 and later versions.
>
> Once this call fails, vfs_copy_file_range() calls copy_file_range()
> corresponding to the cifs filesystem which is introduced by this patch.
> This calls the more widely available
> SMB2_ioctl(.., FSCTL_SRV_COPYCHUNK_WRITE, ..)
>
> The upstream changes in this area was first made by the commit
> 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
> This commit also introduces the ioctls FICLONE and FICLONERANGE which
> removes the need for separate cifs ioctls to perform server side copies
> and hence can be removed.
>

ioctls FICLONE and FICLONERANGE perform a file clone operation which
for cifs is implemented through FSCTL_DUPLICATE_EXTENTS_TO_FILE for
SMB3 only. ioctl CIFS_IOC_COPYCHUNK_FILE performs a file copy
operation which is implemented through FSCTL_SRV_COPYCHUNK_WRITE. So,
this generic ioctls can't substitute the existing cifs one.

Also there is a copy_file_range() system call that calls
vfs_copy_file_range(). With this patch applied it tries to clone first
and then copy. It means that for SMB3 it will still call
DUPLICATE_EXTENTS_TO_FILE and we end up with two calls issuing
DUPLICATE_EXTENTS_TO_FILE and zero -SRV_COPYCHUNK_WRITE.

Thus I suggest not to remove a separate cifs ioctl that always calls
COPYCHUNK_WRITE for possible scenarios where DUPLICATE_EXTENTS_TO_FILE
is not suitable.

> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |  72 +++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsglob.h |   2 +-
>  fs/cifs/ioctl.c    | 107 -----------------------------------------------------
>  fs/cifs/smb2ops.c  |  16 +++++---
>  4 files changed, 84 insertions(+), 113 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 70f4e65..33bc53d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -972,6 +972,72 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
>         return rc;
>  }
>
> +ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
> +                        struct file *dst_file, loff_t destoff,
> +                        size_t len, unsigned int flags)
> +{
> +       struct inode *src_inode = file_inode(src_file);
> +       struct inode *target_inode = file_inode(dst_file);
> +       struct cifsFileInfo *smb_file_src = src_file->private_data;
> +       struct cifsFileInfo *smb_file_target = dst_file->private_data;
> +       struct cifs_tcon *src_tcon;
> +       struct cifs_tcon *target_tcon;
> +       unsigned int xid;
> +       int rc;
> +
> +       xid = get_xid();
> +
> +       cifs_dbg(FYI, "copy file range\n");
> +
> +       if (src_inode == target_inode) {
> +               rc = -EINVAL;
> +               goto out;
> +       }
> +
> +       if (!src_file->private_data || !dst_file->private_data) {
> +               rc = -EBADF;
> +               cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
> +               goto out;
> +       }
> +
> +       rc = -EXDEV;
> +       src_tcon = tlink_tcon(smb_file_src->tlink);
> +       target_tcon = tlink_tcon(smb_file_target->tlink);
> +
> +       if (src_tcon->ses != target_tcon->ses) {
> +               cifs_dbg(VFS, "source and target of copy not on same server\n");
> +               goto out;
> +       }
> +
> +       /*
> +        * Note: cifs case is easier than btrfs since server responsible for
> +        * checks for proper open modes and file type and if it wants
> +        * server could even support copy of range where source = target
> +        */
> +       lock_two_nondirectories(target_inode, src_inode);
> +
> +       cifs_dbg(FYI, "about to flush pages\n");
> +       /* should we flush first and last page first */
> +       truncate_inode_pages(&target_inode->i_data, 0);
> +
> +       if (target_tcon->ses->server->ops->clone_range)
> +               rc = target_tcon->ses->server->ops->clone_range(xid,
> +                       smb_file_src, smb_file_target, off, len, destoff);

I think there is a naming confusion here. I suggest to rename
clone_range() callback to copy_range() to reflect its actual logic.

> +       else
> +               rc = -EOPNOTSUPP;
> +
> +       /* force revalidate of size and timestamps of target file now
> +          that target is updated on the server */
> +       CIFS_I(target_inode)->time = 0;
> +       /* although unlocking in the reverse order from locking is not
> +          strictly necessary here it is a little cleaner to be consistent */
> +       unlock_two_nondirectories(src_inode, target_inode);
> +
> +out:
> +       free_xid(xid);
> +       return rc;
> +}
> +
>  const struct file_operations cifs_file_ops = {
>         .read_iter = cifs_loose_read_iter,
>         .write_iter = cifs_file_write_iter,
> @@ -984,6 +1050,7 @@ const struct file_operations cifs_file_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1001,6 +1068,7 @@ const struct file_operations cifs_file_strict_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1018,6 +1086,7 @@ const struct file_operations cifs_file_direct_ops = {
>         .mmap = cifs_file_mmap,
>         .splice_read = generic_file_splice_read,
>         .unlocked_ioctl  = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .llseek = cifs_llseek,
>         .setlease = cifs_setlease,
> @@ -1035,6 +1104,7 @@ const struct file_operations cifs_file_nobrl_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1051,6 +1121,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1067,6 +1138,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
>         .mmap = cifs_file_mmap,
>         .splice_read = generic_file_splice_read,
>         .unlocked_ioctl  = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .llseek = cifs_llseek,
>         .setlease = cifs_setlease,
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 7ea8a33..ae0c095 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -405,7 +405,7 @@ struct smb_version_operations {
>         char * (*create_lease_buf)(u8 *, u8);
>         /* parse lease context buffer and return oplock/epoch info */
>         __u8 (*parse_lease_buf)(void *, unsigned int *);
> -       int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
> +       ssize_t (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
>                         struct cifsFileInfo *target_file, u64 src_off, u64 len,
>                         u64 dest_off);
>         int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 0015287..14975b7 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -34,110 +34,6 @@
>  #include "cifs_ioctl.h"
>  #include <linux/btrfs.h>
>
> -static int cifs_file_clone_range(unsigned int xid, struct file *src_file,
> -                         struct file *dst_file)
> -{
> -       struct inode *src_inode = file_inode(src_file);
> -       struct inode *target_inode = file_inode(dst_file);
> -       struct cifsFileInfo *smb_file_src;
> -       struct cifsFileInfo *smb_file_target;
> -       struct cifs_tcon *src_tcon;
> -       struct cifs_tcon *target_tcon;
> -       int rc;
> -
> -       cifs_dbg(FYI, "ioctl clone range\n");
> -
> -       if (!src_file->private_data || !dst_file->private_data) {
> -               rc = -EBADF;
> -               cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
> -               goto out;
> -       }
> -
> -       rc = -EXDEV;
> -       smb_file_target = dst_file->private_data;
> -       smb_file_src = src_file->private_data;
> -       src_tcon = tlink_tcon(smb_file_src->tlink);
> -       target_tcon = tlink_tcon(smb_file_target->tlink);
> -
> -       if (src_tcon->ses != target_tcon->ses) {
> -               cifs_dbg(VFS, "source and target of copy not on same server\n");
> -               goto out;
> -       }
> -
> -       /*
> -        * Note: cifs case is easier than btrfs since server responsible for
> -        * checks for proper open modes and file type and if it wants
> -        * server could even support copy of range where source = target
> -        */
> -       lock_two_nondirectories(target_inode, src_inode);
> -
> -       cifs_dbg(FYI, "about to flush pages\n");
> -       /* should we flush first and last page first */
> -       truncate_inode_pages(&target_inode->i_data, 0);
> -
> -       if (target_tcon->ses->server->ops->clone_range)
> -               rc = target_tcon->ses->server->ops->clone_range(xid,
> -                       smb_file_src, smb_file_target, 0, src_inode->i_size, 0);
> -       else
> -               rc = -EOPNOTSUPP;
> -
> -       /* force revalidate of size and timestamps of target file now
> -          that target is updated on the server */
> -       CIFS_I(target_inode)->time = 0;
> -       /* although unlocking in the reverse order from locking is not
> -          strictly necessary here it is a little cleaner to be consistent */
> -       unlock_two_nondirectories(src_inode, target_inode);
> -out:
> -       return rc;
> -}
> -
> -static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
> -                       unsigned long srcfd)
> -{
> -       int rc;
> -       struct fd src_file;
> -       struct inode *src_inode;
> -
> -       cifs_dbg(FYI, "ioctl clone range\n");
> -       /* the destination must be opened for writing */
> -       if (!(dst_file->f_mode & FMODE_WRITE)) {
> -               cifs_dbg(FYI, "file target not open for write\n");
> -               return -EINVAL;
> -       }
> -
> -       /* check if target volume is readonly and take reference */
> -       rc = mnt_want_write_file(dst_file);
> -       if (rc) {
> -               cifs_dbg(FYI, "mnt_want_write failed with rc %d\n", rc);
> -               return rc;
> -       }
> -
> -       src_file = fdget(srcfd);
> -       if (!src_file.file) {
> -               rc = -EBADF;
> -               goto out_drop_write;
> -       }
> -
> -       if (src_file.file->f_op->unlocked_ioctl != cifs_ioctl) {
> -               rc = -EBADF;
> -               cifs_dbg(VFS, "src file seems to be from a different filesystem type\n");
> -               goto out_fput;
> -       }
> -
> -       src_inode = file_inode(src_file.file);
> -       rc = -EINVAL;
> -       if (S_ISDIR(src_inode->i_mode))
> -               goto out_fput;
> -
> -       rc = cifs_file_clone_range(xid, src_file.file, dst_file);
> -
> -out_fput:
> -       fdput(src_file);
> -out_drop_write:
> -       mnt_drop_write_file(dst_file);
> -       return rc;
> -}
> -
>  static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
>                                 void __user *arg)
>  {
> @@ -250,9 +146,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>                                 cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>                         }
>                         break;
> -               case CIFS_IOC_COPYCHUNK_FILE:
> -                       rc = cifs_ioctl_clone(xid, filep, arg);
> -                       break;
>                 case CIFS_IOC_SET_INTEGRITY:
>                         if (pSMBFile == NULL)
>                                 break;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 5d456eb..b7aa0926 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -586,7 +586,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> -static int
> +static ssize_t
>  smb2_clone_range(const unsigned int xid,
>                         struct cifsFileInfo *srcfile,
>                         struct cifsFileInfo *trgtfile, u64 src_off,
> @@ -599,6 +599,7 @@ smb2_clone_range(const unsigned int xid,
>         struct cifs_tcon *tcon;
>         int chunks_copied = 0;
>         bool chunk_sizes_updated = false;
> +       ssize_t bytes_written, total_bytes_written = 0;
>
>         pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
>
> @@ -662,14 +663,16 @@ smb2_clone_range(const unsigned int xid,
>                         }
>                         chunks_copied++;
>
> +                       bytes_written = le32_to_cpu(retbuf->TotalBytesWritten);
>                         src_off += le32_to_cpu(retbuf->TotalBytesWritten);
>                         dest_off += le32_to_cpu(retbuf->TotalBytesWritten);
> -                       len -= le32_to_cpu(retbuf->TotalBytesWritten);
> +                       len -= bytes_written;
> +                       total_bytes_written += bytes_written;
>
> -                       cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %d\n",
> +                       cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %zu\n",
>                                 le32_to_cpu(retbuf->ChunksWritten),
>                                 le32_to_cpu(retbuf->ChunkBytesWritten),
> -                               le32_to_cpu(retbuf->TotalBytesWritten));
> +                               bytes_written);
>                 } else if (rc == -EINVAL) {
>                         if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
>                                 goto cchunk_out;
> @@ -706,7 +709,10 @@ smb2_clone_range(const unsigned int xid,
>  cchunk_out:
>         kfree(pcchunk);
>         kfree(retbuf);
> -       return rc;
> +       if (rc)
> +               return rc;
> +       else
> +               return total_bytes_written;
>  }
>
>  static int
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Other than the comments above the patch looks good.

-- 
Best regards,
Pavel Shilovsky
