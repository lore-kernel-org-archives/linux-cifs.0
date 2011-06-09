From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix sparse error
Date: Thu, 9 Jun 2011 07:11:05 -0400
Message-ID: <20110609071105.097ebf4b@corrin.poochiereds.net>
References: <1307609933-5632-1-git-send-email-piastryyy@gmail.com>
	<1307609933-5632-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307609933-5632-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  9 Jun 2011 12:58:53 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> cifs_sb_master_tlink was declared as inline, but without a definition.
> Remove the declaration and move the definition up.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 23addcb..76a6670 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2203,7 +2203,10 @@ cifs_put_tlink(struct tcon_link *tlink)
>  }
>  
>  static inline struct tcon_link *
> -cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
> +{
> +	return cifs_sb->master_tlink;
> +}
>  
>  static int
>  compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
> @@ -3538,12 +3541,6 @@ out:
>  	return tcon;
>  }
>  
> -static inline struct tcon_link *
> -cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
> -{
> -	return cifs_sb->master_tlink;
> -}
> -
>  struct cifs_tcon *
>  cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
>  {

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
