From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 7/8] cifs-utils: cifsacl utilities: Add configure and
 make directives for cifsacl (try #2)
Date: Thu, 25 Aug 2011 14:34:02 -0400
Message-ID: <20110825143402.31dbfd5e@barsoom.rdu.redhat.com>
References: <1314126264-12107-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314126264-12107-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 23 Aug 2011 14:04:24 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Add configure directives for option cifsacl.  The default action is
> to enable cifsacl option.
> cifsacl option is enabled or disabled in a similar way to cifs.idmap
> in the same function. In addition, for cifsacl, check for sys/xattr.h
> is done in the smae .m4 file.
> 
> Add directives to build getcifsacl in Makefile.
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am      |   17 ++++++++++++++++-
>  aclocal/idmap.m4 |   23 ++++++++++++++++++++---
>  configure.ac     |   17 +++++++++++++++++
>  3 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 4938447..3ec6b7e 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -9,7 +9,7 @@ mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
>  man_MANS = mount.cifs.8
>  
>  sbin_PROGRAMS =
> -clean-local: clean-local-upcall clean-local-idmap
> +clean-local: clean-local-upcall clean-local-idmap clean-local-aclprogs
>  
>  if CONFIG_CIFSUPCALL
>  sbin_PROGRAMS += cifs.upcall
> @@ -50,3 +50,18 @@ clean-local-idmap:
>  if CONFIG_CIFSIDMAP
>  	rm -f cifs.idmap.8 cifs.idmap.8-t
>  endif
> +
> +if CONFIG_CIFSACL
> +sbin_PROGRAMS += getcifsacl
> +getcifsacl_SOURCES = getcifsacl.c
> +getcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
> +man_MANS += getcifsacl.8
> +
> +getcifsacl.8: getcifsacl.8.in
> +	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> +endif
> +
> +clean-local-aclprogs:
> +if CONFIG_CIFSACL
> +	rm -f getcifsacl.8 getcifsacl.8-t
> +endif
> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> index 211d372..ada73f0 100644
> --- a/aclocal/idmap.m4
> +++ b/aclocal/idmap.m4
> @@ -23,10 +23,10 @@ AC_DEFUN([AC_WBCH_COMPL],[
>  #endif
>  ]])
>  
> -dnl Check for wbclient.h header and libwbclietn.so
> +dnl Check for wbclient.h header and libwbclient.so
>  dnl
>  AC_DEFUN([AC_TEST_WBCHL],[
> -if test $enable_cifsidmap != "no"; then
> +if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
>  	AC_CHECK_HEADERS([wbclient.h], , [
>  				if test "$enable_cifsidmap" = "yes"; then
>  					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> @@ -34,10 +34,27 @@ if test $enable_cifsidmap != "no"; then
>  					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling cifs.idmap.])
>  					enable_cifsidmap="no"
>  				fi
> +				if test "$enable_cifsacl" = "yes"; then
> +					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> +				else
> +					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling cifsacl.])
> +					enable_cifsacl="no"
> +				fi
>  			], [ AC_WBCH_COMPL ])
>  fi
>  
> -if test $enable_cifsidmap != "no"; then
> +if test $enable_cifsacl != "no"; then
> +	AC_CHECK_HEADERS([sys/xattr.h], , [
> +				if test "$enable_cifsacl" = "yes"; then
> +					AC_MSG_ERROR([/usr/include/sys/xattr.h not found])
> +				else
> +					AC_MSG_WARN([/usr/include/sys/xattr.h not found. Disabling cifsacl.])
> +					enable_cifsacl="no"
> +				fi
> +			], [ ])
> +fi
> +
> +if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
>  	AC_CHECK_LIB([wbclient], [wbcStringToSid],
>  		[ WINB_LDADD='-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERROR([No functioning wbclient library found!])])
>  	AC_SUBST(WINB_LDADD)
> diff --git a/configure.ac b/configure.ac
> index 780abe7..293415f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -28,6 +28,12 @@ AC_ARG_ENABLE(cifsidmap,
>  	enable_cifsidmap=$enableval,
>  	enable_cifsidmap="maybe")
>  
> +AC_ARG_ENABLE(cifsacl,
> +	[AC_HELP_STRING([--enable-cifsacl],
> +			[Create get/set cifsacl binary @<:@default=yes@:>@])],
> +	enable_cifsacl=$enableval,
> +	enable_cifsacl="maybe")
> +
>  # Checks for programs.
>  AC_PROG_CC
>  AC_PROG_SED
> @@ -94,6 +100,16 @@ if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
>  				fi
>  			])
>  fi
> +if test $enable_cifsacl != "no"; then
> +	AC_CHECK_HEADERS([wbclient.h], , [
> +				if test "$enable_cifsacl" = "yes"; then
> +					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> +				else
> +					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling getcifsacl.])
> +					enable_cifsacl="no"
> +				fi
> +			])
> +fi
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_LIB([krb5], [krb5_init_context],
>  			[ KRB5_LDADD='-lkrb5' ],
> @@ -156,6 +172,7 @@ LIBS=$cu_saved_libs
>  AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
>  AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
>  AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
> +AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
>  
>  LIBCAP_NG_PATH
>  
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


I started pulling these in and ran into a snag...

checking wbclient.h presence... yes
configure: WARNING: wbclient.h: present but cannot be compiled
configure: WARNING: wbclient.h:     check for missing prerequisite headers?
configure: WARNING: wbclient.h: see the Autoconf documentation
configure: WARNING: wbclient.h:     section "Present But Cannot Be Compiled"
configure: WARNING: wbclient.h: proceeding with the compiler's result
configure: WARNING:     ## ----------------------------------- ##
configure: WARNING:     ## Report this to cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org ##
configure: WARNING:     ## ----------------------------------- ##

...according to config.log:

configure:4410: gcc -c -g -O2  conftest.c >&5
In file included from conftest.c:84:0:
/usr/include/wbclient.h:664:5: error: unknown type name 'bool'
configure:4410: $? = 1
configure: failed program was:

...this looks like a bug in wbclient.h, actually. It should be
including stdbool.h before trying to use a bool. Unfortunately though,
we're likely going to need to work around this bug. I know there's a
way to make autoconf tests pull in extra includes, but I don't have my
autoconf book handy.

Shirish, can you look into this, fix it and resubmit this patch?

Simo tells me there's an open samba bug to fix this...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
