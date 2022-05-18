Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F06C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 14:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbiEROm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 10:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiEROmX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 10:42:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B361C15D8
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 07:42:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 81C0221AA3;
        Wed, 18 May 2022 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652884940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tSQNei5NjtYiobKuvdGd+72BEPbPztjZq6AqyBPb560=;
        b=KxLaWv/hrvak26Pf6ERYdlwPBNdjMCYd7Sks8qarR4e0yYINt1T8Dg64K8gmPjf9VVPWzF
        Dsx5maLw7wn/SqreDXL1KLDZm8G40137pNL9Gy5pWdvsW64sPIjesEGiusN3/dhkvTBApH
        wt+iTyesMWk8CA16nB6xIQZbkAIfAqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652884940;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tSQNei5NjtYiobKuvdGd+72BEPbPztjZq6AqyBPb560=;
        b=b6YkqZKjICqI6Ry/h4i2W/UZZSIi3gg2GVs14bVio99tXR0zgDLdvzZOuZwvE1tu16E/b/
        O35dZ3E67hCyjOAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0117133F5;
        Wed, 18 May 2022 14:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 89bTK8sFhWJdNQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 May 2022 14:42:19 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: don't call cifs_dfs_query_info_nonascii_quirk() if nodfs was set
Date:   Wed, 18 May 2022 11:41:03 -0300
Message-Id: <20220518144105.21913-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also return EOPNOTSUPP if path is remote but nodfs was set.

Fixes: a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned for non-ASCII dfs refs")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 42e14f408856..1ef3d16a8bda 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3432,6 +3432,7 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 	struct cifs_tcon *tcon = mnt_ctx->tcon;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *full_path;
+	bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
 
 	if (!server->ops->is_path_accessible)
 		return -EOPNOTSUPP;
@@ -3449,14 +3450,20 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	if (rc == -ENOENT && is_tcon_dfs(tcon))
+	if (nodfs) {
+		if (rc == -EREMOTE)
+			rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* path *might* exist with non-ASCII characters in DFS root
+	 * try again with full path (only if nodfs is not set) */
+	if (rc == -ENOENT && is_tcon_dfs(tcon) && !nodfs)
 		rc = cifs_dfs_query_info_nonascii_quirk(xid, tcon, cifs_sb,
 							full_path);
 #endif
-	if (rc != 0 && rc != -EREMOTE) {
-		kfree(full_path);
-		return rc;
-	}
+	if (rc != 0 && rc != -EREMOTE)
+		goto out;
 
 	if (rc != -EREMOTE) {
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
@@ -3468,6 +3475,7 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 		}
 	}
 
+out:
 	kfree(full_path);
 	return rc;
 }
-- 
2.36.1

