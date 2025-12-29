Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAB61E98E3
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767030593; cv=none; b=G02TbIvK3RUXOYQhXOZ9eZF58cQ2iEqwYa44uoID21SmXNYjPXxVOQ31WZMe0ro21gThuShbhNEMycZG2/zFyH4KlB61Tp9g0BBMCGj0ZUIIiUtrMrgC4AYPc9BBK+znj3CQfpp5dkwXoF0tHjTu2oEPS4xJLNRkSOpNJxwGB3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767030593; c=relaxed/simple;
	bh=h1LYwe/ou0z1Cv9cTfwr4kHyWTnliyye8wV+LxmTFS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=We98JUkRnIhDawT0bMom3rYRuc0k4xwqP6hVP9nZ/KK6EewXPmPGl8cmcrWBBmFyNPxXGYh8SWeIVM+Yb3Ler1T/IMRWJYTuQHf5sQCFabR5wSYgjEPrkILqvPintzCBkCWI0K37GGaLm9hL+fmXUZwrTQS6jY6UtgfDBEg25/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e+boLafD; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+boLafD"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8885b3c06caso148352966d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 09:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767030590; x=1767635390; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DHHRu/RWWOtstcwucmwR9ZUnRlT4NfKwNAx7jFKEfQY=;
        b=e+boLafDb1DB2RV0wM1aVwWfsNjxCrntq153c5jrxho7sIKRHPrTcv4k3kzV/0B9j2
         DEtz5tB7QBMmGzsZJX/sakRxvbL0zL5L/5h1c70z8ddvHMTR2dL2HsfPPn8mH97K4Uyc
         ngPPiocUC4T8IyoiakF+utloJDHHveNrdiMg8lgo0LWNLPxczDWMZLf9GjpbKVxSZ3tO
         JEPO1hOPqDbrW93GbLGwb/Te06ifg8vWrxt1SxoLEWguTJ3+Y4eoHwZi1xLEPg65IRq2
         6mZtdoewK1SLj2xa5LHyrAY+XzhElVhglP8y+J56/WGUGSNi3bcwFc61IDSjKo0y6MNd
         npIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767030590; x=1767635390;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DHHRu/RWWOtstcwucmwR9ZUnRlT4NfKwNAx7jFKEfQY=;
        b=fPrkVoSPgwVf7OMTuRqdLrRksApNjZSr6ooy6Xn6xmSMpDYRXi+70nex8IvYOycihS
         QpO0g487IQhAb7a0qw5cgBwrQHwbUL0vsi7JBxrCmO39P+racejnYfmGPVxjwd+K1lee
         M7NgJas9WAg18zx5Kb5t/7cFCsDa3WhcvdCz7HX159sCwfxnlXDgh53n6gaxSwL3XC/3
         5xLNPCUukuEwwB7SXs20A+imazisEkiHNfSAb+CSgwEEnw5mo4Ecthh1ol8wrsGQe0XO
         GotgRBcz8JacdqVVspfK86BTimyw4ujZBgXgd69cVovxgdHvN7U2forcxG0lpcEedvdE
         3PbQ==
X-Gm-Message-State: AOJu0Ywsr5KO3iqFRKVRFPiewpGaor+KYQ0EH6pzVr+iojSD4oLRc1/O
	UVbPbx9V6sNVQ05+NSP1WS7yuwpCfJGkVjRc2EKr8fVuoHbApV/abnp00tUkvZw1xiHRdzlbRUa
	uiJnBwyxpt01qq9vaPK09AvdruiO7x2/CZw==
X-Gm-Gg: AY/fxX7K2+D5RDuKYiMCd5rSIuoqmeuIDn5tVgdv2jVvjukY/mo7u2Q98UKUXjJEAXW
	jdR1YJ6V+H/3ZxDCzpsqvT634mRN6Fqg7TxWt1dmIXFEC8KGVYRR/VRdXgfnyNUY+nxhh0LZGVe
	DWBDh9MIXLXRsClZ0zuZI2r6S88OYqYNxNGM62OapVkO1dftnFtS0wAec6z43soCt8A7WynLvBo
	fWBcMiQljg9qr5YGlCMzoetpqpI0w5V5NSXstp6tJK3SDSz5qWLGJ4yHtSpn9eNpeabRryyGHtw
	tt2KaMjm1Zg1dCKdzkkyURrgMaS+IdNRP1NNjWCpulQKpmirNQ0OJj7rU4UKWP3ybQLWAhv/+xR
	LvQjRpFOR7gkdAwICX31P9GDI0KNUhk5/9GQE6jTnqQ6yvEc8BnYThBNtAShHEWTU
X-Google-Smtp-Source: AGHT+IEH+Tdt41/ND/bRWXMiblJC1+ZL7aFgON4igHB2UtBIzxmuRMXmR4EBc+GFSTg6vmdod9xe3o+5qlB0iMbf+Hs=
X-Received: by 2002:a05:6214:28e:b0:888:4930:797e with SMTP id
 6a1803df08f44-88d881bb2efmr373111506d6.70.1767030590309; Mon, 29 Dec 2025
 09:49:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvKO3oSX+PtgLfYjRGd70HpGWdeh_Q+FX8b6qALY7s2zw@mail.gmail.com>
 <CAH2r5msC4AkhcH+pZAU3kyAVLgbuSO-Bnf3RoXDt61sTb6p6Ag@mail.gmail.com>
In-Reply-To: <CAH2r5msC4AkhcH+pZAU3kyAVLgbuSO-Bnf3RoXDt61sTb6p6Ag@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Dec 2025 11:49:38 -0600
X-Gm-Features: AQt7F2p1gZga-_J-69wAIBX9CYf8PpLQACEjVGGq6mBj3bILTq37fB0NYC1USWg
Message-ID: <CAH2r5mvrt_zUkBd5mjqc7Yt+bo71D6bNxY3eU_ewsUvL0pa1AA@mail.gmail.com>
Subject: Re: [PATCH v2] smb3 client: add missing tracepoint for unsupported ioctls
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a54deb06471ade78"

--000000000000a54deb06471ade78
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ugh - had a typo.  v4 attached.

On Mon, Dec 29, 2025 at 11:41=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> v3 attached.  Minor change to remove a few lines of code from v2.
>
>
> On Mon, Dec 29, 2025 at 10:27=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > In v2 added missing null check
> >
> > In debugging a recent problem with an xfstest, noticed that we weren't
> > tracing cases where the ioctl was not supported.  Add dynamic tracepoin=
t:
> >     "trace-cmd record -e smb3_unsupported_ioctl"
> > and then after running an app which calls unsupported ioctl,
> > "trace-cmd show"would display e.g.
> >       xfs_io-7289    [012] .....  1205.137765: smb3_unsupported_ioctl:
> > xid=3D19 fid=3D0x4535bb84 ioctl cmd=3D0x801c581f
> >
> > See attached
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000a54deb06471ade78
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mjrgdrep0>
X-Attachment-Id: f_mjrgdrep0

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
LAorCQkJCXBTTUJGaWxlID8gcFNNQkZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCA6IDAsCisJCQkJ
Y29tbWFuZCk7CiAJCQlicmVhazsKIAl9CiBjaWZzX2lvY19leGl0OgpkaWZmIC0tZ2l0IGEvZnMv
c21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCmluZGV4IGIwZmJjMmRm
NjQyZS4uYTU4NGE3NzQzMTEzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3RyYWNlLmgKKysr
IGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC0xNTc5LDYgKzE1NzksNyBAQCBERUZJTkVfRVZF
TlQoc21iM19pb2N0bF9jbGFzcywgc21iM18jI25hbWUsICBcCiAJVFBfQVJHUyh4aWQsIGZpZCwg
Y29tbWFuZCkpCiAKIERFRklORV9TTUIzX0lPQ1RMX0VWRU5UKGlvY3RsKTsKK0RFRklORV9TTUIz
X0lPQ1RMX0VWRU5UKHVuc3VwcG9ydGVkX2lvY3RsKTsKIAogREVDTEFSRV9FVkVOVF9DTEFTUyhz
bWIzX3NodXRkb3duX2NsYXNzLAogCVRQX1BST1RPKF9fdTMyIGZsYWdzLAotLSAKMi41MS4wCgo=
--000000000000a54deb06471ade78--
