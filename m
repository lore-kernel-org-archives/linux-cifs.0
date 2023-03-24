Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06126C6FD1C
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 16:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCXQ4o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjCXQ4n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 12:56:43 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8587CA9
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 09:56:42 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679677000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+swoB9cir7CdV+UF2zOItQXXE6oCK43tQ1ufYulnD1U=;
        b=ahFSwELGTFzOj6ipfi1fJuoRGw3oFU9nxoPBETOY8WsvEtBhzFUWqI7zVscKiGzh2YnPZr
        ESp4peJZy68Q9kDjsTpJvnsSMTkER5bA/2M5j0cV+XqEzGArHY5YblH0C3CbVMkLfPOVfY
        S79jUhXIGZdpdQsnkMVJhskgKWJ73ilWCmCANDeoAl956sZBO44pyl3d59F2aKijNSHAzy
        yv/TbL9owTvTlnSGI5U1dKyGeW1dtiHbSvPBQOAlzFGR2AvewwNJVTlsnBAio0de609O+7
        tu2GNeui8C/y1Ec16XyQexn6w6Gf6erTeE4HGUl6BmFw1ajmP+UrHchV8nCC7A==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1679677000; a=rsa-sha256;
        cv=none;
        b=dvJkY5NkhruYXpRmEACRFWYjfLESE1m5LSBQUBKyHn2Nvduo79KUiX2WQUeMKvAEwnPFMX
        CpQwkXyIVZ4DOgEIc5eFAHZhasmw0s/+kxIx3nwVQ0O2cmw5iIlmRvP6PjYY6YclC3RIe0
        smETR44p/E9NHqq9hexvD3J/lTF0YKWvpVeFDanVKS/6Zl4hwVVEQ9IRsIGXjMHpOOcEar
        EyhKekReAHlPYbH6dULRDyT+NlMruImUC9i1/Y641/MQQIoCPtUGVWRdI22PrOdGtX3L05
        z7IO87yRqThYp4ExRUhL2OBH9YSlqvmtZWT//OjLs+u1xFtEW9sB3Q0yd7AKfw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679677000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+swoB9cir7CdV+UF2zOItQXXE6oCK43tQ1ufYulnD1U=;
        b=A1qEW0RbI/G7f83ozeXc0RkNqNfCIgJixkJIEVLBVEAQubkeBqOsRRHzk2md72j3uyz3Jq
        hnJ3x4gPMseHyq77WvF6rq9ve9M2e4Hn6RT8FAyqBBKFqodYx+8pZJcFVlRCfLOAruktIu
        oiTJozJN5vkhw56s8yf9X3RF3cuCNiiASaREmmQit9jyfoajU0+O/ykw2q0GeNTZWWhw1W
        hQikAyl6pEOrNDzXtTXCt3OopENSOdaLDAH/s9eCuGkq4SwhpklYaPtJVm6uyh121rNbaw
        ZN22kR+X5Zpd9H2DN7mg02FQ/0gvsgHyfy9zT4X9Jh+PElXvJzqLb+iNet4idQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] cifs: fix dentry lookups in directory handle cache
Date:   Fri, 24 Mar 2023 13:56:33 -0300
Message-Id: <20230324165633.22702-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Get rid of any prefix paths in @path before lookup_positive_unlocked()
as it will call ->lookup() which already adds those prefix paths
through build_path_from_dentry().

This has caused a performance regression when mounting shares with a
prefix path where readdir(2) would end up retrying several times to
open bad directory names that contained duplicate prefix paths.

Fix this by skipping any prefix paths in @path before calling
lookup_positive_unlocked().

Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root directories also")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cached_dir.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 71fabb4c09a4..bfc964b36c72 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -99,6 +99,23 @@ path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
 	return dentry;
 }
 
+static const char *path_no_prefix(struct cifs_sb_info *cifs_sb,
+				  const char *path)
+{
+	size_t len = 0;
+
+	if (!*path)
+		return path;
+
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+	    cifs_sb->prepath) {
+		len = strlen(cifs_sb->prepath) + 1;
+		if (unlikely(len > strlen(path)))
+			return ERR_PTR(-EINVAL);
+	}
+	return path + len;
+}
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
@@ -125,6 +142,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct dentry *dentry = NULL;
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
+	const char *npath;
 
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
@@ -160,6 +178,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return 0;
 	}
 
+	/*
+	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
+	 * calling ->lookup() which already adds those through
+	 * build_path_from_dentry().  Also, do it earlier as we might reconnect
+	 * below when trying to send compounded request and then potentially
+	 * having a different prefix path (e.g. after DFS failover).
+	 */
+	npath = path_no_prefix(cifs_sb, path);
+	if (IS_ERR(npath)) {
+		rc = PTR_ERR(npath);
+		kfree(utf16_path);
+		return rc;
+	}
+
 	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
@@ -252,10 +284,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!path[0])
+	if (!npath[0])
 		dentry = dget(cifs_sb->root);
 	else {
-		dentry = path_to_dentry(cifs_sb, path);
+		dentry = path_to_dentry(cifs_sb, npath);
 		if (IS_ERR(dentry)) {
 			rc = -ENOENT;
 			goto oshr_free;
-- 
2.40.0

