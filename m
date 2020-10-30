Return-Path: <SRS0=oISg=EF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3185C4742C
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Oct 2020 11:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6827F20706
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Oct 2020 11:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgJ3Lww (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:52:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:47082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgJ3Lww (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 30 Oct 2020 07:52:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2123EAE02
        for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2020 11:52:23 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH v3 02/11] cifs: Make extract_sharename function public
Date:   Fri, 30 Oct 2020 12:52:01 +0100
Message-Id: <20201030115210.8888-3-scabrero@suse.de>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201030115210.8888-1-scabrero@suse.de>
References: <20201030115210.8888-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move the function to misc.c

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cache.c     | 24 ------------------------
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/fscache.c   |  1 +
 fs/cifs/fscache.h   |  1 -
 fs/cifs/misc.c      | 24 ++++++++++++++++++++++++
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 0f2adecb94f2..488fe0ffc1ef 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -53,30 +53,6 @@ const struct fscache_cookie_def cifs_fscache_server_index_def = {
 	.type = FSCACHE_COOKIE_TYPE_INDEX,
 };
 
-char *extract_sharename(const char *treename)
-{
-	const char *src;
-	char *delim, *dst;
-	int len;
-
-	/* skip double chars at the beginning */
-	src = treename + 2;
-
-	/* share name is always preceded by '\\' now */
-	delim = strchr(src, '\\');
-	if (!delim)
-		return ERR_PTR(-EINVAL);
-	delim++;
-	len = strlen(delim);
-
-	/* caller has to free the memory */
-	dst = kstrndup(delim, len, GFP_KERNEL);
-	if (!dst)
-		return ERR_PTR(-ENOMEM);
-
-	return dst;
-}
-
 static enum
 fscache_checkaux cifs_fscache_super_check_aux(void *cookie_netfs_data,
 					      const void *data,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d716e81d86fa..5f997a01fb45 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -621,6 +621,7 @@ struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
 void cifs_put_tcp_super(struct super_block *sb);
 int update_super_prepath(struct cifs_tcon *tcon, char *prefix);
 char *extract_hostname(const char *unc);
+char *extract_sharename(const char *unc);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index da688185403c..20d24af33ee2 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -22,6 +22,7 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
+#include "cifsproto.h"
 
 /*
  * Key layout of CIFS server cache index object
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 1091633d2adb..e811f2dd7619 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -57,7 +57,6 @@ extern const struct fscache_cookie_def cifs_fscache_inode_object_def;
 
 extern int cifs_fscache_register(void);
 extern void cifs_fscache_unregister(void);
-extern char *extract_sharename(const char *);
 
 /*
  * fscache.c
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3d5cc25c167f..f0a1c24751b2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1227,3 +1227,27 @@ char *extract_hostname(const char *unc)
 
 	return dst;
 }
+
+char *extract_sharename(const char *unc)
+{
+	const char *src;
+	char *delim, *dst;
+	int len;
+
+	/* skip double chars at the beginning */
+	src = unc + 2;
+
+	/* share name is always preceded by '\\' now */
+	delim = strchr(src, '\\');
+	if (!delim)
+		return ERR_PTR(-EINVAL);
+	delim++;
+	len = strlen(delim);
+
+	/* caller has to free the memory */
+	dst = kstrndup(delim, len, GFP_KERNEL);
+	if (!dst)
+		return ERR_PTR(-ENOMEM);
+
+	return dst;
+}
-- 
2.29.0

