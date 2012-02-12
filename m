From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: allow specifying rootsbindir at configure
 time
Date: Sun, 12 Feb 2012 07:34:02 -0500
Message-ID: <20120212073402.6e383242@tlielax.poochiereds.net>
References: <1328720579-31585-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328720579-31585-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  8 Feb 2012 12:02:59 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> ...via the $ROOTSBINDIR environment variable, and AC_ARG_VAR macro.
> The default is to use /sbin for this value, which only currently
> affects the installation location of mount.cifs.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am  |    2 +-
>  configure.ac |   10 +++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 6182965..924c99e 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,7 +1,7 @@
>  AM_CFLAGS = -Wall -Wextra
>  ACLOCAL_AMFLAGS = -I aclocal
>  
> -root_sbindir = "/sbin"
> +root_sbindir = $(ROOTSBINDIR)
>  root_sbin_PROGRAMS = mount.cifs
>  mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
>  mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
> diff --git a/configure.ac b/configure.ac
> index 4c715ab..02b1ef2 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -9,7 +9,7 @@ AC_CONFIG_MACRO_DIR(aclocal)
>  
>  AM_INIT_AUTOMAKE
>  
> -# "with" options
> +# "enable" options
>  AC_ARG_ENABLE(cifsupcall,
>  	[AC_HELP_STRING([--enable-cifsupcall],
>  			[Create cifs.upcall binary @<:@default=yes@:>@])],
> @@ -34,6 +34,14 @@ AC_ARG_ENABLE(cifsacl,
>  	enable_cifsacl=$enableval,
>  	enable_cifsacl="maybe")
>  
> +# check for ROOTSBINDIR environment var
> +if test -z $ROOTSBINDIR; then
> +	ROOTSBINDIR="/sbin"
> +	export ROOTSBINDIR
> +fi
> +
> +AC_ARG_VAR(ROOTSBINDIR, [Location where files ordinarily under /sbin should be installed. Note: unaffected by --prefix. @<:@default=/sbin@:>@])
> +
>  # Checks for programs.
>  AC_PROG_CC
>  AC_PROG_SED

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
