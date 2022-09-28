Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA56C07E9D
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 01:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiI1BcG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 21:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiI1BcF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 21:32:05 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112F310E5D2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 18:32:04 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z4so386135lft.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 18:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RlfLAYkIgKs+g6Byz5GMtV4ny3WvBeJYkyNNcR2Ss7M=;
        b=WCKP+FVDKEun9fa5YQAG8QzbvxaOVAFYTHOy3wiIqoCtYQnsfJ24IGSBxq6C2zenbB
         +wjI3Bslw4b0EL5dEP9LVc6+TLxgr8DJ62XzT279s2C/N5Xwv+E4pJyYgG/4Dve/WwYx
         8WhrQox0GPmxsdYRrkhPQ9dCZbOoN63dqwWLIrXeYKjkjvBoDYYQv5ITxjMRuBQdx3xw
         y/o4rySTCjc8MooObWT2zy6OixsTJxaSyl2chtBbrhDs/wkamAiIRd04cDi8iOCduFv2
         DmCSxGmylndVg2uliZVPVZ4inmhdjAgSuMA5/Dmp1WRFtkU3xlo9+NkcUNKAqx3iz1+J
         Kw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RlfLAYkIgKs+g6Byz5GMtV4ny3WvBeJYkyNNcR2Ss7M=;
        b=JGkJqEa9JoI/fg/CkfLo4LihmG6izf8YSLE3A0np5crnouvURLLJFejbn/L0lpvxPX
         EJJ8i9vJXc1k+TbHw5pXAncngSGnO1qQqgG2+KwBHnJ5S1WjMvd7ifHokdnjHt6LfrHk
         pMpX/bCMcCf8EN6BMcT7Nt9abAd8cf3TsMTC7vAlfQE9AkNpZdIoozCFK8xYX/MmyK4o
         ZLIf7JqP3uCbWWPvU8dJkiKGTp6yOzlKfrBOv0TsDi4MjLQxmgZ2YB3d4YeeYxibwSXw
         ydhzr1GiRM/9XiO5BanvZwM6dCYNszpHznXfnNRpIWvvtCQwjZe+64K5UzH8ySU1jOcH
         QJwA==
X-Gm-Message-State: ACrzQf1cmDDfXUL2fFQ91g+ZWbfRWxIHxBFUnq58dx8K6OkUQ5GSCJrR
        8NiCE8gkqnGqgJ7Psa9fdZ8RGgDMvgY=
X-Google-Smtp-Source: AMsMyM6jTdQxJlIEcQLJSTlRHgP9Zv68ntPjeVGN/82qSPd9apNyYlU+MMyfeCGwnje2lbWuci08Ng==
X-Received: by 2002:a05:6512:3ca8:b0:499:2f89:cb42 with SMTP id h40-20020a0565123ca800b004992f89cb42mr11804226lfv.227.1664328722358;
        Tue, 27 Sep 2022 18:32:02 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e2-144.dhcp.inet.fi. [193.210.226.144])
        by smtp.gmail.com with ESMTPSA id x1-20020a056512078100b00492cfecf1c0sm315576lfr.245.2022.09.27.18.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:32:02 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH 1/2] ksmbd: validate share name from share config response
Date:   Wed, 28 Sep 2022 04:31:50 +0300
Message-Id: <20220928013151.633112-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Share config response may contain the share name without casefolding as
it is known to the user space daemon. When it is present, compare it to
the share name the share config request was made with. If they differ,
casefold it and compare again. If they still differ, we have a share
config which is incompatible with the way we do share config caching.
Currently, this is the case if CONFIG_UNICODE is not set, the share
name contains non-ASCII characters, and those non-ASCII characters do
not match those in the share name known to user space. In other words,
when CONFIG_UNICODE is not set, UTF-8 share names now work but are only
case-insensitive in the ASCII range.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 fs/ksmbd/ksmbd_netlink.h     |  3 ++-
 fs/ksmbd/mgmt/share_config.c | 20 +++++++++++++++++---
 fs/ksmbd/mgmt/share_config.h |  4 +++-
 fs/ksmbd/mgmt/tree_connect.c |  4 ++--
 fs/ksmbd/misc.c              |  4 ++--
 fs/ksmbd/misc.h              |  1 +
 6 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index e0cbcfa98c7e..ff07c67f4565 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
 	__u16	force_directory_mode;
 	__u16	force_uid;
 	__u16	force_gid;
-	__u32	reserved[128];		/* Reserved room */
+	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
+	__u32	reserved[112];		/* Reserved room */
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index 5d039704c23c..ac766768d283 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -16,6 +16,7 @@
 #include "user_config.h"
 #include "user_session.h"
 #include "../transport_ipc.h"
+#include "../misc.h"
 
 #define SHARE_HASH_BITS		3
 static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
@@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	return 0;
 }
 
-static struct ksmbd_share_config *share_config_request(const char *name)
+static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
+						       const char *name)
 {
 	struct ksmbd_share_config_response *resp;
 	struct ksmbd_share_config *share = NULL;
@@ -133,6 +135,17 @@ static struct ksmbd_share_config *share_config_request(const char *name)
 	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
 		goto out;
 
+	if (*resp->share_name && strcmp(resp->share_name, name)) {
+		char *cf_resp_name;
+		bool equal;
+
+		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
+		equal = cf_resp_name && !strcmp(cf_resp_name, name);
+		kfree(cf_resp_name);
+		if (!equal)
+			goto out;
+	}
+
 	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
 	if (!share)
 		goto out;
@@ -190,7 +203,8 @@ static struct ksmbd_share_config *share_config_request(const char *name)
 	return share;
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
+struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
+						  const char *name)
 {
 	struct ksmbd_share_config *share;
 
@@ -202,7 +216,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
 
 	if (share)
 		return share;
-	return share_config_request(name);
+	return share_config_request(um, name);
 }
 
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
index 7f7e89ecfe61..3fd338293942 100644
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -9,6 +9,7 @@
 #include <linux/workqueue.h>
 #include <linux/hashtable.h>
 #include <linux/path.h>
+#include <linux/unicode.h>
 
 struct ksmbd_share_config {
 	char			*name;
@@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
 	__ksmbd_share_config_put(share);
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
+struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
+						  const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index 867c0286b901..8ce17b3fb8da 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	struct sockaddr *peer_addr;
 	int ret;
 
-	sc = ksmbd_share_config_get(share_name);
+	sc = ksmbd_share_config_get(conn->um, share_name);
 	if (!sc)
 		return status;
 
@@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		struct ksmbd_share_config *new_sc;
 
 		ksmbd_share_config_del(sc);
-		new_sc = ksmbd_share_config_get(share_name);
+		new_sc = ksmbd_share_config_get(conn->um, share_name);
 		if (!new_sc) {
 			pr_err("Failed to update stale share config\n");
 			status.ret = -ESTALE;
diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
index 28459b1efaa8..9e8afaa686e3 100644
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
 	strreplace(path, '/', '\\');
 }
 
-static char *casefold_sharename(struct unicode_map *um, const char *name)
+char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
 {
 	char *cf_name;
 	int cf_len;
@@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
 		name = (pos + 1);
 
 	/* caller has to free the memory */
-	return casefold_sharename(um, name);
+	return ksmbd_casefold_sharename(um, name);
 }
 
 /**
diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
index cc72f4e6baf2..1facfcd21200 100644
--- a/fs/ksmbd/misc.h
+++ b/fs/ksmbd/misc.h
@@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
 void ksmbd_conv_path_to_unix(char *path);
 void ksmbd_strip_last_slash(char *path);
 void ksmbd_conv_path_to_windows(char *path);
+char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
 char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
 
-- 
2.37.3

