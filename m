Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8ADC2D0B1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 20:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E8BA2077B
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 20:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="SWhJn8R/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfLDUi1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 15:38:27 -0500
Received: from mx.cjr.nz ([51.158.111.142]:1750 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfLDUi0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Dec 2019 15:38:26 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 892F581327;
        Wed,  4 Dec 2019 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1575491905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJOu23349s3cNDvalBkVHN6/TkIgwGjb627a6Km8eMM=;
        b=SWhJn8R/Y73aX1h34hRmC803KIxvQ3k6wkecL2sEYLvhM/CkrlcVkiGBl556wb+PzlZZk5
        pC7PpvEzoqNW0FwqH+QjT+7AL9bt8Y3tgtoYeD5YxUTgdDHFJXa39Fpt7luQvPe9RziUhQ
        OwkojamE7K95ARatYLQ75s+9JBUffV4QNvTQc3+tmwyoCwKx3liQtcAOFbajYJndNUICe9
        qXCaNhd23B3/oLRiQaM27FU9myLHCVCKBYmiwTL2g82I9KEOyFsPNSnWq8ijWzcLf8amfY
        70LtIVSS9jz10Dx3UATEGu4z7L2iF2d9DDHZSN4k/Ec443zp1jgA3hRhUEkH5g==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 3/6] cifs: Introduce helpers for finding TCP connection
Date:   Wed,  4 Dec 2019 17:38:00 -0300
Message-Id: <20191204203803.2316-4-pc@cjr.nz>
In-Reply-To: <20191204203803.2316-1-pc@cjr.nz>
References: <20191204203803.2316-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add helpers for finding TCP connections that are good candidates for
being used by DFS refresh worker.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
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

