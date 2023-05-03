Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E094C7EE22
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjECWVv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjECWVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:49 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38238692;
        Wed,  3 May 2023 15:21:43 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gI/91qtA5iwgjzI2yC9NwpCVjUdMgAvpLzhHmundRI=;
        b=rE8n7f8rdDxMoVg+6QC/8LZZa8J7w37O5HyWDM7PqG+qyXbqm+l0d+vHhOANnE7TUk/YMx
        PvyiUjAuTjRNg+l30gvOT74WKQ3r0mkqNlYTxgBDL3Lskkm12ycoov5gl5HsXmpl1n6yP2
        eD6VRHcJzS61lvhjbp41Ab0KTpd+45mSvaltFXXqGnVGpVKceWfep5nzLRzH8Gqs+NyK3D
        ynuto4ksxrQveEJbQlebxNfRGJw+QvuvpnoN2NjneiqJlsFPGYDnEDavTXQMeaB2bkElNk
        7YqZ1xapg0ONIzmezYd6gUZW/aZal4hvAeF+Epq3rguVKiTsFFTitYziXKjPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gI/91qtA5iwgjzI2yC9NwpCVjUdMgAvpLzhHmundRI=;
        b=e9/HzlZvqNBXgP3NWXBMAx7cr4pGYMAZz/DsKD8w+yS3psJ7ryjX++flVU0GAd0ytjSU5g
        Trl52TOV+iRZvzOEANSbbCNopJ/rBp/kKmlCGati+SkoGp5I2SAb0glronXhUH6hFNS0Ht
        gZnAfycUSv2LbyRFGzoGSyjDL14p1KTNuB4JN1l+oirB6KuReKk1A7lQ5WE5pz+Gl1Wkoe
        uRrpI8h35pZKfLdCV+u7H/Ie/kOcZtB58hhj7l5hxqA4ujDtkdFVh7RGyqswxN12iB3v+B
        ZsFtn7aqaT/28bjIJM55p52KNxsVEy3TA19saG+7orb54NSvElMyueAQl6rrZg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152502; a=rsa-sha256;
        cv=none;
        b=Hr7fcUD2AvwCwsNMvo89L9bVXdsY1NM0LOUwZ8bDzMcKPy3KH0YCtWMpPrbMPGNja5v0nw
        LWaw8Q9UJi03qpoFF8kkV++uYXXCeFGRh5pZqD8p3I/6Gkt1zRfYv0QYkw4LXC74XVjOz8
        AzAoQetJ/SLPOUSF0Dh57JoQp7GFIFfbOwvmL28BJ83OkPgdAt5KZr0YDCv3SMdbcLA7hc
        nsTl8hUVAtTk3S34XEZdDqpsnyNqKUJgVzcWlNTl/CCYhL7UfqM6RlLQQKlgXZTbU01yjl
        WnwGinZk+Z+05ys83CM9jL5FCbM2LNhK+q1eE+kgbwrkOePzBfJ4O6DgG875WQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/7] cifs: fix potential race when tree connecting ipc
Date:   Wed,  3 May 2023 19:21:11 -0300
Message-Id: <20230503222117.7609-2-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Protect access of TCP_Server_Info::hostname when building the ipc tree
name as it might get freed in cifsd thread and thus causing an
use-after-free bug in __tree_connect_dfs_target().  Also, while at it,
update status of IPC tcon on success and then avoid any extra tree
connects.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/dfs.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index 3a11716b6e13..37f7da4f5c8b 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -374,6 +374,54 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	return rc;
 }
 
+static void __tree_connect_ipc(const unsigned int xid, char *tree,
+			       struct cifs_sb_info *cifs_sb,
+			       struct cifs_ses *ses)
+{
+	struct TCP_Server_Info *server = ses->server;
+	struct cifs_tcon *tcon = ses->tcon_ipc;
+	int rc;
+
+	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
+	if (cifs_chan_needs_reconnect(ses, server) ||
+	    ses->ses_status != SES_GOOD) {
+		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
+		cifs_server_dbg(FYI, "%s: skipping ipc reconnect due to disconnected ses\n",
+				__func__);
+		return;
+	}
+	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
+
+	cifs_server_lock(server);
+	scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
+	cifs_server_unlock(server);
+
+	rc = server->ops->tree_connect(xid, ses, tree, tcon,
+				       cifs_sb->local_nls);
+	cifs_server_dbg(FYI, "%s: tree_reconnect %s: %d\n", __func__, tree, rc);
+	spin_lock(&tcon->tc_lock);
+	if (rc) {
+		tcon->status = TID_NEED_TCON;
+	} else {
+		tcon->status = TID_GOOD;
+		tcon->need_reconnect = false;
+	}
+	spin_unlock(&tcon->tc_lock);
+}
+
+static void tree_connect_ipc(const unsigned int xid, char *tree,
+			     struct cifs_sb_info *cifs_sb,
+			     struct cifs_tcon *tcon)
+{
+	struct cifs_ses *ses = tcon->ses;
+
+	__tree_connect_ipc(xid, tree, cifs_sb, ses);
+	__tree_connect_ipc(xid, tree, cifs_sb, CIFS_DFS_ROOT_SES(ses));
+}
+
 static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
 				     struct cifs_sb_info *cifs_sb, char *tree, bool islink,
 				     struct dfs_cache_tgt_list *tl)
@@ -382,7 +430,6 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
 	struct cifs_ses *root_ses = CIFS_DFS_ROOT_SES(tcon->ses);
-	struct cifs_tcon *ipc = root_ses->tcon_ipc;
 	char *share = NULL, *prefix = NULL;
 	struct dfs_cache_tgt_iterator *tit;
 	bool target_match;
@@ -418,18 +465,14 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		}
 
 		dfs_cache_noreq_update_tgthint(server->current_fullpath + 1, tit);
-
-		if (ipc->need_reconnect) {
-			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
-			rc = ops->tree_connect(xid, ipc->ses, tree, ipc, cifs_sb->local_nls);
-			cifs_dbg(FYI, "%s: reconnect ipc: %d\n", __func__, rc);
-		}
+		tree_connect_ipc(xid, tree, cifs_sb, tcon);
 
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
 		if (!islink) {
 			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
 			break;
 		}
+
 		/*
 		 * If no dfs referrals were returned from link target, then just do a TREE_CONNECT
 		 * to it.  Otherwise, cache the dfs referral and then mark current tcp ses for
-- 
2.40.1

