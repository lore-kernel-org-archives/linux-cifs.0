From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Handle cifs_idmap type of key to map a SID to
 either an uid or gid (try #17 repost)
Date: Mon, 2 May 2011 07:35:34 -0500
Message-ID: <BANLkTinqwRT+ao2mhBohS89hTu9YgBNfnw@mail.gmail.com>
References: <1303914990-7804-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110502075145.7dc3e1bc@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502075145.7dc3e1bc-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 2, 2011 at 6:51 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 27 Apr 2011 09:36:30 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Handle cifs_idmap type of key. Extract a SID string from the descrip=
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
>> create =A0cifs.cifs_idmap =A0 * =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /usr/sbin/cifs.upcall %k
>>
>> is needed in the file /etc/request-key.conf.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0Makefile.am =A0 | =A0 =A02 +-
>> =A0cifs.upcall.c | =A0117 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++-
>> =A0configure.ac =A0| =A0 35 +++++++++++++++++
>> =A03 files changed, 152 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 67a0190..13b6c16 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -11,7 +11,7 @@ man_MANS =3D mount.cifs.8
>> =A0if CONFIG_CIFSUPCALL
>> =A0sbin_PROGRAMS =3D cifs.upcall
>> =A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spnego.c=
 util.c
>> -cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
>> +cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD) $(WINB_LDAD=
D)
>> =A0man_MANS +=3D cifs.upcall.8
>>
>> =A0#
>> diff --git a/cifs.upcall.c b/cifs.upcall.c
>> index 479517c..6c2088b 100644
>> --- a/cifs.upcall.c
>> +++ b/cifs.upcall.c
>> @@ -45,6 +45,15 @@
>> =A0#include <time.h>
>> =A0#include <netdb.h>
>> =A0#include <arpa/inet.h>
>> +#include <stdint.h>
>> +#include <stdbool.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <errno.h>
>> +#include <limits.h>
>> +#ifdef HAVE_WBCLIENT_H
>> +#include <wbclient.h>
>> +#endif /* HAVE_WBCLIENT_H */
>>
>> =A0#include "util.h"
>> =A0#include "replace.h"
>> @@ -653,7 +662,7 @@ static int cifs_resolver(const key_serial_t key,=
 const char *key_descr)
>> =A0 =A0 =A0 const char *keyend =3D key_descr;
>> =A0 =A0 =A0 /* skip next 4 ';' delimiters to get to description */
>> =A0 =A0 =A0 for (c =3D 1; c <=3D 4; c++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D index(keyend + 1, ';');
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D rindex(keyend + 1, ';');
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!keyend) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_ERR, "invalid=
 key description: %s",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key_descr=
);
>> @@ -695,6 +704,105 @@ static int cifs_resolver(const key_serial_t ke=
y, const char *key_descr)
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> +#ifdef HAVE_LIBWBCLIENT
>> +static int
>> +cifs_sid_resolver(const key_serial_t key, const char *key_descr)
>> +{
>> + =A0 =A0 int i;
>> + =A0 =A0 uid_t uid =3D 0;
>> + =A0 =A0 gid_t gid =3D 0;;
>> + =A0 =A0 wbcErr rc =3D 1;
>> + =A0 =A0 const char *keyend =3D key_descr;
>> + =A0 =A0 struct wbcDomainSid sid;
>> + =A0 =A0 struct passwd *pw;
>> + =A0 =A0 struct group *gr;
>> +
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
>> + =A0 =A0 keyend++;
>> +
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
>> + =A0 =A0 if (strncmp(keyend, "os", 2) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend =3D index(keyend + 1, ':');
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend++;
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) { /* SID has been mapped to a uid=
 */
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 keyend++;
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
>> +#endif /* HAVE_LIBWBCLIENT */
>> +
>> =A0/*
>> =A0 * Older kernels sent IPv6 addresses without colons. Well, at lea=
st
>> =A0 * they're fixed-length strings. Convert these addresses to have =
colon
>> @@ -832,6 +940,13 @@ int main(const int argc, char *const argv[])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_resolver(key, buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>> +#ifdef HAVE_LIBWBCLIENT
>> + =A0 =A0 if ((strncmp(buf, "cifs.cifs_idmap", sizeof("cifs.cifs_idm=
ap") - 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D 0)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_sid_resolver(key, buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +#endif /* HAVE_LIBWBCLIENT */
>>
>> =A0 =A0 =A0 have =3D decode_key_description(buf, &arg);
>> =A0 =A0 =A0 SAFE_FREE(buf);
>> diff --git a/configure.ac b/configure.ac
>> index e0e2a60..45800bd 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -89,6 +89,41 @@ if test $enable_cifsupcall !=3D "no"; then
>> =A0 =A0 =A0 AC_SUBST(KRB5_LDADD)
>> =A0fi
>>
>> +if test $enable_cifsupcall !=3D "no"; then
>> + =A0 =A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
>> + =A0 =A0 =A0 =A0 =A0 =A0 [ WINB_LDADD=3D'-lwbclient' ] [ AC_DEFINE(=
HAVE_LIBWBCLIENT, 1, ["define a var"]) ], AC_MSG_ERROR([no functioning =
wbclient library found!]))
>> + =A0 =A0 AC_SUBST(WINB_LDADD)
>> +fi
>> +
>> +if test $enable_cifsupcall !=3D "no"; then
>> + =A0 =A0 AC_CHECK_HEADERS([stdbool.h])
>> + =A0 =A0 AC_CHECK_HEADERS([stdio.h])
>> + =A0 =A0 AC_CHECK_HEADERS([errno.h])
>> + =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [AC_MSG_ERROR([wbclient.h=
 not found, consider installing libwbclient-devel.])],
>> +[#ifdef HAVE_STDINT_H
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
>> +]
>> +)
>> +fi
>
> What on earth is the stuff above? configure.ac is at it's heart a she=
ll
> script, so I'm pretty sure the above will end up looking like a bunch
> of comments wrapped in square brackets.
>

Without it, I see following in config.log

checking wbclient.h usability... no
checking wbclient.h presence... yes
configure: WARNING: wbclient.h: present but cannot be compiled
configure: WARNING: wbclient.h:     check for missing prerequisite head=
ers?
configure: WARNING: wbclient.h: see the Autoconf documentation
configure: WARNING: wbclient.h:     section "Present But Cannot Be Comp=
iled"
configure: WARNING: wbclient.h: proceeding with the preprocessor's resu=
lt
configure: WARNING: wbclient.h: in the future, the compiler will take p=
recedence
configure: WARNING:     ## ----------------------------------- ##
configure: WARNING:     ## Report this to cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org ##
configure: WARNING:     ## ----------------------------------- ##
checking for wbclient.h... yes

With it, this

checking for wbcStringToSid in -lwbclient... yes
checking stdbool.h usability... yes
checking stdbool.h presence... yes
checking for stdbool.h... yes
checking stdio.h usability... yes
checking stdio.h presence... yes
checking for stdio.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking for wbclient.h... yes

>> +
>> +# Checks for typedefs, structures, and compiler characteristics.
>> =A0if test $enable_cifscreds =3D "yes"; then
>> =A0 =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils=
=2Eh not found, consider installing keyutils-libs-devel.])])
>> =A0fi
>
>
>
> I think this code should be a separate program. I realize that we hav=
e
> precedent for making this part of the same binary since the SPNEGO an=
d
> DNS upcalls are that way, but I don't think that was a good choice in
> retrospect.
>
> These programs ought to be small and single-purpose. If you add this
> in, then every time you do a SPENGO upcall, you'll get the wb_client
> libs linked in. Vice versa for the idmapping upcall wrt to krb5 libs
> (which is really a bigger problem). So, keeping them as part of the
> same program has clear drawbacks. It also makes the code more messy.
>
> The DNS part of this program should (eventually) go away now that it'=
s
> part of a unified kernel infrastructure. At that point cifs.upcall wi=
ll
> be a SPNEGO upcall only again. Let's foster that by making this a
> separate program in its own right.
>
> With that change too, I'd like to see a --enable-cifsidmap option or
> something that allows the new program to be conditionally compiled.
> That can default to "on" but should autodisable when libwbclient or
> other needed libs aren't present.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
