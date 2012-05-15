From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list
Date: Tue, 15 May 2012 12:55:25 -0400
Message-ID: <20120515125525.19ef9cc8@tlielax.poochiereds.net>
References: <1337093239-23409-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337093239-23409-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 May 2012 09:47:19 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> While traversing the linked list of open file handles, if the identfied
> file handle is invalid, a reopen is attempted and if it fails, we 
> resume traversing where we stopped and cifs can oops while accessing
> invalid next element, for list might have changed.
> 
> So mark the invalid file handle and attempt reopen if no
> valid file handle is found in rest of the list.
> Move the invalid file handle to the end of the list and
> if reopen fails for that file handle, start traversing the list again
> from the begining.
> Repeat this four times before giving up and returning an error if
> file reopen keeps failing.
> 
> 
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    1 +
>  fs/cifs/file.c     |   55 +++++++++++++++++++++++++++++----------------------
>  2 files changed, 32 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4ff6313..73fea28 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -43,6 +43,7 @@
>  
>  #define CIFS_MIN_RCV_POOL 4
>  
> +#define MAX_REOPEN_ATT	5 /* these many maximum attempts to reopen a file */


I don't know about this...

What happens if we have a long network partition, and then make 5
attempts to open the file that time out? AFAICT, we'll end up returning
NULL, and see the dreaded "No writable handles for inode" and then
we end up with people complaining about "corrupt data" on writeback.

Is that really the outcome we want with this? That doesn't seem like
very resilient behavior for a network filesystem.

>  /*
>   * default attribute cache timeout (jiffies)
>   */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 81725e9..52da2d2 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1539,10 +1539,11 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
>  struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  					bool fsuid_only)
>  {
> -	struct cifsFileInfo *open_file;
> +	struct cifsFileInfo *open_file, *inv_file = NULL;
>  	struct cifs_sb_info *cifs_sb;
>  	bool any_available = false;
>  	int rc;
> +	unsigned int refind = 0;
>  
>  	/* Having a null inode here (because mapping->host was set to zero by
>  	the VFS or MM) should not happen but we had reports of on oops (due to
> @@ -1562,40 +1563,25 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
>  
>  	spin_lock(&cifs_file_list_lock);
>  refind_writable:
> +	if (refind > MAX_REOPEN_ATT) {
> +		spin_unlock(&cifs_file_list_lock);
> +		return NULL;
> +	}
>  	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
>  		if (!any_available && open_file->pid != current->tgid)
>  			continue;
>  		if (fsuid_only && open_file->uid != current_fsuid())
>  			continue;
>  		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
> -			cifsFileInfo_get(open_file);
> -
>  			if (!open_file->invalidHandle) {
>  				/* found a good writable file */
> +				cifsFileInfo_get(open_file);
>  				spin_unlock(&cifs_file_list_lock);
>  				return open_file;
> +			} else {
> +				if (!inv_file)
> +					inv_file = open_file;
>  			}
> -
> -			spin_unlock(&cifs_file_list_lock);
> -
> -			/* Had to unlock since following call can block */
> -			rc = cifs_reopen_file(open_file, false);
> -			if (!rc)
> -				return open_file;
> -
> -			/* if it fails, try another handle if possible */
> -			cFYI(1, "wp failed on reopen file");
> -			cifsFileInfo_put(open_file);
> -
> -			spin_lock(&cifs_file_list_lock);
> -
> -			/* else we simply continue to the next entry. Thus
> -			   we do not loop on reopen errors.  If we
> -			   can not reopen the file, for example if we
> -			   reconnected to a server with another client
> -			   racing to delete or lock the file we would not
> -			   make progress if we restarted before the beginning
> -			   of the loop here. */
>  		}
>  	}
>  	/* couldn't find useable FH with same pid, try any available */
> @@ -1603,7 +1589,28 @@ refind_writable:
>  		any_available = true;
>  		goto refind_writable;
>  	}
> +
> +	if (inv_file) {
> +		any_available = false;
> +		cifsFileInfo_get(inv_file);
> +		list_del(&inv_file->flist);
> +		list_add_tail(&inv_file->flist, &cifs_inode->openFileList);
> +	}
> +
>  	spin_unlock(&cifs_file_list_lock);
> +
> +	if (inv_file) {
> +		rc = cifs_reopen_file(inv_file, false);
> +		if (!rc)
> +			return inv_file;
> +		else {
> +			spin_lock(&cifs_file_list_lock);
> +			cifsFileInfo_put(inv_file);
> +			++refind;
> +			goto refind_writable;
> +		}
> +	}
> +
>  	return NULL;
>  }
>  


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
