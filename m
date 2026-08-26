Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA0331280C
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758345; cv=none; b=ZEgYYpczrvx7prdjaS2+mAoAI56n3edCTJc4mR2d9CVZrkpVmoVRZMERV1jrVPdFvbvh6MCjfI/o3USXl7oUatgAWnwYtCqjYtaXvEKFDRm9PbCl2bUDsZvIdmeiSghHYKt9svyUg4gDMSlFuuvmNVfAaa36veggDCxWrD6Pqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758345; c=relaxed/simple;
	bh=ymkOB8UMUk5U/Tsy8K8fpcj6cIsBZ2uNEJoBCL7v9V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEq2RyL4wePCuOyHN9utuvE1yXIVawZ3kGJDYFrgGo5sHbzs2Ujl2S1ISoDQoqFKL4k2pOtsoIUxublOhWKRDuRd8Qyp8iD8iXVooWzojTOl74BJFoMOOtAXCiHGEr0XHfUJcCGASy5R4rX1U3zEieWVV2dZ8JKlxtNllqzY3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+Gwic79; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mmc1a69i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+Gwic79";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mmc1a69i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
	b=F+Gwic798dheKBb15IFNSrxsTcagHwAdoIk8OekXtQoAqKdgQN1AROEVQmCTEdA0OrYlXP
	tirLbr00L2rcMHkuaHgcmtwYX2lEPIAyEdTzehrhIQbX+4hEaDpLTq9uzWxrTW9aj3uvbT
	6Op6yUrOipsM8r10fx9y+i2XXtYEeno=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-S-d35H2kMZWh2HNE1nkwlw-1; Wed, 26 Aug 2026 11:32:19 -0400
X-MC-Unique: S-d35H2kMZWh2HNE1nkwlw-1
X-Mimecast-MFC-AGG-ID: S-d35H2kMZWh2HNE1nkwlw_1787758339
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-836c2b00bbaso33414537b3.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758339; x=1788363139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
        b=Mmc1a69iCb5ESpjA5C9OZCIObEZaZKduLaFIXjod68Z+VsZ5Q6w56JMCdz8gc930Vn
         u4/zL6SYRygTs9lRKvTS8ZX/r0r2mfu+SuWLPWOz2D2jYoTBWCNMw9tYVYmO4XNm2Yor
         5PFADmOEILL7FYQjom6vD6loL/rBltWK+kI1serwbPFLW9O0CR6TgG172eHdPlPgrnTI
         FpVh4J/IWkPZh30BbgIEGuLOkjn37gKkk3DVz4rtiS9/diQ8XyJVrT7PjdBvtmS+2CtV
         dy+C7L4JJiiDeOQi+DV6oWN4EQTxFKhQE+MrQSMmGdFQY4qW7glPs7zqF7Z9DO01qTd5
         n0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758339; x=1788363139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=00oADfE3L0pXKHn0B52AvTIT7U/c7rXCUL5afdTYVxk=;
        b=I0HWpxZS1YDp2aTUE8DGnrEFHZVyA+Oxx4/UeJj1PWY2pFT97K3KkLJAEA2tLPk8YA
         uBXXW0zTKdXB06KQW6Fa0dv+9BvJtFsLzG2cEPXazWUpsTIGBU70z2c9LKzyQvbZiu9L
         I+UZiSpIK782KiDf4UQ/eRC5ABL2xTtU7dY3F5mIdo7GH/7Bio+hfOehGKiQfnNKSjwt
         atbPhgvK1ngDr10rofjrlqILkvxFt3RCJAKBkEt3vJFb1dHVIWz1m6vU0Z9xg8cXKWdT
         N1/dS+2edXBuC8eQJyThPLxVPC5geu1nAOsAOcX8Cwrk1FLogxuXfkSm9sFUlTjKfEZj
         ehrg==
X-Gm-Message-State: AFuF++mYswtG28OM4A6YViWFzpplfQ4YyBHeQdFPuW/cc9FHL/WGEUbt
	0D6ROLvNgdVkcl+CKZDwfVAAZ+VfrTw1nEguhitdDWWUTXMF/VIGtPHvOeTNke0vlz9wjgwDd8K
	Ilt9QuUsTQx1bmhNdxZeTrowYdU7eIEWM2YoOV5yCetSKl7H0iB75og79Bz+qNV5w0GUCSqPhSb
	PM4T0VgGyMxTuTxjVkpdCIL7BS5jLWd11AqyfnkWkO0b0DAKY=
X-Gm-Gg: AR+sD11areSRNAKGPBdpNJQn4HpEDDMvHpEVnw1i80++SsnPmhu0rvL296PqST4Td9u
	mbIsFj9GltkJ9Ye9T9aLjkc3zXHZLC1GnhWi7BPX8mxxOkNttmdGOgPQyts5gBePEixjbHof9Zt
	0fguvGAOvFWwOczc6WBFD2HHbMJeQutdYVK3E725dHehhhDp52MqbSzmBOjHDAj5KY10iHvAAmC
	48JdAaI+M8sbdUzNTA5a/2C3a45yKKVoegXVWPTXCFMnsv02Q2XOd00gelZDEqYncAFq2tXpuSj
	gsXH+Dzt54daWvGVYGKqADTEm047S7HqWMplT/OyW38x4X0jbZZmjJAsMjkQyI4i3UVNvsn4glR
	r2yYGhO9YGmUw28Qo3cxwi++7858ho/Gf7QfrqQ2wHMMxEB2LDiqTXK4sScPBGAmZHA==
X-Received: by 2002:a53:cd11:0:b0:66c:bf45:bc0a with SMTP id 956f58d0204a3-66d25666916mr2085825d50.11.1787758339239;
        Wed, 26 Aug 2026 08:32:19 -0700 (PDT)
X-Received: by 2002:a53:cd11:0:b0:66c:bf45:bc0a with SMTP id 956f58d0204a3-66d25666916mr2085774d50.11.1787758337244;
        Wed, 26 Aug 2026 08:32:17 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 04/11] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Wed, 26 Aug 2026 10:31:40 -0500
Message-ID: <20260826153147.4112943-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dfs_referrals() checks DfsPathOffset and NetworkAddressOffset
against the buffer end but not against sizeof(*ref).  An offset smaller
than sizeof(struct dfs_referral_level_3) places the derived pointer
inside the referral header, causing cifs_strndup_from_utf16() to read
struct fields as string data.

Require each offset to be at least sizeof(*ref).

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/misc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04..bc7cccebf387 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -787,7 +787,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
-		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->DfsPathOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: DfsPathOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->DfsPathOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}
@@ -801,7 +805,11 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		}
 
 		/* copy link target UNC */
-		if (le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->NetworkAddressOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: NetworkAddressOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->NetworkAddressOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}
-- 
2.55.0

