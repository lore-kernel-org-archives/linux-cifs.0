From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/3] bug fixes and code cleanups for inaccessible root
 patch
Date: Mon, 1 Aug 2016 09:56:59 +0200
Message-ID: <20160801095659.07cf4e48@aaptelpc>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cSEYp_2BQ65.bTqUQALq8+v"; protocol="application/pgp-signature"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469828301-9937-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/cSEYp_2BQ65.bTqUQALq8+v
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jul 2016 22:38:18 +0100 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
wrote:
> The fix for unaccessible root with summary
> "fs/cifs: make share unaccessible at root level mountable"
> introduces a few bugs. This series of patches cleans up some parts of
> the code and also fixes a couple of bugs seen in the patch.

Good catch. Thanks for the cleanup!

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/cSEYp_2BQ65.bTqUQALq8+v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXnwDNAAoJEDIGO5Hchq/8XcEQAI5ZHvL5c/sTHMx87ajaMTMR
MWLUy+X9TBULHS8J2xDIWK0s2FQoK0lPb2AJDL+7nVLORFRhSQCe2yglTrU6RZ/J
yTLuoakUinlkNMV6SISB3QQg4y3vsn7+zm6vLxJmr0y6+kgS3Do1BrtJEXb3ekqh
46HArO4wOYQb8TRaSgsXMZ+oAUelW+SWiEUvH9gYE037RoOPvymGor2tIeP4yOJP
0Ia8LOxJR2RnNiERT+MoS1U+aUOdCtiwrP48VGtbyOfHpzyOz0pUoUaTYf9k7F1N
cpj0BXikW18/bJolevvUd9zeTfP8/0bIKERUUWC25A/JDUZWCD5gv7HjHxDJzHiG
+4O/aNntCKLnr9xTRIaVVak0WJIIZ8u53kNOL/kLz5Kw2ADUP81Lu5TnwO4m+cZU
FJakr1FBBOPBadc1vO8d4T7Lhex7mHi0PPSn4m4t0fH2/DicfR/a7Em8pr4zInrC
CiUGCkqkPovt4RWDNHxSu5AO3CoRGzGbid9ar9+R50zp4+7UWd+sj9HzKm4XASyO
4PKJAMUB4dAw6i/VDhJRehmVGgXT3RnTKkoLwpaEx42z3LEtHEXGqWKqWdL31eSE
tobqdjsNoeY8FOJhELSxvMQtEwcmAz0ZHYg6q4X2OGRKvjvYtaQWKhYJzcQ25kDj
D8IgMRy6xr7iUH6Ph9zV
=IeaT
-----END PGP SIGNATURE-----

--Sig_/cSEYp_2BQ65.bTqUQALq8+v--
