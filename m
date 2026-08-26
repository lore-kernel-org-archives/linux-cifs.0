Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F407E3CDBA5
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 19:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787771467; cv=none; b=Fkfdybk7XTN7qFMRo6FhrqcdEhQT7ecTnfAUzbF59wKm4Ka4hsDt4VD+L/2brSiq4qWnBj4v7qPxO2B8agf8JeUV7ksAjm9i+soGTW7+7i0p6p/vcJjC2F1xiRUFy7aFeYeFGpA9ztx3CDgjAOHGrIRxLl2GANbbc4lzStzGR/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787771467; c=relaxed/simple;
	bh=hA8SRvFuua85xZ5A7WL0pI+8AgdAGDofjCeAaFmQkbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYlBdhFHI4/EF19S+9lsxmgzU/bYyxH7O5q6w8uKho5SesnvqNVCmVqDN9IRyFbNfWeRj16mdfANQehgWYqK0WoFhh2LJ1XDqz8r6Q00ZRAQZCgBgcdawNEishr2BqjXkGoQ9zzNhM9cloCLmQRMiLpsoA5s1gIFteWZZ5Ste6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUE+NTQ0; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUE+NTQ0"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4518ad44e83so1484591fac.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 12:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787771458; x=1788376258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o+kYzMea9PvaxPnoMNSVSpZwSGyo0Hz87g0xc/2UNKw=;
        b=KUE+NTQ0U8SGgusgxjHltiggAY7AKzdhzvvwv/AvI7fi1bZvlkyG5TB85DXFbzvv0w
         ANr5/McCw8/5EYfON5nyZhO36Mrk+3ya8ptetMI4X+HEU9Oxb2nCOBAoPfkt0rjdvPmo
         5iQjp7CMYbdcwxcxfAyB4fFZNx9yZItOGMCZ8fnloG+DK0Eb+oVMQuT81Xd/y44mF3OS
         U7rXHuuf2svxkUfV6ZzQ95V5O5S2dtgmByl+UYj/ddWjNLzOlVBTnpmRBXka5gTt+b4Y
         JFgg5YqjROfERzw0SZIp9Syaxw4NX5DoIxLTBB/+SUtvAy8LAlDe7LEyMXm0mCin1yah
         YEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787771458; x=1788376258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o+kYzMea9PvaxPnoMNSVSpZwSGyo0Hz87g0xc/2UNKw=;
        b=B2Q7OB47vEYuRPW2O/+i8N++3gBjm8epCqSoX39PEtp0cf9cuCRwBblHi3Bs6XewT6
         PXAYs7Fuz1IaIRnj6gWlgcZhoG3qDaJ9zAj3NDVHoZI10FkVaVAdoOxKLdtW++AOmv1M
         shaPBO1CD4t5OlreW4T+NK1TtdQqg0Gr51+6O3yYMbZGMEhm+mQRTb/jMZ2age7sWcmZ
         unLdL8A+QvVLsRQKBublPR26Ui95bdZcUG5bt+XB2Ve2o5ydbieUhZk1iIyI+a2wA6We
         KyJe2h5SmUqX8uPH5zN/pnLVMkoHQXvNAuMQoqJm1yRwZXqNugaLdGe1TuQOKo4E780S
         A+tA==
X-Forwarded-Encrypted: i=1; AHgh+Rrz53yDYR0u1AIgvFLIpSVSQ1H7jptMECVjzSe36GjQE8HfWXxXE1T5gj1siJA6VoHsTPa4BoB4HP9l@vger.kernel.org
X-Gm-Message-State: AFuF++mfx7x68otelCyfWjxOcNx9l05PB4MGxy52g0d0evX/z5W07nkl
	JJ/kWO2yjR9TzgCICmsLepDN1qt+0rdtynEv5pskpITB0YzG+OMBXCwC
X-Gm-Gg: AR+sD104rnNr9jvwizd6Dz6gpgglM97oljEm1iDUOiPh6PVv2zcjrSLIgEoGsYsZGaG
	NjyLMuy3r5bhoIlER3iJS9vv+LzRd/np0fZSdfq4AdfJdQgpfFRtbKR7Cef2ejshS8E6ivy/jV7
	kR0dLVREdhshgo/q/AIBgbh4tde2DUHelwkjwWXBTCzGIX/2STakvUrPYlB8jx6St/A3pIFREpL
	tT9kFxSOQ+BmoPw6FGaVMjc329KOADgH4/oc2YZfUHfOVClp/O+gutaPsm4F8FQQZn1+vfW9c3q
	jKYa1IziLdnoy2VVJRWO/rgdjrrYpGm51AMgdbC3vN57i21WrH3zvdDRTi4Et/AI2l+sIKtsZhV
	kPQ/JIKjb4vXm8dqAln+jgKxAfFPKeGRXJWrsTuPbWNrHyhTthor0A66XcCNcVjUxrG2rcY3p8p
	bK+NV8MxhLE51FWGdu8vrTa4yen2qtHHvT24wwYvb+LZNPqs8NRnzOAa3MlFPiNQw28EyS3eXBj
	DypPg==
X-Received: by 2002:a05:6870:8326:b0:45e:9b66:7175 with SMTP id 586e51a60fabf-4659a399422mr9554944fac.16.1787771457575;
        Wed, 26 Aug 2026 12:10:57 -0700 (PDT)
Received: from FredPC.lan ([2600:382:3107:46eb:31a7:8fef:9fc6:7e8b])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-465ad9ecc2fsm3060369fac.4.2026.08.26.12.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 12:10:56 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH 2/2] smb: client: prevent out-of-bounds dfs_info3_param access in copy_ref_data()
Date: Wed, 26 Aug 2026 12:10:33 -0700
Message-ID: <20260826191033.162320-3-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
References: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, copy_ref_data() assumes that numrefs > 0, and unconditinally
accesses refs[0]. If copy_ref_data() somehow is passed an empty list,
this would cause major out-of-bounds write and read problems.

Enforce numrefs > 0.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs_cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index b0388c460499..b51c8355d73d 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -389,6 +389,9 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 	struct cache_dfs_tgt *target;
 	int i;
 
+	if (WARN_ON_ONCE(numrefs <= 0))
+		return -EINVAL;
+
 	for (i = 0; i < numrefs; i++) {
 		struct cache_dfs_tgt *t;
 
-- 
2.53.0

