Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6E5C8C7
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 01:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022277; cv=pass; b=sFcWhTZtB/SO5bwBOY/L7pvvnb8k69FN5gdJdj6m/9P2yMeD1IPAByZzTfpMRIcABmWKfewoxFrfoP2FDUFqj5R3UYxgOp+J22O5OhZKqD/ovtdLfYY7CLYQsVc056IUX8/7U60v20xGPrhvoF3zBU7eAZiixAnCXWeCCZRhTtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022277; c=relaxed/simple;
	bh=QkPuBshoXjA0KjitqAnAIsdnd4VyNFUOEmnUrBsGHeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB2gKIvFbNhPRp4b1z0J3upOzrMVBCxxYgBiCNYDT3aTeo4y+ju9QOpjIj+I3EtvKkBvYgn7Krfw2di1A1U25YwdCDEXlsgObGf40JJb3ky6bCW8EKQlua+PMETt+HQXyLXW+X5m8trLc6jc/gNbL7GyUnI60HGxW8PTu+xre8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=k+JRX36c; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="k+JRX36c"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPzfgaYhNq4/iJMnxLD+3a0KEoGBLXpCMiuKPVZW44k=;
	b=k+JRX36ciJCIFdH3lhxJ3LxDa93ALTpsl1IeGWOpPDdF+irk/uUWdjRYcMJIL7AyJI/7CX
	gOlaUKLe1Ei2VfWATVzMb+5H/KUZy2zPHsbBO5K/DaRwlKtiLRqnOcEfm0x157p3ksX4YK
	h8Asgs7/e+hl4DHZV81dACYRw6fmcEDmUAQuKOvuHaYdj4T2FsRq3NUNAVQWbm5et56mWN
	mgm+ToJ2JlNe2C7xRYznF3v+JaeZfQlXcfIg4IGziwjuIrTmJRrxMK7EMN/6UhmleN6AVC
	fpsFbLqvX1rBAnrp5zO1i4JTgg+yrRCmDQhdVtCAAnXNDaUGebJ6FXBiKQR99g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022272; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPzfgaYhNq4/iJMnxLD+3a0KEoGBLXpCMiuKPVZW44k=;
	b=UTuf94pAkMkmPyfFrKpW3GId6UOhHfuyjDnpnqBqWj19kTlD9KwI1VorgTy+Ewxfsj/sMi
	OgN7wFxzyTAdQVF9te2YXp7/+rQ/zJttXRPu1QBukv8yRhcIuX6AGxJRhxbM9qn6rJf2f6
	uri60U/7Xu8M7HJpvstyMy10iPiG8b95pESzvw0CcaKAnYzCdb/ZDX4aka+wyUqkyG3NR1
	Iv/CWUWIHoeWLYy+yGFLTEF41gnsrUmaGO3tlVloVQdAgHRdg/U2hEfCHOJkynSHS2xCNW
	KTTsUFxlCAvajw/8dx0rx4GD9qO5NRqLI4TDXLyLbq0w0VFVy7bGaahHJC6/Lg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712022272; a=rsa-sha256;
	cv=none;
	b=htNQeeHJys0wUA4kRqLA0iviAuYRS/vG7sK/H35q7dqsPZy9j4Z5WGGbOQa9gyzJiktcUd
	6SWE9iS71+Qe/P1fyHPApBKkbepCDq203kOWhspUbnVc6cTx/CpPaSd6XxOPMLwh4xwxHJ
	evAdlZibdrYaThNLyKVaAABpWqomlI5lG161vvbb/Ksh+BF+5D8Eqgz0jA1ALuK0p5vHC1
	kyjJBjUGwbKNgq94M4aMzmN0C0NIJmxL8Rx2eWRkZvvTT7LeeHW0z1p2O78RRnbDgeeiam
	AqyQH/jDleCo9dGrLUqBf0gr47w434iLMATan8e40DmGMHH6+HmjwuxWnlqLMA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/4] smb: client: refresh referral without acquiring refpath_lock
Date: Mon,  1 Apr 2024 22:44:07 -0300
Message-ID: <20240402014409.145562-2-pc@manguebit.com>
In-Reply-To: <20240402014409.145562-1-pc@manguebit.com>
References: <20240402014409.145562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid refreshing DFS referral with refpath_lock acquired as the I/O
could block for a while due to a potentially disconnected or slow DFS
root server and then making other threads - that use same @server and
don't require a DFS root server - unable to make any progress.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/dfs_cache.c | 44 +++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 0552a864ff08..11c8efecf7aa 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1172,8 +1172,8 @@ static bool is_ses_good(struct cifs_ses *ses)
 	return ret;
 }
 
-/* Refresh dfs referral of tcon and mark it for reconnect if needed */
-static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_refresh)
+/* Refresh dfs referral of @ses and mark it for reconnect if needed */
+static void __refresh_ses_referral(struct cifs_ses *ses, bool force_refresh)
 {
 	struct TCP_Server_Info *server = ses->server;
 	DFS_CACHE_TGT_LIST(old_tl);
@@ -1181,10 +1181,21 @@ static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_ref
 	bool needs_refresh = false;
 	struct cache_entry *ce;
 	unsigned int xid;
+	char *path = NULL;
 	int rc = 0;
 
 	xid = get_xid();
 
+	mutex_lock(&server->refpath_lock);
+	if (server->leaf_fullpath) {
+		path = kstrdup(server->leaf_fullpath + 1, GFP_ATOMIC);
+		if (!path)
+			rc = -ENOMEM;
+	}
+	mutex_unlock(&server->refpath_lock);
+	if (!path)
+		goto out;
+
 	down_read(&htable_rw_lock);
 	ce = lookup_cache_entry(path);
 	needs_refresh = force_refresh || IS_ERR(ce) || cache_entry_expired(ce);
@@ -1218,19 +1229,17 @@ static int __refresh_tcon(const char *path, struct cifs_ses *ses, bool force_ref
 	free_xid(xid);
 	dfs_cache_free_tgts(&old_tl);
 	dfs_cache_free_tgts(&new_tl);
-	return rc;
+	kfree(path);
 }
 
-static int refresh_tcon(struct cifs_tcon *tcon, bool force_refresh)
+static inline void refresh_ses_referral(struct cifs_ses *ses)
 {
-	struct TCP_Server_Info *server = tcon->ses->server;
-	struct cifs_ses *ses = tcon->ses;
+	__refresh_ses_referral(ses, false);
+}
 
-	mutex_lock(&server->refpath_lock);
-	if (server->leaf_fullpath)
-		__refresh_tcon(server->leaf_fullpath + 1, ses, force_refresh);
-	mutex_unlock(&server->refpath_lock);
-	return 0;
+static inline void force_refresh_ses_referral(struct cifs_ses *ses)
+{
+	__refresh_ses_referral(ses, true);
 }
 
 /**
@@ -1271,25 +1280,20 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 	 */
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 
-	return refresh_tcon(tcon, true);
+	force_refresh_ses_referral(tcon->ses);
+	return 0;
 }
 
 /* Refresh all DFS referrals related to DFS tcon */
 void dfs_cache_refresh(struct work_struct *work)
 {
-	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon;
 	struct cifs_ses *ses;
 
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
 
-	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses) {
-		server = ses->server;
-		mutex_lock(&server->refpath_lock);
-		if (server->leaf_fullpath)
-			__refresh_tcon(server->leaf_fullpath + 1, ses, false);
-		mutex_unlock(&server->refpath_lock);
-	}
+	for (ses = tcon->ses; ses; ses = ses->dfs_root_ses)
+		refresh_ses_referral(ses);
 
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
 			   atomic_read(&dfs_cache_ttl) * HZ);
-- 
2.44.0

