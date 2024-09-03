Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB4B1D1726
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725345196; cv=none; b=DyP1UerJbwnRRlyjoJ+Z62EC9glAIFuss3JwQGpaLHU9ZRuolOCAiilQXQ+F7+Q2Iw6HbPDcp7A+TtXk9rgIgPX/wNX6rwKAMWDS+BQGiOyciXRcLXnz7IS9djWqLEIDhVWF4K0nqDhrAaPDZjqlPdlKrpJt/iSYSGeRZ4EGEiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725345196; c=relaxed/simple;
	bh=szCIc29dWt+2hcsHz1SQ4Wbgz6YMxd3rTKOaVvEybc4=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=tq5YQQFs5r+UFHQRKmIYVF47npQJEQfWehR7BIdaE5oGuiMxcg59qxKWZLtC5nio90Apjs90sRVARCCFDLn/RI8+YrxY8N+W8hPIXjtWPDEv3ZUvRFUVvPU3/DFiMeVkV+q9sDQV3WG+LQqV9mSfSwlsPi1FJ6nlSqKVjM4WhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RZNO4kDw; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RZNO4kDw"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240903063305epoutp0112f2faa0ab953316da8eed110bec472e~xqE3-DcXR2672626726epoutp01R
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 06:33:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240903063305epoutp0112f2faa0ab953316da8eed110bec472e~xqE3-DcXR2672626726epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725345185;
	bh=szCIc29dWt+2hcsHz1SQ4Wbgz6YMxd3rTKOaVvEybc4=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=RZNO4kDw7wTgCUiQPkwDqD3Urd1zJUQ+hRpxFF+ptXfsaCGwKTTUPahiLDg+7wv9B
	 Xyc6UmmoogSKLQcHv46ETBdlkpPcDPBncRSOHg9ayrKcVgHL7n8Kz3c81Kgy7R7uMs
	 QWqQ/Vbh6pM2PS1H47niUZ061alvpFS/ADAkFeMo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240903063304epcas1p462f4c1d80455718a7fece47b7c2d7426~xqE3jSV_j0555505555epcas1p4H;
	Tue,  3 Sep 2024 06:33:04 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.36.226]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WybR41nt3z4x9QH; Tue,  3 Sep
	2024 06:33:04 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	60.0B.09734.F9DA6D66; Tue,  3 Sep 2024 15:33:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240903063303epcas1p26f368533650a6c2e62180ec2efbf68fd~xqE2FFDcO2995529955epcas1p2M;
	Tue,  3 Sep 2024 06:33:03 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240903063303epsmtrp1507bb81b4ce2c77c6bf0c6387ffaf978~xqE2ECNFy1321813218epsmtrp16;
	Tue,  3 Sep 2024 06:33:03 +0000 (GMT)
X-AuditID: b6c32a39-b5dfa70000002606-61-66d6ad9f43f9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BC.69.08964.E9DA6D66; Tue,  3 Sep 2024 15:33:03 +0900 (KST)
Received: from hobinwoo05 (unknown [10.246.60.174]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240903063302epsmtip18073bcf864b4cc2a38a7a95f8cccb2c4~xqE1xcFMk0395903959epsmtip15;
	Tue,  3 Sep 2024 06:33:02 +0000 (GMT)
From: "Hobin Woo" <hobin.woo@samsung.com>
To: "'Namjae Jeon'" <linkinjeon@kernel.org>
Cc: "'CIFS'" <linux-cifs@vger.kernel.org>, "'Steve French'"
	<sfrench@samba.org>, "'Sergey Senozhatsky'" <senozhatsky@chromium.org>,
	"'Tom Talpey'" <tom@talpey.com>, "'Sungjong Seo'" <sj1557.seo@samsung.com>,
	=?UTF-8?B?J+ydtOq4sOyEsSc=?= <kiras.lee@samsung.com>
In-Reply-To: <005401dafdc9$18aaee00$4a00ca00$@samsung.com>
Subject: RE: [PATCH] ksmbd: make __dir_empty() compatible with POSIX
Date: Tue, 3 Sep 2024 15:33:02 +0900
Message-ID: <005501dafdcb$20ada410$6208ec30$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK7M9wwvANU2Ug2ja9sNvzytQiFfgKsmR7EAnkQNaUB92YBALBMQgtQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmge78tdfSDD6+V7Y40PKG3WLitKXM
	Fi/+72K22L1xEZtFx8ujzBZb/h1htTj16xSTA7vH7IaLLB6bVnWyeczd1cfo0bdlFaPH5SdX
	GD0+b5ILYIvKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BWoFecmFtcmpeul5daYmVo
	YGBkClSYkJ2xbsZUtoJr0hVXHzeyNzB+lOpi5OSQEDCR+H3yJmsXIxeHkMAORokXD+6xQTif
	GCX+zZnMAuF8Y5R48us0I0zL1mV/GSESexkl7t1bAZYQEnjBKLHuWwqIzSagKfG3fT/QKA4O
	EQFtifsv0kHqmQW6mCSW9l5lBqnhFLCSWPL9IguILSzgIjF/02wwm0VAReLGzfusIDavgKVE
	+67N7BC2oMTJmU/AapiBZi5b+JoZ4iAFiZ9Pl4HViwi4Sfz9vZ8JokZEYnZnGzPIYgmBuRwS
	337/h/rAReLF3x6oZmGJV8e3sEPYUhIv+9ug7GKJdSfXQdk1Et2z77BB2PYSza3NYI8xAz25
	fpc+xC4+iXdfe1hBwhICvBIdbUIQ1coSjY+fs0DYkhJTljeyQtgeElsOfmabwKg4C8lns5B8
	NgvJB7MQli1gZFnFKJZaUJybnlpsWGAKj+zk/NxNjOBkqmW5g3H62w96hxiZOBgPMUpwMCuJ
	8MZuvJomxJuSWFmVWpQfX1Sak1p8iNEUGNYTmaVEk/OB6TyvJN7QxNLAxMzIxMLY0thMSZz3
	zJWyVCGB9MSS1OzU1ILUIpg+Jg5OqQamxmPek+vOvI4NkG+bvO7Pg6t+ag/zf1jdcdDqMZza
	mJ5r5nh/a5jcib2TZuyXmrz06KfvfTzPT7DOsVW85PqN+35YyWLef09/fNkUdO0UU3vnPOvU
	WSFvYpfNnGKmXcq/g2H1p5Wz5/x+Fd3N06KwN12V15CNj+udZEJo1tol4kFLGJQ5M02msu46
	u/j9kYUH95za3fnl0H+dCUFV2851WV77/KPSO+tNuZFF9+TrEx/8dykr6TEPVbX49mtS6c+f
	XPZmAlM6e5el26wSX7PDIyJkXc2Hk3GK9zafEVonI9k9oZsx5VnM8SpRqZgJO1zzvz9efeLF
	6w1PuufdkbNqU258Nk8zj+vlDfEC5/meh5VYijMSDbWYi4oTAdJ/pFMvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42LZdlhJTnf+2mtpBg83MFkcaHnDbjFx2lJm
	ixf/dzFb7N64iM2i4+VRZost/46wWpz6dYrJgd1jdsNFFo9NqzrZPObu6mP06NuyitHj8pMr
	jB6fN8kFsEVx2aSk5mSWpRbp2yVwZTxpWsJa8F6w4sQZ+QbGTbxdjJwcEgImEluX/WXsYuTi
	EBLYzSix6dgd9i5GDqCEpMSzSxIQprDE4cPFECXPGCUm3pnNDNLLJqAp8bd9PxtIjYiAtsT9
	F+kgNcwCfUwSd79PA6sREmhgkjjc6wpicwpYSSz5fpEFxBYWcJGYv2k2mM0ioCJx4+Z9VhCb
	V8BSon3XZnYIW1Di5MwnYDXMQPN7H7YywtjLFr5mhrhfQeLn02VgvSICbhJ/f+9ngqgRkZjd
	2cY8gVF4FpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgTH
	lJbmDsbtqz7oHWJk4mA8xCjBwawkwhu78WqaEG9KYmVValF+fFFpTmrxIUZpDhYlcV7xF70p
	QgLpiSWp2ampBalFMFkmDk6pBibjz8dPJMkumXHf4krjfV3viiW7+I1duY4VpseoPyj/MT2v
	xXHlrKl3pjnXJRxancp6fsbFR8EPp+hGqlzUfvHLXrLa4W3CzP0Vl2MfJyRt7vRK2ldVOif5
	v/srBga2Z6vT0wuSON867D3Vp9i3fnXlj5S4s0XtgpP8N06JeXg910z2+ZuIa+pTatucVfI3
	7frx7qe0X5ebSd5NY8G3q+M9Xs62WD3bjHOm8Nk447PZX7jdInO+mbLf3/vdxilTPfZje/We
	HuNl9w4eLl1q/JF/0o17F2Z3shXzruf8pGd0WHN71Q6tmZUt2n2uQg51RsHny/XDfq7ee1/3
	xyOWujMW4QqsTEUBoY1NhccmyCmxFGckGmoxFxUnAgAf3UrVGAMAAA==
X-CMS-MailID: 20240903063303epcas1p26f368533650a6c2e62180ec2efbf68fd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250
References: <CGME20240903051932epcas1p31c823baa892d8dc3f3e2ed8e1c073250@epcas1p3.samsung.com>
	<20240903051918.728540-1-hobin.woo@samsung.com>
	<CAKYAXd_zBESXWJ+CubrDBd0u_i9h=CimJ=6E_DxtfNLTXxRPgA@mail.gmail.com>
	<005401dafdc9$18aaee00$4a00ca00$@samsung.com>

>=20
> On Tue, Sep 3, 2024 at 2:19=E2=80=AFPM=20Hobin=20Woo=20<hobin.woo=40samsu=
ng.com>=0D=0A>=20wrote:=0D=0A>=20>=0D=0A>=20>=20Some=20file=20systems=20may=
=20not=20provide=20dot=20(.)=20and=20dot-dot=20(..)=20as=20they=20are=0D=0A=
>=20>=20optional=20in=20POSIX.=20ksmbd=20can=20misjudge=20emptiness=20of=20=
a=20directory=20in=0D=0A>=20those=0D=0A>=20>=20file=20systems,=20since=20it=
=20assumes=20there=20are=20always=20at=20least=20two=20entries:=0D=0A>=20>=
=20dot=20and=20dot-dot.=0D=0A>=20>=20Just=20set=20the=20dirent_count=20to=
=202,=20if=20the=20first=20entry=20is=20not=20a=20dot.=0D=0A>=20>=0D=0A>=20=
>=20Signed-off-by:=20Hobin=20Woo=20<hobin.woo=40samsung.com>=0D=0A>=20>=20-=
--=0D=0A>=20>=20=20fs/smb/server/vfs.c=20=7C=202=20++=0D=0A>=20>=20=201=20f=
ile=20changed,=202=20insertions(+)=0D=0A>=20>=0D=0A>=20>=20diff=20--git=20a=
/fs/smb/server/vfs.c=20b/fs/smb/server/vfs.c=0D=0A>=20>=20index=209e859ba01=
0cf..bb836fa0aaa6=20100644=0D=0A>=20>=20---=20a/fs/smb/server/vfs.c=0D=0A>=
=20>=20+++=20b/fs/smb/server/vfs.c=0D=0A>=20>=20=40=40=20-1115,6=20+1115,8=
=20=40=40=20static=20bool=20__dir_empty(struct=20dir_context=20*ctx,=0D=0A>=
=20const=20char=20*name,=20int=20namlen,=0D=0A>=20>=20=20=20=20=20=20=20=20=
=20struct=20ksmbd_readdir_data=20*buf;=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=
=20=20=20=20buf=20=3D=20container_of(ctx,=20struct=20ksmbd_readdir_data,=20=
ctx);=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(offset=20=3D=3D=200=20&&=20=
=21(namlen=20=3D=3D=201=20&&=20name=5B0=5D=20=3D=3D=20'.'))=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20buf->dirent_count=20=3D=202;=
=0D=0A>=20How=20about=20not=20counting=20the=20dot,=20dotdot=20entry?=20Bec=
ause=20the=20dot,=20dotdot=0D=0A>=20entry=20is=20not=20always=20at=20the=20=
front.=0D=0A>=20and=20we=20change=20the=20following=20code=20together=20if=
=20we=20do=20not=20count=20them.=0D=0AThanks=20for=20pointing=20out.=0D=0AW=
e=20should=20also=20consider=20the=20stop=20condition.=20So=20the=20v2=20co=
de=20would=20look=20like=20this:=0D=0A=09buf=20=3D=20container_of(ctx,=20st=
ruct=20ksmbd_readdir_data,=20ctx);=0D=0A+=20=20=20=20=20=20=20if=20(=21is_d=
ot_dotdot(name,=20namlen))=0D=0A+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20buf->dirent_count++;=0D=0A=0D=0A-=20=20=20=20=20=20=20return=20buf->dire=
nt_count=20<=3D=202;=0D=0A+=20=20=20=20=20=20=20return=20=21buf->dirent_cou=
nt;=0D=0A=0D=0AThanks.=0D=0A=0D=0A=0D=0A>=20=0D=0A>=20diff=20--git=20a/fs/s=
mb/server/vfs.c=20b/fs/smb/server/vfs.c=0D=0A>=20index=209e859ba010cf..243b=
b2f3aa1f=20100644=0D=0A>=20---=20a/fs/smb/server/vfs.c=0D=0A>=20+++=20b/fs/=
smb/server/vfs.c=0D=0A>=20=40=40=20-1137,7=20+1137,7=20=40=40=20int=20ksmbd=
_vfs_empty_dir(struct=20ksmbd_file=20*fp)=0D=0A>=20=20=20=20=20=20=20=20=20=
readdir_data.dirent_count=20=3D=200;=0D=0A>=20=0D=0A>=20=20=20=20=20=20=20=
=20=20err=20=3D=20iterate_dir(fp->filp,=20&readdir_data.ctx);=0D=0A>=20-=20=
=20=20=20=20=20=20if=20(readdir_data.dirent_count=20>=202)=0D=0A>=20+=20=20=
=20=20=20=20=20if=20(readdir_data.dirent_count)=0D=0A>=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20err=20=3D=20-ENOTEMPTY;=0D=0A>=20=20=20=20=20=
=20=20=20=20else=0D=0A>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20e=
rr=20=3D=200;=0D=0A>=20=0D=0A>=20Thanks.=0D=0A>=20>=20=20=20=20=20=20=20=20=
=20buf->dirent_count++;=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=20=20=20=20ret=
urn=20buf->dirent_count=20<=3D=202;=0D=0A>=20>=20--=0D=0A>=20>=202.43.0=0D=
=0A>=20>=0D=0A>=20=0D=0A=0D=0A=0D=0A
