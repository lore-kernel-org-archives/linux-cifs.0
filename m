From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Wed, 20 Jul 2016 14:16:13 +0200
Message-ID: <20160720141613.6a91e293@aaptelpc>
References: <20160527194346.08416d79@aaptelpc>
	<20160609185027.7349f260@aaptelpc>
	<5759C326.5040508@fu-berlin.de>
	<20160610171649.3e12b95c@aaptelpc>
	<CAKywueRMvJ4B6ojqA1TduS4nGFTr5m4wLO2=0M_EVv=vw2T1pw@mail.gmail.com>
	<20160718163847.68ea0d86@aaptelpc>
	<CAKywueRFMu9nvwi_01Yz0HpOqhrK2yZVaLT2JMqw4622irQzNw@mail.gmail.com>
	<20160720125702.43df577e@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ugyjAv0+jAQI=0FqH/5XjGU"; protocol="application/pgp-signature"
Cc: Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720125702.43df577e@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/ugyjAv0+jAQI=0FqH/5XjGU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jul 2016 12:57:02 +0200 Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
wrote:
> Oops. Okay this time checkpatch.pl only complains about a quoted
> string split across lines wich I'm not really sure how to fix so I'm
> leaving that as is.

...because not splitting it would make the line >80 chars. The whole
point of doing this is AFAIU to be able to grep the message so using "\"
wouldn't fix it really.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--Sig_/ugyjAv0+jAQI=0FqH/5XjGU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXj2uPAAoJEDIGO5Hchq/8JqwP/2boNSd/gSWQw3ppBfJrMpkF
ez3p0dvbKASWDt9HhPzd2Bj5PAxPT9UwIq7C6EIxt02tu3x+4OjeK0Urfu5pkzdT
pgDi5pFlM1juebbvwKLUihfHMpXsg1h8N2a7j4o4UXWeK9yx7UV+4SPeTQYqtNh5
2FQ6cDaaXmPDKdk5ZEkp8IK8IfOHgJZVJ0KvDvGjmazm2zqn1j1+XegZAj8SYZza
edEG+bQhdjqgUBvG7Y28o0JRuUlhjKjpa60yoTMElzYnlNQJ0VykEIiUUXUkyD+Y
Rtym1MYOWHruaPsyy7NBg7T27PX5e14Gr880B2YU03MFy5BIu1zjZvWShGtvnoln
Clc1LKHwLPA4HemV0/MW9lIScHcrNKm3vkK7yIKTYcRb+qC14uKtXgjpWPvYTzXg
PkIh7LKwx8Fg9DI+iP6IaTNhbax8WLCJRCM+vDqPHk1BzVXyGwXN1wAjaIg1dArh
wQLinlmjlsk/8fFjMeabu+7nM6NaJnJcl/iUw2mDEdrbanB6EaADcDMwd27u2Hf0
cS8oQi80dpTfkV6Sc+yToNDIahAS8l3hto45wr54JAtWGSxUK7mlLvDW3Nt7e9Ky
ngtuFLRsCkkeo4Z/tA7ti3OeFD8b/n7PKbBFd3u03fPhZUJWdYoIcbKlK/56V7h4
YSJeqoU0V1NmehHmv0w7
=KfWg
-----END PGP SIGNATURE-----

--Sig_/ugyjAv0+jAQI=0FqH/5XjGU--
