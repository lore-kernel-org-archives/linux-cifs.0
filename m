From: Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: Strange O_DIRECT behaviour on non-directio mounts
Date: Wed, 16 Jul 2014 12:02:05 +0200
Message-ID: <20140716100205.GD5471@noname.redhat.com>
References: <20140627111412.GC5223@noname.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140627111412.GC5223-LVckRYR5CXkXGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Am 27.06.2014 um 13:14 hat Kevin Wolf geschrieben:
> Hi Steve,
>=20
> I just discussed a problem with a qemu user on IRC, which boiled down to
> him trying to open an image file on cifs with O_DIRECT, but not using a
> directio mount. I understand that this probably isn't going to work
> anytime soon (if at all), but it resulted in a rather unhelpful failure
> mode.
>=20
> What happens is that cifs lets the open() call succeed even with the
> unsupported O_DIRECT on that mount, but then fails any I/O on the file
> descriptor. I believe this was introduced in commit dca69288 (which I
> think is otherwise pretty useful).
>=20
> With the old behaviour, qemu detected what's going on and suggested to
> use a non-O_DIRECT mode to the user, but with the new one, it got rather
> unhappy after failing to find a working O_DIRECT alignment and ran into
> an assertion failure...
>=20
> Now I'll certainly fix the latter in qemu, but I also think that the
> behaviour of cifs is rather surprising. Any chance that you can make
> open() with O_DIRECT fail again on non-directio mounts?
>=20
> Thanks,
> Kevin

No interest at all, not even to tell me that I'm completely wrong? :-/

Kevin

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTxk2dAAoJEH8JsnLIjy/WtpcP/3Dl/SlYJrl9jqrOq9Uhgm9j
UfeLY9WZjxHy4fZoEqW/cTwRt3GanNTz6cjT4ELI0qn1cCXDWYjR4B3wPlmf4/SO
LXlLYR9TiNqSK2XLlCCOlJUF/XOfRgMcrOgqzw8z1UczVru6CDrFn+588AdqeKlt
JFihLYF7Efl+ueOXKiSOqe5l5W40uPPfN3MUGr5dx5trIQVz7ewhTIHNgUoR8l7B
ZW4wBCIMoI6H2kXExqqKwvcW6YM1R3UQ68uS0b7Bb/w2ogHB6MHhGD/QfSabo6Y8
r84EWsZ2jG/Okbhf1FS9p1kzWbOpjASERsS21DKzKnx9CoXNZjlfkradj/8nMzDQ
yo13VzXXFTYX+5zhPWR+59FQ3QuEVTAGwh6th+Em7bFeDX+i2TrwuQLsmluVS8Vy
ShsONeoXOAh65f5dw/22lGA+sMv1RetTX3Wy2QHDkNW72TLV+f+33jfYGDhLQ+Nh
2Oe52gBrqNdCBqgdzqDLe4HmkiC/Rlziq1+FTQJixufVX48OC55r8Nev13N4KMgf
Swya8l6NxQ+ob6JZ64jYJvcVCd5j9ngZFBZQHxXUOou7EQhrxzs5WU9HKrZytmtV
VzaRVaYBWFUtTz1XW9GJYr0763mWJtvMfNRMaHD7pPpUTkmQ/7uffWI/2XgEBQhO
tV+DoG+6HXUHL2MDTdQ5
=TBuh
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
