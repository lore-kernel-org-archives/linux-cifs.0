From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping (try #4)
Date: Wed, 25 May 2011 11:39:15 -0400
Message-ID: <20110525113915.67adc929@tlielax.poochiereds.net>
References: <1306161764-685-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110524145229.50c98d6b@tlielax.poochiereds.net>
	<BANLkTikWuDFe81r4AyTAfqK0fHOeEtS9yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikWuDFe81r4AyTAfqK0fHOeEtS9yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 24 May 2011 20:39:26 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, May 24, 2011 at 1:52 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 23 May 2011 09:42:44 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Handle cifs.idmap type of key. Extract a SID string from the descr=
iption
> >> and map it to either an uid or gid using winbind APIs.
> >> If that fails (e.g. because winbind is not installed/running or wi=
nbind
> >> returns an error), kernel assigns uid and gid (from mount superblo=
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
> >> =C2=A0aclocal/idmap.m4 | =C2=A0 45 ++++++++++++
> >> =C2=A0cifs.idmap.c =C2=A0 =C2=A0 | =C2=A0197 +++++++++++++++++++++=
+++++++++++++++++++++++++++++++++
> >> =C2=A0cifs.upcall.c =C2=A0 =C2=A0| =C2=A0 =C2=A01 -
> >> =C2=A0configure.ac =C2=A0 =C2=A0 | =C2=A0 20 +++++-
> >> =C2=A05 files changed, 270 insertions(+), 4 deletions(-)
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
> >
> > ^^^ nit: don't add extra newline
> >
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
> >> index 0000000..ea24824
> >> --- /dev/null
> >> +++ b/cifs.idmap.c
> >> @@ -0,0 +1,197 @@
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
> >> + =C2=A0 =C2=A0 =C2=A0* function calls return with an error, retur=
n an error the
> >> + =C2=A0 =C2=A0 =C2=A0* upcall caller. =C2=A0Otherwise instanticat=
e a key using that uid.
> >> + =C2=A0 =C2=A0 =C2=A0*
> >> + =C2=A0 =C2=A0 =C2=A0* The same applies to SID and gid mapping.
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
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SID has =
been mapped to an uid */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__, s=
trerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_ret;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "gs:");
> >> + =C2=A0 =C2=A0 if (sidstr) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcStringToSid(=
sidstr, &sid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_DEBUG, "Invalid group string: %s, rc: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_descr, =
rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D wbcSidToGid(&sid, &gid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to gid wbc er=
ror: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 key_descr, rc);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SID has =
been mapped to a gid */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 __func__, strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_ret;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
> >> +
> >> +cifs_idmap_ret:
> >> + =C2=A0 =C2=A0 if (sidstr)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(sidstr);
> >> +
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> +
> >> +int main(const int argc, char *const argv[])
> >> +{
> >> + =C2=A0 =C2=A0 int c;
> >> + =C2=A0 =C2=A0 long rc =3D 1;
> >> + =C2=A0 =C2=A0 key_serial_t key =3D 0;
> >> + =C2=A0 =C2=A0 char *buf;
> >> +
> >> + =C2=A0 =C2=A0 openlog(prog, 0, LOG_DAEMON);
> >> +
> >> + =C2=A0 =C2=A0 while ((c =3D getopt_long(argc, argv, "v", NULL, N=
ULL)) !=3D -1) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (c) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'v':
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 printf("version: %s\n", VERSION);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 syslog(LOG_ERR, "unknown option: %c", c);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto out;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* is there a key? */
> >> + =C2=A0 =C2=A0 if (argc <=3D optind) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 usage();
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* get key and keyring values */
> >> + =C2=A0 =C2=A0 errno =3D 0;
> >> + =C2=A0 =C2=A0 key =3D strtol(argv[optind], NULL, 10);
> >> + =C2=A0 =C2=A0 if (errno !=3D 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key =3D 0;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "Inval=
id key format: %s", strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 rc =3D keyctl_describe_alloc(key, &buf);
> >> + =C2=A0 =C2=A0 if (rc =3D=3D -1) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "keyct=
l_describe_alloc failed: %s",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0strerror(errno));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 1;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 syslog(LOG_DEBUG, "key description: %s", buf);
> >> +
> >> + =C2=A0 =C2=A0 if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap=
") - 1) =3D=3D 0))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_idmap(key,=
 buf);
> >> +out:
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >
> >
> > Program looks fine, I think...
> >
> >> diff --git a/cifs.upcall.c b/cifs.upcall.c
> >> index 479517c..de92092 100644
> >> --- a/cifs.upcall.c
> >> +++ b/cifs.upcall.c
> >> @@ -749,7 +749,6 @@ static int ip_to_fqdn(const char *addrstr, cha=
r *host, size_t hostlen)
> >>
> >> =C2=A0static void usage(void)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_ser=
ial", prog);
> >> =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] key=
_serial\n", prog);
> >> =C2=A0}
> >>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^^
> > This belongs in a separate patch. I've gone ahead and queued one up=
=2E
> >
> >> diff --git a/configure.ac b/configure.ac
> >> index e0e2a60..906bc2d 100644
> >> --- a/configure.ac
> >> +++ b/configure.ac
> >> @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
> >> =C2=A0 =C2=A0 =C2=A0 enable_cifscreds=3D$enableval,
> >> =C2=A0 =C2=A0 =C2=A0 enable_cifscreds=3D"no")
> >>
> >> +AC_ARG_ENABLE(cifsidmap,
> >> + =C2=A0 =C2=A0 [AC_HELP_STRING([--enable-cifsidmap],
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [Create cifs.idmap binary @<:@default=3Dyes@:>@])],
> >> + =C2=A0 =C2=A0 enable_cifsidmap=3D$enableval,
> >> + =C2=A0 =C2=A0 enable_cifsidmap=3D"maybe")
> >> +
> >> =C2=A0# Checks for programs.
> >> =C2=A0AC_PROG_CC
> >> =C2=A0AC_PROG_SED
> >> =C2=A0AC_GNU_SOURCE
> >>
> >> =C2=A0# Checks for header files.
> >> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h=
 mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mou=
nt.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_=
ERROR([necessary header(s) not found])])
> >> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h=
 mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h =
string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h sysl=
og.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> >>
> >> =C2=A0if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> >> @@ -72,7 +78,7 @@ if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ])
> >> =C2=A0fi
> >> -if test $enable_cifsupcall !=3D "no"; then
> >> +if test $enable_cifsupcall !=3D "no" -o $enable_cifsidmap !=3D "n=
o"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([keyutils.h], , [
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsupcall" =3D=
 "yes"; then
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_M=
SG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel=
=2E])
> >> @@ -80,6 +86,12 @@ if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_M=
SG_WARN([keyutils.h not found, consider installing keyutils-libs-devel.=
 Disabling cifs.upcall.])
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enab=
le_cifsupcall=3D"no"
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D "yes"; =
then
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_ERRO=
R([keyutils.h not found, consider installing keyutils-libs-devel.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_WARN=
([keyutils.h not found, consider installing keyutils-libs-devel. Disabl=
ing cifs.idmap.])
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_cifs=
idmap=3D"no"
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ])
> >> =C2=A0fi
> >> =C2=A0if test $enable_cifsupcall !=3D "no"; then
> >> @@ -89,6 +101,9 @@ if test $enable_cifsupcall !=3D "no"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_SUBST(KRB5_LDADD)
> >> =C2=A0fi
> >>
> >> +# checks for wbclient.h and libwbclient.so library
> >> +AC_TEST_WBCHL
> >> +
> >> =C2=A0if test $enable_cifscreds =3D "yes"; then
> >> =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERRO=
R([keyutils.h not found, consider installing keyutils-libs-devel.])])
> >> =C2=A0fi
> >> @@ -140,6 +155,7 @@ LIBS=3D$cu_saved_libs
> >>
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall"=
 !=3D "no"])
> >> =C2=A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D=
 "yes"])
> >> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D "=
no"])
> >>
> >> =C2=A0LIBCAP_NG_PATH
> >>
> >
> > At this point, I'm not quite comfortable enabling this by default g=
iven
> > that there is no documentation. Any objection to merging the follow=
ing
> > modified patch instead?
> >
> > -------------------------[snip]-------------------------
> >
> > [PATCH] cifs-utils: Create new binary cifs.idmap for sid to uid/gid=
 mapping (try #4)
> >
> > Handle cifs.idmap type of key. Extract a SID string from the descri=
ption
> > and map it to either an uid or gid using winbind APIs.
> > If that fails (e.g. because winbind is not installed/running or win=
bind
> > returns an error), kernel assigns uid and gid (from mount superbloc=
k).
> >
> > Enable including winbind header files and idmapping code conditiona=
l
> > to winbind devel rpms (header and library).
> >
> > An entry such as this
> >
> > create =C2=A0cifs.idmap =C2=A0 * =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /usr/sbin/cifs.idmap %k
> >
> > is needed in the file /etc/request-key.conf.
> >
> > [Note: Modified to not build new tool by default, and to fix up som=
e
> > =C2=A0 =C2=A0 =C2=A0 whitespace munging]
> >
> > Modified-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > =C2=A0Makefile.am =C2=A0 =C2=A0 =C2=A0| =C2=A0 10 +++-
> > =C2=A0aclocal/idmap.m4 | =C2=A0 45 ++++++++++++
> > =C2=A0cifs.idmap.c =C2=A0 =C2=A0 | =C2=A0197 ++++++++++++++++++++++=
++++++++++++++++++++++++++++++++
> > =C2=A0configure.ac =C2=A0 =C2=A0 | =C2=A0 17 ++++-
> > =C2=A04 files changed, 266 insertions(+), 3 deletions(-)
> > =C2=A0create mode 100644 aclocal/idmap.m4
> > =C2=A0create mode 100644 cifs.idmap.c
> >
> > diff --git a/Makefile.am b/Makefile.am
> > index 67a0190..6046369 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -8,8 +8,10 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
> >
> > =C2=A0man_MANS =3D mount.cifs.8
> >
> > +sbin_PROGRAMS =3D
> > +
> > =C2=A0if CONFIG_CIFSUPCALL
> > -sbin_PROGRAMS =3D cifs.upcall
> > +sbin_PROGRAMS +=3D cifs.upcall
> > =C2=A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spne=
go.c util.c
> > =C2=A0cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
> > =C2=A0man_MANS +=3D cifs.upcall.8
> > @@ -30,3 +32,9 @@ bin_PROGRAMS =3D cifscreds
> > =C2=A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
> > =C2=A0cifscreds_LDADD =3D -lkeyutils
> > =C2=A0endif
> > +
> > +if CONFIG_CIFSIDMAP
> > +sbin_PROGRAMS +=3D cifs.idmap
> > +cifs_idmap_SOURCES =3D cifs.idmap.c
> > +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
> > +endif
> > diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> > new file mode 100644
> > index 0000000..211d372
> > --- /dev/null
> > +++ b/aclocal/idmap.m4
> > @@ -0,0 +1,45 @@
> > +dnl Headers needed by wbclient.h
> > +dnl
> > +AC_DEFUN([AC_WBCH_COMPL],[
> > +[
> > +#ifdef HAVE_STDINT_H
> > +#include <stdint.h>
> > +#endif
> > +]
> > +[#ifdef HAVE_STDBOOL_H
> > +#include <stdbool.h>
> > +#endif
> > +]
> > +[#ifdef HAVE_STDIO_H
> > +#include <stdio.h>
> > +#endif
> > +]
> > +[#ifdef HAVE_STDLIB_H
> > +#include <stdlib.h>
> > +#endif
> > +]
> > +[#ifdef HAVE_ERRNO_H
> > +#include <errno.h>
> > +#endif
> > +]])
> > +
> > +dnl Check for wbclient.h header and libwbclietn.so
> > +dnl
> > +AC_DEFUN([AC_TEST_WBCHL],[
> > +if test $enable_cifsidmap !=3D "no"; then
> > + =C2=A0 =C2=A0 =C2=A0 AC_CHECK_HEADERS([wbclient.h], , [
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D =
"yes"; then
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_M=
SG_ERROR([wbclient.h not found, consider installing libwbclient-devel.]=
)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_M=
SG_WARN([wbclient.h not found, consider installing libwbclient-devel. D=
isabling cifs.idmap.])
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enab=
le_cifsidmap=3D"no"
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ], [ AC_WBCH_COMPL ])
> > +fi
> > +
> > +if test $enable_cifsidmap !=3D "no"; then
> > + =C2=A0 =C2=A0 =C2=A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 [ WINB_LDADD=3D'=
-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbc=
lient"]) ], [AC_MSG_ERROR([No functioning wbclient library found!])])
> > + =C2=A0 =C2=A0 =C2=A0 AC_SUBST(WINB_LDADD)
> > +fi
> > +])
> > diff --git a/cifs.idmap.c b/cifs.idmap.c
> > new file mode 100644
> > index 0000000..ea24824
> > --- /dev/null
> > +++ b/cifs.idmap.c
> > @@ -0,0 +1,197 @@
> > +/*
> > +* CIFS idmap helper.
> > +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
> > +*
> > +* Used by /sbin/request-key.conf for handling
> > +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
> > +* You should have keyutils installed and add
> > +* this lines to /etc/request-key.conf file:
> > +
> > + =C2=A0 =C2=A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
> > +
> > +* This program is free software; you can redistribute it and/or mo=
dify
> > +* it under the terms of the GNU General Public License as publishe=
d by
> > +* the Free Software Foundation; either version 2 of the License, o=
r
> > +* (at your option) any later version.
> > +* This program is distributed in the hope that it will be useful,
> > +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > +* GNU General Public License for more details.
> > +* You should have received a copy of the GNU General Public Licens=
e
> > +* along with this program; if not, write to the Free Software
> > +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1=
307 USA
> > +*/
> > +
> > +#ifdef HAVE_CONFIG_H
> > +#include "config.h"
> > +#endif /* HAVE_CONFIG_H */
> > +
> > +#include <string.h>
> > +#include <getopt.h>
> > +#include <syslog.h>
> > +#include <dirent.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > +#include <keyutils.h>
> > +#include <stdint.h>
> > +#include <stdbool.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <errno.h>
> > +#include <limits.h>
> > +#include <wbclient.h>
> > +
> > +static const char *prog =3D "cifs.idmap";
> > +
> > +static void usage(void)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "Usage: %s key_serial\n", pr=
og);
> > +}
> > +
> > +char *strget(const char *str, char *substr)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int len, sublen, retlen;
> > + =C2=A0 =C2=A0 =C2=A0 char *retstr, *substrptr;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 sublen =3D strlen(substr);
> > + =C2=A0 =C2=A0 =C2=A0 substrptr =3D strstr(str, substr);
> > + =C2=A0 =C2=A0 =C2=A0 if (substrptr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D strlen(s=
ubstrptr);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 substrptr +=3D s=
ublen;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retlen =3D len -=
 sublen;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (retlen > 0) =
{
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 retstr =3D malloc(retlen + 1);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (retstr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strncpy(retstr, substrptr, retle=
n);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return retstr;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 return NULL;
> > +}
> > +
> > +static int
> > +cifs_idmap(const key_serial_t key, const char *key_descr)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 uid_t uid =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 gid_t gid =3D 0;;
> > + =C2=A0 =C2=A0 =C2=A0 wbcErr rc =3D 1;
> > + =C2=A0 =C2=A0 =C2=A0 char *sidstr =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 struct wbcDomainSid sid;
> > + =C2=A0 =C2=A0 =C2=A0 struct passwd *pw;
> > + =C2=A0 =C2=A0 =C2=A0 struct group *gr;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Use winbind to convert received stri=
ng to a SID and lookup
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* name and map that SID to an uid. =C2=
=A0If either of these
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* function calls return with an error,=
 return an error the
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* upcall caller. =C2=A0Otherwise insta=
nticate a key using that uid.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* The same applies to SID and gid mapp=
ing.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "os:");
> > + =C2=A0 =C2=A0 =C2=A0 if (sidstr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcString=
ToSid(sidstr, &sid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 syslog(LOG_DEBUG, "Invalid owner string: %s, rc: %d",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_descr, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D wbcSidToUid(&sid, &uid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to uid=
 wbc error: %d",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 key_descr, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SI=
D has been mapped to an uid */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %=
s",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_=
ret;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 sidstr =3D strget(key_descr, "gs:");
> > + =C2=A0 =C2=A0 =C2=A0 if (sidstr) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wbcString=
ToSid(sidstr, &sid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 syslog(LOG_DEBUG, "Invalid group string: %s, rc: %d",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_=
descr, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D wbcSidToGid(&sid, &gid);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "SID %s to gid=
 wbc error: %d",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 key_descr, rc);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc) { /* SI=
D has been mapped to a gid */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, "%s: key inst: %=
s",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 __func__, strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto cifs_idmap_=
ret;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "Invalid key: %s", key_des=
cr);
> > +
> > +cifs_idmap_ret:
> > + =C2=A0 =C2=A0 =C2=A0 if (sidstr)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(sidstr);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> > +}
> > +
> > +int main(const int argc, char *const argv[])
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int c;
> > + =C2=A0 =C2=A0 =C2=A0 long rc =3D 1;
> > + =C2=A0 =C2=A0 =C2=A0 key_serial_t key =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 char *buf;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 openlog(prog, 0, LOG_DAEMON);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 while ((c =3D getopt_long(argc, argv, "v", N=
ULL, NULL)) !=3D -1) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (c) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'v':
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 printf("version: %s\n", VERSION);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 syslog(LOG_ERR, "unknown option: %c", c);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* is there a key? */
> > + =C2=A0 =C2=A0 =C2=A0 if (argc <=3D optind) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 usage();
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* get key and keyring values */
> > + =C2=A0 =C2=A0 =C2=A0 errno =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 key =3D strtol(argv[optind], NULL, 10);
> > + =C2=A0 =C2=A0 =C2=A0 if (errno !=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, =
"Invalid key format: %s", strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D keyctl_describe_alloc(key, &buf);
> > + =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D -1) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 syslog(LOG_ERR, =
"keyctl_describe_alloc failed: %s",
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0strerror(errno));
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 1;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > + =C2=A0 =C2=A0 =C2=A0 syslog(LOG_DEBUG, "key description: %s", buf=
);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if ((strncmp(buf, "cifs.idmap", sizeof("cifs=
=2Eidmap") - 1) =3D=3D 0))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_idma=
p(key, buf);
> > +out:
> > + =C2=A0 =C2=A0 =C2=A0 return rc;
> > +}
> > diff --git a/configure.ac b/configure.ac
> > index e0e2a60..6cac703 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0enable_cifscreds=3D$enableval,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0enable_cifscreds=3D"no")
> >
> > +AC_ARG_ENABLE(cifsidmap,
> > + =C2=A0 =C2=A0 =C2=A0 [AC_HELP_STRING([--enable-cifsidmap],
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 [Create cifs.idmap binary @<:@default=3Dno@:>@])],
> > + =C2=A0 =C2=A0 =C2=A0 enable_cifsidmap=3D$enableval,
> > + =C2=A0 =C2=A0 =C2=A0 enable_cifsidmap=3D"no")
> > +
> > =C2=A0# Checks for programs.
> > =C2=A0AC_PROG_CC
> > =C2=A0AC_PROG_SED
> > =C2=A0AC_GNU_SOURCE
> >
> > =C2=A0# Checks for header files.
> > -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h =
mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/moun=
t.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_E=
RROR([necessary header(s) not found])])
> > +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h =
mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h s=
tring.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslo=
g.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> >
> > =C2=A0if test $enable_cifsupcall !=3D "no"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> > @@ -72,7 +78,7 @@ if test $enable_cifsupcall !=3D "no"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0])
> > =C2=A0fi
> > -if test $enable_cifsupcall !=3D "no"; then
> > +if test $enable_cifsupcall !=3D "no" -o $enable_cifsidmap !=3D "no=
"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0AC_CHECK_HEADERS([keyutils.h], , [
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if test "$enable_cifsupcall" =
=3D "yes"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
C_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-de=
vel.])
> > @@ -80,6 +86,9 @@ if test $enable_cifsupcall !=3D "no"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
C_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-dev=
el. Disabling cifs.upcall.])
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0e=
nable_cifsupcall=3D"no"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D =
"yes"; then
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_M=
SG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel=
=2E])
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0])
> > =C2=A0fi
> > =C2=A0if test $enable_cifsupcall !=3D "no"; then
> > @@ -89,6 +98,9 @@ if test $enable_cifsupcall !=3D "no"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0AC_SUBST(KRB5_LDADD)
> > =C2=A0fi
> >
> > +# checks for wbclient.h and libwbclient.so library
> > +AC_TEST_WBCHL
> > +
> > =C2=A0if test $enable_cifscreds =3D "yes"; then
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0AC_CHECK_HEADERS([keyutils.h], , [AC_MSG=
_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.]=
)])
> > =C2=A0fi
> > @@ -140,6 +152,7 @@ LIBS=3D$cu_saved_libs
> >
> > =C2=A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" =
!=3D "no"])
> > =C2=A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D=
 "yes"])
>=20
> > +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" =3D "ye=
s"])
>=20
> Jeff, this modified patch looks fine. I will soon get in the man page=
,
> related changes, along with changing this line to !=3D 'no' to comple=
te
> all the changes necessary for id mapping.
>=20

Ok, committed along with a patch to remove a couple of unused
variables. I'll probably ship the next release with this set to "no".
We can discuss changing that afterward since this has implications for
people packaging cifs-utils.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
