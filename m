Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B4F3939AE
	for <linux-cifs@vger.kernel.org>; Sun, 24 May 2026 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779630631; cv=pass; b=kpdivQ3imHGGCTLT1VHWwcQywAYs+oFWzopfxEqRkFq+cjQkI5EBjsX/y6VS9qwHxBqWWf3Hh55K00jQPDX9dgO4BeXcCU9cRF2vEexwSKaDKcNl5+IQgIz8A8gch8TmenxnTQXEGCkn0P9ndvUq/K8hVrZjRurcVbxgZIyuTOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779630631; c=relaxed/simple;
	bh=uii0LdVQpDQEMaF/oP+P85G53PJx+YFYnVwn8J2du0c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bW/pZBAwms+8SvL7Vvu7IqvRAuNTDCIfVi61OP4CjDjcDYxj5YW8ZHXKo5PGYke2FecfrLKzHjL+ntjvBlorKbtxLH/36JvKnrjf+uD/CV99UdGAWjRlEjnSyJTIAE+3DP8SBrINn06/Xx3CQG+hIbmiSad6cYx1R9ApuPV4JE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TdynaAM8; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TdynaAM8"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8acae26e564so115756506d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 24 May 2026 06:50:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779630629; cv=none;
        d=google.com; s=arc-20240605;
        b=fYpWJ16YB/fStp6T77jc2diYSQmJ4m8KXhcq6tTq0h/afVbo8Db8kQfrERirYAeQVA
         zpo2677ITWhWjRZ/A6TGsuf/5re6ghX7oe61Fg47ofsFZUOwQUjuDZbHLFcZ+3CVw5/2
         5IruEuNFza97VeNS0+myLpDquagk8SCTb0QyEI3YrNMj2MuHlRkyw6YURHuWSsimLsil
         BXzdUez3DaiaKssizurV0P1GPFH8t7D2OkUFSgobCSElqoHYiD3l5gCF5dNsJzSwt0cN
         FwrDCLkwrgGg+niSqr7PyU7aKo3Qh0AuHieLu3FWD/W0MEYkSw/U5a2ta5b55CloIuCT
         1h1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+JeT5hz1hCbicULiV2h2N0udecL+UajpwWWhxL4W8Yw=;
        fh=Qr9ZWqst8N9e1Ej0VxFNZNS9HRiuud5KRUk3X3njxfg=;
        b=G7/qBX4tyiiVUBgxzgX61EpWWnMKYL6TBZwFciwayR2lBq3p5Xn0J7D1L9rH/fayPo
         bPB7P/9qIndIcTqQ9BIXPF7WD78rjDsymfo6tj4XHxyuAShnWmpLRYadbIz3J4eLl5p5
         Zwut/BcyWhrf5muzSVTTUxt7wWabvDQ7Xr+CSWvnYMeXn+bG1SERJprU6VOXxEUU2eNa
         ZUKydG6hUCxnecVTxXWctkP5jijpDhyg088r/tTIRA5ol5OT6XflCKJROdurPL5RRRzz
         n07HGOXMsdySuK/18L5VX4CWmXTM0iXPTVo2+S04NsNQwYPsKxvSxs7nDpLBeVI0Fv2k
         Qu7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779630629; x=1780235429; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+JeT5hz1hCbicULiV2h2N0udecL+UajpwWWhxL4W8Yw=;
        b=TdynaAM8Itjfo2YV3m8FGy6CWyWTPSGdcYmy7BI6ykXLj9YHdSkED2+ZcvoA9EPvl+
         dgt7yTB/FuHiRP/UjXdi7g2mQ4kjzIa1i4FUy+gkVJGFlo51cR93ueINWBZMmsOwsG9F
         zxsR80MnNwL4NPnyDTBzXj3JvPi1HxRJ49VyhdHfc9LO3nHxduQni9RGRkwcwP4JrBTt
         aPesWbf9tx7KQHzSiuvv3Spq1fWjcz07dv5a8SK7eF+8Mia1ucbFaSAG8hZE6ICpwgSR
         zk/QFS10yhRQddyrsjbtHLYkmpTsZGUOx6CAIvWPmOUTd/CKem5BrFo9/e4IYauVtHKd
         clEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779630629; x=1780235429;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+JeT5hz1hCbicULiV2h2N0udecL+UajpwWWhxL4W8Yw=;
        b=H+oAuM/RpxE1cJtTK/5D3+FpNqgqs20yeD/Va8IMRt53JrjYffPOO1DtelkD4/2PHk
         4xyuond5fTzqqa9hQbQyIeQogdNI845r/PvDbn6I61jcnplx5yWkwDclJIo8kGIckBAE
         1ejpseH4sZDpEMUbAs9N5yKtt8vIQ4zJmq5OXvFv9xnqO9wDKwIRW3IVxRo/ZSuZAl5k
         HXmbM/odxi9501T6x1+PZ3HNiOd1jqcFlEtKt0OtwyVdQzIi9MKBBFaoHfVQ3hByI75Y
         vKNch4/NnCYA7MDeSdDxTCBIpy06oS+xJxQKD/asc+KaaoIVlNuDw302VrsuwYCdqMWq
         lIjw==
X-Gm-Message-State: AOJu0YxklMWvM64a5jowHQe3f5N8ZLIDS7NWdVzl7RvamuQyd/TQvioN
	qTAY9LU0mhWm2gdCPp+Y27SoMV5j8Ukg2zmy8Sey3XMUuKMi+cXsHGhJXxDNjj656U1Xua8N+GD
	+MsjQMxT9lfmWH1l8ovz0EjVcG/kjLdE=
X-Gm-Gg: Acq92OEDYgTVl23FgtQkdNSLH54gu3OK/E2H9UnzqxAB3kMuOatobYvhgkDmyBFRLRG
	SOJqctoGGu8jwz2ksOFHM9YnTo7IYAzrqhvD2dvr9uF40909nKGQzCYovvnLV2lhVfMj8A6I6Vz
	hhxugRFDr4Y5Lnvx0CwaQuUZJFmQAxT3KylmKIwq9jN5VLrGTs+jetAT4S83+Wt2KOksxlwteaw
	TUAUmkysS+3q+/9kCy31f1cTNLas3CEpNx15VB6kSLfNW91KPSdIuIcgeS8Soc/on3/SZ3gSnms
	l1Z1PAU+ZQ0dgPAIqntwnvzCoe4jimFtzgXDTk40LbTtcwX9ljIeHZccu7vWN8Q+Yo2R339/Nwx
	O6Do27ywnyKrBGIkTV/OO3Sr2rnfZTfc5xQPkDfYG/iglwLiDnRqna/Rj+qaHsw9rZRpGDdhbTU
	IzxwO8
X-Received: by 2002:a05:620a:d93:b0:8f4:3bb0:ca7 with SMTP id
 af79cd13be357-914b49ba29fmr1641669185a.37.1779630629060; Sun, 24 May 2026
 06:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: _Vx Ano13 <ano13vx@gmail.com>
Date: Sun, 24 May 2026 20:50:18 +0700
X-Gm-Features: AVHnY4KQm6wBTfgxHVOLHyRuiW8J5Rm3Ed3Sx9Wv9OQDgRCfmexg2a3JkKd7KLM
Message-ID: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
Subject: [PATCH] ksmbd: add missing software bounds checks in RDMA transport layer
To: linux-rdma@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com
Content-Type: multipart/mixed; boundary="0000000000007a35120652908b85"

--0000000000007a35120652908b85
Content-Type: text/plain; charset="UTF-8"

Hi maintainers,
This patch fixes a missing software bounds check in the ksmbd RDMA
transport layer. I noticed that a length parameter was not being
properly validated before use, which could lead to potential issues.
Please review this fix. Any feedback is appreciated.
Thanks,
Nguyen Van Tuann

--0000000000007a35120652908b85
Content-Type: application/octet-stream; 
	name="0001-ksmbd-add-bounds-validation-for-SMB-Direct-RDMA-desc.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-add-bounds-validation-for-SMB-Direct-RDMA-desc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mpju33f60>
X-Attachment-Id: f_mpju33f60

RnJvbSA4NmRiMGVlNTU3MzMyZDU3ZDIyNTk0NWEyMTkzYjVjOWY3N2E0YjNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOZ3V5ZW4gVmFuIFR1YW4gPGFubzEzdnhAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIzIE1heSAyMDI2IDE3OjE3OjM4ICswMDAwClN1YmplY3Q6IFtQQVRDSF0ga3Nt
YmQ6IGFkZCBib3VuZHMgdmFsaWRhdGlvbiBmb3IgU01CIERpcmVjdCBSRE1BIGRlc2NyaXB0b3Jz
CgpWYWxpZGF0ZSBvZmZzZXQsIGxlbmd0aCwgYW5kIGRlc2NfbGVuIGZpZWxkcyBvZiB0aGUgU01C
IERpcmVjdCBidWZmZXIKZGVzY3JpcHRvciBiZWZvcmUgcGFzc2luZyB0aGVtIHRvIHRoZSBSRE1B
IHRyYW5zcG9ydCBsYXllci4gV2l0aG91dAp0aGlzIGNoZWNrLCBhIHJlbW90ZSBhdHRhY2tlciBj
YW4gc3VwcGx5IGNyYWZ0ZWQgZGVzY3JpcHRvciB2YWx1ZXMgdG8KY2F1c2Ugb3V0LW9mLWJvdW5k
cyBtZW1vcnkgYWNjZXNzIGluIHRoZSB1bmRlcmx5aW5nIFJETUEgc3RhY2suCgpTaWduZWQtb2Zm
LWJ5OiBOZ3V5ZW4gVmFuIFR1YW4gPGFubzEzdnhAZ21haWwuY29tPgotLS0KIGZzL3NtYi9zZXJ2
ZXIvdHJhbnNwb3J0X3JkbWEuYyB8IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEg
ZmlsZSBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL3NlcnZl
ci90cmFuc3BvcnRfcmRtYS5jIGIvZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jCmluZGV4
IGI2ZDYzZmY4YS4uZTEwNDE2YzBiIDEwMDY0NAotLS0gYS9mcy9zbWIvc2VydmVyL3RyYW5zcG9y
dF9yZG1hLmMKKysrIGIvZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jCkBAIC0yNjAsNiAr
MjYwLDExIEBAIHN0YXRpYyBpbnQgc21iX2RpcmVjdF9yZG1hX3dyaXRlKHN0cnVjdCBrc21iZF90
cmFuc3BvcnQgKnQsCiAgICAgc3RydWN0IHNtYl9kaXJlY3RfdHJhbnNwb3J0ICpzdCA9IFNNQkRf
VFJBTlModCk7CiAgICAgc3RydWN0IHNtYmRpcmVjdF9zb2NrZXQgKnNjID0gc3QtPnNvY2tldDsK
IAorCWludCByZXQ7CisKKwlyZXQgPSB2YWxpZGF0ZV9zbWJkX2Rlc2NyaXB0b3JfdjEoZGVzYywg
ZGVzY19sZW4sIGJ1Zmxlbik7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKwogICAgIHJldHVy
biBzbWJkaXJlY3RfY29ubmVjdGlvbl9yZG1hX3htaXQoc2MsIGJ1ZiwgYnVmbGVuLAogICAgICAg
ICAgICAgICAgICAgICAgICAgICBkZXNjLCBkZXNjX2xlbiwgZmFsc2UpOwogfQpAQCAtMjcwLDYg
KzI3NSwxMSBAQCBzdGF0aWMgaW50IHNtYl9kaXJlY3RfcmRtYV9yZWFkKHN0cnVjdCBrc21iZF90
cmFuc3BvcnQgKnQsCiAgICAgc3RydWN0IHNtYl9kaXJlY3RfdHJhbnNwb3J0ICpzdCA9IFNNQkRf
VFJBTlModCk7CiAgICAgc3RydWN0IHNtYmRpcmVjdF9zb2NrZXQgKnNjID0gc3QtPnNvY2tldDsK
IAorCWludCByZXQ7CisKKwlyZXQgPSB2YWxpZGF0ZV9zbWJkX2Rlc2NyaXB0b3JfdjEoZGVzYywg
ZGVzY19sZW4sIGJ1Zmxlbik7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKwogICAgIHJldHVy
biBzbWJkaXJlY3RfY29ubmVjdGlvbl9yZG1hX3htaXQoc2MsIGJ1ZiwgYnVmbGVuLAogICAgICAg
ICAgICAgICAgICAgICAgICAgICBkZXNjLCBkZXNjX2xlbiwgdHJ1ZSk7CiB9CkBAIC01NDEsMyAr
NTUxLDE2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qga3NtYmRfdHJhbnNwb3J0X29wcyBrc21iZF9z
bWJfZGlyZWN0X3RyYW5zcG9ydF9vcHMgPSB7CiAKIE1PRFVMRV9JTVBPUlRfTlMoIlNNQkRJUkVD
VCIpOwogCitzdGF0aWMgaW50IHZhbGlkYXRlX3NtYmRfZGVzY3JpcHRvcl92MShzdHJ1Y3Qgc21i
ZGlyZWN0X2J1ZmZlcl9kZXNjcmlwdG9yX3YxICpkZXNjLAorCQkJCSAgICAgICB1bnNpZ25lZCBp
bnQgZGVzY19sZW4sCisJCQkJICAgICAgIHVuc2lnbmVkIGludCBidWZsZW4pCit7CisJaWYgKGRl
c2NfbGVuIDwgc2l6ZW9mKHN0cnVjdCBzbWJkaXJlY3RfYnVmZmVyX2Rlc2NyaXB0b3JfdjEpKQor
CQlyZXR1cm4gLUVJTlZBTDsKKwlpZiAoZGVzYy0+bGVuZ3RoID09IDAgfHwgZGVzYy0+bGVuZ3Ro
ID4gYnVmbGVuKQorCQlyZXR1cm4gLUVJTlZBTDsKKwlpZiAoZGVzYy0+bGVuZ3RoID4gc21iX2Rp
cmVjdF9tYXhfcmVhZF93cml0ZV9zaXplKQorCQlyZXR1cm4gLUVJTlZBTDsKKwlyZXR1cm4gMDsK
K30KLS0gCjIuNDMuMAo=
--0000000000007a35120652908b85--
