From: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Replace cifs md5 hashing functions with kernel
 crypto APIs
Date: Fri, 21 Jan 2011 18:07:48 +0100
Message-ID: <4D39BD64.5080101@samba.org>
References: <1295622245-10581-1-git-send-email-shirishpargaonkar@gmail.com>	<20110121104228.60262dd2@tlielax.poochiereds.net> <AANLkTim3b8TFYYV5dcpOi4DtoLBz1XqdOOt6fTYB88uU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC12AE04CBC2353DF6283B69F"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim3b8TFYYV5dcpOi4DtoLBz1XqdOOt6fTYB88uU-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC12AE04CBC2353DF6283B69F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Shirish,

>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>> Replace remaining use of md5 hash functions local to cifs module
>>> with kernel crypto APIs.
>>> Remove header and source file containing those local functions.
>>>
>>>
>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>>  fs/cifs/Makefile      |    2 +-
>>>  fs/cifs/cifsencrypt.c |    1 -
>>>  fs/cifs/link.c        |   59 +++++++--
>>>  fs/cifs/md5.c         |  366 ---------------------------------------=
----------
>>>  fs/cifs/md5.h         |   38 -----
>>>  fs/cifs/smbencrypt.c  |    1 -
>>>  6 files changed, 51 insertions(+), 416 deletions(-)
>>>  delete mode 100644 fs/cifs/md5.c
>>>  delete mode 100644 fs/cifs/md5.h
>>>
>>
>> Very nice. The CIFS parts look good to me, and I'm always fond of
>> reducing the code we need to support as well as the cifs.ko footprint.=

>> Assuming that mfsymlink support still works after this patch...
>=20
> I did test briefly, e.g. creating symlinks and deleting them.
> Hoping Stefan Metzmacher will comment.
> I did verify that the (md5) hash value was different for different actu=
alpaths

Just test with and without your changes, create symlinks with both
versions which point to
the same target. And verify you can use them with both.
Then you can mount without mfsymlink support and verify that the
lowlevel file
has the same md5sum.

metze


--------------enigC12AE04CBC2353DF6283B69F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk05vXkACgkQm70gjA5TCD+z1wCgo3nyVV5DRKAEBYwTZIiJvLNM
/28AniS4dpx7Kp4FUC6Sy7KTjIerLMhY
=GWrN
-----END PGP SIGNATURE-----

--------------enigC12AE04CBC2353DF6283B69F--
