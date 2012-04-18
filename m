From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] autoconf: fix tests for wbclient to use pkgconfig
Date: Wed, 18 Apr 2012 15:53:38 -0400
Message-ID: <20120418155338.3364cf5b@corrin.poochiereds.net>
References: <1334406772-5533-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334406772-5533-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 14 Apr 2012 08:32:52 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Use the pkgconfig file that's included with wbclient to perform the test
> for wbclient usability, and to set the correct CFLAGS and LDADD.
> 
> This is particularly necessary on recent Fedora with samba4 since it
> puts the wbclient.h file in a different directory than before.
> 
> Also, remove a redundant test for wbclient.h from configure.ac.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am      |    9 ++++++---
>  aclocal/idmap.m4 |   37 +++----------------------------------
>  configure.ac     |   15 ---------------
>  3 files changed, 9 insertions(+), 52 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 924c99e..17ad8e1 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -41,7 +41,8 @@ endif
>  if CONFIG_CIFSIDMAP
>  sbin_PROGRAMS += cifs.idmap
>  cifs_idmap_SOURCES = cifs.idmap.c
> -cifs_idmap_LDADD = -lkeyutils $(WINB_LDADD)
> +cifs_idmap_LDADD = -lkeyutils $(WBCLIENT_LIBS)
> +cifs_idmap_CFLAGS = $(WBCLIENT_CFLAGS)
>  man_MANS += cifs.idmap.8
>  
>  cifs.idmap.8: cifs.idmap.8.in
> @@ -56,12 +57,14 @@ endif
>  if CONFIG_CIFSACL
>  bin_PROGRAMS += getcifsacl
>  getcifsacl_SOURCES = getcifsacl.c
> -getcifsacl_LDADD = $(WINB_LDADD)
> +getcifsacl_LDADD = $(WBCLIENT_LIBS)
> +getcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
>  man_MANS += getcifsacl.1
>  
>  bin_PROGRAMS += setcifsacl
>  setcifsacl_SOURCES = setcifsacl.c
> -setcifsacl_LDADD = $(WINB_LDADD)
> +setcifsacl_LDADD = $(WBCLIENT_LIBS)
> +setcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
>  man_MANS += setcifsacl.1
>  
>  endif
> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> index ada73f0..70a0649 100644
> --- a/aclocal/idmap.m4
> +++ b/aclocal/idmap.m4
> @@ -1,33 +1,8 @@
> -dnl Headers needed by wbclient.h
> -dnl
> -AC_DEFUN([AC_WBCH_COMPL],[
> -[
> -#ifdef HAVE_STDINT_H
> -#include <stdint.h>
> -#endif
> -]
> -[#ifdef HAVE_STDBOOL_H
> -#include <stdbool.h>
> -#endif
> -]
> -[#ifdef HAVE_STDIO_H
> -#include <stdio.h>
> -#endif
> -]
> -[#ifdef HAVE_STDLIB_H
> -#include <stdlib.h>
> -#endif
> -]
> -[#ifdef HAVE_ERRNO_H
> -#include <errno.h>
> -#endif
> -]])
> -
> -dnl Check for wbclient.h header and libwbclient.so
> +dnl Check for wbclient package
>  dnl
>  AC_DEFUN([AC_TEST_WBCHL],[
>  if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
> -	AC_CHECK_HEADERS([wbclient.h], , [
> +	PKG_CHECK_MODULES(WBCLIENT, wbclient, , [
>  				if test "$enable_cifsidmap" = "yes"; then
>  					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
>  				else
> @@ -40,7 +15,7 @@ if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
>  					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling cifsacl.])
>  					enable_cifsacl="no"
>  				fi
> -			], [ AC_WBCH_COMPL ])
> +			])
>  fi
>  
>  if test $enable_cifsacl != "no"; then
> @@ -53,10 +28,4 @@ if test $enable_cifsacl != "no"; then
>  				fi
>  			], [ ])
>  fi
> -
> -if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
> -	AC_CHECK_LIB([wbclient], [wbcStringToSid],
> -		[ WINB_LDADD='-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERROR([No functioning wbclient library found!])])
> -	AC_SUBST(WINB_LDADD)
> -fi
>  ])
> diff --git a/configure.ac b/configure.ac
> index 1f561f5..9b5ce15 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -139,21 +139,6 @@ if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
>  				fi
>  			])
>  fi
> -if test $enable_cifsacl != "no"; then
> -	AC_CHECK_HEADERS([wbclient.h], , [
> -				if test "$enable_cifsacl" = "yes"; then
> -					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> -				else
> -					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling getcifsacl.])
> -					enable_cifsacl="no"
> -				fi
> -			],
> -			[AC_INCLUDES_DEFAULT]
> -			[#ifdef HAVE_STDBOOL_H
> -			    #include <stdbool.h>
> -			    #endif
> -			])
> -fi
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_LIB([krb5], [krb5_init_context],
>  			[ KRB5_LDADD='-lkrb5' ],

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
