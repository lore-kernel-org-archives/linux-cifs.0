From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: sparse warning in cifsacl.c
Date: Fri, 27 May 2011 15:32:11 -0500
Message-ID: <BANLkTin-iQ7mrPifK-wM1BfM1HO6GsbjcQ@mail.gmail.com>
References: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng@mail.gmail.com>
	<20110527154459.1da9c523@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110527154459.1da9c523-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

OK - after you and shirish take a look will send this trivial delta up
as a 2nd patch (the other is already merged).  I wish compiler were
smart enough to figure this out ... but Jeff's point makes sense.

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 5f02b4e..8f17006 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone =3D {
 	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
 /* security id for Authenticated Users system group */
 static const struct cifs_sid sid_authusers =3D {
-	1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
+	1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11)} };
 /* group users */
 static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0, 5}, =
{} };


On Fri, May 27, 2011 at 2:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 26 May 2011 23:48:45 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Shirish - below is a patch to fix a sparse warning in the cifsacl
>> code. =A0The change around line 458 is cosmetic (doesn't look like t=
he
>> original code caused a problem but at least this quiets sparse) but
>> doesn't sid_authusers have an endian error. =A0 How far back does th=
is
>> bug go - does it affect much?
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index 076b69c..5f02b4e 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone =3D {
>> =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>> =A0/* security id for Authenticated Users system group */
>> =A0static const struct cifs_sid sid_authusers =3D {
>> - =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };
>> + =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0^^^^^^^^^
> This will break on big-endian arches. You need to use
> __constant_cpu_to_le32() instead.
>
>> =A0/* group users */
>> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0,=
 5}, {} };
>>
>> @@ -458,7 +458,8 @@ int compare_sids(const struct cifs_sid *ctsid,
>> const struct cifs_sid *cwsid)
>> =A0 =A0 =A0 if (num_subauth) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < num_subauth; ++i) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->sub_auth[i] !=
=3D cwsid->sub_auth[i]) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid-=
>sub_auth[i] > cwsid->sub_auth[i])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (le32_t=
o_cpu(ctsid->sub_auth[i]) >
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 le32_to_cpu(cwsid->sub_auth[i]))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 return 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 return -1;
>>
>>
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Thanks,

Steve
