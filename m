From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: use type __u32 instead of int for the oplock
 parameter
Date: Fri, 17 Sep 2010 10:39:57 -0400
Message-ID: <20100917103957.5cbde780@tlielax.poochiereds.net>
References: <4C937776.909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C937776.909-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 19:43:10 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> ... and avoid implicit casting from a signed type. Also, pass oplock by value
> instead by reference as we don't intend to change the value in
> cifs_open_inode_helper().
> 
> Thanks to Jeff Layton for spotting this.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> 
>  fs/cifs/file.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index de748c6..d33da45 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -165,7 +165,7 @@ psx_client_can_cache:
>  
>  /* all arguments to this function must be checked for validity in caller */
>  static inline int cifs_open_inode_helper(struct inode *inode,
> -	struct cifsTconInfo *pTcon, int *oplock, FILE_ALL_INFO *buf,
> +	struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *buf,
>  	char *full_path, int xid)
>  {
>  	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
> @@ -207,11 +207,11 @@ client_can_cache:
>  		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
>  					 xid, NULL);
>  
> -	if ((*oplock & 0xF) == OPLOCK_EXCLUSIVE) {
> +	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
>  		pCifsInode->clientCanCacheAll = true;
>  		pCifsInode->clientCanCacheRead = true;
>  		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
> -	} else if ((*oplock & 0xF) == OPLOCK_READ)
> +	} else if ((oplock & 0xF) == OPLOCK_READ)
>  		pCifsInode->clientCanCacheRead = true;
>  
>  	return rc;
> @@ -365,7 +365,7 @@ int cifs_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> -	rc = cifs_open_inode_helper(inode, tcon, &oplock, buf, full_path, xid);
> +	rc = cifs_open_inode_helper(inode, tcon, oplock, buf, full_path, xid);
>  	if (rc != 0)
>  		goto out;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
