From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Fix building with autoconf version older than 2.60.
Date: Mon, 9 Jul 2012 14:01:16 -0400
Message-ID: <20120709140116.2bcebdb9@tlielax.poochiereds.net>
References: <1341854687-17786-1-git-send-email-asn@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Schneider <asn-a6JcYMd0PQ1abyy8hY48cw@public.gmane.org>
To: Andreas Schneider <asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341854687-17786-1-git-send-email-asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  9 Jul 2012 19:24:47 +0200
Andreas Schneider <asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> From: Andreas Schneider <asn-a6JcYMd0PQ1abyy8hY48cw@public.gmane.org>
> 
> AC_PROG_SED is only avaliable in recent autoconf versions.
> Use AC_CHECK_PROG instead if AC_PROG_SED is not present.
> 
> Signed-off-by: Andreas Schneider <asn-a6JcYMd0PQ1abyy8hY48cw@public.gmane.org>
> ---
>  configure.ac |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 0dd1155..f95a2de 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -44,10 +44,15 @@ AC_ARG_VAR(ROOTSBINDIR, [Location where files ordinarily under /sbin should be i
>  
>  # Checks for programs.
>  AC_PROG_CC
> -AC_PROG_SED
>  AC_GNU_SOURCE
>  AM_PROG_CC_C_O
>  
> +# AC_PROG_SED is only avaliable in recent autoconf versions.
> +# Use AC_CHECK_PROG instead if AC_PROG_SED is not present.
> +ifdef([AC_PROG_SED],
> +      [AC_PROG_SED],
> +      [AC_CHECK_PROG(SED, sed, sed)])
> +
>  # Checks for typedefs, structures, and compiler characteristics.
>  AC_HEADER_STDBOOL
>  AC_TYPE_UID_T

Looks fine...

The AC_PROG_SED in the later versions of autoconf do quite a bit more
to verify that sed actually works, but our use of sed is very simple in
cifs-utils so this should be ok.

I'll plan to commit the patch in a day or two if no one objects.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
