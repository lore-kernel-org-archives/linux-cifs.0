Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DB3C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiCGBfX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiCGBfV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:21 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2343ED2C
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 698641F38E;
        Mon,  7 Mar 2022 01:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ko+1977Dpz412rYtBkdv3BBW+4Npe98VCjEVojvyaHU=;
        b=SxaBxDLfmtXoIrjA20P+XnAV90zrg8ZT9xKZIC9ebvisMlQhRu0wewZtI3In5Wcw37T/Ml
        1uptxzUdbv3WbGLVgANkhpo15v+godEjCAl4QasZiKojfP9cm9CUkAFvkKjwP4JjBtcbVr
        fetg2dvVUYOzR92ruXkP0BBFww7uB0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616865;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ko+1977Dpz412rYtBkdv3BBW+4Npe98VCjEVojvyaHU=;
        b=dERnD9JTsLFjqSsGeUERMMqkNzxzVNFMuvX8xdhSMlcDZ+pUcGvFTUOywrttRjnS8aSh10
        7o6Cb8jEGpkL86CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6FE821340A;
        Mon,  7 Mar 2022 01:34:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id q8h5DSBhJWIwdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:24 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 5/9] user: introduce user_cmd
Date:   Sun,  6 Mar 2022 22:33:40 -0300
Message-Id: <20220307013344.29064-6-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create user command in preparation for binary unification.

Rename some variables to make them more relatable to user properties and
management.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 daemon/daemon.c         |  12 +-
 daemon/ipc.c            |   6 +-
 include/config_parser.h |   2 +-
 include/ksmbdtools.h    |   7 +-
 lib/config_parser.c     |   4 +-
 user/Makefile.am        |   2 +-
 user/adduser.c          | 180 -----------------------------
 user/user.c             | 238 ++++++++++++++++++++++++++++++++++++++
 user/user_admin.c       | 247 +++++++++++++++++++++-------------------
 user/user_admin.h       |  35 +++++-
 10 files changed, 417 insertions(+), 316 deletions(-)
 delete mode 100644 user/adduser.c
 create mode 100644 user/user.c

diff --git a/daemon/daemon.c b/daemon/daemon.c
index 946f500bc977..50afbd2ed70d 100644
--- a/daemon/daemon.c
+++ b/daemon/daemon.c
@@ -291,11 +291,11 @@ static int setup_signals(sighandler_t handler)
 	return 0;
 }
 
-static int parse_configs(char *pwddb, char *smbconf)
+static int parse_configs(char *db, char *smbconf)
 {
 	int ret;
 
-	ret = cp_parse_pwddb(pwddb);
+	ret = cp_parse_db(db);
 	if (ret == -ENOENT) {
 		pr_err("User database file does not exist. %s\n",
 			"Only guest sessions (if permitted) will work.");
@@ -395,7 +395,7 @@ static int worker_process_init(void)
 		goto out;
 	}
 
-	ret = parse_configs(global_conf.pwddb, global_conf.smbconf);
+	ret = parse_configs(global_conf.db, global_conf.smbconf);
 	if (ret) {
 		pr_err("Failed to parse configuration files\n");
 		goto out;
@@ -645,7 +645,7 @@ int main(int argc, char *argv[])
 
 	set_logger_app_name("ksmbd.daemon");
 	memset(&global_conf, 0x00, sizeof(struct smbconf_global));
-	global_conf.pwddb = PATH_PWDDB;
+	global_conf.db = PATH_USERS_DB;
 	global_conf.smbconf = PATH_SMBCONF;
 	pr_logger_init(PR_LOGGER_STDIO);
 
@@ -669,7 +669,7 @@ int main(int argc, char *argv[])
 			global_conf.smbconf = g_strdup(optarg);
 			break;
 		case 'u':
-			global_conf.pwddb = g_strdup(optarg);
+			global_conf.db = g_strdup(optarg);
 			break;
 		case 'n':
 			if (!optarg)
@@ -694,7 +694,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!global_conf.smbconf || !global_conf.pwddb) {
+	if (!global_conf.smbconf || !global_conf.db) {
 		pr_err("Out of memory\n");
 		exit(EXIT_FAILURE);
 	}
diff --git a/daemon/ipc.c b/daemon/ipc.c
index c46cbc174175..b793a1e101b0 100644
--- a/daemon/ipc.c
+++ b/daemon/ipc.c
@@ -63,13 +63,13 @@ static int generic_event(int type, void *payload, size_t sz)
 	return 0;
 }
 
-static int parse_reload_configs(const char *pwddb, const char *smbconf)
+static int parse_reload_configs(const char *db, const char *smbconf)
 {
 	int ret;
 
 	pr_debug("Reload config\n");
 	usm_remove_all_users();
-	ret = cp_parse_pwddb(pwddb);
+	ret = cp_parse_db(db);
 	if (ret == -ENOENT) {
 		pr_err("User database file does not exist. %s\n",
 		       "Only guest sessions (if permitted) will work.");
@@ -91,7 +91,7 @@ static int handle_generic_event(struct nl_cache_ops *unused,
 				void *arg)
 {
 	if (ksmbd_health_status & KSMBD_SHOULD_RELOAD_CONFIG) {
-		parse_reload_configs(global_conf.pwddb, global_conf.smbconf);
+		parse_reload_configs(global_conf.db, global_conf.smbconf);
 		ksmbd_health_status &= ~KSMBD_SHOULD_RELOAD_CONFIG;
 	}
 
diff --git a/include/config_parser.h b/include/config_parser.h
index c051f487c319..0aefc3b4d5c7 100644
--- a/include/config_parser.h
+++ b/include/config_parser.h
@@ -26,7 +26,7 @@ int cp_parse_external_smbconf_group(char *name, char *opts);
 int cp_smbconfig_hash_create(const char *smbconf);
 void cp_smbconfig_destroy(void);
 
-int cp_parse_pwddb(const char *pwddb);
+int cp_parse_db(const char *db);
 int cp_parse_smbconf(const char *smbconf);
 int cp_parse_reload_smbconf(const char *smbconf);
 int cp_parse_subauth(const char *subauth_path);
diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index fccb88d8898a..978cbe148eac 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -57,7 +57,7 @@ struct smbconf_global {
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
 	char			*krb5_service_name;
-	char			*pwddb;
+	char			*db;
 	char			*smbconf;
 };
 
@@ -85,8 +85,9 @@ extern struct smbconf_global global_conf;
 
 #define KSMBD_CONF_FILE_MAX		10000
 
-#define PATH_PWDDB	"/etc/ksmbd/ksmbdpwd.db"
-#define PATH_SMBCONF	"/etc/ksmbd/smb.conf"
+#define PATH_USERS_DB		"/etc/ksmbd/users.db"
+#define PATH_OLD_USERS_DB	"/etc/ksmbd/ksmbdpwd.db"
+#define PATH_SMBCONF		"/etc/ksmbd/smb.conf"
 
 #define KSMBD_HEALTH_START		(0)
 #define KSMBD_HEALTH_RUNNING		(1 << 0)
diff --git a/lib/config_parser.c b/lib/config_parser.c
index 20e27c3ab8ec..a000a2a6059e 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -680,9 +680,9 @@ int cp_parse_smbconf(const char *smbconf)
 				    GROUPS_CALLBACK_STARTUP_INIT);
 }
 
-int cp_parse_pwddb(const char *pwddb)
+int cp_parse_db(const char *db)
 {
-	return __mmap_parse_file(pwddb, usm_add_update_user_from_pwdentry);
+	return __mmap_parse_file(db, usm_add_update_user_from_pwdentry);
 }
 
 int cp_smbconfig_hash_create(const char *smbconf)
diff --git a/user/Makefile.am b/user/Makefile.am
index c5cee686f5cc..ba491c84f0f4 100644
--- a/user/Makefile.am
+++ b/user/Makefile.am
@@ -4,4 +4,4 @@ ksmbd_adduser_LDADD = $(top_builddir)/lib/libksmbdtools.a
 
 sbin_PROGRAMS = ksmbd.adduser
 
-ksmbd_adduser_SOURCES = md4_hash.c user_admin.c adduser.c md4_hash.h user_admin.h
+ksmbd_adduser_SOURCES = md4_hash.c user_admin.c user.c md4_hash.h user_admin.h
diff --git a/user/adduser.c b/user/adduser.c
deleted file mode 100644
index 88b12db9f439..000000000000
--- a/user/adduser.c
+++ /dev/null
@@ -1,180 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
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
-#include "management/user.h"
-#include "management/share.h"
-#include "user_admin.h"
-#include "linux/ksmbd_server.h"
-#include "version.h"
-
-static char *arg_account = NULL;
-static char *arg_password = NULL;
-
-enum {
-	COMMAND_ADD_USER = 1,
-	COMMAND_DEL_USER,
-	COMMAND_UPDATE_USER,
-};
-
-static void usage(void)
-{
-	fprintf(stderr, "Usage: smbuseradd\n");
-
-	fprintf(stderr, "\t-a | --add-user=login\n");
-	fprintf(stderr, "\t-d | --del-user=login\n");
-	fprintf(stderr, "\t-u | --update-user=login\n");
-	fprintf(stderr, "\t-p | --password=pass\n");
-
-	fprintf(stderr, "\t-i smbpwd.db | --import-users=smbpwd.db\n");
-	fprintf(stderr, "\t-V | --version\n");
-	fprintf(stderr, "\t-v | --verbose\n");
-
-	exit(EXIT_FAILURE);
-}
-
-static void show_version(void)
-{
-	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
-	exit(EXIT_FAILURE);
-}
-
-static int parse_configs(char *pwddb)
-{
-	int ret;
-
-	ret = test_file_access(pwddb);
-	if (ret)
-		return ret;
-
-	ret = cp_parse_pwddb(pwddb);
-	if (ret)
-		return ret;
-	return 0;
-}
-
-static int sanity_check_user_name_simple(char *uname)
-{
-	int sz, i;
-
-	if (!uname)
-		return -EINVAL;
-
-	sz = strlen(uname);
-	if (sz < 1)
-		return -EINVAL;
-	if (sz >= KSMBD_REQ_MAX_ACCOUNT_NAME_SZ)
-		return -EINVAL;
-
-	/* 1'; Drop table users -- */
-	if (!strcmp(uname, "root"))
-		return -EINVAL;
-
-	if (strpbrk(uname, ":\n"))
-		return -EINVAL;
-
-	return 0;
-}
-
-int main(int argc, char *argv[])
-{
-	int ret = EXIT_FAILURE;
-	char *pwddb = PATH_PWDDB;
-	int c, cmd = 0;
-
-	set_logger_app_name("ksmbd.adduser");
-
-	opterr = 0;
-	while ((c = getopt(argc, argv, "c:i:a:d:u:p:Vvh")) != EOF)
-		switch (c) {
-		case 'a':
-			arg_account = g_strdup(optarg);
-			cmd = COMMAND_ADD_USER;
-			break;
-		case 'd':
-			arg_account = g_strdup(optarg);
-			cmd = COMMAND_DEL_USER;
-			break;
-		case 'u':
-			arg_account = g_strdup(optarg);
-			cmd = COMMAND_UPDATE_USER;
-			break;
-		case 'p':
-			arg_password = g_strdup(optarg);
-			break;
-		case 'i':
-			pwddb = g_strdup(optarg);
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
-	if (sanity_check_user_name_simple(arg_account)) {
-		pr_err("User name sanity check failure\n");
-		goto out;
-	}
-
-	if (!pwddb) {
-		pr_err("Out of memory\n");
-		goto out;
-	}
-
-	ret = usm_init();
-	if (ret) {
-		pr_err("Failed to init user management\n");
-		goto out;
-	}
-
-	ret = shm_init();
-	if (ret) {
-		pr_err("Failed to init net share management\n");
-		goto out;
-	}
-
-	ret = parse_configs(pwddb);
-	if (ret) {
-		pr_err("Unable to parse configuration files\n");
-		goto out;
-	}
-
-	if (cmd == COMMAND_ADD_USER)
-		ret = command_add_user(pwddb, arg_account, arg_password);
-	if (cmd == COMMAND_DEL_USER)
-		ret = command_del_user(pwddb, arg_account);
-	if (cmd == COMMAND_UPDATE_USER)
-		ret = command_update_user(pwddb, arg_account, arg_password);
-
-	/*
-	 * We support only ADD_USER command at this moment
-	 */
-	if (ret == 0 && cmd == COMMAND_ADD_USER)
-		notify_ksmbd_daemon();
-out:
-	shm_destroy();
-	usm_destroy();
-	return ret;
-}
diff --git a/user/user.c b/user/user.c
new file mode 100644
index 000000000000..f59c34c11b02
--- /dev/null
+++ b/user/user.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
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
+#include "management/user.h"
+#include "management/share.h"
+#include "user_admin.h"
+#include "linux/ksmbd_server.h"
+
+static ksmbd_user_cmd ksmbd_user_get_cmd(char *cmd)
+{
+	int i;
+
+	if (!cmd)
+		return KSMBD_CMD_USER_NONE;
+
+	for (i = 1; i < KSMBD_CMD_USER_MAX; i++)
+		if (!strcmp(cmd, ksmbd_user_cmds_str[i]))
+			return (ksmbd_user_cmd)i;
+
+	return KSMBD_CMD_USER_NONE;
+}
+
+static const char *ksmbd_user_get_cmd_str(ksmbd_user_cmd cmd)
+{
+	if (cmd > KSMBD_CMD_USER_MAX)
+		return ksmbd_user_cmds_str[KSMBD_CMD_USER_NONE];
+
+	return ksmbd_user_cmds_str[(int)cmd];
+}
+
+void user_usage(ksmbd_user_cmd cmd)
+{
+	const char *cmd_str = ksmbd_user_get_cmd_str(cmd);
+
+	switch (cmd) {
+	case KSMBD_CMD_USER_ADD:
+	case KSMBD_CMD_USER_UPDATE:
+		pr_out("Usage: ksmbdctl user %s <username> [-p <password>] [-d <file>]\n", cmd_str);
+		pr_out("Adds or updates a user to the database.\n\n");
+		pr_out("%-30s%s", "  -p, --password=<password>", "Use <password> for <username>\n");
+		pr_out("%-30s%s", "  -d, --database=<file>", "Use <file> as database\n\n");
+		break;
+	case KSMBD_CMD_USER_DELETE:
+		pr_out("Usage: ksmbdctl user delete <username>\n");
+		pr_out("Delete user from database.\n\n");
+		break;
+	case KSMBD_CMD_USER_LIST:
+		pr_out("Usage: ksmbdctl user list\n");
+		pr_out("List users in database.\n\n");
+		pr_out("%-30s%s", "  -d, --database=<file>", "Use <file> as database\n\n");
+		break;
+	default:
+		pr_out("Usage: ksmbdctl user <subcommand> <args> [options]\n");
+		pr_out("User management.\n\n");
+		pr_out("List of available subcommands:\n");
+		pr_out("%-20s%s", "  add", "Add a user\n");
+		pr_out("%-20s%s", "  delete", "Delete a user\n");
+		pr_out("%-20s%s", "  update", "Update an existing user\n");
+		pr_out("%-20s%s", "  list", "List users in user database\n\n");
+		break;
+	}
+
+	exit(EXIT_FAILURE);
+}
+
+static int parse_configs(char *db)
+{
+	int ret;
+
+	ret = test_file_access(db);
+	if (ret)
+		return ret;
+
+	ret = cp_parse_db(db);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int sanity_check_user_name_simple(char *uname)
+{
+	int sz, i;
+
+	if (!uname)
+		return -EINVAL;
+
+	sz = strlen(uname);
+	if (sz < 1)
+		return -EINVAL;
+	if (sz >= KSMBD_REQ_MAX_ACCOUNT_NAME_SZ)
+		return -EINVAL;
+
+	/* 1'; Drop table users -- */
+	if (!strcmp(uname, "root"))
+		return -EINVAL;
+
+	for (i = 0; i < sz; i++) {
+		if (isalnum(uname[i]))
+			return 0;
+	}
+	return -EINVAL;
+}
+
+int user_cmd(int argc, char *argv[])
+{
+	int ret = EXIT_FAILURE;
+	char *db = PATH_USERS_DB;
+	char *login = NULL;
+	char *pw = NULL;
+	ksmbd_user_cmd cmd = KSMBD_CMD_USER_NONE;
+	const char *cmd_str = NULL;
+	int c;
+
+	if (argc < 2)
+		goto usage;
+
+	set_logger_app_name("ksmbd-user");
+
+	cmd = ksmbd_user_get_cmd(argv[1]);
+	cmd_str = ksmbd_user_get_cmd_str(cmd);
+
+	if (cmd == KSMBD_CMD_USER_NONE)
+		goto usage;
+
+	if (cmd != KSMBD_CMD_USER_LIST) {
+		if (argc == 2)
+			goto missing_arg;
+
+		if (argv[2][0] != '-')
+			login = g_strdup(argv[2]);
+		else
+			goto usage;
+	}
+
+	optind = 1;
+	while((c = getopt_long(argc, argv, "-:p:d:", user_opts, NULL)) != EOF)
+		switch (c) {
+		case 1:
+			break;
+		case 'p':
+			pw = g_strdup(optarg);
+			break;
+		case 'd':
+			db = g_strdup(optarg);
+			break;
+		case ':':
+		case '?':
+		default:
+			goto usage;
+		}
+
+	if (cmd == KSMBD_CMD_USER_LIST)
+		goto user_list;
+
+	if (!login)
+		goto missing_arg;
+
+	if (sanity_check_user_name_simple(login)) {
+		pr_err("User name (%s) sanity check failure\n");
+		goto out;
+	}
+
+user_list:
+	if (!db) {
+		pr_err("Out of memory\n");
+		goto out;
+	}
+
+	ret = usm_init();
+	if (ret) {
+		pr_err("Failed to init user management\n");
+		goto out;
+	}
+
+	ret = shm_init();
+	if (ret) {
+		pr_err("Failed to init net share management\n");
+		goto out;
+	}
+
+	ret = parse_configs(db);
+	if (ret) {
+		pr_err("Unable to parse database file %s\n", db);
+		goto out;
+	}
+
+	switch (cmd) {
+	case KSMBD_CMD_USER_ADD:
+		ret = user_add_cmd(db, login, pw);
+		break;
+	case KSMBD_CMD_USER_DELETE:
+		ret = user_delete_cmd(db, login);
+		break;
+	case KSMBD_CMD_USER_UPDATE:
+		ret = user_update_cmd(db, login, pw);
+		break;
+	case KSMBD_CMD_USER_LIST:
+		ret = user_list_cmd(db);
+		break;
+	}
+
+	/*
+	 * FIXME: We support only ADD_USER command at this moment
+	 */
+	if (ret == 0 && cmd == KSMBD_CMD_USER_ADD)
+		notify_ksmbd_daemon();
+out:
+	shm_destroy();
+	usm_destroy();
+	return ret;
+
+missing_arg:
+	if (cmd > KSMBD_CMD_USER_NONE && cmd < KSMBD_CMD_USER_MAX)
+		pr_out("Subcommand \"%s\" requires an argument.\n\n", cmd_str);
+usage:
+	user_usage(cmd);
+
+	return ret;
+}
diff --git a/user/user_admin.c b/user/user_admin.c
index 95b05ea33f28..ca0e14978701 100644
--- a/user/user_admin.c
+++ b/user/user_admin.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
  *
  *   linux-cifsd-devel@lists.sourceforge.net
  */
@@ -8,8 +9,8 @@
 #include <glib.h>
 #include <stdlib.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <unistd.h>
-#include <getopt.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <termios.h>
@@ -24,23 +25,23 @@
 
 #define MAX_NT_PWD_LEN 129
 
-static char *arg_account = NULL;
-static char *arg_password = NULL;
 static int conf_fd = -1;
 static char wbuf[2 * MAX_NT_PWD_LEN + 2 * KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 
-static int __opendb_file(char *pwddb)
+static int open_db(char *db, bool truncate)
 {
-	conf_fd = open(pwddb, O_WRONLY);
+	conf_fd = open(db, O_WRONLY);
 	if (conf_fd == -1) {
-		pr_err("%s %s\n", strerr(errno), pwddb);
+		pr_err("%s %s\n", strerr(errno), db);
 		return -EINVAL;
 	}
 
-	if (ftruncate(conf_fd, 0)) {
-		pr_err("%s %s\n", strerr(errno), pwddb);
-		close(conf_fd);
-		return -EINVAL;
+	if (truncate) {
+		if (ftruncate(conf_fd, 0)) {
+			pr_err("%s %s\n", strerr(errno), db);
+			close(conf_fd);
+			return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -60,149 +61,147 @@ static void term_toggle_echo(int on_off)
 	tcsetattr(STDIN_FILENO, TCSAFLUSH, &term);
 }
 
-static char *__prompt_password_stdin(size_t *sz)
+static char *prompt_password_stdin(size_t *sz)
 {
-	char *pswd1 = calloc(1, MAX_NT_PWD_LEN + 1);
-	char *pswd2 = calloc(1, MAX_NT_PWD_LEN + 1);
+	char *pw1 = calloc(1, MAX_NT_PWD_LEN + 1);
+	char *pw2 = calloc(1, MAX_NT_PWD_LEN + 1);
 	size_t len = 0;
 	int i;
 
-	if (!pswd1 || !pswd2) {
-		free(pswd1);
-		free(pswd2);
-		pr_err("Out of memory\n");
-		return NULL;
-	}
+	if (!pw1 || !pw2)
+		goto fail;
 
 again:
-	printf("New password: ");
+	pr_out("New password: ");
 	term_toggle_echo(0);
-	if (fgets(pswd1, MAX_NT_PWD_LEN, stdin) == NULL) {
+	if (fgets(pw1, MAX_NT_PWD_LEN, stdin) == NULL) {
 		term_toggle_echo(1);
-		pr_err("\nFatal error: %s\n", strerr(errno));
-		free(pswd1);
-		free(pswd2);
-		return NULL;
+		pr_out("\n");
+		goto fail;
 	}
+	pr_out("\n");
 
-	printf("\nRetype new password: ");
-	if (fgets(pswd2, MAX_NT_PWD_LEN, stdin) == NULL) {
+	pr_out("Retype new password: ");
+	if (fgets(pw2, MAX_NT_PWD_LEN, stdin) == NULL) {
 		term_toggle_echo(1);
-		pr_err("\nFatal error: %s\n", strerr(errno));
-		free(pswd1);
-		free(pswd2);
-		return NULL;
+		pr_out("\n");
+		goto fail;
 	}
 	term_toggle_echo(1);
-	printf("\n");
+	pr_out("\n");
 
-	len = strlen(pswd1);
+	len = strlen(pw1);
 	for (i = 0; i < len; i++)
-		if (pswd1[i] == '\n')
-			pswd1[i] = 0x00;
+		if (pw1[i] == '\n')
+			pw1[i] = 0x00;
 
-	len = strlen(pswd2);
+	len = strlen(pw2);
 	for (i = 0; i < len; i++)
-		if (pswd2[i] == '\n')
-			pswd2[i] = 0x00;
+		if (pw2[i] == '\n')
+			pw2[i] = 0x00;
 
-	if (memcmp(pswd1, pswd2, MAX_NT_PWD_LEN + 1)) {
+	if (memcmp(pw1, pw2, MAX_NT_PWD_LEN + 1)) {
 		pr_err("Passwords don't match\n");
 		goto again;
 	}
 
-	len = strlen(pswd1);
+	len = strlen(pw1);
 	if (len <= 1) {
 		pr_err("No password was provided\n");
 		goto again;
 	}
 
 	*sz = len;
-	free(pswd2);
-	return pswd1;
+	free(pw2);
+	return pw1;
+fail:
+	pr_err("Fatal error: %s\n", strerr(errno));
+	free(pw1);
+	free(pw2);
+	return NULL;
 }
 
-static char *prompt_password(size_t *sz)
+static char *prompt_password(char *password, size_t *len)
 {
-	if (!arg_password)
-		return __prompt_password_stdin(sz);
+	if (!password)
+		return prompt_password_stdin(len);
 
-	*sz = strlen(arg_password);
-	return arg_password;
+	*len = strlen(password);
+	return password;
 }
 
-static char *get_utf8_password(long *len)
+static char *get_utf8_password(char *password, long *len)
 {
 	size_t raw_sz;
-	char *pswd_raw, *pswd_converted;
+	char *pw_raw, *pw_converted;
 	gsize bytes_read = 0;
 	gsize bytes_written = 0;
 
-	pswd_raw = prompt_password(&raw_sz);
-	if (!pswd_raw)
+	pw_raw = prompt_password(password, &raw_sz);
+	if (!pw_raw)
 		return NULL;
 
-	pswd_converted = ksmbd_gconvert(pswd_raw,
+	pw_converted = ksmbd_gconvert(pw_raw,
 					raw_sz,
 					KSMBD_CHARSET_UTF16LE,
 					KSMBD_CHARSET_DEFAULT,
 					&bytes_read,
 					&bytes_written);
-	if (!pswd_converted) {
-		free(pswd_raw);
+	if (!pw_converted) {
+		free(pw_raw);
 		return NULL;
 	}
 
 	*len = bytes_written;
-	free(pswd_raw);
-	return pswd_converted;
+	free(pw_raw);
+	return pw_converted;
 }
 
-static void __sanity_check(char *pswd_hash, char *pswd_b64)
+static void sanity_check_pw(char *pw_hash, char *pw_b64)
 {
-	size_t pass_sz;
-	char *pass = base64_decode(pswd_b64, &pass_sz);
+	size_t len;
+	char *pass = base64_decode(pw_b64, &len);
 
 	if (!pass) {
 		pr_err("Unable to decode NT hash\n");
 		exit(EXIT_FAILURE);
 	}
 
-	if (memcmp(pass, pswd_hash, pass_sz)) {
+	if (memcmp(pass, pw_hash, len)) {
 		pr_err("NT hash encoding error\n");
 		exit(EXIT_FAILURE);
 	}
 	free(pass);
 }
 
-static char *get_hashed_b64_password(void)
+static char *get_hashed_b64_password(char *password)
 {
 	struct md4_ctx mctx;
 	long len;
-	char *pswd_plain, *pswd_hash, *pswd_b64;
+	char *pw_plain, *pw_hash, *pw_b64;
 
-	pswd_plain = get_utf8_password(&len);
-	if (!pswd_plain)
+	pw_plain = get_utf8_password(password, &len);
+	if (!pw_plain)
 		return NULL;
 
-	pswd_hash = calloc(1, sizeof(mctx.hash) + 1);
-	if (!pswd_hash) {
-		free(pswd_plain);
+	pw_hash = calloc(1, sizeof(mctx.hash) + 1);
+	if (!pw_hash) {
+		free(pw_plain);
 		pr_err("Out of memory\n");
 		return NULL;
 	}
 
 	md4_init(&mctx);
-	md4_update(&mctx, pswd_plain, len);
-	md4_final(&mctx, pswd_hash);
+	md4_update(&mctx, pw_plain, len);
+	md4_final(&mctx, pw_hash);
 
-	pswd_b64 = base64_encode(pswd_hash,
+	pw_b64 = base64_encode(pw_hash,
 				 MD4_HASH_WORDS * sizeof(unsigned int));
 
-	__sanity_check(pswd_hash, pswd_b64);
-	free(pswd_plain);
-	free(pswd_hash);
-	return pswd_b64;
+	sanity_check_pw(pw_hash, pw_b64);
+	free(pw_plain);
+	free(pw_hash);
+	return pw_b64;
 }
 
 static void write_user(struct ksmbd_user *user)
@@ -248,7 +247,7 @@ static void write_remove_user_cb(gpointer key,
 {
 	struct ksmbd_user *user = (struct ksmbd_user *)value;
 
-	if (!g_ascii_strcasecmp(user->name, arg_account)) {
+	if (!g_ascii_strcasecmp(user->name, (char *)user_data)) {
 		pr_info("User '%s' removed\n", user->name);
 		return;
 	}
@@ -262,96 +261,91 @@ static void lookup_can_del_user(gpointer key,
 {
 	struct ksmbd_share *share = (struct ksmbd_share *)value;
 	int ret = 0;
-	int *abort_del_user = (int *)user_data;
+	char *account = (char *)user_data;
 
-	if (*abort_del_user)
+	if (!account)
 		return;
 
 	ret = shm_lookup_users_map(share,
 				   KSMBD_SHARE_ADMIN_USERS_MAP,
-				   arg_account);
+				   account);
 	if (ret == 0)
 		goto conflict;
 
 	ret = shm_lookup_users_map(share,
 				   KSMBD_SHARE_WRITE_LIST_MAP,
-				   arg_account);
+				   account);
 	if (ret == 0)
 		goto conflict;
 
 	ret = shm_lookup_users_map(share,
 				   KSMBD_SHARE_VALID_USERS_MAP,
-				   arg_account);
+				   account);
 	if (ret == 0)
 		goto conflict;
 
-	*abort_del_user = 0;
 	return;
 
 conflict:
 	pr_err("Share %s requires user %s to exist\n",
-		share->name, arg_account);
-	*abort_del_user = 1;
+		share->name, account);
+	account = NULL;
 }
 
-int command_add_user(char *pwddb, char *account, char *password)
+int user_add_cmd(char *db, char *account, char *password)
 {
 	struct ksmbd_user *user;
-	char *pswd;
-
-	arg_account = account;
-	arg_password = password;
+	char *pw;
 
-	user = usm_lookup_user(arg_account);
+	user = usm_lookup_user(account);
 	if (user) {
 		put_ksmbd_user(user);
-		pr_err("Account `%s' already exists\n", arg_account);
+		pr_err("Account `%s' already exists\n", account);
 		return -EEXIST;
 	}
 
-	pswd = get_hashed_b64_password();
-	if (!pswd) {
+	pw = get_hashed_b64_password(password);
+	if (!pw) {
 		pr_err("Out of memory\n");
 		return -EINVAL;
 	}
 
-	/* pswd is already g_strdup-ed */
-	if (usm_add_new_user(arg_account, pswd)) {
+	/* pw is already g_strdup-ed */
+	if (usm_add_new_user(account, pw)) {
 		pr_err("Could not add new account\n");
 		return -EINVAL;
 	}
 
-	pr_info("User '%s' added\n", arg_account);
-	if (__opendb_file(pwddb))
+	if (open_db(db, true))
 		return -EINVAL;
 
 	for_each_ksmbd_user(write_user_cb, NULL);
+
+	pr_info("User '%s' added\n", account);
+
 	close(conf_fd);
 	return 0;
 }
 
-int command_update_user(char *pwddb, char *account, char *password)
+int user_update_cmd(char *db, char *account, char *password)
 {
 	struct ksmbd_user *user;
-	char *pswd;
-
-	arg_password = password;
-	arg_account = account;
+	char *pw;
 
-	user = usm_lookup_user(arg_account);
+	user = usm_lookup_user(account);
 	if (!user) {
-		pr_err("Unknown account\n");
+		pr_err("Unknown account \"%s\"\n", account);
 		return -EINVAL;
 	}
 
-	pswd = get_hashed_b64_password();
-	if (!pswd) {
+	pw = get_hashed_b64_password(password);
+	if (!pw) {
 		pr_err("Out of memory\n");
 		put_ksmbd_user(user);
 		return -EINVAL;
 	}
 
-	if (usm_update_user_password(user, pswd)) {
+	if (usm_update_user_password(user, pw)) {
 		pr_err("Out of memory\n");
 		put_ksmbd_user(user);
 		return -ENOMEM;
@@ -359,9 +353,9 @@ int command_update_user(char *pwddb, char *account, char *password)
 
 	pr_info("User '%s' updated\n", account);
 	put_ksmbd_user(user);
-	free(pswd);
+	free(pw);
 
-	if (__opendb_file(pwddb))
+	if (open_db(db, true))
 		return -EINVAL;
 
 	for_each_ksmbd_user(write_user_cb, NULL);
@@ -369,28 +363,47 @@ int command_update_user(char *pwddb, char *account, char *password)
 	return 0;
 }
 
-int command_del_user(char *pwddb, char *account)
+int user_delete_cmd(char *db, char *account)
 {
-	int abort_del_user = 0;
+	char *abort_del_user = strdup(account);
 
-	arg_account = account;
-	if (!cp_key_cmp(global_conf.guest_account, arg_account)) {
+	if (!cp_key_cmp(global_conf.guest_account, account)) {
 		pr_err("User %s is a global guest account. Abort deletion.\n",
-				arg_account);
+				account);
 		return -EINVAL;
 	}
 
-	for_each_ksmbd_share(lookup_can_del_user, &abort_del_user);
+	for_each_ksmbd_share(lookup_can_del_user, abort_del_user);
 
-	if (abort_del_user) {
+	if (!abort_del_user) {
 		pr_err("Aborting user deletion\n");
 		return -EINVAL;
 	}
 
-	if (__opendb_file(pwddb))
+	if (open_db(db, true))
+		return -EINVAL;
+
+	for_each_ksmbd_user(write_remove_user_cb, account);
+	close(conf_fd);
+	return 0;
+}
+
+static void list_users_cb(gpointer key, gpointer value, gpointer data)
+{
+	struct ksmbd_user *user = (struct ksmbd_user *)value;
+
+	pr_out("%s\n", user->name);
+}
+
+int user_list_cmd(char *db)
+{
+	if (open_db(db, false))
 		return -EINVAL;
 
-	for_each_ksmbd_user(write_remove_user_cb, NULL);
+	pr_out("Users in %s:\n", db);
+	for_each_ksmbd_user(list_users_cb, NULL);
+	pr_out("\n");
 	close(conf_fd);
+
 	return 0;
 }
diff --git a/user/user_admin.h b/user/user_admin.h
index 9ff839e846bd..2dfbaa00b6b0 100644
--- a/user/user_admin.h
+++ b/user/user_admin.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
  *
  *   linux-cifsd-devel@lists.sourceforge.net
  */
@@ -8,8 +9,36 @@
 #ifndef __KSMBD_USER_ADMIN_H__
 #define __KSMBD_USER_ADMIN_H__
 
-int command_add_user(char *pwddb, char *account, char *password);
-int command_update_user(char *pwddb, char *account, char *password);
-int command_del_user(char *pwddb, char *account);
+int user_add_cmd(char *db, char *account, char *password);
+int user_delete_cmd(char *db, char *account);
+int user_update_cmd(char *db, char *account, char *password);
+int user_list_cmd(char *db);
+
+typedef enum {
+	KSMBD_CMD_USER_NONE = 0,
+	KSMBD_CMD_USER_ADD,
+	KSMBD_CMD_USER_DELETE,
+	KSMBD_CMD_USER_UPDATE,
+	KSMBD_CMD_USER_LIST,
+	KSMBD_CMD_USER_MAX
+} ksmbd_user_cmd;
+
+/* List of supported subcommands */
+static const char *ksmbd_user_cmds_str[] = {
+	"none",
+	"add",
+	"delete",
+	"update",
+	"list",
+};
+
+static struct option user_opts[] = {
+	{ "password", required_argument, NULL, 'p' },
+	{ "database", required_argument, NULL, 'd' },
+	{ 0, 0, 0, 0 },
+};
+
+void user_usage(ksmbd_user_cmd cmd);
+int user_cmd(int argc, char *argv[]);
 
 #endif /* __KSMBD_USER_ADMIN_H__ */
-- 
2.34.1

