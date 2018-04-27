From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/6] IB: make INFINIBAND_ADDR_TRANS configurable
Date: Fri, 27 Apr 2018 12:07:52 -0400
Message-ID: <1524845272.11756.51.camel@redhat.com>
References: <20180426181935.32977-1-gthelen@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ArJuE/oCyHuv67w/co53"
To: Greg Thelen <gthelen@google.com>, Bart.VanAssche@wdc.com,
        hch@lst.de, jgg@ziepe.ca, axboe@fb.com, keith.busch@intel.com,
        sagi@grimberg.me, sfrench@samba.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426181935.32977-1-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--=-ArJuE/oCyHuv67w/co53
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-04-26 at 11:19 -0700, Greg Thelen wrote:
> This series allows for CONFIG_INFINIBAND without
> CONFIG_INFINIBAND_ADDR_TRANS (aka RDMA communication manager).
> Fuzzing has been finding fair number of CM bugs.
> So provide an option to disable it in systems which don't need it.
>=20
> Changes since last posting (https://lkml.org/lkml/2018/4/25/1266):
> - added ("ib_srp: depend on INFINIBAND_ADDR_TRANS") patch

[ snip explanation of series ]

Thanks for taking the time to research this out.  Series applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ArJuE/oCyHuv67w/co53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjStgACgkQuCajMw5X
L90xJg//a3hFT2eczO/FPDKXHnrDksGkdNTHpQkUoL9zQOhTbWVG8CwPYtVB7Ozg
DXDn2k0PgA0YHt40EX6t2WTwwKUcmcebCfVH9erg4AOW6FYfNZShCOQz/W3bvzgl
19UUE7/7zGFELRmNPu/ZAy6FgZACrKpOP+DS/HkIaLQrJ8MvM9YSyoIhGlvrP8QX
Qn2eGEKIP7qNYNTVPex51Y45SDqjP9CZFzYOvaUk26E6AHv4iJ2SFfKcin/qBWNG
Rj2abtevDOsmrNXvskAF92yIIXGTZFX83dDrAS+B2vSJkFeVUfylIyVU4CylXT2a
BwAj/Xwb2fYKzSy8AVclUy8I83gqKt+6IvqsxVdh0HmqKYvYDPLNgdnRe6PNb0uz
xTmJHQRyF5rGSYVavqhIHP+5c2DkGZioOSlnpqD08PEqHaNnqLvWghInpKSl9qB8
cMp2o2oVmMAEgs3RfCuGTAtiYW9uRAIHaaaoGUJEXXqNpGVXJbXmw21rUhVzxPQg
s15x7dQfsfQKHrrhtr390WN8GJJZw/c26KxieJF8O3NNIlgXWmxDGoFeAvgFusQ/
OBB2F0pfrE1faoXJ56ntqzSnnc+KFXfNluNrxYrFcd4rZqYCVyrvr9WgquvPb/EK
whQoEIINKvsq+btKVZIJgj2eeak4Kau9k7+XdWURYZFQu8Uavwk=
=MJmw
-----END PGP SIGNATURE-----

--=-ArJuE/oCyHuv67w/co53--
