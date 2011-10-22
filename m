From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix DFS handling in cifs_get_file_info
Date: Sat, 22 Oct 2011 07:06:56 -0400
Message-ID: <20111022070656.4eb6129c@tlielax.poochiereds.net>
References: <1319279870-17657-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319279870-17657-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 22 Oct 2011 14:37:50 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> We should call cifs_all_info_to_fattr in rc == 0 case only.
> 
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/inode.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 663c4e3..2c50bd2 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -562,7 +562,16 @@ int cifs_get_file_info(struct file *filp)
>  
>  	xid = GetXid();
>  	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
> -	if (rc == -EOPNOTSUPP || rc == -EINVAL) {
> +	switch (rc) {
> +	case 0:
> +		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
> +		break;
> +	case -EREMOTE:
> +		cifs_create_dfs_fattr(&fattr, inode->i_sb);
> +		rc = 0;
> +		break;
> +	case -EOPNOTSUPP:
> +	case -EINVAL:
>  		/*
>  		 * FIXME: legacy server -- fall back to path-based call?
>  		 * for now, just skip revalidating and mark inode for
> @@ -570,18 +579,14 @@ int cifs_get_file_info(struct file *filp)
>  		 */
>  		rc = 0;
>  		CIFS_I(inode)->time = 0;
> +	default:
>  		goto cgfi_exit;
> -	} else if (rc == -EREMOTE) {
> -		cifs_create_dfs_fattr(&fattr, inode->i_sb);
> -		rc = 0;
> -	} else if (rc)
> -		goto cgfi_exit;
> +	}
>  
>  	/*
>  	 * don't bother with SFU junk here -- just mark inode as needing
>  	 * revalidation.
>  	 */
> -	cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
>  	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
>  	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
>  	cifs_fattr_to_inode(inode, &fattr);

I think this looks fine. Did you actually see a problem with this or
did you notice it by inspection?

It doesn't seem like we'd ever hit the EREMOTE case here. If we have
a DFS referral, won't we typically get the EREMOTE during the QPathInfo
call (i.e. during the lookup) ?

Either way it's probably worthwhile to fix...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
