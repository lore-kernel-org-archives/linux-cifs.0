Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080CCC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jan 2022 19:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiANTxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jan 2022 14:53:44 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:45618 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANTxo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jan 2022 14:53:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id DE63230637FC;
        Fri, 14 Jan 2022 22:53:42 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id buaCsRl3SEOW; Fri, 14 Jan 2022 22:53:42 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id EBE2E30637FD;
        Fri, 14 Jan 2022 22:53:41 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ktjw8ZS20BOj; Fri, 14 Jan 2022 22:53:41 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id BD1A030637FB;
        Fri, 14 Jan 2022 22:53:41 +0300 (MSK)
Date:   Fri, 14 Jan 2022 22:53:40 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>
Subject: [PATCH v2 2/2] cifs: quirk for STATUS_OBJECT_NAME_INVALID returned
 for non-ASCII dfs refs
Message-ID: <YeHUxJ9zTVNrKveF@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Windows SMB server responds with STATUS_OBJECT_NAME_INVALID code to
SMB2 QUERY_INFO request for "\<server>\<dfsname>\<linkpath>" DFS reference,
where <dfsname> contains non-ASCII unicode symbols.

Check such DFS reference and emulate -EREMOTE if it is actual.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215440
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
---
v2: No changes, this is a new patch in the patchset for #215440 fix

 fs/cifs/cifsproto.h |  5 +++++
 fs/cifs/connect.c   |  5 +++++
 fs/cifs/inode.c     |  6 ++++++
 fs/cifs/misc.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4f5a3e857df4..b3a9cc0def2c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -626,6 +626,11 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 int match_target_ip(struct TCP_Server_Info *server,
 		    const char *share, size_t share_len,
 		    bool *result);
+
+int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
+				       struct cifs_tcon *tcon,
+				       struct cifs_sb_info *cifs_sb,
+				       const char *dfs_link_path);
 #endif
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1060164b984a..db0f8a1c8fb5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3322,6 +3322,11 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	if (rc == -ENOENT && is_tcon_dfs(tcon))
+		rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
+							full_path);
+#endif
 	if (rc != 0 && rc != -EREMOTE) {
 		kfree(full_path);
 		return rc;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 279622e4eb1c..baa197edd8c5 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -952,6 +952,12 @@ cifs_get_inode_info(struct inode **inode,
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 						 full_path, tmp_data,
 						 &adjust_tz, &is_reparse_point);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		if (rc == -ENOENT && is_tcon_dfs(tcon))
+			rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon,
+								cifs_sb,
+								full_path);
+#endif
 		data = tmp_data;
 	}
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5148d48d6a35..56598f7dbe00 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1302,4 +1302,53 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
 }
+
+/** cifs_dfs_query_info_nonascii_quirk
+ * Handle weird Windows SMB server behaviour. It responds with
+ * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
+ * for "\<server>\<dfsname>\<linkpath>" DFS reference,
+ * where <dfsname> contains non-ASCII unicode symbols.
+ *
+ * Check such DFS reference and emulate -ENOENT if it is actual.
+ */
+int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
+				       struct cifs_tcon *tcon,
+				       struct cifs_sb_info *cifs_sb,
+				       const char *linkpath)
+{
+	char *treename, *dfspath, sep;
+	int treenamelen, linkpathlen, rc;
+
+	treename = tcon->treeName;
+	/* MS-DFSC: All paths in REQ_GET_DFS_REFERRAL and RESP_GET_DFS_REFERRAL
+	 * messages MUST be encoded with exactly one leading backslash, not two
+	 * leading backslashes.
+	 */
+	sep = CIFS_DIR_SEP(cifs_sb);
+	if (treename[0] == sep && treename[1] == sep)
+		treename++;
+	linkpathlen = strlen(linkpath);
+	treenamelen = strnlen(treename, MAX_TREE_SIZE + 1);
+	dfspath = kzalloc(treenamelen + linkpathlen + 1, GFP_KERNEL);
+	if (!dfspath)
+		return -ENOMEM;
+	if (treenamelen)
+		memcpy(dfspath, treename, treenamelen);
+	memcpy(dfspath + treenamelen, linkpath, linkpathlen);
+	rc = dfs_cache_find(xid, tcon->ses, cifs_sb->local_nls,
+			    cifs_remap(cifs_sb), dfspath, NULL, NULL);
+	if (rc == 0) {
+		cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
+			 dfspath);
+		rc = -EREMOTE;
+	} else if (rc == -EEXIST) {
+		cifs_dbg(FYI, "DFS ref '%s' is not found, emulate -ENOENT\n",
+			 dfspath);
+		rc = -ENOENT;
+	} else {
+		cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
+	}
+	kfree(dfspath);
+	return rc;
+}
 #endif
-- 
2.30.2

