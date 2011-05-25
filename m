From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping (try #4)
Date: Tue, 24 May 2011 20:39:26 -0500
Message-ID: <BANLkTikWuDFe81r4AyTAfqK0fHOeEtS9yA@mail.gmail.com>
References: <1306161764-685-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110524145229.50c98d6b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110524145229.50c98d6b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 24, 2011 at 1:52 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 23 May 2011 09:42:44 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Handle cifs.idmap type of key. Extract a SID string from the descrip=
tion
>> and map it to either an uid or gid using winbind APIs.
>> If that fails (e.g. because winbind is not installed/running or winb=
ind
>> returns an error), kernel assigns uid and gid (from mount superblock=
).
>>
>> Enable including winbind header files and idmapping code conditional
>> to winbind devel rpms (header and library).
>>
>> An entry such as this
>>
>> create =A0cifs.idmap =A0 * =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 /usr/sbin/cifs.idmap %k
>>
>> is needed in the file /etc/request-key.conf.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0Makefile.am =A0 =A0 =A0| =A0 11 +++-
>> =A0aclocal/idmap.m4 | =A0 45 ++++++++++++
>> =A0cifs.idmap.c =A0 =A0 | =A0197 +++++++++++++++++++++++++++++++++++=
+++++++++++++++++++
>> =A0cifs.upcall.c =A0 =A0| =A0 =A01 -
>> =A0configure.ac =A0 =A0 | =A0 20 +++++-
>> =A05 files changed, 270 insertions(+), 4 deletions(-)
>> =A0create mode 100644 aclocal/idmap.m4
>> =A0create mode 100644 cifs.idmap.c
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 67a0190..c6eeb22 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -8,8 +8,10 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
>>
>> =A0man_MANS =3D mount.cifs.8
>>
>> +sbin_PROGRAMS =3D
>> +
>> =A0if CONFIG_CIFSUPCALL
>> -sbin_PROGRAMS =3D cifs.upcall
>> +sbin_PROGRAMS +=3D cifs.upcall
>> =A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spnego.c=
 util.c
>> =A0cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
>> =A0man_MANS +=3D cifs.upcall.8
>> @@ -30,3 +32,10 @@ bin_PROGRAMS =3D cifscreds
>> =A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
>> =A0cifscreds_LDADD =3D -lkeyutils
>> =A0endif
>> +
>> +if CONFIG_CIFSIDMAP
>> +sbin_PROGRAMS +=3D cifs.idmap
>> +cifs_idmap_SOURCES =3D cifs.idmap.c
>> +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
>> +endif
>> +
>
> ^^^ nit: don't add extra newline
>
>> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
>> new file mode 100644
>> index 0000000..211d372
>> --- /dev/null
>> +++ b/aclocal/idmap.m4
>> @@ -0,0 +1,45 @@
>> +dnl Headers needed by wbclient.h
>> +dnl
>> +AC_DEFUN([AC_WBCH_COMPL],[
>> +[
>> +#ifdef HAVE_STDINT_H
>> +#include <stdint.h>
>> +#endif
>> +]
>> +[#ifdef HAVE_STDBOOL_H
>> +#include <stdbool.h>
>> +#endif
>> +]
>> +[#ifdef HAVE_STDIO_H
>> +#include <stdio.h>
>> +#endif
>> +]
>> +[#ifdef HAVE_STDLIB_H
>> +#include <stdlib.h>
>> +#endif
>> +]
>> +[#ifdef HAVE_ERRNO_H
>> +#include <errno.h>
>> +#endif
>> +]])
>> +
>> +dnl Check for wbclient.h header and libwbclietn.so
>> +dnl
>> +AC_DEFUN([AC_TEST_WBCHL],[
>> +if test $enable_cifsidmap !=3D "no"; then
>> + =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test "$=
enable_cifsidmap" =3D "yes"; then
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbclien=
t-devel.])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbclient=
-devel. Disabling cifs.idmap.])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enable_cifsidmap=3D"no"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ], [ AC_WBCH_COMPL ])
>> +fi
>> +
>> +if test $enable_cifsidmap !=3D "no"; then
>> + =A0 =A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
>> + =A0 =A0 =A0 =A0 =A0 =A0 [ WINB_LDADD=3D'-lwbclient' ] [ AC_DEFINE(=
HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERROR(=
[No functioning wbclient library found!])])
>> + =A0 =A0 AC_SUBST(WINB_LDADD)
>> +fi
>> +])
>> diff --git a/cifs.idmap.c b/cifs.idmap.c
>> new file mode 100644
>> index 0000000..ea24824
>> --- /dev/null
>> +++ b/cifs.idmap.c
>> @@ -0,0 +1,197 @@
>> +/*
>> +* CIFS idmap helper.
>> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
>> +*
>> +* Used by /sbin/request-key.conf for handling
>> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
>> +* You should have keyutils installed and add
>> +* this lines to /etc/request-key.conf file:
>> +
>> + =A0 =A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
>> +
>> +* This program is free software; you can redistribute it and/or mod=
ify
>> +* it under the terms of the GNU General Public License as published=
 by
>> +* the Free Software Foundation; either version 2 of the License, or
>> +* (at your option) any later version.
>> +* This program is distributed in the hope that it will be useful,
>> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> +* GNU General Public License for more details.
>> +* You should have received a copy of the GNU General Public License
>> +* along with this program; if not, write to the Free Software
>> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-13=
07 USA
>> +*/
>> +
>> +#ifdef HAVE_CONFIG_H
>> +#include "config.h"
>> +#endif /* HAVE_CONFIG_H */
>> +
>> +#include <string.h>
>> +#include <getopt.h>
>> +#include <syslog.h>
>> +#include <dirent.h>
>> +#include <sys/types.h>
>> +#include <sys/stat.h>
>> +#include <unistd.h>
>> +#include <keyutils.h>
>> +#include <stdint.h>
>> +#include <stdbool.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <errno.h>
>> +#include <limits.h>
>> +#include <wbclient.h>
>> +
>> +static const char *prog =3D "cifs.idmap";
>> +
>> +static void usage(void)
>> +{
>> + =A0 =A0 fprintf(stderr, "Usage: %s key_serial\n", prog);
>> +}
>> +
>> +char *strget(const char *str, char *substr)
>> +{
>> + =A0 =A0 int len, sublen, retlen;
>> + =A0 =A0 char *retstr, *substrptr;
>> +
>> + =A0 =A0 sublen =3D strlen(substr);
>> + =A0 =A0 substrptr =3D strstr(str, substr);
>> + =A0 =A0 if (substrptr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(substrptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 substrptr +=3D sublen;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 retlen =3D len - sublen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retlen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retstr =3D malloc(retlen +=
 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retstr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(re=
tstr, substrptr, retlen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret=
str;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return NULL;
>> +}
>> +
>> +static int
>> +cifs_idmap(const key_serial_t key, const char *key_descr)
>> +{
>> + =A0 =A0 uid_t uid =3D 0;
>> + =A0 =A0 gid_t gid =3D 0;;
>> + =A0 =A0 wbcErr rc =3D 1;
>> + =A0 =A0 char *sidstr =3D NULL;
>> + =A0 =A0 struct wbcDomainSid sid;
>> + =A0 =A0 struct passwd *pw;
>> + =A0 =A0 struct group *gr;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Use winbind to convert received string to a SID and l=
ookup
>> + =A0 =A0 =A0* name and map that SID to an uid. =A0If either of thes=
e
>> + =A0 =A0 =A0* function calls return with an error, return an error =
the
>> + =A0 =A0 =A0* upcall caller. =A0Otherwise instanticate a key using =
that uid.
>> + =A0 =A0 =A0*
>> + =A0 =A0 =A0* The same applies to SID and gid mapping.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 sidstr =3D strget(key_descr, "os:");
>> + =A0 =A0 if (sidstr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(sidstr, &sid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Invalid=
 owner string: %s, rc: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_descr,=
 rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToUid(&sid, &=
uid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to uid wbc error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 key_descr, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to an ui=
d */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantiate(=
key, &uid, sizeof(uid_t), 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_ERR, "%s: key inst: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 sidstr =3D strget(key_descr, "gs:");
>> + =A0 =A0 if (sidstr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(sidstr, &sid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Invalid=
 group string: %s, rc: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 key_descr, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToGid(&sid, &=
gid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to gid wbc error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 key_descr, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to a gid=
 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantiate(=
key, &gid, sizeof(gid_t), 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_ERR, "%s: key inst: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 __func__, strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
>> +
>> +cifs_idmap_ret:
>> + =A0 =A0 if (sidstr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 free(sidstr);
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> +int main(const int argc, char *const argv[])
>> +{
>> + =A0 =A0 int c;
>> + =A0 =A0 long rc =3D 1;
>> + =A0 =A0 key_serial_t key =3D 0;
>> + =A0 =A0 char *buf;
>> +
>> + =A0 =A0 openlog(prog, 0, LOG_DAEMON);
>> +
>> + =A0 =A0 while ((c =3D getopt_long(argc, argv, "v", NULL, NULL)) !=3D=
 -1) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 switch (c) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 case 'v':
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("version: %s\n", VE=
RSION);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "unknown o=
ption: %c", c);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* is there a key? */
>> + =A0 =A0 if (argc <=3D optind) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 usage();
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* get key and keyring values */
>> + =A0 =A0 errno =3D 0;
>> + =A0 =A0 key =3D strtol(argv[optind], NULL, 10);
>> + =A0 =A0 if (errno !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 key =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "Invalid key format: %s", =
strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D keyctl_describe_alloc(key, &buf);
>> + =A0 =A0 if (rc =3D=3D -1) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "keyctl_describe_alloc fai=
led: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 syslog(LOG_DEBUG, "key description: %s", buf);
>> +
>> + =A0 =A0 if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap") - 1) =
=3D=3D 0))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_idmap(key, buf);
>> +out:
>> + =A0 =A0 return rc;
>> +}
>
>
> Program looks fine, I think...
>
>> diff --git a/cifs.upcall.c b/cifs.upcall.c
>> index 479517c..de92092 100644
>> --- a/cifs.upcall.c
>> +++ b/cifs.upcall.c
>> @@ -749,7 +749,6 @@ static int ip_to_fqdn(const char *addrstr, char =
*host, size_t hostlen)
>>
>> =A0static void usage(void)
>> =A0{
>> - =A0 =A0 syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", pr=
og);
>> =A0 =A0 =A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n",=
 prog);
>> =A0}
>>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^
> This belongs in a separate patch. I've gone ahead and queued one up.
>
>> diff --git a/configure.ac b/configure.ac
>> index e0e2a60..906bc2d 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
>> =A0 =A0 =A0 enable_cifscreds=3D$enableval,
>> =A0 =A0 =A0 enable_cifscreds=3D"no")
>>
>> +AC_ARG_ENABLE(cifsidmap,
>> + =A0 =A0 [AC_HELP_STRING([--enable-cifsidmap],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifs.idmap binary =
@<:@default=3Dyes@:>@])],
>> + =A0 =A0 enable_cifsidmap=3D$enableval,
>> + =A0 =A0 enable_cifsidmap=3D"maybe")
>> +
>> =A0# Checks for programs.
>> =A0AC_PROG_CC
>> =A0AC_PROG_SED
>> =A0AC_GNU_SOURCE
>>
>> =A0# Checks for header files.
>> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h m=
ntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount=
=2Eh sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_=
ERROR([necessary header(s) not found])])
>> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h m=
ntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h st=
ring.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog=
=2Eh unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>>
>> =A0if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
>> @@ -72,7 +78,7 @@ if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
>> =A0fi
>> -if test $enable_cifsupcall !=3D "no"; then
>> +if test $enable_cifsupcall !=3D "no" -o $enable_cifsidmap !=3D "no"=
; then
>> =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test =
"$enable_cifsupcall" =3D "yes"; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 AC_MSG_ERROR([keyutils.h not found, consider installing keyutil=
s-libs-devel.])
>> @@ -80,6 +86,12 @@ if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 AC_MSG_WARN([keyutils.h not found, consider installing keyutils=
-libs-devel. Disabling cifs.upcall.])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 enable_cifsupcall=3D"no"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test "$=
enable_cifsidmap" =3D "yes"; then
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-l=
ibs-devel.])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_WARN([keyutils.h not found, consider installing keyutils-li=
bs-devel. Disabling cifs.idmap.])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enable_cifsidmap=3D"no"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
>> =A0fi
>> =A0if test $enable_cifsupcall !=3D "no"; then
>> @@ -89,6 +101,9 @@ if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 AC_SUBST(KRB5_LDADD)
>> =A0fi
>>
>> +# checks for wbclient.h and libwbclient.so library
>> +AC_TEST_WBCHL
>> +
>> =A0if test $enable_cifscreds =3D "yes"; then
>> =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils=
=2Eh not found, consider installing keyutils-libs-devel.])])
>> =A0fi
>> @@ -140,6 +155,7 @@ LIBS=3D$cu_saved_libs
>>
>> =A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" !=3D=
 "no"])
>> =A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D "y=
es"])
>> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D "no=
"])
>>
>> =A0LIBCAP_NG_PATH
>>
>
> At this point, I'm not quite comfortable enabling this by default giv=
en
> that there is no documentation. Any objection to merging the followin=
g
> modified patch instead?
>
> -------------------------[snip]-------------------------
>
> [PATCH] cifs-utils: Create new binary cifs.idmap for sid to uid/gid m=
apping (try #4)
>
> Handle cifs.idmap type of key. Extract a SID string from the descript=
ion
> and map it to either an uid or gid using winbind APIs.
> If that fails (e.g. because winbind is not installed/running or winbi=
nd
> returns an error), kernel assigns uid and gid (from mount superblock)=
=2E
>
> Enable including winbind header files and idmapping code conditional
> to winbind devel rpms (header and library).
>
> An entry such as this
>
> create =A0cifs.idmap =A0 * =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
/usr/sbin/cifs.idmap %k
>
> is needed in the file /etc/request-key.conf.
>
> [Note: Modified to not build new tool by default, and to fix up some
> =A0 =A0 =A0 whitespace munging]
>
> Modified-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0Makefile.am =A0 =A0 =A0| =A0 10 +++-
> =A0aclocal/idmap.m4 | =A0 45 ++++++++++++
> =A0cifs.idmap.c =A0 =A0 | =A0197 ++++++++++++++++++++++++++++++++++++=
++++++++++++++++++
> =A0configure.ac =A0 =A0 | =A0 17 ++++-
> =A04 files changed, 266 insertions(+), 3 deletions(-)
> =A0create mode 100644 aclocal/idmap.m4
> =A0create mode 100644 cifs.idmap.c
>
> diff --git a/Makefile.am b/Makefile.am
> index 67a0190..6046369 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -8,8 +8,10 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
>
> =A0man_MANS =3D mount.cifs.8
>
> +sbin_PROGRAMS =3D
> +
> =A0if CONFIG_CIFSUPCALL
> -sbin_PROGRAMS =3D cifs.upcall
> +sbin_PROGRAMS +=3D cifs.upcall
> =A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spnego.c =
util.c
> =A0cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
> =A0man_MANS +=3D cifs.upcall.8
> @@ -30,3 +32,9 @@ bin_PROGRAMS =3D cifscreds
> =A0cifscreds_SOURCES =3D cifscreds.c resolve_host.c util.c
> =A0cifscreds_LDADD =3D -lkeyutils
> =A0endif
> +
> +if CONFIG_CIFSIDMAP
> +sbin_PROGRAMS +=3D cifs.idmap
> +cifs_idmap_SOURCES =3D cifs.idmap.c
> +cifs_idmap_LDADD =3D -lkeyutils $(WINB_LDADD)
> +endif
> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
> new file mode 100644
> index 0000000..211d372
> --- /dev/null
> +++ b/aclocal/idmap.m4
> @@ -0,0 +1,45 @@
> +dnl Headers needed by wbclient.h
> +dnl
> +AC_DEFUN([AC_WBCH_COMPL],[
> +[
> +#ifdef HAVE_STDINT_H
> +#include <stdint.h>
> +#endif
> +]
> +[#ifdef HAVE_STDBOOL_H
> +#include <stdbool.h>
> +#endif
> +]
> +[#ifdef HAVE_STDIO_H
> +#include <stdio.h>
> +#endif
> +]
> +[#ifdef HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif
> +]
> +[#ifdef HAVE_ERRNO_H
> +#include <errno.h>
> +#endif
> +]])
> +
> +dnl Check for wbclient.h header and libwbclietn.so
> +dnl
> +AC_DEFUN([AC_TEST_WBCHL],[
> +if test $enable_cifsidmap !=3D "no"; then
> + =A0 =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 "$enable_cifsidmap" =3D "yes"; then
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbc=
lient-devel.])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbcl=
ient-devel. Disabling cifs.idmap.])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 enable_cifsidmap=3D"no"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ], [ AC_WBCH_COMPL ])
> +fi
> +
> +if test $enable_cifsidmap !=3D "no"; then
> + =A0 =A0 =A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ WINB_LDADD=3D'-lwbclient' ] [ AC_DEFI=
NE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERR=
OR([No functioning wbclient library found!])])
> + =A0 =A0 =A0 AC_SUBST(WINB_LDADD)
> +fi
> +])
> diff --git a/cifs.idmap.c b/cifs.idmap.c
> new file mode 100644
> index 0000000..ea24824
> --- /dev/null
> +++ b/cifs.idmap.c
> @@ -0,0 +1,197 @@
> +/*
> +* CIFS idmap helper.
> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
> +*
> +* Used by /sbin/request-key.conf for handling
> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
> +* You should have keyutils installed and add
> +* this lines to /etc/request-key.conf file:
> +
> + =A0 =A0create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
> +
> +* This program is free software; you can redistribute it and/or modi=
fy
> +* it under the terms of the GNU General Public License as published =
by
> +* the Free Software Foundation; either version 2 of the License, or
> +* (at your option) any later version.
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +* GNU General Public License for more details.
> +* You should have received a copy of the GNU General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-130=
7 USA
> +*/
> +
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <string.h>
> +#include <getopt.h>
> +#include <syslog.h>
> +#include <dirent.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <keyutils.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <limits.h>
> +#include <wbclient.h>
> +
> +static const char *prog =3D "cifs.idmap";
> +
> +static void usage(void)
> +{
> + =A0 =A0 =A0 fprintf(stderr, "Usage: %s key_serial\n", prog);
> +}
> +
> +char *strget(const char *str, char *substr)
> +{
> + =A0 =A0 =A0 int len, sublen, retlen;
> + =A0 =A0 =A0 char *retstr, *substrptr;
> +
> + =A0 =A0 =A0 sublen =3D strlen(substr);
> + =A0 =A0 =A0 substrptr =3D strstr(str, substr);
> + =A0 =A0 =A0 if (substrptr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(substrptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 substrptr +=3D sublen;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retlen =3D len - sublen;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retlen > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retstr =3D malloc(retle=
n + 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy=
(retstr, substrptr, retlen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
retstr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return NULL;
> +}
> +
> +static int
> +cifs_idmap(const key_serial_t key, const char *key_descr)
> +{
> + =A0 =A0 =A0 uid_t uid =3D 0;
> + =A0 =A0 =A0 gid_t gid =3D 0;;
> + =A0 =A0 =A0 wbcErr rc =3D 1;
> + =A0 =A0 =A0 char *sidstr =3D NULL;
> + =A0 =A0 =A0 struct wbcDomainSid sid;
> + =A0 =A0 =A0 struct passwd *pw;
> + =A0 =A0 =A0 struct group *gr;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Use winbind to convert received string to a SID an=
d lookup
> + =A0 =A0 =A0 =A0* name and map that SID to an uid. =A0If either of t=
hese
> + =A0 =A0 =A0 =A0* function calls return with an error, return an err=
or the
> + =A0 =A0 =A0 =A0* upcall caller. =A0Otherwise instanticate a key usi=
ng that uid.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* The same applies to SID and gid mapping.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 sidstr =3D strget(key_descr, "os:");
> + =A0 =A0 =A0 if (sidstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(sidstr, &sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Inva=
lid owner string: %s, rc: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_des=
cr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToUid(&sid=
, &uid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_DEBUG, "SID %s to uid wbc error: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 key_descr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to an=
 uid */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantia=
te(key, &uid, sizeof(uid_t), 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_ERR, "%s: key inst: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sidstr =3D strget(key_descr, "gs:");
> + =A0 =A0 =A0 if (sidstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(sidstr, &sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Inva=
lid group string: %s, rc: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 key_descr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToGid(&sid=
, &gid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_DEBUG, "SID %s to gid wbc error: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 key_descr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to a =
gid */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantia=
te(key, &gid, sizeof(gid_t), 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_ERR, "%s: key inst: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 __func__, strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_idmap_ret;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
> +
> +cifs_idmap_ret:
> + =A0 =A0 =A0 if (sidstr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(sidstr);
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> +int main(const int argc, char *const argv[])
> +{
> + =A0 =A0 =A0 int c;
> + =A0 =A0 =A0 long rc =3D 1;
> + =A0 =A0 =A0 key_serial_t key =3D 0;
> + =A0 =A0 =A0 char *buf;
> +
> + =A0 =A0 =A0 openlog(prog, 0, LOG_DAEMON);
> +
> + =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "v", NULL, NULL))=
 !=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (c) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'v':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("version: %s\n",=
 VERSION);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "unknow=
n option: %c", c);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* is there a key? */
> + =A0 =A0 =A0 if (argc <=3D optind) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 usage();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* get key and keyring values */
> + =A0 =A0 =A0 errno =3D 0;
> + =A0 =A0 =A0 key =3D strtol(argv[optind], NULL, 10);
> + =A0 =A0 =A0 if (errno !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "Invalid key format: %s=
", strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 rc =3D keyctl_describe_alloc(key, &buf);
> + =A0 =A0 =A0 if (rc =3D=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "keyctl_describe_alloc =
failed: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strerror(errno));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 syslog(LOG_DEBUG, "key description: %s", buf);
> +
> + =A0 =A0 =A0 if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap") - =
1) =3D=3D 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_idmap(key, buf);
> +out:
> + =A0 =A0 =A0 return rc;
> +}
> diff --git a/configure.ac b/configure.ac
> index e0e2a60..6cac703 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
> =A0 =A0 =A0 =A0enable_cifscreds=3D$enableval,
> =A0 =A0 =A0 =A0enable_cifscreds=3D"no")
>
> +AC_ARG_ENABLE(cifsidmap,
> + =A0 =A0 =A0 [AC_HELP_STRING([--enable-cifsidmap],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create cifs.idmap bina=
ry @<:@default=3Dno@:>@])],
> + =A0 =A0 =A0 enable_cifsidmap=3D$enableval,
> + =A0 =A0 =A0 enable_cifsidmap=3D"no")
> +
> =A0# Checks for programs.
> =A0AC_PROG_CC
> =A0AC_PROG_SED
> =A0AC_GNU_SOURCE
>
> =A0# Checks for header files.
> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mn=
tent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount.=
h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERR=
OR([necessary header(s) not found])])
> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mn=
tent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h str=
ing.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.=
h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>
> =A0if test $enable_cifsupcall !=3D "no"; then
> =A0 =A0 =A0 =A0AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> @@ -72,7 +78,7 @@ if test $enable_cifsupcall !=3D "no"; then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fi
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0])
> =A0fi
> -if test $enable_cifsupcall !=3D "no"; then
> +if test $enable_cifsupcall !=3D "no" -o $enable_cifsidmap !=3D "no";=
 then
> =A0 =A0 =A0 =A0AC_CHECK_HEADERS([keyutils.h], , [
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if tes=
t "$enable_cifsupcall" =3D "yes"; then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0AC_MSG_ERROR([keyutils.h not found, consider installing keyutil=
s-libs-devel.])
> @@ -80,6 +86,9 @@ if test $enable_cifsupcall !=3D "no"; then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0AC_MSG_WARN([keyutils.h not found, consider installing keyutils=
-libs-devel. Disabling cifs.upcall.])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0enable_cifsupcall=3D"no"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fi
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 "$enable_cifsidmap" =3D "yes"; then
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([keyutils.h not found, consider installing keyuti=
ls-libs-devel.])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0])
> =A0fi
> =A0if test $enable_cifsupcall !=3D "no"; then
> @@ -89,6 +98,9 @@ if test $enable_cifsupcall !=3D "no"; then
> =A0 =A0 =A0 =A0AC_SUBST(KRB5_LDADD)
> =A0fi
>
> +# checks for wbclient.h and libwbclient.so library
> +AC_TEST_WBCHL
> +
> =A0if test $enable_cifscreds =3D "yes"; then
> =A0 =A0 =A0 =A0AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyuti=
ls.h not found, consider installing keyutils-libs-devel.])])
> =A0fi
> @@ -140,6 +152,7 @@ LIBS=3D$cu_saved_libs
>
> =A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" !=3D =
"no"])
> =A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D "ye=
s"])

> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" =3D "yes"=
])

Jeff, this modified patch looks fine. I will soon get in the man page,
related changes, along with changing this line to !=3D 'no' to complete
all the changes necessary for id mapping.

>
> =A0LIBCAP_NG_PATH
>
> --
> 1.7.5.1
>
>
