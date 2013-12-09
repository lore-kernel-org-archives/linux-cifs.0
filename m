From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count
 check
Date: Mon, 9 Dec 2013 06:03:21 -0500
Message-ID: <20131209060321.030be558@tlielax.poochiereds.net>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
	<1386536924-51726-4-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dean Gehnert <deang-l6nL5VImRDY@public.gmane.org>
To: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386536924-51726-4-git-send-email-timg-l6nL5VImRDY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun,  8 Dec 2013 14:08:43 -0700
Tim Gardner <timg-l6nL5VImRDY@public.gmane.org> wrote:

> The reference count on tlink can only be decremented if
> cifs_sb_tlink(cifs_sb) was used to acquire it. That only
> happens if open_file==NULL.
> 
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Dean Gehnert <deang-l6nL5VImRDY@public.gmane.org>
> Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
> ---
> 
> V2 - this is a new patch in the V2 series.
> 
>  fs/cifs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3f710c6..e332038 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  			CIFSSMBClose(xid, tcon, netfid);
>  		}
>  	}
> -	if (tlink)
> +	if (!open_file)
>  		cifs_put_tlink(tlink);
>  
>  set_size_out:


I don't see the bug here...

The only place tlink gets set to a non-NULL value is where
cifs_sb_tlink gets called. Am I missing something?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
