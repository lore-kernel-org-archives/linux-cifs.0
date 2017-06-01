From: =?UTF-8?Q?Bj=c3=b6rn_Jacke?= <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: add SFM mapping for 0x01-0x1F
Date: Thu, 1 Jun 2017 12:04:28 +0200
Message-ID: <9c69c458-07a8-cd52-df30-72eb28fde38a@samba.org>
References: <20170601090006.GA21508@SerNet.DE>
 <mps4lw0t5o8.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LTmk2KcS76Ut3ce1NTNlhAiFclFreO5Eb"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mps4lw0t5o8.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LTmk2KcS76Ut3ce1NTNlhAiFclFreO5Eb
Content-Type: multipart/mixed; boundary="neRDVL0UlHprhSCqfggEIEWEtXQx9oAmk";
 protected-headers="v1"
From: =?UTF-8?Q?Bj=c3=b6rn_Jacke?= <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <9c69c458-07a8-cd52-df30-72eb28fde38a-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: add SFM mapping for 0x01-0x1F
References: <20170601090006.GA21508-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
 <mps4lw0t5o8.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
In-Reply-To: <mps4lw0t5o8.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>

--neRDVL0UlHprhSCqfggEIEWEtXQx9oAmk
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hi Aur=C3=A9lien,
On 01.06.2017 11:31, Aur=C3=A9lien Aptel wrote:
> Are these mappings documented somewhere? Now that Windows has a new
> Linux subsystem I wonder if any of these SFM/SFU mappings have changed.=

>=20
> Cheers,
>=20

it once was documentd in MS KB117258 ... which disappeared
unfortunately, wayback machine still has is though:

https://web-beta.archive.org/web/20150315001238/http://support.microsoft.=
com:80/en-us/kb/117258

I also verified that current OS X clients use these mappings for SMB.

The only remaining mapping which needs fixing in the cifs module is the
backslash now.

Bj=C3=B6rn



--neRDVL0UlHprhSCqfggEIEWEtXQx9oAmk--

--LTmk2KcS76Ut3ce1NTNlhAiFclFreO5Eb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEAREIAAYFAlkv5q0ACgkQdoo0s+hIejlbfACg9aJ69Y6Hh2BvetNdO4oadmwD
6eMAnRK5H7tdSYR2kJfzNaLdi5LuB7YS
=ourF
-----END PGP SIGNATURE-----

--LTmk2KcS76Ut3ce1NTNlhAiFclFreO5Eb--
