Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B42C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 14:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiEROmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 10:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiEROmi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 10:42:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC40B36CD
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 07:42:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9EE2B21B24;
        Wed, 18 May 2022 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652884956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/u5LHfh6peIemwjob6auURANxMplGrikqvtf9yxL+68=;
        b=jRV+daG14A1iOBRlLrm/zkPKI7Gm4FZRoKXfRjJDabOnw763St6nY91WXrPIeUipJOruaL
        dC5sGmiFFvjIsQRk8lNUqYftzW2xIe4gOOHDSLkXhfLcad7Dx+SNTuHwu2jSvFhDIAfDfj
        L2SGYLLjZgwRjMFVpJJo/EIwa9xXWXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652884956;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/u5LHfh6peIemwjob6auURANxMplGrikqvtf9yxL+68=;
        b=VmEAXxcDouKdo3tdAfcCn2bNorjEeqfE4WMf919V5q8Ss/ZNEAd1mFIoezKYIAn/xdf3Rd
        AO7pGsYLkMRPIhAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18390133F5;
        Wed, 18 May 2022 14:42:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZsEzMtsFhWJ+NQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 May 2022 14:42:35 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: return ENOENT for DFS lookup_cache_entry()
Date:   Wed, 18 May 2022 11:41:05 -0300
Message-Id: <20220518144105.21913-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518144105.21913-1-ematsumiya@suse.de>
References: <20220518144105.21913-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

EEXIST didn't make sense to use when dfs_cache_find() couldn't find a
cache entry nor retrieve a referral target.

It also doesn't make sense cifs_dfs_query_info_nonascii_quirk() to
emulate ENOENT anymore.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c   | 6 ++++--
 fs/cifs/dfs_cache.c | 6 +++---
 fs/cifs/misc.c      | 6 +-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1ef3d16a8bda..9cd866d929a9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3420,8 +3420,9 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 }
 
 /*
- * Check if path is remote (e.g. a DFS share). Return -EREMOTE if it is,
- * otherwise 0.
+ * Check if path is remote (i.e. a DFS share).
+ *
+ * Return -EREMOTE if it is, otherwise 0 or -errno.
  */
 static int is_path_remote(struct mount_ctx *mnt_ctx)
 {
@@ -3711,6 +3712,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	if (!isdfs)
 		goto out;
 
+	/* proceed as DFS mount */
 	uuid_gen(&mnt_ctx.mount_id);
 	rc = connect_dfs_root(&mnt_ctx, &tl);
 	dfs_cache_free_tgts(&tl);
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 956f8e5cf3e7..c5dd6f7305bd 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -654,7 +654,7 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
 			return ce;
 		}
 	}
-	return ERR_PTR(-EEXIST);
+	return ERR_PTR(-ENOENT);
 }
 
 /*
@@ -662,7 +662,7 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
  *
  * Use whole path components in the match.  Must be called with htable_rw_lock held.
  *
- * Return ERR_PTR(-EEXIST) if the entry is not found.
+ * Return ERR_PTR(-ENOENT) if the entry is not found.
  */
 static struct cache_entry *lookup_cache_entry(const char *path)
 {
@@ -710,7 +710,7 @@ static struct cache_entry *lookup_cache_entry(const char *path)
 		while (e > s && *e != sep)
 			e--;
 	}
-	return ERR_PTR(-EEXIST);
+	return ERR_PTR(-ENOENT);
 }
 
 /**
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index afaf59c22193..a5b5b15e658a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1309,7 +1309,7 @@ int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
  * for "\<server>\<dfsname>\<linkpath>" DFS reference,
  * where <dfsname> contains non-ASCII unicode symbols.
  *
- * Check such DFS reference and emulate -ENOENT if it is actual.
+ * Check such DFS reference.
  */
 int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
 				       struct cifs_tcon *tcon,
@@ -1341,10 +1341,6 @@ int cifs_dfs_query_info_nonascii_quirk(const unsigned int xid,
 		cifs_dbg(FYI, "DFS ref '%s' is found, emulate -EREMOTE\n",
 			 dfspath);
 		rc = -EREMOTE;
-	} else if (rc == -EEXIST) {
-		cifs_dbg(FYI, "DFS ref '%s' is not found, emulate -ENOENT\n",
-			 dfspath);
-		rc = -ENOENT;
 	} else {
 		cifs_dbg(FYI, "%s: dfs_cache_find returned %d\n", __func__, rc);
 	}
-- 
2.36.1

