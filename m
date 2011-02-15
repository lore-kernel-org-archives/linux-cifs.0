From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Add idmap key and related data structures and
 functions (try #5)
Date: Tue, 15 Feb 2011 14:21:52 -0600
Message-ID: <AANLkTinkFm5PXnDbET-ywXJ86+SWxgX_YtfBYGBNNwC8@mail.gmail.com>
References: <1297450136-31586-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110215151638.62a96a14@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110215151638.62a96a14-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Feb 15, 2011 at 2:16 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 11 Feb 2011 12:48:56 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Define (global) data structures to store ids, uids and gids, to whic=
h a
>> SID maps. =A0There are two separate trees, one for SID/uid and anoth=
er one
>> for SID/gid.
>>
>> A new type of key, cifs_idmap_key_type, is used.
>>
>> Keys are instantiated and searched using credential of the root by
>> overriding and restoring the credentials of the caller requesting th=
e key.
>> Once a SID is mapped, it is stored along with the mapped id, in one
>> of the rb trees and key is released.
>>
>> Register a pruning function with the shrinker that prunes the rb tre=
es
>> when memory pressure warrants freeing up cache. =A0Just for now, it =
is
>> more like cleaning entire cache than pruning. =A0The subsequent patc=
h has
>> this function defined.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c =A0 | =A0138 ++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A07 +++
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 ++
>> =A0fs/cifs/cifsproto.h | =A0 =A03 +
>> =A04 files changed, 153 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index beeebf1..388b34c 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -23,6 +23,10 @@
>>
>> =A0#include <linux/fs.h>
>> =A0#include <linux/slab.h>
>> +#include <linux/string.h>
>> +#include <linux/keyctl.h>
>> +#include <linux/key-type.h>
>> +#include <keys/user-type.h>
>> =A0#include "cifspdu.h"
>> =A0#include "cifsglob.h"
>> =A0#include "cifsacl.h"
>> @@ -50,6 +54,140 @@ static const struct cifs_sid sid_authusers =3D {
>> =A0/* group users */
>> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0,=
 5}, {} };
>>
>> +static const struct cred *root_cred;
>> +
>> +/*
>> + * Run idmap cache shrinker.
>> + */
>> +static int
>> +cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t =
gfp_mask)
>> +{
>> + =A0 =A0 /* Use a pruning scheme in a subsequent patch instead */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0maybe add the standard "FIXME:" prefix? to the comment=
 above?
>
>> + =A0 =A0 cifs_destroy_idmaptrees();
>> + =A0 =A0 return 0;
>> +}
>> +
>
> Aside from the trivial comment fix, this looks OK, I guess. Eventuall=
y
> it would be good to have a more selective pruning scheme than just
> dropping the entire idmap cache.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, that comment and invocation of function cifs_destroy_idmaptrees
goes away in the patch 2/2.

Regards,

Shirish
