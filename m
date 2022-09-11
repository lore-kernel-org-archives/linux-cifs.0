Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C155ECAAD3
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Sep 2022 20:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIKU5p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 11 Sep 2022 16:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIKU5o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 11 Sep 2022 16:57:44 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6A324BEF
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 13:57:42 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m15so11752506lfl.9
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 13:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=tvsdfAlyRV/BPyPYli6S+BG9+lGaolYc0yEpNMhZ8CM=;
        b=jsgK9ffrPmlqZ47yRFZqvyzT5M2Rws88xbe9pbbfAPAwJVNgd/EQ7sTb3/yLEyxEXs
         fR1rnPPY7VBH/4VL+s+nxt3o0sNQeIGHaihfqPSxEob+bA1Z1iwYjMdL+pae4J4jF6cc
         ELYRsu6F6YMnQUTLfN/JjA4yyqYKNoJE7KIAnIbPzg+/a3ubWjKG2JBOFX/9yz1+uJDq
         G/8oVD/MiZeN5XsC4HofogUqYrF3X05klxsHXFziHX/lXkTJcod0DX3y3N8fyhysdp3a
         vghTg8zNcJJULg6wggBDXu5yq6xzQneTJ66k9maHqTwfyRbFoaP0yILIbnEbTY0dmobI
         7++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=tvsdfAlyRV/BPyPYli6S+BG9+lGaolYc0yEpNMhZ8CM=;
        b=zWIn7XWH+2eY5RyW9l/ycOOkr4FcV6zUhJjYjKr2kjBUZywSLwT0Cc8AXMacDtFVoS
         /tPh19wSAln1bT814YesF/zpsXiDWfZL0FxKhhf3k6xb8xAw1P9SRUi7u9i5sTT22X5y
         Rd4q5yQTbcvP8jrTIgFr9soPpj9vQPXmZlpDGqEhCOaFaP9L3uEdd1UNkqr/j5aZVV9c
         4ZWKCqysEKPBE1X0Y1w7wasTHpaylN6eWoNrWUtOf+EC9bl92qODbmXpkic70jQIPZdv
         O5mFDEHmmyboBhHFHF1lv+p9CNvZnk6z9Jdk9zsYo4ns6kPSqYyPbIGmYcqapHznAEd7
         jMvg==
X-Gm-Message-State: ACgBeo1CajwrvkyX1QVnuYH6TvyzoKqU5Fic6Vo3pmD7hKm+lTO0MzwH
        t1VoY9IfkJ8eRGWdQEvnB3m+UFRirXo=
X-Google-Smtp-Source: AA6agR6vH0U/FL1pA5bQtxukwNXsNTmp89LaMO2+5cF/A8/PMk4cfWafVdg8g5ui9nSW29L+Y+/h8w==
X-Received: by 2002:a05:6512:261b:b0:492:cd8a:e1c with SMTP id bt27-20020a056512261b00b00492cd8a0e1cmr7469970lfb.528.1662929861039;
        Sun, 11 Sep 2022 13:57:41 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bc-66.dhcp.inet.fi. [46.132.188.66])
        by smtp.gmail.com with ESMTPSA id d30-20020a19385e000000b00492e98c27ebsm723640lfj.91.2022.09.11.13.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 13:57:40 -0700 (PDT)
From:   =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     =?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Subject: [PATCH 1/2] ksmbd: casefold utf-8 share names and fix ascii lowercase conversion
Date:   Sun, 11 Sep 2022 23:57:28 +0300
Message-Id: <20220911205729.299358-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

strtolower() corrupts all UTF-8 share names that have a byte in the C0
(À ISO8859-1) to DE (Þ ISO8859-1) range, since the non-ASCII part of
ISO8859-1 is incompatible with UTF-8. Prevent this by checking that a
byte is in the ASCII range with isascii(), before the conversion to
lowercase with tolower(). Properly handle case-insensitivity of UTF-8
share names by casefolding them, but fallback to ASCII lowercase
conversion on failure or if CONFIG_UNICODE is not set. Refactor to move
the share name casefolding immediately after the share name extraction.
Also, make the associated constness corrections.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 fs/ksmbd/connection.c        |  8 +++++++
 fs/ksmbd/connection.h        |  1 +
 fs/ksmbd/mgmt/share_config.c | 18 ++++-----------
 fs/ksmbd/mgmt/share_config.h |  2 +-
 fs/ksmbd/mgmt/tree_connect.c |  2 +-
 fs/ksmbd/mgmt/tree_connect.h |  2 +-
 fs/ksmbd/misc.c              | 45 +++++++++++++++++++++++++++++-------
 fs/ksmbd/misc.h              |  2 +-
 fs/ksmbd/smb2pdu.c           |  2 +-
 fs/ksmbd/unicode.h           |  3 ++-
 10 files changed, 57 insertions(+), 28 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 756ad631c019..12be8386446a 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -60,6 +60,12 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	conn->local_nls = load_nls("utf8");
 	if (!conn->local_nls)
 		conn->local_nls = load_nls_default();
+	if (IS_ENABLED(CONFIG_UNICODE))
+		conn->um = utf8_load(UNICODE_AGE(12, 1, 0));
+	else
+		conn->um = ERR_PTR(-EOPNOTSUPP);
+	if (IS_ERR(conn->um))
+		conn->um = NULL;
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	conn->total_credits = 1;
@@ -350,6 +356,8 @@ int ksmbd_conn_handler_loop(void *p)
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
 
+	if (IS_ENABLED(CONFIG_UNICODE))
+		utf8_unload(conn->um);
 	unload_nls(conn->local_nls);
 	if (default_conn_ops.terminate_fn)
 		default_conn_ops.terminate_fn(conn);
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index e7f7d5707951..41d96f5cef06 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -46,6 +46,7 @@ struct ksmbd_conn {
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
 	struct nls_table		*local_nls;
+	struct unicode_map		*um;
 	struct list_head		conns_list;
 	/* smb session 1 per user */
 	struct xarray			sessions;
diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index c9bca1c2c834..5d039704c23c 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -26,7 +26,7 @@ struct ksmbd_veto_pattern {
 	struct list_head	list;
 };
 
-static unsigned int share_name_hash(char *name)
+static unsigned int share_name_hash(const char *name)
 {
 	return jhash(name, strlen(name), 0);
 }
@@ -72,7 +72,7 @@ __get_share_config(struct ksmbd_share_config *share)
 	return share;
 }
 
-static struct ksmbd_share_config *__share_lookup(char *name)
+static struct ksmbd_share_config *__share_lookup(const char *name)
 {
 	struct ksmbd_share_config *share;
 	unsigned int key = share_name_hash(name);
@@ -119,7 +119,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	return 0;
 }
 
-static struct ksmbd_share_config *share_config_request(char *name)
+static struct ksmbd_share_config *share_config_request(const char *name)
 {
 	struct ksmbd_share_config_response *resp;
 	struct ksmbd_share_config *share = NULL;
@@ -190,20 +190,10 @@ static struct ksmbd_share_config *share_config_request(char *name)
 	return share;
 }
 
-static void strtolower(char *share_name)
-{
-	while (*share_name) {
-		*share_name = tolower(*share_name);
-		share_name++;
-	}
-}
-
-struct ksmbd_share_config *ksmbd_share_config_get(char *name)
+struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
 {
 	struct ksmbd_share_config *share;
 
-	strtolower(name);
-
 	down_read(&shares_table_lock);
 	share = __share_lookup(name);
 	if (share)
diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
index 902f2cb1963a..7f7e89ecfe61 100644
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -74,7 +74,7 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
 	__ksmbd_share_config_put(share);
 }
 
-struct ksmbd_share_config *ksmbd_share_config_get(char *name);
+struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
 bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
 			       const char *filename);
 #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index 97ab7987df6e..867c0286b901 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -17,7 +17,7 @@
 
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			char *share_name)
+			const char *share_name)
 {
 	struct ksmbd_tree_conn_status status = {-ENOENT, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
diff --git a/fs/ksmbd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
index 71e50271dccf..0f97ddc1e39c 100644
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -42,7 +42,7 @@ struct ksmbd_session;
 
 struct ksmbd_tree_conn_status
 ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
-			char *share_name);
+			const char *share_name);
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 			       struct ksmbd_tree_connect *tree_conn);
diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
index df991107ad2c..8316e2bf926d 100644
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/xattr.h>
 #include <linux/fs.h>
+#include <linux/unicode.h>
 
 #include "misc.h"
 #include "smb_common.h"
@@ -226,26 +227,54 @@ void ksmbd_conv_path_to_windows(char *path)
 	strreplace(path, '/', '\\');
 }
 
+static char *casefold_sharename(struct unicode_map *um, const char *name)
+{
+	char *cf_name;
+	int cf_len;
+
+	cf_name = kzalloc(KSMBD_REQ_MAX_SHARE_NAME, GFP_KERNEL);
+	if (!cf_name)
+		return ERR_PTR(-ENOMEM);
+
+	if (IS_ENABLED(CONFIG_UNICODE)) {
+		const struct qstr q_name = {.name = name, .len = strlen(name)};
+
+		if (!um)
+			goto out_ascii;
+
+		cf_len = utf8_casefold(um, &q_name, cf_name,
+				       KSMBD_REQ_MAX_SHARE_NAME);
+		if (cf_len < 0)
+			goto out_ascii;
+
+		return cf_name;
+	}
+
+out_ascii:
+	cf_len = strscpy(cf_name, name, KSMBD_REQ_MAX_SHARE_NAME);
+	if (cf_len < 0)
+		return ERR_PTR(-E2BIG);
+
+	for (; *cf_name; ++cf_name)
+		*cf_name = isascii(*cf_name) ? tolower(*cf_name) : *cf_name;
+	return cf_name - cf_len;
+}
+
 /**
  * ksmbd_extract_sharename() - get share name from tree connect request
  * @treename:	buffer containing tree name and share name
  *
  * Return:      share name on success, otherwise error
  */
-char *ksmbd_extract_sharename(char *treename)
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
 {
-	char *name = treename;
-	char *dst;
-	char *pos = strrchr(name, '\\');
+	const char *name = treename, *pos = strrchr(name, '\\');
 
 	if (pos)
 		name = (pos + 1);
 
 	/* caller has to free the memory */
-	dst = kstrdup(name, GFP_KERNEL);
-	if (!dst)
-		return ERR_PTR(-ENOMEM);
-	return dst;
+	return casefold_sharename(um, name);
 }
 
 /**
diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
index aae2a252945f..fbb7db560a28 100644
--- a/fs/ksmbd/misc.h
+++ b/fs/ksmbd/misc.h
@@ -20,7 +20,7 @@ int get_nlink(struct kstat *st);
 void ksmbd_conv_path_to_unix(char *path);
 void ksmbd_strip_last_slash(char *path);
 void ksmbd_conv_path_to_windows(char *path);
-char *ksmbd_extract_sharename(char *treename);
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
 
 #define KSMBD_DIR_INFO_ALIGNMENT	8
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 19412ac701a6..62a8da520810 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1883,7 +1883,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		goto out_err1;
 	}
 
-	name = ksmbd_extract_sharename(treename);
+	name = ksmbd_extract_sharename(conn->um, treename);
 	if (IS_ERR(name)) {
 		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
 		goto out_err1;
diff --git a/fs/ksmbd/unicode.h b/fs/ksmbd/unicode.h
index 5593024230ae..076f6034a789 100644
--- a/fs/ksmbd/unicode.h
+++ b/fs/ksmbd/unicode.h
@@ -24,6 +24,7 @@
 #include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/nls.h>
+#include <linux/unicode.h>
 
 #define  UNIUPR_NOLOWER		/* Example to not expand lower case tables */
 
@@ -69,7 +70,7 @@ char *smb_strndup_from_utf16(const char *src, const int maxlen,
 			     const struct nls_table *codepage);
 int smbConvertToUTF16(__le16 *target, const char *source, int srclen,
 		      const struct nls_table *cp, int mapchars);
-char *ksmbd_extract_sharename(char *treename);
+char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
 #endif
 
 /*
-- 
2.37.3

