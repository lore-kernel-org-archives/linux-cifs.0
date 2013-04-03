From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: on send failure, readjust server sequence number
 downward
Date: Wed, 3 Apr 2013 15:02:27 -0400
Message-ID: <20130403150227.25f37cce@tlielax.poochiereds.net>
References: <1365012430-6795-1-git-send-email-jlayton@redhat.com>
	<515C7AF2.3090902@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cTNScZR1bLjDFobf0D9fG1j"; protocol="application/pgp-signature"
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515C7AF2.3090902-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/cTNScZR1bLjDFobf0D9fG1j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Apr 2013 14:54:42 -0400
Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 04/03/2013 02:07 PM, Jeff Layton wrote:
> > If sending a call to the server fails for some reason (for instance, the
> > sending thread caught a signal), then we must readjust the sequence
> > number downward again or the next send will have it too high.
> >=20
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/smb1ops.c   |  3 +++
> >  fs/cifs/transport.c | 13 +++++++++++++
> >  2 files changed, 16 insertions(+)
> >=20
> > diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> > index 23bcd11..3efdb9d 100644
> > --- a/fs/cifs/smb1ops.c
> > +++ b/fs/cifs/smb1ops.c
> > @@ -61,6 +61,9 @@ send_nt_cancel(struct TCP_Server_Info *server, void *=
buf,
> >  	 */
> >  	--server->sequence_number;
> >  	rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
> > +	if (rc < 0)
> > +		server->sequence_number--;
> > +
> >  	mutex_unlock(&server->srv_mutex);
> > =20
> >  	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc =3D %d\n",
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 653bf26..293d2c8 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -522,6 +522,9 @@ cifs_call_async(struct TCP_Server_Info *server, str=
uct smb_rqst *rqst,
> >  	rc =3D smb_send_rqst(server, rqst);
> >  	cifs_in_send_dec(server);
> >  	cifs_save_when_sent(mid);
> > +
> > +	if (rc < 0)
> > +		server->sequence_number -=3D 2;
> >  	mutex_unlock(&server->srv_mutex);
> > =20
> >  	if (rc =3D=3D 0)
> > @@ -711,6 +714,8 @@ SendReceive2(const unsigned int xid, struct cifs_se=
s *ses,
> >  	cifs_in_send_dec(ses->server);
> >  	cifs_save_when_sent(midQ);
> > =20
> > +	if (rc < 0)
> > +		ses->server->sequence_number -=3D 2;
> >  	mutex_unlock(&ses->server->srv_mutex);
> > =20
> >  	if (rc < 0) {
> > @@ -835,6 +840,10 @@ SendReceive(const unsigned int xid, struct cifs_se=
s *ses,
> >  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_leng=
th));
> >  	cifs_in_send_dec(ses->server);
> >  	cifs_save_when_sent(midQ);
> > +
> > +	if (rc < 0)
> > +		ses->server->sequence_number -=3D 2;
> > +
> >  	mutex_unlock(&ses->server->srv_mutex);
> > =20
> >  	if (rc < 0)
> > @@ -968,6 +977,10 @@ SendReceiveBlockingLock(const unsigned int xid, st=
ruct cifs_tcon *tcon,
> >  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_leng=
th));
> >  	cifs_in_send_dec(ses->server);
> >  	cifs_save_when_sent(midQ);
> > +
> > +	if (rc < 0)
> > +		ses->server->sequence_number -=3D 2;
> > +
> >  	mutex_unlock(&ses->server->srv_mutex);
> > =20
> >  	if (rc < 0) {
> >=20
>=20
> I was re-prioritized...I'll test the patches you'd like me to test just
> as soon as I can. At that point, I'll prod the list and ask for an
> up-to-date list of the patchset you'd like me to try.
>=20

This one is current vs. mainline as of today. It'll probably need to be
backported to RHEL6 though. The other one you'll want to test is commit
31efee60f489c75 in the mainline tree. It too will need to be backported
to rhel6, but that shouldn't be too hard...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/cTNScZR1bLjDFobf0D9fG1j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXHzDAAoJEAAOaEEZVoIVGb0QAKIZ+HyvQ3f6y4NRWNTxVnmv
kwOwqWHSDV6EFEjcnSq3WBL8mvbZX5zF1TvfLJqUHVhG7zcaq7eJlg82pCKh084t
fcwh1iuA6+A63HY7Ka1YJFgZCjShC6p646159+uX/3vqkoRUdWTlOkXj2o0aQ2eK
lLQw5RQ/Hfi/Eq2CG1eKj0wSzkdiuO/Mr3vUBhNv6ecfnzROJTtRLTtlRISU3Dy7
F3eDFTWmeNiJvO3QQLUo3bd56fuXJjNO+zt9lJQDL+0WdmgQH2fFixnnJ0fntvsD
tirbzPAAmwuK+XXLWGojd/COfqojXY4YU3Vm+4fRWCSfzwFuLIx1gJIfUDiGJy43
MSspy2ULJuV0nk/zOWuKgZWDr8TUoKZBwkumL/RTL+o5IxEI9WucUVkadVGjU+Km
BtujiKzJaBdcfkiAkTEhpAyP4veXZaYLveGbfWyyAG5hBByOJH2dqyZl3AzPKzHh
/2KK/N4YBlJSUMhQVCQyht+WwaXmgf1B5a+sIZNohcZBdeLLINpRIGaRrzhfHxeZ
Yt9i2B0j84Gz2EnL9sSBvQhWQ/cUteJKv5G9KvElVl8Xbj5eJvLuIyanygl189ee
p+SK2Ke9D7PKTcSpecyK0VvjbuHcEnqczFD+v9bVW9XHqYmXOFJttQ601HhCKPCg
myt5zu09fqcpx6uSm2jH
=kboe
-----END PGP SIGNATURE-----

--Sig_/cTNScZR1bLjDFobf0D9fG1j--
