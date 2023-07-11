Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491CAEB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jul 2023 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjGKRPX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jul 2023 13:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjGKRPW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jul 2023 13:15:22 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FF3A1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jul 2023 10:15:21 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689095719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iu40+Tzb3GvZHvjyMEogoDnfTThFzvXVk6B1eRx6Zrg=;
        b=lnmOoEBp4HyghkXxgkFtZoaUzoCgyrlyHNbATIBIz+oXh3MdVAsDFjgz13AP+HEWoPh0j8
        s2t8xqkCk1mk+SVRZc4VtVb8/xiv6qL89BuA0I+ILWyS6CDF03sRznKUVexYlhflp/c+UN
        47P2vQsnfX7Wm/jk0WdZkG38QP3BJFHRAQJCSkjiseEZjn+bfCfE+NPLP7U236hQxdr9mm
        LCmjuV5/hK+aKwB8kTsJG/a+WfOD0PmW2rLvYQTCKKAamc8zSMVMMrqpz68AYmaEK00nNA
        1SSO/4Q5bBpk94Cs+BVkgNdBHtZotoAADgT0R7Y8IDWfWTjUHqT6PoScubXWkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689095719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iu40+Tzb3GvZHvjyMEogoDnfTThFzvXVk6B1eRx6Zrg=;
        b=WQEFZBeFG64DTAwuitM32I6cL6GceWD7AQpbv0cznCKXm0oo2rdN0TQPOd0EJh1KqQhtkd
        3ROWJF7PZVob9L6oAlJA/IeLgWCgVFRMU+1+T/vsNY4X/xq1n1cZB0jyQYIlJmPm3c3H2K
        +RjVpzC2k9a7wxCaYygTJYIGBHtY9RtyD+1aGkELO7p8A6OD8iL7XZxYE9Kl+rk0zy+N0x
        p4sG4cO6jXb/PcNUM0e7eTEwfZg4rCvPaGTtESNsVIWCpvMc3wFREfmEyMKPF1Xpl/IFv0
        Yke8hHaCpbaiAS0vZmpT8TdJBNc5fdDCN97uUv4aYXwGA2FbDOVlkA+PepixeQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1689095719; a=rsa-sha256;
        cv=none;
        b=fmhB2v4H4ADpBXO98uyiV5L9f41X8KZiqbiHoTkfHL1moglJ5UhJkwwcQF1/YD8HCpNsFQ
        uolJRZlc0ny+sLE8i81LhvtQDc7DcKQDlfJz+O3+kjvI5hUO2Q3B72K5AnT8qt64lkdVRa
        vaYp4951RPLNCOYxmjN5P16CKevF+GAO4PpaL5h19Dr1OPvQQ8sEQGfOp1a/dgGVHo9pCP
        iEi7S5ss5psdYcB+Usi/gPH7hJy0/WZbI0r+Ixsrfd1Ged62IMGTJGQz44X+ZG2mv2rYUM
        m8ReUI7Tzxe0k9SYLlF0K+IUkhiwg6Q5OPZCHeQGNf1SYlAnjSvUhLfQrI9CIg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: fix missed ses refcounting
Date:   Tue, 11 Jul 2023 14:15:10 -0300
Message-ID: <20230711171510.5295-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use new cifs_smb_ses_inc_refcount() helper to get an active reference
of @ses and @ses->dfs_root_ses (if set).  This will prevent
@ses->dfs_root_ses of being put in the next call to cifs_put_smb_ses()
and thus potentially causing an use-after-free bug.

Fixes: 8e3554150d6c ("cifs: fix sharing of DFS connections")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/dfs.c           | 26 ++++++++++----------------
 fs/smb/client/smb2transport.c |  2 +-
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 1403a2d1ab17..df3fd3b720da 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -66,6 +66,12 @@ static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_path)
 	return rc;
 }
 
+/*
+ * Track individual DFS referral servers used by new DFS mount.
+ *
+ * On success, their lifetime will be shared by final tcon (dfs_ses_list).
+ * Otherwise, they will be put by dfs_put_root_smb_sessions() in cifs_mount().
+ */
 static int add_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
@@ -80,11 +86,12 @@ static int add_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
 		INIT_LIST_HEAD(&root_ses->list);
 
 		spin_lock(&cifs_tcp_ses_lock);
-		ses->ses_count++;
+		cifs_smb_ses_inc_refcount(ses);
 		spin_unlock(&cifs_tcp_ses_lock);
 		root_ses->ses = ses;
 		list_add_tail(&root_ses->list, &mnt_ctx->dfs_ses_list);
 	}
+	/* Select new DFS referral server so that new referrals go through it */
 	ctx->dfs_root_ses = ses;
 	return 0;
 }
@@ -242,7 +249,6 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
-	struct cifs_ses *ses;
 	bool nodfs = ctx->nodfs;
 	int rc;
 
@@ -276,20 +282,8 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	}
 
 	*isdfs = true;
-	/*
-	 * Prevent DFS root session of being put in the first call to
-	 * cifs_mount_put_conns().  If another DFS root server was not found
-	 * while chasing the referrals (@ctx->dfs_root_ses == @ses), then we
-	 * can safely put extra refcount of @ses.
-	 */
-	ses = mnt_ctx->ses;
-	mnt_ctx->ses = NULL;
-	mnt_ctx->server = NULL;
-	rc = __dfs_mount_share(mnt_ctx);
-	if (ses == ctx->dfs_root_ses)
-		cifs_put_smb_ses(ses);
-
-	return rc;
+	add_root_smb_session(mnt_ctx);
+	return __dfs_mount_share(mnt_ctx);
 }
 
 /* Update dfs referral path of superblock */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index c6db898dab7c..7676091b3e77 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -160,7 +160,7 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
-		++ses->ses_count;
+		cifs_smb_ses_inc_refcount(ses);
 		spin_unlock(&ses->ses_lock);
 		return ses;
 	}
-- 
2.41.0

