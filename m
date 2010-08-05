From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Date: Thu, 5 Aug 2010 13:45:45 +1000
Message-ID: <20100805134545.93ccb1b4.sfr@canb.auug.org.au>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
	<4C497CD5.5010908@kernel.org>
	<20100723213148.3d2193a3.sfr@canb.auug.org.au>
	<4C497E5F.80301@kernel.org>
	<20100723214233.7cb7de8d.sfr@canb.auug.org.au>
	<20100805130459.f62468cd.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_13_45_45_+1000_u819=hHGuf89bSBC"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100805130459.f62468cd.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Thu__5_Aug_2010_13_45_45_+1000_u819=hHGuf89bSBC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Thu, 5 Aug 2010 13:04:59 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Fri, 23 Jul 2010 21:42:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > On Fri, 23 Jul 2010 13:34:55 +0200 Tejun Heo <tj@kernel.org> wrote:
> > >
> > > I was thinking about sending pull request w/ a note describing how to
> > > resolve the conflict.  Would pulling in master before requesting pull
> > > be better?
> >=20
> > Either would work.  Linus is fine with doing merge fixups and, after al=
l,
> > I figured it out. :-)
> >=20
> > A description always helps, of course.
>=20
> Linus has merged the cifs tree, so you could fix these conflicts in your
> tree by merging the cifs tree that Linus' merged (rather than merging
> against all of Linus' tree).   That would be commit
> cb76d5e25008b76fb8e348c861d32659430ac3fa ("cifs: fsc should not default
> to "on"") in Linus' tree.
>=20
> Or you could leave it all to Linus if you want to.

Actually there is some more stuff in the cifs tree that has not gone to
Linus, yet.  Sorry about that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Aug_2010_13_45_45_+1000_u819=hHGuf89bSBC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWjPpAAoJEDMEi1NhKgbsG3QH/3JSjfxsFgHtA9V85DxJ078c
VLQFoIdzdvyNgm+MraWk+bfzU4rqBwwDLOCr0O5EsUpVs6xd1BN9Cc5j3oO3rNIb
daOkYH0Q+OGyHoZuXdFQi2nxqQtYlucNxDfrbKtbehBGmkDLY3QDriPCXlxT5Whv
70n0Kqi34XP+43urXCKwgGuXP6cwtBBDSPriu/IYXSa9p4l+PfZ0ymqhA9T7oaW9
JlyiTwiktnuQcxKfbV34BM0zEhPy6z3Oo1Rb0XHR5G3Rb0CLBSHYivxxImfEx4RC
D0FTA5jvUe3H6SVeXE6quqAvYWs2qCqXhNuQPV07Ub44PwzD2vHZV4Klo8NuZ54=
=J3gW
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_13_45_45_+1000_u819=hHGuf89bSBC--
