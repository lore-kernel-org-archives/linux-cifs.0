Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A06C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D1A207D3
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="XIKECA3O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgESSjD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 14:39:03 -0400
Received: from mx.cjr.nz ([51.158.111.142]:15656 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgESSjD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 May 2020 14:39:03 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 66D2380346;
        Tue, 19 May 2020 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1589913540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=26zvJ7ApPuWUE56ycAkS7Z+a6PGSnn+VJc+yWsPg9Lo=;
        b=XIKECA3OQ1HwodVnLJ0ZEr7XUg+7yGpQ2VDTTpBDy5+8mCJKKAAfMd8hfaQwAXZbDhKio4
        To6Be92xLGV0t6uF98z1L/zgReBOg+6NbTXX+guZXUUW/L4pNS7j2SobJB6JTi5pJMAo7W
        tGBQwImLiYto2x/KIrBESJtDM7BWEM28eePZzLH81HU4Q6vSRkEwAviwcbE0quFz4k8oVd
        RUW8mzUmbdAQ5Cuc0JBMSyXB3fF5W2OXTU5boJwXafyuvx7h5SdCsrLud/8qdYWuN8Jc/Z
        737zXfSbh926SAjTPat0c6C3jRvnIZHEa6TyLNCMYQnclnaptVVxgKTlaECdsg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/3] cifs: handle hostnames that resolve to same ip in failover
Date:   Tue, 19 May 2020 15:38:28 -0300
Message-Id: <20200519183829.5512-2-pc@cjr.nz>
In-Reply-To: <20200519183829.5512-1-pc@cjr.nz>
References: <20200519183829.5512-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In order to support reconnect to hostnames that resolve to same ip
address, besides relying on the currently set hostname to match DFS
targets, attempt to resolve the targets and then match their addresses
with the reconnected server ip address.

For instance, if we have two hostnames "FOO" and "BAR", and both
resolve to the same ip address, we would be able to handle failover in
DFS paths like

    \\FOO\dfs\link1 -> [ \BAZ\share2 (*), \BAR\share1 ]
    \\FOO\dfs\link2 -> [ \BAZ\share2 (*), \FOO\share1 ]

so when "BAZ" is no longer accessible, link1 and link2 would get
reconnected despite having different target hostnames.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsproto.h |  5 ++++
 fs/cifs/cifssmb.c   | 55 +++++++++++++++++++++++++++++---------------
 fs/cifs/connect.c   |  6 ++---
 fs/cifs/misc.c      | 48 ++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 56 ++++++++++++++++++++++++++++++---------------
 5 files changed, 131 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 12a895e02db4..311d8e86c5a8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -89,6 +89,7 @@ extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
+extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
 			struct smb_rqst *rqst,
@@ -616,6 +617,10 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 	return dfs_cache_find(xid, ses, nls_codepage, remap, old_path,
 			      referral, NULL);
 }
+
+int match_target_ip(struct TCP_Server_Info *server,
+		    const char *share, size_t share_len,
+		    bool *result);
 #endif
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 182b864b3075..526171503c4e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -129,6 +129,7 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
 				 struct cifs_tcon *tcon)
 {
 	int rc;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct dfs_cache_tgt_list tl;
 	struct dfs_cache_tgt_iterator *it = NULL;
 	char *tree;
@@ -141,15 +142,14 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
 	if (!tree)
 		return -ENOMEM;
 
-	if (tcon->ipc) {
-		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
-			  tcon->ses->server->hostname);
-		rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
-		goto out;
-	}
-
 	if (!tcon->dfs_path) {
-		rc = CIFSTCon(0, tcon->ses, tcon->treeName, tcon, nlsc);
+		if (tcon->ipc) {
+			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
+				  server->hostname);
+			rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
+		} else {
+			rc = CIFSTCon(0, tcon->ses, tcon->treeName, tcon, nlsc);
+		}
 		goto out;
 	}
 
@@ -157,13 +157,13 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
 	if (rc)
 		goto out;
 
-	extract_unc_hostname(tcon->ses->server->hostname, &tcp_host,
-			     &tcp_host_len);
+	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
 	for (it = dfs_cache_get_tgt_iterator(&tl); it;
 	     it = dfs_cache_get_next_tgt(&tl, it)) {
 		const char *share, *prefix;
 		size_t share_len, prefix_len;
+		bool target_match;
 
 		rc = dfs_cache_get_tgt_share(it, &share, &share_len, &prefix,
 					     &prefix_len);
@@ -177,19 +177,38 @@ static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
 
 		if (dfs_host_len != tcp_host_len
 		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-			cifs_dbg(FYI, "%s: skipping %.*s, doesn't match %.*s",
+			cifs_dbg(FYI, "%s: %.*s doesn't match %.*s",
 				 __func__,
 				 (int)dfs_host_len, dfs_host,
 				 (int)tcp_host_len, tcp_host);
-			continue;
+
+			rc = match_target_ip(server, dfs_host, dfs_host_len,
+					     &target_match);
+			if (rc) {
+				cifs_dbg(VFS, "%s: failed to match target ip: %d\n",
+					 __func__, rc);
+				break;
+			}
+
+			if (!target_match) {
+				cifs_dbg(FYI, "%s: skipping target\n", __func__);
+				continue;
+			}
 		}
 
-		scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len, share);
-
-		rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
-		if (!rc) {
-			rc = update_super_prepath(tcon, prefix, prefix_len);
-			break;
+		if (tcon->ipc) {
+			scnprintf(tree, MAX_TREE_SIZE, "\\\\%.*s\\IPC$",
+				  (int)share_len, share);
+			rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
+		} else {
+			scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len,
+				  share);
+			rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
+			if (!rc) {
+				rc = update_super_prepath(tcon, prefix,
+							  prefix_len);
+				break;
+			}
 		}
 		if (rc == -EREMOTE)
 			break;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 47b9fbb70bf5..094c939cb98e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2496,8 +2496,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
  * specified, or if srcaddr is specified and
  * matches the IP address of the rhs argument.
  */
-static bool
-srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
+bool
+cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs)
 {
 	switch (srcaddr->sa_family) {
 	case AF_UNSPEC:
@@ -2588,7 +2588,7 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 		return false; /* don't expect to be here */
 	}
 
-	if (!srcip_matches(srcaddr, (struct sockaddr *)&server->srcaddr))
+	if (!cifs_match_ipaddr(srcaddr, (struct sockaddr *)&server->srcaddr))
 		return false;
 
 	return true;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 550ce9020a3e..1ec6a5543eda 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -32,6 +32,9 @@
 #include "cifs_unicode.h"
 #include "smb2pdu.h"
 #include "cifsfs.h"
+#ifdef CONFIG_CIFS_DFS_UPCALL
+#include "dns_resolve.h"
+#endif
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -1083,6 +1086,51 @@ void cifs_put_tcp_super(struct super_block *sb)
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
+int match_target_ip(struct TCP_Server_Info *server,
+		    const char *share, size_t share_len,
+		    bool *result)
+{
+	int rc;
+	char *target, *tip = NULL;
+	struct sockaddr tipaddr;
+
+	*result = false;
+
+	target = kzalloc(share_len + 3, GFP_KERNEL);
+	if (!target) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	scnprintf(target, share_len + 3, "\\\\%.*s", (int)share_len, share);
+
+	cifs_dbg(FYI, "%s: target name: %s\n", __func__, target + 2);
+
+	rc = dns_resolve_server_name_to_ip(target, &tip);
+	if (rc < 0)
+		goto out;
+
+	cifs_dbg(FYI, "%s: target ip: %s\n", __func__, tip);
+
+	if (!cifs_convert_address(&tipaddr, tip, strlen(tip))) {
+		cifs_dbg(VFS, "%s: failed to convert target ip address\n",
+			 __func__);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	*result = cifs_match_ipaddr((struct sockaddr *)&server->dstaddr,
+				    &tipaddr);
+	cifs_dbg(FYI, "%s: ip addresses match: %u\n", __func__, *result);
+	rc = 0;
+
+out:
+	kfree(target);
+	kfree(tip);
+
+	return rc;
+}
+
 static void tcon_super_cb(struct super_block *sb, void *arg)
 {
 	struct super_cb_data *sd = arg;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b30aa3cdd845..cabc19f404e6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -160,6 +160,7 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
 			    struct cifs_tcon *tcon)
 {
 	int rc;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct dfs_cache_tgt_list tl;
 	struct dfs_cache_tgt_iterator *it = NULL;
 	char *tree;
@@ -172,15 +173,15 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
 	if (!tree)
 		return -ENOMEM;
 
-	if (tcon->ipc) {
-		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
-			  tcon->ses->server->hostname);
-		rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
-		goto out;
-	}
-
 	if (!tcon->dfs_path) {
-		rc = SMB2_tcon(0, tcon->ses, tcon->treeName, tcon, nlsc);
+		if (tcon->ipc) {
+			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
+				  server->hostname);
+			rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
+		} else {
+			rc = SMB2_tcon(0, tcon->ses, tcon->treeName, tcon,
+				       nlsc);
+		}
 		goto out;
 	}
 
@@ -188,13 +189,13 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
 	if (rc)
 		goto out;
 
-	extract_unc_hostname(tcon->ses->server->hostname, &tcp_host,
-			     &tcp_host_len);
+	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
 
 	for (it = dfs_cache_get_tgt_iterator(&tl); it;
 	     it = dfs_cache_get_next_tgt(&tl, it)) {
 		const char *share, *prefix;
 		size_t share_len, prefix_len;
+		bool target_match;
 
 		rc = dfs_cache_get_tgt_share(it, &share, &share_len, &prefix,
 					     &prefix_len);
@@ -208,19 +209,38 @@ static int __smb2_reconnect(const struct nls_table *nlsc,
 
 		if (dfs_host_len != tcp_host_len
 		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-			cifs_dbg(FYI, "%s: skipping %.*s, doesn't match %.*s",
+			cifs_dbg(FYI, "%s: %.*s doesn't match %.*s",
 				 __func__,
 				 (int)dfs_host_len, dfs_host,
 				 (int)tcp_host_len, tcp_host);
-			continue;
+
+			rc = match_target_ip(server, dfs_host, dfs_host_len,
+					     &target_match);
+			if (rc) {
+				cifs_dbg(VFS, "%s: failed to match target ip: %d\n",
+					 __func__, rc);
+				break;
+			}
+
+			if (!target_match) {
+				cifs_dbg(FYI, "%s: skipping target\n", __func__);
+				continue;
+			}
 		}
 
-		scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len, share);
-
-		rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
-		if (!rc) {
-			rc = update_super_prepath(tcon, prefix, prefix_len);
-			break;
+		if (tcon->ipc) {
+			scnprintf(tree, MAX_TREE_SIZE, "\\\\%.*s\\IPC$",
+				  (int)share_len, share);
+			rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
+		} else {
+			scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len,
+				  share);
+			rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
+			if (!rc) {
+				rc = update_super_prepath(tcon, prefix,
+							  prefix_len);
+				break;
+			}
 		}
 		if (rc == -EREMOTE)
 			break;
-- 
2.26.2

