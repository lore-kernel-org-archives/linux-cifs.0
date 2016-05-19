From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the security tree
Date: Thu, 19 May 2016 11:11:49 +0100
Message-ID: <12307.1463652709@warthog.procyon.org.uk>
References: <20160519140120.23b345a1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519140120.23b345a1-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Content-ID: <12306.1463652709.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:

> From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> Date: Thu, 19 May 2016 13:45:10 +1000
> Subject: [PATCH] cifs: fix for keyringalloc() API change
> 
> Signed-off-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> ---
>  fs/cifs/cifs_spnego.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 248ab431930c..9ef0dfcb2f95 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -207,7 +207,7 @@ init_cifs_spnego(void)
>  				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
>  				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
>  				KEY_USR_VIEW | KEY_USR_READ,
> -				KEY_ALLOC_NOT_IN_QUOTA, NULL);
> +				KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
>  	if (IS_ERR(keyring)) {
>  		ret = PTR_ERR(keyring);
>  		goto failed_put_cred;

This looks correct.

David
