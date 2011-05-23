From: Gerald Carter <jerry-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 11:31:34 -0500
Message-ID: <4DDA8BE6.8000001@plainjoe.org>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>	<20110522115938.GA27941@infradead.org>	<20110522081707.72cce108@corrin.poochiereds.net>	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>	<20110523071208.5dc935f8@corrin.poochiereds.net> <BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2E776BF23C708FA3C85551F2"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2E776BF23C708FA3C85551F2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/23/2011 08:42 AM, Steve French wrote:

> Shirish had done some experiments (and AFAIK has a small patch
> that fixed NFS export over CIFS which works, with the usual restriction=
s
> about having to return ESTALE if the NFS client tries to access
> an inode which has been flushed from the cache on the server side).
>=20
>>> For nfs v3 clients that can't handle ESTALE, we are probably
>>> stuck with having to wait for Samba to implement the flag
>> Flag?
>=20
> NTCreateX:  FILE_OPEN_BY_FILE_ID
>=20
> IIRC Shirish verified that the Windows client will emit this flag, but =
their
> server had not gotten around to implementing it (although Samba could
> implement it now that their is an open-by-handle syscall).

Hey Jeff/Steve,

I found in [MS-CIFS] that says a server MUST return STATUS_NOT_SUPPORTED
for this option.



Cheers, Jerry


--------------enig2E776BF23C708FA3C85551F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iD8DBQFN2ovqIR7qMdg1EfYRApJvAJkBAKGLfjzdM1UEWUiBP7b3Pt9chQCgqsUr
OUDZBWytR7zms0MGGPDzbF0=
=cYOO
-----END PGP SIGNATURE-----

--------------enig2E776BF23C708FA3C85551F2--
