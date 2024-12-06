Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DAF1474AF
	for <linux-cifs@vger.kernel.org>; Fri,  6 Dec 2024 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496588; cv=none; b=PWTnXaouPhdb7RKvFZ+JXj/oHPZtmmne/QkK1fmzsXDA+AuZu4mXUmHclWsW3CjgqmURL8Rle8d8lBNWIO5fUlD2hTC8sEoZchLFFJYIwfLS6PB3HplwMt0mhT7e0tEX4lE9PRgXsy1MJZW/kAhCFcpZSh2ga0BTOv1Friba9+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496588; c=relaxed/simple;
	bh=GoHTj64/ZEd3D2vEKsIPJYnSD1xlHaHMuxXjQhX9blw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K68VfwDYN5jSrIWleU5FH4/ivCXpT1WKwQhiFwFZsLWExILbU2O84nWfsNbNPLCD76P+fG5WG+W5mEmPCjj39PJlo2yCY1TpBfwi+sOH6+iuniNllgbOoMzhh4+wZNfpRxf12gSouW9jntx4U1DVl+L4FT+Wdc6c//CJf60SIvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=M3OYaxBA; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="M3OYaxBA"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733496576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8MQ1IbEpcH+z3LBpSFGpQNfXeKyfsnX7KchiQxRnrwY=;
	b=M3OYaxBAsq2nbI+48HedlcWk8JyrYFXkBwgk4lBW1cHVDhgmWYtsu9xg7wxyeclXClB8WH
	ZvpiS4yZNDByqcNlhzEPYHidP0NPodRSwf8LJaU0cvAQOeMY6MQItEs7hPtwjkZqCLiiXq
	xTbyjlJJ1qxHQfYQeGWBymposD5M28tOGMcGahx0gFV0H+o/o9mUORqBMr7o68tFJPJvbv
	S+3uo5VMabmUvWJrGmSE42c42bT81WOCZnOewoDr+8Vy4jc6o7bH3W8sakCKYZWPtqNArA
	LOgunOV4ja+cgMSMusFzVn/ECDHZ+G4z/5llaLzwTN+cyRBEgHffArumAtF9Fw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: fix potential race in cifs_put_tcon()
Date: Fri,  6 Dec 2024 11:49:07 -0300
Message-ID: <20241206144907.162730-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dfs_cache_refresh() delayed worker could race with cifs_put_tcon(), so
make sure to call list_replace_init() on @tcon->dfs_ses_list after
kworker is cancelled or finished.

Fixes: 4f42a8b54b5c ("smb: client: fix DFS interlink failover")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 56b3a9eb9b05..2372538a1211 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2532,9 +2532,6 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 
 	list_del_init(&tcon->tcon_list);
 	tcon->status = TID_EXITING;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	list_replace_init(&tcon->dfs_ses_list, &ses_list);
-#endif
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -2542,6 +2539,7 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	cancel_delayed_work_sync(&tcon->query_interfaces);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cancel_delayed_work_sync(&tcon->dfs_cache_work);
+	list_replace_init(&tcon->dfs_ses_list, &ses_list);
 #endif
 
 	if (tcon->use_witness) {
-- 
2.47.1

