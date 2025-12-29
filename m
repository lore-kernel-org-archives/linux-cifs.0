Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B73823182D
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030127; cv=none; b=qT7ekjQNgDzun6wHed/v5wGYreEq2bINLWRItclbEbCpF3Nb/x7tfW1GoVDguGU3En96LB9LzBH2jZbrRt5vwdtbFjUHYG9RcVtR+hGo8jLYUH0wEBFNZSMB2acaTonxqSslEl/Wwqs149f7ill1Uf8B5Dm57jex5q9doK3cDtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030127; c=relaxed/simple;
	bh=5Pi5NSOcEf2nB9BdFdQypcpflBTRYolgdeeZ3iT8Omk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=MOBCtZ1pQwgeLAvu3aknA35MOj0Mhoxw3G/De46qmrniYhFrNrpvZ84yg4x7tfoGdnT1gszxbkXAiLchH7AECKsfcy7vHtntgjrkFEX+V4Ac6dKZKhgQBnqZHETJQMGf6G15rFFAPAxC3mQSCpOPV7K982CFyFVLrxAiN3Y/CJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDRB1fLb; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDRB1fLb"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88fdac49a85so63507776d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 09:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767030124; x=1767634924; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrKl52JlksvEIcIFuiJ7Ow4OKF8FM9/WcP4vXfmxSJ0=;
        b=EDRB1fLb1xmfYXjlIvTbeHMdaPtmBo5nzQMNUFhth9cNC62GgKeo4JR0KhNN2Xy71P
         zAsdjvmTsxiOJTwxXAeUL+I9xchlbo/3VTTJ6iEMlPzs07EXbUNY86dLFpuSYsWordEv
         BsUxGI4RYukstJ/JBQxaAYOTfYN9trQxaVM9ZsyZTPdm8RLGEJIZpZ4xQoxTUUJHR0JG
         01TvJn78DubGG5tM2obtK6N9M2XO/pIZ4LF2bUfDYUn1vPV23UiCgjPQ/bcmRN9adb2b
         78Pjxzpg3QZjU/OBAsYsJle3uNbyehcNpOa9I7fEfflgGMJAHGclhRNJczdgptyUvnKI
         nh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030124; x=1767634924;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrKl52JlksvEIcIFuiJ7Ow4OKF8FM9/WcP4vXfmxSJ0=;
        b=e1od3AbylZIHA0iuN27mbKRXhmsLRBWolWkFi/mC2NnXJmC5HuTvbvZWRsmiATAeR/
         sDZM9SlhG8KpCITtLVKdY3Btapa5VL3C8HkQEFW20bil8VZfa2dRi0O9cDgPpSGw3RHq
         KlzHamcUatLjM2GsPvUkMRZp6jXWgrR76WIzStG0dNSFhQnnL//l/7ATZLFjZmhB7nIm
         vMSZ7uIaqSvvie5OPo4uUWZnN/M9uqoeM9Mx5vdAmHbn9VSrLFeVXEadGVbAVVVmWmoP
         8tNuJ7Bf+qHB7VQbAUlavFZOPTbOcH/XWBWpLH6tTH/4jAoFGZCbCn7OofnX4oEQAQhF
         861Q==
X-Gm-Message-State: AOJu0Yy4gTPPzMyuWK8b0LZPegzW3wc5uO/Gy0ysXrlKrNel0OXCsdRC
	vHAlhQ7CEkx7cSPwY3MW8sMngZsEMZDqoYFaRILyH5d17YMRPGb2HSNmEYS8f0SfQdq7qnu8yF1
	T8ZyWSf65uy9NDMx6npPnLhQS4t4K9A8Jrw==
X-Gm-Gg: AY/fxX5BmKrDWTa9CryZCrr5Pz7s162OBgeST+OybO+2A/J/SbqRSXyo4/7+zuiW7tf
	PF63sasgh9YJDuH2TCIyLLf52Q16OK3lWB4Q9lK0Md2msX6Nhvr/XoTDASWgmvKtYOWb87B7Xi3
	RVCHvYoZICBmFcgDsKHM5yLsspSHf0XfgZn9l6I4RY3LQvD5SLlsCgIAsRwP8yXYBP2brbUm2AE
	T5XbXIHpmezZod4iBSt8ld6Fkm+yEr9tXTLXFj4jAGK5mU0g7fgidQH9eQY60rLTBtQlRojJHNC
	UgTz97Qly6MjXy6uIdIZWcx4it1LKcgWPPVKzy1gi3F0c+OGX2lkPNANnd3M53OI02afi7NeDKJ
	NtUyziuhMmJG742c21pSNkTKdSqQP5GyNAlxzKGwLB1DLSfvW9svuvWSbD/kcCuYD
X-Google-Smtp-Source: AGHT+IGDXyN/pdArpROL5V2KWZWp5yffqQpPGp7Ycvn2c8u7b6ZNBrrJvdpu7/JCJoAUpmfVRkgyEdKRZijxD/tgJTE=
X-Received: by 2002:a05:6214:b28:b0:88a:2360:7f15 with SMTP id
 6a1803df08f44-88d851fdae6mr322970976d6.12.1767030123576; Mon, 29 Dec 2025
 09:42:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvKO3oSX+PtgLfYjRGd70HpGWdeh_Q+FX8b6qALY7s2zw@mail.gmail.com>
In-Reply-To: <CAH2r5mvKO3oSX+PtgLfYjRGd70HpGWdeh_Q+FX8b6qALY7s2zw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Dec 2025 11:41:51 -0600
X-Gm-Features: AQt7F2rh7RsRfbnbOzDbQxBqTp26tXhYB0ghlEgnvYvStdkU-Y6cdipPgTMHJVo
Message-ID: <CAH2r5msC4AkhcH+pZAU3kyAVLgbuSO-Bnf3RoXDt61sTb6p6Ag@mail.gmail.com>
Subject: Re: [PATCH v2] smb3 client: add missing tracepoint for unsupported ioctls
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d333cf06471ac2e6"

--000000000000d333cf06471ac2e6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

v3 attached.  Minor change to remove a few lines of code from v2.


On Mon, Dec 29, 2025 at 10:27=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> In v2 added missing null check
>
> In debugging a recent problem with an xfstest, noticed that we weren't
> tracing cases where the ioctl was not supported.  Add dynamic tracepoint:
>     "trace-cmd record -e smb3_unsupported_ioctl"
> and then after running an app which calls unsupported ioctl,
> "trace-cmd show"would display e.g.
>       xfs_io-7289    [012] .....  1205.137765: smb3_unsupported_ioctl:
> xid=3D19 fid=3D0x4535bb84 ioctl cmd=3D0x801c581f
>
> See attached
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000d333cf06471ac2e6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mjrg3kvx0>
X-Attachment-Id: f_mjrg3kvx0

RnJvbSAzYWI3ZTdkNjUxNjJmMGMxNTNkZmU0MTgzOWEwNWFmYzJhZmU0NjAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjkgRGVjIDIwMjUgMTA6MjM6MTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzIGNsaWVudDogYWRkIG1pc3NpbmcgdHJhY2Vwb2ludCBmb3IgdW5zdXBwb3J0ZWQgaW9jdGxz
CgpJbiBkZWJ1Z2dpbmcgYSByZWNlbnQgcHJvYmxlbSB3aXRoIGFuIHhmc3Rlc3QsIG5vdGljZWQg
dGhhdCB3ZSB3ZXJlbid0CnRyYWNpbmcgY2FzZXMgd2hlcmUgdGhlIGlvY3RsIHdhcyBub3Qgc3Vw
cG9ydGVkLiAgQWRkIGR5bmFtaWMgdHJhY2Vwb2ludDoKICAgICJ0cmFjZS1jbWQgcmVjb3JkIC1l
IHNtYjNfdW5zdXBwb3J0ZWRfaW9jdGwiCmFuZCB0aGVuIGFmdGVyIHJ1bm5pbmcgYW4gYXBwIHdo
aWNoIGNhbGxzIHVuc3VwcG9ydGVkIGlvY3RsLAoidHJhY2UtY21kIHNob3cid291bGQgZGlzcGxh
eSBlLmcuCiAgICAgIHhmc19pby03Mjg5ICAgIFswMTJdIC4uLi4uICAxMjA1LjEzNzc2NTogc21i
M191bnN1cHBvcnRlZF9pb2N0bDogeGlkPTE5IGZpZD0weDQ1MzViYjg0IGlvY3RsIGNtZD0weDgw
MWM1ODFmCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9pb2N0bC5jIHwgMyArKysKIGZzL3NtYi9jbGllbnQvdHJh
Y2UuaCB8IDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L2lvY3RsLmMgYi9mcy9zbWIvY2xpZW50L2lvY3RsLmMKaW5kZXggMGE5
OTM1Y2UwNWE1Li5hODIwYmU1NDdkZDIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW9jdGwu
YworKysgYi9mcy9zbWIvY2xpZW50L2lvY3RsLmMKQEAgLTU4OCw2ICs1ODgsOSBAQCBsb25nIGNp
ZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWdu
ZWQgbG9uZyBhcmcpCiAJCQlicmVhazsKIAkJZGVmYXVsdDoKIAkJCWNpZnNfZGJnKEZZSSwgInVu
c3VwcG9ydGVkIGlvY3RsXG4iKTsKKwkJCXRyYWNlX3NtYjNfdW5zdXBwb3J0ZWRfaW9jdGwoeGlk
LAorCQkJCXBTTUJmaWxlID8gcFNNQkZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCA6IDAsCisJCQkJ
Y29tbWFuZCk7CiAJCQlicmVhazsKIAl9CiBjaWZzX2lvY19leGl0OgpkaWZmIC0tZ2l0IGEvZnMv
c21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCmluZGV4IGIwZmJjMmRm
NjQyZS4uYTU4NGE3NzQzMTEzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3RyYWNlLmgKKysr
IGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC0xNTc5LDYgKzE1NzksNyBAQCBERUZJTkVfRVZF
TlQoc21iM19pb2N0bF9jbGFzcywgc21iM18jI25hbWUsICBcCiAJVFBfQVJHUyh4aWQsIGZpZCwg
Y29tbWFuZCkpCiAKIERFRklORV9TTUIzX0lPQ1RMX0VWRU5UKGlvY3RsKTsKK0RFRklORV9TTUIz
X0lPQ1RMX0VWRU5UKHVuc3VwcG9ydGVkX2lvY3RsKTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhz
bWIzX3NodXRkb3duX2NsYXNzLAogCVRQX1BST1RPKF9fdTMyIGZsYWdzLAotLSAKMi41MS4wCgo=
--000000000000d333cf06471ac2e6--
