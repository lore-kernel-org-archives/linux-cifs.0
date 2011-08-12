From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
Date: Fri, 12 Aug 2011 11:49:19 +1000
Message-ID: <20110812114919.2797815cf41cd69048e1d3cf@canb.auug.org.au>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
	<CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com>
	<1313092847.3122.13.camel@localhost.localdomain>
	<CAH2r5muSOM=haAXHg+ys05vgJ30m94g_NQz-Y2AgMDkmV1dbiw@mail.gmail.com>
	<alpine.LRH.2.00.1108121047540.14215@tundra.namei.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_11_49_19_+1000_STIf+hZlW/Zq7re_"
Cc: Steve French <smfrench@gmail.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Eric Paris <eparis@parisplace.org>,
	linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
	David Safford <safford@watson.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: James Morris <jmorris@namei.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1108121047540.14215@tundra.namei.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Fri__12_Aug_2011_11_49_19_+1000_STIf+hZlW/Zq7re_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 12 Aug 2011 10:48:27 +1000 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> On Thu, 11 Aug 2011, Steve French wrote:
>=20
> > makes sense - do we want this going through the cifs tree or as part
> > of the xattr change mentioned below.
>=20
> Should be fine to go into the CIFS tree, as long as that is in -next.

Except then that could leave Linus' tree broken during the next merge
window depending on the order he merges the cifs and security-testing
trees.  Unless that patch is sent to Linus as a fix patch before the next
merge window, of course.

I will add this patch as a merge fixup to the merge of the
security-testing tree for today.  And will remove my copy when one of the
trees gets fixed.

James: maybe I should change the name of your tree in -next to just
"security"?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_11_49_19_+1000_STIf+hZlW/Zq7re_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORIafAAoJEDMEi1NhKgbsh3wH/j/+XoXMZuG+E9hS+wd6J8RC
lI7Vtths2igscR7PMKcn5kesRFE2dBRXXVWQtuS97fn2oUriFxXuFuzzRh8YZn29
7fMeIotRKebwmTdHY324gDUMbSdnpEkgyHxyKGwh43M+h7X8OkXyNr2ZUDlawg8Q
aJlYhBN7iQk3r5yyKnCtT+9/lgRAg90CD7wTmpgA7/W1EYdXmony2Y1LJ8ddLCC/
21lJ25jACap7rCMA4UZppCq6K0mcjvzlds/yPhx1RKJMr2n7KfkPK/FO8ofgZOx0
5Z8tmOHiH9OB1Wld8g578H2rxn0hsH941x7XmE2ZwdIdTBOsQDYJpYqf/Zn2FIY=
=dCXG
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_11_49_19_+1000_STIf+hZlW/Zq7re_--
