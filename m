From: Stefan Metzmacher <metze@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
Date: Sat, 22 Sep 2018 05:56:26 +0200
Message-ID: <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="WXjiMPtVHnKmtcwzasYbKH8rMfBvFkChY"
To: Tom Talpey <tom@talpey.com>,
        Long Li <longli@exchange.microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXjiMPtVHnKmtcwzasYbKH8rMfBvFkChY
Content-Type: multipart/mixed; boundary="f0yBHCqlzomqLL96mnR7F6gKrVemvi8CB";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Tom Talpey <tom@talpey.com>, Long Li <longli@exchange.microsoft.com>,
 Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Tom Talpey <ttalpey@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>,
 Stephen Hemminger <sthemmin@microsoft.com>
Message-ID: <a7680efb-6ecf-0f70-2fde-55c2b69b534b@samba.org>
Subject: Re: [Patch v7 21/22] CIFS: SMBD: Upper layer performs SMB read via
 RDMA write through memory registration
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
 <20171107085514.12693-22-longli@exchange.microsoft.com>
 <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>
In-Reply-To: <9b02dadb-d21b-7a8d-7803-910041f66047@talpey.com>

--f0yBHCqlzomqLL96mnR7F6gKrVemvi8CB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->Channel =3D SMB2_CHAN=
NEL_RDMA_V1_INVALIDATE;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (need_invalidate)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
q->Channel =3D SMB2_CHANNEL_RDMA_V1;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->ReadChannelInfoOffset=
 =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 of=
fsetof(struct smb2_read_plain_req, Buffer);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->ReadChannelInfoLength=
 =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 si=
zeof(struct smbd_buffer_descriptor_v1);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v1 =3D (struct smbd_buffer=
_descriptor_v1 *) &req->Buffer[0];
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 v1->offset =3D rdata->mr->=
mr->iova;
>=20
> It's unnecessary, and possibly leaking kernel information, to use
> the IOVA as the offset of a memory region which is registered using
> an FRWR. Because such regions are based on the exact bytes targeted
> by the memory handle, the offset can be set to any value, typically
> zero, but nearly arbitrary. As long as the (offset + length) does
> not wrap or otherwise overflow, offset can be set to anything
> convenient.
>=20
> Since SMB reads and writes range up to 8MB, I'd suggest zeroing the
> least significant 23 bits, which should guarantee it. The other 41
> bits, party on. You could randomize them, pass some clever identifier
> such as MID sequence, whatever.

I just tested that setting:

mr->iova &=3D (PAGE_SIZE - 1);
mr->iova |=3D 0xFFFFFFFF00000000;

after the ib_map_mr_sg() and before doing the IB_WR_REG_MR, seems to work=
=2E

metze


--f0yBHCqlzomqLL96mnR7F6gKrVemvi8CB--

--WXjiMPtVHnKmtcwzasYbKH8rMfBvFkChY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAlulvWoACgkQDbX1YShp
vVb+3Q/9FQKMxdB61HpBQAO2lostxIlm4vcgPBlO5HxN1UlrqQLUdnaKUhtGUFz7
0LzuQXSUMS3woN3HvLhhqIMk3Tt9JmTV97AydPGWfV2w7bwhsQXt7m0gMYTIllbo
mj0/vjYW474sTCBPBdYZLUd7DAX7IBdWpy7p+TIH2r/ZgKcGt2q6pzUQ5FnrybJz
gL4UNONLdtQtlZiN/QW+oFsEBsQBQNo8ey6ZHZ2ZPLTngElrbCZ5LQoQOaSAUuBT
WQUGe/v47vKDN250a+mEhMdlkfk1PLhbNPAwcqxgLo3nJdY8GjeP3WRjoSw65eCs
aqJpbArCb+CLcJUCnlBuJGQvpKFmGd2t0JN/Jk/JC9AWBVNVC7P+0r6b0tiZFpBD
pLtQiaVNwuv7M7V0U5Ni65yE+AfdollEMoWSluTejU4cH64qa9C6aYEarfdmmo2l
BTZjnw+QRQSrfJLUjXfU1cpoI4ATEmsIDaNLqS6kzBd0xyI5xcPUX/e3QxvjVX5b
J9yBt/mDbFnuacSzTANbSr1ZwZV5wYQWZQQgcdBZd+k8s//uiJCJAW1WPqC1v2wk
S9D+wH+qiStJ45I52PHftT1hWHZfILMkf/4xHY1WTGSnym655jNA6gvPdUJRV+w0
UsWnvgrUzBxIIUM5wLN/QcTiDtWZ+9/LJg/9JgOdE91bdooymKg=
=e7Ot
-----END PGP SIGNATURE-----

--WXjiMPtVHnKmtcwzasYbKH8rMfBvFkChY--
