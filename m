From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: Credits for session setup
Date: Thu, 04 Oct 2012 23:24:24 +0200
Message-ID: <506DFE88.9030705@samba.org>
References: <CAH2r5mu0jFiXwvVZidJ_XTyXK=AvNVKZEby=pjmipi86VJndvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig789AF61268485879E2FC2AAC"
Cc: linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5mu0jFiXwvVZidJ_XTyXK=AvNVKZEby=pjmipi86VJndvw@mail.gmail.com>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig789AF61268485879E2FC2AAC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

> Samba server only grants one credit on SMB2 session setup (ntlmssp
> phase one) - we need to change linux cifs client's "change conf"
> routine to not disable oplocks and echo requests (we only exempt
> negotiate protocol response returning one credit).

How much credits are you requesting?

Please provide captures...

metze


--------------enig789AF61268485879E2FC2AAC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBt/owACgkQm70gjA5TCD+aCQCgl4tliaGLUVyGBY5VEEZpdaR3
5G0An33oq7WGNg+BNCH/lkQWS/ZLRScE
=NycF
-----END PGP SIGNATURE-----

--------------enig789AF61268485879E2FC2AAC--
