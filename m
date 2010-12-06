From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 13:46:31 +1100
Message-ID: <1291603591.22122.3.camel@ruth>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1";
	protocol="application/pgp-signature";
	boundary="=-qG+zvvAeew8gPTQXLpV/"
Cc: linux-cifs@vger.kernel.org, cifs-protocol@samba.org,
	samba-technical@lists.samba.org
To: Volker.Lendecke@SerNet.DE
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <E1POnFL-00BKfp-6h@intern.SerNet.DE>
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


--=-qG+zvvAeew8gPTQXLpV/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-12-04 at 09:12 +0100, Volker Lendecke wrote:
> On Fri, Dec 03, 2010 at 09:28:11PM -0500, Jeff Layton wrote:
> > So, what does this mean for CIFS clients? I believe that the best
> > behavior for the client is to *never* time out an individual request,
> > aside from SMB echoes.
>=20
> I like this concept.

+1

If the server is up and running enough to respond with smb echo replies,
then it seems reasonable to assume it is still dealing with the other
requests, or if it wishes to abandon a pending request, it will respond
to it (eventually) with an error. =20

Volker,

Is it correct to say that this is how Samba3 deals with slow calls and
Windows clients, using the echo handling child?

Andrew Bartlett

--=20
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
Samba Developer, Cisco Inc.

--=-qG+zvvAeew8gPTQXLpV/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBM/E53z4A8Wyi0NrsRAodAAJ90Q7YDdhE5wEy/bfcIcTPG6ouv9gCeMO3n
dBJADb6zcDQg7sn++f5GZ/o=
=HY0v
-----END PGP SIGNATURE-----

--=-qG+zvvAeew8gPTQXLpV/--
