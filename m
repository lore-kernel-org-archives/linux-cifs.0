From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3.2] cifs: ensure that uncached writes handle unmapped
 areas correctly
Date: Mon, 07 Apr 2014 20:16:24 +0100
Message-ID: <1396898184.8206.34.camel@deadeye.wl.decadent.org.uk>
References: <1396819692.13361.4.camel@deadeye.wl.decadent.org.uk>
	 <20140407140039.7e2542e9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2IEqdpjJ/4Wsi0t9PNcU"
Cc: Pavel Shilovsky <piastry@etersoft.ru>,
	Steve French <smfrench@gmail.com>,
	stable <stable@vger.kernel.org>, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140407140039.7e2542e9@tlielax.poochiereds.net>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--=-2IEqdpjJ/4Wsi0t9PNcU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-07 at 14:00 -0400, Jeff Layton wrote:
> On Sun, 06 Apr 2014 22:28:12 +0100
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > Here's the backported version I've queued up for 3.2.  It's untested;
> > please let me know if you see any problem with it.
[...]
> > +		/*
> > +		 * If we have no data to send, then that probably means that
> > +		 * the copy above failed altogether. That's most likely because
> > +		 * the address in the iovec was bogus. Set the rc to -EFAULT,
> > +		 * free anything we allocated and bail out.
> > +		 */
> > +		if (!cur_len) {
> > +			kunmap(pages[0]);
> > +			rc =3D -EFAULT;
> > +			break;
> > +		}
> > +
>=20
>=20
> I don't think this looks quite right in 3.2...
>=20
> If you hit the -EFAULT case above, then you'll break out of the big
> (outer) do...while loop. The code that handles whether to do a short
> write or an error code is in that loop, and that break will bypass it.
>=20
> If you didn't actually do any I/O at that point, then cifs_iovec_write
> is going to return 0 instead of -EFAULT. You'll probably need to
> rejigger the error handling to make that work properly.

Yes, I fixed that in v2.

> Looks like there's also an existing bug in there too if
> cifs_reopen_file fails...

Right, Raphael also noticed that and I'll post a patch for the next
update.

Ben.

> > +		/*
> > +		 * i + 1 now represents the number of pages we actually used in
> > +		 * the copy phase above.
> > +		 */
> > +		npages =3D i + 1;
> > +
> >  		do {
> >  			if (open_file->invalidHandle) {
> >  				rc =3D cifs_reopen_file(open_file, false);
> >=20
> >=20

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-2IEqdpjJ/4Wsi0t9PNcU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUAU0L5iOe/yOyVhhEJAQqnfQ/4un/pbbvdbAabnKlE77kmqxYYtDWKGrKx
90DHZq3XW9vc4W1PUj7umCUIAXHHB4aurIGd5NFXGsZJF1EO/kaqehrc5azeMMOk
JI6mQUyWrexfx/Olaj4qPOiI0ZylcVU7OBaOq77PFs5y+xIT0T3ai3ONVfMNgfRF
pGrIG15j1NdMebFpN9T9MMTNqc56tKsTQja4Tkledlk0nUpbbwOFr1Fvz2GxDU//
3hTEb5j/04R1OABYCDPPNHB27RV4goVhBLYVW7mJ9BJ6URslk3X46/mN4ZPOjV9o
Nnhlc3lEdgu0AAQ6tJgFWTAqJNT4jm2Tx32nVtTxWI+BNcfccO0dczy/H/gBaIsB
smA2yjyfHQZlmufOnkEFEorkX1awz/98K0nXMWIcVSe5wjmaTX7hdQt2emFLzhwZ
JE9DF6+0f1kT9pMCKXDtpalvujyYlvjv0ZelD62s2e/5g0xAlmBdkCIh2kL3XQXg
AxonqTzIgvO/WlRL9fWGaDjrZBfDuRvQQvLbAu4F3zO+xG5axcDnrcZdj35rWRIt
YjXfG2pIlRmE2/nSRtoQ6zEMT64br9CXFBAbe2/ZVO6K1yr0JzJwt5nGnl/KCWQM
M4pEcJcSiS47CtB6YTwdsknwb/Hk9VluiV8CkSMKO5bdp2U8aff8ziD9mULNiZKm
uYDSWUgxBg==
=RHja
-----END PGP SIGNATURE-----

--=-2IEqdpjJ/4Wsi0t9PNcU--
