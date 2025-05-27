Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E0C10A1E
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748314666; cv=none; b=UiQR12/M7n5kB0n8r1iLSMKgBZBdwAUL5Xoz4LBky7ua8bXjGzWN/JulVay+hhUpgNZ50TSLmlsZxtj0WElIQjMY22Dd/TKuh6NIxpMYkSkltn3JNncPGFp7wdKOoeMoBOI0lfftaod7mjK/ATRZx61ZxO16PVm6dmOSHPab02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748314666; c=relaxed/simple;
	bh=agPkYkrf1ZYLH6z1atCc+qIVkXnstmf3ylfkWtcJ0f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K6PrerZarWu7BuTz5t3AgzdtC7WtGxmv8zIbEzu6e082tqX2Q1Z7xSIz1UtOd/MnJWkLyQz25dS6J6dbsklfWDCbnod/b5ah3J6mjwr2OCMUDXg9HFoOHNNTvjD52Ie48xO7xNj3W0L1VO+rcHuSWb7yDNMYdoEWhYJo8WaMfm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCyiDutV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCyiDutV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8ABC4CEEF
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 02:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748314666;
	bh=agPkYkrf1ZYLH6z1atCc+qIVkXnstmf3ylfkWtcJ0f0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aCyiDutVwJ6zMKV17lIhrxMAIqGmPccDYD0OzTuanSAohyDuufmaYZg+h3yVp3bUw
	 VcJSDCN1WJ+jloxqmksJnAxetHPduPB9ydImaibHwDZND8Xt7iWN8VL+Q7tbyB+HHd
	 zsPQym3/azbL2teKJagiKNGQ8qRqjvMOxmBwmRgrk6V5SjrRGDSgeIUjBSTCoVkCCH
	 l3Y9o8W9QLLSTW+GN/GtAXlMXDjnlvtGEUdB1J+WI/KdoawVyjxj1zRbLyV1n1/6bo
	 ekcsG80NDB28zM57H50Ic9m5MM2Hn9ZT8yHL9nHgXGqi0nkILeS2vMUB2VwJKFxDIh
	 ar60Ze5rIiP9Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac34257295dso563652866b.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 19:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVjzQVcsr1R0oocK9opMJbrRXPW90G4wAP6FlYvNmX2aEMoG7/SW9HzO3pNUJqWwXgTDguoKTjy08AI@vger.kernel.org
X-Gm-Message-State: AOJu0YwAb9nCuYNdyKVgWgBqSW+4F22kbKr/Jrwj83Rt3B8t6fj+oPCN
	UUHRnE4gHIJJKcbRXnHwSA3+u4aUDJmP1OsTTeJT2ICx+xWAVkQ9J9ewPMWxaqOViQgp7LpRC1n
	7dBDuL671DZ9JxJtfcl3wvBmZGFRDgJU=
X-Google-Smtp-Source: AGHT+IFKoy7+WA3FrEbwh0t1/JblMPWVC4agnlABQNVyaA0M2F32O0zmUBMudGwrYAD0STSZGQvJ7D3cRaFZ4xcV0kU=
X-Received: by 2002:a17:907:7f17:b0:ad5:2137:cc9e with SMTP id
 a640c23a62f3a-ad85b120246mr1055358766b.3.1748314664714; Mon, 26 May 2025
 19:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org> <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
In-Reply-To: <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 27 May 2025 11:57:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@mail.gmail.com>
X-Gm-Features: AX0GCFvTG7PyeVOnwAGSRypSLMybChZJqwjjHGYoRWzKG1AbwevX2VUGX7hAT04
Message-ID: <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	=?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: multipart/mixed; boundary="0000000000008bf7ad0636153a27"

--0000000000008bf7ad0636153a27
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> On Mon, May 26, 2025 at 9:39=E2=80=AFPM Ralph Boehme <slow@samba.org> wro=
te:
> >
> > On 5/26/25 1:37 PM, Namjae Jeon wrote:
> > > On Mon, May 26, 2025 at 7:45=E2=80=AFAM Steve French <smfrench@gmail.=
com> wrote:
> > >> If the POSIX/Linux context is included in the SMB3.1.1 open then we
> > >> mounted with ("linux" or "posix")
> > > Such a context could be created in smb2_create context like apple con=
text(AAPL).
> > > However, I wonder if there is any plan to add it to SMB3.1.1 posix
> > > extension specification.
> > It's been part of the spec since the beginning. You can find it here:
> Right, I found it.
> Thanks for your reply.
> >
> > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> >
> > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
Philipp,

Can you confirm if your issue is fixed with the attached patch ?

Thanks!

--0000000000008bf7ad0636153a27
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-allow-a-filename-to-contain-special-characters.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-allow-a-filename-to-contain-special-characters.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mb5xe8510>
X-Attachment-Id: f_mb5xe8510

RnJvbSA0ZDRmZDViYjYzNzk3MjA5ZDYzMjQ3Yzk1ZTg3NTczMGFhOTA0MGRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBUdWUsIDI3IE1heSAyMDI1IDExOjIzOjAxICswOTAwClN1YmplY3Q6IFtQQVRDSF0ga3Nt
YmQ6IGFsbG93IGEgZmlsZW5hbWUgdG8gY29udGFpbiBzcGVjaWFsIGNoYXJhY3RlcnMgb24KIFNN
QjMuMS4xIHBvc2l4IGV4dGVuc2lvbgoKSWYgY2xpZW50IHNlbmQgU01CMl9DUkVBVEVfUE9TSVhf
Q09OVEVYVCB0byBrc21iZCwgQWxsb3cgYSBmaWxlbmFtZQp0byBjb250YWluIHNwZWNpYWwgY2hh
cmFjdGVycy4KClJlcG9ydGVkLWJ5OiBQaGlsaXBwIEtlcmxpbmcgPHBrZXJsaW5nQGNhc2l4Lm9y
Zz4KU2lnbmVkLW9mZi1ieTogTmFtamFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4KU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZz
L3NtYi9zZXJ2ZXIvc21iMnBkdS5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAyNiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2VydmVyL3NtYjJwZHUuYyBiL2ZzL3NtYi9zZXJ2
ZXIvc21iMnBkdS5jCmluZGV4IDNhNGJmZmU5N2I1NC4uNGFiYjZjMzA5NDU4IDEwMDY0NAotLS0g
YS9mcy9zbWIvc2VydmVyL3NtYjJwZHUuYworKysgYi9mcy9zbWIvc2VydmVyL3NtYjJwZHUuYwpA
QCAtMjg3NCw3ICsyODc0LDcgQEAgaW50IHNtYjJfb3BlbihzdHJ1Y3Qga3NtYmRfd29yayAqd29y
aykKIAlpbnQgcmVxX29wX2xldmVsID0gMCwgb3Blbl9mbGFncyA9IDAsIG1heV9mbGFncyA9IDAs
IGZpbGVfaW5mbyA9IDA7CiAJaW50IHJjID0gMDsKIAlpbnQgY29udHh0X2NudCA9IDAsIHF1ZXJ5
X2Rpc2tfaWQgPSAwOwotCWludCBtYXhpbWFsX2FjY2Vzc19jdHh0ID0gMCwgcG9zaXhfY3R4dCA9
IDA7CisJYm9vbCBtYXhpbWFsX2FjY2Vzc19jdHh0ID0gZmFsc2UsIHBvc2l4X2N0eHQgPSBmYWxz
ZTsKIAlpbnQgc190eXBlID0gMDsKIAlpbnQgbmV4dF9vZmYgPSAwOwogCWNoYXIgKm5hbWUgPSBO
VUxMOwpAQCAtMjkwMyw2ICsyOTAzLDI3IEBAIGludCBzbWIyX29wZW4oc3RydWN0IGtzbWJkX3dv
cmsgKndvcmspCiAJCXJldHVybiBjcmVhdGVfc21iMl9waXBlKHdvcmspOwogCX0KIAorCWlmIChy
ZXEtPkNyZWF0ZUNvbnRleHRzT2Zmc2V0ICYmIHRjb24tPnBvc2l4X2V4dGVuc2lvbnMpIHsKKwkJ
Y29udGV4dCA9IHNtYjJfZmluZF9jb250ZXh0X3ZhbHMocmVxLCBTTUIyX0NSRUFURV9UQUdfUE9T
SVgsIDE2KTsKKwkJaWYgKElTX0VSUihjb250ZXh0KSkgeworCQkJcmMgPSBQVFJfRVJSKGNvbnRl
eHQpOworCQkJZ290byBlcnJfb3V0MjsKKwkJfSBlbHNlIGlmIChjb250ZXh0KSB7CisJCQlzdHJ1
Y3QgY3JlYXRlX3Bvc2l4ICpwb3NpeCA9IChzdHJ1Y3QgY3JlYXRlX3Bvc2l4ICopY29udGV4dDsK
KworCQkJaWYgKGxlMTZfdG9fY3B1KGNvbnRleHQtPkRhdGFPZmZzZXQpICsKKwkJCQlsZTMyX3Rv
X2NwdShjb250ZXh0LT5EYXRhTGVuZ3RoKSA8CisJCQkgICAgc2l6ZW9mKHN0cnVjdCBjcmVhdGVf
cG9zaXgpIC0gNCkgeworCQkJCXJjID0gLUVJTlZBTDsKKwkJCQlnb3RvIGVycl9vdXQyOworCQkJ
fQorCQkJa3NtYmRfZGVidWcoU01CLCAiZ2V0IHBvc2l4IGNvbnRleHRcbiIpOworCisJCQlwb3Np
eF9tb2RlID0gbGUzMl90b19jcHUocG9zaXgtPk1vZGUpOworCQkJcG9zaXhfY3R4dCA9IHRydWU7
CisJCX0KKwl9CisKIAlpZiAocmVxLT5OYW1lTGVuZ3RoKSB7CiAJCW5hbWUgPSBzbWIyX2dldF9u
YW1lKChjaGFyICopcmVxICsgbGUxNl90b19jcHUocmVxLT5OYW1lT2Zmc2V0KSwKIAkJCQkgICAg
IGxlMTZfdG9fY3B1KHJlcS0+TmFtZUxlbmd0aCksCkBAIC0yOTI1LDkgKzI5NDYsMTEgQEAgaW50
IHNtYjJfb3BlbihzdHJ1Y3Qga3NtYmRfd29yayAqd29yaykKIAkJCQlnb3RvIGVycl9vdXQyOwog
CQl9CiAKLQkJcmMgPSBrc21iZF92YWxpZGF0ZV9maWxlbmFtZShuYW1lKTsKLQkJaWYgKHJjIDwg
MCkKLQkJCWdvdG8gZXJyX291dDI7CisJCWlmIChwb3NpeF9jdHh0ID09IGZhbHNlKSB7CisJCQly
YyA9IGtzbWJkX3ZhbGlkYXRlX2ZpbGVuYW1lKG5hbWUpOworCQkJaWYgKHJjIDwgMCkKKwkJCQln
b3RvIGVycl9vdXQyOworCQl9CiAKIAkJaWYgKGtzbWJkX3NoYXJlX3ZldG9fZmlsZW5hbWUoc2hh
cmUsIG5hbWUpKSB7CiAJCQlyYyA9IC1FTk9FTlQ7CkBAIC0zMDg1LDI4ICszMTA4LDYgQEAgaW50
IHNtYjJfb3BlbihzdHJ1Y3Qga3NtYmRfd29yayAqd29yaykKIAkJCXJjID0gLUVCQURGOwogCQkJ
Z290byBlcnJfb3V0MjsKIAkJfQotCi0JCWlmICh0Y29uLT5wb3NpeF9leHRlbnNpb25zKSB7Ci0J
CQljb250ZXh0ID0gc21iMl9maW5kX2NvbnRleHRfdmFscyhyZXEsCi0JCQkJCQkJIFNNQjJfQ1JF
QVRFX1RBR19QT1NJWCwgMTYpOwotCQkJaWYgKElTX0VSUihjb250ZXh0KSkgewotCQkJCXJjID0g
UFRSX0VSUihjb250ZXh0KTsKLQkJCQlnb3RvIGVycl9vdXQyOwotCQkJfSBlbHNlIGlmIChjb250
ZXh0KSB7Ci0JCQkJc3RydWN0IGNyZWF0ZV9wb3NpeCAqcG9zaXggPQotCQkJCQkoc3RydWN0IGNy
ZWF0ZV9wb3NpeCAqKWNvbnRleHQ7Ci0JCQkJaWYgKGxlMTZfdG9fY3B1KGNvbnRleHQtPkRhdGFP
ZmZzZXQpICsKLQkJCQkgICAgbGUzMl90b19jcHUoY29udGV4dC0+RGF0YUxlbmd0aCkgPAotCQkJ
CSAgICBzaXplb2Yoc3RydWN0IGNyZWF0ZV9wb3NpeCkgLSA0KSB7Ci0JCQkJCXJjID0gLUVJTlZB
TDsKLQkJCQkJZ290byBlcnJfb3V0MjsKLQkJCQl9Ci0JCQkJa3NtYmRfZGVidWcoU01CLCAiZ2V0
IHBvc2l4IGNvbnRleHRcbiIpOwotCi0JCQkJcG9zaXhfbW9kZSA9IGxlMzJfdG9fY3B1KHBvc2l4
LT5Nb2RlKTsKLQkJCQlwb3NpeF9jdHh0ID0gMTsKLQkJCX0KLQkJfQogCX0KIAogCWlmIChrc21i
ZF9vdmVycmlkZV9mc2lkcyh3b3JrKSkgewotLSAKMi4yNS4xCgo=
--0000000000008bf7ad0636153a27--
