Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26385C433FE
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Oct 2022 22:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJAWxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 18:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJAWxl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 18:53:41 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677F327DE4
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 15:53:40 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id bs18so6709310ljb.1
        for <linux-cifs@vger.kernel.org>; Sat, 01 Oct 2022 15:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=7MPE01tsWm2KGJS2QUCZUbNcKOuLzdt7KEzKQsu43dc=;
        b=XAe/UZUNd1iDm8RPB7HZCsIg9I4TjNia8oeHasnNJWgv4c9Kke0WeUQCnuY9qka0XB
         9wj/irPXkgytGOXjq0WDv4rg8zANkpDt23At5g+h9Y0pVqBkBQDSb+ovaut7j1rB20kj
         i8wlBsy/AtFp6ltjbVIRy7UAgDIEfXSEkyTSRg+RYKL8V5HNmEeSCrGXo8/AWByHxjQL
         bYxWVChAJH0s2SZg+3mQHYJtgUzyXhZTZcHgy9tjQIPn0LpkaKWQEWwJRHf+NqaJp4j/
         MzgNP8ooB9Jh52du1vw+1+L6EDiyDqErhtX7t1W0zutHYC0Fntpwhz7wMUvgVovd1lnY
         pOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=7MPE01tsWm2KGJS2QUCZUbNcKOuLzdt7KEzKQsu43dc=;
        b=sOjksmGGdy9OalcafRVDQVQPmVwA+iPZUWYK4YRAm5k5XvPrayxzh5gFHXBoMnvNAy
         rb399Tte13UI/H9rXsKPclVwOAqq98iY7XKiSmvBbYZR5dIgk5sQauNLcMXQ7JLa+1hq
         UfjbnEQUkmMkWmHeIWNWheZBBipRZWAWIDh8uy05BMr+LONSes22M7vGtkqGagg9SFt8
         fZbjWogZ6jYecrxKP5UN8lWErvJeNa5S+dVF2nXstK6vnVL7PrBPnX45AUjbgltNJFp7
         u/Ov6fFvVuP9JKUie6i4be5zJLdZ2UQ6uGAaTCZH7USGOAEIPb1vtRd+dfNHbHZEejBy
         8Uag==
X-Gm-Message-State: ACrzQf0baJkvkVn095Sdg0VAVVUHfMcZgu/ZTj/qKzK3g+IkjnXuPzcP
        1QyINMLnvFJN16It/PaGM9WbhKwUpAM=
X-Google-Smtp-Source: AMsMyM4UA047aquASmlE2pe+9HIbMiatt9wlACXny8q7vS3Sb4/usI72mpCw/dDLtixf1DjTBvUqxQ==
X-Received: by 2002:a2e:9145:0:b0:26d:d4bf:cc64 with SMTP id q5-20020a2e9145000000b0026dd4bfcc64mr66789ljg.478.1664664818526;
        Sat, 01 Oct 2022 15:53:38 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84be-149.dhcp.inet.fi. [46.132.190.149])
        by smtp.gmail.com with ESMTPSA id z7-20020a2eb527000000b0026dc69247e8sm71098ljm.99.2022.10.01.15.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 15:53:37 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org,
        =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH v3] ksmbd: validate share name from share config response
Date:   Sun,  2 Oct 2022 01:53:24 +0300
Message-Id: <20221001225324.21771-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Share config response may contain the share name without casefolding as
it is known to the user space daemon. When it is present, casefold and
compare it to the share name the share config request was made with. If
they differ, we have a share config which is incompatible with the way
share config caching is done. This is the case when CONFIG_UNICODE is
not set, the share name contains non-ASCII characters, and those non-
ASCII characters do not match those in the share name known to user
space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
names now work but are only case-insensitive in the ASCII range.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 v3:
   - removed initial strcmp() check since it could only save a call to
     ksmbd_casefold_sharename() for matching ASCII-only share names

 v2:
   - no changes were made

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
index 5d039704c23c..c62e87b67247 100644
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
 
+	if (*resp->share_name) {
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

