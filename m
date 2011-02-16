From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: handle cifs_idmap type of key to map a SID to
 either an uid or gid (try #5)
Date: Wed, 16 Feb 2011 12:05:34 -0600
Message-ID: <AANLkTin4fidAT_osBUKV9TC+X-j66Gr7qteQpcX0kMOJ@mail.gmail.com>
References: <1297450149-31632-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110215154559.56ce5169@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110215154559.56ce5169-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Feb 15, 2011 at 2:45 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 11 Feb 2011 12:49:09 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
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
>> =A0cifs.upcall.c | =A0 98 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A02 files changed, 99 insertions(+), 1 deletions(-)
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 67a0190..c9018ae 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -11,7 +11,7 @@ man_MANS =3D mount.cifs.8
>> =A0if CONFIG_CIFSUPCALL
>> =A0sbin_PROGRAMS =3D cifs.upcall
>> =A0cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spnego.c=
 util.c
>> -cifs_upcall_LDADD =3D -ltalloc -lkeyutils $(KRB5_LDADD)
>> +cifs_upcall_LDADD =3D -ltalloc -lwbclient -lkeyutils $(KRB5_LDADD)
>> =A0man_MANS +=3D cifs.upcall.8
>>
>> =A0#
>> diff --git a/cifs.upcall.c b/cifs.upcall.c
>> index 479517c..fe8a6ad 100644
>> --- a/cifs.upcall.c
>> +++ b/cifs.upcall.c
>> @@ -45,6 +45,13 @@
>> =A0#include <time.h>
>> =A0#include <netdb.h>
>> =A0#include <arpa/inet.h>
>> +#include <stdint.h>
>> +#include <stdbool.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <errno.h>
>> +#include <limits.h>
>> +#include <wbclient.h>
>>
>> =A0#include "util.h"
>> =A0#include "replace.h"
>> @@ -695,6 +702,91 @@ static int cifs_resolver(const key_serial_t key=
, const char *key_descr)
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantiate(=
key, &uid, sizeof(uid_t), 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_ERR, "%s: key inst: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0Instead of all this if then nesting and continual chec=
king for
> =A0 =A0 =A0 =A0the value of rc, I think it would be easier to follow =
the logic
> =A0 =A0 =A0 =A0and maintain this if it instead either did a "goto out=
" in the
> =A0 =A0 =A0 =A0error cases or just did a return when it hits an error=
=2E

Will comments help?  I thought of using function calls and goto calls
but none of them will make readability and logic any easier.
There are five different calls, and if either of first two fail, insete=
ad of
returning, third one gets called and all calls are different
(e.g. if either of wbcStringToSid or wbcSidToUid, getpwnam should
be called and if either of  wbcStringToSid or wbcSidToGid fail,
getgrnam should be called.
keyctl_instantiate should be called if either  wbcSidToUid or getpwnam
succeed (in that order) or  if either wbcSidToGid or getgrnam succeed
(in that order).
It would not be any clearer to follow this with goto statements.

>
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D keyctl_instantiate(=
key, &gid, sizeof(gid_t), 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG=
_ERR, "%s: key inst: %s",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 __func__, strerror(errno));
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "Invalid SID");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^=
^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Might be helpful to know what that SID=
 is, don't you
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0think?

yes, will fix this.

>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0/*
>> =A0 * Older kernels sent IPv6 addresses without colons. Well, at lea=
st
>> =A0 * they're fixed-length strings. Convert these addresses to have =
colon
>> @@ -833,6 +925,12 @@ int main(const int argc, char *const argv[])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 if ((strncmp(buf, "cifs.cifs_idmap", sizeof("cifs.cifs_idm=
ap") - 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D 0)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_sid_resolver(key, buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 have =3D decode_key_description(buf, &arg);
>> =A0 =A0 =A0 SAFE_FREE(buf);
>> =A0 =A0 =A0 if ((have & DKD_MUSTHAVE_SET) !=3D DKD_MUSTHAVE_SET) {
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
