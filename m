Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E07C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiEIXsZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiEIXrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF7622181ED
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652139741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZAj7T/m1ZMQwc31h5WhYgnsHHe0OC+z/vqpT2ZBiFM=;
        b=RLdnKVM9+NZkOB23dGLlVj07mXpb7wYChWZ4YF5AxbZ5tX/IVjMUGfYjyUhrCEjQ8OsV1F
        F67dfv29cDdgfD338Oj2C/UHBzaI1JMYYnpgbJyomBOHIzFq4zKkrZCKmQXlis9j1ZQ9Fn
        mH5nM0qMZSwb3fc1Oni2PURrrDb9kxQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-p6wlOVbAPuadwQ2m3iUruQ-1; Mon, 09 May 2022 19:42:17 -0400
X-MC-Unique: p6wlOVbAPuadwQ2m3iUruQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8883B29AB445;
        Mon,  9 May 2022 23:42:17 +0000 (UTC)
Received: from thinkpad (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D302401E9D;
        Mon,  9 May 2022 23:42:15 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/4] cifs: move definition of cifs_fattr earlier in cifsglob.h
Date:   Tue, 10 May 2022 09:42:04 +1000
Message-Id: <20220509234207.2469586-2-lsahlber@redhat.com>
In-Reply-To: <20220509234207.2469586-1-lsahlber@redhat.com>
References: <20220509234207.2469586-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This only moves these definitions to come earlier in the file
but not change the definition itself.
This is done to reduce the amount of changes in future patches.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h | 62 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8de977c359b1..f2eeabb189a2 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1009,6 +1009,37 @@ cap_unix(struct cifs_ses *ses)
 	return ses->server->vals->cap_unix & ses->capabilities;
 }
 
+/*
+ * common struct for holding inode info when searching for or updating an
+ * inode with new info
+ */
+
+#define CIFS_FATTR_DFS_REFERRAL		0x1
+#define CIFS_FATTR_DELETE_PENDING	0x2
+#define CIFS_FATTR_NEED_REVAL		0x4
+#define CIFS_FATTR_INO_COLLISION	0x8
+#define CIFS_FATTR_UNKNOWN_NLINK	0x10
+#define CIFS_FATTR_FAKE_ROOT_INO	0x20
+
+struct cifs_fattr {
+	u32		cf_flags;
+	u32		cf_cifsattrs;
+	u64		cf_uniqueid;
+	u64		cf_eof;
+	u64		cf_bytes;
+	u64		cf_createtime;
+	kuid_t		cf_uid;
+	kgid_t		cf_gid;
+	umode_t		cf_mode;
+	dev_t		cf_rdev;
+	unsigned int	cf_nlink;
+	unsigned int	cf_dtype;
+	struct timespec64 cf_atime;
+	struct timespec64 cf_mtime;
+	struct timespec64 cf_ctime;
+	u32             cf_cifstag;
+};
+
 struct cached_fid {
 	bool is_valid:1;	/* Do we have a useable root fid */
 	bool file_all_info_is_valid:1;
@@ -1641,37 +1672,6 @@ struct file_list {
 	struct cifsFileInfo *cfile;
 };
 
-/*
- * common struct for holding inode info when searching for or updating an
- * inode with new info
- */
-
-#define CIFS_FATTR_DFS_REFERRAL		0x1
-#define CIFS_FATTR_DELETE_PENDING	0x2
-#define CIFS_FATTR_NEED_REVAL		0x4
-#define CIFS_FATTR_INO_COLLISION	0x8
-#define CIFS_FATTR_UNKNOWN_NLINK	0x10
-#define CIFS_FATTR_FAKE_ROOT_INO	0x20
-
-struct cifs_fattr {
-	u32		cf_flags;
-	u32		cf_cifsattrs;
-	u64		cf_uniqueid;
-	u64		cf_eof;
-	u64		cf_bytes;
-	u64		cf_createtime;
-	kuid_t		cf_uid;
-	kgid_t		cf_gid;
-	umode_t		cf_mode;
-	dev_t		cf_rdev;
-	unsigned int	cf_nlink;
-	unsigned int	cf_dtype;
-	struct timespec64 cf_atime;
-	struct timespec64 cf_mtime;
-	struct timespec64 cf_ctime;
-	u32             cf_cifstag;
-};
-
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
 {
 	if (param) {
-- 
2.30.2

