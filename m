Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D06C432C3
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5775D2075C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="wq7+1v2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfK0AhW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:22 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16144 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfK0AhW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:22 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1BFA680A26;
        Wed, 27 Nov 2019 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8de9DSizj+Y1qnLIsP/a1mWhbQnfE7kGGXj/acVoBQ=;
        b=wq7+1v2Ie0ZaEpJRhXj5RnwqiHb9BXYJOtL3KcSX4bAI2v0kEFLlMzq8rXXjLXAkVuhImA
        blA4X8ts/vSTT02T8UjcMyx4GP+pDNRDyuJtnnBJOBJ1gOKOM8dahHZ1IdbypF9W1HVO1R
        AVjvLbhWDvEzt4a51MqCRJSHOl90p1Uu9gg7SCcQFdpvMyAA0Da0coM48U2AULuWz8E01z
        b46aTBI9ONrKxR0CuGD7Ss5BYc+oJgajOewEBiLzxXNaCcP9AWz43qbRbmIMN+mCFolhzD
        ljDwsQlN4KUfV9RqWSrHUjWjpjikUde90DNxM9XBNjZzMG8HdyVvtjhZBKtxzw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v3 06/11] cifs: Introduce helpers for finding TCP connection
Date:   Tue, 26 Nov 2019 21:36:29 -0300
Message-Id: <20191127003634.14072-7-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add helpers for finding TCP connections that are good candidates for
being used by DFS refresh worker.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 49c5f045270f..e889608e5e13 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1305,6 +1305,30 @@ static char *get_dfs_root(const char *path)
 	return npath;
 }
 
+static inline void put_tcp_server(struct TCP_Server_Info *server)
+{
+	cifs_put_tcp_session(server, 0);
+}
+
+static struct TCP_Server_Info *get_tcp_server(struct smb_vol *vol)
+{
+	struct TCP_Server_Info *server;
+
+	server = cifs_find_tcp_session(vol);
+	if (IS_ERR_OR_NULL(server))
+		return NULL;
+
+	spin_lock(&GlobalMid_Lock);
+	if (server->tcpStatus != CifsGood) {
+		spin_unlock(&GlobalMid_Lock);
+		put_tcp_server(server);
+		return NULL;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	return server;
+}
+
 /* Find root SMB session out of a DFS link path */
 static struct cifs_ses *find_root_ses(struct vol_info *vi,
 				      struct cifs_tcon *tcon,
@@ -1347,13 +1371,8 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 		goto out;
 	}
 
-	server = cifs_find_tcp_session(&vol);
-	if (IS_ERR_OR_NULL(server)) {
-		ses = ERR_PTR(-EHOSTDOWN);
-		goto out;
-	}
-	if (server->tcpStatus != CifsGood) {
-		cifs_put_tcp_session(server, 0);
+	server = get_tcp_server(&vol);
+	if (!server) {
 		ses = ERR_PTR(-EHOSTDOWN);
 		goto out;
 	}
@@ -1451,19 +1470,18 @@ static void refresh_cache_worker(struct work_struct *work)
 	mutex_lock(&vol_lock);
 
 	list_for_each_entry(vi, &vol_list, list) {
-		server = cifs_find_tcp_session(&vi->smb_vol);
-		if (IS_ERR_OR_NULL(server))
+		server = get_tcp_server(&vi->smb_vol);
+		if (!server)
 			continue;
-		if (server->tcpStatus != CifsGood)
-			goto next;
+
 		get_tcons(server, &list);
 		list_for_each_entry_safe(tcon, ntcon, &list, ulist) {
 			refresh_tcon(vi, tcon);
 			list_del_init(&tcon->ulist);
 			cifs_put_tcon(tcon);
 		}
-next:
-		cifs_put_tcp_session(server, 0);
+
+		put_tcp_server(server);
 	}
 	queue_delayed_work(dfscache_wq, &refresh_task, cache_ttl * HZ);
 	mutex_unlock(&vol_lock);
-- 
2.24.0

