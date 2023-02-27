Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8C3C64ED8
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Feb 2023 13:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB0Nxm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Feb 2023 08:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB0Nxl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Feb 2023 08:53:41 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B811653
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 05:53:40 -0800 (PST)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677506017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RiRtH6IA+mG95Rpz097sgZ8XUAgs+X49fs6C8U3exHI=;
        b=hJnDspqMX7BCElvwL/tzid/zupSAfhBq/QNuBdW81Gpg4BN6WAzO50HgIdXlxmFq4vuMow
        bpKjvYOBSdiIU+d8o8qgtITJpwHwiEfojVVBhpacCIQblasWyv1yKkHHHFoZYttPeFDjaX
        H+zWfcUSy8fVtxLgcPMLMJtC6YOsnlAAhKGuDkW0zUXTCpVrzsek4YdNNsWEV9xbtB1M1d
        /XNubJmiTTYoTDcVcfsH/44C0Y0Z8A6UVa5LGLZsbM4BYUs5K9IVlapZTOBBOjcu5WuKIQ
        4xpNxnbNj88AzOHzFaGHb0ctzRMR7tBH67o7BNf6Da/7HB9uPeK6Kk4A8huIWg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677506017; a=rsa-sha256;
        cv=none;
        b=lKay26RnJk7Zl3FfvNCSAti9kFcrNFWlL1LUyd14MCli6cFudZcMOBXFthEOjGM8H5Lgih
        laa+lzvMt5ry844uHRUS/0C4okaqlBZ0LHQkwEB1XcxKkOtgrtu+2b/d08C/dAbcsoET6N
        qpXxOx44DngPB3JUu7DgMBiUEoySk19jOx/RsPb3SvpQ8yysT8OxcJOzEFOj6fE9mx0kqS
        pGgRRq4d4ZoiiCCs4qxAoMY1Z35qdSF5Ti1vMSlYhkWx7K2GhNUFZIHgBPgQtMz5GUaAZl
        CZ59DM+tKL9FW6bPR4qiMx4sE45W1i+aGNF/9zIFrgC3JEz/j25mp9Yk3snDig==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677506017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RiRtH6IA+mG95Rpz097sgZ8XUAgs+X49fs6C8U3exHI=;
        b=c8L38FG8CqNarQFsg9EtBLSQa+iW3ArkL352+tq37sJTStoLAl1oLDL9LEKO54neztVaJU
        kZ9K0VKYHyiYVipPbuNpY2KTvh+MC6ea3XNLc3bWW8gS0RAzbJYiFvq6Wu4I+6dpSOZHQP
        9idIwX+HtZZIGHrqs7QUE8eL1Im/YyOgbpYzBdTeWH79i81rx3ZjvS4g6agUtswIIgI1v0
        79A2+YezKx9tFABOI4toOTxGBHcFVz4iDOmuDl5mhZzWSTAVs2FO2UW9qjTxK2cusm+Bru
        rKD9omsIPDgwqxsgfH0IPwBEg6gRWBB6QWp+ERCF//oRud/fBrhrn1uR/uhi5g==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/2] cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID
Date:   Mon, 27 Feb 2023 10:53:22 -0300
Message-Id: <20230227135323.26712-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do not map STATUS_OBJECT_NAME_INVALID to -EREMOTE under non-DFS
shares, or 'nodfs' mounts or CONFIG_CIFS_DFS_UPCALL=n builds.
Otherwise, in the slow path, get a referral to figure out whether it
is an actual DFS link.

This could be simply reproduced under a non-DFS share by running the
following

  $ mount.cifs //srv/share /mnt -o ...
  $ cat /mnt/$(printf '\U110000')
  cat: '/mnt/'$'\364\220\200\200': Object is remote

Fixes: c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsproto.h | 20 ++++++++++----
 fs/cifs/misc.c      | 66 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2inode.c | 21 ++++++++-------
 fs/cifs/smb2ops.c   | 23 +++++++++-------
 4 files changed, 105 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b7a36ebd0f2f..20a2f0f3f682 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -667,11 +667,21 @@ static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
 int match_target_ip(struct TCP_Server_Info *server,
 		    const char *share, size_t share_len,
 		    bool *result);
-
-int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
-				       struct cifs_tcon *tcon,
-				       struct cifs_sb_info *cifs_sb,
-				       const char *dfs_link_path);
+int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink);
+#else
+static inline int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink)
+{
+	*islink = false;
+	return 0;
+}
 #endif
 
 static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 2905734eb289..003b0a522fea 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -21,6 +21,7 @@
 #include "cifsfs.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dns_resolve.h"
+#include "dfs_cache.h"
 #endif
 #include "fs_context.h"
 #include "cached_dir.h"
@@ -1198,4 +1199,69 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	return 0;
 }
+
+/*
+ * Handle weird Windows SMB server behaviour. It responds with
+ * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request for
+ * "\<server>\<dfsname>\<linkpath>" DFS reference, where <dfsname> contains
+ * non-ASCII unicode symbols.
+ */
+int cifs_inval_name_dfs_link_error(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   const char *full_path,
+				   bool *islink)
+{
+	struct cifs_ses *ses = tcon->ses;
+	size_t len;
+	char *path;
+	char *ref_path;
+
+	*islink = false;
+
+	/*
+	 * Fast path - skip check when @full_path doesn't have a prefix path to
+	 * look up or tcon is not DFS.
+	 */
+	if (strlen(full_path) < 2 || !cifs_sb ||
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
+	    !is_tcon_dfs(tcon) || !ses->server->origin_fullpath)
+		return 0;
+
+	/*
+	 * Slow path - tcon is DFS and @full_path has prefix path, so attempt
+	 * to get a referral to figure out whether it is an DFS link.
+	 */
+	len = strnlen(tcon->tree_name, MAX_TREE_SIZE + 1) + strlen(full_path) + 1;
+	path = kmalloc(len, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	scnprintf(path, len, "%s%s", tcon->tree_name, full_path);
+	ref_path = dfs_cache_canonical_path(path + 1, cifs_sb->local_nls,
+					    cifs_remap(cifs_sb));
+	if (IS_ERR(ref_path)) {
+		if (PTR_ERR(ref_path) != -EINVAL)
+			return PTR_ERR(ref_path);
+	} else if (ses->server->ops->get_dfs_refer) {
+		struct dfs_info3_param *refs = NULL;
+		int num_refs = 0;
+
+		/*
+		 * XXX: we are not using dfs_cache_find() here because we might
+		 * end filling all the DFS cache and thus potentially
+		 * removing cached DFS targets that the client would eventually
+		 * need during failover.
+		 */
+		if (!ses->server->ops->get_dfs_refer(xid, ses, ref_path, &refs,
+						     &num_refs, cifs_sb->local_nls,
+						     cifs_remap(cifs_sb)))
+			*islink = refs[0].server_type == DFS_TYPE_LINK;
+		free_dfs_info_array(refs, num_refs);
+		kfree(ref_path);
+	}
+
+	kfree(path);
+	return 0;
+}
 #endif
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 37b4cd59245d..9b956294e864 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -527,12 +527,13 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb, const char *full_path,
 			 struct cifs_open_info_data *data, bool *adjust_tz, bool *reparse)
 {
-	int rc;
 	__u32 create_options = 0;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
 	struct kvec err_iov[3] = {};
 	int err_buftype[3] = {};
+	bool islink;
+	int rc, rc2;
 
 	*adjust_tz = false;
 	*reparse = false;
@@ -580,15 +581,15 @@ int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 					      SMB2_OP_QUERY_INFO, cfile, NULL, NULL,
 					      NULL, NULL);
 			goto out;
-		} else if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
-			   hdr->Status == STATUS_OBJECT_NAME_INVALID) {
-			/*
-			 * Handle weird Windows SMB server behaviour. It responds with
-			 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
-			 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
-			 * where <dfsname> contains non-ASCII unicode symbols.
-			 */
-			rc = -EREMOTE;
+		} else if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
+							     full_path, &islink);
+			if (rc2) {
+				rc = rc2;
+				goto out;
+			}
+			if (islink)
+				rc = -EREMOTE;
 		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f79b075f2992..6dfb865ee9d7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -796,7 +796,6 @@ static int
 smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
 	__le16 *utf16_path;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	int err_buftype = CIFS_NO_BUFFER;
@@ -804,6 +803,8 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec err_iov = {};
 	struct cifs_fid fid;
 	struct cached_fid *cfid;
+	bool islink;
+	int rc, rc2;
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
 	if (!rc) {
@@ -833,15 +834,17 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 		if (unlikely(!hdr || err_buftype == CIFS_NO_BUFFER))
 			goto out;
-		/*
-		 * Handle weird Windows SMB server behaviour. It responds with
-		 * STATUS_OBJECT_NAME_INVALID code to SMB2 QUERY_INFO request
-		 * for "\<server>\<dfsname>\<linkpath>" DFS reference,
-		 * where <dfsname> contains non-ASCII unicode symbols.
-		 */
-		if (rc != -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) &&
-		    hdr->Status == STATUS_OBJECT_NAME_INVALID)
-			rc = -EREMOTE;
+
+		if (rc != -EREMOTE && hdr->Status == STATUS_OBJECT_NAME_INVALID) {
+			rc2 = cifs_inval_name_dfs_link_error(xid, tcon, cifs_sb,
+							     full_path, &islink);
+			if (rc2) {
+				rc = rc2;
+				goto out;
+			}
+			if (islink)
+				rc = -EREMOTE;
+		}
 		if (rc == -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) && cifs_sb &&
 		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
 			rc = -EOPNOTSUPP;
-- 
2.39.2

