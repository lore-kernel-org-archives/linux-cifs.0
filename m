From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] cifs: check offset in decode_ntlmssp_challenge()
Date: Tue, 31 Jan 2012 14:25:08 +0300
Message-ID: <20120131112508.GE3294@mwanda>
References: <20120131085201.GB22039@elgon.mountain>
	<20120131054937.3e7ccf89@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7phR3qVEw/4Cnor3"
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20120131054937.3e7ccf89@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org


--7phR3qVEw/4Cnor3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 05:49:37AM -0500, Jeff Layton wrote:
> On Tue, 31 Jan 2012 11:52:01 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
>=20
> > We should check that we're not copying memory from beyond the end of the
> > blob.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >=20
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index d85efad..eb76741 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -395,6 +395,10 @@ static int decode_ntlmssp_challenge(char *bcc_ptr,=
 int blob_len,
> >  	ses->ntlmssp->server_flags =3D le32_to_cpu(pblob->NegotiateFlags);
> >  	tioffset =3D le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
> >  	tilen =3D le16_to_cpu(pblob->TargetInfoArray.Length);
> > +	if (tioffset > blob_len || tioffset + tilen > blob_len) {
> > +		cERROR(1, "tioffset + tilen too high %u + %u", tioffset, tilen);
> > +		return -EINVAL;
> > +	}
>=20
> Good catch.
>=20
> Do we really need a || here though? Would it not be sufficient to check
> if tioffset + tilen > blob_len? Or are you concerned about that value
> wrapping?

Yep.  I was concerned about value wrapping.

regards,
dan carpenter


--7phR3qVEw/4Cnor3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ8+UAAoJEOnZkXI/YHqRqA8P/3pkufoCNuERIIFAZ+9skYoH
ABQP0ysXh4dOBGun4t8HXBjGBgjI7t0mTJtpCqGra5bEBLJlTxBWsSZ9aHwCh1bP
N3xtgGB3epeSCmi5gyRDjtyf52zM3/Ry7zwXfe9J1opnIcczxGIaRpDrB6gIKX2j
ley5dKvySOufn/mEESGREknbXN01hYvz3YxmJFCp74l7XWHlaKRFnApdQ4jWlYLh
wVDdE8H1y90oatoXc2lbfRyDkyskhC97nAWygbzLFDXVC5AWcLATkZXSf7r60tTw
psXsmoMl/YtS7RmQJLitTG87rocKRo94iMLlP9zL0yX3lBC2AWv0iaFwPC9sKtjr
MAQyPrlEhl3VtGGTeDEqUTVFqTroQvO5ovL6qOj60vv+wxFw6m3xasnSvHdLGLqO
/GTLuuY64OvpZi0OY1Ufwmlv1OabRzQ9IkbvgKQC11Ynuu6oMVs9LwBxTXJ+Pr4F
mF3Ka9CZwRQcW77teJG01bLUMjUXwYovqQMZjy7hdMwmv1tqSmpMv4PoIaGHXauI
oOu3EWn+BAFTN4ZXeTAVpKWoNpAWV/dDN38vydURhBtDoZl+ZETfWFdlKw00LIF4
/CpRvcjXpiF/b+tm9Fo3vRPqC3NQiThnxplEKZs7GvwTl3mqzxVggSitMA18ZyPT
wLdDGFOPU9WZ7zfdEDHv
=7Ljr
-----END PGP SIGNATURE-----

--7phR3qVEw/4Cnor3--
