From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Invalidate inode pages on the last close
Date: Mon, 1 Nov 2010 09:41:55 -0400
Message-ID: <20101101094155.13d43eea@tlielax.poochiereds.net>
References: <AANLkTi=ZzzjuH-yzgkCWCpm3g7UoBXM8rLgWdUVzj2VO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ZzzjuH-yzgkCWCpm3g7UoBXM8rLgWdUVzj2VO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 31 Oct 2010 22:42:40 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> When we close the last file handle of the inode we should invalidate it
> to prevent data coherency problem when we open it again but it has been
> modified by other clients.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d7c212a..6edeb5b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -290,6 +290,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>  			cifs_file->dentry->d_inode);
>  		cifsi->clientCanCacheRead = false;
>  		cifsi->clientCanCacheAll  = false;
> +		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> +			invalidate_remote_inode(inode);
>  	}
>  	spin_unlock(&cifs_file_list_lock);
> 

NAK. I don't think it's safe to call invalidate_remote_inode under a
spinlock like this.

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
