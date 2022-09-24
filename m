Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259C4C04A95
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Sep 2022 02:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIXCXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 22:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiIXCX3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 22:23:29 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3F0132D61
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 19:23:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id i26so2834911lfp.11
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 19:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=spKZP61gMfcFMTFcd3jTIfq/eNyEGyu9n2+QZkPcFEQ=;
        b=mNFVRJ7rJvVDTJedvjSWStjnCWAO+6pfNTqkXrL+3gxqwUkMnlzwQdc0ltpmPPXSPn
         bC5jRWPlwgYrUdrXm7pNzAh6Mdlff6aXB2Rkr0YFJZO9ZTS7vh89A0Z+Ja6uTvFd0GGY
         xsPLM9vVr3sGpMFCkCk58otWPdygAkVrkR3VU28L31mAE712r041fDBYUfDA/OPg6mOJ
         TJo/n/AqDxPQ0luvDAO01USIb2tf96+LcbaQcp1OMLwCwQPK46w5Yu7qnAoMoNDmNIPe
         V4w4fVSyV4CZpmwb1dRq+LL0tVHUtxxuJWJxqWAEzd1wz4bLLkcDbTIUoVvKxMlyEKXh
         cOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=spKZP61gMfcFMTFcd3jTIfq/eNyEGyu9n2+QZkPcFEQ=;
        b=KR/S4WEulEecFq7pnI4J94EuivFjDlTHr2yecF4MX41EH0hqI3+0uNDJc4J43Ev5jq
         LlDzQvI+ynjI9uSQiUmPa7syCav4lJgUjXU9kB4rqEwG7noy+qLabCRFD3BQN3lTCUIV
         5a0g2CJhAe4lJETwdeNun/bIgTU9ZzJdcBiLjtK3MGQ23Rw9tPUgUzlP7lS5qpJJCE8T
         FXDbcuvCDsNu4ayw/UI447V6kANH8L3mM8MfLAKya0NOrACTYAaSR/71AJM/fGXvi3EY
         pxbbwfzkmm4MILV4rqZkr8rRgHIU7mnkOw5HFnnNjlxn+Y3F0oNwWCdmtkgh2L0cvwkU
         WyPQ==
X-Gm-Message-State: ACrzQf2CT/at2ovB5L/j751S97WUA5thbDg3h78ew96tBl+1QLe/gQ8Y
        QQckTBHCaXV0hLIpC/xq9xgGuB69hiQ=
X-Google-Smtp-Source: AMsMyM7j0d5zCdj2FvlozTHDglfZdOHTwFV8s9zYCSPDaFoqpJzcGjJFsWWsjoIExpiQbc1Q9Ka8hg==
X-Received: by 2002:a05:6512:a86:b0:499:f794:5cc2 with SMTP id m6-20020a0565120a8600b00499f7945cc2mr4200654lfu.100.1663986206184;
        Fri, 23 Sep 2022 19:23:26 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e7-71.dhcp.inet.fi. [193.210.231.71])
        by smtp.gmail.com with ESMTPSA id z35-20020a0565120c2300b0048b3926351bsm1706696lfu.56.2022.09.23.19.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 19:23:25 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH] ksmbd: make utf-8 file name comparison work in __caseless_lookup()
Date:   Sat, 24 Sep 2022 05:23:13 +0300
Message-Id: <20220924022313.281318-1-atteh.mailbox@gmail.com>
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
index 4fcf96a01c16..a3269df7c7b3 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1145,12 +1145,23 @@ static int __caseless_lookup(struct dir_context *ctx, const char *name,
 			     unsigned int d_type)
 {
 	struct ksmbd_readdir_data *buf;
+	int cmp;
 
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
+	if (!(IS_ENABLED(CONFIG_UNICODE) && buf->um) || cmp < 0)
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

