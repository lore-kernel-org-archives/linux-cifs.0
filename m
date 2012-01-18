From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] ACL and FSCACHE support no longer EXPERIMENTAL
Date: Wed, 18 Jan 2012 18:49:45 -0500
Message-ID: <20120118184945.6e25d738@tlielax.poochiereds.net>
References: <CAH2r5msw4LesNZPo5_nrGpP=gCtsTHmxEmHA5i2ihs6wKjLpVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msw4LesNZPo5_nrGpP=gCtsTHmxEmHA5i2ihs6wKjLpVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 18 Jan 2012 17:21:26 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> commit 8194589ef0caae455f602a1a841744d8019374f9
> Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Jan 18 17:19:11 2012 -0600
> 
>     [CIFS] ACL and FSCACHE support no longer EXPERIMENTAL
> 
>     CIFS ACL support and FSCACHE support have been in long enough
>     to be no longer considered experimental.  Remove obsolete Kconfig
>     dependency.
> 
>     Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index f66cc16..0554b00 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -140,7 +140,6 @@ config CIFS_DFS_UPCALL
> 
>  config CIFS_FSCACHE
>  	  bool "Provide CIFS client caching support (EXPERIMENTAL)"
> -	  depends on EXPERIMENTAL
>  	  depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
>  	  help
>  	    Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
> @@ -149,7 +148,7 @@ config CIFS_FSCACHE
> 
>  config CIFS_ACL
>  	  bool "Provide CIFS ACL support (EXPERIMENTAL)"
> -	  depends on EXPERIMENTAL && CIFS_XATTR && KEYS
> +	  depends on CIFS_XATTR && KEYS
>  	  help
>  	    Allows to fetch CIFS/NTFS ACL from the server.  The DACL blob
>  	    is handed over to the application/caller.
> 

Sure, why not...

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
