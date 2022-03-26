Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5929EC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Mar 2022 00:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiCZAhw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiCZAhw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Mar 2022 20:37:52 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E65A24059C
        for <linux-cifs@vger.kernel.org>; Fri, 25 Mar 2022 17:36:17 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so13682319pjb.5
        for <linux-cifs@vger.kernel.org>; Fri, 25 Mar 2022 17:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aolCN0BeVAIJIlvVlbSxJqoEzcawuDglkXQYjjGkOJs=;
        b=SBFjOvg0mXW9uBlWUtDJKF7s1HaXN/xVLHOp/AsmBK5usVyFgK9Gpzq1H7tCZDKj3h
         dEREkpc4RERgSxS4dBM+rS6qFTEBZboD4GtxAU9+28FMsoObJaeWKM5WlXlcgJm7NV52
         jWg9EeCJVUS+zSKo+i0/w9lk+4tK1cKYbTolpcWRFHat1o50kvBJE453ajY3VBhRAZyd
         WEEjm3daN05BMoUL7cxETg9QnPLN+//bnrdjSfo7JCoZX7m0atSv/6SuyJtexPo0ptHn
         /14hHq7bk6dVWTDkcJ1XSH021wUQq1KRU/ZtkKPgD5pg+u2xh+wUThG41pm9u7NCugv/
         iG4Q==
X-Gm-Message-State: AOAM533Puzg0SI3jyyPiGUi4kpFfE9vsUqFjiHmat00KEfhv/7fo+V2a
        0kICU3qSShGuEqT6UWfdkZ9K1bQaA84=
X-Google-Smtp-Source: ABdhPJyIpofRJqTAC7MQPiHO4oEsI++3NEA/b7wyQZ0yjGGH65/oZxiwoXHvv4qUacGcdhjhdKqhfw==
X-Received: by 2002:a17:90a:7303:b0:1bf:a5e2:2c03 with SMTP id m3-20020a17090a730300b001bfa5e22c03mr27672138pjk.136.1648254976464;
        Fri, 25 Mar 2022 17:36:16 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y16-20020a637d10000000b00381268f2c6fsm6574866pgc.4.2022.03.25.17.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 17:36:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     "Leonidas P. Papadakos" <papadakospan@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd-tools: accept global share options
Date:   Sat, 26 Mar 2022 09:35:59 +0900
Message-Id: <20220326003559.5608-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220326003559.5608-1-linkinjeon@kernel.org>
References: <20220326003559.5608-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: "Leonidas P. Papadakos" <papadakospan@gmail.com>

Local options in share groups override global ones.

Signed-off-by: Leonidas P. Papadakos <papadakospan@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 lib/config_parser.c | 119 +++++++++++++++++++++++++++-----------------
 1 file changed, 73 insertions(+), 46 deletions(-)

diff --git a/lib/config_parser.c b/lib/config_parser.c
index aa1dbf2..9ce730c 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -21,6 +21,7 @@
 
 struct smbconf_global global_conf;
 struct smbconf_parser parser;
+struct smbconf_group *global_group;
 
 unsigned long long memparse(const char *v)
 {
@@ -389,62 +390,62 @@ static int cp_add_global_guest_account(gpointer _v)
 	return 0;
 }
 
-static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
+static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 {
 	if (!cp_key_cmp(_k, "server string")) {
 		global_conf.server_string = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "workgroup")) {
 		global_conf.work_group = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "netbios name")) {
 		global_conf.netbios_name = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "server min protocol")) {
 		global_conf.server_min_protocol = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "server signing")) {
 		global_conf.server_signing = cp_get_group_kv_config_opt(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "server max protocol")) {
 		global_conf.server_max_protocol = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "guest account")) {
 		cp_add_global_guest_account(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "max active sessions")) {
 		global_conf.sessions_cap = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "tcp port")) {
 		if (!global_conf.tcp_port)
 			global_conf.tcp_port = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "ipc timeout")) {
 		global_conf.ipc_timeout = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "max open files")) {
 		global_conf.file_max = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "restrict anonymous")) {
@@ -455,7 +456,7 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 			pr_err("Invalid restrict anonymous value\n");
 		}
 
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "map to guest")) {
@@ -469,22 +470,22 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		if (!cp_key_cmp(_v, "bad uid"))
 			global_conf.map_to_guest =
 				KSMBD_CONF_MAP_TO_GUEST_BAD_UID;
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "bind interfaces only")) {
 		global_conf.bind_interfaces_only = cp_get_group_kv_bool(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "interfaces")) {
 		global_conf.interfaces = cp_get_group_kv_list(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "deadtime")) {
 		global_conf.deadtime = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb2 leases")) {
@@ -493,27 +494,27 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		else
 			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB2_LEASES;
 
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "root directory")) {
 		global_conf.root_dir = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb2 max read")) {
 		global_conf.smb2_max_read = memparse(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb2 max write")) {
 		global_conf.smb2_max_write = memparse(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb2 max trans")) {
 		global_conf.smb2_max_trans = memparse(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb3 encryption")) {
@@ -522,22 +523,22 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		else
 			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_ENCRYPTION;
 
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "share:fake_fscaps")) {
 		global_conf.share_fake_fscaps = cp_get_group_kv_long(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "kerberos service name")) {
 		global_conf.krb5_service_name = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "kerberos keytab file")) {
 		global_conf.krb5_keytab_file = cp_get_group_kv_string(_v);
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "server multi channel support")) {
@@ -546,16 +547,35 @@ static void global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		else
 			global_conf.flags &= ~KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL;
 
-		return;
+		return TRUE;
 	}
 
 	if (!cp_key_cmp(_k, "smb2 max credits")) {
 		global_conf.smb2_max_credits = memparse(_v);
-		return;
+		return TRUE;
 	}
+
+	/* At this point, this is an option that must be applied to all shares */
+	return FALSE;
+}
+
+static void global_conf_default(void)
+{
+	/* The SPARSE_FILES file system capability flag is set by default */
+	global_conf.share_fake_fscaps = 64;
+}
+
+static void global_conf_create(void)
+{
+	/*
+	 * This will transfer server options to global_conf, and leave behind
+	 * in the global parser group, the options that must be applied to every
+	 * share
+	 */
+	g_hash_table_foreach_remove(global_group->kv, global_group_kv, NULL);
 }
 
-static void fixup_missing_global_group(void)
+static void global_conf_fixup_missing(void)
 {
 	int ret;
 
@@ -593,29 +613,30 @@ static void fixup_missing_global_group(void)
 			ret);
 }
 
-static void default_global_group(void)
+static void append_key_value(gpointer _k, gpointer _v, gpointer user_data)
 {
-	/* The SPARSE_FILES file system capability flag is set by default */
-	global_conf.share_fake_fscaps = 64;
-}
+	GHashTable *receiver = (GHashTable *) user_data;
 
-static void global_group(struct smbconf_group *group)
-{
-	g_hash_table_foreach(group->kv, global_group_kv, NULL);
+	/* Don't override local share options */
+	if (!g_hash_table_lookup(receiver, _k))
+		g_hash_table_insert(receiver, g_strdup(_k), g_strdup(_v));
 }
 
 #define GROUPS_CALLBACK_STARTUP_INIT	0x1
 #define GROUPS_CALLBACK_REINIT		0x2
 
-static void groups_callback(gpointer _k, gpointer _v, gpointer flags)
+static void groups_callback(gpointer _k, gpointer _v, gpointer user_data)
 {
-	if (g_ascii_strncasecmp(_k, "global", 6)) {
-		shm_add_new_share((struct smbconf_group *)_v);
-		return;
-	}
+	struct smbconf_group *group = (struct smbconf_group *)_v;
+
+	if (group != global_group) {
+		if (global_group && g_ascii_strncasecmp(_k, "ipc$", 4))
+			g_hash_table_foreach(global_group->kv,
+					     append_key_value,
+					     group->kv);
 
-	if (flags == (gpointer)GROUPS_CALLBACK_STARTUP_INIT)
-		global_group((struct smbconf_group *)_v);
+		shm_add_new_share(group);
+	}
 }
 
 static int cp_add_ipc_share(void)
@@ -648,7 +669,7 @@ static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb, long flags)
 {
 	int ret;
 
-	default_global_group();
+	global_conf_default();
 
 	ret = cp_smbconfig_hash_create(smbconf);
 	if (ret)
@@ -656,10 +677,16 @@ static int __cp_parse_smbconfig(const char *smbconf, GHFunc cb, long flags)
 
 	ret = cp_add_ipc_share();
 	if (!ret) {
+		global_group = g_hash_table_lookup(parser.groups, "global");
+
+		if (global_group && (flags == GROUPS_CALLBACK_STARTUP_INIT))
+			global_conf_create();
+
 		g_hash_table_foreach(parser.groups,
 				     groups_callback,
-				     (gpointer)flags);
-		fixup_missing_global_group();
+				     NULL);
+
+		global_conf_fixup_missing();
 	}
 	cp_smbconfig_destroy();
 	return ret;
-- 
2.25.1

