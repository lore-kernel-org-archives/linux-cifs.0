Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758004;
	b=sH8L0wvLsnhLXzHLPoCnf7mSCCX7CbmCVRiNBYLF/Lva34XHm/DsCdFFaj41gYM4C3jO
	 e/TxHOljbaGmcruCnr+cLOUN6Ge/YPCzyBzqh1FXikM3sCQXiiczMkczOdJUXKyDk9GFC
	 REMXR8uwV6zVo5woVQnT4QTshBBgv8jvAiD69rgMAY4+hn71ZvOnyJ9zcab8qgM29XjZR
	 c1+6///oQnFfwNnhHQ5Z3zUPdsv3jWH/sJiaJ7hvQd1MZu/dhpUDFKYWwFTkFBi/gxZlo
	 IFR1VQ2wUtdsVYd6uEUq7ayr+Klgq93G9PBY4X6jaoTcTVkwOt5ZOa6VNsF7e7BBbzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758004;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9VItWmi9UHiGij/i4Du4r2xIwo+QaJVFaf5QD6qzlQ=;
	b=Omu6oQI4Jeeg4NbL49dZNhIy9rn12cqLswMvD+6+n6aRPONDJGk+TF8nJZVF2QgugRqO
	 yiViDYnInpBjYNwJv5AufRBiDt6EK7cJ+X/ExnnmJuuQfo0I/7Kga5tFRQUmaGqk9L+Wx
	 tphCJNoynE+4IFOG1qluSm7ZstLhuykRMknXHEwrVSBbZ0QDeEPgPEi4Wuaiby5UY17cq
	 HugPYgcLZYJV2PFqPGGRzDloX7w4kI7kbvbtMsDGStzptyB+i5CgI55EJkrGwlqMAbrs9
	 vmEES1/Gad7KrpvD+4qvptpFD78hjuyBXHObsP8F+YZFZnDmRqMjTshETU3MpY0lJEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SuIlweFe;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C37D606A338
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 15:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C37D606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SuIlweFe
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso945400f8f.1
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 07:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794758003; x=1795362803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O9VItWmi9UHiGij/i4Du4r2xIwo+QaJVFaf5QD6qzlQ=;
        b=SuIlweFexL5SYa9O7lC+ikAmwwOEAqre+cYxlWzMrIdJTOVAcTVJLVRXmxYYk4v5Lb
         ZuvEd6pXpS7BfGgB4m6LdBUurkJadGlVGJAg7RvxZSHKhxAxhfJt/+PFTdPmHuQD+/Vv
         ojve3UhGaj8ZAOO9E/c/JHeOpfvd6wzMJNf+ZZ67sedwDyrR9z5IqqbPQdgP4FFh2kzN
         5QPp1PS7F7ZV/xPoPa9NlvfQ9L96fnLzpSJy3kqkmMitzYwwIJhF/+7ummjrLyohxFoY
         f6tgZj82gD9W/deAG9w7R13yhHsOo1nWLOj8T1MZhgRzRtZGXOVOtaS0ORyPRTg2LpeS
         FN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758003; x=1795362803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O9VItWmi9UHiGij/i4Du4r2xIwo+QaJVFaf5QD6qzlQ=;
        b=hchz7qPH+Be+iZY7aw+XIlXkW33G/kBRetC7H880KXQIYG84CVwu1+vNcfzz82DsTN
         Rtb4NI+s4KTVRq1UInAd0DPgSErpdzHRS3gnKllatY5l+B1OXLfTfnrZFkp2yNjfRMyb
         hhMv3JJlIXVaK3V4QMQGNioNkqwdeUEvpcy54smtb+saDsNZOzhTtaLj58G2lIRtceDu
         pmzyJkaIqCpxakDGIS35y5F77lkANMo1sX3EogCCkJSjyglwTR8uBfjcv/uqj++3Njlz
         6kGPzceYFbtDpXcj8RZzdvDxRVW3KRzzcV6Exb0gU15C94iFQKz7AYs3TvTEtGTZ7DO4
         2jqA==
X-Forwarded-Encrypted: i=1; AL+hErFimqdk+tBl7bd72BoNoc0/8u9lzDjcL0H2/wk5tRV4UQIqrMPhj5hX6/SibhKIvjDhNxbAXmNG4NRf@vger.kernel.org
X-Gm-Message-State: APuU4Z+ECM7BVgTyDucY/HecjVBAai1bKjB8N+wtQE1knv6S7m/qnXbe
	C/ayxbFLejS7o1CYzrkCe+1ERJJlGXGdk1Y0fD6ROtCOu1DOyPP1E877
X-Gm-Gg: AYBFou2QY6qI0pw6jqZ9+1DV6EACDYpTK/Ff88pwHx6D2wS8YChKEEWXneVOwQCGTgm
	c7TsUN/hEyOZZKkkB9DLMBPhfakmE0ygputMs1UaQhbTrX3iWK7FN+18OCjZZUsa/Kz2IrVwlbE
	8v9Ras02QxMnFQpM04mVwAYoW3Ndadtxue7/SVvqp24SwJH3FmQ0IaYdAJhi5f0YZWkBbxr297r
	bBuoyVx8a1n7ZXdZCIz6wSpp1QSk4p0kO7oRRSpoZ/Gbg39NCPlSUPyoCv8jRFnviguLrC3R7vh
	EPQ/EbfuiOOCLqrkzra5ebVI/QIIfFRb/k+ajmgjsolv1kW3Yq2KkOAbOMqMfd7tYetGOpKHZH4
	2WnHT6WewgAFQS75Dut49KxsBQm0sbPCNBr8Li9QKTl0/vR5pZ4SC3P55IN+e851SPFdw2eZU/4
	9EZ3yn3xDWM93jeIBKm1uwtx3xKVnpygTa7jtbwaMfwZwpb90Rb+NygHO60M3NpVCqYrM8zcrBq
	KVjgocTZq08AEdAHpEQt264qOeFkzjQyDJztj4rgRzJ0KU2A57a13l8meKsJJf62HF5ucDsHZj9
	mReTeuHO6Unu/Fha1EhvNABy
X-Received: by 2002:a05:6000:1885:b0:499:d9a9:5158 with SMTP id ffacd0b85a97d-49c727d1e47mr16775237f8f.31.1794758002517;
        Sun, 15 Nov 2026 07:53:22 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f7828a4sm17215084f8f.23.2026.11.15.07.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:53:21 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 2/2] ksmbd: decode version 3 fields in ndr_decode_dos_attr()
Date: Sun, 15 Nov 2026 16:53:08 +0100
Message-ID: <20261115155308.415734-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115155308.415734-1-koray.fra@gmail.com>
References: <20261115155308.415734-1-koray.fra@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When decoding a version 3 user.DOSATTRIB xattr, ndr_decode_dos_attr()
discards ea_size, size, alloc_size, and change_time into NULL. When the
xattr is subsequently rewritten, ndr_encode_dos_attr() writes zeros for
these fields, clobbering their existing values on disk.

Fix this by decoding ea_size, size, alloc_size, and change_time into
struct xattr_dos_attrib so their values are preserved.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
v3 changes:
- split out from v2;

 fs/smb/server/ndr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/ndr.c b/fs/smb/server/ndr.c
index b5190528340f..1376d5a59fc8 100644
--- a/fs/smb/server/ndr.c
+++ b/fs/smb/server/ndr.c
@@ -271,15 +271,15 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 
 		ret = ndr_read_int64(n, &da->create_time);
 	} else {
-		ret = ndr_read_int32(n, NULL);
+		ret = ndr_read_int32(n, &da->ea_size);
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->size);
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->alloc_size);
 		if (ret)
 			return ret;
 
@@ -287,7 +287,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->change_time);
 	}
 
 	return ret;
-- 
2.56.0

