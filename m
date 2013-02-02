From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: add autoconf test to make sure that
 libwbclient is usable
Date: Sat, 2 Feb 2013 05:19:10 -0500
Message-ID: <20130202051910.0fc08dae@tlielax.poochiereds.net>
References: <1359741425-7546-1-git-send-email-jlayton@samba.org>
	<CADT32eLPrepCyAV-KQrdWfnLN0QEaNRqbpd7GRYkGVKc10UUjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLPrepCyAV-KQrdWfnLN0QEaNRqbpd7GRYkGVKc10UUjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 1 Feb 2013 15:08:16 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Feb 1, 2013 at 11:57 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > The idmapwb plugin requires a usable wbcSidsToUnixIds() function. Check
> > to ensure that the wbclient library provides that symbol, and handle
> > it appropriately if it doesn't.
> >
> > If someone were so inclined they probably could fix idmapwb to fall
> > back to the older mapping functions if that symbol doesn't exist,
> > but for now this patch just makes it refuse to build the plugin.
> >
> > Reported-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  aclocal/idmap.m4 | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> > index 939a901..4946179 100644
> > --- a/aclocal/idmap.m4
> > +++ b/aclocal/idmap.m4
> > @@ -19,6 +19,26 @@ if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
> >                         ])
> >  fi
> >
> > +if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
> > +       ac_wbc_save_LDFLAGS="$LDFLAGS"
> > +       LDFLAGS="$LDFLAGS $WBCLIENT_LIBS"
> > +       AC_CHECK_LIB(wbclient, wbcSidsToUnixIds, , [
> > +                               if test "$enable_cifsidmap" = "yes"; then
> > +                                       AC_MSG_ERROR([wbclient library lacks wbcSidsToUnixIds().])
> > +                               else
> > +                                       AC_MSG_ERROR([wbclient library lacks wbcSidsToUnixIds(). Disabling cifs.idmap.])
> > +                                       enable_cifsidmap="no"
> > +                               fi
> > +                               if test "$enable_cifsacl" = "yes"; then
> > +                                       AC_MSG_ERROR([wbclient library lacks wbcSidsToUnixIds.])
> > +                               else
> > +                                       AC_MSG_WARN([wbclient library lacks wbcSidsToUnixIds(). Disabling cifsacl tools.])
> > +                                       enable_cifsacl="no"
> > +                               fi
> > +                       ])cifstest6:/usr/src/cifs.utils.012813.1/cifs-utils
> 
> # autoreconf
> 
> # /usr/src/cifs.utils.012813.1/cifs-utils # ./configure
> checking for a BSD-compatible install... /usr/bin/install -c
> checking whether build environment is sane... yes
> checking for a thread-safe mkdir -p... /bin/mkdir -p
> checking for gawk... gawk
> checking whether make sets $(MAKE)... yes
> checking for gcc... gcc
> checking for C compiler default output file name... a.out
> checking whether the C compiler works... yes
> checking whether we are cross compiling... no
> checking for suffix of executables...
> checking for suffix of object files... o
> checking whether we are using the GNU C compiler... yes
> checking whether gcc accepts -g... yes
> checking for gcc option to accept ISO C89... none needed
> checking for style of include used by make... GNU
> checking dependency style of gcc... gcc3
> checking how to run the C preprocessor... gcc -E
> checking for grep that handles long lines and -e... /usr/bin/grep
> checking for egrep... /usr/bin/grep -E
> checking for ANSI C header files... yes
> checking for sys/types.h... yes
> checking for sys/stat.h... yes
> checking for stdlib.h... yes
> checking for string.h... yes
> checking for memory.h... yes
> checking for strings.h... yes
> checking for inttypes.h... yes
> checking for stdint.h... yes
> checking for unistd.h... yes
> checking minix/config.h usability... no
> checking minix/config.h presence... no
> checking for minix/config.h... no
> checking whether it is safe to define __EXTENSIONS__... yes
> checking whether gcc and cc understand -c and -o together... yes
> checking for a sed that does not truncate output... /usr/bin/sed
> checking for stdbool.h that conforms to C99... yes
> checking for _Bool... yes
> checking for uid_t in sys/types.h... yes
> checking for off_t... yes
> checking for pid_t... yes
> checking for size_t... yes
> checking for ptrdiff_t... yes
> checking for ssize_t... yes
> checking for uint32_t... yes
> checking for uint8_t... yes
> checking for library containing getmntent... none required
> checking whether lstat dereferences a symlink specified with a
> trailing slash... yes
> checking for stdlib.h... (cached) yes
> checking for GNU libc compatible malloc... yes
> checking for stdlib.h... (cached) yes
> checking for GNU libc compatible realloc... yes
> checking for working strnlen... yes
> checking for alarm... yes
> checking for atexit... yes
> checking for endpwent... yes
> checking for getmntent... (cached) yes
> checking for getpass... yes
> checking for gettimeofday... yes
> checking for inet_ntop... yes
> checking for memset... yes
> checking for realpath... yes
> checking for setenv... yes
> checking for strchr... yes
> checking for strcmp... yes
> checking for strdup... yes
> checking for strerror... yes
> checking for strncasecmp... yes
> checking for strndup... yes
> checking for strpbrk... yes
> checking for strrchr... yes
> checking for strstr... yes
> checking for strtol... yes
> checking for strtoul... yes
> checking for tolower... yes
> checking for uname... yes
> checking for clock_gettime... no
> checking for clock_gettime in -lrt... yes
> checking arpa/inet.h usability... yes
> checking arpa/inet.h presence... yes
> checking for arpa/inet.h... yes
> checking ctype.h usability... yes
> checking ctype.h presence... yes
> checking for ctype.h... yes
> checking fcntl.h usability... yes
> checking fcntl.h presence... yes
> checking for fcntl.h... yes
> checking for inttypes.h... (cached) yes
> checking limits.h usability... yes
> checking limits.h presence... yes
> checking for limits.h... yes
> checking mntent.h usability... yes
> checking mntent.h presence... yes
> checking for mntent.h... yes
> checking netdb.h usability... yes
> checking netdb.h presence... yes
> checking for netdb.h... yes
> checking stddef.h usability... yes
> checking stddef.h presence... yes
> checking for stddef.h... yes
> checking for stdint.h... (cached) yes
> checking for stdbool.h... (cached) yes
> checking for stdlib.h... (cached) yes
> checking stdio.h usability... yes
> checking stdio.h presence... yes
> checking for stdio.h... yes
> checking errno.h usability... yes
> checking errno.h presence... yes
> checking for errno.h... yes
> checking for string.h... (cached) yes
> checking for strings.h... (cached) yes
> checking sys/mount.h usability... yes
> checking sys/mount.h presence... yes
> checking for sys/mount.h... yes
> checking sys/param.h usability... yes
> checking sys/param.h presence... yes
> checking for sys/param.h... yes
> checking sys/socket.h usability... yes
> checking sys/socket.h presence... yes
> checking for sys/socket.h... yes
> checking sys/time.h usability... yes
> checking sys/time.h presence... yes
> checking for sys/time.h... yes
> checking syslog.h usability... yes
> checking syslog.h presence... yes
> checking for syslog.h... yes
> checking for unistd.h... (cached) yes
> checking sys/fsuid.h usability... yes
> checking sys/fsuid.h presence... yes
> checking for sys/fsuid.h... yes
> checking for setfsuid... yes
> checking krb5.h usability... yes
> checking krb5.h presence... yes
> checking for krb5.h... yes
> checking krb5/krb5.h usability... yes
> checking krb5/krb5.h presence... yes
> checking for krb5/krb5.h... yes
> checking for keyvalue in krb5_keyblock... no
> checking talloc.h usability... yes
> checking talloc.h presence... yes
> checking for talloc.h... yes
> checking keyutils.h usability... yes
> checking keyutils.h presence... yes
> checking for keyutils.h... yes
> checking for krb5_init_context in -lkrb5... yes
> checking for pkg-config... /usr/bin/pkg-config
> checking pkg-config is at least version 0.9.0... yes
> checking for WBCLIENT... yes
> checking for wbcSidsToUnixIds in -lwbclient... no
> configure: error: wbclient library lacks wbcSidsToUnixIds(). Disabling
> cifs.idmap.
> 
> # /usr/src/cifs.utils.012813.1/cifs-utils # make
> /bin/sh ./config.status --recheck
> running CONFIG_SHELL=/bin/sh /bin/sh ./configure --no-create --no-recursion
> checking for a BSD-compatible install... /usr/bin/install -c
> checking whether build environment is sane... yes
> checking for a thread-safe mkdir -p... /bin/mkdir -p
> checking for gawk... gawk
> checking whether make sets $(MAKE)... yes
> checking for gcc... gcc
> checking for C compiler default output file name... a.out
> checking whether the C compiler works... yes
> checking whether we are cross compiling... no
> checking for suffix of executables...
> checking for suffix of object files... o
> checking whether we are using the GNU C compiler... yes
> checking whether gcc accepts -g... yes
> checking for gcc option to accept ISO C89... none needed
> checking for style of include used by make... GNU
> checking dependency style of gcc... gcc3
> checking how to run the C preprocessor... gcc -E
> checking for grep that handles long lines and -e... /usr/bin/grep
> checking for egrep... /usr/bin/grep -E
> checking for ANSI C header files... yes
> checking for sys/types.h... yes
> checking for sys/stat.h... yes
> checking for stdlib.h... yes
> checking for string.h... yes
> checking for memory.h... yes
> checking for strings.h... yes
> checking for inttypes.h... yes
> checking for stdint.h... yes
> checking for unistd.h... yes
> checking minix/config.h usability... no
> checking minix/config.h presence... no
> checking for minix/config.h... no
> checking whether it is safe to define __EXTENSIONS__... yes
> checking whether gcc and cc understand -c and -o together... yes
> checking for a sed that does not truncate output... /usr/bin/sed
> checking for stdbool.h that conforms to C99... yes
> checking for _Bool... yes
> checking for uid_t in sys/types.h... yes
> checking for off_t... yes
> checking for pid_t... yes
> checking for size_t... yes
> checking for ptrdiff_t... yes
> checking for ssize_t... yes
> checking for uint32_t... yes
> checking for uint8_t... yes
> checking for library containing getmntent... none required
> checking whether lstat dereferences a symlink specified with a
> trailing slash... yes
> checking for stdlib.h... (cached) yes
> checking for GNU libc compatible malloc... yes
> checking for stdlib.h... (cached) yes
> checking for GNU libc compatible realloc... yes
> checking for working strnlen... yes
> checking for alarm... yes
> checking for atexit... yes
> checking for endpwent... yes
> checking for getmntent... (cached) yes
> checking for getpass... yes
> checking for gettimeofday... yes
> checking for inet_ntop... yes
> checking for memset... yes
> checking for realpath... yes
> checking for setenv... yes
> checking for strchr... yes
> checking for strcmp... yes
> checking for strdup... yes
> checking for strerror... yes
> checking for strncasecmp... yes
> checking for strndup... yes
> checking for strpbrk... yes
> checking for strrchr... yes
> checking for strstr... yes
> checking for strtol... yes
> checking for strtoul... yes
> checking for tolower... yes
> checking for uname... yes
> checking for clock_gettime... no
> checking for clock_gettime in -lrt... yes
> checking arpa/inet.h usability... yes
> checking arpa/inet.h presence... yes
> checking for arpa/inet.h... yes
> checking ctype.h usability... yes
> checking ctype.h presence... yes
> checking for ctype.h... yes
> checking fcntl.h usability... yes
> checking fcntl.h presence... yes
> checking for fcntl.h... yes
> checking for inttypes.h... (cached) yes
> checking limits.h usability... yes
> checking limits.h presence... yes
> checking for limits.h... yes
> checking mntent.h usability... yes
> checking mntent.h presence... yes
> checking for mntent.h... yes
> checking netdb.h usability... yes
> checking netdb.h presence... yes
> checking for netdb.h... yes
> checking stddef.h usability... yes
> checking stddef.h presence... yes
> checking for stddef.h... yes
> checking for stdint.h... (cached) yes
> checking for stdbool.h... (cached) yes
> checking for stdlib.h... (cached) yes
> checking stdio.h usability... yes
> checking stdio.h presence... yes
> checking for stdio.h... yes
> checking errno.h usability... yes
> checking errno.h presence... yes
> checking for errno.h... yes
> checking for string.h... (cached) yes
> checking for strings.h... (cached) yes
> checking sys/mount.h usability... yes
> checking sys/mount.h presence... yes
> checking for sys/mount.h... yes
> checking sys/param.h usability... yes
> checking sys/param.h presence... yes
> checking for sys/param.h... yes
> checking sys/socket.h usability... yes
> checking sys/socket.h presence... yes
> checking for sys/socket.h... yes
> checking sys/time.h usability... yes
> checking sys/time.h presence... yes
> checking for sys/time.h... yes
> checking syslog.h usability... yes
> checking syslog.h presence... yes
> checking for syslog.h... yes
> checking for unistd.h... (cached) yes
> checking sys/fsuid.h usability... yes
> checking sys/fsuid.h presence... yes
> checking for sys/fsuid.h... yes
> checking for setfsuid... yes
> checking krb5.h usability... yes
> checking krb5.h presence... yes
> checking for krb5.h... yes
> checking krb5/krb5.h usability... yes
> checking krb5/krb5.h presence... yes
> checking for krb5/krb5.h... yes
> checking for keyvalue in krb5_keyblock... no
> checking talloc.h usability... yes
> checking talloc.h presence... yes
> checking for talloc.h... yes
> checking keyutils.h usability... yes
> checking keyutils.h presence... yes
> checking for keyutils.h... yes
> checking for krb5_init_context in -lkrb5... yes
> checking for pkg-config... /usr/bin/pkg-config
> checking pkg-config is at least version 0.9.0... yes
> checking for WBCLIENT... yes
> checking for wbcSidsToUnixIds in -lwbclient... no
> configure: error: wbclient library lacks wbcSidsToUnixIds(). Disabling
> cifs.idmap.
> make: *** [config.status] Error 1
> 
> > +       LDFLAGS=$ac_wbc_save_LDFLAGS
> > +fi
> > +
> >  if test $enable_cifsacl != "no"; then
> >         AC_CHECK_HEADERS([sys/xattr.h], , [
> >                                 if test "$enable_cifsacl" = "yes"; then
> > --
> > 1.7.11.7
> >
> 
> Jeff, is this the intended/expected outcome?

No, it isn't. It should disable the cifsacl tools instead. I've sent a
v2 patch that should fix it...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
