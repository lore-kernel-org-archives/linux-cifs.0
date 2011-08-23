From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs-utils: cifsacl utilities: Add configure and
 make directives
Date: Tue, 23 Aug 2011 08:56:26 -0400
Message-ID: <20110823085626.4b7014b1@corrin.poochiereds.net>
References: <1313810867-2340-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313810867-2340-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Aug 2011 22:27:47 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> autoconf and automake directives to build utilities getcifsacl
> and setcifsacl.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am  |   24 +++++++++++++++++++++++-
>  configure.ac |   25 ++++++++++++++++++++++++-
>  2 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 4938447..7d4bdea 100644
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
> @@ -50,3 +50,25 @@ clean-local-idmap:
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
> +sbin_PROGRAMS += setcifsacl
> +setcifsacl_SOURCES = setcifsacl.c
> +setcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
> +man_MANS += setcifsacl.8
> +
> +getcifsacl.8: getcifsacl.8.in
> +	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> +setcifsacl.8: setcifsacl.8.in
> +	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
> +endif
> +
> +clean-local-aclprogs:
> +if CONFIG_CIFSACL
> +	rm -f getcifsacl.8 getcifsacl.8-t setcifsacl.8 setcifsacl.8-t
> +endif
> diff --git a/configure.ac b/configure.ac
> index 780abe7..5b2bc6d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -28,13 +28,19 @@ AC_ARG_ENABLE(cifsidmap,
>  	enable_cifsidmap=$enableval,
>  	enable_cifsidmap="maybe")
>  
> +AC_ARG_ENABLE(cifsacl,
> +	[AC_HELP_STRING([--enable-cifsacl],
> +			[Create get/set cifsacl binary @<:@default=no@:>@])],
> +	enable_cifsacl=$enableval,
> +	enable_cifsacl="maybe")
> +

It looks like this will be built by default, so the default=no is
clearly wrong. Either you need to fix the help string or set
enable_cifsacl to "no" here.

>  # Checks for programs.
>  AC_PROG_CC
>  AC_PROG_SED
>  AC_GNU_SOURCE
>  
>  # Checks for header files.
> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h sys/xattr.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>  

^^^^
We should not fail the entire build if sys/xattr.h cannot be found. The
"core" tool (mount.cifs) does not require it. I suggest conditionally
checking for it in a similar fashion as wbclient.h

>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> @@ -94,6 +100,22 @@ if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
>  				fi
>  			])
>  fi
> +if test $enable_cifsacl != "no"; then
> +	AC_CHECK_HEADERS([wbclient.h], , [
> +				if test "$enable_cifsupcall" = "yes"; then
> +					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> +				else
> +					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling get/setcifsacl.])
> +					enable_cifsacl="no"
> +				fi
> +				if test "$enable_cifsacl" = "yes"; then
> +					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel.])
> +				else
> +					AC_MSG_WARN([wbclient.h not found, consider installing libwbclient-devel. Disabling get/setcifsacl.])
> +					enable_cifsacl="no"
> +				fi
> +			])
> +fi
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_LIB([krb5], [krb5_init_context],
>  			[ KRB5_LDADD='-lkrb5' ],
> @@ -156,6 +178,7 @@ LIBS=$cu_saved_libs
>  AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
>  AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
>  AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
> +AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
>  
>  LIBCAP_NG_PATH
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
