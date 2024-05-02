Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC446768EC
	for <linux-cifs@vger.kernel.org>; Thu,  2 May 2024 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652088; cv=none; b=VRf3/B2OrfLiDbQEXkKNrQOUNTPA2F0XlvQ/1Nn8N2RWJ9pg+/ZmvXHegD8D3cD5Sf/zZNNEMUp+0GGTxIJ1fCqaOR8VuWhEY8Rbp/KwJp/tbK1A2VUj6T4yC8ZtS7ZZW2jb+Bh5m/acoiz35HtR6YIDZUPOhRjZjhrav3QDcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652088; c=relaxed/simple;
	bh=5h7sok0m8DjI5YsoFx+jLT1NBD5B2YuhY83DLe+cq6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p9UOXl/LAYa+AGTBb/huM+0CRNIvaWaxXGIZjW/6c6cIx/o4lLOHjG8Hw+P04HOPUoTszKN4K+7ct8DWIGjH5AcPgVchyaKAIKl26K6foLWKxEaBh+3HAqIYheAl2V7J1Qfcr2s3o1wQBLrs+rpYL+gdSO6X1o14gFlOKrNaKpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ee12766586so1420394b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 May 2024 05:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714652086; x=1715256886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sGAoqFrk+6nq0PTf89x/MjVnNXSxxNmJMXohKG6K0g=;
        b=cXirVq4u2jHqmAYRUjWiKPDeA71mrUIKNaMTk6tVIuAv5m9PN8uYgxNHiTXyuM7P/W
         RALdynWcUm6B+k7SQAjDpVXECk0kumiTeA4KQyPQg0ZjKIVxYr79s7mt4f0pfHqjjQsf
         7XUQ9+ikG5htSnisbtVUW5C2cBe05zDr1pdMaeRloyoLOhdDLBd6ECUkEwvr3gaKeRpW
         M+A8D3p/X4KdhNazleRI1mGrnVv9rm1k4LCIPika/t2KPCm1YUArjxZEQna3qS86r0tn
         znxkosRDLU1+PgiJYNPP/vSgxuKMXCd4Wbe2m7xn2QrEuUeW0Ni574rHruBC4O6tUYa2
         LMeg==
X-Gm-Message-State: AOJu0YzHM+q8QFDnC9tfEM9uGlEfFk0yeO0Lt6ojkHzWsIuFHsFTWl16
	fJUjJC/xpo80gj9gZs7xaCGEoS4ehjA4f4m/yu+mXufAFI4APwKJCMjdVA==
X-Google-Smtp-Source: AGHT+IGAupCS20UUrVHvjvFOYQf8S0aD7mpQE+LrEwbAT4VkGEzbcwvhooOJHnbq3DSTZLplQ8LGrg==
X-Received: by 2002:a05:6a00:2186:b0:6ed:21d5:fbdb with SMTP id h6-20020a056a00218600b006ed21d5fbdbmr3453178pfi.8.1714652085738;
        Thu, 02 May 2024 05:14:45 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id gx8-20020a056a001e0800b006edec30bbc2sm1069840pfb.49.2024.05.02.05.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 05:14:45 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/4] ksmbd: do not grant v2 lease if parent lease key and epoch are not set
Date: Thu,  2 May 2024 21:14:25 +0900
Message-Id: <20240502121425.5123-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240502121425.5123-1-linkinjeon@kernel.org>
References: <20240502121425.5123-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fix xfstests generic/070 test with smb2 leases = yes.

cifs.ko doesn't set parent lease key and epoch in create context v2 lease.
ksmbd suppose that parent lease and epoch are vaild if data length is
v2 lease context size and handle directory lease using this values.
ksmbd should hanle it as v1 lease not v2 lease if parent lease key and
epoch are not set in create context v2 lease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index c2abf109010d..b9d9116fc2b3 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1201,7 +1201,9 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 
 	/* Only v2 leases handle the directory */
 	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
-		if (!lctx || lctx->version != 2)
+		if (!lctx || lctx->version != 2 ||
+		    (lctx->flags != SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE &&
+		     !lctx->epoch))
 			return 0;
 	}
 
@@ -1466,8 +1468,9 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
-		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
-		       SMB2_LEASE_KEY_SIZE);
+		if (lease->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
+			memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
+			       SMB2_LEASE_KEY_SIZE);
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease_v2, lcontext));
 		buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context_v2));
@@ -1526,8 +1529,9 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
-		memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
-				SMB2_LEASE_KEY_SIZE);
+		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
+			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+			       SMB2_LEASE_KEY_SIZE);
 		lreq->version = 2;
 	} else {
 		struct create_lease *lc = (struct create_lease *)cc;
-- 
2.25.1

