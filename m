Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807443090D9
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774920086; cv=pass; b=uVSOrCoBqShoBHeuufDNNkrfiXruPQawQCDdzHBfbV9yUcj5hmhK0q/C081dI4uRQmZ1uIolYJgx4JNVLCZRgQd0e8XnYmH1aJdUf4hq/yOV4nqwbnkh4DTuFhCcrJEJ9Mc7VyleIKXsLuBBhnmBbZ6pCV7NXnS/sl0SlHQA654=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774920086; c=relaxed/simple;
	bh=mh6DenKik5Hj90gluwSnn71YwM7KoCUYaUtTcrYColk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ADDIkRtsylLc32VJ9xfLymhsS9AhKUm+6Z4EIXclEO7v5uoHlVZ7u0aXQEkJKHj3nEWZerQjQKReHdvMCWGdpocViqHhE4SR/pPjWMcNuRDioJ/05uaqTajf609N075yhct5x2VQrXaOkdaaqIetqWKQQvIXczwH5m8wkTTatUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQxItt64; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQxItt64"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cd8576a512so666618085a.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Mar 2026 18:21:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774920084; cv=none;
        d=google.com; s=arc-20240605;
        b=eNgKh3twa0weMRE2KjL4XRLjsqPyQRWm5x0fVy4d3hk9mn/jTuO3cJxkShdQJOm3XU
         KVvWHRVO/utiMH1/mOOJoJSUBSbLh0J1GaRcAq4oL6W/q8Vj/c3LZKJoCED773mSKpVc
         Mo/XIAP5ggIAKWhfg0CN2Zci1Q68toRH63Tz2EsXwV2xwc6sNdvSHIbEyHTP6+juKHxp
         Rs0/sfFC/4YqtHeSoYH4aejPOSE4VOlBI2n3rB2Og0ZHshxGhNJJCema9m3MLMMTCmae
         rpsYGB3kHjjI/6EodngkcVbLkxXhiF/hnqC/OIpMGD+xXIgHP5ELnvwAmYA/wjP0e2zk
         KSbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=VLID+gIwDdYHT4OS3d1rNCEZoPjg9UIK8ZtFXbUjHn8=;
        fh=V21WnHa5Bp0UwNuU5h6XhKbr/piNqURsXp58x0ll9oI=;
        b=bUEmJpp2+arcen8iLIfkNQEC+05bAilz0VqfB+xp0EI4xCwqmVy+ZQcvpvrDdbRwoz
         Dlcdp8017gQM7hL62eqXe2hyOpljdUJsiAxX9+viDnhywhln51Qek4VvHDsECynpY5U0
         ikG8YJO52hHDlCQA3z3rHJ0l8FlMpppwBuOwFm7+BdpnAD3hprGTFJEWJXUfS8z+reWO
         k3D8tzC5X5wAwnchNvkrkqU3eSWTSpBIxzFyxRA8rg8ZYa7Zr2bP9cSOKBE2JGPBOm0+
         CXqFsdDj43f5dJgF0p8MHZjS7CXuOd2/WlqqvU7jYXJm3jSeF6bZXwmg5hCvBu87XOac
         M8og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774920084; x=1775524884; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLID+gIwDdYHT4OS3d1rNCEZoPjg9UIK8ZtFXbUjHn8=;
        b=HQxItt64Pti7bsxyKR91tbG3XgoUg4x251WeFifMSen1wJzxrskcqnCpnpzaYUkRxq
         MsKAopnu1MMeSqezj3YXPZYF6JVVISMMihXo1jhCh7h8qY24a3+hkhNfQs+pxLt56xTU
         RHyxg/9VuRi2Of9DWTOtPfKjO770dxd4XnCVz52/Rw9TT2WSUHM1WERKs8LPtDR1PuMk
         MHHP+mpHuStoW8068LTA5z8wQN5AcxzYM0YV9A03OeFcULslmvv51NpoE1noygepjes9
         jPtNx8qNqsBgxzVCLJi9tQdCkx2oDjIgingyBnzhfwZCMiPxTxV3psMLu5CkkYO9Tmp/
         g4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774920084; x=1775524884;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLID+gIwDdYHT4OS3d1rNCEZoPjg9UIK8ZtFXbUjHn8=;
        b=hYt7OArixNA5Kv82Nv01rZLadVqJcE0FW52GskeNvmQfBH65EokD9NkcWiBkHLDU8T
         RKSBRz/TReIspOMiBWSTrE4UH9FzeEt32MCeHKroYvFKOIBJKRKkzR6M/T1/c2EhcncS
         IF8IoN9r2rSa7ppPTrj9ZRVThJOrsYha/LP+nSwK3wrChwB4h8bi3XcGvMTC6FN/Dlzd
         FbfYBaz4fghFVl9IRT/edr1Ln823D6uC0QW+b+0lMn/VthLt/2nN41U8kyQISO0aKV41
         re8451AuGR68LdcOlGRT7NdLpcuqzkEOvkeAxEuN8QKaZoy/OacWe2U6rEH2ssqn338q
         XXXg==
X-Gm-Message-State: AOJu0YwzrIYMjE08Hq2VOC/ELbJP7+YE3EVoLssnxCYD177R7NULG1hf
	4j8UUvxh8vuepkdmTcOSQnMHw/mKXXDIMnRtBo5WZgd2VtkfUmpBLiZJbZXM3JsiBerPtl/p9HC
	3mkbif86sS4dXjk6Dq1eOd1qNSpSz9N/HrQ==
X-Gm-Gg: ATEYQzwfYKbErD0TS3ps5hJHGzpAZ4vJTtnj6D0MeiiGXi1xJOEE9c88va9IkSPg14p
	TQchYaeniKOFHmtagmQ56fH4BsFvqVU3jEWnzFJqpPVy3DQdZYGflT/pAzVWuZwSk2lm9MoqXsF
	TfNUO0G/NTA0Sgos1eBw+F0MzZ1haCNg6uP6OSBvIEJC++lBl6Pj7twjrYxXh57By9fVXmVu0aK
	YKapU4sWHLGx0GM89J2meotiG3f4t5oRIPWFFEJIffm1WXEUm2dtSnKfuAfR8ZtnEN0VaudguOz
	eURoSdZ5RljXS1HjCQHjYAbGEsPDaYSG97S3HDQjtIf1P9cApmiRwkwUt1IqBdBUaIryEfIEZZA
	9UEmKTrmZqq5bPwmxINaAucAQxqeWFlUfaYCSFbhE9vLTWn4ZLixrOdFeZbdDpq2d0Hivj03Wfd
	fxlxod5tLQIE1YL6DBXsQLFKXdqfKX45g=
X-Received: by 2002:a05:6214:6014:b0:899:a586:2923 with SMTP id
 6a1803df08f44-8a2cbc62810mr23009636d6.28.1774920084056; Mon, 30 Mar 2026
 18:21:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <rM3FgiN70vidwsHNx9HrdB8n5fR6QzmN8av68v2EoXn3ovIk0pMYh7_KVxczILavRTAUdRhPDx2xIlFE33H6FmhYFndPSpXp726MOeSJT58=@proton.me>
In-Reply-To: <rM3FgiN70vidwsHNx9HrdB8n5fR6QzmN8av68v2EoXn3ovIk0pMYh7_KVxczILavRTAUdRhPDx2xIlFE33H6FmhYFndPSpXp726MOeSJT58=@proton.me>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Mar 2026 20:21:12 -0500
X-Gm-Features: AQROBzAEjR_eYp_2zgtNmbeLla5Qi5J2XZ19FKV8z0kha2MtrCd-OGACpl9KDSU
Message-ID: <CAH2r5muSYRTTc-6puKpviuWGc7LziPTsGTsk9Pp2SQ8tZRVC-g@mail.gmail.com>
Subject: Fwd: Malformed patches
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001e13cd064e47c9c8"

--0000000000001e13cd064e47c9c8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Resending to the mailing list as well

---------- Forwarded message ---------
From: FredTheDude <FredTheDude@proton.me>
Date: Mon, Mar 30, 2026 at 8:02=E2=80=AFPM
Subject: Malformed patches
To: smfrench@gmail.com <smfrench@gmail.com>, sfrench@samba.org
<sfrench@samba.org>


Proton Free does not support SMTP, so I couldn't use git send-email.

--=20
Thanks,

Steve

--0000000000001e13cd064e47c9c8
Content-Type: application/x-patch; 
	name="0001-fs-smb-client-add-verbose-error-logging-for-UNC-pars.patch"
Content-Disposition: attachment; 
	filename="0001-fs-smb-client-add-verbose-error-logging-for-UNC-pars.patch"
Content-Transfer-Encoding: base64
Content-ID: <19d417a8bf7c584e7661>
X-Attachment-Id: 19d417a8bf7c584e7661

RnJvbSBkMTgzOTE5N2M5NjVlZjRhZDA5YjJlYWZmYjRmMmM1ZGU0ZmU1NTQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGcmVkcmljIENvdmVyIDxGcmVkVGhlRHVkZUBwcm90b24ubWU+
CkRhdGU6IFNhdCwgMjggTWFyIDIwMjYgMTg6NDc6NTMgLTA3MDAKU3ViamVjdDogW1BBVENIXSBm
cy9zbWIvY2xpZW50OiBhZGQgdmVyYm9zZSBlcnJvciBsb2dnaW5nIGZvciBVTkMgcGFyc2luZwoK
QWRkIGNpZnNfZGJnKFZGUywgLi4uKSBzdGF0ZW1lbnRzIHRvIHNtYjNfcGFyc2VfZGV2bmFtZSgp
IHRvIHByb3ZpZGUKZXhwbGljaXQgZmVlZGJhY2sgd2hlbiBwYXJzaW5nIGZhaWxzLiBDdXJyZW50
bHksIHRoZSBmdW5jdGlvbiByZXR1cm5zCi1FSU5WQUwgc2lsZW50bHksIG1ha2luZyBpdCBkaWZm
aWN1bHQgdG8gZGVidWcgbW91bnQgZmFpbHVyZXMgY2F1c2VkCmJ5IG1hbGZvcm1lZCBwYXRocyBv
ciBtaXNzaW5nIHNoYXJlIG5hbWVzLgoKU2lnbmVkLW9mZi1ieTogRnJlZHJpYyBDb3ZlciA8RnJl
ZFRoZUR1ZGVAcHJvdG9uLm1lPgotLS0KCklmIEkgbWFkZSBhbnkgc3R1cGlkIG1pc3Rha2VzLCBw
bGVhc2UgYmUgcGF0aWVudCB3aXRoIG1lLgpDIGlzIG5vdCBteSBiZXN0IGxhbmd1YWdlLCBhbmQg
dGhpcyBpcyBteSBmaXJzdCBwYXRjaCwgYW5kIEkgYW0ganVzdCBhIGhpZ2ggc2Nob29sIGZyZXNo
bWFuLiBUaGFua3MhCi0tLQogZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMgfCAxMiArKysrKysr
KystLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMgYi9mcy9zbWIvY2xpZW50L2Zz
X2NvbnRleHQuYwppbmRleCBhNGE3YzdlZWUuLjAzYzExMmY0ZCAxMDA2NDQKLS0tIGEvZnMvc21i
L2NsaWVudC9mc19jb250ZXh0LmMKKysrIGIvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKQEAg
LTY1OCwxMyArNjU4LDE3IEBAIHNtYjNfcGFyc2VfZGV2bmFtZShjb25zdCBjaGFyICpkZXZuYW1l
LCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAKIAkvKiBtYWtlIHN1cmUgd2UgaGF2ZSBh
IHZhbGlkIFVOQyBkb3VibGUgZGVsaW1pdGVyIHByZWZpeCAqLwogCWxlbiA9IHN0cnNwbihkZXZu
YW1lLCBkZWxpbXMpOwotCWlmIChsZW4gIT0gMikKKwlpZiAobGVuICE9IDIpIHsKKwkJY2lmc19k
YmcoVkZTLCAiVU5DOiBwYXRoIG11c3QgYmVnaW4gd2l0aCAvLyBvciBcXFxcXG4iKTsKIAkJcmV0
dXJuIC1FSU5WQUw7CisJfQogCiAJLyogZmluZCBkZWxpbWl0ZXIgYmV0d2VlbiBob3N0IGFuZCBz
aGFyZW5hbWUgKi8KIAlwb3MgPSBzdHJwYnJrKGRldm5hbWUgKyAyLCBkZWxpbXMpOwotCWlmICgh
cG9zKQorCWlmICghcG9zKSB7CisJCWNpZnNfZGJnKFZGUywgIlVOQzogbWlzc2luZyBkZWxpbWl0
ZXIgYmV0d2VlbiBob3N0bmFtZSBhbmQgc2hhcmUgbmFtZVxuIik7CiAJCXJldHVybiAtRUlOVkFM
OworCX0KIAogCS8qIHJlY29yZCB0aGUgc2VydmVyIGhvc3RuYW1lICovCiAJa2ZyZWUoY3R4LT5z
ZXJ2ZXJfaG9zdG5hbWUpOwpAQCAtNjc3LDggKzY4MSwxMCBAQCBzbWIzX3BhcnNlX2Rldm5hbWUo
Y29uc3QgY2hhciAqZGV2bmFtZSwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4KQogCiAJLyog
bm93IGdvIHVudGlsIG5leHQgZGVsaW1pdGVyIG9yIGVuZCBvZiBzdHJpbmcgKi8KIAlsZW4gPSBz
dHJjc3BuKHBvcywgZGVsaW1zKTsKLQlpZiAoIWxlbikKKwlpZiAoIWxlbikgeworCQljaWZzX2Ri
ZyhWRlMsICJVTkM6IG1pc3Npbmcgc2hhcmUgbmFtZVxuIik7CiAJCXJldHVybiAtRUlOVkFMOwor
CX0KIAogCS8qIG1vdmUgInBvcyIgdXAgdG8gZGVsaW1pdGVyIG9yIE5VTEwgKi8KIAlwb3MgKz0g
bGVuOwotLSAKMi40My4wCgo=
--0000000000001e13cd064e47c9c8
Content-Type: application/x-patch; 
	name="0001-fs-smb-client-fs_context.c-fix-out-of-bounds-read-in.patch"
Content-Disposition: attachment; 
	filename="0001-fs-smb-client-fs_context.c-fix-out-of-bounds-read-in.patch"
Content-Transfer-Encoding: base64
Content-ID: <19d417a8bf7ed4c42ab2>
X-Attachment-Id: 19d417a8bf7ed4c42ab2

RnJvbSBmY2QxZWQ5ZDI5NDM5Y2Q3MTYzYjA4OWUyM2I3ZjcyNjVlZWVhNmFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGcmVkcmljIENvdmVyIDxGcmVkVGhlRHVkZUBwcm90b24ubWU+
CkRhdGU6IE1vbiwgMzAgTWFyIDIwMjYgMTM6MTE6MjcgLTA3MDAKU3ViamVjdDogW1BBVENIXSBm
cy9zbWIvY2xpZW50OiBmaXggb3V0LW9mLWJvdW5kcyByZWFkIGluCiBjaWZzX3Nhbml0aXplX3By
ZXBhdGgKCldoZW4gY2lmc19zYW5pdGl6ZV9wcmVwYXRoIGlzIGNhbGxlZCB3aXRoIGFuIGVtcHR5
IHN0cmluZyBvciBhIHN0cmluZwpjb250YWluaW5nIG9ubHkgZGVsaW1pdGVycyAoZS5nLiwgIi8i
KSwgdGhlIGN1cnJlbnQgbG9naWMgYXR0ZW1wdHMgdG8KY2hlY2sgKihjdXJzb3IyIC0gMSkgYmVm
b3JlIGN1cnNvcjIgaGFzIGFkdmFuY2VkLiBUaGlzIHJlc3VsdHMgaW4gYW4Kb3V0LW9mLWJvdW5k
cyByZWFkLgoKVGhpcyBwYXRjaCBhZGRzIGFuIGVhcmx5IGV4aXQgY2hlY2sgYWZ0ZXIgc3RyaXBw
aW5nIHByZXBlbmRlZApkZWxpbWl0ZXJzLiBJZiBubyBwYXRoIGNvbnRlbnQgcmVtYWlucywgdGhl
IGZ1bmN0aW9uIHJldHVybnMgTlVMTC4KClRoZSBidWcgd2FzIGlkZW50aWZpZWQgdmlhIG1hbnVh
bCBhdWRpdCBhbmQgdmVyaWZpZWQgdXNpbmcgYQpzdGFuZGFsb25lIHRlc3QgY2FzZSBjb21waWxl
ZCB3aXRoIEFkZHJlc3NTYW5pdGl6ZXIsIHdoaWNoCnRyaWdnZXJlZCBhIFNFR1Ygb24gYWZmZWN0
ZWQgaW5wdXRzLgoKU2lnbmVkLW9mZi1ieTogRnJlZHJpYyBDb3ZlciA8RnJlZFRoZUR1ZGVAcHJv
dG9uLm1lPgoKLS0tCgpJZiBJIG1hZGUgYW55IHN0dXBpZCBtaXN0YWtlcywgbGV0IG1lIGtub3cu
CkkgYW0ganVzdCBhIGhpZ2gtc2Nob29sIGZyZXNobWFuLCBhbmQgSSBoYXZlIGEgbG90IHRvIGxl
YXJuLCBlc3BlY2lhbGx5IGluIEMuClRoYW5rcyBmb3IgdGFraW5nIHlvdXIgdGltZSB0byBsb29r
IGF0IG15IHBhdGNoLgotLS0KIGZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jIHwgNCArKysrCiAx
IGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVu
dC9mc19jb250ZXh0LmMgYi9mcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuYwppbmRleCAwM2MxMTJm
NGQuLjNmMGZhYWU5OSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKKysr
IGIvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKQEAgLTU4OCw2ICs1ODgsMTAgQEAgY2hhciAq
Y2lmc19zYW5pdGl6ZV9wcmVwYXRoKGNoYXIgKnByZXBhdGgsIGdmcF90IGdmcCkKIAl3aGlsZSAo
SVNfREVMSU0oKmN1cnNvcjEpKQogCQljdXJzb3IxKys7CiAKKwkvKiBleGl0IGluIGNhc2Ugb2Yg
b25seSBkZWxpbWl0ZXJzICovCisJaWYgKCEqY3Vyc29yMSkKKwkJcmV0dXJuIE5VTEw7CisKIAkv
KiBjb3B5IHRoZSBmaXJzdCBsZXR0ZXIgKi8KIAkqY3Vyc29yMiA9ICpjdXJzb3IxOwogCi0tIAoy
LjQzLjAKCg==
--0000000000001e13cd064e47c9c8--
