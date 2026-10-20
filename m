Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792460828;
	b=DHXx9X1d6hIuk67Z5Vhn+JPaUT2qwKjhaSGD6EVHggJrQePjY62P2k/fzc9L8Q77AEm6
	 QasF+5ZNbrNM+EU7aIBbpmi+Yy+0loJbHTGsX74KMTGKcYE3VORFeA/pY+0H6DDN6lATo
	 URvUkRD6yi2Gck1KC+3BbQBpvjv6NSeJ29bIxgV7qg9MbJyfyLTLPT1EHa9CoTIGaHraI
	 bDLEr8cBMzX8bjnrafwByiRl/871785haijYs00LBUBAjzurW+a6rAqbJTjmyWlm0/Ik6
	 IADqvc3KCGOZHZ5r6xFgepXlxO4r8SKK9bPjSvmtEnZ1lgmOLkC3Vs3DNcQU+HXG53Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792460828;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=36aiT4SCiJW1oC+ypktSbMwxV9Bu9o1ziS132CV1Ul0=;
	b=K8yG9ASnVBnuZc7KyB2nPOjNqPTf/eFVa0wG4mAU2P5WoFmys4jXPnTf3alqrDXCN6mk
	 hpPJfmyq8tVXlWWqz64Cs2hXh99neXSeaOId57/x+Pjh7E3tO61CGH35mp892TMtSXd1/
	 913lVwSvbPYUkkpjbCKpxOG/NBZlfgUiw2kik2bOUCxLskLgG9hDnhlFN4btGKFiEhiXT
	 JkQBbCt1O5JNYYL+eBCT/nso2Iex62LNGNHItvKqBrrE5qzTB+4fA7ScZDCsUG50IZAiK
	 JEGyJIR+blJd22cB2hkZ0gBiGvqh3/M7YGaHszr1FA/cdQzJ9A9SZGIeXUhG1blG8RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhEJWdXe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3440606A319
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhEJWdXe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFBF1F000C6
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 01:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792460827;
	bh=36aiT4SCiJW1oC+ypktSbMwxV9Bu9o1ziS132CV1Ul0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nhEJWdXeolRSp+v+VXzqalxWMoqCThAifAqyHbbpcUuwpO9YfmGm8RNZV9CfcL0yz
	 EN6wKRBKzeVNnlJeW8a+D40glUuqYSsxPskzeL9mTnTRcI/G2dpNcvpoB1jPmV+mIW
	 5xE2BHMV86FqW1JOuoh1ORXiczN8FCuKM6gY5J+KQrcFSwZ30eOisG0AGeTMbt94OS
	 Olw8432zHhz3pB4LZ6XdS2EVCMz8JkfNmlublqiowrJDrdkFFvdEO/PRVDAGdInzYD
	 tz/Ltjnj+jDSW9kzmAsZwFZ3nITHMYIecEXy8x9FVJSeDhK8ueiDhaLEEPwJP0pTY9
	 8COOio9kSE1HQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c445c95d553so188924766b.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 18:47:07 -0700 (PDT)
X-Gm-Message-State: AFq9FYIQHDaRCozQYPa3eyBa979xJsFPMd2HF9a0rd3dAGUYVGktQm1a
	O6fz82LKaYLPwP0ioB0O0kbh6u1v25oA50o3qAIkhDpg8osXanSuTEyc+tQpUwL6ORI17ao1vsS
	5hA4kJxY4EKkM8bfjOkwKonSpnHqIfVc=
X-Received: by 2002:a17:907:d307:b0:c39:34ba:2f6b with SMTP id
 a640c23a62f3a-c419e836de6mr677187766b.26.1792460826446; Mon, 19 Oct 2026
 18:47:06 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD37_9gGnApAuagqOuZ13WB=DW8c_ZpWFBX4cE00YtGhmE2PbQ@mail.gmail.com>
In-Reply-To: <CAD37_9gGnApAuagqOuZ13WB=DW8c_ZpWFBX4cE00YtGhmE2PbQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Oct 2026 10:46:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FXeaK2GBRgskkTNBXVjJc92qNDP0S_39u=Eb19h1rBw@mail.gmail.com>
X-Gm-Features: AclHuK9tQfR87KJWXqOG0KkUxMGFh-fwO9eNBnU_-v8HNVuoE02EkN_BRnR1Yhs
Message-ID: <CAKYAXd_FXeaK2GBRgskkTNBXVjJc92qNDP0S_39u=Eb19h1rBw@mail.gmail.com>
Subject: Re: [Bug report] ksmbd: fd_limit leaks a slot per durable-handle
 reconnect -> cross-user open DoS
To: Mohammed <mohammed.saad.alquraini@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000d5d2c4065e3bce90"

--000000000000d5d2c4065e3bce90
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 8:48=E2=80=AFAM Mohammed
<mohammed.saad.alquraini@gmail.com> wrote:
>
> Hello Namjae,
Hi Mohammed,

>
> ksmbd's global open-file counter (fd_limit) leaks one slot per durable-ha=
ndle
> reconnect, so an authenticated user can exhaust the server-wide budget an=
d deny
> other users' opens. Validated end-to-end on an unmodified kernel; every n=
umber
> below is measured. Found with an LLM-assisted code-analysis pipeline (dis=
closed
> up front per security-bugs.rst). Low severity -- it needs a non-default c=
onfig
> and the cap is already soft (see caveat), so this is a regular bug for th=
e
> public list, not a security@ case.
Can you check if an attached patch fixes this issue ?
Thanks for the report.

--000000000000d5d2c4065e3bce90
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-fix-fd_limit-accounting-across-durable-reconne.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-fix-fd_limit-accounting-across-durable-reconne.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvg0uzzg0>
X-Attachment-Id: f_mvg0uzzg0

RnJvbSA0NTRhZThlNWMzMDZlNWRkYWU3MDQ2ZTViM2JkMWQwZjg2NDNlNGQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBUdWUsIDIwIE9jdCAyMDI2IDEwOjE5OjE5ICswOTAwClN1YmplY3Q6IFtQQVRDSF0ga3Nt
YmQ6IGZpeCBmZF9saW1pdCBhY2NvdW50aW5nIGFjcm9zcyBkdXJhYmxlIHJlY29ubmVjdHMKCkEg
ZGlzY29ubmVjdGVkIGR1cmFibGUgaGFuZGxlIGtlZXBzIGl0cyBrc21iZF9maWxlIGFuZCB0aGUg
ZmRfbGltaXQKcmVzZXJ2YXRpb24gdGFrZW4gYXQgaXRzIGluaXRpYWwgb3Blbi4gUmVjb25uZWN0
aW5nIGFsbG9jYXRlcyBhbm90aGVyCnZvbGF0aWxlIElEIGFuZCB0YWtlcyBhbm90aGVyIHJlc2Vy
dmF0aW9uIGZvciB0aGUgc2FtZSBmaWxlLiBGaW5hbCBjbG9zZQpyZXR1cm5zIG9ubHkgb25lIHJl
c2VydmF0aW9uLCBzbyByZXBlYXRlZCByZWNvbm5lY3RzIHBlcm1hbmVudGx5IHJlZHVjZQp0aGUg
c2VydmVyLXdpZGUgb3Blbi1maWxlIGJ1ZGdldC4KCk1vdmUgcmVzZXJ2YXRpb24gaW50byBrc21i
ZF9vcGVuX2ZkKCkgYW5kIHJlbGVhc2UgaXQgb24gZXZlcnkgY3JlYXRpb24KZmFpbHVyZS4gS2Vl
cCB0aGUgcmVzZXJ2YXRpb24gdW50aWwgZmluYWwgY2xvc2UsIGluY2x1ZGluZyB3aGlsZSBhIGR1
cmFibGUKaGFuZGxlIGlzIGRpc2Nvbm5lY3RlZC4gTWFrZSBJRCBhbGxvY2F0aW9uIGluZGVwZW5k
ZW50IG9mIGZkX2xpbWl0IHNvCnJlY29ubmVjdHMgbmVpdGhlciBjb25zdW1lIG5vciByZXR1cm4g
c2xvdHMuIFRoaXMgYWxzbyBhdm9pZHMgcmV0dXJuaW5nIGFuCnVucmVzZXJ2ZWQgc2xvdCB3aGVu
IHBlcnNpc3RlbnQgSUQgYWxsb2NhdGlvbiBmYWlscy4KCk5ldyBvcGVucyBjb250aW51ZSB0byBy
ZXR1cm4gLUVNRklMRSB3aGVuIHRoZSBidWRnZXQgaXMgZXhoYXVzdGVkLCBrZWVwaW5nCnRoZSBl
eGlzdGluZyBTVEFUVVNfSU5TVUZGSUNJRU5UX1JFU09VUkNFUyBtYXBwaW5nLgoKRml4ZXM6IGM4
ZWZjYzc4NjE0NiAoImtzbWJkOiBhZGQgc3VwcG9ydCBmb3IgZHVyYWJsZSBoYW5kbGVzIHYxL3Yy
IikKUmVwb3J0ZWQtYnk6IE1vaGFtbWVkIDxtb2hhbW1lZC5zYWFkLmFscXVyYWluaUBnbWFpbC5j
b20+ClNpZ25lZC1vZmYtYnk6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+Ci0t
LQogZnMvc21iL3NlcnZlci92ZnNfY2FjaGUuYyB8IDE1ICsrKysrKysrLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9zbWIvc2VydmVyL3Zmc19jYWNoZS5jIGIvZnMvc21iL3NlcnZlci92ZnNfY2FjaGUuYwppbmRl
eCAzNWMzNTYzOGRjY2MuLmJmYTI4ZWYxOTdmNiAxMDA2NDQKLS0tIGEvZnMvc21iL3NlcnZlci92
ZnNfY2FjaGUuYworKysgYi9mcy9zbWIvc2VydmVyL3Zmc19jYWNoZS5jCkBAIC0xNDQ2LDExICsx
NDQ2LDYgQEAgc3RhdGljIGludCBfX29wZW5faWQoc3RydWN0IGtzbWJkX2ZpbGVfdGFibGUgKmZ0
LCBzdHJ1Y3Qga3NtYmRfZmlsZSAqZnAsCiAJdTY0CQkJaWQgPSAwOwogCWludAkJCXJldDsKIAot
CWlmICh0eXBlID09IE9QRU5fSURfVFlQRV9WT0xBVElMRV9JRCAmJiBmZF9saW1pdF9kZXBsZXRl
ZCgpKSB7Ci0JCV9fb3Blbl9pZF9zZXQoZnAsIEtTTUJEX05PX0ZJRCwgdHlwZSk7Ci0JCXJldHVy
biAtRU1GSUxFOwotCX0KLQogCWlkcl9wcmVsb2FkKEtTTUJEX0RFRkFVTFRfR0ZQKTsKIAl3cml0
ZV9sb2NrKCZmdC0+bG9jayk7CiAJcmV0ID0gaWRyX2FsbG9jX2N5Y2xpYyhmdC0+aWRyLCBmcCwg
S1NNQkRfU1RBUlRfRklELCBJTlRfTUFYIC0gMSwKQEAgLTE0NjAsNyArMTQ1NSw2IEBAIHN0YXRp
YyBpbnQgX19vcGVuX2lkKHN0cnVjdCBrc21iZF9maWxlX3RhYmxlICpmdCwgc3RydWN0IGtzbWJk
X2ZpbGUgKmZwLAogCQlyZXQgPSAwOwogCX0gZWxzZSB7CiAJCWlkID0gS1NNQkRfTk9fRklEOwot
CQlmZF9saW1pdF9jbG9zZSgpOwogCX0KIAogCV9fb3Blbl9pZF9zZXQoZnAsIGlkLCB0eXBlKTsK
QEAgLTE0ODAsMTAgKzE0NzQsMTUgQEAgc3RydWN0IGtzbWJkX2ZpbGUgKmtzbWJkX29wZW5fZmQo
c3RydWN0IGtzbWJkX3dvcmsgKndvcmssIHN0cnVjdCBmaWxlICpmaWxwKQogCXN0cnVjdCBrc21i
ZF9maWxlICpmcDsKIAlpbnQgcmV0OwogCisJLyogRHVyYWJsZSByZWNvbm5lY3RzIHJldXNlIHRo
ZSBzbG90IGhlbGQgZm9yIHRoZSBsaWZldGltZSBvZiBmcC4gKi8KKwlpZiAoZmRfbGltaXRfZGVw
bGV0ZWQoKSkKKwkJcmV0dXJuIEVSUl9QVFIoLUVNRklMRSk7CisKIAlmcCA9IGttZW1fY2FjaGVf
emFsbG9jKGZpbHBfY2FjaGUsIEtTTUJEX0RFRkFVTFRfR0ZQKTsKIAlpZiAoIWZwKSB7CiAJCXBy
X2VycigiRmFpbGVkIHRvIGFsbG9jYXRlIG1lbW9yeVxuIik7Ci0JCXJldHVybiBFUlJfUFRSKC1F
Tk9NRU0pOworCQlyZXQgPSAtRU5PTUVNOworCQlnb3RvIGVycl9mZF9saW1pdDsKIAl9CiAKIAlJ
TklUX0xJU1RfSEVBRCgmZnAtPmJsb2NrZWRfd29ya3MpOwpAQCAtMTUyOSw2ICsxNTI4LDggQEAg
c3RydWN0IGtzbWJkX2ZpbGUgKmtzbWJkX29wZW5fZmQoc3RydWN0IGtzbWJkX3dvcmsgKndvcmss
IHN0cnVjdCBmaWxlICpmaWxwKQogCWtzbWJkX2Nvbm5fcHV0KGZwLT5jb25uKTsKIAlrc21iZF9z
aGFyZV9jb25maWdfcHV0KGZwLT5zaGFyZV9jb25mKTsKIAlrbWVtX2NhY2hlX2ZyZWUoZmlscF9j
YWNoZSwgZnApOworZXJyX2ZkX2xpbWl0OgorCWZkX2xpbWl0X2Nsb3NlKCk7CiAJcmV0dXJuIEVS
Ul9QVFIocmV0KTsKIH0KIAotLSAKMi4yNS4xCgo=
--000000000000d5d2c4065e3bce90--
