From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: unused variables
Date: Mon, 21 May 2012 08:22:54 -0400
Message-ID: <20120521082254.59596de7@corrin.poochiereds.net>
References: <1337417534-14128-1-git-send-email-luk@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337417534-14128-1-git-send-email-luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 19 May 2012 10:52:14 +0200
Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:

> ---
>  mount.cifs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 2d1d842..a1b0454 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -525,13 +525,13 @@ free_caps:
>  }
>  #else /* HAVE_LIBCAP */
>  static int
> -drop_capabilities(int parent)
> +drop_capabilities(int parent __attribute((unused)))
>  {
>  	return 0;
>  }
>  
>  static int
> -toggle_dac_capability(int writable, int enable)
> +toggle_dac_capability(int writable __attribute((unused)), int enable __attribute((unused)))
>  {
>  	return 0;
>  }

Thanks, merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
