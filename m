From: Stefan Metzmacher <metze@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Sun, 23 Sep 2018 23:24:27 +0200
Message-ID: <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
 <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="c5GHWwVHnxwpR9NKglrCRGV5nEI92Gmrw"
To: Tom Talpey <tom@talpey.com>,
        Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c5GHWwVHnxwpR9NKglrCRGV5nEI92Gmrw
Content-Type: multipart/mixed; boundary="B64A0tmpOHUCJVaPx9ryigimzaEGy1bjp";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Tom Talpey <tom@talpey.com>, Long Li <longli@exchange.microsoft.com>,
 Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Tom Talpey <ttalpey@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>,
 Stephen Hemminger <sthemmin@microsoft.com>
Message-ID: <f9c791af-28d0-5107-e41a-31eee03cbda0@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
 <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
 <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>
In-Reply-To: <699de6ba-201a-fd4f-bcac-234e13f33afc@talpey.com>

--B64A0tmpOHUCJVaPx9ryigimzaEGy1bjp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Tom,

>> I just tested that setting:
>>
>> mr->iova &=3D (PAGE_SIZE - 1);
>> mr->iova |=3D 0xFFFFFFFF00000000;
>>
>> after the ib_map_mr_sg() and before doing the IB_WR_REG_MR, seems to
>> work.
>=20
> Good! As you know, we were concerned about it after seeing that
> the ib_dma_map_sg() code was unconditionally setting it to the
> dma_mapped address. By salting those FFFF's with varying data,
> this should give your FRWR regions stronger integrity in addition
> to not leaking kernel "addresses" to the wire.

Just wondering... Isn't the thing we use called FRMR?

metze


--B64A0tmpOHUCJVaPx9ryigimzaEGy1bjp--

--c5GHWwVHnxwpR9NKglrCRGV5nEI92Gmrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAluoBI8ACgkQDbX1YShp
vVaXdg//ZEmZRIkzmO40yTTKvzu9rkTAhOYXM2ifY0CFIEj1KdjTwYVaktGYrYMs
UYsLQgMvsFAz1DUJx/VkwNlpPsKq5zJyeSDKojAwTw/keVZ8/VgOXM4bytUrgFU8
gsaiXyreXhGpdqVzIvECFAeOD0TRnD0COM2FfBWF9YxnuHH9iH4+7TfSBVSjImAV
0dUWTGn81v117FzTCC6lMXJuySrV4X4cHdfK00FVxgMO8BNuA6Z61GA26foUrWRL
gwdYfHYRoMbD0F4qNw2+ggXifEwmhicUnLIGlXo0mnC7ercNFnBwG+sQLpaCdfJH
ti2YYM5NEHQm8dwufM/nD+Ogabs/Y48YMor/6Dp9S+JaVxXiAy5gJgQALhyAVRQj
kC8zn3hKvNSHG/h2LSzEdBtFbPouiSkh0j2OgmaN6bTJ1bnQKR3IUsApTDWdNCgf
W3Az98N3NgDPFe4zLW/poLX3p8fapHrQa1pB3z6Txtlk9N/B3Dtuk6govGmCEvcI
xSQCri0o12NNKKsGm3M86XK6iiQlMGGLE/h/4z+3CTytlPfhm0KI7gKETKuQg6xU
2RD9dl/Iv0luuhejxKjjcytf8dYw/dEbtV3vxOTiZ2bsAbZUzE2osBm9sThhau7r
CdSTialSHXOA1xVtIaO68rgqdwMhODYUMOVbjGgh9ahkTqJWUN0=
=lpBp
-----END PGP SIGNATURE-----

--c5GHWwVHnxwpR9NKglrCRGV5nEI92Gmrw--
