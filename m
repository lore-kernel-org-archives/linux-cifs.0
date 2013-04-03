From: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: on send failure, readjust server sequence number
 downward
Date: Wed, 03 Apr 2013 14:54:42 -0400
Message-ID: <515C7AF2.3090902@gmail.com>
References: <1365012430-6795-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2IAQDSMRNQSXOKAAJQDRV"
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365012430-6795-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2IAQDSMRNQSXOKAAJQDRV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2013 02:07 PM, Jeff Layton wrote:
> If sending a call to the server fails for some reason (for instance, th=
e
> sending thread caught a signal), then we must readjust the sequence
> number downward again or the next send will have it too high.
>=20
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb1ops.c   |  3 +++
>  fs/cifs/transport.c | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
>=20
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 23bcd11..3efdb9d 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -61,6 +61,9 @@ send_nt_cancel(struct TCP_Server_Info *server, void *=
buf,
>  	 */
>  	--server->sequence_number;
>  	rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));=

> +	if (rc < 0)
> +		server->sequence_number--;
> +
>  	mutex_unlock(&server->srv_mutex);
> =20
>  	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc =3D %d\n",
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 653bf26..293d2c8 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -522,6 +522,9 @@ cifs_call_async(struct TCP_Server_Info *server, str=
uct smb_rqst *rqst,
>  	rc =3D smb_send_rqst(server, rqst);
>  	cifs_in_send_dec(server);
>  	cifs_save_when_sent(mid);
> +
> +	if (rc < 0)
> +		server->sequence_number -=3D 2;
>  	mutex_unlock(&server->srv_mutex);
> =20
>  	if (rc =3D=3D 0)
> @@ -711,6 +714,8 @@ SendReceive2(const unsigned int xid, struct cifs_se=
s *ses,
>  	cifs_in_send_dec(ses->server);
>  	cifs_save_when_sent(midQ);
> =20
> +	if (rc < 0)
> +		ses->server->sequence_number -=3D 2;
>  	mutex_unlock(&ses->server->srv_mutex);
> =20
>  	if (rc < 0) {
> @@ -835,6 +840,10 @@ SendReceive(const unsigned int xid, struct cifs_se=
s *ses,
>  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_leng=
th));
>  	cifs_in_send_dec(ses->server);
>  	cifs_save_when_sent(midQ);
> +
> +	if (rc < 0)
> +		ses->server->sequence_number -=3D 2;
> +
>  	mutex_unlock(&ses->server->srv_mutex);
> =20
>  	if (rc < 0)
> @@ -968,6 +977,10 @@ SendReceiveBlockingLock(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>  	rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_leng=
th));
>  	cifs_in_send_dec(ses->server);
>  	cifs_save_when_sent(midQ);
> +
> +	if (rc < 0)
> +		ses->server->sequence_number -=3D 2;
> +
>  	mutex_unlock(&ses->server->srv_mutex);
> =20
>  	if (rc < 0) {
>=20

I was re-prioritized...I'll test the patches you'd like me to test just
as soon as I can. At that point, I'll prod the list and ask for an
up-to-date list of the patchset you'd like me to try.


------enig2IAQDSMRNQSXOKAAJQDRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRXHr1AAoJED5TcEBdxYwQrVEH+QFs3HkFbPBOGWuDnyajHUW9
uvq59vYvEEc4pbFYYAGIInIQBrbcF8Joh9RwOfbYQFuJe6vxt/832HVM1xh30/6T
3MvwFL4VjHGAb4vYQeSrRWBAB33S0wgwTbWRZGQv5rjVLV4FCGD5aKL21al3tvaZ
6Uw+wtZd1UXAyNumnt8SR9ldL1C0Cw5yRLITsWy4XKhZRduPqNwgsE9+BeQ+sS+C
4AEHb68r9feFoKBEH4NZyxqRNGTappXJFczApi3ViQaihJWUbagWc+RQqzJL8qhG
BVDFItI7Xooprk/txxDlBzz3odeXnQpoOMeT4Pwjc+6jyctkz9EvX9CnipfsPlw=
=3pNW
-----END PGP SIGNATURE-----

------enig2IAQDSMRNQSXOKAAJQDRV--
