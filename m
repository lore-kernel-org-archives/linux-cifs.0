Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5FCC35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6526F20828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oJ8XgNIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBXNPz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:15:55 -0500
Received: from hr2.samba.org ([144.76.82.148]:41900 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNPy (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=vu0pVT1lrXHDDTgbpKPX4XwbIiTXPfElsbKsEY3oTqY=; b=oJ8XgNINFbqHDmFVHOUj8/VLGX
        4lVC0/USiFYdVIDbK/fLwMoz11D+MaCk9Nx17p0A+LEgCAxL4j1Ei6kSz6YmS7ZJh9Ag4o9UHSDwC
        giHSxbDCbbJwPH5Ze+ypz6Trd0ip6xCkucVYdvc+0KUtmvTDu3FrJnF1QzBo/KRuuPu8feRh25wUV
        V7QR+yrappNDxSESMz+a2PItNTrG4G9oc2G2RFq9VH/lMSEsTw4rh09qgaWvbUWpNybm+GkUBJt84
        7YauAJCO8ZLn/36BI3w7P0oOV3JxBPovXX33n9N+XdAPy0XbUHnvOGiQqDKhqULzDEhneFDqve5rr
        g5zmjhE9VwS8dkXZOVZjyaFOb3RjlJPy7SFujfokd4wOEmhkTuyhF3OS7iGoNqVJLGLOZpM3Vx8xv
        OwQywnksWr6iS56Lwnbn7YuIbe7I5yHaGcKAksz8tEXrUZkOSk70eVcktM5elZtMylJcWwoVDiuPO
        qy51gCoGzNq2U1w051h/C7dQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaQ-00061e-Hz; Mon, 24 Feb 2020 13:15:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 05/13] cifs: merge __{cifs,smb2}_reconnect[_tcon]() into cifs_tree_connect()
Date:   Mon, 24 Feb 2020 14:15:02 +0100
Message-Id: <20200224131510.20608-6-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

They were identical execpt to CIFSTCon() vs. SMB2_tcon().
These are also available via ops->tree_connect().

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifsproto.h |  3 ++
 fs/cifs/cifssmb.c   | 82 +------------------------------------------
 fs/cifs/connect.c   | 84 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 82 +------------------------------------------
 4 files changed, 89 insertions(+), 162 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e2624ebad189..4c93007e44c0 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -263,6 +263,9 @@ extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
 extern void cifs_free_llist(struct list_head *llist);
 extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
 
+extern int cifs_tree_connect(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     const struct nls_table *nlsc);
 extern int cifs_connect_session_locked(const unsigned int xid,
 				       struct cifs_ses *ses,
 				       struct nls_table *nls_info,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index dcb009fade8c..412d141e1adc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -124,86 +124,6 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	 */
 }
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
-static int __cifs_reconnect_tcon(const struct nls_table *nlsc,
-				 struct cifs_tcon *tcon)
-{
-	int rc;
-	struct dfs_cache_tgt_list tl;
-	struct dfs_cache_tgt_iterator *it = NULL;
-	char *tree;
-	const char *tcp_host;
-	size_t tcp_host_len;
-	const char *dfs_host;
-	size_t dfs_host_len;
-
-	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
-	if (!tree)
-		return -ENOMEM;
-
-	if (tcon->ipc) {
-		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
-			  tcon->ses->server->hostname);
-		rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
-		goto out;
-	}
-
-	if (!tcon->dfs_path) {
-		rc = CIFSTCon(0, tcon->ses, tcon->treeName, tcon, nlsc);
-		goto out;
-	}
-
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, NULL, &tl);
-	if (rc)
-		goto out;
-
-	extract_unc_hostname(tcon->ses->server->hostname, &tcp_host,
-			     &tcp_host_len);
-
-	for (it = dfs_cache_get_tgt_iterator(&tl); it;
-	     it = dfs_cache_get_next_tgt(&tl, it)) {
-		const char *tgt = dfs_cache_get_tgt_name(it);
-
-		extract_unc_hostname(tgt, &dfs_host, &dfs_host_len);
-
-		if (dfs_host_len != tcp_host_len
-		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-			cifs_dbg(FYI, "%s: skipping %.*s, doesn't match %.*s",
-				 __func__,
-				 (int)dfs_host_len, dfs_host,
-				 (int)tcp_host_len, tcp_host);
-			continue;
-		}
-
-		scnprintf(tree, MAX_TREE_SIZE, "\\%s", tgt);
-
-		rc = CIFSTCon(0, tcon->ses, tree, tcon, nlsc);
-		if (!rc)
-			break;
-		if (rc == -EREMOTE)
-			break;
-	}
-
-	if (!rc) {
-		if (it)
-			rc = dfs_cache_noreq_update_tgthint(tcon->dfs_path + 1,
-							    it);
-		else
-			rc = -ENOENT;
-	}
-	dfs_cache_free_tgts(&tl);
-out:
-	kfree(tree);
-	return rc;
-}
-#else
-static inline int __cifs_reconnect_tcon(const struct nls_table *nlsc,
-					struct cifs_tcon *tcon)
-{
-	return CIFSTCon(0, tcon->ses, tcon->treeName, tcon, nlsc);
-}
-#endif
-
 /* reconnect the socket, tcon, and smb session if needed */
 static int
 cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
@@ -301,7 +221,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 
 	cifs_mark_open_files_invalid(tcon);
-	rc = __cifs_reconnect_tcon(nls_codepage, tcon);
+	rc = cifs_tree_connect(0, tcon, nls_codepage);
 	mutex_unlock(&ses->session_mutex);
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 34269ef40774..c243c9a1b3d4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5290,6 +5290,90 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
+int cifs_tree_connect(const unsigned int xid,
+		      struct cifs_tcon *tcon,
+		      const struct nls_table *nlsc)
+{
+	const struct smb_version_operations *ops = tcon->ses->server->ops;
+	int rc;
+	struct dfs_cache_tgt_list tl;
+	struct dfs_cache_tgt_iterator *it = NULL;
+	char *tree;
+	const char *tcp_host;
+	size_t tcp_host_len;
+	const char *dfs_host;
+	size_t dfs_host_len;
+
+	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
+	if (!tree)
+		return -ENOMEM;
+
+	if (tcon->ipc) {
+		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
+			  tcon->ses->server->hostname);
+		rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+		goto out;
+	}
+
+	if (!tcon->dfs_path) {
+		rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+		goto out;
+	}
+
+	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, NULL, &tl);
+	if (rc)
+		goto out;
+
+	extract_unc_hostname(tcon->ses->server->hostname, &tcp_host,
+			     &tcp_host_len);
+
+	for (it = dfs_cache_get_tgt_iterator(&tl); it;
+	     it = dfs_cache_get_next_tgt(&tl, it)) {
+		const char *tgt = dfs_cache_get_tgt_name(it);
+
+		extract_unc_hostname(tgt, &dfs_host, &dfs_host_len);
+
+		if (dfs_host_len != tcp_host_len
+		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
+			cifs_dbg(FYI, "%s: skipping %.*s, doesn't match %.*s",
+				 __func__,
+				 (int)dfs_host_len, dfs_host,
+				 (int)tcp_host_len, tcp_host);
+			continue;
+		}
+
+		scnprintf(tree, MAX_TREE_SIZE, "\\%s", tgt);
+
+		rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+		if (!rc)
+			break;
+		if (rc == -EREMOTE)
+			break;
+	}
+
+	if (!rc) {
+		if (it)
+			rc = dfs_cache_noreq_update_tgthint(tcon->dfs_path + 1,
+							    it);
+		else
+			rc = -ENOENT;
+	}
+	dfs_cache_free_tgts(&tl);
+out:
+	kfree(tree);
+	return rc;
+}
+#else
+int cifs_tree_connect(const unsigned int xid,
+		      struct cifs_tcon *tcon,
+		      const struct nls_table *nlsc)
+{
+	const struct smb_version_operations *ops = tcon->ses->server->ops;
+	return ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+}
+#endif
+
 int
 cifs_connect_session_locked(const unsigned int xid,
 			    struct cifs_ses *ses,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a15a53d2e808..715a50ffb234 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -155,86 +155,6 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
-static int __smb2_reconnect(const struct nls_table *nlsc,
-			    struct cifs_tcon *tcon)
-{
-	int rc;
-	struct dfs_cache_tgt_list tl;
-	struct dfs_cache_tgt_iterator *it = NULL;
-	char *tree;
-	const char *tcp_host;
-	size_t tcp_host_len;
-	const char *dfs_host;
-	size_t dfs_host_len;
-
-	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
-	if (!tree)
-		return -ENOMEM;
-
-	if (tcon->ipc) {
-		scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$",
-			  tcon->ses->server->hostname);
-		rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
-		goto out;
-	}
-
-	if (!tcon->dfs_path) {
-		rc = SMB2_tcon(0, tcon->ses, tcon->treeName, tcon, nlsc);
-		goto out;
-	}
-
-	rc = dfs_cache_noreq_find(tcon->dfs_path + 1, NULL, &tl);
-	if (rc)
-		goto out;
-
-	extract_unc_hostname(tcon->ses->server->hostname, &tcp_host,
-			     &tcp_host_len);
-
-	for (it = dfs_cache_get_tgt_iterator(&tl); it;
-	     it = dfs_cache_get_next_tgt(&tl, it)) {
-		const char *tgt = dfs_cache_get_tgt_name(it);
-
-		extract_unc_hostname(tgt, &dfs_host, &dfs_host_len);
-
-		if (dfs_host_len != tcp_host_len
-		    || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-			cifs_dbg(FYI, "%s: skipping %.*s, doesn't match %.*s",
-				 __func__,
-				 (int)dfs_host_len, dfs_host,
-				 (int)tcp_host_len, tcp_host);
-			continue;
-		}
-
-		scnprintf(tree, MAX_TREE_SIZE, "\\%s", tgt);
-
-		rc = SMB2_tcon(0, tcon->ses, tree, tcon, nlsc);
-		if (!rc)
-			break;
-		if (rc == -EREMOTE)
-			break;
-	}
-
-	if (!rc) {
-		if (it)
-			rc = dfs_cache_noreq_update_tgthint(tcon->dfs_path + 1,
-							    it);
-		else
-			rc = -ENOENT;
-	}
-	dfs_cache_free_tgts(&tl);
-out:
-	kfree(tree);
-	return rc;
-}
-#else
-static inline int __smb2_reconnect(const struct nls_table *nlsc,
-				   struct cifs_tcon *tcon)
-{
-	return SMB2_tcon(0, tcon->ses, tcon->treeName, tcon, nlsc);
-}
-#endif
-
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
@@ -356,7 +276,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	if (tcon->use_persistent)
 		tcon->need_reopen_files = true;
 
-	rc = __smb2_reconnect(nls_codepage, tcon);
+	rc = cifs_tree_connect(0, tcon, nls_codepage);
 	mutex_unlock(&tcon->ses->session_mutex);
 
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
-- 
2.17.1

