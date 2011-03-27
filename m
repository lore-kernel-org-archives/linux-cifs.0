From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for
 cifs_invalidate_mapping (try #2)
Date: Sun, 27 Mar 2011 06:48:57 -0400
Message-ID: <20110327064857.6fc346f0@tlielax.poochiereds.net>
References: <1301127285-3573-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301127285-3573-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 26 Mar 2011 11:14:45 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Base of approach for splitting all calls that uses cifs_invalidate_mapping
> (or cifs_revalidate_dentry, cifs_revalidate_file) into two groups:
> 1) aware about -EBUSY error code and report it back (cifs_d_revalidate,
> cifs_strict_fsync, cifs_file_strict_mmap);
> 2) don't do it (cifs_getattrs, cifs_lseek).
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    8 +++++++-
>  fs/cifs/cifsfs.h |    2 +-
>  fs/cifs/file.c   |   18 ++++++++++++++----
>  fs/cifs/inode.c  |   23 ++++++++++++++++-------
>  4 files changed, 38 insertions(+), 13 deletions(-)
> 

-----------------[snip]---------------------

> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index bb64313..f4391ff 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -61,7 +61,7 @@ extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
>  		       struct dentry *);
>  extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
> -extern void cifs_invalidate_mapping(struct inode *inode);
> +extern int cifs_invalidate_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>  
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b9731c9..d99cf48 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1448,8 +1448,13 @@ int cifs_strict_fsync(struct file *file, int datasync)
>  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
>  		file->f_path.dentry->d_name.name, datasync);
>  
> -	if (!CIFS_I(inode)->clientCanCacheRead)
> -		cifs_invalidate_mapping(inode);
> +	if (!CIFS_I(inode)->clientCanCacheRead) {
> +		rc = cifs_invalidate_mapping(inode);
> +		if (rc) {
> +			FreeXid(xid);
> +			return rc;
> +		}
> +	}
>  

Now that I've had some more time to think on this patch, I don't think
this is what we want at all. The problem in a nutshell is that an -EBUSY
return makes no sense here.

Suppose I run fsync() on a file, and everything is written out
successfully, but some page is redirtied in the meantime and can't be
invalidated. This then returns -EBUSY, but why should the task doing the
fsync care that the pages can't be invalidated? It shouldn't, AFAICT.
The thread getting the -EBUSY ought to be the one that next attempts to
access the page.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
