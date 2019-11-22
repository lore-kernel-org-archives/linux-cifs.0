Return-Path: <SRS0=i0zP=ZO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEBEC432C3
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E97E2071C
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Nov 2019 15:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="Z3LN6aUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVPbu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Nov 2019 10:31:50 -0500
Received: from mx.cjr.nz ([51.158.111.142]:28476 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfKVPbt (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Nov 2019 10:31:49 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1D0B580A51;
        Fri, 22 Nov 2019 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574436707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmCdYtHTRFtTbKwICBxuny47W3tQAxRiRVHAX01WFq8=;
        b=Z3LN6aUqKJYcnCGOhPTuZouNKfMSdufsOlNUfCi+ybz9/+f7kIMt1OIMhosZZ9RGHTzGN8
        a3iBMQQP3KnO35D8F5SRZn6VOi28OZHUAdgLIgojFC7C6G74Afjb6F0oauUyjhh95IaVAu
        i0Dly6xDy4kAKe17AU+oXeyiGZd+fwsPlH5v6q4FgNDqpnBBdeUKVqw42QPDTtRhrdywAo
        lnR1NjsgRKzA0gCY1+lytb9LBwsd6cjPQqxwjcWVoWL0KwICM9KHRgHGgvJHmcJ+g/NtlE
        09ihkkFNZL7WG9BmLKEuFA135i1F6x/AT7oQd1xH/V99U7MIMVHB+j8HQYLcVA==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 5/7] cifs: Fix potential deadlock when updating vol in cifs_reconnect()
Date:   Fri, 22 Nov 2019 12:30:55 -0300
Message-Id: <20191122153057.6608-6-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-1-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can't hold the vol_lock spinlock while refreshing the DFS cache
because cifs_reconnect() may call dfs_cache_update_vol() while we are
walking through the volume list.

Create a temp list with all volumes eligible for refreshing and then
use it without any locks held.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index b082603c793a..5b9d7281dd67 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -49,6 +49,8 @@ struct vol_info {
 	struct smb_vol smb_vol;
 	char *mntdata;
 	struct list_head list;
+	struct list_head rlist;
+	int vol_count;
 };
 
 static struct kmem_cache *cache_slab __read_mostly;
@@ -516,13 +518,15 @@ static struct cache_entry *lookup_cache_entry(const char *path,
 	return ce;
 }
 
-static inline void free_vol(struct vol_info *vi)
+static void put_vol(struct vol_info *vi)
 {
-	list_del(&vi->list);
-	kfree(vi->fullpath);
-	kfree(vi->mntdata);
-	cifs_cleanup_volume_info_contents(&vi->smb_vol);
-	kfree(vi);
+	if (!--vi->vol_count) {
+		list_del_init(&vi->list);
+		kfree(vi->fullpath);
+		kfree(vi->mntdata);
+		cifs_cleanup_volume_info_contents(&vi->smb_vol);
+		kfree(vi);
+	}
 }
 
 static inline void free_vol_list(void)
@@ -530,7 +534,7 @@ static inline void free_vol_list(void)
 	struct vol_info *vi, *nvi;
 
 	list_for_each_entry_safe(vi, nvi, &vol_list, list)
-		free_vol(vi);
+		put_vol(vi);
 }
 
 /**
@@ -1140,6 +1144,7 @@ int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 		goto err_free_fullpath;
 
 	vi->mntdata = mntdata;
+	vi->vol_count++;
 
 	spin_lock(&vol_lock);
 	list_add_tail(&vi->list, &vol_list);
@@ -1219,11 +1224,9 @@ void dfs_cache_del_vol(const char *fullpath)
 	cifs_dbg(FYI, "%s: fullpath: %s\n", __func__, fullpath);
 
 	spin_lock(&vol_lock);
-
 	vi = find_vol(fullpath);
 	if (!IS_ERR(vi))
-		free_vol(vi);
-
+		put_vol(vi);
 	spin_unlock(&vol_lock);
 }
 
@@ -1446,18 +1449,31 @@ static int refresh_tcon(struct vol_info *vi, struct cifs_tcon *tcon)
  */
 static void refresh_cache_worker(struct work_struct *work)
 {
-	struct vol_info *vi;
+	struct vol_info *vi, *nvi;
 	struct TCP_Server_Info *server;
+	LIST_HEAD(vols);
 	LIST_HEAD(tcons);
 	struct cifs_tcon *tcon, *ntcon;
 	int rc;
 
+	/* Get SMB volumes that are eligible (CifsGood) for refreshing */
 	spin_lock(&vol_lock);
 	list_for_each_entry(vi, &vol_list, list) {
 		server = get_tcp_server(&vi->smb_vol);
 		if (!server)
 			continue;
 
+		vi->vol_count++;
+		list_add_tail(&vi->rlist, &vols);
+		put_tcp_server(server);
+	}
+	spin_unlock(&vol_lock);
+
+	list_for_each_entry_safe(vi, nvi, &vols, rlist) {
+		server = get_tcp_server(&vi->smb_vol);
+		if (!server)
+			goto next_vol;
+
 		get_tcons(server, &tcons);
 		rc = 0;
 
@@ -1474,8 +1490,13 @@ static void refresh_cache_worker(struct work_struct *work)
 		}
 
 		put_tcp_server(server);
+
+next_vol:
+		list_del_init(&vi->rlist);
+		spin_lock(&vol_lock);
+		put_vol(vi);
+		spin_unlock(&vol_lock);
 	}
-	spin_unlock(&vol_lock);
 
 	queue_delayed_work(dfscache_wq, &refresh_task,
 			   atomic_read(&cache_ttl) * HZ);
-- 
2.24.0

