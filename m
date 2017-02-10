From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Introduce cifs_copy_file_range()
Date: Fri, 10 Feb 2017 12:03:32 -0800
Message-ID: <CAKywueTbpr50dShE0N9UFkV3xK6g9Q-MZyq1s04nnzGtre1eDQ@mail.gmail.com>
References: <20170210103351.10163-1-sprabhu@redhat.com> <20170210103351.10163-3-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210103351.10163-3-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-10 2:33 GMT-08:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The patch introduces the file_operations helper cifs_copy_file_range()
> which is used by the syscall copy_file_range. The new file operations
> helper allows us to perform server side copies for SMB2.0 and 2.1
> servers as well as SMB 3.0+ servers which do not support the ioctl
> FSCTL_DUPLICATE_EXTENTS_TO_FILE.
>
> The new helper uses the ioctl FSCTL_SRV_COPYCHUNK_WRITE to perform
> server side copies. The helper is called by vfs_copy_file_range() only
> once an attempt to clone the file using the ioctl
> FSCTL_DUPLICATE_EXTENTS_TO_FILE has failed.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsfs.h   |  5 ++++
>  fs/cifs/cifsglob.h |  6 ++--
>  fs/cifs/ioctl.c    | 60 ++-----------------------------------
>  fs/cifs/smb2ops.c  | 20 ++++++++-----
>  5 files changed, 110 insertions(+), 68 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 70f4e65..9e32988 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -972,6 +972,86 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
>         return rc;
>  }
>
> +ssize_t cifs_file_copychunk_range(unsigned int xid,
> +                               struct file *src_file, loff_t off,
> +                               struct file *dst_file, loff_t destoff,
> +                               size_t len, unsigned int flags)
> +{
> +       struct inode *src_inode = file_inode(src_file);
> +       struct inode *target_inode = file_inode(dst_file);
> +       struct cifsFileInfo *smb_file_src;
> +       struct cifsFileInfo *smb_file_target;
> +       struct cifs_tcon *src_tcon;
> +       struct cifs_tcon *target_tcon;
> +       ssize_t rc;
> +
> +       cifs_dbg(FYI, "copychunk range\n");
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
> +       smb_file_target = dst_file->private_data;
> +       smb_file_src = src_file->private_data;
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
> +       if (target_tcon->ses->server->ops->copychunk_range)
> +               rc = target_tcon->ses->server->ops->copychunk_range(xid,
> +                       smb_file_src, smb_file_target, off, len, destoff);
> +       else
> +               rc = -EOPNOTSUPP;
> +
> +       /* force revalidate of size and timestamps of target file now
> +        * that target is updated on the server
> +        */
> +       CIFS_I(target_inode)->time = 0;
> +       /* although unlocking in the reverse order from locking is not
> +        * strictly necessary here it is a little cleaner to be consistent
> +        */
> +       unlock_two_nondirectories(src_inode, target_inode);
> +
> +out:
> +       return rc;
> +}
> +
> +ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
> +                               struct file *dst_file, loff_t destoff,
> +                               size_t len, unsigned int flags)
> +{
> +       unsigned int xid = get_xid();
> +       ssize_t rc;
> +
> +       rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
> +                                       len, flags);
> +       free_xid(xid);
> +       return rc;
> +}
> +
>  const struct file_operations cifs_file_ops = {
>         .read_iter = cifs_loose_read_iter,
>         .write_iter = cifs_file_write_iter,
> @@ -984,6 +1064,7 @@ const struct file_operations cifs_file_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1001,6 +1082,7 @@ const struct file_operations cifs_file_strict_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1018,6 +1100,7 @@ const struct file_operations cifs_file_direct_ops = {
>         .mmap = cifs_file_mmap,
>         .splice_read = generic_file_splice_read,
>         .unlocked_ioctl  = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .llseek = cifs_llseek,
>         .setlease = cifs_setlease,
> @@ -1035,6 +1118,7 @@ const struct file_operations cifs_file_nobrl_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1051,6 +1135,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
>         .splice_read = generic_file_splice_read,
>         .llseek = cifs_llseek,
>         .unlocked_ioctl = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .setlease = cifs_setlease,
>         .fallocate = cifs_fallocate,
> @@ -1067,6 +1152,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
>         .mmap = cifs_file_mmap,
>         .splice_read = generic_file_splice_read,
>         .unlocked_ioctl  = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .llseek = cifs_llseek,
>         .setlease = cifs_setlease,
> @@ -1078,6 +1164,7 @@ const struct file_operations cifs_dir_ops = {
>         .release = cifs_closedir,
>         .read    = generic_read_dir,
>         .unlocked_ioctl  = cifs_ioctl,
> +       .copy_file_range = cifs_copy_file_range,
>         .clone_file_range = cifs_clone_file_range,
>         .llseek = generic_file_llseek,
>  };
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index c9c00a8..6eb8174 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -139,6 +139,11 @@ extern ssize_t     cifs_listxattr(struct dentry *, char *, size_t);
>  # define cifs_listxattr NULL
>  #endif
>
> +extern ssize_t cifs_file_copychunk_range(unsigned int xid,
> +                                       struct file *src_file, loff_t off,
> +                                       struct file *dst_file, loff_t destoff,
> +                                       size_t len, unsigned int flags);
> +
>  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  #ifdef CONFIG_CIFS_NFSD_EXPORT
>  extern const struct export_operations cifs_export_ops;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f9376db..dda6d0b 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -405,10 +405,10 @@ struct smb_version_operations {
>         char * (*create_lease_buf)(u8 *, u8);
>         /* parse lease context buffer and return oplock/epoch info */
>         __u8 (*parse_lease_buf)(void *, unsigned int *);
> -       int (*copychunk_range)(const unsigned int,
> +       ssize_t (*copychunk_range)(const unsigned int,
>                         struct cifsFileInfo *src_file,
> -                       struct cifsFileInfo *target_file, u64 src_off, u64 len,
> -                       u64 dest_off);
> +                       struct cifsFileInfo *target_file,
> +                       u64 src_off, u64 len, u64 dest_off);
>         int (*duplicate_extents)(const unsigned int, struct cifsFileInfo *src,
>                         struct cifsFileInfo *target_file, u64 src_off, u64 len,
>                         u64 dest_off);
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 9bf0f94..265c45f 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -34,63 +34,6 @@
>  #include "cifs_ioctl.h"
>  #include <linux/btrfs.h>
>
> -static int cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
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
> -       cifs_dbg(FYI, "ioctl copychunk range\n");
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
> -       if (target_tcon->ses->server->ops->copychunk_range)
> -               rc = target_tcon->ses->server->ops->copychunk_range(xid,
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
>  static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
>                         unsigned long srcfd)
>  {
> @@ -129,7 +72,8 @@ static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
>         if (S_ISDIR(src_inode->i_mode))
>                 goto out_fput;
>
> -       rc = cifs_file_copychunk_range(xid, src_file.file, dst_file);
> +       rc = cifs_file_copychunk_range(xid, src_file.file, 0, dst_file, 0,
> +                                       src_inode->i_size, 0);
>
>  out_fput:
>         fdput(src_file);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 3dfd925..bf0c71d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -586,7 +586,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>         return rc;
>  }
>
> -static int
> +static ssize_t
>  smb2_copychunk_range(const unsigned int xid,
>                         struct cifsFileInfo *srcfile,
>                         struct cifsFileInfo *trgtfile, u64 src_off,
> @@ -599,6 +599,7 @@ smb2_copychunk_range(const unsigned int xid,
>         struct cifs_tcon *tcon;
>         int chunks_copied = 0;
>         bool chunk_sizes_updated = false;
> +       ssize_t bytes_written, total_bytes_written = 0;
>
>         pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
>
> @@ -662,14 +663,16 @@ smb2_copychunk_range(const unsigned int xid,
>                         }
>                         chunks_copied++;
>
> -                       src_off += le32_to_cpu(retbuf->TotalBytesWritten);
> -                       dest_off += le32_to_cpu(retbuf->TotalBytesWritten);
> -                       len -= le32_to_cpu(retbuf->TotalBytesWritten);
> +                       bytes_written = le32_to_cpu(retbuf->TotalBytesWritten);
> +                       src_off += bytes_written;
> +                       dest_off += bytes_written;
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
> @@ -706,7 +709,10 @@ smb2_copychunk_range(const unsigned int xid,
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

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
