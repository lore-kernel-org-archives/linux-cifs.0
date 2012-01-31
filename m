From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: check offset in decode_ntlmssp_challenge()
Date: Tue, 31 Jan 2012 06:50:07 -0500
Message-ID: <20120131065007.48437316@tlielax.poochiereds.net>
References: <20120131085201.GB22039@elgon.mountain>
	<20120131054937.3e7ccf89@tlielax.poochiereds.net>
	<20120131112508.GE3294@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O1TZwJsEylf__pXK+z5XObZ"; protocol="application/pgp-signature"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120131112508.GE3294@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/O1TZwJsEylf__pXK+z5XObZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jan 2012 14:25:08 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Jan 31, 2012 at 05:49:37AM -0500, Jeff Layton wrote:
> > On Tue, 31 Jan 2012 11:52:01 +0300
> > Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >=20
> > > We should check that we're not copying memory from beyond the end of =
the
> > > blob.
> > >=20
> > > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >=20
> > > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > > index d85efad..eb76741 100644
> > > --- a/fs/cifs/sess.c
> > > +++ b/fs/cifs/sess.c
> > > @@ -395,6 +395,10 @@ static int decode_ntlmssp_challenge(char *bcc_pt=
r, int blob_len,
> > >  	ses->ntlmssp->server_flags =3D le32_to_cpu(pblob->NegotiateFlags);
> > >  	tioffset =3D le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
> > >  	tilen =3D le16_to_cpu(pblob->TargetInfoArray.Length);
> > > +	if (tioffset > blob_len || tioffset + tilen > blob_len) {
> > > +		cERROR(1, "tioffset + tilen too high %u + %u", tioffset, tilen);
> > > +		return -EINVAL;
> > > +	}
> >=20
> > Good catch.
> >=20
> > Do we really need a || here though? Would it not be sufficient to check
> > if tioffset + tilen > blob_len? Or are you concerned about that value
> > wrapping?
>=20
> Yep.  I was concerned about value wrapping.
>=20
> regards,
> dan carpenter
>=20

Seems reasonable then. Thanks...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/O1TZwJsEylf__pXK+z5XObZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPJ9VwAAoJEAAOaEEZVoIVaK8QAJJ6BGwtw/SprlIBAXXqq6bZ
M6hwHbdlsKGegrF1We7OAaCQdQKSHz0/4YjNOOy97qdfDwIUR/acMcaX09HuYYn6
gMU5qKLFXGJKrfdZN5W27gYSeCXUDS1Z4TXKa68dAqDQgA/e45P1o78F0PnJmkRm
ak6dbI7d7aY0J3dZRJmzgFYw6+KeWNDAPTjzYLrVV0wFxU9kjRZwsCY/Gh3eq7ob
WD+V8poP/J5KaXdzYmwqElCVKSPnRlEk7W7gKQCqSAljC2iVprWOzRz8IgMdcUyW
ZRrNe26k7yOxD19qbbNfKlpfBWuDl+801ERNcsd3Kw9L22HoyIIdp1EpgUpBcUTg
CjZ1rm6KI6lPB0qYUG4Gcv9C+UKBtqmCrjnj67rw0tjTi5XgOTZJFLHzBMzAkNq/
Lk7XQasL+tfZzGZWgEdk8/Ccdl1ZOSTWRk/kmRzXBp1ABBGWVksmtD3y6kw+IOOl
Llp/Vza97E0KKpSENz6CsN04v71joMmCjwZbBJmqqYyA5VB8UZTtZPUvuwPc/xU5
fkJJIjxwj7u6EHZCHjwO9pMxUFv+JbJ/ZQL+PdjWtLxv+tmuOsSl6sVxbKmK7S7h
51G528Bzb1o7M6nGeJiuh0hl+r0aH9LDtGRBi7GxTHs05+Vo4UogrW5iO15nhBEN
kSzYBSDkhOjOngEk7k3N
=D38r
-----END PGP SIGNATURE-----

--Sig_/O1TZwJsEylf__pXK+z5XObZ--
