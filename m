Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7288913792B
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636572; cv=pass; b=Wp3B4w3/F4xzDZO1Ugu6ocM8KmwuoB11MGXo3Bxy22vPerBQbahfqXC7fKchGqjAjKRcSZbv4+xxARZt/1kNLovtJdnKXk3K/Z4GEPv/atZ96+CH/+6/qN2k/l/WQFxtINuIRGIj8GIe6km1gXf25cpdJ72QvUTnbu28K+ew4II=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636572; c=relaxed/simple;
	bh=M8yXWvKkAZrRCEo1J0g7+JdKRbniTURXUM5S+BHDCtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apRuvbzePB5h1Un60Nkvt6O+C2ov5nyuMtNSfwszTDbyT6REzmkjE58Du6dU9InvUrxNxm4HGoq0Q1i+HHrWEwhkRBsKMgLc5dBhFurFpJtrJIsVlsToyhB+2fAVeybQ4bYKgV9buKu33K8FnxyOJLJZcBdMTbXlARwtVKMfp9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=TQM1YlOy; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="TQM1YlOy"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLYjtw+j9tWHFsr8fJTdUEj5OnHSbDmq606lLM6/UFc=;
	b=TQM1YlOymwTjf7DDR/UV5AKsi59081FPYdTiThQfeWrlNJs6iwFjiMfmWQ/ihDI5x+D2g9
	latTvsPDku5aGb/A1WVcAu56ZSHViP90rSRCi8ZrdgD0V77w05KLE25XRWdgG+1OFF0s4i
	m+ilFfDCh6BK91WpdsNifH60kIKw0AuzvUxdREvMZDF9hThMKuO94h3ApWN80l8Eu4lYdX
	+t+yhAVuiXNgjurdFj1m0jMFOCESzWOJMAx2Bg8Tp2iyfwRb3b4Bv4AcGPuQ7nAuUvwQZ/
	GCikKw3El1IGGKqu8xbRmH6PR4Q7vfUq4WZwnvCE3sWOUnbCG5Aoi0vwfn3PVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636569; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLYjtw+j9tWHFsr8fJTdUEj5OnHSbDmq606lLM6/UFc=;
	b=pghyYKQ0kEB7H767Hz0Dg16hn9n065MFlYEoiUbakdTd0XKBEz6rJYpOELLCHI7FLK3hlO
	S8+MPD8ZebMMHKKDw+HkDXMcHZvDD7m4cLsj4paIs9Z+nf/i1kQP7rvmBQ5kRml18mTz2R
	WZgVoH3S6tT/1JO6PISxQkC+bHXWknRNyxXdB6o455FYvDXTTMGhktWytEsoni/WOhNTZb
	SYqd57kM4kcdahPfZVU6FIj6BSbh2O0P6kZWp4IfKz0a1q37Gg8tWm2y3ttgCXsMDcWrp4
	ZPXULoZknNS0Cnt+Md39XOp4rFiIftRLyBTXYPQiT7lSOiewFFtDPdtjBS301w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636569; a=rsa-sha256;
	cv=none;
	b=IHxcYl6LSdVgvu0SOte8YFzY7i1ilgRu1O3e/wzeHHUiEd9KEP1sOYzjBPRP9is98r/Zhv
	Xy+W0zP7FtQPQ0bqR0puQe52HtODeh6AxjgXiDUnxUJYwXFHg70usy7dCrKf1Pi9Mxy2Og
	HsqDiF8PUiSwxSQeu137fwv9oEcfZ0Tt/VEHZZsr11kPD40ZXbP4KFOFqJvYTQ0fkRsvVC
	8cv/HqUswO46buv1fsX4XpVgv8DrfWm5y1BvVMDyOSntHArr6idK8+qgvBaKbcN80fqF9m
	MJx0lZocF6np9BSZMKxReIlEhihKIauBcA1UHMyAqTrRy3pOOV0FH8xsUZya/Q==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/9] smb: client: improve purging of cached referrals
Date: Wed, 18 Sep 2024 02:15:35 -0300
Message-ID: <20240918051542.64349-2-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Purge cached referrals that have a single target when reaching maximum
of cache size as the client won't need them to failover.  Otherwise
remove oldest cache entry.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/dfs_cache.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 3cf7c88489be..e496dbf8c622 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -126,6 +126,7 @@ static inline void free_tgts(struct cache_entry *ce)
 
 static inline void flush_cache_ent(struct cache_entry *ce)
 {
+	cifs_dbg(FYI, "%s: %s\n", __func__, ce->path);
 	hlist_del_init(&ce->hlist);
 	kfree(ce->path);
 	free_tgts(ce);
@@ -441,34 +442,31 @@ static struct cache_entry *alloc_cache_entry(struct dfs_info3_param *refs, int n
 	return ce;
 }
 
-static void remove_oldest_entry_locked(void)
+/* Remove all referrals that have a single target or oldest entry */
+static void purge_cache(void)
 {
 	int i;
 	struct cache_entry *ce;
-	struct cache_entry *to_del = NULL;
-
-	WARN_ON(!rwsem_is_locked(&htable_rw_lock));
+	struct cache_entry *oldest = NULL;
 
 	for (i = 0; i < CACHE_HTABLE_SIZE; i++) {
 		struct hlist_head *l = &cache_htable[i];
+		struct hlist_node *n;
 
-		hlist_for_each_entry(ce, l, hlist) {
+		hlist_for_each_entry_safe(ce, n, l, hlist) {
 			if (hlist_unhashed(&ce->hlist))
 				continue;
-			if (!to_del || timespec64_compare(&ce->etime,
-							  &to_del->etime) < 0)
-				to_del = ce;
+			if (ce->numtgts == 1)
+				flush_cache_ent(ce);
+			else if (!oldest ||
+				 timespec64_compare(&ce->etime,
+						    &oldest->etime) < 0)
+				oldest = ce;
 		}
 	}
 
-	if (!to_del) {
-		cifs_dbg(FYI, "%s: no entry to remove\n", __func__);
-		return;
-	}
-
-	cifs_dbg(FYI, "%s: removing entry\n", __func__);
-	dump_ce(to_del);
-	flush_cache_ent(to_del);
+	if (atomic_read(&cache_count) >= CACHE_MAX_ENTRIES && oldest)
+		flush_cache_ent(oldest);
 }
 
 /* Add a new DFS cache entry */
@@ -484,7 +482,7 @@ static struct cache_entry *add_cache_entry_locked(struct dfs_info3_param *refs,
 
 	if (atomic_read(&cache_count) >= CACHE_MAX_ENTRIES) {
 		cifs_dbg(FYI, "%s: reached max cache size (%d)\n", __func__, CACHE_MAX_ENTRIES);
-		remove_oldest_entry_locked();
+		purge_cache();
 	}
 
 	rc = cache_entry_hash(refs[0].path_name, strlen(refs[0].path_name), &hash);
-- 
2.46.0

