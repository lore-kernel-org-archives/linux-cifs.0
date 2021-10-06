Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA09C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6337D61166
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhJFQP1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:15:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36732 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhJFQP1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 12:15:27 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3C17122572;
        Wed,  6 Oct 2021 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633536814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2iZJWiOKCYBsm4m1UBOUt95anK0h0bkAT5tBF/Bhf0g=;
        b=Uhd5xoLoCjizQpUbGZMkW+4J89S1tdx3qzYqiTkNIr5G50RNGQycZh5NZShF/pnPyalne6
        zr8ASNAp8qDhhuG/yvwvw1ZSWDoZV4n3NEeE9xobja4/mbnnp+7OHnJy5BjjJu+/VzT8ef
        eR/eo/7Idry/yIgpH6aAbTafUmrDjQw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633536814;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=2iZJWiOKCYBsm4m1UBOUt95anK0h0bkAT5tBF/Bhf0g=;
        b=QdMeTrvCz6lrEC93P8Y+++NRe4++wA9Ttkv0qtIXk71wEzp0g0O23UbW1ltiETww/rku3z
        S/6jn5DPvlp9p1Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C4C5113E55;
        Wed,  6 Oct 2021 16:13:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FD/mIy3LXWHdOQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 06 Oct 2021 16:13:33 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org
Subject: [PATCH] ksmbd-tools: change default db file name to users.db
Date:   Wed,  6 Oct 2021 13:13:31 -0300
Message-Id: <20211006161331.4510-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This commit changes the default file name for the users database from
/etc/ksmbd/ksmbdpwd.db to /etc/ksmbd/users.db, which is more reasonable
and makes more sense for end users.

Also rename some variables and functions that dealt with this file.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 adduser/adduser.c       | 20 ++++++++++----------
 adduser/user_admin.c    | 20 ++++++++++----------
 include/config_parser.h |  2 +-
 include/ksmbdtools.h    |  4 ++--
 lib/config_parser.c     |  4 ++--
 mountd/ipc.c            |  6 +++---
 mountd/mountd.c         | 14 +++++++-------
 7 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/adduser/adduser.c b/adduser/adduser.c
index 54774d3d6e15..e4d17460b4c9 100644
--- a/adduser/adduser.c
+++ b/adduser/adduser.c
@@ -56,15 +56,15 @@ static void show_version(void)
 	exit(EXIT_FAILURE);
 }
 
-static int parse_configs(char *pwddb)
+static int parse_configs(char *db)
 {
 	int ret;
 
-	ret = test_file_access(pwddb);
+	ret = test_file_access(db);
 	if (ret)
 		return ret;
 
-	ret = cp_parse_pwddb(pwddb);
+	ret = cp_parse_db(db);
 	if (ret)
 		return ret;
 	return 0;
@@ -97,7 +97,7 @@ static int sanity_check_user_name_simple(char *uname)
 int main(int argc, char *argv[])
 {
 	int ret = EXIT_FAILURE;
-	char *pwddb = PATH_PWDDB;
+	char *db = PATH_USERS_DB;
 	int c, cmd = 0;
 
 	set_logger_app_name("smbuseradd");
@@ -121,7 +121,7 @@ int main(int argc, char *argv[])
 			arg_password = g_strdup(optarg);
 			break;
 		case 'i':
-			pwddb = g_strdup(optarg);
+			db = g_strdup(optarg);
 			break;
 		case 'V':
 			show_version();
@@ -139,7 +139,7 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	if (!pwddb) {
+	if (!db) {
 		pr_err("Out of memory\n");
 		goto out;
 	}
@@ -156,18 +156,18 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	ret = parse_configs(pwddb);
+	ret = parse_configs(db);
 	if (ret) {
 		pr_err("Unable to parse configuration files\n");
 		goto out;
 	}
 
 	if (cmd == COMMAND_ADD_USER)
-		ret = command_add_user(pwddb, arg_account, arg_password);
+		ret = command_add_user(db, arg_account, arg_password);
 	if (cmd == COMMAND_DEL_USER)
-		ret = command_del_user(pwddb, arg_account);
+		ret = command_del_user(db, arg_account);
 	if (cmd == COMMAND_UPDATE_USER)
-		ret = command_update_user(pwddb, arg_account, arg_password);
+		ret = command_update_user(db, arg_account, arg_password);
 
 	/*
 	 * We support only ADD_USER command at this moment
diff --git a/adduser/user_admin.c b/adduser/user_admin.c
index 7ea1d43c3540..df1315292bac 100644
--- a/adduser/user_admin.c
+++ b/adduser/user_admin.c
@@ -31,16 +31,16 @@ static char *arg_password = NULL;
 static int conf_fd = -1;
 static char wbuf[2 * MAX_NT_PWD_LEN + 2 * KSMBD_REQ_MAX_ACCOUNT_NAME_SZ];
 
-static int __opendb_file(char *pwddb)
+static int open_db_file(char *db)
 {
-	conf_fd = open(pwddb, O_WRONLY);
+	conf_fd = open(db, O_WRONLY);
 	if (conf_fd == -1) {
-		pr_err("%s %s\n", strerr(errno), pwddb);
+		pr_err("%s %s\n", strerr(errno), db);
 		return -EINVAL;
 	}
 
 	if (ftruncate(conf_fd, 0)) {
-		pr_err("%s %s\n", strerr(errno), pwddb);
+		pr_err("%s %s\n", strerr(errno), db);
 		close(conf_fd);
 		return -EINVAL;
 	}
@@ -295,7 +295,7 @@ conflict:
 	*abort_del_user = 1;
 }
 
-int command_add_user(char *pwddb, char *account, char *password)
+int command_add_user(char *db, char *account, char *password)
 {
 	struct ksmbd_user *user;
 	char *pswd;
@@ -323,7 +323,7 @@ int command_add_user(char *pwddb, char *account, char *password)
 	}
 
 	pr_info("User '%s' added\n", arg_account);
-	if (__opendb_file(pwddb))
+	if (open_db_file(db))
 		return -EINVAL;
 
 	for_each_ksmbd_user(write_user_cb, NULL);
@@ -331,7 +331,7 @@ int command_add_user(char *pwddb, char *account, char *password)
 	return 0;
 }
 
-int command_update_user(char *pwddb, char *account, char *password)
+int command_update_user(char *db, char *account, char *password)
 {
 	struct ksmbd_user *user;
 	char *pswd;
@@ -362,7 +362,7 @@ int command_update_user(char *pwddb, char *account, char *password)
 	put_ksmbd_user(user);
 	free(pswd);
 
-	if (__opendb_file(pwddb))
+	if (open_db_file(db))
 		return -EINVAL;
 
 	for_each_ksmbd_user(write_user_cb, NULL);
@@ -370,7 +370,7 @@ int command_update_user(char *pwddb, char *account, char *password)
 	return 0;
 }
 
-int command_del_user(char *pwddb, char *account)
+int command_del_user(char *db, char *account)
 {
 	int abort_del_user = 0;
 
@@ -388,7 +388,7 @@ int command_del_user(char *pwddb, char *account)
 		return -EINVAL;
 	}
 
-	if (__opendb_file(pwddb))
+	if (open_db_file(db))
 		return -EINVAL;
 
 	for_each_ksmbd_user(write_remove_user_cb, NULL);
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
index 5a1236878613..2d55fefdffed 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -56,7 +56,7 @@ struct smbconf_global {
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
 	char			*krb5_service_name;
-	char			*pwddb;
+	char			*users_db;
 	char			*smbconf;
 };
 
@@ -84,7 +84,7 @@ extern struct smbconf_global global_conf;
 
 #define KSMBD_CONF_FILE_MAX		10000
 
-#define PATH_PWDDB	"/etc/ksmbd/ksmbdpwd.db"
+#define PATH_USERS_DB	"/etc/ksmbd/users.db"
 #define PATH_SMBCONF	"/etc/ksmbd/smb.conf"
 
 #define KSMBD_HEALTH_START		(0)
diff --git a/lib/config_parser.c b/lib/config_parser.c
index ebbe2dd4e69f..da82a95955f3 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -674,9 +674,9 @@ int cp_parse_smbconf(const char *smbconf)
 				    GROUPS_CALLBACK_STARTUP_INIT);
 }
 
-int cp_parse_pwddb(const char *pwddb)
+int cp_parse_db(const char *db)
 {
-	return __mmap_parse_file(pwddb, usm_add_update_user_from_pwdentry);
+	return __mmap_parse_file(db, usm_add_update_user_from_pwdentry);
 }
 
 int cp_smbconfig_hash_create(const char *smbconf)
diff --git a/mountd/ipc.c b/mountd/ipc.c
index 15c59f5aa850..be2b6a2c3fed 100644
--- a/mountd/ipc.c
+++ b/mountd/ipc.c
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
+		parse_reload_configs(global_conf.users_db, global_conf.smbconf);
 		ksmbd_health_status &= ~KSMBD_SHOULD_RELOAD_CONFIG;
 	}
 
diff --git a/mountd/mountd.c b/mountd/mountd.c
index 71a4d985d5a9..2476f62d0355 100644
--- a/mountd/mountd.c
+++ b/mountd/mountd.c
@@ -44,7 +44,7 @@ static void usage(void)
 	fprintf(stderr, "Usage: ksmbd\n");
 	fprintf(stderr, "\t--p=NUM | --port=NUM              TCP port NUM\n");
 	fprintf(stderr, "\t--c=smb.conf | --config=smb.conf  config file\n");
-	fprintf(stderr, "\t--u=pwd.db | --users=pwd.db       Users DB\n");
+	fprintf(stderr, "\t--u=users.db | --users=users.db   Users DB\n");
 	fprintf(stderr, "\t--n | --nodetach                  Don't detach\n");
 	fprintf(stderr, "\t--s | --systemd                   Service mode\n");
 	fprintf(stderr, "\t-V | --version                    Show version\n");
@@ -288,11 +288,11 @@ static int setup_signals(sighandler_t handler)
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
@@ -392,7 +392,7 @@ static int worker_process_init(void)
 		goto out;
 	}
 
-	ret = parse_configs(global_conf.pwddb, global_conf.smbconf);
+	ret = parse_configs(global_conf.users_db, global_conf.smbconf);
 	if (ret) {
 		pr_err("Failed to parse configuration files\n");
 		goto out;
@@ -562,7 +562,7 @@ int main(int argc, char *argv[])
 
 	set_logger_app_name("ksmbd-manager");
 	memset(&global_conf, 0x00, sizeof(struct smbconf_global));
-	global_conf.pwddb = PATH_PWDDB;
+	global_conf.users_db = PATH_USERS_DB;
 	global_conf.smbconf = PATH_SMBCONF;
 	pr_logger_init(PR_LOGGER_STDIO);
 
@@ -586,7 +586,7 @@ int main(int argc, char *argv[])
 			global_conf.smbconf = g_strdup(optarg);
 			break;
 		case 'u':
-			global_conf.pwddb = g_strdup(optarg);
+			global_conf.users_db = g_strdup(optarg);
 			break;
 		case 'n':
 			if (!optarg)
@@ -611,7 +611,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!global_conf.smbconf || !global_conf.pwddb) {
+	if (!global_conf.smbconf || !global_conf.users_db) {
 		pr_err("Out of memory\n");
 		exit(EXIT_FAILURE);
 	}
-- 
2.33.0

