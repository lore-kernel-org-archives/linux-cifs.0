Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ABD1CD1E0
	for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2024 10:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731409161; cv=none; b=u37/xgfyR35NF/R4Xpa6yBWpdo6tKe2IAQX0WnRKFJ/XVBQISFQ5FgvkYAzelK5Higyeq91n9fKkKPghPNOTYe91Kj3uxdrjpVIXc2qhE7/SijCJHYZKi+8cD7jBYmXNLkRX/lCMmVU4q/WD/YoVfyJjYAAjvY3XN9/EcRoWg1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731409161; c=relaxed/simple;
	bh=JZrQqai739fl3FlLxmWvgPe2WqRUGYdV53/fwcZtUZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ibmCals2tFw+hEvbNJCdndcmOb0FyM5NKt90GEViVCXzheMVIyfj30cNTD6PZo7uuSFjFt0u8rCpP5aL3JpCWJzuVj6Rn5szq58Y3hJvoG+M2MhOusz+8aEYZ7bXGnkgIPqy/5blYRRlUNR2Mi/vu2chNa3/bgWphqovpH92nFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V/QowCEE; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V/QowCEE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731409154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UxtS3i6mC2mIaktpQVjbvFWs72IlB4Imlh8S3FMp3b8=;
	b=V/QowCEEXm+yn7+E+DFRMd7QUl84/GOVvtmbzmFXRrL0N+B1lI1TNZVt/iG6maoeHjYE5n
	3zKlAsdpMs581VyefZs5IJHk3uj0Q8ddYttonOfOO4eKfkdpHc/yGdHKjfVw9Z+fFfHjUD
	UGmA/jr0mT/y4Koo9zP2jRzre8ekZtw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: Use str_yes_no() helper function
Date: Tue, 12 Nov 2024 11:58:38 +0100
Message-ID: <20241112105837.166575-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_yes_no() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/client/dfs_cache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 110f03df012a..00820f57b434 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -173,8 +173,8 @@ static int dfscache_proc_show(struct seq_file *m, void *v)
 				   "cache entry: path=%s,type=%s,ttl=%d,etime=%ld,hdr_flags=0x%x,ref_flags=0x%x,interlink=%s,path_consumed=%d,expired=%s\n",
 				   ce->path, ce->srvtype == DFS_TYPE_ROOT ? "root" : "link",
 				   ce->ttl, ce->etime.tv_nsec, ce->hdr_flags, ce->ref_flags,
-				   DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
-				   ce->path_consumed, cache_entry_expired(ce) ? "yes" : "no");
+				   str_yes_no(DFS_INTERLINK(ce->hdr_flags)),
+				   ce->path_consumed, str_yes_no(cache_entry_expired(ce)));
 
 			list_for_each_entry(t, &ce->tlist, list) {
 				seq_printf(m, "  %s%s\n",
@@ -242,9 +242,9 @@ static inline void dump_ce(const struct cache_entry *ce)
 		 ce->srvtype == DFS_TYPE_ROOT ? "root" : "link", ce->ttl,
 		 ce->etime.tv_nsec,
 		 ce->hdr_flags, ce->ref_flags,
-		 DFS_INTERLINK(ce->hdr_flags) ? "yes" : "no",
+		 str_yes_no(DFS_INTERLINK(ce->hdr_flags)),
 		 ce->path_consumed,
-		 cache_entry_expired(ce) ? "yes" : "no");
+		 str_yes_no(cache_entry_expired(ce)));
 	dump_tgts(ce);
 }
 
-- 
2.47.0

