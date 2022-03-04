Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46957C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Mar 2022 16:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240743AbiCDQZV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCDQZU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Mar 2022 11:25:20 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E18C1C2D8C
        for <linux-cifs@vger.kernel.org>; Fri,  4 Mar 2022 08:24:32 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 34A18808C1;
        Fri,  4 Mar 2022 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1646411070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ig2F6uo0V+ywXYOMpGZdT4yDySs7NqZYZUXEDqyi38w=;
        b=KfnMIweZiwdLZSXzV/xxvV05sBRQkAuCBI25fLw6dCxsUInG+AT+akpRY4kbIf0Z1/pdDJ
        3d56yKOO/aNi+ADhhvqLNlat+uLtwGXnM7WfRZ3FZzwPZK2n5+c5S4lZnBoitnWXLblQe9
        Ek4qvDMmxMLA56pGAKBNg3JpuR9qvFvbDswItVV99Q8KvIqhOje/s8GyxLk6r0K0jsWiU+
        deCxjAdmNqdEXopylRUfEuCdfE8NCzxvlV3SiDdATSLOFx6es0BIdTvkZvHVleY0X2dIz+
        GoMTpPXRhd61RkXcHUzi4uK2a+Q/Z1cXmQKrckeJ0r/Gf+dK8eekjOhn/l26yg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: do not skip link targets when an I/O fails
Date:   Fri,  4 Mar 2022 13:22:15 -0300
Message-Id: <20220304162215.25536-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When I/O fails in one of the currently connected DFS targets, retry it
from other targets as specified in MS-DFSC "3.1.5.2 I/O Operation to
+Target Fails with an Error Other Than STATUS_PATH_NOT_COVERED."

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 053cb449eb16..79b5f20c38e7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3473,6 +3473,9 @@ static int connect_dfs_target(struct mount_ctx *mnt_ctx, const char *full_path,
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	char *oldmnt = cifs_sb->ctx->mount_options;
 
+	cifs_dbg(FYI, "%s: full_path=%s ref_path=%s target=%s\n", __func__, full_path, ref_path,
+		 dfs_cache_get_tgt_name(tit));
+
 	rc = dfs_cache_get_tgt_referral(ref_path, tit, &ref);
 	if (rc)
 		goto out;
@@ -3571,13 +3574,18 @@ static int __follow_dfs_link(struct mount_ctx *mnt_ctx)
 	if (rc)
 		goto out;
 
-	/* Try all dfs link targets */
+	/* Try all dfs link targets.  If an I/O fails from currently connected DFS target with an
+	 * error other than STATUS_PATH_NOT_COVERED (-EREMOTE), then retry it from other targets as
+	 * specified in MS-DFSC "3.1.5.2 I/O Operation to Target Fails with an Error Other Than
+	 * STATUS_PATH_NOT_COVERED."
+	 */
 	for (rc = -ENOENT, tit = dfs_cache_get_tgt_iterator(&tl);
 	     tit; tit = dfs_cache_get_next_tgt(&tl, tit)) {
 		rc = connect_dfs_target(mnt_ctx, full_path, mnt_ctx->leaf_fullpath + 1, tit);
 		if (!rc) {
 			rc = is_path_remote(mnt_ctx);
-			break;
+			if (!rc || rc == -EREMOTE)
+				break;
 		}
 	}
 
@@ -3651,7 +3659,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		goto error;
 
 	rc = is_path_remote(&mnt_ctx);
-	if (rc == -EREMOTE)
+	if (rc)
 		rc = follow_dfs_link(&mnt_ctx);
 	if (rc)
 		goto error;
-- 
2.35.1

