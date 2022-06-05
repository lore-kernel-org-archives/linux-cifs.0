Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B03C43334
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Jun 2022 22:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348554AbiFEWzA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Jun 2022 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiFEWy7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Jun 2022 18:54:59 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E072E4EDD9
        for <linux-cifs@vger.kernel.org>; Sun,  5 Jun 2022 15:54:57 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1D6E57FC20;
        Sun,  5 Jun 2022 22:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654469695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e+5HFztMcF2H4tNI9LMWNI/bz5LaJU8OGJLFN8iLSJ0=;
        b=hK2CVFyoD/ZsTZuHosl0M3smMOWOqDGqso8pNm4m3Ik70sTwvAGyWzTPsFENelU2DtU0Ng
        hAv1Z0EY8hpgxAt2t5wh7DuOVutDDsLLTNa4F/s+u9NIqV0iJEj7xFXwHIN4HyTDus7B9s
        Cvbmo5cLoiiH/dIO1tAP39yyDI+YZK7474ZdU0fmWvnxh32lKb8x8AMI8pKd5TRPJzNJgT
        05pDY1bnp723O/IfRwwO8xIHVWqjEEyJa0RQpDlSh3gU4DQRIl26yXlfG5rugmoJkCuWQJ
        dhmJ8to3Kycxdg/RIqz4W11Cfi/1wc1uaDWdmtUMxU6yV3PVBoDq9WnLWKXg7A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>,
        Satadru Pramanik <satadru@gmail.com>
Subject: [PATCH] cifs: fix reconnect on smb3 mount types
Date:   Sun,  5 Jun 2022 19:54:26 -0300
Message-Id: <20220605225426.8558-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs.ko defines two file system types: cifs & smb3, and
__cifs_get_super() was not including smb3 file system type when
looking up superblocks, therefore failing to reconnect tcons in
cifs_tree_connect().

Fix this by calling iterate_supers_type() on both file system types.

Link: https://lore.kernel.org/r/CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com
Reported-by: Satadru Pramanik <satadru@gmail.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsfs.c |  2 +-
 fs/cifs/cifsfs.h |  2 +-
 fs/cifs/misc.c   | 27 ++++++++++++++++-----------
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 12c872800326..325423180fd2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1086,7 +1086,7 @@ struct file_system_type cifs_fs_type = {
 };
 MODULE_ALIAS_FS("cifs");
 
-static struct file_system_type smb3_fs_type = {
+struct file_system_type smb3_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "smb3",
 	.init_fs_context = smb3_init_fs_context,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index dd7e070ca243..b17be47a8e59 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -38,7 +38,7 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
 	return (unsigned long) dentry->d_fsdata;
 }
 
-extern struct file_system_type cifs_fs_type;
+extern struct file_system_type cifs_fs_type, smb3_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 35962a1a23b9..8e67a2d406ab 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1211,18 +1211,23 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 		.data = data,
 		.sb = NULL,
 	};
+	struct file_system_type **fs_type = (struct file_system_type *[]) {
+		&cifs_fs_type, &smb3_fs_type, NULL,
+	};
 
-	iterate_supers_type(&cifs_fs_type, f, &sd);
-
-	if (!sd.sb)
-		return ERR_PTR(-EINVAL);
-	/*
-	 * Grab an active reference in order to prevent automounts (DFS links)
-	 * of expiring and then freeing up our cifs superblock pointer while
-	 * we're doing failover.
-	 */
-	cifs_sb_active(sd.sb);
-	return sd.sb;
+	for (; *fs_type; fs_type++) {
+		iterate_supers_type(*fs_type, f, &sd);
+		if (sd.sb) {
+			/*
+			 * Grab an active reference in order to prevent automounts (DFS links)
+			 * of expiring and then freeing up our cifs superblock pointer while
+			 * we're doing failover.
+			 */
+			cifs_sb_active(sd.sb);
+			return sd.sb;
+		}
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 static void __cifs_put_super(struct super_block *sb)
-- 
2.36.1

