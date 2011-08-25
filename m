From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] autoconf: work around broken wbclient.h file
Date: Thu, 25 Aug 2011 15:55:14 -0500
Message-ID: <CADT32eKM_M1m+3o4B_d_0hTe5aJGek0pvj8DfX3a9-0naRfpqA@mail.gmail.com>
References: <1314304263-2153-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314304263-2153-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 25, 2011 at 3:31 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Some versions of wbclient.h have function declarations with bool type

Jeff, did not understand this verbiage, did you mean winbind library
or source files or something else?
Other than that, looks fine.

Regards,

Shirish

> args, but they don't include wbclient.h themselves. Make sure that
> we can deal with that by telling the autoconf test to include stdbool=
=2Eh
> explicitly.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0configure.ac | =A0 59 +++++++++++++++++++++++++++++++-------------=
-------------
> =A01 files changed, 32 insertions(+), 27 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index 2541f39..2607fb1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -39,6 +39,33 @@ AC_PROG_CC
> =A0AC_PROG_SED
> =A0AC_GNU_SOURCE
>
> +# Checks for typedefs, structures, and compiler characteristics.
> +AC_HEADER_STDBOOL
> +AC_TYPE_UID_T
> +AC_TYPE_OFF_T
> +AC_TYPE_PID_T
> +AC_TYPE_SIZE_T
> +AC_CHECK_TYPES([ptrdiff_t, ssize_t, uint32_t, uint8_t])
> +
> +# Checks for library functions.
> +AC_FUNC_GETMNTENT
> +AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
> +AC_FUNC_MALLOC
> +AC_FUNC_REALLOC
> +AC_FUNC_STRNLEN
> +
> +# check for required functions
> +AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday=
 inet_ntop memset realpath setenv strchr strcmp strdup strerror strncas=
ecmp strndup strpbrk strrchr strstr strtol strtoul tolower uname], , [A=
C_MSG_ERROR([necessary functions(s) not found])])
> +
> +AC_CHECK_FUNCS(clock_gettime, [], [
> + =A0AC_CHECK_LIB(rt, clock_gettime, [
> + =A0 =A0 =A0AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
> + =A0 =A0 =A0 AC_DEFINE(HAVE_CLOCK_GETTIME,1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Whether the clock_gettime func is ther=
e])
> + =A0 =A0 =A0LIBS=3D"$LIBS -lrt"
> + =A0 =A0 =A0 =A0])
> + =A0])
> +
> =A0# Checks for header files.
> =A0AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h =
mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h s=
tring.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslo=
g.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>
> @@ -108,6 +135,11 @@ if test $enable_cifsacl !=3D "no"; then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0AC_MSG_WARN([wbclient.h not found, consider installing libwbcli=
ent-devel. Disabling getcifsacl.])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0enable_cifsacl=3D"no"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fi
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [AC_INCLUDES_DEFAULT]
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [#ifdef HAVE_STDBOOL_H
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 #include <stdbo=
ol.h>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 #endif
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0])
> =A0fi
> =A0if test $enable_cifsupcall !=3D "no"; then
> @@ -124,33 +156,6 @@ if test $enable_cifscreds =3D "yes"; then
> =A0 =A0 =A0 =A0AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyuti=
ls.h not found, consider installing keyutils-libs-devel.])])
> =A0fi
>
> -# Checks for typedefs, structures, and compiler characteristics.
> -AC_HEADER_STDBOOL
> -AC_TYPE_UID_T
> -AC_TYPE_OFF_T
> -AC_TYPE_PID_T
> -AC_TYPE_SIZE_T
> -AC_CHECK_TYPES([ptrdiff_t, ssize_t, uint32_t, uint8_t])
> -
> -# Checks for library functions.
> -AC_FUNC_GETMNTENT
> -AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
> -AC_FUNC_MALLOC
> -AC_FUNC_REALLOC
> -AC_FUNC_STRNLEN
> -
> -# check for required functions
> -AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday=
 inet_ntop memset realpath setenv strchr strcmp strdup strerror strncas=
ecmp strndup strpbrk strrchr strstr strtol strtoul tolower uname], , [A=
C_MSG_ERROR([necessary functions(s) not found])])
> -
> -AC_CHECK_FUNCS(clock_gettime, [], [
> - =A0AC_CHECK_LIB(rt, clock_gettime, [
> - =A0 =A0 =A0AC_DEFINE(HAVE_CLOCK_GETTIME, 1)
> - =A0 =A0 =A0 AC_DEFINE(HAVE_CLOCK_GETTIME,1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Whether the clock_gettime func is ther=
e])
> - =A0 =A0 =A0LIBS=3D"$LIBS -lrt"
> - =A0 =A0 =A0 =A0])
> - =A0])
> -
>
> =A0# ugly, but I'm not sure how to check for functions in a library t=
hat's not in $LIBS
> =A0cu_saved_libs=3D$LIBS
> --
> 1.7.6
>
>
