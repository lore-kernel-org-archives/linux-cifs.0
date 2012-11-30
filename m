From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: Remove unused cEVENT macro
Date: Fri, 30 Nov 2012 06:47:10 -0500
Message-ID: <20121130064710.1bcd227b@tlielax.poochiereds.net>
References: <cover.1354217746.git.joe@perches.com>
	<7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Nov 2012 11:37:18 -0800
Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:

> It uses an undefined KERN_EVENT and is itself unused.
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index c0c68bb..b0fc344 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -63,12 +63,6 @@ do {						\
>  /* debug event message: */
>  extern int cifsERROR;
>  
> -#define cEVENT(fmt, arg...)						\
> -do {									\
> -	if (cifsERROR)							\
> -		printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);	\
> -} while (0)
> -
>  /* error event message: e.g., i/o error */
>  #define cifserror(fmt, arg...)					\
>  do {								\
> @@ -88,7 +82,6 @@ do {						\
>   */
>  #else		/* _CIFS_DEBUG */
>  #define cERROR(set, fmt, arg...)
> -#define cEVENT(fmt, arg...)
>  #define cFYI(set, fmt, arg...)
>  #define cifserror(fmt, arg...)
>  #endif		/* _CIFS_DEBUG */

Yay! More cruft removal!

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
