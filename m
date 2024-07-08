Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6918824A3
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jul 2024 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720441876; cv=none; b=tYmUS09I0+TISbRvAL3SYvm9n5UePk8xgWKZIAMTTV/uCqxwDshdf8mkwWyL/gQqo4lg8r6bw+7g/X0wspDPNm33OuMwpAsXi7qFtcMg1gdBfJE/uyXcm+JLqWvAewWt/XWlurhyoTIG1JcdH744/wM5f1c25RXzi+1/fakfiHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720441876; c=relaxed/simple;
	bh=M/7HMUIr1zuTuj0Fw+kUwT+vZEGzY2YodNA8WW6XVcQ=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=G7FTQiQNuaWjtPRaCkjfw68ihQlSTz1R2E38B/rWCatv1u4bAcp2KMPRxw/cptdOS/eSECOaScJA/rqWEQ2Q7YPetq+rwkV7XjRfePcjjczU58tRMNDPu6kbRqZzYF5OI8ERlBRiaa3ChuZLBUgJMSIvYzgPmG+efmUZbBJxmIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FyQdbsXB; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FyQdbsXB"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240708123111epoutp043f92194d97a1c0e6446a6dbfa164069c~gPMRIyZ6J0111901119epoutp04c
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jul 2024 12:31:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240708123111epoutp043f92194d97a1c0e6446a6dbfa164069c~gPMRIyZ6J0111901119epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720441871;
	bh=M/7HMUIr1zuTuj0Fw+kUwT+vZEGzY2YodNA8WW6XVcQ=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=FyQdbsXB3tpY0/rVGERdetLVbAB4nPxZstSOLFn55dT1/eLvmDIwnVttTmZMyBmTW
	 IEGXuVq8FydPWg6kTJxxL/AIsPdXTbLtFy9Bj59PMGCgWEc0CTmGTEt17yAM+6J+8S
	 Xd2xL24wXY8K/KX9LjzgU+SG1QTsV0m/fvJjp2NQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240708123110epcas1p4c75aae5842491694a6762128698dce21~gPMQoOd0r2692726927epcas1p46;
	Mon,  8 Jul 2024 12:31:10 +0000 (GMT)
Received: from epsmgec1p1-new.samsung.com (unknown [182.195.38.243]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WHk4Z1BTSz4x9Px; Mon,  8 Jul
	2024 12:31:10 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmgec1p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.52.19059.E0CDB866; Mon,  8 Jul 2024 21:31:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240708123109epcas1p38d8fe8fa28f3124091dbafb3f0d1384d~gPMPkCNoE2712627126epcas1p30;
	Mon,  8 Jul 2024 12:31:09 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240708123109epsmtrp247f295aa281bde8593d821dd4ae301a1~gPMPjWLTB1389513895epsmtrp2G;
	Mon,  8 Jul 2024 12:31:09 +0000 (GMT)
X-AuditID: b6c32a4c-e6fff70000004a73-a0-668bdc0e9fb6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.9C.07412.D0CDB866; Mon,  8 Jul 2024 21:31:09 +0900 (KST)
Received: from hobinwoo05 (unknown [10.246.60.174]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240708123109epsmtip1e5ce345301379947173595c48ac4bd5a~gPMPVT0t41290312903epsmtip1b;
	Mon,  8 Jul 2024 12:31:09 +0000 (GMT)
From: "Hobin Woo" <hobin.woo@samsung.com>
To: "'Tom Talpey'" <tom@talpey.com>, "'Ralph Boehme'" <slow@samba.org>,
	"'Namjae Jeon'" <linkinjeon@kernel.org>
Cc: <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
	<senozhatsky@chromium.org>, <sj1557.seo@samsung.com>,
	<yoonho.shin@samsung.com>, <kiras.lee@samsung.com>
In-Reply-To: <e39d83a4-4f8c-41c6-98e5-089a51a2e833@talpey.com>
Subject: RE: [PATCH v2] ksmb: discard write access to the directory open
Date: Mon, 8 Jul 2024 21:31:09 +0900
Message-ID: <02ad01dad132$b62837f0$2278a7d0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIaGRn8a8r1qVWIUbQ+O5SqjZMFsgLXObxqAnxJ25wCAAAzFAI/vfk7Als8q1WxDqlXUA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmvi7fne40gxNT2SwOtLxht5g4bSmz
	xYv/u5gtdm9cxGbR8fIos8WWf0dYLb5cucJucerXKSaLoyfuMjpwesxuuMjisWlVJ5vH3F19
	jB59W1Yxelx+coXR4/MmuQC2qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWF
	vMTcVFslF58AXbfMHKCrlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFZgV6xYm5
	xaV56Xp5qSVWhgYGRqZAhQnZGVfPrGIu2C1bse/IcdYGxmMyXYycHBICJhJH579jBLGFBPYw
	Slz7kt3FyAVkf2KUeDr7JiOE841RYvvFFewwHf9/LIZK7GWU6Dkzhx3CecEosbNnHzNIFZuA
	psTf9v1sILaIQKHE5GnvWEGKmAUWM0qcuHETqIODg1PATuLHL0eQGmEBD4mTny4wgdgsAioS
	26c9BtvGK2ApsXjtVVYIW1Di5MwnLCA2s4C2xLKFr5khLlKQ+Pl0GSvErjCJU++eQ9WISMzu
	bGMG2SshsJZDYk3nOUaQvRICLhITexUheoUlXh3fAvWZlMTnd3vZIOxiiXUn10HFayS6Z9+B
	ittLNLc2s4GMYQb6cf0ufYhVfBLvvvawQkznlehoE4KoVpZofAxxjYSApMSU5Y1QJR4Sr99L
	TmBUnIXkr1lI/pqF5P5ZCLsWMLKsYpRKLSjOTU9NNiww1M1LLYdHd3J+7iZGcJLV8tnB+H39
	X71DjEwcjIcYJTiYlUR459/oThPiTUmsrEotyo8vKs1JLT7EaAoM7YnMUqLJ+cA0n1cSb2hi
	aWBiZmRiYWxpbKYkznvmSlmqkEB6YklqdmpqQWoRTB8TB6dUA5NEiPSNtcoyquvqvDpjPio9
	Z6+Z9kFOKmqje/zrfyLRk007TwRstrwitnxq2ebXnvKsZje3sD9xzTkYLLygdMoz81oxDe7i
	/627BX5qapVqf5u+NWrji3MdzOIHWBjV1ISr8q1rZaJyZu+6/IjTc8rHOpGZvT/PCx9b0fMw
	eNeSOTpr9wjcZ3LTeruX8/u3JOXnZ/q4YmZfiVJY5XWil2FqVNwM375jHPMZu1fv/N15dKK1
	s8EWEbEbkusjxcUFcyNCZK9/2zl79ZuuGiflU3a6tj+eblCfIpBW8PerRL+DR7DazFSXIxvy
	N02uDGX4mRV68EFjgm7C6yNuGx/8vPm1wtLp4XKVToY3x02UziqxFGckGmoxFxUnAgD2PVAq
	OwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSnC7vne40gwcLlS0OtLxht5g4bSmz
	xYv/u5gtdm9cxGbR8fIos8WWf0dYLb5cucJucerXKSaLoyfuMjpwesxuuMjisWlVJ5vH3F19
	jB59W1Yxelx+coXR4/MmuQC2KC6blNSczLLUIn27BK6Mzns3WApOilRM3vODpYFxpkAXIyeH
	hICJxP8fixm7GLk4hAR2M0q8W/yXpYuRAyghKfHskgSEKSxx+HAxRMkzRokf7x+xgfSyCWhK
	/G3fD2aLCBRLPJl1kh2kiFlgJaPErb/vWCE6njJJvGqayg4yiVPATuLHL0eQBmEBD4mTny4w
	gdgsAioS26c9ZgexeQUsJRavvcoKYQtKnJz5hAXEZhbQluh92MoIYy9b+JoZ4gEFiZ9Pl7FC
	HBEmcerdc6h6EYnZnW3MExiFZyEZNQvJqFlIRs1C0rKAkWUVo2RqQXFuem6yYYFhXmq5XnFi
	bnFpXrpecn7uJkZwrGlp7GC8N/+f3iFGJg7GQ4wSHMxKIrzzb3SnCfGmJFZWpRblxxeV5qQW
	H2KU5mBREuc1nDE7RUggPbEkNTs1tSC1CCbLxMEp1cDUZiKln8ht+deI6dLHF3NC193QPqLJ
	G3xub5zf6aqMXi9uZyYe9Ql5O5smbogUmRWZu7MkRlXy2w72ORZST/cWvzjjvtXtNePFdS/s
	qoslREsUP+1/wpWoVyP7fl8tgzHDG+UXS529lk2pYlyZPOlnfzevZ86JjJOpU//wTJqw4b+M
	vNbXs3mGLCIcOXu+rhV516udEsXVaeObnunb+67vzyF/u6qXUc+rerXDlxwLf7BNacGsC5uX
	Njr1mO9/efGX7dH/O+Jeyz42+PqONTb19uz2PLOrDYeD225xrj+jeS/3QICf1CqNGzdie/Z7
	Of2snXs66q1Sp11taHyi2OLjraJWIYsPnXR8nszz97YSS3FGoqEWc1FxIgCv7z8/JAMAAA==
X-CMS-MailID: 20240708123109epcas1p38d8fe8fa28f3124091dbafb3f0d1384d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240705032731epcas1p177d910a154ded37c459af1c2374a3571
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
	<20240705032725.39761-1-hobin.woo@samsung.com>
	<1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
	<CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
	<ef50bdc4-360f-4714-a503-bddbdabcbb14@samba.org>
	<e39d83a4-4f8c-41c6-98e5-089a51a2e833@talpey.com>

> On 7/5/2024 9:16 AM, Ralph Boehme wrote:
> > On 7/5/24 2:33 PM, Namjae Jeon wrote:
> >> 2024=EB=85=84=207=EC=9B=94=205=EC=9D=BC=20(=EA=B8=88)=20=EC=98=A4=ED=
=9B=84=208:54,=20Ralph=20Boehme=20<slow=40samba.org>=EB=8B=98=EC=9D=B4=20=
=EC=9E=91=EC=84=B1:=0D=0A>=20>>>=0D=0A>=20>>>=20On=207/5/24=205:27=20AM,=20=
Hobin=20Woo=20wrote:=0D=0A>=20>>>>=20may_open()=20does=20not=20allow=20a=20=
directory=20to=20be=20opened=20with=20the=20write=0D=0A>=20>>>>=20access.=
=0D=0A>=20>>>>=20However,=20some=20writing=20flags=20set=20by=20client=20re=
sult=20in=20adding=20write=0D=0A>=20access=0D=0A>=20>>>>=20on=20server,=20m=
aking=20ksmbd=20incompatible=20with=20FUSE=20file=20system.=20Simply,=0D=0A=
>=20>>>>=20let's=0D=0A>=20>>>>=20discard=20the=20write=20access=20when=20op=
ening=20a=20directory.=0D=0A>=20>>>=0D=0A>=20>>>=20afair=20this=20should=20=
cause=20a=20failure=20like=20EACCESS=20or=20EISDIR=20and=20just=20be=0D=0A>=
=20>>>=20ignored.=20What=20does=20a=20Windows=20server=20return=20in=20this=
=20case,=20or=20Samba=20for=0D=0A>=20>>>=20that=20matter=20as=20it=20(hopef=
ully)=20will=20behave=20like=20Windows.=0D=0A>=20>>=20=20From=20what=20I've=
=20checked=20the=20packet=20dump,=20Samba=20doesn't=20return=20any=0D=0A>=
=20>>=20errors=20in=20the=20same=20case.=0D=0A>=20>>=20Samba=20seems=20to=
=20open=20it=20with=20O_RDONLY=20if=20it=20is=20directory,=20So=20there=20i=
s=0D=0A>=20>>=20no=20problem,=20is=20it=20right?=0D=0A>=20>=0D=0A>=20>=20Hm=
,=20it=20seems=20my=20memory=20is=20playing=20tricks=20on=20me.=20Samba=20i=
ndeed=20forces=0D=0A>=20>=20O_RDONLY=20for=20directories=20in=20the=20serve=
rs=20and=20ignores=20the=20client=0D=0A>=20requested=0D=0A>=20>=20access=20=
mask.=20Interestingly=20we=20don't=20seem=20to=20have=20any=20test=20for=20=
this=20case,=0D=0A>=20>=20at=20least=20I=20couldn't=20find=20any=20with=20a=
=20quick=20search.=20Quickly=20putting=0D=0A>=20>=20together=20a=20torture=
=20test=20shows=20Windows=20behaves=20the=20same.=20MS-FSA=20doesn't=0D=0A>=
=20>=20mention=20any=20such=20check=20should=20be=20done=20for=20directorie=
s=20as=20well.=20Getinfo=0D=0A>=20>=20on=20such=20a=20handle=20even=20retur=
ns=20the=20original=20unmodified=20client=20access=0D=0A>=20>=20mask,=20inc=
luding=20the=20write=20access.=0D=0ARight.=20That=20is=20why=20I=20fixed=20=
ksmd=20not=20FUSE.=0D=0A>=20>=0D=0A>=20>=20Sorry=20for=20the=20noise=21=20:=
)=0D=0A>=20>=0D=0A>=20>=20-slow=0D=0A>=20=0D=0A>=20I=20would=20ask=20to=20s=
ee=20that=20the=20SMB3=20protocol=20test=20suite=20results=20are=20not=0D=
=0A>=20impacted=20by=20this=20change,=20and=20ideally=20the=20various=20Lin=
ux/XFS=20tests=20as=0D=0A>=20well.=20I=20don't=20see=20any=20indication=20t=
hese=20were=20run?=0D=0A>=20=0D=0A>=20The=20other=20thing=20I=20want=20to=
=20point=20out=20is=20that=20the=20crash=20reported=20in=20the=0D=0A>=20com=
mit=20message=20is=20a=20FUSE=20failure.=20Why=20is=20that=20not=20a=20bug,=
=20and=20why=20does=0D=0A>=20the=20message=20not=20justify=20why=20the=20=
=22fix=22=20is=20in=20ksmbd?=0D=0AAs=20you=20pointed=20out,=20if=20FUSE=20h=
ad=20additional=20checks=20for=20this,=20then=20the=20issue=0D=0Awouldn't=
=20have=20occurred=20in=20the=20first=20place.=20However,=20I=20believe=20i=
t=20is=20not=20the=0D=0Afundamental=20fix=20since=20FUSE=20operates=20corre=
ctly=20under=20the=20sanity=20checks=20of=20VFS.=20=0D=0A=0D=0AWidely=20use=
d=20file=20systems=20may=20perform=20such=20checks=20by=20themselves=20or=
=20might=20not=20=0D=0Ahave=20the=20functionality=20related=20to=20this.=20=
But=20if=20any=20new=20functionality=0D=0Arelevant=20to=20this=20were=20add=
ed,=20we=20can=20expect=20similar=20problems=20to=20happen.=0D=0A=0D=0AHobi=
n=0D=0A>=20=0D=0A>=20Tom.=0D=0A=0D=0A
