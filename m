Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8271DC433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 16:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbiERQdC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 12:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiERQdB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 12:33:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337B18DACE
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 09:32:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 73B2F1F9BD;
        Wed, 18 May 2022 16:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652891576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LyynhIIrRelvuvIjA2C5ugKl9Q0I4nvo0nSAyjaDObo=;
        b=b2hpS6KhVc6n2JBSAwqkuzRNPlVuvPOs7bZK0Yt5e6JzktiQar/vrnuLQjbW9qlRwTHx0J
        kZU5Bi1se0gDGoI5S2f+7Fp0ERuPcwWeIm/7pwcdO8iUCYb7cygN/eneFD/K6ivqp78gEF
        qeQpJu3ErEZGmqReKJAq4tljhvBh3vg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652891576;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LyynhIIrRelvuvIjA2C5ugKl9Q0I4nvo0nSAyjaDObo=;
        b=H9I9g75zEAD25ShzgbUpzJ3xOFYJG0hi95xAq+V/GCDGF5N6K8o+1ReDarIefSnXyFH7nY
        nH4RXrtDB2llJyAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4405133F5;
        Wed, 18 May 2022 16:32:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id d9+5KLcfhWKnagAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 May 2022 16:32:55 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2] cifs: don't call cifs_dfs_query_info_nonascii_quirk() if nodfs was set
Date:   Wed, 18 May 2022 13:31:55 -0300
Message-Id: <20220518163155.28520-1-ematsumiya@suse.de>
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
v2: remove useles !nodfs check before calling
    cifs_dfs_query_info_nonascii_quirk()

 fs/cifs/connect.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 42e14f408856..0505d7782e42 100644
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
+	if (nodfs) {
+		if (rc == -EREMOTE)
+			rc = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* path *might* exist with non-ASCII characters in DFS root
+	 * try again with full path (only if nodfs is not set) */
 	if (rc == -ENOENT && is_tcon_dfs(tcon))
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

