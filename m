Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4389BC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 21:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiI0V5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 17:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiI0V5c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 17:57:32 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE287111DE7
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 14:57:30 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i26so17653566lfp.11
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 14:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RyA6PO7C4HbkGl+E3db+65l/cOTs+g5RrcIc+s/q/NI=;
        b=FuBv8CRIe6i8AoVcKU94qdYyXkF86zixReEJ9NpsnTnZye4MBg3oWaWa32ERUBrZPS
         AYC9xaUs90UzOfvliYclDUe8OSzVdbxQd9/UoQ0h/qKsjF35jBzWhHUe/kxWOIyrqD1R
         +gZe0cUC3/MZBdY6f2Kd5n5zzTb+0mu7Rouy+EY3gqq+dJBlKrOJIu76MBsEOc50mOLx
         AOxomuyyHAqO8t3qkH2hjXwDvnQaLkeqaASaSREOlXlYZcCDH+2s+2ukWOhN0dbBoXyW
         B+TWdW8ZyBdiGeaKxr+yUJVIzuXVmzAigDQFWPWA27qmDabvDLd6oNsYK9m3RfwgnmM8
         +goA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RyA6PO7C4HbkGl+E3db+65l/cOTs+g5RrcIc+s/q/NI=;
        b=W1q6HYL1vM1qcjCcarGC/keRq6kg7PzdlDEK9hWSWtWtX/S6rDTfFK2yd9xvQNn6CU
         Xnx+NSHRSPQ0qtZbk04EF9QA96XGZZxv3Z/haPvS2HagcEWAO4GnG6SHB8wt4iCALmHY
         /G8JcPUDed0Mn4Hytb8898afjkNl+ZEe8/Oeir6ZrRsNqloDD7uzdbWuQEdgrRA/sLAD
         4qZUIUWYb9espARo72X69Szy9RzDcEBEq4bIibolvYI0bCsis1IrmMK2fIz7D9ZUNBiH
         Y7EF0CKcFG/x1HWOKQfy9gOjy59okhFdAndomxBof8R05RXgvPOS1zwgeBNMXMIuwh38
         DN7Q==
X-Gm-Message-State: ACrzQf18Lm+OFwHwY2VBsUB4uX0e815J3srhjZGgzLhQZMKVzynX9QiE
        8WDeXIgH7CZH/98VXpw2pR116mphf0o=
X-Google-Smtp-Source: AMsMyM433jZ2FKE77Tefty9tt1Vk4i3wRXxENfW3rqojpZLTcgmQ+Jm0PhFxpJGSFMpAxZmGXkQNYA==
X-Received: by 2002:a05:6512:3091:b0:49a:d800:2828 with SMTP id z17-20020a056512309100b0049ad8002828mr12020618lfd.534.1664315849094;
        Tue, 27 Sep 2022 14:57:29 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e2-144.dhcp.inet.fi. [193.210.226.144])
        by smtp.gmail.com with ESMTPSA id be43-20020a056512252b00b004979ec19380sm272325lfb.285.2022.09.27.14.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 14:57:28 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH v2] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
Date:   Wed, 28 Sep 2022 00:57:21 +0300
Message-Id: <20220927215721.328425-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Case-insensitive file name lookups with __caseless_lookup() use
strncasecmp() for file name comparison. strncasecmp() assumes an
ISO8859-1-compatible encoding, which is not the case here as UTF-8
is always used. As such, use of strncasecmp() here produces correct
results only if both strings use characters in the ASCII range only.
Fix this by using utf8_strncasecmp() if CONFIG_UNICODE is set. On
failure or if CONFIG_UNICODE is not set, fallback to strncasecmp().
Also, as we are adding an include for `linux/unicode.h', include it
in `fs/ksmbd/connection.h' as well since it should be explicit there.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 v2:
  - simplified fallback condition by initializing `cmp'

 fs/ksmbd/connection.h |  1 +
 fs/ksmbd/vfs.c        | 20 +++++++++++++++++---
 fs/ksmbd/vfs.h        |  2 ++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 41d96f5cef06..3643354a3fa7 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -14,6 +14,7 @@
 #include <net/request_sock.h>
 #include <linux/kthread.h>
 #include <linux/nls.h>
+#include <linux/unicode.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 4fcf96a01c16..8d8af724df70 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1145,12 +1145,23 @@ static int __caseless_lookup(struct dir_context *ctx, const char *name,
 			     unsigned int d_type)
 {
 	struct ksmbd_readdir_data *buf;
+	int cmp = -EINVAL;
 
 	buf = container_of(ctx, struct ksmbd_readdir_data, ctx);
 
 	if (buf->used != namlen)
 		return 0;
-	if (!strncasecmp((char *)buf->private, name, namlen)) {
+	if (IS_ENABLED(CONFIG_UNICODE) && buf->um) {
+		const struct qstr q_buf = {.name = buf->private,
+					   .len = buf->used};
+		const struct qstr q_name = {.name = name,
+					    .len = namlen};
+
+		cmp = utf8_strncasecmp(buf->um, &q_buf, &q_name);
+	}
+	if (cmp < 0)
+		cmp = strncasecmp((char *)buf->private, name, namlen);
+	if (!cmp) {
 		memcpy((char *)buf->private, name, namlen);
 		buf->dirent_count = 1;
 		return -EEXIST;
@@ -1166,7 +1177,8 @@ static int __caseless_lookup(struct dir_context *ctx, const char *name,
  *
  * Return:	0 on success, otherwise error
  */
-static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name, size_t namelen)
+static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
+				   size_t namelen, struct unicode_map *um)
 {
 	int ret;
 	struct file *dfilp;
@@ -1176,6 +1188,7 @@ static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name, size_t na
 		.private	= name,
 		.used		= namelen,
 		.dirent_count	= 0,
+		.um		= um,
 	};
 
 	dfilp = dentry_open(dir, flags, current_cred());
@@ -1238,7 +1251,8 @@ int ksmbd_vfs_kern_path(struct ksmbd_work *work, char *name,
 				break;
 
 			err = ksmbd_vfs_lookup_in_dir(&parent, filename,
-						      filename_len);
+						      filename_len,
+						      work->conn->um);
 			path_put(&parent);
 			if (err)
 				goto out;
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index d7542a2dab52..593059ca8511 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -12,6 +12,7 @@
 #include <linux/namei.h>
 #include <uapi/linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/unicode.h>
 
 #include "smbacl.h"
 #include "xattr.h"
@@ -60,6 +61,7 @@ struct ksmbd_readdir_data {
 	unsigned int		used;
 	unsigned int		dirent_count;
 	unsigned int		file_attr;
+	struct unicode_map	*um;
 };
 
 /* ksmbd kstat wrapper to get valid create time when reading dir entry */
-- 
2.37.3

