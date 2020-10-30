Return-Path: <SRS0=oISg=EF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E010FC55178
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Oct 2020 11:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8564820706
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Oct 2020 11:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgJ3Lww (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Oct 2020 07:52:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:47072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgJ3Lww (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 30 Oct 2020 07:52:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D89FAACBF
        for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2020 11:52:22 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH v3 01/11] cifs: Make extract_hostname function public
Date:   Fri, 30 Oct 2020 12:52:00 +0100
Message-Id: <20201030115210.8888-2-scabrero@suse.de>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201030115210.8888-1-scabrero@suse.de>
References: <20201030115210.8888-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move the function to misc.c and give it a public header.

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/connect.c   | 34 ----------------------------------
 fs/cifs/misc.c      | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 24c6f36177ba..d716e81d86fa 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -620,6 +620,7 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
 void cifs_put_tcp_super(struct super_block *sb);
 int update_super_prepath(struct cifs_tcon *tcon, char *prefix);
+char *extract_hostname(const char *unc);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 static inline int get_dfs_path(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c38156f324dd..5aadc4632097 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -284,7 +284,6 @@ static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
-static char *extract_hostname(const char *unc);
 
 /*
  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
@@ -1230,39 +1229,6 @@ cifs_demultiplex_thread(void *p)
 	module_put_and_exit(0);
 }
 
-/* extract the host portion of the UNC string */
-static char *
-extract_hostname(const char *unc)
-{
-	const char *src;
-	char *dst, *delim;
-	unsigned int len;
-
-	/* skip double chars at beginning of string */
-	/* BB: check validity of these bytes? */
-	if (strlen(unc) < 3)
-		return ERR_PTR(-EINVAL);
-	for (src = unc; *src && *src == '\\'; src++)
-		;
-	if (!*src)
-		return ERR_PTR(-EINVAL);
-
-	/* delimiter between hostname and sharename is always '\\' now */
-	delim = strchr(src, '\\');
-	if (!delim)
-		return ERR_PTR(-EINVAL);
-
-	len = delim - src;
-	dst = kmalloc((len + 1), GFP_KERNEL);
-	if (dst == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	memcpy(dst, src, len);
-	dst[len] = '\0';
-
-	return dst;
-}
-
 static int get_option_ul(substring_t args[], unsigned long *option)
 {
 	int rc;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1c14cf01dbef..3d5cc25c167f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1195,3 +1195,35 @@ int update_super_prepath(struct cifs_tcon *tcon, char *prefix)
 	cifs_put_tcon_super(sb);
 	return rc;
 }
+
+/* extract the host portion of the UNC string */
+char *extract_hostname(const char *unc)
+{
+	const char *src;
+	char *dst, *delim;
+	unsigned int len;
+
+	/* skip double chars at beginning of string */
+	/* BB: check validity of these bytes? */
+	if (strlen(unc) < 3)
+		return ERR_PTR(-EINVAL);
+	for (src = unc; *src && *src == '\\'; src++)
+		;
+	if (!*src)
+		return ERR_PTR(-EINVAL);
+
+	/* delimiter between hostname and sharename is always '\\' now */
+	delim = strchr(src, '\\');
+	if (!delim)
+		return ERR_PTR(-EINVAL);
+
+	len = delim - src;
+	dst = kmalloc((len + 1), GFP_KERNEL);
+	if (dst == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(dst, src, len);
+	dst[len] = '\0';
+
+	return dst;
+}
-- 
2.29.0

