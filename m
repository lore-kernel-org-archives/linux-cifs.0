Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C10314B73
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790815957; cv=none; b=dCI8LwcE0I9QIBvpxJRc+9KpJXMPiiHHgEMO8Hu5mQtv8ubuUviU8+o2VI5uXfQyqHPBu4ztBWa+6DY05CNFF+wOMAA40Og6IR/XQEZ/eFQc5JQ9Zwjxbvk8dzzfmzD0XmwjJpw2P5imIFTZysfniVeLFziQ2rKO80MPqmYZ9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790815957; c=relaxed/simple;
	bh=nXtWqJBhEwzSKgipfT5D/Z55Mvx+8SSRuHkMxeNKn+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jRaYMVEY5pamNTKJS0WOnquv8nbyeUWV0Xu+sleAqAHdjE7kOFnm+ZJZlR1wfCTS8dIbj887S8QutyoMOrTUA0nPT4GxitC+Rex4Zrmdzlc0yZLn3eBTOvpLxkAClEeWlf+kdAjKMLtJqaWenl3pKGJw2Y6+B7gAY5u37ET3Z0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/4PaAOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/4PaAOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6801F000FF
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790815955;
	bh=+sOEFOrvymLzsg7ddQqfhWsExnZt58LwSILYptE2lxw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l/4PaAOnXvfU3JphZyWH9ADTQomuL+9QpoMyYFrjxTmjdRFvnGGZU8BMlhb4uhOx4
	 2EDMIMXDoK9J3ZjcDguwJAD77BAoxivBnKudM2Fb5Mh5lEziVwm0bJv7Ol36U26nVL
	 dQaWbnF8W9i4VCfBYKR0tkNoXFgRB4TvkYdx2I3wxTHPZim2Jj7dYYphjzFZreNlRC
	 kArWMv2ZXOw5D81EAeKvk8iG+qE/uKLjOuBKA1U9K+0Hk0afEyqcapQA+9W4k9yJ5C
	 OXhqWWnJKpxyLuRPVmRuUXcYgRo2+yFGPJN57fazVLLwQTqcRtNNwKZICyr6s54l+4
	 TC0+hjpvq75Tw==
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e0f2c945eso225642766b.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 17:52:35 -0700 (PDT)
X-Gm-Message-State: AFq9FYIOHDos4JJVmUssDqCKOFSypHe22tt+IFC+xYMa/jyGR6lQMpTY
	G30Y7P/NAeJ/3cLZvUQAzy8BAxP4PZ437kAFcofC3B6SwngAig9SpGZhtnZFhFhSQOsqSHFQTu+
	gO9x2LDhM0P4RB7D1oWEdvMrIERJO3tY=
X-Received: by 2002:a17:907:60d0:b0:c2d:ca32:217a with SMTP id
 a640c23a62f3a-c2e23da3c15mr231157566b.33.1790815954415; Wed, 30 Sep 2026
 17:52:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANTrAmy-2tA9B_mY-hARC5LE_==6m+52Pq1p0EV6fRXgWtyGQg@mail.gmail.com>
In-Reply-To: <CANTrAmy-2tA9B_mY-hARC5LE_==6m+52Pq1p0EV6fRXgWtyGQg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 1 Oct 2026 09:52:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8bQDuC8vdhqN5GtP2LfkNzSBe26R8Ci=DpM_PV_F9N2A@mail.gmail.com>
X-Gm-Features: AclHuK94_R_2dJcb5_gMzOkRtMp7KZxcviHqyPrxJGI6J8q8UvDO_J9iew3lQM4
Message-ID: <CAKYAXd8bQDuC8vdhqN5GtP2LfkNzSBe26R8Ci=DpM_PV_F9N2A@mail.gmail.com>
Subject: Re: pre-auth remote kernel heap info-leak via conn->ops TOCTOU
To: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="000000000000d2822e065cbcd494"

--000000000000d2822e065cbcd494
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 11:27=E2=80=AFPM =EB=A0=88=EB=93=9C=ED=8C=80=ED=95=
=98=EA=B3=A0=EC=8B=B6=EC=96=B4=EC=9A=94 <ihopenre@gmail.com> wrote:
>
> Hi Namjae,
Hi,
>
> I found a TOCTOU race condition in ksmbd that allows an unauthenticated
> remote attacker to leak 23 bytes of kernel heap data per connection.
The patch does not fully eliminate the conn->ops race. A pipelined
SMB2 request can still run with SMB1 ops while the first SMB1 worker
upgrades the connection, leaving the earlier SMB1 request to run with
SMB2 ops. The size check only blocks this specific out-of-bounds read.
It does not prevent dispatch with the wrong protocol ops.

Could you check if an attached patch fixes this issue?

Thanks.

--000000000000d2822e065cbcd494
Content-Type: application/x-patch; 
	name="0001-ksmbd-wait-for-negotiation-before-receiving-another-.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-wait-for-negotiation-before-receiving-another-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_muo1akml0>
X-Attachment-Id: f_muo1akml0

RnJvbSBjNDczZTVkZWE2ZGYzYzhlNGExMGZmYjkyOTMxNGVmMzJmMmZiYzEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBXZWQsIDMwIFNlcCAyMDI2IDIwOjM5OjUzICswOTAwClN1YmplY3Q6IFtQQVRDSF0ga3Nt
YmQ6IHdhaXQgZm9yIG5lZ290aWF0aW9uIGJlZm9yZSByZWNlaXZpbmcgYW5vdGhlciBQRFUKClRo
ZSByZWNlaXZlIHRocmVhZCBxdWV1ZXMgYSByZXF1ZXN0IGFuZCBjYW4gcmVhZCB0aGUgbmV4dCBQ
RFUgYmVmb3JlCnRoZSBuZWdvdGlhdGlvbiB3b3JrZXIgZmluaXNoZXMuIFdoaWxlIG5lZWRfbmVn
IGlzIHNldCwgdGhlIG5leHQgUERVCmNhbiBjYXVzZSBrc21iZF9pbml0X3NtYl9zZXJ2ZXIoKSB0
byByZXBsYWNlIGNvbm4tPm9wcy4gQSBwaXBlbGluZWQKU01CMiByZXF1ZXN0IGNhbiB0aGVyZWZv
cmUgbWFrZSB0aGUgd29ya2VyIGhhbmRsZSBhbiBlYXJsaWVyLCBzaG9ydGVyClNNQjEgcmVxdWVz
dCB3aXRoIFNNQjIgb3BlcmF0aW9ucyBhbmQgcmVhZCBiZXlvbmQgaXRzIGJ1ZmZlci4KCkFuIFNN
QjEgbXVsdGktcHJvdG9jb2wgbmVnb3RpYXRlIG1heSBiZSBmb2xsb3dlZCBieSBhbiBTTUIyIE5F
R09USUFURQp0aGF0IGNoYW5nZXMgY29ubi0+b3BzIGFnYWluLiBXYWl0IGZvciB3b3JrIHF1ZXVl
ZCB3aGlsZSB0aGUgY29ubmVjdGlvbgppcyBuZXcgb3IgbmVlZHMgbmVnb3RpYXRpb24gdG8gY29t
cGxldGUgYmVmb3JlIHJlYWRpbmcgYW5vdGhlciBQRFUuClRoaXMga2VlcHMgdGhlIG9wZXJhdGlv
bnMgc3RhYmxlIGZvciBib3RoIHN0YWdlcyBvZiBuZWdvdGlhdGlvbiB3aXRob3V0CmNoYW5naW5n
IHdoZW4gbmVlZF9uZWcgaXMgY2xlYXJlZC4KCkZpeGVzOiBkYzgyODlmOTEyMzggKCJrc21iZDog
Zml4IHNsYWItb3V0LW9mLWJvdW5kcyBpbiBpbml0X3NtYjJfcnNwX2hkciIpClJlcG9ydGVkLWJ5
OiBpaG9wZW5yZS1lbmcgPGlob3BlbnJlQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogTmFtamFl
IEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4KLS0tCiBmcy9zbWIvc2VydmVyL3NlcnZlci5j
IHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBh
L2ZzL3NtYi9zZXJ2ZXIvc2VydmVyLmMgYi9mcy9zbWIvc2VydmVyL3NlcnZlci5jCmluZGV4IGVi
Mjk1MmYyZGViZS4uMWNiOTk1YTM2YjIxIDEwMDY0NAotLS0gYS9mcy9zbWIvc2VydmVyL3NlcnZl
ci5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvc2VydmVyLmMKQEAgLTM5OCw2ICszOTgsNyBAQCBzdGF0
aWMgdm9pZCBoYW5kbGVfa3NtYmRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndrKQogc3RhdGlj
IGludCBxdWV1ZV9rc21iZF93b3JrKHN0cnVjdCBrc21iZF9jb25uICpjb25uKQogewogCXN0cnVj
dCBrc21iZF93b3JrICp3b3JrOworCWJvb2wgd2FpdF9mb3JfbmVnID0ga3NtYmRfY29ubl9uZXco
Y29ubikgfHwga3NtYmRfY29ubl9uZWVkX25lZ290aWF0ZShjb25uKTsKIAlpbnQgZXJyOwogCiAJ
ZXJyID0ga3NtYmRfaW5pdF9zbWJfc2VydmVyKGNvbm4pOwpAQCAtNDIwLDYgKzQyMSwxMCBAQCBz
dGF0aWMgaW50IHF1ZXVlX2tzbWJkX3dvcmsoc3RydWN0IGtzbWJkX2Nvbm4gKmNvbm4pCiAJY29u
bi0+bGFzdF9hY3RpdmUgPSBqaWZmaWVzOwogCUlOSVRfV09SSygmd29yay0+d29yaywgaGFuZGxl
X2tzbWJkX3dvcmspOwogCWtzbWJkX3F1ZXVlX3dvcmsod29yayk7CisJLyogTmVnb3RpYXRpb24g
Y2FuIGNoYW5nZSBjb25uLT5vcHMsIGZpbmlzaCBpdCBiZWZvcmUgcmVhZGluZyBhbm90aGVyIFBE
VS4gKi8KKwlpZiAod2FpdF9mb3JfbmVnKQorCQl3YWl0X2V2ZW50KGNvbm4tPnJlcV9ydW5uaW5n
X3EsCisJCQkgICBhdG9taWNfcmVhZCgmY29ubi0+cmVxX3J1bm5pbmcpID09IDApOwogCXJldHVy
biAwOwogfQogCi0tIAoyLjI1LjEKCg==
--000000000000d2822e065cbcd494--
