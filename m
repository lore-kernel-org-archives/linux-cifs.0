From: Stefan Metzmacher <metze@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Mon, 24 Sep 2018 06:07:25 +0200
Message-ID: <c418b22a-7248-4c00-7879-8b3313e12515@samba.org>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
 <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
 <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
 <de042465-e9b9-3782-00ce-38943053c7b6@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="hbGauCvnbeqQ9Rlnq9Q6TVYvuOdzSpiDr"
To: Tom Talpey <tom@talpey.com>,
        Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de042465-e9b9-3782-00ce-38943053c7b6@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hbGauCvnbeqQ9Rlnq9Q6TVYvuOdzSpiDr
Content-Type: multipart/mixed; boundary="VlgwhgtDBOfVYKcLNmV0qIkLThSRoyKiF";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Tom Talpey <tom@talpey.com>, Long Li <longli@exchange.microsoft.com>,
 Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Tom Talpey <ttalpey@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>,
 Stephen Hemminger <sthemmin@microsoft.com>
Message-ID: <c418b22a-7248-4c00-7879-8b3313e12515@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
 <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
 <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
 <de042465-e9b9-3782-00ce-38943053c7b6@talpey.com>
In-Reply-To: <de042465-e9b9-3782-00ce-38943053c7b6@talpey.com>

--VlgwhgtDBOfVYKcLNmV0qIkLThSRoyKiF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

> They're basically the same concept, it's a subtle difference.
>=20
> FRMR =3D Fast Register Memory Region
> FRWR =3D Fast Register Work Request
>=20
> The memory region is the mr itself, this is created early on.
>=20
> The work request is built when actually binding the physical
> pages to the region, and setting the offset, length, etc, which
> is what's happening in the routine that I made the comment on.
>=20
> So, for this discussion I chose to say FRWR. Sorry for any
> confusion!

Ah, thanks! Confusion resolved:-)

metze



--VlgwhgtDBOfVYKcLNmV0qIkLThSRoyKiF--

--hbGauCvnbeqQ9Rlnq9Q6TVYvuOdzSpiDr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAluoYv0ACgkQDbX1YShp
vVaIWRAAutNfRgEZZpiedTIEmKyYRrGg7snhkmpzG0n/9lbkW+DtyvT7J+5Cx2rh
HsflIB3iGXcdnAKGX3k+VApiEvrB+2ZrH5sIEDQbpmabATbKfW+PEJyO5o27XffA
bajAScF2ctMhDfwGKi6PyATi/toDkHCtz8AGqSuxyvNOQ+Ck6lC/6antiHIzxwEa
iJBQaaYb5XFJlSvG83wpl65l095gYYkPy26HrXO8RqPBSf+AkglQxamMTZWTUd62
oDtSIspBpRbtRznqMq6VFPmUwnOlxu6YrLKLqUQixICIgbAkwxTs8OZz65ilQBrb
z89YP/t8kJzA0uK4IJ+FW4bjiHBnOuKxgAtr9P2qs1/So31pndQy4IRraD3Xbv7J
+vZCudzuOMEw2fwiJZ7C7ZbsbjEr9WagaInY36QX5/khvfvDhGEQYelrITCytzEX
Fcnny+51g32vbcaea5YcOQ1yLGJ6Dq1Z7z5MDvOAhrR4qXf/g0yV1GceYv3G5dTV
XImKO8OJpBsiwCy361OnYzFsspB+GWmMMgh77X3Sl3eibe92lMv6WoN/lvTnqE36
9d7qqRwZYs0Fx7XM/kV+hveHpvTKQIsl2J5SEKHqgHetSbhvyFfFTRuc3JPuROJj
iV1Gx48j+4JUhXgsvetHEuv+MjAFueoB612X0USqvctJvB897mo=
=m9fC
-----END PGP SIGNATURE-----

--hbGauCvnbeqQ9Rlnq9Q6TVYvuOdzSpiDr--
