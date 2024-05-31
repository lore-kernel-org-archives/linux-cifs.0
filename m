Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE12225DA
	for <linux-cifs@vger.kernel.org>; Fri, 31 May 2024 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717171443; cv=none; b=CqnHQ2ZmRQmsF3F8tFlYI66pQYM9zKLqFwRDpF0KmaEZ/yggF+2o1JcUI8Byr1gC+Hq5Q5F08cQxRKKAXnxBbNk8Y1AdrQRTruXK2pOuueKMRd2pa4bmbzLlwdsBIDtCE3gsTZtaZV5DI4+3msRmiizF+nd4NJu40zbXuhGWEqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717171443; c=relaxed/simple;
	bh=WiCdpQYYUYTGChiKJOMBiPOWVY7Tx/THaICqizeQrCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BBxGQDWhSxwqYamvYDsVPsGymmpv7EeB8/TcHIaWrM22nJP8StIMEpND/OOdHxg4dPq8c+BHYH5Hgty0bSxlsRSOysxnWSRHfkx773SMBLNWqsHmXsi2YD+3BNJBMbDJZZHrTugs7sNWesXHdUrjDqgX9TZ9UTQDbC4LXrV/jLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtzOsnV/; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtzOsnV/"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52b03d66861so2442731e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 May 2024 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717171439; x=1717776239; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BP3OYmqSISkbA4bGQhMnDyTeGUzuMs6M7GjHy8pkSgQ=;
        b=QtzOsnV/nEisfq5Thl9g5e27wuWhCjqUCGxrK/Wk12gCLUq9wyRMfr5qlqlZNapyPb
         t0V4H+jCzPdvgWwDMvKURCknV3WU5Ky9JGHC4QPcSrBb9aExnO897+8GzbPDVC+Z8jvE
         Fwc1o9N2TTF92ofJfEub5an85iKxEwot3aVWteTVlxYhuxhfUNFAPPZpnzRpYtsCv0dZ
         S4S6QzK1hEAEAN3doARlrs5DTKtSZIHf+Tz+CVF4DTBKzgy+kDyjDEJY4TA1YtRxn7cb
         weU1K6C66+C+Jum0bcBMlbtJbgWj7Oawh7nPN2lmISlD61K0SEUbIDZkNIp7oWkp4QvE
         nV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717171439; x=1717776239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BP3OYmqSISkbA4bGQhMnDyTeGUzuMs6M7GjHy8pkSgQ=;
        b=wKAi/fGHgSWPnunXAAUpEGfqgKH5vC7Yuf+omrY4P68Ll1scARGNgIhh6LoCbHMEit
         yIbLL3qVjsd4s6cQiZzuJMMMlhxFnVhDEIehGG7OlumetnDG5YyjFIe7OxNboR5peeFO
         Fghl+UmN20wZKEYYmemJhS4xkqM0tiTXPMHTt3iIhXgs1ZP/usWrf5VVriIlnrmK9GHy
         tOK06T01WnDT6ZJ9eRONtaIh+gCbRS9SahIqCouVfUQQyoCRu8LtiU55+v8YzVQOw0zx
         Pm+pMI8zVb+EguXKanMaZdRyTOMIMKLDBdJ/DtfWI8olGPxSnz+RcG5+7ElO7QmYZirP
         vRww==
X-Gm-Message-State: AOJu0YwCd1jkRkE2cFoD1hFA4A14fenB1Dc0Qq67lNqYwlJEMb1xLHYa
	lchNRbVsTVIx6VhsfNGvo5kdRS5v7Z0Of+j6lYf1+wE/Fg1Bwz4Xu9jzGLXLRvxc02RNzhYvhr9
	sPx3UJRrs0/KyXg/vq9UVekGy7Fo6kA==
X-Google-Smtp-Source: AGHT+IEneJHoMrGHxvTYa5Z2rh0ZY+SR81TEe4GY84uVDjEohwaYUtLf/yCPq+EvU+zEn8eOav43iTltaRNp6PT79uk=
X-Received: by 2002:a05:6512:702:b0:52b:8543:3ca with SMTP id
 2adb3069b0e04-52b8970be17mr1311005e87.42.1717171439125; Fri, 31 May 2024
 09:03:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvv6GS07jY2W_5zXV3YpcHup7rZghRqmpoeSDndgrkDEA@mail.gmail.com>
In-Reply-To: <CAH2r5mvv6GS07jY2W_5zXV3YpcHup7rZghRqmpoeSDndgrkDEA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 31 May 2024 11:03:47 -0500
Message-ID: <CAH2r5mvtW3ErBD0gp1HdiKpwth3KMbmwPzjauTm15KNgrHqa+g@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix creating sockets when using sfu mount options
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000a5e27d0619c22169"

--000000000000a5e27d0619c22169
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated to remove setting major/minor number for sockets since they
are not relevant (and are not reported by stat command e.g.).

Suggested by Paulo.

On Wed, May 29, 2024 at 6:30=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
>     cifs: fix creating sockets when using sfu mount options
>
>     When running fstest generic/423 with sfu mount option, it
>     was being skipped due to inability to create sockets:
>
>       generic/423  [not run] cifs does not support mknod/mkfifo
>
>     which can also be easily reproduced with their af_unix tool:
>
>       ./src/af_unix /mnt1/socket-two bind: Operation not permitted
>
>     Fix sfu mount option to allow creating and reporting sockets.
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

--000000000000a5e27d0619c22169
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-creating-sockets-when-using-sfu-mount-optio.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-creating-sockets-when-using-sfu-mount-optio.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lwuvht7x0>
X-Attachment-Id: f_lwuvht7x0

RnJvbSAxMzU1NTNhMDY1YTY2OTYxNDg4MDFhNmRkNjc2MTYzODFmYzRjMjI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjkgTWF5IDIwMjQgMTg6MTY6NTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggY3JlYXRpbmcgc29ja2V0cyB3aGVuIHVzaW5nIHNmdSBtb3VudCBvcHRpb25zCgpX
aGVuIHJ1bm5pbmcgZnN0ZXN0IGdlbmVyaWMvNDIzIHdpdGggc2Z1IG1vdW50IG9wdGlvbiwgaXQK
d2FzIGJlaW5nIHNraXBwZWQgZHVlIHRvIGluYWJpbGl0eSB0byBjcmVhdGUgc29ja2V0czoKCiAg
Z2VuZXJpYy80MjMgIFtub3QgcnVuXSBjaWZzIGRvZXMgbm90IHN1cHBvcnQgbWtub2QvbWtmaWZv
Cgp3aGljaCBjYW4gYWxzbyBiZSBlYXNpbHkgcmVwcm9kdWNlZCB3aXRoIHRoZWlyIGFmX3VuaXgg
dG9vbDoKCiAgLi9zcmMvYWZfdW5peCAvbW50MS9zb2NrZXQtdHdvIGJpbmQ6IE9wZXJhdGlvbiBu
b3QgcGVybWl0dGVkCgpGaXggc2Z1IG1vdW50IG9wdGlvbiB0byBhbGxvdyBjcmVhdGluZyBhbmQg
cmVwb3J0aW5nIHNvY2tldHMuCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2Ns
aWVudC9jaWZzcGR1LmggICB8ICAyICstCiBmcy9zbWIvY2xpZW50L2lub2RlLmMgICAgIHwgMTQg
KysrKysrKysrKy0tLS0KIGZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMgfCAgNSArKysrKwogZnMv
c21iL2NsaWVudC9zbWIyb3BzLmMgICB8ICAzICsrKwogZnMvc21iL2NsaWVudC9zbWIycGR1LmMg
ICB8ICAyICstCiA1IGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzcGR1LmggYi9mcy9zbWIvY2xpZW50
L2NpZnNwZHUuaAppbmRleCBjNDZkNDE4YzFjMGMuLmEyMDcyYWI5ZTU4NiAxMDA2NDQKLS0tIGEv
ZnMvc21iL2NsaWVudC9jaWZzcGR1LmgKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzcGR1LmgKQEAg
LTI1NzQsNyArMjU3NCw3IEBAIHR5cGVkZWYgc3RydWN0IHsKIAogCiBzdHJ1Y3Qgd2luX2RldiB7
Ci0JdW5zaWduZWQgY2hhciB0eXBlWzhdOyAvKiBJbnR4Q0hSIG9yIEludHhCTEsgb3IgTG54RklG
TyovCisJdW5zaWduZWQgY2hhciB0eXBlWzhdOyAvKiBJbnR4Q0hSIG9yIEludHhCTEsgb3IgTG54
RklGTyBvciBMbnhTT0NLICovCiAJX19sZTY0IG1ham9yOwogCV9fbGU2NCBtaW5vcjsKIH0gX19h
dHRyaWJ1dGVfXygocGFja2VkKSk7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lub2RlLmMg
Yi9mcy9zbWIvY2xpZW50L2lub2RlLmMKaW5kZXggMjYyNTc2NTczZWI1Li4xYmM0ZGFkN2UyMjQg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L2lu
b2RlLmMKQEAgLTYwNiw2ICs2MDYsMTAgQEAgY2lmc19zZnVfdHlwZShzdHJ1Y3QgY2lmc19mYXR0
ciAqZmF0dHIsIGNvbnN0IGNoYXIgKnBhdGgsCiAJCQkJbW5yID0gbGU2NF90b19jcHUoKihfX2xl
NjQgKikocGJ1ZisxNikpOwogCQkJCWZhdHRyLT5jZl9yZGV2ID0gTUtERVYobWpyLCBtbnIpOwog
CQkJfQorCQl9IGVsc2UgaWYgKG1lbWNtcCgiTG54U09DSyIsIHBidWYsIDgpID09IDApIHsKKwkJ
CWNpZnNfZGJnKEZZSSwgIlNvY2tldFxuIik7CisJCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGU09D
SzsKKwkJCWZhdHRyLT5jZl9kdHlwZSA9IERUX1NPQ0s7CiAJCX0gZWxzZSBpZiAobWVtY21wKCJJ
bnR4TE5LIiwgcGJ1ZiwgNykgPT0gMCkgewogCQkJY2lmc19kYmcoRllJLCAiU3ltbGlua1xuIik7
CiAJCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGTE5LOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVu
dC9zbWIyb3BzLmMgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwppbmRleCA0Y2U2YzMxMjFhN2Uu
LmM4ZTUzNjU0MDg5NSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKKysrIGIv
ZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKQEAgLTQ5OTcsNiArNDk5Nyw5IEBAIHN0YXRpYyBpbnQg
X19jaWZzX3NmdV9tYWtlX25vZGUodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGlub2RlICppbm9k
ZSwKIAkJcGRldi5tYWpvciA9IGNwdV90b19sZTY0KE1BSk9SKGRldikpOwogCQlwZGV2Lm1pbm9y
ID0gY3B1X3RvX2xlNjQoTUlOT1IoZGV2KSk7CiAJCWJyZWFrOworCWNhc2UgU19JRlNPQ0s6CisJ
CXN0cnNjcHkocGRldi50eXBlLCAiTG54U09DSyIpOworCQlicmVhazsKIAljYXNlIFNfSUZJRk86
CiAJCXN0cnNjcHkocGRldi50eXBlLCAiTG54RklGTyIpOwogCQlicmVhazsKCg==
--000000000000a5e27d0619c22169--
