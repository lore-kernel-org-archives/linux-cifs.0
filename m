Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C490C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiCGBfR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiCGBfR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A073E0CB
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A64B6210ED;
        Mon,  7 Mar 2022 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZMqZd2qDGWVLCf2bvjcjSxP5iWrUu0XRGtOQwDZ3ec=;
        b=xQ2RuZIWDDmK33h1+V1KFk4+vV4YPDfWtmB3dRGGp6grHoWQUSDLbYodlyTl/kgpxj8El5
        sBtnBvALJV/ihTN7r00ZearvteCNypb7fWLS+6VvM2CbcqRd1mNqN+mBUkkP9Wj9xG9oEI
        /gTM5YqUv1hzEjY37Bc31w9H3KTOX5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616861;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZMqZd2qDGWVLCf2bvjcjSxP5iWrUu0XRGtOQwDZ3ec=;
        b=1/Cn7IpM3xZjeXbDw5Y/TDZNZrM+bUkoGLF4pLNcobwkat8XRz4GIXWo67sE32eu1CFh0l
        hJ8CehKOBkwZk7Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD19F1340A;
        Mon,  7 Mar 2022 01:34:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wnSdJxxhJWIldAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:20 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 4/9] share: introduce share_cmd
Date:   Sun,  6 Mar 2022 22:33:39 -0300
Message-Id: <20220307013344.29064-5-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create share command in preparation for binary unification.

Introduce a command to list available shares.

Makes open_smbconf() optionally truncate the file (for list command).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 include/ksmbdtools.h |  16 ++-
 share/Makefile.am    |   2 +-
 share/addshare.c     | 172 --------------------------------
 share/share.c        | 227 +++++++++++++++++++++++++++++++++++++++++++
 share/share_admin.c  |  85 ++++++++++++----
 share/share_admin.h  |  35 ++++++-
 6 files changed, 335 insertions(+), 202 deletions(-)
 delete mode 100644 share/addshare.c
 create mode 100644 share/share.c

diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index 170ce23ead2c..fccb88d8898a 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -101,12 +101,14 @@ extern int ksmbd_health_status;
 //---------------------------------------------------------------//
 #define LOGAPP		"[%s/%d]:"
 #define PRERR		LOGAPP" ERROR: "
+#define PRWARN		LOGAPP" WARN: "
 #define PRINF		LOGAPP" INFO: "
 #define PRDEBUG		LOGAPP" DEBUG: "
 
 #define PR_ERROR	0
-#define PR_INFO		1
-#define PR_DEBUG	2
+#define PR_WARN		1
+#define PR_INFO		2
+#define PR_DEBUG	3
 
 static int log_level = PR_INFO;
 
@@ -134,12 +136,16 @@ extern void pr_logger_init(int flags);
 					##__VA_ARGS__);			\
 	} while (0)
 
-#define pr_debug(f, ...)	\
+#define pr_debug(f, ...) \
 	pr_log(PR_DEBUG, PRDEBUG f, ##__VA_ARGS__)
-#define pr_info(f, ...)	\
+#define pr_info(f, ...) \
 	pr_log(PR_INFO, PRINF f, ##__VA_ARGS__)
-#define pr_err(f, ...)	\
+#define pr_warn(f, ...) \
+	pr_log(PR_WARN, PRWARN f, ##__VA_ARGS__)
+#define pr_err(f, ...) \
 	pr_log(PR_ERROR, PRERR f, ##__VA_ARGS__)
+#define pr_out(f, ...) \
+	fprintf(stderr, f, ##__VA_ARGS__)
 
 //---------------------------------------------------------------//
 
diff --git a/share/Makefile.am b/share/Makefile.am
index dafc985add5d..bea487edfeeb 100644
--- a/share/Makefile.am
+++ b/share/Makefile.am
@@ -4,4 +4,4 @@ ksmbd_addshare_LDADD = $(top_builddir)/lib/libksmbdtools.a
 
 sbin_PROGRAMS = ksmbd.addshare
 
-ksmbd_addshare_SOURCES = share_admin.c addshare.c share_admin.h
+ksmbd_addshare_SOURCES = share_admin.c share.c share_admin.h
diff --git a/share/addshare.c b/share/addshare.c
deleted file mode 100644
index 4ff94b18a641..000000000000
--- a/share/addshare.c
+++ /dev/null
@@ -1,172 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
- *
- *   linux-cifsd-devel@lists.sourceforge.net
- */
-
-#include <glib.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <getopt.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <sys/types.h>
-#include <signal.h>
-#include <errno.h>
-#include <ctype.h>
-
-#include "config_parser.h"
-#include "ksmbdtools.h"
-#include "management/share.h"
-#include "linux/ksmbd_server.h"
-#include "share_admin.h"
-#include "version.h"
-
-static char *arg_name;
-static char *arg_opts;
-
-enum {
-	COMMAND_ADD_SHARE = 1,
-	COMMAND_DEL_SHARE,
-	COMMAND_UPDATE_SHARE,
-};
-
-static void usage(void)
-{
-	int i;
-
-	fprintf(stderr, "Usage: smbshareadd\n");
-
-	fprintf(stderr, "\t-a | --add-share=share\n");
-	fprintf(stderr, "\t-d | --del-share=share\n");
-	fprintf(stderr, "\t-u | --update-share=share\n");
-	fprintf(stderr, "\t-o | --options=\"op1=val1 op2=val2...\"\n");
-
-	fprintf(stderr, "\t-c smb.conf\n");
-	fprintf(stderr, "\t-V | --version\n");
-	fprintf(stderr, "\t-v | --verbose\n");
-
-	fprintf(stderr, "Supported share options:\n");
-	for (i = 0; i < KSMBD_SHARE_CONF_MAX; i++)
-		fprintf(stderr, "\t%s\n", KSMBD_SHARE_CONF[i]);
-	exit(EXIT_FAILURE);
-}
-
-static void show_version(void)
-{
-	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
-	exit(EXIT_FAILURE);
-}
-
-static int parse_configs(char *smbconf)
-{
-	int ret;
-
-	ret = test_file_access(smbconf);
-	if (ret)
-		return ret;
-
-	ret = cp_smbconfig_hash_create(smbconf);
-	if (ret)
-		return ret;
-	return 0;
-}
-
-static int sanity_check_share_name_simple(char *name)
-{
-	int sz, i;
-
-	if (!name)
-		return -EINVAL;
-
-	sz = strlen(name);
-	if (sz < 1)
-		return -EINVAL;
-	if (sz >= KSMBD_REQ_MAX_SHARE_NAME)
-		return -EINVAL;
-
-	if (!cp_key_cmp(name, "global"))
-		return -EINVAL;
-
-	return -EINVAL;
-}
-
-int main(int argc, char *argv[])
-{
-	int ret = EXIT_FAILURE;
-	char *smbconf = PATH_SMBCONF;
-	int c, cmd = 0;
-
-	set_logger_app_name("ksmbd.addshare");
-
-	opterr = 0;
-	while ((c = getopt(argc, argv, "c:a:d:u:p:o:Vvh")) != EOF)
-		switch (c) {
-		case 'a':
-			arg_name = g_ascii_strdown(optarg, strlen(optarg));
-			cmd = COMMAND_ADD_SHARE;
-			break;
-		case 'd':
-			arg_name = g_ascii_strdown(optarg, strlen(optarg));
-			cmd = COMMAND_DEL_SHARE;
-			break;
-		case 'u':
-			arg_name = g_ascii_strdown(optarg, strlen(optarg));
-			cmd = COMMAND_UPDATE_SHARE;
-			break;
-		case 'c':
-			smbconf = strdup(optarg);
-			break;
-		case 'o':
-			arg_opts = strdup(optarg);
-			break;
-		case 'V':
-			show_version();
-			break;
-		case 'v':
-			break;
-		case '?':
-		case 'h':
-		default:
-			usage();
-	}
-
-	if (cmd != COMMAND_DEL_SHARE && !arg_opts) {
-		usage();
-		return -1;
-	}
-
-	if (sanity_check_share_name_simple(arg_name)) {
-		pr_err("share name sanity check failure\n");
-		goto out;
-	}
-
-	if (!smbconf) {
-		pr_err("Out of memory\n");
-		goto out;
-	}
-
-	ret = parse_configs(smbconf);
-	if (ret) {
-		pr_err("Unable to parse configuration files\n");
-		goto out;
-	}
-
-	if (cmd == COMMAND_ADD_SHARE)
-		ret = command_add_share(smbconf, arg_name, arg_opts);
-	if (cmd == COMMAND_DEL_SHARE)
-		ret = command_del_share(smbconf, arg_name);
-	if (cmd == COMMAND_UPDATE_SHARE)
-		ret = command_update_share(smbconf, arg_name, arg_opts);
-
-	/*
-	 * We support only ADD_SHARE command for the time being
-	 */
-	if (ret == 0 && cmd == COMMAND_ADD_SHARE)
-		notify_ksmbd_daemon();
-out:
-	cp_smbconfig_destroy();
-	return ret;
-}
diff --git a/share/share.c b/share/share.c
new file mode 100644
index 000000000000..91d23d28c426
--- /dev/null
+++ b/share/share.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
+ *
+ *   linux-cifsd-devel@lists.sourceforge.net
+ */
+
+#include <glib.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <errno.h>
+#include <ctype.h>
+
+#include "config_parser.h"
+#include "ksmbdtools.h"
+#include "management/share.h"
+#include "linux/ksmbd_server.h"
+#include "share_admin.h"
+
+static ksmbd_share_cmd ksmbd_share_get_cmd(char *cmd)
+{
+	int i;
+
+	if (!cmd)
+		return KSMBD_CMD_SHARE_NONE;
+
+	for (i = 1; i < KSMBD_CMD_SHARE_MAX; i++)
+		if (!strcmp(cmd, ksmbd_share_cmds_str[i]))
+			return (ksmbd_share_cmd)i;
+
+	return KSMBD_CMD_SHARE_NONE;
+}
+
+static const char *ksmbd_share_get_cmd_str(ksmbd_share_cmd cmd)
+{
+	if (cmd > KSMBD_CMD_SHARE_MAX)
+		return ksmbd_share_cmds_str[KSMBD_CMD_SHARE_NONE];
+
+	return ksmbd_share_cmds_str[(int)cmd];
+}
+
+static int parse_configs(char *smbconf)
+{
+	int ret;
+
+	ret = test_file_access(smbconf);
+	if (ret)
+		return ret;
+
+	ret = cp_smbconfig_hash_create(smbconf);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int sanity_check_share_name_simple(char *name)
+{
+	int sz, i;
+
+	if (!name)
+		return -EINVAL;
+
+	sz = strlen(name);
+	if (sz < 1)
+		return -EINVAL;
+	if (sz >= KSMBD_REQ_MAX_SHARE_NAME)
+		return -EINVAL;
+
+	if (!cp_key_cmp(name, "global"))
+		return -EINVAL;
+
+	for (i = 0; i < sz; i++) {
+		if (isalnum(name[i]))
+			return 0;
+	}
+	return -EINVAL;
+}
+
+void share_usage(ksmbd_share_cmd cmd)
+{
+	int i;
+	const char *cmd_str = ksmbd_share_get_cmd_str(cmd);
+
+	switch (cmd) {
+	case KSMBD_CMD_SHARE_ADD:
+	case KSMBD_CMD_SHARE_UPDATE:
+		pr_out("Usage: ksmbdctl share %s <share_name> [-c <file>] -o \"op1=val1,op2=val2,...\"\n", cmd_str);
+		pr_out("Adds or updates a share to smb.conf file.\n\n");
+		pr_out("%-30s%s", "  -c, --conf=<file>", "Use <file> as smb.conf\n");
+		pr_out("%-30s%s", "  -o, --options=<options>", "Specify options for share\n\n");
+		pr_out("Supported share options:\n");
+		for (i = 0; i < KSMBD_SHARE_CONF_MAX; i++)
+			pr_out("%s\n", KSMBD_SHARE_CONF[i]);
+		break;
+	case KSMBD_CMD_SHARE_DELETE:
+		pr_out("Usage: ksmbdctl share delete <share_name>\n");
+		pr_out("Deletes a share.\n\n");
+		break;
+	default:
+		pr_out("Usage: ksmbdctl share <subcommand> <args> [options]\n");
+		pr_out("Share management.\n\n");
+		pr_out("List of available subcommands:\n");
+		pr_out("%-20s%s", "  add", "Add a share\n");
+		pr_out("%-20s%s", "  delete", "Delete a share\n");
+		pr_out("%-20s%s", "  update", "Update a share\n");
+		pr_out("%-20s%s", "  list", "List the names of all shares available\n\n");
+		break;
+	}
+
+	exit(EXIT_FAILURE);
+}
+
+int share_cmd(int argc, char *argv[])
+{
+	int ret = EXIT_FAILURE;
+	char *smbconf = PATH_SMBCONF;
+	char *share_name = NULL;
+	char *options = NULL;
+	ksmbd_share_cmd cmd = KSMBD_CMD_SHARE_NONE;
+	int c;
+
+	if (argc < 2)
+		goto usage;
+
+	set_logger_app_name("ksmbd-share");
+
+	cmd = ksmbd_share_get_cmd(argv[1]);
+
+	if (cmd == KSMBD_CMD_SHARE_NONE)
+		goto usage;
+
+	if(argc == 2 && cmd != KSMBD_CMD_SHARE_LIST)
+		goto missing_arg;
+
+	if (argv[2] && argv[2][0] != '-')
+		share_name = g_ascii_strdown(argv[2], strlen(argv[2]));
+	else if (cmd != KSMBD_CMD_SHARE_LIST)
+		goto usage;
+
+	optind = 1;
+	while ((c = getopt_long(argc, argv, "-:c:o:", share_opts, NULL)) != EOF)
+		switch (c) {
+		case 1:
+			break;
+		case 'c':
+			if (cmd == KSMBD_CMD_SHARE_DELETE)
+				continue;
+			smbconf = strdup(optarg);
+			break;
+		case 'o':
+			if (cmd == KSMBD_CMD_SHARE_DELETE || cmd == KSMBD_CMD_SHARE_LIST)
+				continue;
+			options = strdup(optarg);
+			break;
+		case ':':
+		case '?':
+		default:
+			goto usage;
+		}
+
+	if (cmd == KSMBD_CMD_SHARE_LIST)
+		goto share_list;
+
+	if (!share_name)
+		goto missing_arg;
+
+	if (cmd != KSMBD_CMD_SHARE_DELETE && !options) {
+		pr_out("Subcommand \"%s\" requires '-o' option set.\n\n", ksmbd_share_get_cmd_str(cmd));
+		goto usage;
+	}
+
+	if (sanity_check_share_name_simple(share_name)) {
+		pr_err("Share name (%s) sanity check failure\n", share_name);
+		goto out;
+	}
+
+share_list:
+	if (!smbconf) {
+		pr_err("Out of memory\n");
+		goto out;
+	}
+
+	ret = parse_configs(smbconf);
+	if (ret) {
+		pr_err("Unable to parse configuration file %s\n", smbconf);
+		goto out;
+	}
+
+	switch (cmd) {
+	case KSMBD_CMD_SHARE_ADD:
+		ret = share_add_cmd(smbconf, share_name, options);
+		break;
+	case KSMBD_CMD_SHARE_DELETE:
+		ret = share_delete_cmd(smbconf, share_name);
+		break;
+	case KSMBD_CMD_SHARE_UPDATE:
+		ret = share_update_cmd(smbconf, share_name, options);
+		break;
+	case KSMBD_CMD_SHARE_LIST:
+		ret = share_list_cmd(smbconf);
+		break;
+	}
+
+	/*
+	 * FIXME: We support only ADD_SHARE command for the time being
+	 */
+	if (ret == 0 && cmd == KSMBD_CMD_SHARE_ADD)
+		notify_ksmbd_daemon();
+
+out:
+	cp_smbconfig_destroy();
+	return ret;
+missing_arg:
+	if (cmd > KSMBD_CMD_SHARE_NONE && cmd < KSMBD_CMD_SHARE_MAX)
+		pr_out("Subcommand \"%s\" requires an argument.\n\n", ksmbd_share_get_cmd_str(cmd));
+usage:
+	share_usage(cmd);
+
+	return ret;
+}
diff --git a/share/share_admin.c b/share/share_admin.c
index 0ff13d8017dd..61780fb00b5a 100644
--- a/share/share_admin.c
+++ b/share/share_admin.c
@@ -1,12 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
  *
  *   linux-cifsd-devel@lists.sourceforge.net
  */
 
 #include <glib.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <getopt.h>
@@ -48,24 +50,26 @@ static char *aux_group_name(char *name)
 	return gn;
 }
 
-static int __open_smbconf(char *smbconf)
+static int open_smbconf(char *smbconf, bool truncate)
 {
-	conf_fd = open(smbconf, O_WRONLY);
+	conf_fd = open(smbconf, O_RDWR);
 	if (conf_fd == -1) {
 		pr_err("%s %s\n", strerr(errno), smbconf);
 		return -EINVAL;
 	}
 
-	if (ftruncate(conf_fd, 0)) {
-		pr_err("%s %s\n", strerr(errno), smbconf);
-		close(conf_fd);
-		return -EINVAL;
+	if (truncate) {
+		if (ftruncate(conf_fd, 0)) {
+			pr_err("%s %s\n", strerr(errno), smbconf);
+			close(conf_fd);
+			return -EINVAL;
+		}
 	}
 
 	return 0;
 }
 
-static void __write(void)
+static void do_write(void)
 {
 	int nr = 0;
 	int ret;
@@ -83,7 +87,7 @@ static void __write(void)
 	}
 }
 
-static void __write_share(gpointer key, gpointer value, gpointer buf)
+static void write_share(gpointer key, gpointer value, gpointer buf)
 {
 	char *k = (char *)key;
 	char *v = (char *)value;
@@ -95,14 +99,14 @@ static void __write_share(gpointer key, gpointer value, gpointer buf)
 			sizeof(wbuf));
 		exit(EXIT_FAILURE);
 	}
-	__write();
+	do_write();
 }
 
-static void write_share(struct smbconf_group *g)
+static void write_share_all(struct smbconf_group *g)
 {
 	wsz = snprintf(wbuf, sizeof(wbuf), "[%s]\n", g->name);
-	__write();
-	g_hash_table_foreach(g->kv, __write_share, NULL);
+	do_write();
+	g_hash_table_foreach(g->kv, write_share, NULL);
 }
 
 static void write_share_cb(gpointer key, gpointer value, gpointer share_data)
@@ -113,7 +117,7 @@ static void write_share_cb(gpointer key, gpointer value, gpointer share_data)
 	 * Do not write AUX group
 	 */
 	if (!strstr(g->name, AUX_GROUP_PREFIX))
-		write_share(g);
+		write_share_all(g);
 }
 
 static void write_remove_share_cb(gpointer key,
@@ -127,7 +131,7 @@ static void write_remove_share_cb(gpointer key,
 		return;
 	}
 
-	write_share(g);
+	write_share_all(g);
 }
 
 static void update_share_cb(gpointer key,
@@ -145,12 +149,32 @@ static void update_share_cb(gpointer key,
 	g_hash_table_insert(g, nk, nv);
 }
 
-int command_add_share(char *smbconf, char *name, char *opts)
+static void list_shares_cb(gpointer key, gpointer value, gpointer data)
+{
+	char *nk, *nv;
+
+	nk = g_strdup(key);
+	nv = g_strdup(value);
+
+	if (!nk || !nv)
+		exit(EXIT_FAILURE);
+
+	if (!strcmp(nk, "global"))
+		goto out;
+
+	pr_out("%s\n", nk);
+
+out:
+	g_free(nk);
+	g_free(nv);
+}
+
+int share_add_cmd(char *smbconf, char *name, char *opts)
 {
 	char *new_name = NULL;
 
 	if (g_hash_table_lookup(parser.groups, name)) {
-		pr_err("Share already exists: %s\n", name);
+		pr_warn("Share already exists: %s\n", name);
 		return -EEXIST;
 	}
 
@@ -158,7 +182,7 @@ int command_add_share(char *smbconf, char *name, char *opts)
 	if (cp_parse_external_smbconf_group(new_name, opts))
 		goto error;
 
-	if (__open_smbconf(smbconf))
+	if (open_smbconf(smbconf, true))
 		goto error;
 	g_hash_table_foreach(parser.groups, write_share_cb, NULL);
 	close(conf_fd);
@@ -170,7 +194,7 @@ error:
 	return -EINVAL;
 }
 
-int command_update_share(char *smbconf, char *name, char *opts)
+int share_update_cmd(char *smbconf, char *name, char *opts)
 {
 	struct smbconf_group *existing_group;
 	struct smbconf_group *update_group;
@@ -198,7 +222,7 @@ int command_update_share(char *smbconf, char *name, char *opts)
 			     update_share_cb,
 			     existing_group->kv);
 
-	if (__open_smbconf(smbconf))
+	if (open_smbconf(smbconf, true))
 		goto error;
 
 	g_hash_table_foreach(parser.groups, write_share_cb, NULL);
@@ -211,9 +235,9 @@ error:
 	return -EINVAL;
 }
 
-int command_del_share(char *smbconf, char *name)
+int share_delete_cmd(char *smbconf, char *name)
 {
-	if (__open_smbconf(smbconf))
+	if (open_smbconf(smbconf, true))
 		return -EINVAL;
 
 	g_hash_table_foreach(parser.groups,
@@ -222,3 +246,22 @@ int command_del_share(char *smbconf, char *name)
 	close(conf_fd);
 	return 0;
 }
+
+int share_list_cmd(char *smbconf)
+{
+	if (open_smbconf(smbconf, false))
+		return -EINVAL;
+
+	if (g_hash_table_size(parser.groups) <= 1) {
+		pr_out("No shares available in %s.\n", smbconf);
+		goto out;
+	}
+
+	pr_out("Shares available in %s:\n", smbconf);
+	g_hash_table_foreach(parser.groups,
+			     list_shares_cb,
+			     NULL);
+out:
+	close(conf_fd);
+	return 0;
+}
diff --git a/share/share_admin.h b/share/share_admin.h
index 7df3871bfe81..00cf1147af18 100644
--- a/share/share_admin.h
+++ b/share/share_admin.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
  *
  *   linux-cifsd-devel@lists.sourceforge.net
  */
@@ -8,8 +9,36 @@
 #ifndef __KSMBD_SHARE_ADMIN_H__
 #define __KSMBD_SHARE_ADMIN_H__
 
-int command_add_share(char *smbconf, char *name, char *opts);
-int command_update_share(char *smbconf, char *name, char *opts);
-int command_del_share(char *smbconf, char *name);
+int share_add_cmd(char *smbconf, char *name, char *opts);
+int share_delete_cmd(char *smbconf, char *name);
+int share_update_cmd(char *smbconf, char *name, char *opts);
+int share_list_cmd(char *smbconf);
+
+typedef enum {
+	KSMBD_CMD_SHARE_NONE = 0,
+	KSMBD_CMD_SHARE_ADD,
+	KSMBD_CMD_SHARE_DELETE,
+	KSMBD_CMD_SHARE_UPDATE,
+	KSMBD_CMD_SHARE_LIST,
+	KSMBD_CMD_SHARE_MAX
+} ksmbd_share_cmd;
+
+/* List of supported subcommands */
+static const char *ksmbd_share_cmds_str[] = {
+	"none",
+	"add",
+	"delete",
+	"update",
+	"list"
+};
+
+static struct option share_opts[] = {
+        { "conf", required_argument, NULL, 'c' },
+        { "options", required_argument, NULL, 'o' },
+	{ 0, 0, 0, 0 },
+};
+
+void share_usage(ksmbd_share_cmd cmd);
+int share_cmd(int argc, char *argv[]);
 
 #endif /* __KSMBD_SHARE_ADMIN_H__ */
-- 
2.34.1

