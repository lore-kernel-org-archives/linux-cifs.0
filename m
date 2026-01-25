Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1212F3608
	for <linux-cifs@vger.kernel.org>; Sun, 25 Jan 2026 19:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769369225; cv=none; b=FGF5NhtT7cxL4YF+a9nmR3Ul24q5GgqiJQQ/TjSJUpdLWmhyTUHWbrEFN04R1BYrO2YHVXPiQLN5OA0eFtQeLwF7eKJGGaUaDnqByVU0G7NBewOpeSxDUfTJ7WHEYT6GFWjelhnAHEePJr8ScTwP4G8+Sp6VjIUfbkR+NFmTcdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769369225; c=relaxed/simple;
	bh=VFYV+W6vxiBeByE7k+LL0zm44Pqxf/vPCIPL+lLuYXU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCSFTEze8drogGyXTELHFEaT39AmgoefxeMP3oLBPo8/nLsiDFLgFEYRcTd+WseBbvRIMzcExIF6RYo0HXfDxY9BG4xdkiwKquzUBdV/DWLMy+bqu5qP7+L5r0nDKU8gQdV9RcfyBcfVXu2VpeTOGN+prlk98BeLCnWWr4F6czQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denisons.org; spf=pass smtp.mailfrom=denisons.org; dkim=pass (2048-bit key) header.d=denisons.org header.i=@denisons.org header.b=nJEl5OaF; arc=none smtp.client-ip=79.135.106.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denisons.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denisons.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denisons.org header.i=@denisons.org header.b="nJEl5OaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denisons.org;
	s=protonmail; t=1769369214; x=1769628414;
	bh=VFYV+W6vxiBeByE7k+LL0zm44Pqxf/vPCIPL+lLuYXU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=nJEl5OaF3vVQ5KHjCy6bLex+JX8EYaPJ16u9Aqx5crWQLsoWN0rVx4OD9AfkNX2Un
	 +w8WQGqz1bo9eNBS6ZuylN81XKJ7Hy2nfgLC6516okTF15YXVZGULT3iMybDf1NMjk
	 kB4fLUKpVXI4x9NDm+qHvn3doAZX1CxVOMiulvu2AZ7z5GRnsqK1blcGGgJPj2uAxM
	 raXzseRJ36LHcutWgG3CFYcjLEvBTVVCSQ4YrHTCgS92hei3AaB2ocNqv0G+9muXkx
	 oe5qHf+OFZKsTOBCVYL/XQs3OrU/+85Pxe/Zly6YoyKcpDsK8CJktJLiwT8vj8RL3p
	 GxQPOX2Z5Lb9w==
Date: Sun, 25 Jan 2026 19:26:50 +0000
To: Steve French <smfrench@gmail.com>, ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, Steven French <Steven.French@microsoft.com>
From: Sam Denison <dev@denisons.org>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Decimated subseconds in smbinfo filebasicinfo timestamp output
Message-ID: <shU8wpo2oNyUu4RkVuN0VHmIES1SzKRN9in6AJDn4EKDDGwMkzl2ShJ8i-4AfFOSKDDnEhxZVGH_w8y9JxO683d_QQzMJOig7eOb0AmaFBs=@denisons.org>
In-Reply-To: <CAH2r5ms02k4feJEmfzenU-DgFMSDFDiCc1=o_JpyaiWcnOU1Tg@mail.gmail.com>
References: <n3ma17AT6PhgrI6OfkbdTz3n_ak9jHfcYoGaAOdyxsY63h-GVDNpzS98XsQlTPN6r2nYxdQ_ODsxNX7fPh8J0PpSJ7-Tvt_8uqjtpfQamGw=@denisons.org> <hrQNBHikNUU26Klip-roC5Vuq474cWlMtfx-yvROP7k6iAyEW66dCc8negCRm4xdOuRqAQDa346BJQKyFLl3HveGykv-jkKihJarU5MYpFQ=@denisons.org> <f147af48-6c01-47f4-ba51-71b77c1ea94a@linux.dev> <Sj-xdM9FhG-h2q9G9x6pAEQN2TZEyWvq3Vh66-KRyGXnoDxar4KfSmsStO9n2mWnJgez0zqgn7STXBXjedgRKRLs23ql190kfqKNrl1J48Y=@denisons.org> <LV9PR21MB4757D8624474C50468BEAE81E48EA@LV9PR21MB4757.namprd21.prod.outlook.com> <LV9PR21MB4757E63CE7D0DE2610AF2655E489A@LV9PR21MB4757.namprd21.prod.outlook.com> <50b282c2-6a06-42cc-b52e-b545fd8d9e01@linux.dev> <hAshiKr_dint37zHnaRbpo9UNdT9my5xllqfyLLXWYZR5jpRVn2lpTvzgWWng3w-INoptu8YHCUMVtda0JV-ekS3zNGePJgJMqL3wKw6HWQ=@denisons.org> <CAH2r5ms02k4feJEmfzenU-DgFMSDFDiCc1=o_JpyaiWcnOU1Tg@mail.gmail.com>
Feedback-ID: 178018445:user:proton
X-Pm-Message-ID: f36357a741459239bb777379249f119e814bd5ee
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="b1=_qD026MqNwTzcz1RtPQA3JwbdbKZsFcvLHZmLmqeeY"

--b1=_qD026MqNwTzcz1RtPQA3JwbdbKZsFcvLHZmLmqeeY
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Okay, like this?

I=E2=80=99ve attached the patch kindly written by ChenXiaoSong, if I unders=
tand the intention this is simply to allow me to take credit and do little =
to no work! I only edited the dates and times in the patches header and exa=
mples. I haven=E2=80=99t ran a single Git command! Hope the patch still wor=
ks.

I=E2=80=99ve CCed linux-cifs@vger.kernel.org and samba-technical@lists.samb=
a.org as requested

Sam


On Tuesday, 20 January 2026 at 15:40, Steve French <smfrench@gmail.com> wro=
te:

> You can send your patch as an attachment to us, you shouldn't need to cha=
nge your email address or worry about smtp.
>=20
> Thanks,
>=20
> Steve
--b1=_qD026MqNwTzcz1RtPQA3JwbdbKZsFcvLHZmLmqeeY
Content-Type: application/octet-stream; name=0001-smbinfo-fix-decimated-subseconds-in-smbinfo-filebasi.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=0001-smbinfo-fix-decimated-subseconds-in-smbinfo-filebasi.patch

RnJvbSA3OTEzYzFhMjRiMDNiOGMzNDc1ZWZlYmJiNzhjYWM1YmZiNDRiZTczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW0gRGVuaXNvbiA8ZGV2QGRlbmlzb25zLm9yZz4KRGF0ZTog
U3VuLCAyNSBKYW4gMjAyNiAxOToxNTowMSArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIHNtYmluZm86
IGZpeCBkZWNpbWF0ZWQgc3Vic2Vjb25kcyBpbiBzbWJpbmZvIGZpbGViYXNpY2luZm8KIHRpbWVz
dGFtcCBvdXRwdXQKClRoZSBvdXRwdXQgb2YgYC4vc21iaW5mbyBmaWxlYmFzaWNpbmZvIC9tbnQv
ZmlsZWAgaXMgYXMgZm9sbG93czoKCiAgQ3JlYXRpb24gVGltZTogMjAyNi0wMS0yNSAxOToxNTow
MS4wNzA3MjkKICBMYXN0IEFjY2VzcyBUaW1lOiAyMDI2LTAxLTI1IDE5OjE1OjAxLjA3MDcyOQog
IExhc3QgV3JpdGUgVGltZTogMjAyNi0wMS0yNSAxOToxNTowMS4wNzA3MjkKICBMYXN0IENoYW5n
ZSBUaW1lOiAyMDI2LTAxLTI1IDE5OjE1OjAxLjA3MDcyOQoKVGhlIG91dHB1dCBvZiBgc3RhdCAv
bW50L2ZpbGVgIGlzIGFzIGZvbGxvd3M6CgogIEFjY2VzczogMjAyNi0wMS0yNSAxOToxNTowMS43
MDcyOTQ2MDAgKzAwMDAKICBNb2RpZnk6IDIwMjYtMDEtMjUgMTk6MTU6MDEuNzA3Mjk0NjAwICsw
MDAwCiAgQ2hhbmdlOiAyMDI2LTAxLTI1IDE5OjE1OjAxLjcwNzI5NDYwMCArMDAwMAogICBCaXJ0
aDogMjAyNi0wMS0yNSAxOToxNTowMS43MDcyOTQ2MDAgKzAwMDAKCkluIGB3aW5fdG9fZGF0ZXRp
bWUoKWAsIHdoZW4gY29udmVydGluZyBgdXNlY2AgdG8gYSB2YWx1ZSBpbiBzZWNvbmRzLApvbmUg
emVybyBuZWVkcyB0byBiZSByZW1vdmVkIGZyb20gdGhlIGRpdmlzb3IuCgpTaWduZWQtb2ZmLWJ5
OiBTYW0gRGVuaXNvbiA8ZGV2QGRlbmlzb25zLm9yZz4KU2lnbmVkLW9mZi1ieTogQ2hlblhpYW9T
b25nIDxjaGVueGlhb3NvbmdAa3lsaW5vcy5jbj4KLS0tCiBzbWJpbmZvIHwgMiArLQogMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvc21i
aW5mbyBiL3NtYmluZm8KaW5kZXggNTdlOGEwYS4uYTE2ODE4NiAxMDA3NTUKLS0tIGEvc21iaW5m
bworKysgYi9zbWJpbmZvCkBAIC00MjgsNyArNDI4LDcgQEAgZGVmIGNtZF9maWxlYWxsaW5mbyhh
cmdzKToKIGRlZiB3aW5fdG9fZGF0ZXRpbWUoc21iMl90aW1lKToKICAgICB1c2VjID0gKHNtYjJf
dGltZSAvIDEwKSAlIDEwMDAwMDAKICAgICBzZWMgID0gKHNtYjJfdGltZSAtIDExNjQ0NDczNjAw
MDAwMDAwMCkgLy8gMTAwMDAwMDAKLSAgICByZXR1cm4gZGF0ZXRpbWUuZGF0ZXRpbWUuZnJvbXRp
bWVzdGFtcChzZWMgKyB1c2VjLzEwMDAwMDAwKQorICAgIHJldHVybiBkYXRldGltZS5kYXRldGlt
ZS5mcm9tdGltZXN0YW1wKHNlYyArIHVzZWMvMTAwMDAwMCkKIAogZGVmIGNtZF9maWxlYmFzaWNp
bmZvKGFyZ3MpOgogICAgIHFpID0gUXVlcnlJbmZvU3RydWN0KGluZm9fdHlwZT0weDEsIGZpbGVf
aW5mb19jbGFzcz00LCBpbnB1dF9idWZmZXJfbGVuZ3RoPTQwKQotLSAKMi40My4wCgo=

--b1=_qD026MqNwTzcz1RtPQA3JwbdbKZsFcvLHZmLmqeeY--

