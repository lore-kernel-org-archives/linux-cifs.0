From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a gid
Date: Sat, 11 Dec 2010 15:47:12 -0600
Message-ID: <AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101211111716.1e21be41@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101211111716.1e21be41-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 11, 2010 at 10:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Tue, =A07 Dec 2010 11:11:12 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Use a cifs upcall to map a SID to either an uid or a gid using
>> winbind.
>>
>> There is a corrosponding patch for the cifs.upcall binary in cifs-ut=
ils rpm
>> that is being posted also.
>>
>> A new type of key, cifs_acl_key_type, is used.
>> To map a SID, which can be either a Onwer SID or a Group SID, key
>> description starts with the string "os" or "gs" followed by SID conv=
erted
>> to a string. Without "os" or "gs", cifs.upcall does not know whether
>> SID needs to be mapped to either an uid or a gid.
>>
>> Once a key is instantiated, get rid of it since cifs does not need t=
o
>> use in any way.
>> winbind does the id mapping and looks up name for the newly mapped
>> SID/uid or SID/gid combination.
>>
>> For now, cifs.upcall is only used to map a SID to an id (uid or gid)=
 but
>> it would be used to obtain an SID (string) for an id.
>>
>> An entry such as this
>>
>> create =A0cifs.cifs_acl =A0 * =A0 =A0 =A0 * =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 /usr/sbin/cifs.upcall %k
>>
>> is needed in the file /etc/request-key.conf.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0117 ++++++++++++++++++++++++++++++++++++++=
++++++++++-----
>> =A0fs/cifs/cifsacl.h | =A0 =A08 ++++
>> =A0fs/cifs/cifsfs.c =A0| =A0 =A07 +++
>> =A03 files changed, 122 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index a520091..d3ac6c8 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -23,6 +23,9 @@
>>
>> =A0#include <linux/fs.h>
>> =A0#include <linux/slab.h>
>> +#include <linux/string.h>
>> +#include <keys/user-type.h>
>> +#include <linux/key-type.h>
>> =A0#include "cifspdu.h"
>> =A0#include "cifsglob.h"
>> =A0#include "cifsacl.h"
>> @@ -52,6 +55,102 @@ static const struct cifs_sid sid_authusers =3D {
>> =A0/* group users */
>> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0,=
 5}, {} };
>>
>> +static int
>> +cifs_acl_key_instantiate(struct key *key, const void *data, size_t =
datalen)
>> +{
>> + =A0 =A0 char *payload;
>> +
>> + =A0 =A0 payload =3D kmalloc(datalen, GFP_KERNEL);
>> + =A0 =A0 if (!payload)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 memcpy(payload, data, datalen);
>> + =A0 =A0 key->payload.data =3D payload;
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static void
>> +cifs_acl_key_destroy(struct key *key)
>> +{
>> + =A0 =A0 kfree(key->payload.data);
>> +}
>> +
>> +struct key_type cifs_acl_key_type =3D {
>> + =A0 =A0 .name =A0 =A0 =A0 =A0=3D "cifs.cifs_acl",
>> + =A0 =A0 .instantiate =3D cifs_acl_key_instantiate,
>> + =A0 =A0 .destroy =A0 =A0 =3D cifs_acl_key_destroy,
>> + =A0 =A0 .describe =A0 =A0=3D user_describe,
>> + =A0 =A0 .match =A0 =A0 =A0 =3D user_match,
>> +};
>> +
>
> Nit: these don't have so much to do with ACL's per-se, as much as
> idmapping. Maybe these functions and the key type should be called
> "cifs_idmap_*" and "cifs.idmap" ? It might be clearer to admins what
> this is for.

Yes, will change the name as you suggested, that sounds right, rather
that acl.

>
>> +static void
>> +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
>> +{
>> + =A0 =A0 int i;
>> + =A0 =A0 unsigned long saval;
>> + =A0 =A0 char *strptr;
>> +
>> + =A0 =A0 strptr =3D sidstr;
>> +
>> + =A0 =A0 sprintf(strptr, "%s", "S");
>> + =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> +
>> + =A0 =A0 sprintf(strptr, "-%d", sidptr->revision);
>> + =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> +
>> + =A0 =A0 for (i =3D 0; i < 6; ++i) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidptr->authority[i]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%d", sid=
ptr->authority[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen=
(sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 for (i =3D 0; i < sidptr->num_subauth; ++i) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 saval =3D le32_to_cpu(sidptr->sub_auth[i])=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%ld", saval);
>> + =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> + =A0 =A0 }
>> +}
>> +
>> +static int
>> +sid_to_id(struct cifs_sid *psid, struct cifs_fattr *fattr, uint sid=
type)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 char *sidstr, *strptr;
>> + =A0 =A0 struct key *idkey;
>> +
>> + =A0 =A0 sidstr =3D kzalloc(SIDLEN, GFP_KERNEL);
>> + =A0 =A0 if (!sidstr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 strptr =3D sidstr;
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "%s", "os:");
>> + =A0 =A0 else if (sidtype =3D=3D SIDGROUP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "%s", "gs:");
>> + =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto idresolve_err;
>> + =A0 =A0 }
>> + =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> +
>> + =A0 =A0 sid_to_str(psid, strptr);
>> +
>> + =A0 =A0 idkey =3D request_key(&cifs_acl_key_type, sidstr, "");
>> + =A0 =A0 if (IS_ERR(idkey))
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: idkey error: %d\n", __func__,=
 -ENOKEY);
>> + =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D *(unsign=
ed long *)idkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (sidtype =3D=3D SIDGROUP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D *(unsign=
ed long *)idkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
>> + =A0 =A0 }
>> +
>> +idresolve_err:
>> + =A0 =A0 kfree(sidstr);
>> + =A0 =A0 return rc;
>> +}
>>
>
> What about security? With this code, it'll be possible for a user to
> "stuff" the cache with idmapping. In the situation where the kernel i=
s
> trying to enforce permissions on the client, it'll be possible to
> trick it into mapping a sid to a uid of your choosing. I think you ne=
ed
> to guard against that.

That means cifs module will have to know what was the range of ids for
uids and gids to be allocated by winbind as dictated by entries in
smb.conf and if a returned id happens not to be in that range, discard =
it
and assign default id of 0 (root).
winbind know the range from smb.conf, it could be any smb.conf file,
not necessarily under /etc/samba/smb.conf.
How would cifs module know that range.
Not sure if winbind has an API to query the ranges.  And even if it had=
,
it is possible that winbind deamon itself is not running.

>
> You'll also be doing an upcall every time a different user needs to m=
ap
> a SID to a UID/GID.
>
> Finally, calling into the keys API every time you want to map an ID
> sounds rather inefficient. This might take quite some time if you wer=
e
> doing "ls -l" on a large directory.
>
> Would it be better to consider taking the info in the key and
> populating a different cache? You could register it with a shrinker a=
nd
> prune off LRU entries if memory gets tight.
>

Will look into this.  One thing that concerns me is if a cached etnry
for a SID with its name and an id (either an uid or a gid), if that SID
now represents a different object and has differernt name, would
not cached info be incorrect?  Not sure if this can ever happen
or how would it happen and if it does, what would be a trigger
for a cache revalidation and purges!

> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
