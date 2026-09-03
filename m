Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D8B230BDB
	for <linux-cifs@vger.kernel.org>; Thu,  3 Sep 2026 00:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396587; cv=none; b=Ocm7zSLX8qnHvmBK59TxYiYWVq64NHFbvNUz+f0X0r70XcNEUQoevUMmrNSAzi2e9ZIuFBWjbUAyH2M16O4wQSrkQG/bIJ7sDQBEquT9CNborJJpY1HOPaRaC00IdGVLUCdFYx6V0GoR0wZ/wSYqMl5y6rGhTKp6KhKJ4e7ezNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396587; c=relaxed/simple;
	bh=V61jU58dWmh9JU/HwKfKCIjKKdtyH97DAWiwdtm7cpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cAClKouoP4jpIra4qj1JZ2sv4bqCU9ugqzWIBXSFPXOoZv3+Uyu+qXdwCaN1A4zRH/4KUrR3F5EFHNcMKC3nmgHNxctgxxGJRItqjvDZoGc4eXamUyToQarvz8YZ01LmZQWDpVvjoPkmbE7batqjThfRUqYHgalP3DLBQFy1qCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRz/TBgC; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRz/TBgC"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f4f3683fbcso583962a34.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788396585; x=1789001385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJg4fEtRIl54wQ0ZY6Uj39EgnebExxBTWGzyjxtO7Og=;
        b=BRz/TBgCd8/7KIL0T4VMV7aUkOvtVUPs+74RNw98v4eMSeIcPhmQ0n0qiiro+RGhaf
         ZzUpX4XW0YiH8IKHSF25Wr2IEX+1MswJOv4YGJL1yL/o3sW35XTVlDRdcb01ocnH9lz/
         UAr6PuwXmztHhpHkgMSPtq1JQYBzI5hPVgWh3BEf32tYqzC9m1Xaoy5BTLVcNe2JRkNg
         51rWaGcqknYRPqpr7mwwQoFd634zVVp6YdcU9MwRK2scCoVv2y5WAUXg7BIGPT3Ke4zH
         ICD9PdUTeJWJE6Yi4LAZIMwMM8LQ+RmG4fuJkIOrQCKZNRP6+sh9ER1uhzCR75Eu/VdD
         IzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788396585; x=1789001385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJg4fEtRIl54wQ0ZY6Uj39EgnebExxBTWGzyjxtO7Og=;
        b=VERuTHNcZOtYbLzmcFC0p1/8w01k2gCPdwclJPdkoLdJF3P7P7LzNw5uLvc1FkhcN6
         1A2y8K7YCZg3PllxcGhUO/FQDauiWCFdpFhbV9DP+ZRft1FE5kB514u+MU6adyVgrxAO
         0O4UitHcfO3QVVYw9sdVwN/tNt049e20npVe9EHohlmhRIBLNRDsQpXuVXIuntoF4f76
         Gnsa8S9+dyRrgeFcZaeohO00nHGuEvw/wEHu/hey1bfDMDKYBi0k9Ux1K1ie5KgpYWIC
         j3L+G0FqSnpEdm4NAgw985/NomRuVJPqjy0odEuuzA4l+72ayVKceoBOam04yv+vdNxL
         gzLg==
X-Forwarded-Encrypted: i=1; AKwUvBxSgRx/7k3QENlouArcMLysj/IaxS46lIcFJ1aEM+E82ERjnq/W2/6ZZ5D/xNLjpp/v7Ns2cvIaqC14@vger.kernel.org
X-Gm-Message-State: AFuF++lgA4HQKrV9jQOyBaVAwD4drkoKj9DXm+fHXYF2mt1WGGdL/ojO
	ioqrUEQYkQvkzwAxOmyKOu5LCMCLZfujXzBGLHMvQYiIfGuvdvJnyJd9
X-Gm-Gg: AYBFou0s9KhfVymnFT04nAup50xD3TNLUT/AwoiB1njmiR9lPHGvhwWUWzU7zBnEYpB
	7rS+D8e/b77AniMjkh/PQ6+EmVqog0Z6z2cGTAiWuFi7MGUd1+d5Bu8cufMa5MHbpP7S2CHQbkh
	r4beaHTovMzSiGYozvM9teoU8wFL3PMZBhrEyESD9hCPxE0Mn3uATWtfdsvFQWyc3mHlbhDKMqs
	hH1cH9IJB7zgZK64d8OfDPEUCr/GEy1lUqSUGnXMDcvQGwf503Ml9LlXyzwm7ChhRy9Pvmvt+lo
	iHKg5j4/FVbl+tnbsRSGprgrq5CzmKGARx5tOoVp+k+uC1LHXJyub9qr2CCzkuTxmMyeJ0jKsq5
	7/ncdFbmqAig+rI9zpMPHm8uwlo8r8XqRzFCapbSw0DI4CDKIP4UngPHb7rNYVhaHOqVivOnulI
	Xdp/d98WAKzA+815uam6wK+FeaQcXOo9/psOeyylzbITPiUmB9UuKL30Q5rrr4/u1FkH37eJr+Z
	60=
X-Received: by 2002:a05:6830:230c:b0:7e9:dc11:5920 with SMTP id 46e09a7af769-7f908b27acfmr205481a34.8.1788396585093;
        Wed, 02 Sep 2026 17:49:45 -0700 (PDT)
Received: from FredPC.lan ([107.116.101.17])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74caad7dbsm3488138a34.2.2026.09.02.17.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 17:49:44 -0700 (PDT)
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
Subject: [PATCH v2] smb: client: fill cache fields after populating cache in copy_ref_data()
Date: Wed,  2 Sep 2026 17:49:01 -0700
Message-ID: <20260903004901.135233-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In copy_ref_data(), struct cache_entry *ce has its fields populated
at the beginning of the function. Later, if alloc_target fails with
an ERR_PTR, free_tgts() is called on the cache, leaving the cache
metadata populated without any targets. Critically, this extends
ce->etime, making the cache appear valid for longer without any
targets.

Also, free_tgts() does not set ce->numtgts to zero. On error, when
the cache is freed, ce->numtgts is not zeroed, and other cache users
may attempt to access nonexistent entries.

Update fields after copying targets to prevent partial-state updates.
Set ce->numtgts to zero at the end of free_tgts().

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
v2: (per feedback from Paulo Alcantara)
  - Remove redundant ce->numtgts = 0 in update_cache_entry_locked()
  - Drop patch 2/2 as redundant
---
 fs/smb/client/dfs_cache.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 86dba25b7a5a..611e18fe8204 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -123,6 +123,7 @@ static inline void free_tgts(struct cache_entry *ce)
 		kfree(t);
 	}
 
+	ce->numtgts = 0;
 	WRITE_ONCE(ce->tgthint, NULL);
 }
 
@@ -388,13 +389,6 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 	struct cache_dfs_tgt *target;
 	int i;
 
-	ce->ttl = max_t(int, refs[0].ttl, CACHE_MIN_TTL);
-	ce->etime = get_expire_time(ce->ttl);
-	ce->srvtype = refs[0].server_type;
-	ce->hdr_flags = refs[0].flags;
-	ce->ref_flags = refs[0].ref_flag;
-	ce->path_consumed = refs[0].path_consumed;
-
 	for (i = 0; i < numrefs; i++) {
 		struct cache_dfs_tgt *t;
 
@@ -409,12 +403,19 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
 		} else {
 			list_add_tail(&t->list, &ce->tlist);
 		}
-		ce->numtgts++;
 	}
 
 	target = list_first_entry_or_null(&ce->tlist, struct cache_dfs_tgt,
 					  list);
+
 	WRITE_ONCE(ce->tgthint, target);
+	ce->ttl = max_t(int, refs[0].ttl, CACHE_MIN_TTL);
+	ce->etime = get_expire_time(ce->ttl);
+	ce->srvtype = refs[0].server_type;
+	ce->hdr_flags = refs[0].flags;
+	ce->ref_flags = refs[0].ref_flag;
+	ce->path_consumed = refs[0].path_consumed;
+	ce->numtgts = numrefs;
 
 	return 0;
 }
@@ -634,7 +635,6 @@ static int update_cache_entry_locked(struct cache_entry *ce, const struct dfs_in
 	}
 
 	free_tgts(ce);
-	ce->numtgts = 0;
 
 	rc = copy_ref_data(refs, numrefs, ce, th);
 
-- 
2.53.0

