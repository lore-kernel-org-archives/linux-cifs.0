From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Implement cifs_file_strict_mmap (try #2)
Date: Fri, 17 Dec 2010 09:12:20 -0500
Message-ID: <20101217091220.2a9497c2@tlielax.poochiereds.net>
References: <1292521052-5388-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292521052-5388-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Dec 2010 20:37:31 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Invalidate inode mapping if we don't have at least Level II oplock.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    4 ++--
>  fs/cifs/cifsfs.h |    1 +
>  fs/cifs/file.c   |   15 +++++++++++++++
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7660133..a218afe 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -720,7 +720,7 @@ const struct file_operations cifs_file_strict_ops = {
>  	.lock = cifs_lock,
>  	.fsync = cifs_strict_fsync,
>  	.flush = cifs_flush,
> -	.mmap = cifs_file_mmap,
> +	.mmap = cifs_file_strict_mmap,
>  	.splice_read = generic_file_splice_read,
>  	.llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_POSIX
> @@ -775,7 +775,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
>  	.release = cifs_close,
>  	.fsync = cifs_strict_fsync,
>  	.flush = cifs_flush,
> -	.mmap = cifs_file_mmap,
> +	.mmap = cifs_file_strict_mmap,
>  	.splice_read = generic_file_splice_read,
>  	.llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_POSIX
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 8584829..657738f 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -89,6 +89,7 @@ extern int cifs_fsync(struct file *, int);
>  extern int cifs_strict_fsync(struct file *, int);
>  extern int cifs_flush(struct file *, fl_owner_t id);
>  extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
> +extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
>  extern const struct file_operations cifs_dir_ops;
>  extern int cifs_dir_open(struct inode *inode, struct file *file);
>  extern int cifs_readdir(struct file *file, void *direntry, filldir_t filldir);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4e37cb8..d48723c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1827,6 +1827,21 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  	return total_read;
>  }
>  
> +int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	int rc, xid;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +
> +	xid = GetXid();
> +
> +	if (!CIFS_I(inode)->clientCanCacheRead)
> +		cifs_invalidate_mapping(inode);
> +
> +	rc = generic_file_mmap(file, vma);
> +	FreeXid(xid);
> +	return rc;
> +}
> +
>  int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	int rc, xid;

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
