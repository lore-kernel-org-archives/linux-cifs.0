Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E1AC3DA79
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 21:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbiL2VoB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiL2VoB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 16:44:01 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5877D10055
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 13:43:59 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 75DFF7FC20;
        Thu, 29 Dec 2022 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1672350237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/EVamuxWW8kNwshuB1gJZJVjqaKjvcNSpFnLuL0XsFw=;
        b=fTYnHsbYO4d9SZWBYqFDwKCyGaoVIqNT7XPm9UtjVf5StGc7Ql58WWqx5uXtPEXyyIQBqs
        WikPm1IvvQdX1a6cy7VB2/Gv7R9RvqN7TS/23Gvo+GY1RctSMN0TXve6BLYdCc7v8fQS5j
        Acuw9AoOM3FApy1IhApOkU2+myYhsrb7jLiJJGax6FGFtNdKpuMPNHaieAmlATo3Dy+7Fw
        xD2ubZ/kncjMgeOp673CkSFJJd/GrpBtF0ngw+LPd56SxFab71+pcVaVXLvGOQxn9gOvpp
        d6/iQu1dCQ6YnheFnwu/KqPsowQQYFJnizUbhfuUiP7upBAJ1lCYGbbOAyMAIw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: protect access of TCP_Server_Info::{dstaddr,hostname}
Date:   Thu, 29 Dec 2022 18:43:46 -0300
Message-Id: <20221229214346.9979-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use the appropriate locks to protect access of hostname and dstaddr
fields in cifs_tree_connect() as they might get changed by other
tasks.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs.c  | 22 +++++++++++-----------
 fs/cifs/misc.c |  2 ++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index 30086f2060a1..b64d20374b9c 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -327,8 +327,8 @@ static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb
 	return rc;
 }
 
-static int target_share_matches_server(struct TCP_Server_Info *server, const char *tcp_host,
-				       size_t tcp_host_len, char *share, bool *target_match)
+static int target_share_matches_server(struct TCP_Server_Info *server, char *share,
+				       bool *target_match)
 {
 	int rc = 0;
 	const char *dfs_host;
@@ -338,13 +338,16 @@ static int target_share_matches_server(struct TCP_Server_Info *server, const cha
 	extract_unc_hostname(share, &dfs_host, &dfs_host_len);
 
 	/* Check if hostnames or addresses match */
-	if (dfs_host_len != tcp_host_len || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-		cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__, (int)dfs_host_len,
-			 dfs_host, (int)tcp_host_len, tcp_host);
+	cifs_server_lock(server);
+	if (dfs_host_len != strlen(server->hostname) ||
+	    strncasecmp(dfs_host, server->hostname, dfs_host_len)) {
+		cifs_dbg(FYI, "%s: %.*s doesn't match %s\n", __func__,
+			 (int)dfs_host_len, dfs_host, server->hostname);
 		rc = match_target_ip(server, dfs_host, dfs_host_len, target_match);
 		if (rc)
 			cifs_dbg(VFS, "%s: failed to match target ip: %d\n", __func__, rc);
 	}
+	cifs_server_unlock(server);
 	return rc;
 }
 
@@ -358,13 +361,9 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 	struct cifs_ses *root_ses = CIFS_DFS_ROOT_SES(tcon->ses);
 	struct cifs_tcon *ipc = root_ses->tcon_ipc;
 	char *share = NULL, *prefix = NULL;
-	const char *tcp_host;
-	size_t tcp_host_len;
 	struct dfs_cache_tgt_iterator *tit;
 	bool target_match;
 
-	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
-
 	tit = dfs_cache_get_tgt_iterator(tl);
 	if (!tit) {
 		rc = -ENOENT;
@@ -387,8 +386,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 			break;
 		}
 
-		rc = target_share_matches_server(server, tcp_host, tcp_host_len, share,
-						 &target_match);
+		rc = target_share_matches_server(server, share, &target_match);
 		if (rc)
 			break;
 		if (!target_match) {
@@ -497,7 +495,9 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	}
 
 	if (tcon->ipc) {
+		cifs_server_lock(server);
 		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
+		cifs_server_unlock(server);
 		rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
 		goto out;
 	}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 4d3c586785a5..2a19c7987c5b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1277,7 +1277,9 @@ int match_target_ip(struct TCP_Server_Info *server,
 	if (rc < 0)
 		return rc;
 
+	spin_lock(&server->srv_lock);
 	*result = cifs_match_ipaddr((struct sockaddr *)&server->dstaddr, (struct sockaddr *)&ss);
+	spin_unlock(&server->srv_lock);
 	cifs_dbg(FYI, "%s: ip addresses match: %u\n", __func__, *result);
 	return 0;
 }
-- 
2.39.0

