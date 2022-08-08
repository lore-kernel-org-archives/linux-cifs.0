Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6BEC25B0C
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 22:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiHHWCc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiHHWCa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 18:02:30 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE971BE87
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 15:02:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id j3so4057927ljo.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bgE+UMo9Vo+rfBsSHMr4wD8GPdfh6ZtGp/tMNdv+oq4=;
        b=Hdc9wO485a1KLcatKcQfudheOXeFhsbLxQ/fHQLvkXyolhs5dXZSNKcIu6pdAxfceH
         3G6EgKN7ibSb3sQZvVh46/SaIKokP6RHO3tyamic3M8eeUGDEVRTJyv78ZAQddcyI5kC
         RRK+uAQubir9KHRoXpm9KvQJYFPK9pupMw32NcuoktX0xrFf4hVlyoFEoyHNLKE3W5UY
         G/mbovCDmiyAggBNjSR/g5VGYCjUsRcOff4xsvrDNluwb4Q7XacJP7zozznHZXqO5ur7
         nCD1tmz0/fGaNazmxM26DX+y7A6Rqpw6K5tbS6+av3FCBCMl4D1rGhRnHETkBaaGtUWo
         Mf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bgE+UMo9Vo+rfBsSHMr4wD8GPdfh6ZtGp/tMNdv+oq4=;
        b=OthfvfhqHyFX1HyNTlpg5wawWqr0D9QY7ltfrP9XHkJb5WbM/s3lW+maT96uQT3vpl
         PrPqu+f5c2/IM95nJQyNBKXOgxFUiDUehju0kRSEiBiI4XqdTzWFRGV2yb8pdwY8NMOm
         cQXSV1fB8IjhA/HMC7vLB633UYICAyZuk3PLnwWPziOBrBghnMkiLzwGAyu1+t3Okdpu
         C7uRLwEX1juxzgVZ5TQm5t46rLB8dU8aWOvZir6GR+pdepC0P9rZo3KmXXAd/mZv9JG6
         ugMOdklDIzl7K8B8UKbnMtnHg1vyxMUdhuIboU0b1PsbpKWabqPX4HhHFIacS2v7Ovtc
         1ZrQ==
X-Gm-Message-State: ACgBeo0Fm6JFPboIpOhpNui72iQvMj1mJmQz+dll4sM7Cb+eYCTFJlnt
        7XNpZe0opB6PjRz5XL92x9OmhSY4+c0=
X-Google-Smtp-Source: AA6agR6rRyXv6jg8kXht0GjWjfJ0mzBv4kt3hkUuIRCsWgCiAGUyFAI1IgDpwxC1CLpWZ65f06CM/g==
X-Received: by 2002:a2e:9bcc:0:b0:25e:4dd8:11f7 with SMTP id w12-20020a2e9bcc000000b0025e4dd811f7mr6948700ljj.471.1659996145687;
        Mon, 08 Aug 2022 15:02:25 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2eb-134.dhcp.inet.fi. [193.210.235.134])
        by smtp.gmail.com with ESMTPSA id b15-20020a2eb90f000000b0025e72aae6bdsm1477817ljb.28.2022.08.08.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 15:02:25 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     atheik <atteh.mailbox@gmail.com>
Subject: [PATCH v2 2/3] ksmbd-tools: cleanup config group handling
Date:   Tue,  9 Aug 2022 01:02:15 +0300
Message-Id: <20220808220216.17235-2-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808220216.17235-1-atteh.mailbox@gmail.com>
References: <20220808220216.17235-1-atteh.mailbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename cp_add_ipc_share() to cp_add_ipc_group() in order to better
describe its purpose. Use the ipc_group global variable so as to get
rid of the group name comparison in groups_callback(). Keep track of
used groups callback mode by saving it per-group. Move global group
checks to global_conf_* functions.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 include/config_parser.h |  5 +++
 lib/config_parser.c     | 95 +++++++++++++++++++++++------------------
 2 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/include/config_parser.h b/include/config_parser.h
index b6c49b9..43212c8 100644
--- a/include/config_parser.h
+++ b/include/config_parser.h
@@ -10,7 +10,12 @@
 
 #include <glib.h>
 
+#define GROUPS_CALLBACK_NONE	(0)
+#define GROUPS_CALLBACK_INIT	(1 << 0)
+#define GROUPS_CALLBACK_REINIT	(1 << 1)
+
 struct smbconf_group {
+	unsigned short		cb_mode;
 	char			*name;
 	GHashTable		*kv;
 };
diff --git a/lib/config_parser.c b/lib/config_parser.c
index 5e7a438..d311386 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -21,7 +21,7 @@
 
 struct smbconf_global global_conf;
 struct smbconf_parser parser;
-struct smbconf_group *global_group;
+struct smbconf_group *global_group, *ipc_group;
 
 unsigned long long memparse(const char *v)
 {
@@ -107,6 +107,7 @@ static int add_new_group(char *line)
 	}
 
 	group = g_malloc(sizeof(struct smbconf_group));
+	group->cb_mode = GROUPS_CALLBACK_NONE;
 	group->name = name;
 	group->kv = g_hash_table_new_full(g_str_hash,
 					  g_str_equal,
@@ -561,6 +562,9 @@ static void global_conf_default(void)
 
 static void global_conf_create(void)
 {
+	if (!global_group || global_group->cb_mode != GROUPS_CALLBACK_INIT)
+		return;
+
 	/*
 	 * This will transfer server options to global_conf, and leave behind
 	 * in the global parser group, the options that must be applied to every
@@ -569,6 +573,23 @@ static void global_conf_create(void)
 	g_hash_table_foreach_remove(global_group->kv, global_group_kv, NULL);
 }
 
+static void append_key_value(gpointer _k, gpointer _v, gpointer user_data)
+{
+	GHashTable *receiver = (GHashTable *) user_data;
+
+	/* Don't override local share options */
+	if (!g_hash_table_lookup(receiver, _k))
+		g_hash_table_insert(receiver, g_strdup(_k), g_strdup(_v));
+}
+
+static void global_conf_update(struct smbconf_group *group)
+{
+	if (!global_group)
+		return;
+
+	g_hash_table_foreach(global_group->kv, append_key_value, group->kv);
+}
+
 static void global_conf_fixup_missing(void)
 {
 	int ret;
@@ -607,39 +628,29 @@ static void global_conf_fixup_missing(void)
 			ret);
 }
 
-static void append_key_value(gpointer _k, gpointer _v, gpointer user_data)
-{
-	GHashTable *receiver = (GHashTable *) user_data;
-
-	/* Don't override local share options */
-	if (!g_hash_table_lookup(receiver, _k))
-		g_hash_table_insert(receiver, g_strdup(_k), g_strdup(_v));
-}
-
-#define GROUPS_CALLBACK_STARTUP_INIT	0x1
-#define GROUPS_CALLBACK_REINIT		0x2
-
 static void groups_callback(gpointer _k, gpointer _v, gpointer user_data)
 {
-	struct smbconf_group *group = (struct smbconf_group *)_v;
+	struct smbconf_group *group = (struct smbconf_group *) _v;
+	unsigned short cb_mode = *(unsigned short *) user_data;
 
-	if (group != global_group) {
-		if (global_group && g_ascii_strcasecmp(_k, "ipc$"))
-			g_hash_table_foreach(global_group->kv,
-					     append_key_value,
-					     group->kv);
+	if (group == global_group)
+		return;
 
-		shm_add_new_share(group);
-	}
+	group->cb_mode = cb_mode;
+
+	if (group != ipc_group)
+		global_conf_update(group);
+
+	shm_add_new_share(group);
 }
 
-static int cp_add_ipc_share(void)
+static int cp_add_ipc_group(void)
 {
 	char *comment = NULL, *guest = NULL;
 	int ret = 0;
 
-	if (g_hash_table_lookup(parser.groups, "ipc$"))
-		return 0;
+	if (ipc_group)
+		return ret;
 
 	comment = g_strdup("comment = IPC share");
 	guest = g_strdup("guest ok = yes");
@@ -649,13 +660,18 @@ static int cp_add_ipc_share(void)
 	if (ret) {
 		pr_err("Unable to add IPC$ share\n");
 		ret = -EINVAL;
+		goto out;
 	}
+
+	ipc_group = g_hash_table_lookup(parser.groups, "ipc$");
+out:
 	g_free(comment);
 	g_free(guest);
 	return ret;
 }
 
-static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb, long flags)
+static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb,
+				unsigned short cb_mode)
 {
 	int ret;
 
@@ -665,35 +681,32 @@ static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb, long flags)
 	if (ret)
 		return ret;
 
-	ret = cp_add_ipc_share();
-	if (!ret) {
-		global_group = g_hash_table_lookup(parser.groups, "global");
+	ret = cp_add_ipc_group();
+	if (ret)
+		goto out;
 
-		if (global_group && (flags == GROUPS_CALLBACK_STARTUP_INIT))
-			global_conf_create();
+	global_group = g_hash_table_lookup(parser.groups, "global");
+	if (global_group)
+		global_group->cb_mode = cb_mode;
 
-		g_hash_table_foreach(parser.groups,
-				     groups_callback,
-				     NULL);
-
-		global_conf_fixup_missing();
-	}
+	global_conf_create();
+	g_hash_table_foreach(parser.groups, groups_callback, &cb_mode);
+	global_conf_fixup_missing();
+out:
 	cp_smbconfig_destroy();
 	return ret;
 }
 
 int cp_parse_reload_smbconf(const char *smbconf)
 {
-	return __cp_parse_smbconfig(smbconf,
-				    groups_callback,
+	return __cp_parse_smbconfig(smbconf, groups_callback,
 				    GROUPS_CALLBACK_REINIT);
 }
 
 int cp_parse_smbconf(const char *smbconf)
 {
-	return __cp_parse_smbconfig(smbconf,
-				    groups_callback,
-				    GROUPS_CALLBACK_STARTUP_INIT);
+	return __cp_parse_smbconfig(smbconf, groups_callback,
+				    GROUPS_CALLBACK_INIT);
 }
 
 int cp_parse_pwddb(const char *pwddb)
-- 
2.37.1

