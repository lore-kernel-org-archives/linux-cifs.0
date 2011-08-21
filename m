From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix ERR_PTR dereference in cifs_get_root
Date: Sun, 21 Aug 2011 12:22:51 -0400
Message-ID: <20110821122251.1e3c05bc@tlielax.poochiereds.net>
References: <1313940615-3347-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313940615-3347-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 21 Aug 2011 19:30:15 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> move it to the beginning of the loop.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 0435bb9..8b79122 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -559,6 +559,12 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  		struct inode *dir = dentry->d_inode;
>  		struct dentry *child;
>  
> +		if (!dir) {
> +			dput(dentry);
> +			dentry = ERR_PTR(-ENOENT);
> +			break;
> +		}
> +
>  		/* skip separators */
>  		while (*s == sep)
>  			s++;
> @@ -574,10 +580,6 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  		mutex_unlock(&dir->i_mutex);
>  		dput(dentry);
>  		dentry = child;
> -		if (!dentry->d_inode) {
> -			dput(dentry);
> -			dentry = ERR_PTR(-ENOENT);
> -		}
>  	} while (!IS_ERR(dentry));
>  	_FreeXid(xid);
>  	kfree(full_path);

What exactly does this fix? The only possible thing I could see it is
if sb->s_root was a negative dentry, and I'm not sure that would ever
happen. Would it?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
