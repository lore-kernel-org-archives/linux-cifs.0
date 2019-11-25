Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A70C43215
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E1272068E
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 16:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="M/lwOvEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfKYQ6n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 11:58:43 -0500
Received: from mx.cjr.nz ([51.158.111.142]:22770 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfKYQ6n (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 11:58:43 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CC8DA80A58;
        Mon, 25 Nov 2019 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574701120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyUwjFr3mFFHupI0BeI49t35NePSq+D+p19YzFWO0+g=;
        b=M/lwOvEaDnWFfLDlEn78vAz6mUlgw5HiZuzAL+4YjwTE+ktWlE5/CTNwfxFOvWwRqbuI7m
        VNFeWTPSkuZqCMfkjTeJCqM4AWkLiXqf4cLqwM+l7d8w0FQbx8UsImBhx5THycdtmKua8c
        dBbAWupLVTc2fJI4AC4+kAXatOMcNWRqAlDVoapYMaTgZpCsCc2qIDOIksHXvIEboMgW2V
        yfrZx+tAI2usUAE5DcQNxubjgqFXP9UUQ2OjB/m6MwcWSqr464b+4EQpYg3mhuKVjID2IR
        RCgudpcMIWW1f5xtF7+CI6tHnU9Jb5i5IOBen9rPS2Qb9r65cbM8rcdAQYGmEw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com, aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v2 5/7] cifs: Fix potential deadlock when updating vol in cifs_reconnect()
Date:   Mon, 25 Nov 2019 13:57:56 -0300
Message-Id: <20191125165758.3793-6-pc@cjr.nz>
In-Reply-To: <20191125165758.3793-1-pc@cjr.nz>
References: <20191125165758.3793-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can't hold the vol_lock spinlock while refreshing the DFS cache
because cifs_reconnect() may call dfs_cache_update_vol() while we are
walking through the volume list.

To prevent that, make vol_info refcounted, create a temp list with all
volumes eligible for refreshing, and then use it without any locks
held.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
v1 -> v2:
  - mention that vol_info is now refcounted in commit msg
  - document put_vol() to say that it must be called with vol_lock held
---
 fs/cifs/dfs_cache.c | 46 +++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index b790f37c0060..263d42d46acc 100644
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
@@ -516,13 +518,16 @@ static struct cache_entry *lookup_cache_entry(const char *path,
 	return ce;
 }
 
-static inline void free_vol(struct vol_info *vi)
+/* Must be called with vol_lock held */
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
@@ -530,7 +535,7 @@ static inline void free_vol_list(void)
 	struct vol_info *vi, *nvi;
 
 	list_for_each_entry_safe(vi, nvi, &vol_list, list)
-		free_vol(vi);
+		put_vol(vi);
 }
 
 /**
@@ -1150,6 +1155,7 @@ int dfs_cache_add_vol(char *mntdata, struct smb_vol *vol, const char *fullpath)
 		goto err_free_fullpath;
 
 	vi->mntdata = mntdata;
+	vi->vol_count++;
 
 	spin_lock(&vol_lock);
 	list_add_tail(&vi->list, &vol_list);
@@ -1229,11 +1235,9 @@ void dfs_cache_del_vol(const char *fullpath)
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
 
@@ -1456,18 +1460,31 @@ static int refresh_tcon(struct vol_info *vi, struct cifs_tcon *tcon)
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
 
@@ -1484,8 +1501,13 @@ static void refresh_cache_worker(struct work_struct *work)
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

