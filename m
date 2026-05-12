Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EF51FC101
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 03:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778555497; cv=pass; b=EXWaoVTYSLemaoDDQp/DKsART15Vcr3cbEYLNoM6gNrHFzHc7qUdIsPhuDfAyW0Z0Tikb8nD1Humbdg+JhCZ8sZMZUKoy1XyhyN+S2jwnXouI42izxzu8LSTyWm8hKJ4dRLrGOsv3vyFg0nHDSQ0xLNedEEm8bTQlKSWBdB+HwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778555497; c=relaxed/simple;
	bh=0ZTEk579c5+3HOmMGdFmYvqGq3HNjo77L9p9/5XMOLs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=S+QQDC3nEPL3uR6a1gh1a4cqhK/4kcQFCC2hTrxgdKLfaIa9II7dbWYgn//+WP2NxnA48Nn1Vm+ljcHFboxmTmQ2YhdJ48uQaEk6enyz5CYYXnfFW2yT/VldkIJKZWe3gjhrnvzCwVh/x9YpPPHiMhZT/T76eI9M/9o5kyPn21U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPrE3Bvk; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPrE3Bvk"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50e5c5033f6so35162141cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 20:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778555494; cv=none;
        d=google.com; s=arc-20240605;
        b=kv0KxDzZ5odeiBowXWO4EmI64Uc52Ew9AfET6Bt/Hc/wbARxkeynjCce6onA0DLgAH
         pje+Hq+RCIx44Ss6cb2IlPvXIqpb6bvos/zh1vXWccLmw5wf+QvKUs/1Txsg3NpmmOAP
         2hp/YNxVpNPWpgcOUZBp170GVWtHR54oavzjhnFPB1hVZ8mi7fjkwrQIxJQGOyRlebL8
         7YT5EYmswgAOJXZGWigOIjSNsDDCVEQTt/un5GxXDEKlNSlxSDav5kZkXRbAWK7GttYm
         74N4CH0QPnTt4jUGczctk3bi2NZp4cZEwPcH1Ea2VLLtxfspxqU4q5gQSvjCKPNsSiFo
         1tQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=PM063rOkqHnzGgWRpoxDZ6B9UQ3+yM43Hbw1slxnZmQ=;
        fh=6tY+Ovy/8DUqZG1+/Nk/+cuG4ArqKwAz485INxhH87g=;
        b=bYX+yz57pL3d0k/Fll5IIteJxSXUisQ2IAgxbl3KFs9EBbt5xgEKtzr2DGqm+20UxR
         2vbct5gRzWnsSQCS7TvCoG6226VwZJnBCJY6hTUU4lujX2jdT+D26h3zox++uTfh4+UB
         e9Let53Ivc3oBkDDMCkd7YjO24GRElF2KqhID2X8Wu/XZ6q/C4lOq6JjkRQW9TgyJpfT
         owxgUvE7QL7WFDZTz+eNqC/ySMfj5AAFwBaoXUYP3FXvMd2Jl5lVDrJh4bhsTrtbSHie
         j27fW99Ig68b6pyWat/qpW2ik0oUfP3xLasTKLd8392CegmgBlv1/rd0Lq2bi58A8uIa
         touA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778555494; x=1779160294; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PM063rOkqHnzGgWRpoxDZ6B9UQ3+yM43Hbw1slxnZmQ=;
        b=lPrE3BvkupLyPzdVfsobMkKRqJWdNYbc/BNVzoLkfOejI48g+16w2MRkdYUF084GF+
         o3jlSnOfmBVsNRz/WxMZTyfZ6RWWcafkspeNvmwUrfgqiwH8xcj3b9TeWem+Mv69UFkq
         tni5ZHH9hXyxU79s3p91NULiWbeNDRdOUj02it2zBSEFYnOKwn8g0MxWChg1uSCYqLsR
         KUoHlh8q4CRsLXdCN8HCDxdhrKV7rsKy2BvsN8TMis13hI4Snd0xy2BDs3RrTwNGKBYK
         cgawC1FWOYWoFxz22gyNw8ifr0dJXnqimKnremL5/wlTJKZPV6jUFonTMkj6+pFgaHQX
         V6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778555494; x=1779160294;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PM063rOkqHnzGgWRpoxDZ6B9UQ3+yM43Hbw1slxnZmQ=;
        b=CMr6Z4LvVQrENgijpNV1N6ZFvc+YLNTvGQPV74JZXUS+wV82n3bed19LgAcXII68bw
         a2MHr8QHhWMZBpwZdi9NSFH6wFEfHH/aiip45BoNGdOouBKxYnyI4UsuGwaaMe8eNlkn
         gTYxWTJ3Jq+u2O5vDikVICRvUtbqgAZNqh2b3pFOrM5A90asObgv96QL4fI8Z3a/lA+F
         BPVF0HJFnH9VbzETiVtUhuqPnGXUioJPE4Go1Kgf/MFRDmUyL4DuNpN1/EwEz1oRfnsR
         CuTGHNP/CZ5rId63mjkgFCfOYYn79eyWFCUwP+f8+rb+a36g52oPYR8fMvi0EcyYUkRl
         hIXg==
X-Gm-Message-State: AOJu0YwPYIeE7x5ja1e6FYRmf2NLZuHJpDeypc0f7WEPYk09uAh1b/p0
	ip6vw0frui+vzD6yi16dcl6ieN81BJdz3S9h9P5E5MWe3NRS+pjsI82fsUbC9RFDapeDqGaVlFG
	WBQfS/fUvqJZSGUDp9dOCX65LJ+2INynVChYY2Dw=
X-Gm-Gg: Acq92OEwna+DGzFMbCbSuObWpJc5+tIBMLPJNQHxq+WDBf+3j5wRKPSeiyb2j2SQi4s
	8dTNoF/jn7JGCtBH8yHE4Da7MNapSBmbD5hR4WQkR1YmUY4wnLlpcfWac0rvmmA+4ACYI1UND2v
	/RzlZilIt0ljDHrvrcwyQI3VMokbZQTfaJcBhkXBXh6zWsfJJz/JP1la7bIYsy80m8K1GIj6LeA
	9JwiOm9qSvOOW8+16ugOz0JT+aOiH1aKP0eXluCjwN017V1GQwLFHbQZwEKzkVWA4VkkU9IyJFe
	K0M9GVcJKtWNYYOlDsIcVzdiFHI3Oe7D4mPKI47UAMCOzkD5OPBwGEOh5DfGq8hYvc0SvEAn5YG
	kYG5aPh+UVJrYiH7tO8b39oY3oCqw9w0tqehE3uElOud4hjIP9s/ISuk4vDJDt/X5As8P1lAe3P
	k2UzS5Eeeq/o4fRj/FZU42RwddRzdL9g==
X-Received: by 2002:a05:622a:199a:b0:510:141d:9d05 with SMTP id
 d75a77b69052e-51461be0166mr377763641cf.7.1778555494430; Mon, 11 May 2026
 20:11:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 May 2026 22:11:22 -0500
X-Gm-Features: AVHnY4KmUbc580neqjH7qWYo3fe0uo_V7343jNJlGsiCSMq87nMXGPmjsItoKro
Message-ID: <CAH2r5mu+axKdXcoDBnFdoR=iNvkj=86xOko5mTcK3cva=SAKXw@mail.gmail.com>
Subject: [PATCH] SMB3.1.1: add missing QUERY_DIR info levels
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000007594b20651963810"

--0000000000007594b20651963810
Content-Type: text/plain; charset="UTF-8"

New Infolevels for QUERY_DIR (and QUERY_INFO) levels 78 through 81 are
now being used by Windows clients and were added to the documentation.
Add defines for them (and correct some typos in documentation).  See
MS-SMB2 2.2.33 and MS-FSCC 2.4


-- 
Thanks,

Steve

--0000000000007594b20651963810
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-add-missing-QUERY_DIR-info-levels.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-add-missing-QUERY_DIR-info-levels.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mp220div0>
X-Attachment-Id: f_mp220div0

RnJvbSBkZDliYzUwMDI4YjYwOTI1MzU4OTQzMzUzMWUzYzU2NWZhYmNkMzU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTEgTWF5IDIwMjYgMjE6NTU6MjMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzLjEuMTogYWRkIG1pc3NpbmcgUVVFUllfRElSIGluZm8gbGV2ZWxzCgpOZXcgSW5mb2xldmVs
cyBmb3IgUVVFUllfRElSIChhbmQgUVVFUllfSU5GTykgbGV2ZWxzIDc4IHRocm91Z2ggODEgYXJl
Cm5vdyBiZWluZyB1c2VkIGJ5IFdpbmRvd3MgY2xpZW50cyBhbmQgd2VyZSBhZGRlZCB0byB0aGUg
ZG9jdW1lbnRhdGlvbi4KQWRkIGRlZmluZXMgZm9yIHRoZW0gKGFuZCBjb3JyZWN0IHNvbWUgdHlw
b3MgaW4gZG9jdW1lbnRhdGlvbikuICBTZWUKTVMtU01CMiAyLjIuMzMgYW5kIE1TLUZTQ0MgMi40
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvc21iL2NvbW1vbi9mc2NjLmggICAgfCA0ICsrLS0KIGZzL3NtYi9jb21tb24vc21iMnBk
dS5oIHwgNCArKysrCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY29tbW9uL2ZzY2MuaCBiL2ZzL3NtYi9jb21tb24v
ZnNjYy5oCmluZGV4IGI0Y2NkZGNhOTI1Ni4uYmMzMDEyY2MyOTVkIDEwMDY0NAotLS0gYS9mcy9z
bWIvY29tbW9uL2ZzY2MuaAorKysgYi9mcy9zbWIvY29tbW9uL2ZzY2MuaApAQCAtMjYwLDEyICsy
NjAsMTIgQEAgdHlwZWRlZiBzdHJ1Y3QgewogCWNoYXIgRmlsZU5hbWVbXTsKIH0gX19wYWNrZWQg
RklMRV9ESVJFQ1RPUllfSU5GTzsgICAvKiBsZXZlbCAweDEwMSBGRiByZXNwIGRhdGEgKi8KIAot
LyogU2VlIE1TLUZTQ0MgMi40LjEzICovCisvKiBTZWUgTVMtRlNDQyAyLjQuMTQgKi8KIHN0cnVj
dCBzbWIyX2ZpbGVfZW9mX2luZm8geyAvKiBlbmNvZGluZyBvZiByZXF1ZXN0IGZvciBsZXZlbCAx
MCAqLwogCV9fbGU2NCBFbmRPZkZpbGU7IC8qIG5ldyBlbmQgb2YgZmlsZSB2YWx1ZSAqLwogfSBf
X3BhY2tlZDsgLyogbGV2ZWwgMjAgU2V0ICovCiAKLS8qIFNlZSBNUy1GU0NDIDIuNC4xNCAqLwor
LyogU2VlIE1TLUZTQ0MgMi40LjE1ICovCiB0eXBlZGVmIHN0cnVjdCB7CiAJX19sZTMyIE5leHRF
bnRyeU9mZnNldDsKIAlfX3UzMiBGaWxlSW5kZXg7CmRpZmYgLS1naXQgYS9mcy9zbWIvY29tbW9u
L3NtYjJwZHUuaCBiL2ZzL3NtYi9jb21tb24vc21iMnBkdS5oCmluZGV4IGE0YjEyZWI4ZGY4MS4u
YWViMGEyNDVjNTMyIDEwMDY0NAotLS0gYS9mcy9zbWIvY29tbW9uL3NtYjJwZHUuaAorKysgYi9m
cy9zbWIvY29tbW9uL3NtYjJwZHUuaApAQCAtMTU2Niw2ICsxNTY2LDEwIEBAIHN0cnVjdCB2YWxp
ZGF0ZV9uZWdvdGlhdGVfaW5mb19yc3AgewogI2RlZmluZSBGSUxFX1NUQU5EQVJEX0xJTktfSU5G
T1JNQVRJT04JNTQKICNkZWZpbmUgRklMRV9JRF9JTkZPUk1BVElPTgkJNTkKICNkZWZpbmUgRklM
RV9JRF9FWFREX0RJUkVDVE9SWV9JTkZPUk1BVElPTiA2MAkvKiBhbHNvIGZvciBRVUVSWV9ESVIg
Ki8KKyNkZWZpbmUgRmlsZUlkNjRFeHRkRGlyZWN0b3J5SW5mb3JtYXRpb24gNzgJLyogYWxzbyBm
b3IgUVVFUllfRElSICovCisjZGVmaW5lIEZpbGVJZDY0RXh0ZEJvdGhEaXJlY3RvcnlJbmZvcm1h
dGlvbiA3OSAvKiBhbHNvIGZvciBRVUVSWV9ESVIgKi8KKyNkZWZpbmUgRmlsZUlkQWxsRXh0ZERp
cmVjdG9yeUluZm9ybWF0aW9uIDgwCS8qIGFsc28gZm9yIFFVRVJZX0RJUiAqLworI2RlZmluZSBG
aWxlSWRBbGxFeHRkQm90aERpcmVjdG9yeUluZm9ybWF0aW9uIDgxIC8qIGFsc28gZm9yIFFVRVJZ
X0RJUiAqLwogLyogVXNlZCBmb3IgUXVlcnkgSW5mbyBhbmQgRmluZCBGaWxlIFBPU0lYIEluZm8g
Zm9yIFNNQjMuMS4xIGFuZCBTTUIxICovCiAjZGVmaW5lIFNNQl9GSU5EX0ZJTEVfUE9TSVhfSU5G
TwkweDA2NAogCi0tIAoyLjUxLjAKCg==
--0000000000007594b20651963810--
