From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Fri, 10 Feb 2012 13:22:16 -0500
Message-ID: <20120210132216.03badf59@tlielax.poochiereds.net>
References: <1328810892-21925-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328810892-21925-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  9 Feb 2012 21:08:12 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Currently we do inc_nlink/drop_nlink for a parent directory for every
> mkdir and rmdir calls. That's wrong when POSIX extensions are disabled
> because in this case a server doesn't do the same things and returns
> the old value on the next QueryInfo request. As the result, we update
> our value with the server one and then decrement it on every rmdir
> call - go to negative nlink values.
> 
> Fix this by doing inc_nlink/drop_nlink for parent directory in mkdir
> and rmdir in POSIX case only. Also add cERROR when nlink value <= 2
> and we still try to decrement it (possible broken servers).
> 

Rather than doing that, I think it would be better not to do the
inc/dec_nlink in either case and instead to set cifsi->time on the
parent to 0 for both cases.

That should force it to have the directory attributes refetched at the
next opportunity. Since we're not doing that now, we're likely missing
out on stuff like directory mtime changes as well.

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/inode.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index a5f54b7..9af6ec7 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1355,11 +1355,11 @@ mkdir_retry_old:
>  		d_drop(direntry);
>  	} else {
>  mkdir_get_info:
> -		inc_nlink(inode);
> -		if (pTcon->unix_ext)
> +		if (pTcon->unix_ext) {
> +			inc_nlink(inode);
>  			rc = cifs_get_inode_info_unix(&newinode, full_path,
>  						      inode->i_sb, xid);
> -		else
> +		} else
>  			rc = cifs_get_inode_info(&newinode, full_path, NULL,
>  						 inode->i_sb, xid, NULL);
>  
> @@ -1475,7 +1475,13 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  	cifs_put_tlink(tlink);
>  
>  	if (!rc) {
> -		drop_nlink(inode);
> +		if (pTcon->unix_ext) {
> +			if (inode->i_nlink > 2)
> +				drop_nlink(inode);
> +			else
> +				cERROR(1, "%s: unexpected nlink number(%u)",
> +				       __func__, inode->i_nlink);
> +		}
>  		spin_lock(&direntry->d_inode->i_lock);
>  		i_size_write(direntry->d_inode, 0);
>  		clear_nlink(direntry->d_inode);


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
