Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0213D52F
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725342793; cv=none; b=MGKM4FnZu7QOz18VwtfQ7ztZd+THSUaViuFzbDZHuu4hJ/WEjHg13GmM4PZwXgeAEAeKCePccsUfCJeJmgoKhyCLVumrW1/uULEVBDkKCW803dETHt4FMWcWjm+U+3ImFJwUMg+6ohps7o1UKgnp7FBf11C7EmsRafazPuF9lIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725342793; c=relaxed/simple;
	bh=OYNVwuPeW6SsEtfUQWnk1cblS1zd0r5KDkboboGuesk=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=W/rsDSsjFVg5CKIFVuA0hwkVHrZJ/M6jSbkfHXWcC2RxcL1t7k0flcsBPF8V4WQjjTr7FMwp4kbITmG3X45/owFZ5sGTf/YpRMBjzQhxqRYaAC/PnxH5tnqcr+t3YrOe+wT5+BcYa5k4pzpfniQUsGIw/kYvIKfDn659CjsAQsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SWc6Uxsb; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SWc6Uxsb"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240903055307epoutp041e0d199bae22013d177f05df757069c9~xph-XNdko1499814998epoutp04c
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 05:53:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240903055307epoutp041e0d199bae22013d177f05df757069c9~xph-XNdko1499814998epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725342787;
	bh=OYNVwuPeW6SsEtfUQWnk1cblS1zd0r5KDkboboGuesk=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=SWc6Uxsbpsr7XOo8EVqs6CDgHju9xqNgAh+qXlbMHOgPZOmX0j7BvETmCwdlJkphP
	 K5SGZbsUWrG/9yR/B0FdT3GwHxdcWuJEIjGZV3BQp8MD/scsxUykmu1OnFeIQRaz/P
	 FHY/mPV4emSINQl816cOKosYfzQijj2LcPhpB/0w=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240903055307epcas1p4524e6de8e5938cc555ab3319e936f92b~xph_4qw4B0765907659epcas1p4o;
	Tue,  3 Sep 2024 05:53:07 +0000 (GMT)
Received: from epsmgec1p1-new.samsung.com (unknown [182.195.36.227]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WyZXz0C15z4x9Py; Tue,  3 Sep
	2024 05:53:07 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmgec1p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.4D.19509.244A6D66; Tue,  3 Sep 2024 14:53:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240903055306epcas1p1dbe9e772c427ad5fe27197a01d9f2dcd~xph_K1KSF0704807048epcas1p1C;
	Tue,  3 Sep 2024 05:53:06 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240903055306epsmtrp25ed39f99dd73200fbdbbd1c1e6c4a485~xph_KLXK-0347603476epsmtrp29;
	Tue,  3 Sep 2024 05:53:06 +0000 (GMT)
X-AuditID: b6c32a4c-10bff70000004c35-94-66d6a4423292
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.37.07567.244A6D66; Tue,  3 Sep 2024 14:53:06 +0900 (KST)
Received: from hobinwoo05 (unknown [10.246.60.174]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240903055306epsmtip2955e3fe57062ccb38638392ffb98fd51~xph9_wMvK2535325353epsmtip2g;
	Tue,  3 Sep 2024 05:53:06 +0000 (GMT)
From: "Hobin Woo" <hobin.woo@samsung.com>
To: "'Steve French'" <smfrench@gmail.com>
Cc: <linux-cifs@vger.kernel.org>, <linkinjeon@kernel.org>,
	<sfrench@samba.org>, <senozhatsky@chromium.org>, <tom@talpey.com>,
	<sj1557.seo@samsung.com>, <kiras.lee@samsung.com>
In-Reply-To: <CAH2r5mvdprK8imp4MCgTS_t3Ke2Gk6bG3SJ0ksZGDNMR4wPGJQ@mail.gmail.com>
Subject: RE: [PATCH] ksmbd: make __dir_empty() compatible with POSIX
Date: Tue, 3 Sep 2024 14:53:06 +0900
Message-ID: <002601dafdc5$8c483ce0$a4d8b6a0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK7M9wwvANU2Ug2ja9sNvzytQiFfgKsmR7EAakkrRewYnOMgA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmga7TkmtpBhMXWlocaHnDbjFx2lJm
	ixf/dzFb7N64iM2i4+VRZost/46wWrx5cZjN4tSvU0wOHB6zGy6yeOycdZfdY9OqTjaPubv6
	GD36tqxi9Lj85Aqjx+dNcgHsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAr0ihNz
	i0vz0vXyUkusDA0MjEyBChOyM9ovLWUu6BCtuHjgOmsD4wfhLkZODgkBE4mmG1+Yuhi5OIQE
	9jBKLNy8hxEkISTwiVFi3VQFiMQ3RonXM5cxwnT0Xv7LCJHYyyjx9mYTM0THC0aJ/etNQWw2
	AU2Jv+372UBsESD7ze5JzCANzAKbGSVWP3zJCpLgFAiUuDFvKjuILSzgIjF/02wWEJtFQEWi
	f+YfsG28ApYS6xffZ4awBSVOznwCVsMsoC2xbOFrZoiLFCR+Pl3GCrHMSeLAxkPMEDUiErM7
	28AWSwis5JBo+rMRqJkDyHGR2HCIA6JXWOLV8S3sELaUxOd3e9kg7GKJdSfXQcVrJLpn34GK
	20s0tzazgYxhBnps/S59iFV8Eu++9rBCTOeV6GgTgqhWlmh8/JwFwpaUmLK8kRXC9pDYcvAz
	2wRGxVlIHpuF5LFZSB6YhbBsASPLKkap1ILi3PTUZMMCQ9281HJ4fCfn525iBKdZLZ8djN/X
	/9U7xMjEwXiIUYKDWUmEN3bj1TQh3pTEyqrUovz4otKc1OJDjKbA4J7ILCWanA9M9Hkl8YYm
	lgYmZkYmFsaWxmZK4rxnrpSlCgmkJ5akZqemFqQWwfQxcXBKNTBxbNnxdW7bbJWLk49u2XVh
	1bqo5xt1kti1I5asZT+hK1u9+vw2r6kx3NHsM6SOfBHYZCmp8+1l2+5lz5f5TA33dFk1y6Nh
	a2rVWt4tRhvSvjklHph933XR6il5pRIpOfsT8jsV3sgkxttMCYisYWlRU9n/sLt4VfER0fNN
	LHWOzyWkXnk8uxxwPcbm3iytZ7fFxBLkbtvLGhwwvXb2QuT9xr+lYsXmofEeB6T/tKv/fBmw
	/O8Rhdse3mK++4wWsVYJs2gsNu5R/tq85u2Vda177RI/1DZHCB51cIsWPR05q/PCoWes2wIC
	n95Y8TlmYs3hBPV3FTeycmN6Vktk/mJRTKtKE+k7sPVFsNJ0dkYlluKMREMt5qLiRABFzbSc
	PAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvK7TkmtpBlOeKVkcaHnDbjFx2lJm
	ixf/dzFb7N64iM2i4+VRZost/46wWrx5cZjN4tSvU0wOHB6zGy6yeOycdZfdY9OqTjaPubv6
	GD36tqxi9Lj85Aqjx+dNcgHsUVw2Kak5mWWpRfp2CVwZf1+cZSy4yl/xqucFawPjPp4uRk4O
	CQETid7LfxlBbCGB3YwST3truhg5gOKSEs8uSUCYwhKHDxd3MXIBVTxjlHhwrJ0ZpJxNQFPi
	b/t+NhBbBMh+s3sSM0gRM8iYY2sOs0J0XGKUuDHtGCtIFadAoMSNeVPZQWxhAReJ+Ztms4DY
	LAIqEv0z/4AdwStgKbF+8X1mCFtQ4uTMJ2A1zALaEr0PWxlh7GULXzNDPKAg8fPpMlaIK5wk
	Dmw8xAxRIyIxu7ONeQKj8Cwko2YhGTULyahZSFoWMLKsYpRMLSjOTc9NNiwwzEst1ytOzC0u
	zUvXS87P3cQIjjUtjR2M9+b/0zvEyMTBeIhRgoNZSYQ3duPVNCHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8hjNmpwgJpCeWpGanphakFsFkmTg4pRqYlEy3Gwe/qhQ+n3hV1UBCIPB34fG3j080
	Celel+CUP/M1dp8sx+rmCwovoxeG3Zj6YdfhLVHXpjz9v0g6eBLP4tcxqmefh1vGyaw5rJfD
	fMKygCGkyc9O+Z1tbXbrxZ/neFjql/V0J4oUmJ7/E2Ac2uBvJHXMi69hg0JeMqOw9qLbx96w
	tplJ7xZW+/SuZ+oW24P+qXE3902s9OTYpG9m/LR/4sVPfzyyvJ9Yxv6zDDmWGN0pYnW4+1iF
	xZubz95FR+3hkTPvv6A2ebnI5gyf/75veDaFXpxdG+Ue8ntHj3tFiVBe9QfWlxVLXCaulT9b
	ZiNYHbSu54LwCo6Ms+b9GZ9fPct+/8D9QoWU6RQlluKMREMt5qLiRAC5k4A7JAMAAA==
X-CMS-MailID: 20240903055306epcas1p1dbe9e772c427ad5fe27197a01d9f2dcd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250
References: <CGME20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250@epcas1p3.samsung.com>
	<20240903051918.728540-1-hobin.woo@samsung.com>
	<CAH2r5mvdprK8imp4MCgTS_t3Ke2Gk6bG3SJ0ksZGDNMR4wPGJQ@mail.gmail.com>

Android's FUSE file system, /storage/emulated/<USER>, is an example of this=
.
https://cs.android.com/android/platform/superproject/main/+/main:packages/p=
roviders/MediaProvider/jni/ReaddirHelper.cpp;l=3D52;drc=3D01c2d29eeefc2d344=
794429af3df08c38adfd57f

> -----Original Message-----
> From: Steve French <smfrench=40gmail.com>
> Sent: Tuesday, September 3, 2024 2:45 PM
> To: Hobin Woo <hobin.woo=40samsung.com>
> Cc: linux-cifs=40vger.kernel.org; linkinjeon=40kernel.org; sfrench=40samb=
a.org;
> senozhatsky=40chromium.org; tom=40talpey.com; sj1557.seo=40samsung.com;
> kiras.lee=40samsung.com
> Subject: Re: =5BPATCH=5D ksmbd: make __dir_empty() compatible with POSIX
>=20
> Is there an example where you have seen an fs not report . and .. ?
>=20
> On Tue, Sep 3, 2024 at 12:19=E2=80=AFAM=20Hobin=20Woo=20<hobin.woo=40sams=
ung.com>=20wrote:=0D=0A>=20>=0D=0A>=20>=20Some=20file=20systems=20may=20not=
=20provide=20dot=20(.)=20and=20dot-dot=20(..)=20as=20they=20are=0D=0A>=20>=
=20optional=20in=20POSIX.=20ksmbd=20can=20misjudge=20emptiness=20of=20a=20d=
irectory=20in=0D=0A>=20those=0D=0A>=20>=20file=20systems,=20since=20it=20as=
sumes=20there=20are=20always=20at=20least=20two=20entries:=0D=0A>=20>=20dot=
=20and=20dot-dot.=0D=0A>=20>=20Just=20set=20the=20dirent_count=20to=202,=20=
if=20the=20first=20entry=20is=20not=20a=20dot.=0D=0A>=20>=0D=0A>=20>=20Sign=
ed-off-by:=20Hobin=20Woo=20<hobin.woo=40samsung.com>=0D=0A>=20>=20---=0D=0A=
>=20>=20=20fs/smb/server/vfs.c=20=7C=202=20++=0D=0A>=20>=20=201=20file=20ch=
anged,=202=20insertions(+)=0D=0A>=20>=0D=0A>=20>=20diff=20--git=20a/fs/smb/=
server/vfs.c=20b/fs/smb/server/vfs.c=0D=0A>=20>=20index=209e859ba010cf..bb8=
36fa0aaa6=20100644=0D=0A>=20>=20---=20a/fs/smb/server/vfs.c=0D=0A>=20>=20++=
+=20b/fs/smb/server/vfs.c=0D=0A>=20>=20=40=40=20-1115,6=20+1115,8=20=40=40=
=20static=20bool=20__dir_empty(struct=20dir_context=20*ctx,=0D=0A>=20const=
=20char=20*name,=20int=20namlen,=0D=0A>=20>=20=20=20=20=20=20=20=20=20struc=
t=20ksmbd_readdir_data=20*buf;=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=20=20=
=20=20buf=20=3D=20container_of(ctx,=20struct=20ksmbd_readdir_data,=20ctx);=
=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(offset=20=3D=3D=200=20&&=20=21(na=
mlen=20=3D=3D=201=20&&=20name=5B0=5D=20=3D=3D=20'.'))=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20buf->dirent_count=20=3D=202;=0D=0A>=
=20>=20=20=20=20=20=20=20=20=20buf->dirent_count++;=0D=0A>=20>=0D=0A>=20>=
=20=20=20=20=20=20=20=20=20return=20buf->dirent_count=20<=3D=202;=0D=0A>=20=
>=20--=0D=0A>=20>=202.43.0=0D=0A>=20>=0D=0A>=20>=0D=0A>=20=0D=0A>=20=0D=0A>=
=20--=0D=0A>=20Thanks,=0D=0A>=20=0D=0A>=20Steve=0D=0A=0D=0A
