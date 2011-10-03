From: Lars =?iso-8859-1?Q?M=FCller?= <lmuelle-l3A5Bk7waGM@public.gmane.org>
Subject: Re: CIFS kernel module bug
Date: Mon, 3 Oct 2011 18:56:29 +0200
Message-ID: <20111003165629.GM5170@giles.fritz.box>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
 <20110930140409.51c1a94c@tlielax.poochiereds.net>
 <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
 <20110930234711.GD14147@samba2>
 <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
 <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
 <20111001150730.GJ5170@giles.fritz.box>
 <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk>
 <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
 <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SgT04PEqo/+yUDw3"
Cc: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65C75335-2A74-4B00-989A-212BAC06A646-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--SgT04PEqo/+yUDw3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 02, 2011 at 09:16:33PM +0100, Anton Altaparmakov wrote:
>=20
> On 1 Oct 2011, at 21:22, Jim McDonough wrote:
[ 8< ]
> > I believe both are available on OES, samba and the CIFS server that
> > has its origins in Netware.
>=20
> That is correct but apparently Salford Software (who handle our Netware &=
 OES site license here in the UK including providing support) have told the=
 guys running the file server that the samba server on OES is not scalable,=
 has loads of bugs, and they must stay away from it at all costs and that t=
hey would not provide any support if our filestore runs that instead of the=
 Novell CIFSd.
>=20
> You can understand why the filestore is thus running the Novell CIFSd rat=
her than Samba=E2=80=A6

This OES is very likely SUSE Linux Enterprise (SLE) 10 based.  This code
base initially included Samba 3.0.

There is an additional, optional software repository available online
for SUSE Linux Enterprise customers - named SLES10-GPLv3-Extras - which
provides Samba 3.4.3[0] - same version and including the same fixes as
the version used with SLE 11 SP 1.

Ok, that's the good news.  Now to the potential bad part.

The bad part only applies if you make use of Domain Services for Windows
(DSfW) formerly known as xad.

Some of the required modifications had not been ported to Samba post-3.0
and therefore running any post-3.0 Samba code will cause trouble aka
will not work.  We're working on this with the OES colleagues.

Lars

[0]
http://www.novell.com/support/viewContent.do?externalId=3D7007836&sliceId=
=3D1
--=20
Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
Samba Team
SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--SgT04PEqo/+yUDw3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFOiek94NBiK0FKV8MRAg6tAJ9qTVnd3by9FSkAhDMeAJHmEDY9RACgkZ9j
SF8c91ugwSuzE5SczY355KU=
=OB0j
-----END PGP SIGNATURE-----

--SgT04PEqo/+yUDw3--
