From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping (try #3)
Date: Mon, 23 May 2011 09:08:58 -0400
Message-ID: <20110523090858.3db17264@tlielax.poochiereds.net>
References: <1306153609-28511-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110523084246.42168c14@tlielax.poochiereds.net>
	<BANLkTinOEbkSdUaZVL=k70gsJtefu73PzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinOEbkSdUaZVL=k70gsJtefu73PzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 23 May 2011 08:04:09 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, May 23, 2011 at 7:42 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 23 May 2011 07:26:49 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Handle cifs.idmap type of key. Extract a SID string from the descr=
iption
> >> and map it to either an uid or gid using winbind APIs.
> >> If that fails (e.g. because winbind is not installed/running or wi=
nbind returns
> >> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
> >> And if that fails, kernel assigns uid and gid (from mount superblo=
ck).
> >>
> >> Enable including winbind header files and idmapping code condition=
al
> >> to winbind devel rpms (header and library).
> >>
> >> An entry such as this
> >>
> >> create =C2=A0cifs.idmap =C2=A0 * =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/sbin/cifs.idmap %k
> >>
> >> is needed in the file /etc/request-key.conf.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0Makefile.am =C2=A0 =C2=A0 =C2=A0| =C2=A0 11 +++-
> >> =C2=A0aclocal/idmap.m4 | =C2=A0 45 +++++++++++
> >> =C2=A0cifs.idmap.c =C2=A0 =C2=A0 | =C2=A0221 +++++++++++++++++++++=
+++++++++++++++++++++++++++++++++
> >> =C2=A0cifs.upcall.c =C2=A0 =C2=A0| =C2=A0 =C2=A01 -
> >> =C2=A0configure.ac =C2=A0 =C2=A0 | =C2=A0 20 +++++-
> >> =C2=A05 files changed, 294 insertions(+), 4 deletions(-)
> >> =C2=A0create mode 100644 aclocal/idmap.m4
> >> =C2=A0create mode 100644 cifs.idmap.c
> >>
> >> diff --git a/Makefile.am b/Makefile.am
> >> index 67a0190..c6eeb22 100644
> >> --- a/Makefile.am
> >> +++ b/Makefile.am
> >> @@ -8,8 +8,10 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
> >>
> >> =C2=A0man_MANS =3D mount.cifs.8
> >>
> >> +sbin_PROGRAMS =3D
> >> +
> >> =C2=A0if CONFIG_CIFSUPCALL
> >> -sbin_PROGRAMS =3D cifs.upcall
> >> +sbin_PROGRAMS +=3D cifs.upcall
> >> =C2=A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spn=
ego.c util.c
> >> =C2=A0cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
> >> =C2=A0man_MANS +=3D cifs.upcall.8
> >> @@ -30,3 +32,10 @@ bin_PROGRAMS =3D cifscreds
> >> =C2=A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
> >> =C2=A0cifscreds_LDADD =3D -lkeyutils
> >> =C2=A0endif
> >> +
> >> +if CONFIG_CIFSIDMAP
> >> +sbin_PROGRAMS +=3D cifs.idmap
> >> +cifs_idmap_SOURCES =3D cifs.idmap.c
> >> +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
> >> +endif
> >> +
> >> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> >> new file mode 100644
> >> index 0000000..211d372
> >> --- /dev/null
> >> +++ b/aclocal/idmap.m4
> >> @@ -0,0 +1,45 @@
> >> +dnl Headers needed by wbclient.h
> >> +dnl
> >> +AC_DEFUN([AC_WBCH_COMPL],[
> >> +[
> >> +#ifdef HAVE_STDINT_H
> >> +#include <stdint.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDBOOL_H
> >> +#include <stdbool.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDIO_H
> >> +#include <stdio.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_STDLIB_H
> >> +#include <stdlib.h>
> >> +#endif
> >> +]
> >> +[#ifdef HAVE_ERRNO_H
> >> +#include <errno.h>
> >> +#endif
> >> +]])
> >> +
> >> +dnl Check for wbclient.h header and libwbclietn.so
> >> +dnl
> >> +AC_DEFUN([AC_TEST_WBCHL],[
> >> +if test $enable_cifsidmap !=3D "no"; then
> >> + =C2=A0 =C2=A0 AC_CHECK_HEADERS([wbclient.h], , [
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D "yes"; =
then
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_ERRO=
R([wbclient.h not found, consider installing libwbclient-devel.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_WARN=
([wbclient.h not found, consider installing libwbclient-devel. Disablin=
g cifs.idmap.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_cifs=
idmap=3D"no"
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ], [ AC_WBCH_COMPL ])
> >> +fi
> >> +
> >> +if test $enable_cifsidmap !=3D "no"; then
> >> + =C2=A0 =C2=A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [ WINB_LDADD=3D'-lwbcl=
ient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"=
]) ], [AC_MSG_ERROR([No functioning wbclient library found!])])
> >> + =C2=A0 =C2=A0 AC_SUBST(WINB_LDADD)
> >> +fi
> >> +])
> >> diff --git a/cifs.idmap.c b/cifs.idmap.c
> >> new file mode 100644
> >> index 0000000..7788bf2
> >> --- /dev/null
> >> +++ b/cifs.idmap.c
> >> @@ -0,0 +1,221 @@
> >> +/*
> >> +* CIFS idmap helper.
> >> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
> >> +*
> >> +* Used by /sbin/request-key.conf for handling
> >> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
> >> +* You should have keyutils installed and add
> >> +* this lines to /etc/request-key.conf file:
> >> +
> >> + =C2=A0 =C2=A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
> >> +
> >> +* This program is free software; you can redistribute it and/or m=
odify
> >> +* it under the terms of the GNU General Public License as publish=
ed by
> >> +* the Free Software Foundation; either version 2 of the License, =
or
> >> +* (at your option) any later version.
> >> +* This program is distributed in the hope that it will be useful,
> >> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> +* GNU General Public License for more details.
> >> +* You should have received a copy of the GNU General Public Licen=
se
> >> +* along with this program; if not, write to the Free Software
> >> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-=
1307 USA
> >> +*/
> >> +
> >> +#ifdef HAVE_CONFIG_H
> >> +#include "config.h"
> >> +#endif /* HAVE_CONFIG_H */
> >> +
> >> +#include <string.h>
> >> +#include <getopt.h>
> >> +#include <syslog.h>
> >> +#include <dirent.h>
> >> +#include <sys/types.h>
> >> +#include <sys/stat.h>
> >> +#include <unistd.h>
> >> +#include <keyutils.h>
> >> +#include <stdint.h>
> >> +#include <stdbool.h>
> >> +#include <stdio.h>
> >> +#include <stdlib.h>
> >> +#include <errno.h>
> >> +#include <limits.h>
> >> +#include <wbclient.h>
> >> +
> >> +static const char *prog =3D "cifs.idmap";
> >> +
> >> +static void usage(void)
> >> +{
> >> + =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s key_serial\n", prog);
> >> +}
> >> +
> >> +char *strget(const char *str, char *substr)
> >> +{
> >> + =C2=A0 =C2=A0 int len, sublen, retlen;
> >> + =C2=A0 =C2=A0 char *retstr, *substrptr;
> >> +
> >> + =C2=A0 =C2=A0 sublen =3D strlen(substr);
> >> + =C2=A0 =C2=A0 substrptr =3D strstr(str, substr);
> >> + =C2=A0 =C2=A0 if (substrptr) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D strlen(substrp=
tr);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 substrptr +=3D sublen;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retlen =3D len - suble=
n;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retlen > 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 retstr =3D malloc(retlen + 1);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (retstr) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strncpy(retstr, substrptr, retlen);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return retstr;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 return NULL;
> >> +}
> >> +
> >
> > I still worry a bit about bounds checking here, but I think we can =
trust
> > keyctl_describe_alloc to give us a NULL terminated string, so let's=
 not
> > sweat it for now.
> >
> >> +static int
> >> +cifs_idmap(const key_serial_t key, const char *key_descr)
> >> +{
> >> + =C2=A0 =C2=A0 uid_t uid =3D 0;
> >> + =C2=A0 =C2=A0 gid_t gid =3D 0;;
> >> + =C2=A0 =C2=A0 wbcErr rc =3D 1;
> >> + =C2=A0 =C2=A0 char *sidstr =3D NULL;
> >> + =C2=A0 =C2=A0 struct wbcDomainSid sid;
> >> + =C2=A0 =C2=A0 struct passwd *pw;
> >> + =C2=A0 =C2=A0 struct group *gr;
> >> +
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Use winbind to convert received string to =
a SID and lookup
> >> + =C2=A0 =C2=A0 =C2=A0* name and map that SID to an uid. =C2=A0If =
either of these
> >> + =C2=A0 =C2=A0 =C2=A0* function calls return with an error, =C2=A0=
use system calls to obtain
> >> + =C2=A0 =C2=A0 =C2=A0* uid of user "nobody". If winbind fails to =
map a SID to an UID
> >> + =C2=A0 =C2=A0 =C2=A0* and there is no user named "nobody", retur=
n error to the
> >> + =C2=A0 =C2=A0 =C2=A0* upcall caller. Otherwise instanticate a ke=
y using that uid.
> >> + =C2=A0 =C2=A0 =C2=A0*
> >> + =C2=A0 =C2=A0 =C2=A0* The same applies to SID and gid mapping. =C2=
=A0Instead of a
> >> + =C2=A0 =C2=A0 =C2=A0* user "nobody", user "nogroup" is looked up=
 if winbind
> >> + =C2=A0 =C2=A0 =C2=A0* fails to map a SID to a gid.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "os:");
> >> + =C2=A0 =C2=A0 if (sidstr) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcStringToSid(=
sidstr, &sid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_DEBUG, "Invalid owner string: %s, rc: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_descr, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D wbcSidToUid(&sid, &uid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to uid wbc er=
ror: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 key_descr, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) { /* either of=
 the two wbcSid functions failed */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 pw =3D getpwnam("nobody");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!pw)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to uid pw err=
or: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_descr, =
rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uid =3D pw->pw_uid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0^^^^^^^^^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Is it ever possible that the error from the wb
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0libs will be transient? If so, then mapping
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0this to nobody could be problematic, right?
> >
>=20
> We can't say. It is possible that the error from winbind is
> transiet and it is also possible that winbind is not running
> at all.
>=20
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0Might it be better to not map it to anything
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0and let the kernel turn this into the mount
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0uid/gid? If "nobody" really is better then you
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0probably ought to set a short timeout on this
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0key.
>=20
> Even if the key is changed to a transiet, the mapping in cache in ker=
nel
> is "permanent" i.e. at least till that cache entry is evicted by shri=
nker,
> if at all.
>=20
> What we can do is perhaps return different codes to kernel to only
> mark an entry as mapped when key handling code returns 0, say
> if it returns 1, then it is nobody/nogroup and do not mark an entry
> as mapped. If it is error (negative ret code), do not mark an entry
> as mapped but assign sb uid/gid.
>=20

That sounds a bit complicated. Why not just exit without instantiating
the key if a successful mapping can't be made? With this scheme, you'll
get different behavior depending on whether cifs.idmap couldn't be
called, or if it got called and the mapping didn't get made.

I think it might be best to have the user get the same behavior in the
event of any failure. Thoughts?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
