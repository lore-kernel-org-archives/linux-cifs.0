From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH][Trivial] CIFS: Don't free volume_info->UNC until we are
 entirely done with it.
Date: Mon, 29 Aug 2011 11:40:41 -0400
Message-ID: <20110829114041.6c1a0a4e@tlielax.poochiereds.net>
References: <alpine.LNX.2.00.1108271851470.27813@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1108271851470.27813-h2p7t3/P30RzeRGmFJ5qR7ZzlVVXadcDXqFh9Ls21Oc@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 27 Aug 2011 18:58:34 +0200 (CEST)
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org> wrote:

> In cleanup_volume_info_contents() we kfree(volume_info->UNC); and then 
> proceed to use that variable on the very next line.
> This causes (at least) Coverity Prevent to complain about use-after-free 
> of that variable (and I guess other checkers may do that as well).
> There's not any /real/ problem here since we are just using the value of 
> the pointer, not actually dereferencing it, but it's still trivial to 
> silence the tool, so why not?
> To me at least it also just seems nicer to defer freeing the variable 
> until we are entirely done with it in all respects.
> 
> Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 633c246..9bb4b10 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2877,9 +2877,9 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
>  {
>  	kfree(volume_info->username);
>  	kzfree(volume_info->password);
> -	kfree(volume_info->UNC);
>  	if (volume_info->UNCip != volume_info->UNC + 2)
>  		kfree(volume_info->UNCip);
> +	kfree(volume_info->UNC);
>  	kfree(volume_info->domainname);
>  	kfree(volume_info->iocharset);
>  	kfree(volume_info->prepath);

Seems reasonable for silencing the checker...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
