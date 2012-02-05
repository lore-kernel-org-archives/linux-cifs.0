From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NULL pointer dereference in
 cifs_construct_tcon()
Date: Sun, 5 Feb 2012 06:22:04 -0500
Message-ID: <20120205062204.763bdab6@tlielax.poochiereds.net>
References: <alpine.LNX.2.00.1202050030520.30244@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1202050030520.30244-h2p7t3/P30RzeRGmFJ5qR7ZzlVVXadcDXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 5 Feb 2012 00:35:19 +0100 (CET)
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> wrote:

> If the call to kcalloc() fails and returns NULL we'll dereference a
> NULL 'vol_info' after we jump to the 'out:' label.
> 
> Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
> ---
>  fs/cifs/connect.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 986709a..bd67b7c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3859,7 +3859,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
>  	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
>  	if (vol_info == NULL) {
>  		tcon = ERR_PTR(-ENOMEM);
> -		goto out;
> +		goto out2;
>  	}
>  
>  	vol_info->local_nls = cifs_sb->local_nls;
> @@ -3901,7 +3901,7 @@ out:
>  	kfree(vol_info->username);
>  	kfree(vol_info->password);
>  	kfree(vol_info);
> -
> +out2:
>  	return tcon;
>  }
>  

Thanks. Dan Carpenter already sent a patch a couple of weeks ago to fix
this. Steve has it in his tree, but hasn't pushed it to Linus yet.

Steve, is there a reason you're waiting?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
