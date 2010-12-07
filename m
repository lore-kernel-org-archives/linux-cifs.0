From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Make cifs_file_map work with strict cache
 mode (try #3)
Date: Tue, 7 Dec 2010 07:56:35 -0500
Message-ID: <20101207075635.6f9c1c5f@tlielax.poochiereds.net>
References: <1291037804-4000-1-git-send-email-piastryyy@gmail.com>
	<1291037804-4000-4-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291037804-4000-4-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 29 Nov 2010 16:36:44 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Invalidate inode if we don't have at least Level II oplock and strict
> cache mode switched on.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d216879..e9f2fae 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1812,14 +1812,24 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	int rc, xid;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  
>  	xid = GetXid();
> -	rc = cifs_revalidate_file(file);
> -	if (rc) {
> -		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
> -		FreeXid(xid);
> -		return rc;
> +
> +	if (!CIFS_I(inode)->clientCanCacheRead &&
> +	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
> +		cifs_invalidate_mapping(inode);
> +	else {
> +		rc = cifs_revalidate_file(file);
> +		if (rc) {
> +			cFYI(1, "Validation prior to mmap failed, error=%d",
> +			     rc);
> +			FreeXid(xid);
> +			return rc;
> +		}
>  	}
> +
>  	rc = generic_file_mmap(file, vma);
>  	FreeXid(xid);
>  	return rc;

Looks reasonable, though all of this special-casing sure is gross...

Might it be better to have a set of cifs_strict_file/inode_ops and use
those rather than all of these if/else conditions?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
