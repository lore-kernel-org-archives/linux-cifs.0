From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a
 gid
Date: Mon, 13 Dec 2010 06:16:22 -0500
Message-ID: <20101213061622.7e78e475@tlielax.poochiereds.net>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101211111716.1e21be41@corrin.poochiereds.net>
	<AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	<20101211193003.4a11fc7f@corrin.poochiereds.net>
	<AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
	<20101211221159.36e6c814@corrin.poochiereds.net>
	<1292125684.7313.4.camel@ruth>
	<20101212063929.77a619e4@tlielax.poochiereds.net>
	<1292210529.15637.10.camel@obed>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1=fElPgJr/uR2gp1GOj7aJM"; protocol="application/pgp-signature"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292210529.15637.10.camel@obed>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/1=fElPgJr/uR2gp1GOj7aJM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Dec 2010 14:22:09 +1100
Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Sun, 2010-12-12 at 06:39 -0500, Jeff Layton wrote:
> > On Sun, 12 Dec 2010 14:48:04 +1100
> > Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >=20
> > > On Sat, 2010-12-11 at 22:11 -0500, Jeff Layton wrote:
> > > > On Sat, 11 Dec 2010 19:57:11 -0500
> > > > Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > >=20
> > > > > On Sat, Dec 11, 2010 at 7:30 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
> > > > > >>
> > > > > >> Will look into this.  One thing that concerns me is if a cache=
d etnry
> > > > > >> for a SID with its name and an id (either an uid or a gid), if=
 that SID
> > > > > >> now represents a different object and has differernt name, wou=
ld
> > > > > >> not cached info be incorrect?  Not sure if this can ever happen
> > > > > >> or how would it happen and if it does, what would be a trigger
> > > > > >> for a cache revalidation and purges!
> > > > > >>
> > > > > >
> > > > > > Sure, mappings can change. But, you still have the same problem=
 with
> > > > > > what you're proposing in these patches. The userspace program i=
sn't
> > > > > > setting a timeout on the key. Once a mapping is put in the keyr=
ing,
> > > > > > it's there until it's revoked. You probably want to set a max T=
TL for
> > > > > > the entries in the cache regardless of what scheme is used.
> > > > >=20
> > > > > I was under the impression that SIDs are never reused. Perhaps I =
am mistaken.
> > > > >=20
> > > >=20
> > > > That may be, but the mapping of a SID is dependent upon settings in
> > > > config files that could change. It seems reasonable to me to only c=
ache
> > > > these mappings for a period of time in the event that they do. That
> > > > period of time could default to being rather long and be tunable.
> > >=20
> > > I think that instead some explicit signal should be made to indicate
> > > that a mapping has changed, so you don't have to worry about cache
> > > times.  It should change *very* rarely and only on specific
> > > administrator intervention.  We do a lot of things to avoid this
> > > happening in the normal course of events.=20
> > >=20
> >=20
> > What would provide this signal? winbindd? I suppose we could add a knob
> > or something under /sys that tells cifs to dump the idmap cache.
>=20
> I think a /sys knob seems appropriate, perhaps easily sent a command
> option on the same utility used for the upcall?
>=20
> > We would also have to consider however how to deal with someone running
> > an old winbindd that doesn't signal the kernel properly.
>=20
> That's a very interesting question, as after a manual reconfiguration
> perhaps even winbind might not know it changed.  It depends how deeply
> the administrator changed things (changing the idmap_rid config settings
> might matter for example).  I'll let others who deal with idmap more
> often comment.=20
>=20

The other option is just to have a manual knob that flushes the cache,
and add something like this to the cifs.upcall manpage: "If you change
your idmapping configuration, then you'll probably also want to flush
the idmap cache." Maybe it's a rare enough thing that we shouldn't
sweat trying to make it too automatic.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

--Sig_/1=fElPgJr/uR2gp1GOj7aJM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk0GAIoACgkQyP0gxQMdzIBofQCfY4T6agM2EoJ2x1Hc8m0mH8hp
UrUAnjfr35nt0WhBwcFsTm93USveBUFX
=G54i
-----END PGP SIGNATURE-----

--Sig_/1=fElPgJr/uR2gp1GOj7aJM--
