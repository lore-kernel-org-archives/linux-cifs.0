From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] autoconf: add --enable-pie and --enable-relro
Date: Tue, 10 Jul 2012 13:17:29 -0400
Message-ID: <20120710131729.1a209e0e@tlielax.poochiereds.net>
References: <1341843174-22470-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341843174-22470-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  9 Jul 2012 10:12:54 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> -pie and -fpie enable the building of position-independent executables,
> and -Wl,-z,relro turns on read-only relocation support in gcc. These
> options are important for security purposes to guard against possible
> buffer overflows that lead to exploits.
> 
> Follow the example of samba here and enable these by default, but add
> configure options that allow people to turn them off at build-time if
> necessary.
> 
> We may also want to eventually add checks to ensure that the compiler
> and linker understand these options, but I'll wait until we have some
> evidence that it's needed before I expend the effort.
> 
> Reported-by: Andreas Schneider <asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am  |    2 +-
>  configure.ac |   27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index b412262..0d0b599 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,4 +1,4 @@
> -AM_CFLAGS = -Wall -Wextra -D_FORTIFY_SOURCE=2
> +AM_CFLAGS = -Wall -Wextra -D_FORTIFY_SOURCE=2 $(PIE_CFLAGS) $(RELRO_CFLAGS)
>  ACLOCAL_AMFLAGS = -I aclocal
>  
>  root_sbindir = $(ROOTSBINDIR)
> diff --git a/configure.ac b/configure.ac
> index 0dd1155..a8d0bbc 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -10,6 +10,18 @@ AC_CONFIG_MACRO_DIR(aclocal)
>  AM_INIT_AUTOMAKE
>  
>  # "enable" options
> +AC_ARG_ENABLE(pie,
> +	[AC_HELP_STRING([--enable-pie],
> +			[Produce position independent executables @<:@default=yes@:>@])],
> +	enable_pie=$enableval,
> +	enable_pie="maybe")
> +
> +AC_ARG_ENABLE(relro,
> +	[AC_HELP_STRING([--enable-relro],
> +			[Enable relocations read-only support @<:@default=yes@:>@])],
> +	enable_relro=$enableval,
> +	enable_relro="maybe")
> +
>  AC_ARG_ENABLE(cifsupcall,
>  	[AC_HELP_STRING([--enable-cifsupcall],
>  			[Create cifs.upcall binary @<:@default=yes@:>@])],
> @@ -82,6 +94,21 @@ AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb
>  AC_CHECK_HEADERS([sys/fsuid.h])
>  AC_CHECK_FUNC(setfsuid, , [AC_MSG_ERROR([System does not support setfsuid()])])
>  
> +# FIXME: add test(s) to autodisable these flags when compiler/linker don't support it
> +if test $enable_pie != "no"; then
> +	PIE_CFLAGS="-fpie -pie"
> +else
> +	PIE_CFLAGS=""
> +fi
> +AC_SUBST([PIE_CFLAGS])
> +
> +if test $enable_relro != "no"; then
> +	RELRO_CFLAGS="-Wl,-z,relro"
> +else
> +	RELRO_CFLAGS=""
> +fi
> +AC_SUBST([RELRO_CFLAGS])
> +
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
>  	if test x$ac_cv_header_krb5_krb5_h != xyes ; then

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
