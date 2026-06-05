Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6924E38E8D4
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2026 04:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780633825; cv=none; b=CwHlVrQjqKcHLchh4zRlLcG0gtV6z4lC3ucgR8UGWBXq1Po59E5Z5zovQKv7bWZd2r8mtUywMN5F6I1gbwqQQTqMHmCBsZOQwsQaf3v1ps337y3G9YSLi97SS2NsVoGHMwbs6jsY97qN4j2NAJ/DYZqAHqZl8+nsnfl7DKJ7g+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780633825; c=relaxed/simple;
	bh=UZuK36PdajGvvnVo7gqEzruJ6LWrsxaDKanPqorC5Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tx86EaGjoin1IzyZI/XWoqVTsLLNP9Q+Wcmtjq49ejeMezPN/fOs5dBWzEfZo2zIHLWtsj9p+h8MOLQIuTu2nIc5gi+Pz41Euanfw0IiwScLvsWiwUqvoXWYGKgFEfqEHbYCgnAgGAEDuKMKGxxv5kyW/1DS/j9uz6RLPWLQfWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O54OLNk9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O54OLNk9"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c0c3543590so10472705ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jun 2026 21:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780633824; x=1781238624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6ujxSEDq4R8lp2y/Xo01gcDdYjorcuEfHYNTccxz27Y=;
        b=O54OLNk9UsgFHvqQGrwzateTaEvxTb74r4A+NcHV2LGqG3c6cw438mUUtNivfqzvMS
         zwKRzDd5JZac5s1OVymta5PjgguHEHMP6d01b2mNmsDH1ONJMA4jMrZoPMxcXvYCXKEN
         C/pAgeNzqWFkQajpfySWfIJqYMrCqEPFcNyHk8e55dl0WRaEvBKfkZEBag9IfjWPsu9O
         DmIO9hVcZqrRLN9iZdtxRhI3ti4v990FXEiKyveqcAcEqx6z17jusxgDdFNSBcUmPN6X
         xWg3jAya2ZVoNo6eFE/TIDvVVnZTQrQEBQudkdxZdDbUs6JOhewp59LPgsw54NW33eSy
         LhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780633824; x=1781238624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ujxSEDq4R8lp2y/Xo01gcDdYjorcuEfHYNTccxz27Y=;
        b=XGSnNgUfTOu0MpMtBIavkJuQg4kCioomrFcrQU07+FbANqXe2opVAIerG1HSDFX/vK
         c4IgKFeuBpu3V3KEuot6lcHXyinBE7x8RdnmCzkdac/D53T5vpwmI9dnnwXJUkVKlnEI
         zt2U3Iv5yKkfop8qJBskuE0A1W/3GKZdSTx4uPUo1rUGyXUuyRXre375JDZeDnubNaQB
         SWERa3l99gvnfzqvtFz7eYqW8E9m0yYkFLDcT+0LnajysAXbRCIPLmDgDsZcEV9e8AA7
         caRyzz+jvy8/9Z8BM68seds3/7+vQYiUL1rLsgoH2+6e8E2SEvzUJ8uI5nIQhDkWInAW
         /hzw==
X-Forwarded-Encrypted: i=1; AFNElJ8Uj16Nh0cF+SY+UQr94vzBpzdVcNuR31cZMpdRRZIxOHqbjybbRvwNNiyKV9GM/5BaBNP7GKBgANtM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtngfmz8lZzICVRKUFoESxCr6G7nyIT2peKgtKK+tRFwf+NxFo
	TKhm1QBzDs+OoPfIicC2QR4DYwG0JHplx2C8A5yfHf41mXz/O/A+JRGj
X-Gm-Gg: Acq92OF46rSZh+1KJt/G4HclpPvIXnZYt87OMLSKxxXJGlRLUTm5g9LYMRKOojzmNrv
	LvWgAGt7+PUAzpuDAirSQze/WjxYcmoZdtD5tfwFHW2aCUbdzDZStWPDU7q4gnCYr/vEYvzwXQn
	TOQM+RiepZZSFRH40VvK81lwzI8stJDEnQqAqYNXNl11c9HehvBOIQIVeIoiFfvPPc0hpaunLke
	0NVUJtLS5e0seAG1eneRG2+k2uK6ZVJC9HqmmYwvGmSPa48xH1YnKS1awbov6k9ZfkAbvVAbELF
	OfwVaXtLLbVxed/DQZlZWoq4TlXTtlE6i9qaFkUEXMHAMY+JA2H7mqv2kDCB01+XbKtUFQewf1+
	pJpIE/EeuYvwgPTJ3RYcems8t4wNOFvcMyPr017tzCoJ932TUtXo6HT+JCn67k7IKbCWfv+7GYZ
	r16bgUQlqUtLtajGcp4k6uw2bBmi74PJmUkbfbil0Cng==
X-Received: by 2002:a17:902:d58f:b0:2bf:195d:21d2 with SMTP id d9443c01a7336-2c1e7e44e91mr18339595ad.16.1780633823560;
        Thu, 04 Jun 2026 21:30:23 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c1664ad138sm78825415ad.82.2026.06.04.21.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 21:30:23 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] ksmbd: fix use-after-free in same_client_has_lease()
Date: Fri,  5 Jun 2026 12:30:16 +0800
Message-ID: <20260605043016.1440866-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

same_client_has_lease() returns an opinfo pointer from ci->m_op_list
after dropping ci->m_lock without taking a reference.

smb_grant_oplock() then dereferences that pointer in copy_lease() and
when checking breaking_cnt. A concurrent close can remove the old lease
from ci->m_op_list and drop the last reference before the caller uses
the returned pointer, leading to a use-after-free.

Take a reference when same_client_has_lease() selects an existing lease,
drop any previous match while scanning, and release the returned
reference in smb_grant_oplock() after copying the lease state.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/smb/server/oplock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 0f5c18520eff..5e717aa03446 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -528,7 +528,12 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 
 		ret = compare_guid_key(opinfo, client_guid, lctx->lease_key);
 		if (ret) {
+			if (!atomic_inc_not_zero(&opinfo->refcount))
+				continue;
+			if (m_opinfo)
+				opinfo_put(m_opinfo);
 			m_opinfo = opinfo;
+
 			/* skip upgrading lease about breaking lease */
 			if (atomic_read(&opinfo->breaking_cnt))
 				continue;
@@ -1237,6 +1242,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 			if (atomic_read(&m_opinfo->breaking_cnt))
 				opinfo->o_lease->flags =
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+			opinfo_put(m_opinfo);
 			goto out;
 		}
 	}
-- 
2.43.0

