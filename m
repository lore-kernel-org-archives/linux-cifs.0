From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Q: cifs, freeing volume_info->UNCip
Date: Thu, 18 Aug 2011 06:42:13 -0400
Message-ID: <20110818064213.0e4d459d@corrin.poochiereds.net>
References: <7087.1313450537@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirk w <kirkpuppy-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
To: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7087.1313450537@jrobl>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Aug 2011 08:22:17 +0900
"J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org> wrote:

> 
> Hello,
> 
> CIFS cleanup_volume_info_contents() looks like having a memory
> corruption problem.
> When UNCip is set to "&vol->UNC[2]" in cifs_parse_mount_options(), it
> should not be kfree()-ed in cleanup_volume_info_contents().
> 
> If it is correct and the code in mainline is not fixed yet, then here is
> a patch.
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccc1afa..e0ea721 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
>  	kfree(volume_info->username);
>  	kzfree(volume_info->password);
>  	kfree(volume_info->UNC);
> -	kfree(volume_info->UNCip);
> +	if (volume_info->UNCip != volume_info->UNC + 2)
> +		kfree(volume_info->UNCip);
>  	kfree(volume_info->domainname);
>  	kfree(volume_info->iocharset);
>  	kfree(volume_info->prepath);
> 
> 

Also, this patch should obviously go to stable too.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
