Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95B2388866
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511535; cv=none; b=rA0+Jn8o0ObX6y8OpIps2SOYaqB/guWkBysq6C0y+BtPH2vzY5nRqDI4j+rz15KGZeCv+5EFyEDJMslpOsNUHwWpYWQXA0ldVovJRyTCZO6+CAvSJQo2S6DTXabrJ/m2Mc5tCTq6VX+TIEScxye2mv+jGdtBgRnlCZ+h5b5iovE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511535; c=relaxed/simple;
	bh=GEEgh9rZXqQEtORnDSOhwDLRgRhASHENAUuVT99E6eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRUbC4A5DumPEQxC6WL2plFtGzHdOkGd9HyashZC6elVUsqdcngWFSeU66U0rScGfCnUZOjc8riep+HHhTM88EwYlttq25g5k9RLSJFcLR3SeIyTTWZifogcCdqRpf9IzBfrROlb0dx3eG5fQTp9XowVr1R7h88iAXt1+mNL8WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZnXRBRRt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gweUtAVo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZnXRBRRt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gweUtAVo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+/MdQeJQA1c6nmEaPWQ+X+W5me3IAq7zSNHpBdMxU8=;
	b=ZnXRBRRt1slv/YZuGe4MKLqfhSn6ERs1JvfYA2+qrwklPfeixdqKa3pIXYx3qA8HeZGEPB
	zSCVjMXRW2sN0N2LG+5JNV09EyMJ4AwwDkzTtQgLk/n7nsITrwZ4PDAq8y76IdoCbklztO
	T68Cgqbndbi8RBZ4Z6TMmjcKNmi2AsY=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-n8N37kdON62DoOzfZXzZKQ-1; Sun, 23 Aug 2026 14:58:51 -0400
X-MC-Unique: n8N37kdON62DoOzfZXzZKQ-1
X-Mimecast-MFC-AGG-ID: n8N37kdON62DoOzfZXzZKQ_1787511530
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7f4026a59cbso5004767a34.1
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511530; x=1788116330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+/MdQeJQA1c6nmEaPWQ+X+W5me3IAq7zSNHpBdMxU8=;
        b=gweUtAVo6j8bW0h3lHKNiS9m7iokKtel3sM+FHZW+0J+/NNTFZ/pqMrQhLlZ6V9N30
         LUJNqS/JQZgX5qD+Qnm25VYs8VFYHYXf8rUrwE7Q08Cr5Rswx0XPqlaGnVHuwShXVO/8
         5APdalXgidbfoq/Rj9BXEOIIQIWZ3ZHD4IgfdhJwNqmltyXC1eReVvkQo0SkB5CpVg2+
         tTbDJzJ1nxEw5CS6/XRAEgh0ck4LI4x/crFX+TmTX31ONzUaRmdRvSgPe8pRnCAvKxmV
         1mrxFXa6Bqc5c+vXg4Pj7UK0xIWg0NmRehCu3f1MQncfQDOAMrXHPb4LjpKEtTIHyqow
         ukbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511530; x=1788116330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+/MdQeJQA1c6nmEaPWQ+X+W5me3IAq7zSNHpBdMxU8=;
        b=DqLwVU2jROpEOUtbvS5TnlyZZHctXs88ryRI5y+XZW8q9e3ovjx4UHM6dsvwnbaN/z
         3KZ0xR2by4+YlsSRImaWhvrx9lR3FPsxXS602YyISYUZgEjDbnZRKA3PAE6mVBqpFrpy
         X+V3Bu2Jif7FwBI9w84kiFaPe2ER9lQpTnt1xW6evuDTKPMC4RqupisM7slssg85TT+Q
         HAgWmQn2kLH48wbTLcTslMZgh+dCbjJRnggfF1cvvNyfYlG88tc1QqT+KNrvxVO3WT7b
         WygblAS334V3QWWps6j/h093JRlhdChzlfo/NCfa0CmFPEDnCYQfmsFfjyjWGvoLd1QG
         xtcg==
X-Gm-Message-State: AFuF++lBT2PZAuZ2NgWibv4jHzfeORZ45993rsHIhXU+dOIxt+jLfj/+
	c42G/2omszWsO2sm3PVBKlbk0c23bIMLdBWzZ5vFqbX1KO6DHmX+66/B++mrslQ5YQzdvpgHFgF
	A4fR9+Bd2v3Szr4smmdeUdFFp1QuwhQvBqnZBJ+r4gNvpwIJlyvOFDTNmI9lhuE33j7aNRgLiLj
	FomOVt88hC5pN+c7+n88wPkR+nt6KuzgAggkzCSIRCHh62xZ0=
X-Gm-Gg: AR+sD109GJuBsZat65CGmH8VT9BttUg7Tjb7LFpTxg/x7EBvEclHMjGuc76kCBN7htI
	4qGS8aVaTZ3HTfq6Y4cb3rCfA7ABTT31EKxvtNCInxb2Atazbn7aHdw1V8EUv0CY2v+iCFqhZoJ
	/BvUo6VWSbUhekVj0M4ojWaRPRNM2g27f6WDp8nIaMIqGMCgIAQN4/7oMemimbz2nyH8DW1bfOo
	+Q6GKVx38OjOrmg7AIjySkFgZwazwH4TaIe+Bnu2A8Q6lt7pTWLSEYqTDjaHGqOgQgvVbb7Dt4d
	ix9QR18Qad0a64qOGSeKKVJy+L2aQGCJGycIpqn4oC/9gaF/YLiA/9Xls7kcdxje/khidhesWId
	5qCxdMBpaa8AgNUpQsB6VpEpaxW4OK9ICd882TQL8rWuhLzvT2Leups5g3J9voh8imA==
X-Received: by 2002:a05:6830:488b:b0:7e6:d0ad:5254 with SMTP id 46e09a7af769-7f4613cc511mr25379216a34.8.1787511530346;
        Sun, 23 Aug 2026 11:58:50 -0700 (PDT)
X-Received: by 2002:a05:6830:488b:b0:7e6:d0ad:5254 with SMTP id 46e09a7af769-7f4613cc511mr25379191a34.8.1787511529969;
        Sun, 23 Aug 2026 11:58:49 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:46 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 09/11] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Sun, 23 Aug 2026 13:58:05 -0500
Message-ID: <20260823185807.3115901-10-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When snapshot_array_size < GMT_TOKEN_SIZE, smb3_enum_snapshots()
unconditionally sets ret_data_len = sizeof(struct smb_snapshot_array),
silently inflating it beyond the actual server response size if the
server returned fewer bytes.  The subsequent copy_to_user() then reads
past the end of retbuf.

Reject responses shorter than sizeof(struct smb_snapshot_array) with -EIO.

Fixes: dcbf1c8af18a ("smb3: add ioctl to get a list of snapshots for volume or share")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 37c1144f3d57..77ff285ce1b6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2376,8 +2376,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.55.0

