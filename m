Return-Path: <SRS0=QTR6=TK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2512CC04A6B
	for <linux-cifs@archiver.kernel.org>; Fri, 10 May 2019 04:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F26EC217F9
	for <linux-cifs@archiver.kernel.org>; Fri, 10 May 2019 04:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfEJEiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 May 2019 00:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfEJEiw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 10 May 2019 00:38:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77CAEC05E760;
        Fri, 10 May 2019 04:38:52 +0000 (UTC)
Received: from localhost (dhcp-12-130.nay.redhat.com [10.66.12.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 995CC60BFB;
        Fri, 10 May 2019 04:38:51 +0000 (UTC)
From:   Murphy Zhou <xzhou@redhat.com>
To:     ltp@lists.linux.it
Cc:     linux-cifs@vger.kernel.org, Murphy Zhou <xzhou@redhat.com>
Subject: [PATCH] safe_setuid: skip if testing on CIFS
Date:   Fri, 10 May 2019 12:38:45 +0800
Message-Id: <20190510043845.4977-1-xzhou@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 10 May 2019 04:38:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As CIFS is not supporting setuid operations.

Signed-off-by: Murphy Zhou <xzhou@redhat.com>
---
 include/tst_fs.h      |  1 +
 lib/safe_macros.c     | 16 ++++++++++++++++
 lib/tst_fs_type.c     |  2 ++
 lib/tst_safe_macros.c |  8 ++++++++
 4 files changed, 27 insertions(+)

diff --git a/include/tst_fs.h b/include/tst_fs.h
index 423ca82ec..5025f0459 100644
--- a/include/tst_fs.h
+++ b/include/tst_fs.h
@@ -42,6 +42,7 @@
 #define TST_NILFS_MAGIC    0x3434
 #define TST_EXOFS_MAGIC    0x5DF5
 #define TST_OVERLAYFS_MAGIC 0x794c7630
+#define TST_CIFS_MAGIC     0xfe534d42
 
 enum {
 	TST_BYTES = 1,
diff --git a/lib/safe_macros.c b/lib/safe_macros.c
index bac34cdb7..c3ba1d5be 100644
--- a/lib/safe_macros.c
+++ b/lib/safe_macros.c
@@ -277,6 +277,14 @@ int safe_seteuid(const char *file, const int lineno, void (*cleanup_fn) (void),
                  uid_t euid)
 {
 	int rval;
+	long fs_type;
+
+	fs_type = tst_fs_type(NULL, ".");
+	if (fs_type == TST_CIFS_MAGIC) {
+		tst_brkm(TCONF, cleanup_fn,
+			 "seteuid is not supported on %s filesystem",
+			 tst_fs_type_name(fs_type));
+	}
 
 	rval = seteuid(euid);
 	if (rval == -1) {
@@ -307,6 +315,14 @@ int safe_setuid(const char *file, const int lineno, void (*cleanup_fn) (void),
                 uid_t uid)
 {
 	int rval;
+	long fs_type;
+
+	fs_type = tst_fs_type(NULL, ".");
+	if (fs_type == TST_CIFS_MAGIC) {
+		tst_brkm(TCONF, cleanup_fn,
+			 "setuid is not supported on %s filesystem",
+			 tst_fs_type_name(fs_type));
+	}
 
 	rval = setuid(uid);
 	if (rval == -1) {
diff --git a/lib/tst_fs_type.c b/lib/tst_fs_type.c
index 1d0ac9669..eea7c5d4b 100644
--- a/lib/tst_fs_type.c
+++ b/lib/tst_fs_type.c
@@ -84,6 +84,8 @@ const char *tst_fs_type_name(long f_type)
 		return "EXOFS";
 	case TST_OVERLAYFS_MAGIC:
 		return "OVERLAYFS";
+	case TST_CIFS_MAGIC:
+		return "CIFS";
 	default:
 		return "Unknown";
 	}
diff --git a/lib/tst_safe_macros.c b/lib/tst_safe_macros.c
index 0e59a3f98..36941ec0b 100644
--- a/lib/tst_safe_macros.c
+++ b/lib/tst_safe_macros.c
@@ -111,6 +111,7 @@ int safe_setreuid(const char *file, const int lineno,
 		  uid_t ruid, uid_t euid)
 {
 	int rval;
+	long fs_type;
 
 	rval = setreuid(ruid, euid);
 	if (rval == -1) {
@@ -119,6 +120,13 @@ int safe_setreuid(const char *file, const int lineno,
 			 (long)ruid, (long)euid);
 	}
 
+	fs_type = tst_fs_type(".");
+	if (fs_type == TST_CIFS_MAGIC) {
+		tst_brk_(file, lineno, TCONF,
+			 "setreuid is not supported on %s filesystem",
+			 tst_fs_type_name(fs_type));
+	}
+
 	return rval;
 }
 
-- 
2.21.0

