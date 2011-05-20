From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping (try #2)
Date: Fri, 20 May 2011 12:29:24 -0500
Message-ID: <BANLkTim_DOA36jXah7JLpGTMe3oo-YutWw@mail.gmail.com>
References: <1305881355-11026-1-git-send-email-shirishppargaonkar@gmail.com>
	<20110520075157.67286979@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110520075157.67286979-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 20, 2011 at 6:51 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 20 May 2011 03:49:15 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Handle cifs.idmap type of key. Extract a SID string from the descrip=
tion
>> and map it to either an uid or gid using winbind APIs.
>> If that fails (e.g. because winbind is not installed/running or winb=
ind returns
>> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
>> And if that fails, kernel assigns uid and gid (from mount superblock=
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
>> =A0aclocal/idmap.m4 | =A0 24 ++++++
>> =A0cifs.idmap.c =A0 =A0 | =A0219 +++++++++++++++++++++++++++++++++++=
+++++++++++++++++++
>> =A0configure.ac =A0 =A0 | =A0 34 ++++++++-
>> =A04 files changed, 285 insertions(+), 3 deletions(-)
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
>> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
>> new file mode 100644
>> index 0000000..b3dcd92
>> --- /dev/null
>> +++ b/aclocal/idmap.m4
>> @@ -0,0 +1,24 @@
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
>
> Maybe I wasn't clear...
>
> I was trying to suggest moving the check for wbclient headers and
> libraries into a separate function. Then you could call that function
> and base the autoconf tests on its result.
>
>> diff --git a/cifs.idmap.c b/cifs.idmap.c
>> new file mode 100644
>> index 0000000..3c718e7
>> --- /dev/null
>> +++ b/cifs.idmap.c
>> @@ -0,0 +1,219 @@
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
>> + =A0 =A0 syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", pr=
og);
>> + =A0 =A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", p=
rog);
>> +}
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^
> These usage messages look wrong. There's no -t or -l option, AFAICT.
> Also, I'm not sure we should syslog this. We probably ought to remove
> that from cifs.upcall as well...
>
>> +static int
>> +cifs_idmap(const key_serial_t key, const char *key_descr)
>> +{
>> + =A0 =A0 int i;
>> + =A0 =A0 int len;
>> + =A0 =A0 uid_t uid =3D 0;
>> + =A0 =A0 gid_t gid =3D 0;;
>> + =A0 =A0 wbcErr rc =3D 1;
>> + =A0 =A0 const char *keystart =3D key_descr;
>> + =A0 =A0 const char *keyend =3D key_descr;
>> + =A0 =A0 struct wbcDomainSid sid;
>> + =A0 =A0 struct passwd *pw;
>> + =A0 =A0 struct group *gr;
>> +
>> + =A0 =A0 len =3D strlen(key_descr);
>> + =A0 =A0 /* skip next 4 ';' delimiters to get to description */
>> + =A0 =A0 for (i =3D 1; i <=3D 4; ++i) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D index(keyend + 1, ';');
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!keyend) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "invalid k=
ey description: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key_descr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> + =A0 =A0 if (keyend - keystart < len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend++;
>> + =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "Invalid key: %s", keystar=
t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>
> I still worry somewhat about buffer overruns here (and this is probab=
ly
> an issue in cifs.upcall too). I wonder whether we'd be better off
> having a separate function that returns the part of the key descripti=
on
> that we're interested in, after verifying that it's NULL terminated.
>
> That could be put in a separate object file that both cifs.upcall and
> cifs.idmap link in.

Jeff,

Is not this problem specific to two functions cifs_resolver()
and cifs_idmap()?
And I think you had mentioned earlier that
"The DNS upcall code in this program is going to deprecated
eventually in favor of the one provided by keyutils."

Would that mean eventually cifs_resolver() function would disappear
and so  this concern only applies to handling of key_descr
in just the function cifs_idmap() i.e. no code in cifs.upcall would nee=
d
the separate function?

Regards,

Shirish
>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Use winbind to convert received string to a SID and l=
ookup
>> + =A0 =A0 =A0* name and map that SID to an uid. =A0If either of thes=
e
>> + =A0 =A0 =A0* function calls return with an error, =A0use system ca=
lls to obtain
>> + =A0 =A0 =A0* uid of user "nobody". If winbind fails to map a SID t=
o an UID
>> + =A0 =A0 =A0* and there is no user named "nobody", return error to =
the
>> + =A0 =A0 =A0* upcall caller. Otherwise instanticate a key using tha=
t uid.
>> + =A0 =A0 =A0*
>> + =A0 =A0 =A0* The same applies to SID and gid mapping. =A0Instead o=
f a
>> + =A0 =A0 =A0* user "nobody", user "nogroup" is looked up if winbind
>> + =A0 =A0 =A0* fails to map a SID to a gid.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 keystart =3D keyend;
>> + =A0 =A0 len =3D strlen(keyend);
>> + =A0 =A0 if (strncmp(keyend, "os", 2) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D index(keyend + 1, ':');
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (keyend - keystart < len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 keyend++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "Invalid o=
wner SID: %s", keystart);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(keyend, &sid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "O strto=
sid: %s, rc: %d", keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToUid(&sid, &=
uid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to uid wbc error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) { /* either of the two wbcSid func=
tions failed */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pw =3D getpwnam("nobody");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!pw)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to uid pw error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid =3D pw=
->pw_uid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
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
>> + =A0 =A0 } else if (strncmp(keyend, "gs", 2) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D index(keyend + 1, ':');
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (keyend - keystart < len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 keyend++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "Invalid G=
roup SID: %s", keystart);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcStringToSid(keyend, &sid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "O strto=
sid: %s, rc: %d", keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wbcSidToGid(&sid, &=
gid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to gid wbc error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) { /* either of the two wbcSid func=
tions failed */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gr =3D getgrnam("nogroup")=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!gr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_DEBUG, "SID %s to gid pw error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 keyend, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid =3D gr=
->gr_gid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
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
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Invalid SID: %s", keyen=
d);
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
>> diff --git a/configure.ac b/configure.ac
>> index e0e2a60..d8f4290 100644
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
>> @@ -89,6 +101,23 @@ if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 AC_SUBST(KRB5_LDADD)
>> =A0fi
>>
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
>> +
>> =A0if test $enable_cifscreds =3D "yes"; then
>> =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils=
=2Eh not found, consider installing keyutils-libs-devel.])])
>> =A0fi
>> @@ -140,6 +169,7 @@ LIBS=3D$cu_saved_libs
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
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
