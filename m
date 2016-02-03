From: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: cifs: out-of-bound write in build_ntlmssp_auth_blob()
Date: Wed, 3 Feb 2016 15:48:17 +0100
Message-ID: <56B21331.1010402@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qoKVTFexUiwrtjk14eawORLd0TRnb4tH8"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"'linux-kernel'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qoKVTFexUiwrtjk14eawORLd0TRnb4tH8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

While running some test, KASan detected several out-of-bound write
accesses to the ntlmssp blob in build_ntlmssp_auth_blob(). In this case,
the ntlmssp blob was allocated in sess_auth_rawntlmssp_authenticate().
Its size is an "empirical" 5*sizeof(struct _AUTHENTICATE_MESSAGE) (320B
on x86_64). I don't know where this value comes from or if it was ever
appropriate, but it is currently insufficient: the user and domain name
in UTF16 could take 1kB by themselves. I'm not sure what's the proper
way to fix this. Naively I'd say to allocate the blob dynamically in
build_ntlmssp_auth_blob().
While I haven't run into the issue, the size of ntlmssp_blob in
SMB2_sess_setup is too small too (sizeof(struct _NEGOTIATE_MESSAGE) + 500=
).

Regards,
Jerome Marchand


--qoKVTFexUiwrtjk14eawORLd0TRnb4tH8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWshMxAAoJEHTzHJCtsuoC2C4IAJecxY41EYlyOdZdjfUsKitr
nHTSUdWi571Lw+5BbDAMAyQuxb+DmK0eXiI0CHAusZlpHIXeO56kCD2xHT9btbsg
uRqzgiIDT8esguAKAnOpraNpL5m2t5rkhcAgiv/a1336GPrAZ5oUZsveGTFb5s9q
ewsSC3aFrmS7jWUc5uTgE4Ktj2KIXQ8iAnDfLQTLCfgCZ/PUkciM31zISUSY4Zjf
/sm3OtrY4OCezZf+z4eIlKoMG02zzmg0Q2QBO63grYgomFwwrAjmLI5xq+HgZVoI
5HOUCfktZbjsKgxXbWF5aS194PGNomqLVPhrWe4Vkh+d7brqYSiJTBkv4rkE9ik=
=I93R
-----END PGP SIGNATURE-----

--qoKVTFexUiwrtjk14eawORLd0TRnb4tH8--
