From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: change mapping default to documented SFM mapping - comments?
Date: Wed, 22 Apr 2015 12:35:33 +0200
Message-ID: <E1Yks0o-00Cb44-4p@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

out of the discussion from https://bugzilla.samba.org/show_bug.cgi?id=3D112=
06

we would like to know if anyone has strong arguments agains a change of the
current mapping (mapchars mount option) to the mappings that are also used =
by
OS X clients for the win32 api illegal characters, see
http://support.microsoft.com/kb/KbView/117258


The current SFU mapping was only used by default in ancient SFU versions an=
d is
not even documented any more by Microsoft. The Mappings in the cifs module =
have
also not been complete.

The only documented mappings in wide use are those described in KB 117258 as
all OS X clients use these mappings. IMHO it would be a good idea to use the
same in cifs vfs, so that cifs vfs and OS X have the same view on files by
default.

For those who alredy actively use the current mappings of cifs vfs: I'm abo=
ut
to prepare a new convmv version which will be able to map/unmap the old SFU=
 and
the SFM mappings. So a conversion will be trivial to do.

That being said, are there objections to a change of the mapping default?

Cheers
Bj=C3=B6rn
--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=C3=B6ttingen
  =E2=98=8E +49-551-370000-0, =E2=84=BB +49-551-370000-9
AG G=C3=B6ttingen, HRB 2816, GF: Dr. Johannes Loxen

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlU3eXMACgkQdoo0s+hIejmrjgCfaOfLI+0ehjAiKkHKNzQo6Hu9
GKQAoNNIjiaTZVztEl0Rp1GRtGXroZQk
=D9Wj
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
