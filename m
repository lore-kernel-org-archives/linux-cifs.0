Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEBF28D8CA
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032316; cv=none; b=RFbjamE6B5h6t69H4Qm2nCnesDF0wrLbKd9AFR5bLwaMP/ZpWnn5hlo40V/xYgezhJc3P1D/hfv48lWAZXfIz8U2QuD4hTY9kKqlLiz4wUXVhDGuaC591qA3pR+qAc66SsWQAHzzOvXz+mHY+kgG66jhosCCSRqxvsxDRdcNlyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032316; c=relaxed/simple;
	bh=YELeShro5fXtSyacyYrYKl1ZEJUv63ijZB/yAcwfMqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2/kQW8FYB9PhBn+coWUpm1DZ70ZAKRHfzHh5Z4Ev4yhGBSUFQBIVTnvKsGI09+GoeQzxy3Z5SHSTSJayFX3PE2ZOh6KgVw4FoMG7VcUGCwEoUalqCsS58Q/VXMspPOSfFweTKVoIvhs6Q235p2wAy6T96ZpKzL4wbgGKMeKbDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RIxgUIYI; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIxgUIYI"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234d366e5f2so85200545ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032314; x=1749637114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AezYNpJ3X7qiilbaBGJpxnQWUebbfJ8rqyhbYLVy6Ys=;
        b=RIxgUIYIIDjbd9g5jO7cw0AhszNVcxaxDw38el4lMgOcoW2B4b8kbFZdXtlLNSVVN+
         97DInWhSan85KMhpQNNOrFjFxx6aZQEPlJj7MgMoGtMmlK/lQ4qkAuY+039qGqyqECYq
         VL4Kj6QAK3YKwKocNViDqBhxdF4o/JPCrclBVg8eefXV7pbh/o9qNXYv/vSACWff2evh
         Bnptey7ldpxQ4n/bhJCBlgPZGofNW9CeOIUKtn0DrtSqgdaMsIBCjZcjmcaRrPaI+lxU
         hbE8PJixtCKNVJdYPgwR4kBxxrqHewzcGyQSWehsSGpkB5C3MGPi5VTZ9rzZdPukC1+H
         Dggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032314; x=1749637114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AezYNpJ3X7qiilbaBGJpxnQWUebbfJ8rqyhbYLVy6Ys=;
        b=HfDVq2pyjXRMdNFkpfRIw9YeCbtKXCqpMIaVUVOvZ9xNuKjlnXWdLk6EwrLLyswlZ9
         aNdJXsW2TwRyw7/E9/IWnhSxo3R6o+rUbNehmGyKHzvG0Lfz6BpsyYMqrJzn0722ey20
         aIYRZb+V4DoNEB+3liVUsgkafB6LK4VNnMmYBSFCSWl3Uk9oCAS4ZGgMvOLibM3N8VPH
         wJdfHlBmh2Q6Wf+7bCFsIOA9IvkNWql7uZa6g0cO87sh6/rM19EIFNj2QGXVKQMdrAkN
         aLdHPjz6f7CsDuRcM5EaAjYsvPW3k7Qv/+I+qkLobPG1HdEY8qpN5o8SLU1umc08Vx2O
         5ToA==
X-Gm-Message-State: AOJu0Yy4ZcwBH7WJmPR5ocmnrCWerMKccUcE5CNnnRiVZQqck6b20jXZ
	rFKcNx5m+tdE9snrFJhIc4mZsImVIjHeC7aet7u33QmkU4ESwvKi95tIJRGLLrH3
X-Gm-Gg: ASbGncuY/mTnGXHJsDQg+s+gkP1oZItWD7/Emc6mXK95bEmLcnSn+s2bVYtBwbDB7Uo
	cyfnwRoxrpC2cVMD3yCoNuiktTLmxyYXTwxWHZ5qkkPCcAigOhBv6nZJDC4pXT3vkHKUhE5tsES
	uSyAIOrdFYtfS3laUtY0KpT0/FfhPAMfJ6EvAKojEfwig/vUYVHzxstlvYvEzDM3EAfepoTqy9S
	p6CiGi3DIDYyGsCinSLeusLr0Sm86eP2OjsSj4m+hJVqFMeMDm5SIIh1hJJTW9y2g7K6/oNNze2
	Y1lnqGF8q2Oi4oaWCr5a+dIFtrXrYXRZieILvVWF81dwQsOvpm3UcrovLZU/Ktb6FFxeh+QE6tc
	TKlY=
X-Google-Smtp-Source: AGHT+IHK7Ebs299XaepQmvU4NF9NKUSvdfUheARxoSjaQ+LLdHzuIP7cZiTdtWTzoHF28rUWQO/UCQ==
X-Received: by 2002:a17:902:d4d2:b0:234:f580:a15 with SMTP id d9443c01a7336-235e11292acmr29629175ad.14.1749032313999;
        Wed, 04 Jun 2025 03:18:33 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:33 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/7] cifs: do not return an invalidated cfid
Date: Wed,  4 Jun 2025 15:48:12 +0530
Message-ID: <20250604101829.832577-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

open_cached_dir should either return an existing valid cfid
or create a new one. Validity of cfid depends on both
cfid->has_lease and cfid->time to be true. However, if has_lease
was invalidated by a worker thread in parallel, we could end up
leaking both a dentry and a server handle.

This change checks if the entry was invalidated and returns
a -ENOENT in such a case.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index e62d3bebff9a..94538f52dfc8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -199,9 +199,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/*
+	 * check again that the cfid is valid (with mutex held this time).
 	 * Return cached fid if it is valid (has a lease and has a time).
 	 * Otherwise, it is either a new entry or laundromat worker removed it
-	 * from @cfids->entries.  Caller will put last reference if the latter.
+	 * from @cfids->entries.  If the latter, we drop the refcount and return
+	 * an error to the caller.
 	 */
 	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
@@ -209,6 +211,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
+	} else if (!cfid->has_lease) {
+		spin_unlock(&cfid->fid_lock);
+		/* drop the ref that we have */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		kfree(utf16_path);
+		return -ENOENT;
 	}
 	spin_unlock(&cfid->fid_lock);
 
-- 
2.43.0

