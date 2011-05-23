From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping (try #3)
Date: Mon, 23 May 2011 08:24:33 -0500
Message-ID: <BANLkTinARum3tKOzGQRFuJG89Kk2Dy_Hdg@mail.gmail.com>
References: <1306153609-28511-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110523084246.42168c14@tlielax.poochiereds.net>
	<BANLkTinOEbkSdUaZVL=k70gsJtefu73PzA@mail.gmail.com>
	<20110523090858.3db17264@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110523090858.3db17264-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 23, 2011 at 8:08 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 23 May 2011 08:04:09 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, May 23, 2011 at 7:42 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > On Mon, 23 May 2011 07:26:49 -0500
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >> Handle cifs.idmap type of key. Extract a SID string from the desc=
ription
>> >> and map it to either an uid or gid using winbind APIs.
>> >> If that fails (e.g. because winbind is not installed/running or w=
inbind returns
>> >> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
>> >> And if that fails, kernel assigns uid and gid (from mount superbl=
ock).
>> >>
>> >> Enable including winbind header files and idmapping code conditio=
nal
>> >> to winbind devel rpms (header and library).
>> >>
>> >> An entry such as this
>> >>
>> >> create =A0cifs.idmap =A0 * =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 /usr/sbin/cifs.idmap %k
>> >>
>> >> is needed in the file /etc/request-key.conf.
>> >>
>> >>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =A0Makefile.am =A0 =A0 =A0| =A0 11 +++-
>> >> =A0aclocal/idmap.m4 | =A0 45 +++++++++++
>> >> =A0cifs.idmap.c =A0 =A0 | =A0221 ++++++++++++++++++++++++++++++++=
++++++++++++++++++++++
>> >> =A0cifs.upcall.c =A0 =A0| =A0 =A01 -
>> >> =A0configure.ac =A0 =A0 | =A0 20 +++++-
>> >> =A05 files changed, 294 insertions(+), 4 deletions(-)
>> >> =A0create mode 100644 aclocal/idmap.m4
>> >> =A0create mode 100644 cifs.idmap.c
>> >>
>> >> diff --git a/Makefile.am b/Makefile.am
>> >> index 67a0190..c6eeb22 100644
>> >> --- a/Makefile.am
>> >> +++ b/Makefile.am
>> >> @@ -8,8 +8,10 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
>> >>
>> >> =A0man_MANS =3D mount.cifs.8
>> >>
>> >> +sbin_PROGRAMS =3D
>> >> +
>> >> =A0if CONFIG_CIFSUPCALL
>> >> -sbin_PROGRAMS =3D cifs.upcall
>> >> +sbin_PROGRAMS +=3D cifs.upcall
>> >> =A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spneg=
o.c util.c
>> >> =A0cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
>> >> =A0man_MANS +=3D cifs.upcall.8
>> >> @@ -30,3 +32,10 @@ bin_PROGRAMS =3D cifscreds
>> >> =A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
>> >> =A0cifscreds_LDADD =3D -lkeyutils
>> >> =A0endif
>> >> +
>> >> +if CONFIG_CIFSIDMAP
>> >> +sbin_PROGRAMS +=3D cifs.idmap
>> >> +cifs_idmap_SOURCES =3D cifs.idmap.c
>> >> +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
>> >> +endif
>> >> +
>> >> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
>> >> new file mode 100644
>> >> index 0000000..211d372
>> >> --- /dev/null
>> >> +++ b/aclocal/idmap.m4
>> >> @@ -0,0 +1,45 @@
>> >> +dnl Headers needed by wbclient.h
>> >> +dnl
>> >> +AC_DEFUN([AC_WBCH_COMPL],[
>> >> +[
>> >> +#ifdef HAVE_STDINT_H
>> >> +#include <stdint.h>
>> >> +#endif
>> >> +]
>> >> +[#ifdef HAVE_STDBOOL_H
>> >> +#include <stdbool.h>
>> >> +#endif
>> >> +]
>> >> +[#ifdef HAVE_STDIO_H
>> >> +#include <stdio.h>
>> >> +#endif
>> >> +]
>> >> +[#ifdef HAVE_STDLIB_H
>> >> +#include <stdlib.h>
>> >> +#endif
>> >> +]
>> >> +[#ifdef HAVE_ERRNO_H
>> >> +#include <errno.h>
>> >> +#endif
>> >> +]])
>> >> +
>> >> +dnl Check for wbclient.h header and libwbclietn.so
>> >> +dnl
>> >> +AC_DEFUN([AC_TEST_WBCHL],[
>> >> +if test $enable_cifsidmap !=3D "no"; then
>> >> + =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 "$enable_cifsidmap" =3D "yes"; then
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbc=
lient-devel.])
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbcl=
ient-devel. Disabling cifs.idmap.])
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 enable_cifsidmap=3D"no"
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ], [ AC_WBCH_COMPL ])
>> >> +fi
>> >> +
>> >> +if test $enable_cifsidmap !=3D "no"; then
>> >> + =A0 =A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 [ WINB_LDADD=3D'-lwbclient' ] [ AC_DEFI=
NE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERR=
OR([No functioning wbclient library found!])])
>> >> + =A0 =A0 AC_SUBST(WINB_LDADD)
>> >> +fi
>> >> +])
>> >> diff --git a/cifs.idmap.c b/cifs.idmap.c
>> >> new file mode 100644
>> >> index 0000000..7788bf2
>> >> --- /dev/null
>> >> +++ b/cifs.idmap.c
>> >> @@ -0,0 +1,221 @@
>> >> +/*
>> >> +* CIFS idmap helper.
>> >> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
>> >> +*
>> >> +* Used by /sbin/request-key.conf for handling
>> >> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
>> >> +* You should have keyutils installed and add
>> >> +* this lines to /etc/request-key.conf file:
>> >> +
>> >> + =A0 =A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
>> >> +
>> >> +* This program is free software; you can redistribute it and/or =
modify
>> >> +* it under the terms of the GNU General Public License as publis=
hed by
>> >> +* the Free Software Foundation; either version 2 of the License,=
 or
>> >> +* (at your option) any later version.
>> >> +* This program is distributed in the hope that it will be useful=
,
>> >> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> >> +* GNU General Public License for more details.
>> >> +* You should have received a copy of the GNU General Public Lice=
nse
>> >> +* along with this program; if not, write to the Free Software
>> >> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111=
-1307 USA
>> >> +*/
>> >> +
>> >> +#ifdef HAVE_CONFIG_H
>> >> +#include "config.h"
>> >> +#endif /* HAVE_CONFIG_H */
>> >> +
>> >> +#include <string.h>
>> >> +#include <getopt.h>
>> >> +#include <syslog.h>
>> >> +#include <dirent.h>
>> >> +#include <sys/types.h>
>> >> +#include <sys/stat.h>
>> >> +#include <unistd.h>
>> >> +#include <keyutils.h>
>> >> +#include <stdint.h>
>> >> +#include <stdbool.h>
>> >> +#include <stdio.h>
>> >> +#include <stdlib.h>
>> >> +#include <errno.h>
>> >> +#include <limits.h>
>> >> +#include <wbclient.h>
>> >> +
>> >> +static const char *prog =3D "cifs.idmap";
>> >> +
>> >> +static void usage(void)
>> >> +{
>> >> + =A0 =A0 fprintf(stderr, "Usage: %s key_serial\n", prog);
>> >> +}
>> >> +
>> >> +char *strget(const char *str, char *substr)
>> >> +{
>> >> + =A0 =A0 int len, sublen, retlen;
>> >> + =A0 =A0 char *retstr, *substrptr;
>> >> +
>> >> + =A0 =A0 sublen =3D strlen(substr);
>> >> + =A0 =A0 substrptr =3D strstr(str, substr);
>> >> + =A0 =A0 if (substrptr) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(substrptr);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 substrptr +=3D sublen;
>> >> +
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 retlen =3D len - sublen;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (retlen > 0) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retstr =3D malloc(retle=
n + 1);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retstr) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy=
(retstr, substrptr, retlen);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
retstr;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 }
>> >> +
>> >> + =A0 =A0 return NULL;
>> >> +}
>> >> +
>> >
>> > I still worry a bit about bounds checking here, but I think we can=
 trust
>> > keyctl_describe_alloc to give us a NULL terminated string, so let'=
s not
>> > sweat it for now.
>> >
>> >> +static int
>> >> +cifs_idmap(const key_serial_t key, const char *key_descr)
>> >> +{
>> >> + =A0 =A0 uid_t uid =3D 0;
>> >> + =A0 =A0 gid_t gid =3D 0;;
>> >> + =A0 =A0 wbcErr rc =3D 1;
>> >> + =A0 =A0 char *sidstr =3D NULL;
>> >> + =A0 =A0 struct wbcDomainSid sid;
>> >> + =A0 =A0 struct passwd *pw;
>> >> + =A0 =A0 struct group *gr;
>> >> +
>> >> + =A0 =A0 /*
>> >> + =A0 =A0 =A0* Use winbind to convert received string to a SID an=
d lookup
>> >> + =A0 =A0 =A0* name and map that SID to an uid. =A0If either of t=
hese
>> >> + =A0 =A0 =A0* function calls return with an error, =A0use system=
 calls to obtain
>> >> + =A0 =A0 =A0* uid of user "nobody". If winbind fails to map a SI=
D to an UID
>> >> + =A0 =A0 =A0* and there is no user named "nobody", return error =
to the
>> >> + =A0 =A0 =A0* upcall caller. Otherwise instanticate a key using =
that uid.
>> >> + =A0 =A0 =A0*
>> >> + =A0 =A0 =A0* The same applies to SID and gid mapping. =A0Instea=
d of a
>> >> + =A0 =A0 =A0* user "nobody", user "nogroup" is looked up if winb=
ind
>> >> + =A0 =A0 =A0* fails to map a SID to a gid.
>> >> + =A0 =A0 =A0*/
>> >> + =A0 =A0 sidstr =3D strget(key_descr, "os:");
>> >> + =A0 =A0 if (sidstr) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(sidstr, &sid);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Inva=
lid owner string: %s, rc: %d",
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_des=
cr, rc);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToUid(&sid=
, &uid);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_DEBUG, "SID %s to uid wbc error: %d",
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 key_descr, rc);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) { /* either of the two wbcSid f=
unctions failed */
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pw =3D getpwnam("nobody=
");
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!pw)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_DEBUG, "SID %s to uid pw error: %d",
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 key_descr, rc);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid =3D=
 pw->pw_uid;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
0;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Is it ever possible=
 that the error from the wb
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0libs will be transi=
ent? If so, then mapping
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0this to nobody coul=
d be problematic, right?
>> >
>>
>> We can't say. It is possible that the error from winbind is
>> transiet and it is also possible that winbind is not running
>> at all.
>>
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Might it be better =
to not map it to anything
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and let the kernel =
turn this into the mount
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uid/gid? If "nobody=
" really is better then you
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0probably ought to s=
et a short timeout on this
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key.
>>
>> Even if the key is changed to a transiet, the mapping in cache in ke=
rnel
>> is "permanent" i.e. at least till that cache entry is evicted by shr=
inker,
>> if at all.
>>
>> What we can do is perhaps return different codes to kernel to only
>> mark an entry as mapped when key handling code returns 0, say
>> if it returns 1, then it is nobody/nogroup and do not mark an entry
>> as mapped. If it is error (negative ret code), do not mark an entry
>> as mapped but assign sb uid/gid.
>>
>
> That sounds a bit complicated. Why not just exit without instantiatin=
g
> the key if a successful mapping can't be made? With this scheme, you'=
ll
> get different behavior depending on whether cifs.idmap couldn't be
> called, or if it got called and the mapping didn't get made.
>
> I think it might be best to have the user get the same behavior in th=
e
> event of any failure. Thoughts?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I think I am OK with that. So basically we are ruling out assigning
nobody/nogroup as uid/gid.
