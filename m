Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5EAC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiCGBf0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiCGBfY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:24 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2903DDE6
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DCD2C1F38F;
        Mon,  7 Mar 2022 01:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywfGlXuHZ9XWWs8WcbJUjWUpDhVOl7/dd652PCmxuu8=;
        b=JIXirxw21fha+1jfXGwTe8lo5MkgzXF/gvMy1W2PFw52mKBc5zUkEp4A1aM6foAYfBMVwz
        uoszPNAY2G9wNItVVfcoHy3c4fimlJguSNs2VT5KDZ1K/55UtPLlB2BcxMncyAUGyiVnia
        BEhe73K93FF3hRqcFPB3QbVXMKxC3CU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616868;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywfGlXuHZ9XWWs8WcbJUjWUpDhVOl7/dd652PCmxuu8=;
        b=e5oMXtITe5oFMC/fati9xuXdMfEbPKWukFBNUHzRymrCkwyS1xsouIO3jHOjxc+1vEunaS
        hgoYJQIWRpcAedDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29B081340A;
        Mon,  7 Mar 2022 01:34:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Xb3nNyNhJWI0dAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:27 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 6/9] daemon: introduce daemon_cmd
Date:   Sun,  6 Mar 2022 22:33:41 -0300
Message-Id: <20220307013344.29064-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Implement and improve daemon management commands.

Sets the forked process name to "ksmbd-daemon".

Rename some variables and functions to something more meaningful.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 daemon/daemon.c      | 320 ++++++++++++++++++++++++++++---------------
 daemon/daemon.h      |  26 ++++
 daemon/ipc.c         |   9 +-
 daemon/rpc.c         |   6 +-
 daemon/worker.c      |  13 +-
 include/ksmbdtools.h |   2 +-
 6 files changed, 248 insertions(+), 128 deletions(-)

diff --git a/daemon/daemon.c b/daemon/daemon.c
index 50afbd2ed70d..533b2bf9de0f 100644
--- a/daemon/daemon.c
+++ b/daemon/daemon.c
@@ -6,7 +6,7 @@
  *   linux-cifsd-devel@lists.sourceforge.net
  */
 
-#include <ksmbdtools.h>
+#include "ksmbdtools.h"
 
 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE
@@ -20,6 +20,7 @@
 #include <fcntl.h>
 #include <sys/file.h>
 #include <sys/types.h>
+#include <sys/prctl.h>
 #include <sys/wait.h>
 #include <signal.h>
 
@@ -35,53 +36,85 @@
 #include "management/spnego.h"
 #include "version.h"
 
-static int no_detach = 0;
 int ksmbd_health_status;
 static pid_t worker_pid;
 static int lock_fd = -1;
 
-typedef int (*worker_fn)(void);
+typedef int (*worker_fn)(void *);
 
-static void usage(void)
+static ksmbd_daemon_cmd ksmbd_daemon_get_cmd(char *cmd)
 {
-	fprintf(stderr, "Usage: ksmbd\n");
-	fprintf(stderr, "\t--p=NUM | --port=NUM              TCP port NUM\n");
-	fprintf(stderr, "\t--c=smb.conf | --config=smb.conf  config file\n");
-	fprintf(stderr, "\t--u=pwd.db | --users=pwd.db       Users DB\n");
-	fprintf(stderr, "\t--n | --nodetach                  Don't detach\n");
-	fprintf(stderr, "\t--s | --systemd                   Service mode\n");
-	fprintf(stderr, "\t-V | --version                    Show version\n");
-	fprintf(stderr, "\t-h | --help                       Show help\n");
+	int i;
 
-	exit(EXIT_FAILURE);
+	if (!cmd)
+		return KSMBD_CMD_DAEMON_NONE;
+
+	for (i = 0; i < KSMBD_CMD_DAEMON_MAX; i++)
+		if (!strcmp(cmd, ksmbd_daemon_cmds_str[i]))
+			return (ksmbd_daemon_cmd)i;
+
+	return KSMBD_CMD_DAEMON_NONE;
+}
+
+static const char *ksmbd_daemon_get_cmd_str(ksmbd_daemon_cmd cmd)
+{
+	if (cmd > KSMBD_CMD_DAEMON_MAX)
+		return ksmbd_daemon_cmds_str[KSMBD_CMD_DAEMON_NONE];
+
+	return ksmbd_daemon_cmds_str[(int)cmd];
 }
 
-static void show_version(void)
+void daemon_usage(ksmbd_daemon_cmd cmd)
 {
-	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
+	const char *cmd_str = ksmbd_daemon_get_cmd_str(cmd);
+	int i;
+
+	switch(cmd) {
+	case KSMBD_CMD_DAEMON_START:
+		pr_out("Usage: ksmbdctl daemon start [options]\n");
+		pr_out("Start ksmbd userspace and kernel daemon.\n\n");
+		pr_out("%-30s%s", "  -p, --port=<num>", "TCP port number to listen on\n");
+		pr_out("%-30s%s", "  -c, --config=<config>", "Use specified smb.conf file\n");
+		pr_out("%-30s%s", "  -u, --usersdb=<config>", "Use specified users DB file\n");
+		pr_out("%-30s%s", "  -n, --nodetach", "Don't detach\n");
+		pr_out("%-30s%s", "  -s, --systemd", "Start daemon in systemd service mode\n");
+		pr_out("%-30s%s", "  -h, --help", "Show this help menu\n\n");
+		break;
+	case KSMBD_CMD_DAEMON_SHUTDOWN:
+		pr_out("Usage: ksmbdctl daemon shutdown\n");
+		pr_out("Shuts down the userspace daemon and the kernel server.\n\n");
+		break;
+	case KSMBD_CMD_DAEMON_DEBUG:
+		pr_out("Usage: ksmbdctl daemon debug <type>\n");
+		pr_out("Enable/disable debugging modules for ksmbd.\n\n");
+		pr_out("List of available types:\n");
+		for (i = 0; i < ARRAY_SIZE(debug_type_strings); i++)
+			pr_out("%s ", debug_type_strings[i]);
+		pr_out("\n\n");
+		break;
+	default:
+		pr_out("Usage: ksmbdctl daemon <subcommand> <args> [options]\n");
+		pr_out("ksmbd daemon management.\n\n");
+		pr_out("List of available subcommands:\n");
+		pr_out("%-20s%s", "start", "Start ksmbd userspace daemon\n");
+		pr_out("%-20s%s", "shutdown", "Shutdown ksmbd userspace daemon\n");
+		pr_out("%-20s%s", "debug", "Enable/disable debugging for ksmbd components\n\n");
+		break;
+	}
+
 	exit(EXIT_FAILURE);
 }
 
 static int handle_orphaned_lock_file(void)
 {
-	char proc_ent[64] = {0, };
-	char manager_pid[10] = {0, };
-	int pid = 0;
+	char proc_ent[64] = { 0 };
+	pid_t pid;
 	int fd;
 
-	fd = open(KSMBD_LOCK_FILE, O_RDONLY);
-	if (fd < 0)
+	pid = get_running_pid();
+	if (pid < 0)
 		return -EINVAL;
 
-	if (read(fd, &manager_pid, sizeof(manager_pid)) == -1) {
-		pr_debug("Unable to read main PID: %s\n", strerr(errno));
-		close(fd);
-		return -EINVAL;
-	}
-
-	close(fd);
-
-	pid = strtol(manager_pid, NULL, 10);
 	snprintf(proc_ent, sizeof(proc_ent), "/proc/%d", pid);
 	fd = open(proc_ent, O_RDONLY);
 	if (fd < 0) {
@@ -91,17 +124,19 @@ static int handle_orphaned_lock_file(void)
 
 	close(fd);
 	pr_info("File '%s' belongs to pid %d\n", KSMBD_LOCK_FILE, pid);
+
 	return -EINVAL;
 }
 
 static int create_lock_file(void)
 {
-	char manager_pid[10];
-	size_t sz;
+	char daemon_pid[10];
+	size_t len;
 
 retry:
 	lock_fd = open(KSMBD_LOCK_FILE, O_CREAT | O_EXCL | O_WRONLY,
 			S_IWUSR | S_IRUSR | S_IRGRP | S_IROTH);
+
 	if (lock_fd < 0) {
 		if (handle_orphaned_lock_file())
 			return -EINVAL;
@@ -111,9 +146,10 @@ retry:
 	if (flock(lock_fd, LOCK_EX | LOCK_NB) != 0)
 		return -EINVAL;
 
-	sz = snprintf(manager_pid, sizeof(manager_pid), "%d", getpid());
-	if (write(lock_fd, manager_pid, sz) == -1)
+	len = snprintf(daemon_pid, sizeof(daemon_pid), "%d", getpid());
+	if (write(lock_fd, daemon_pid, len) == -1)
 		pr_err("Unable to record main PID: %s\n", strerr(errno));
+
 	return 0;
 }
 
@@ -147,7 +183,7 @@ char *make_path_subauth(void)
  * Avoids a corrupt file if the write would be interrupted due
  * to a power failure.
  */
-static int write_file_safe(char *path, char *buff, size_t length, int mode)
+static int write_file_safe(char *path, char *buff, size_t len, int mode)
 {
 	int fd, ret = -1;
 	char *path_tmp = g_strdup_printf("%s.tmp", path);
@@ -161,7 +197,7 @@ static int write_file_safe(char *path, char *buff, size_t length, int mode)
 		goto err_out;
 	}
 
-	if (write(fd, buff, length) == -1) {
+	if (write(fd, buff, len) == -1) {
 		pr_err("Unable to write to %s: %s\n", path_tmp, strerr(errno));
 		close(fd);
 		goto err_out;
@@ -204,9 +240,8 @@ static int generate_sub_auth(void)
 	if (!path_subauth)
 		return -ENOMEM;
 retry:
-	if (g_file_test(path_subauth, G_FILE_TEST_EXISTS)) {
+	if (g_file_test(path_subauth, G_FILE_TEST_EXISTS))
 		rc = cp_parse_subauth(path_subauth);
-	}
 
 	if (rc < 0) {
 		rc = create_subauth_file(path_subauth);
@@ -238,14 +273,14 @@ static int wait_group_kill(int signo)
 	int status;
 
 	if (kill(worker_pid, signo) != 0)
-		pr_err("can't execute kill %d: %s\n",
+		pr_warn("can't execute kill %d: %s\n",
 			worker_pid,
 			strerr(errno));
 
 	while (1) {
 		pid = waitpid(-1, &status, 0);
 		if (pid != 0) {
-			pr_debug("detected pid %d termination\n", pid);
+			pr_debug("Detected pid %d termination\n", pid);
 			break;
 		}
 		sleep(1);
@@ -297,16 +332,16 @@ static int parse_configs(char *db, char *smbconf)
 
 	ret = cp_parse_db(db);
 	if (ret == -ENOENT) {
-		pr_err("User database file does not exist. %s\n",
+		pr_warn("User database file does not exist. %s\n",
 			"Only guest sessions (if permitted) will work.");
 	} else if (ret) {
-		pr_err("Unable to parse user database\n");
+		pr_err("Unable to parse user database %s\n", db);
 		return ret;
 	}
 
 	ret = cp_parse_smbconf(smbconf);
 	if (ret) {
-		pr_err("Unable to parse smb configuration file\n");
+		pr_err("Unable to parse configuration file %s\n", smbconf);
 		return ret;
 	}
 	return 0;
@@ -353,7 +388,7 @@ static void child_sig_handler(int signo)
 	exit(EXIT_SUCCESS);
 }
 
-static void manager_sig_handler(int signo)
+static void daemon_sig_handler(int signo)
 {
 	/*
 	 * Pass SIGHUP to worker, so it will reload configs
@@ -376,7 +411,7 @@ static void manager_sig_handler(int signo)
 	kill(0, SIGINT);
 }
 
-static int worker_process_init(void)
+static int worker_process_init(void *data)
 {
 	int ret;
 
@@ -395,7 +430,7 @@ static int worker_process_init(void)
 		goto out;
 	}
 
-	ret = parse_configs(global_conf.db, global_conf.smbconf);
+	ret = parse_configs(global_conf.users_db, global_conf.smbconf);
 	if (ret) {
 		pr_err("Failed to parse configuration files\n");
 		goto out;
@@ -444,32 +479,40 @@ out:
 	return ret;
 }
 
-static pid_t start_worker_process(worker_fn fn)
+static pid_t start_worker_process(worker_fn fn, void *data)
 {
 	int status = 0;
-	pid_t __pid;
+	pid_t pid;
 
-	__pid = fork();
-	if (__pid < 0) {
+	pid = fork();
+	if (pid < 0) {
 		pr_err("Can't fork child process: `%s'\n", strerr(errno));
 		return -EINVAL;
 	}
-	if (__pid == 0) {
-		status = fn();
+	if (pid == 0) {
+		status = fn(data);
 		exit(status);
 	}
-	return __pid;
+
+	return pid;
 }
 
-static int manager_process_init(void)
+static int daemon_process_start(void *data)
 {
+	int no_detach;
 	/*
 	 * Do not chdir() daemon()'d process to '/'.
 	 */
 	int nochdir = 1;
 
-	setup_signals(manager_sig_handler);
-	if (no_detach == 0) {
+	if(prctl(PR_SET_NAME, "ksmbd-daemon\0", 0, 0, 0))
+		pr_info("Can't set program name: %s\n", strerr(errno));
+
+	if (data)
+		no_detach = *(int *)data;
+
+	setup_signals(daemon_sig_handler);
+	if (!no_detach) {
 		pr_logger_init(PR_LOGGER_SYSLOG);
 		if (daemon(nochdir, 0) != 0) {
 			pr_err("Daemonization failed\n");
@@ -481,7 +524,7 @@ static int manager_process_init(void)
 		 * the group leader already then the function will do
 		 * nothing (apart from setting errnor to EPERM).
 		 */
-		if (no_detach == 1)
+		if (no_detach)
 			setsid();
 	}
 
@@ -494,7 +537,7 @@ static int manager_process_init(void)
 		pr_debug("Failed to generate subauth for domain sid: %s\n",
 				strerr(errno));
 
-	worker_pid = start_worker_process(worker_process_init);
+	worker_pid = start_worker_process(worker_process_init, NULL);
 	if (worker_pid < 0)
 		goto out;
 
@@ -509,8 +552,7 @@ static int manager_process_init(void)
 			continue;
 		}
 
-		pr_err("WARNING: child process exited abnormally: %d\n",
-				child);
+		pr_warn("child process exited abnormally: %d\n", child);
 		if (child == -1) {
 			pr_err("waitpid() returned error code: %s\n",
 				strerr(errno));
@@ -525,7 +567,7 @@ static int manager_process_init(void)
 
 		/* Ratelimit automatic restarts */
 		sleep(1);
-		worker_pid = start_worker_process(worker_process_init);
+		worker_pid = start_worker_process(worker_process_init, NULL);
 		if (worker_pid < 0)
 			goto out;
 	}
@@ -535,35 +577,34 @@ out:
 	return 0;
 }
 
-static int manager_systemd_service(void)
+int daemon_start_cmd(int no_detach, int systemd_service)
 {
-	pid_t __pid;
+	pid_t pid;
+	int ret = -EINVAL;
+
+	/* Check if process is already running */
+	pid = get_running_pid();
+	if (pid > 1) {
+		pr_err("ksmbd-daemon already running (%d)\n", pid);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!systemd_service)
+		return daemon_process_start((void *)&no_detach);
 
-	__pid = start_worker_process(manager_process_init);
-	if (__pid < 0)
+	pid = start_worker_process(daemon_process_start, (void *)&no_detach);
+	if (pid < 0)
 		return -EINVAL;
 
 	return 0;
 }
 
-static struct option opts[] = {
-	{"port",	required_argument,	NULL,	'p' },
-	{"config",	required_argument,	NULL,	'c' },
-	{"users",	required_argument,	NULL,	'u' },
-	{"systemd",	no_argument,		NULL,	's' },
-	{"nodetach",	optional_argument,	NULL,	'n' },
-	{"help",	no_argument,		NULL,	'h' },
-	{"?",		no_argument,		NULL,	'?' },
-	{"version",	no_argument,		NULL,	'V' },
-	{NULL,		0,			NULL,	 0  }
-};
-
 int daemon_shutdown_cmd(void)
 {
 	int fd, ret;
 
 	if (get_running_pid() == -ENOENT) {
-		pr_info("Server is not running.\n");
+		pr_out("Server is not running.\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -613,7 +654,7 @@ err:
 	close(fd);
 err_open:
 	if (ret == -EBADF)
-		pr_debug("Can't open %s. Is ksmbd kernel module loaded?\n");
+		pr_debug("Can't open %s. Is ksmbd kernel module loaded?\n", KSMBD_SYSFS_DEBUG);
 	return ret;
 }
 
@@ -633,74 +674,125 @@ err:
 	if (ret < 0)
 		pr_err("%s. Is kernel module loaded?\n", strerr(errno));
 	else
-		pr_info("ksmbd module version: %s\n", version);
+		pr_out("ksmbd module version: %s\n", version);
 
 	return ret;
 }
 
-int main(int argc, char *argv[])
+int daemon_cmd(int argc, char *argv[])
 {
+	int ret = EXIT_FAILURE;
+	int no_detach = 0;
 	int systemd_service = 0;
-	int c;
+	char *debug_type;
+	const char *cmd_str;
+	ksmbd_daemon_cmd cmd = KSMBD_CMD_DAEMON_NONE;
+	int c, i;
+
+	if (argc < 2)
+		goto usage;
+
+	set_logger_app_name("ksmbd-daemon");
+
+	cmd = ksmbd_daemon_get_cmd(argv[1]);
+	cmd_str = ksmbd_daemon_get_cmd_str(cmd);
+
+	if (cmd == KSMBD_CMD_DAEMON_NONE)
+		goto usage;
+
+	if (cmd == KSMBD_CMD_DAEMON_VERSION ||
+	    cmd == KSMBD_CMD_DAEMON_SHUTDOWN)
+		goto skip_opts;
+
+	if (cmd == KSMBD_CMD_DAEMON_DEBUG) {
+		if (argc == 2)
+			goto usage;
+
+		debug_type = strdup(argv[2]);
+
+		ret = daemon_debug_cmd(debug_type);
+		if (ret == -EINVAL) {
+			pr_out("Invalid debug type \"%s\"\n\n", debug_type);
+			pr_out("List of available types:\n");
+			for (i = 0; i < ARRAY_SIZE(debug_type_strings); i++)
+				pr_out("%s ", debug_type_strings[i]);
+			pr_out("\n\n");
+		} else if (ret < 0) {
+			pr_out("Error enabling/disabling ksmbd debug\n");
+		}
+
+		free(debug_type);
+		return ret;
+	}
 
-	set_logger_app_name("ksmbd.daemon");
 	memset(&global_conf, 0x00, sizeof(struct smbconf_global));
-	global_conf.db = PATH_USERS_DB;
+	global_conf.users_db = PATH_USERS_DB;
 	global_conf.smbconf = PATH_SMBCONF;
-	pr_logger_init(PR_LOGGER_STDIO);
 
-	opterr = 0;
-	while (1) {
-		c = getopt_long(argc, argv, "n::p:c:u:sVh", opts, NULL);
-
-		if (c < 0)
-			break;
+	pr_logger_init(PR_LOGGER_STDIO);
 
-		switch (c) {
-		case 0: /* getopt_long() set a variable, just keep going */
-			break;
+	optind = 1;
+	while ((c = getopt_long(argc, argv, "-:p:c:u:nsh", daemon_opts, NULL)) != EOF)
+		switch(c) {
 		case 1:
 			break;
 		case 'p':
 			global_conf.tcp_port = cp_get_group_kv_long(optarg);
-			pr_debug("TCP port option override\n");
+			pr_info("Overriding TCP port to %hu\n", global_conf.tcp_port);
 			break;
 		case 'c':
 			global_conf.smbconf = g_strdup(optarg);
+			if (!global_conf.smbconf)
+				goto oom;
 			break;
 		case 'u':
-			global_conf.db = g_strdup(optarg);
+			global_conf.users_db = g_strdup(optarg);
+			if (!global_conf.users_db)
+				goto oom;
 			break;
 		case 'n':
-			if (!optarg)
-				no_detach = 1;
-			else
-				no_detach = cp_get_group_kv_long(optarg);
+			no_detach = 1;
 			break;
 		case 's':
 			systemd_service = 1;
 			break;
-		case 'V':
-			show_version();
-			break;
 		case ':':
-			pr_err("Missing option argument\n");
-			/* Fall through */
 		case '?':
 		case 'h':
-			/* Fall through */
 		default:
-			usage();
+			goto usage;
 		}
-	}
 
-	if (!global_conf.smbconf || !global_conf.db) {
-		pr_err("Out of memory\n");
-		exit(EXIT_FAILURE);
+skip_opts:
+	switch (cmd) {
+	case KSMBD_CMD_DAEMON_START:
+		setup_signals(daemon_sig_handler);
+		ret = daemon_start_cmd(no_detach, systemd_service);
+		if (ret != 0) {
+			pr_err("Error starting daemon\n");
+			exit(EXIT_FAILURE);
+		}
+		break;
+	case KSMBD_CMD_DAEMON_SHUTDOWN:
+		ret = daemon_shutdown_cmd();
+		if (ret < 0) {
+			pr_err("Error shutting down server. Is ksmbd kernel module loaded?\n");
+			exit(EXIT_FAILURE);
+		}
+		pr_out("Server was shut down.\n");
+		break;
+	case KSMBD_CMD_DAEMON_VERSION:
+		ret = daemon_version_cmd();
+		break;
 	}
 
-	setup_signals(manager_sig_handler);
-	if (!systemd_service)
-		return manager_process_init();
-	return manager_systemd_service();
+	return ret;
+
+usage:
+	daemon_usage(cmd);
+	exit(EXIT_FAILURE);
+oom:
+	pr_err("Out of memory\n");
+	ret = -ENOMEM;
+	return ret;
 }
diff --git a/daemon/daemon.h b/daemon/daemon.h
index ca064b2b732d..7cfedc100e56 100644
--- a/daemon/daemon.h
+++ b/daemon/daemon.h
@@ -12,10 +12,33 @@
 #define KSMBD_SYSFS_DEBUG	"/sys/class/ksmbd-control/debug"
 #define KSMBD_SYSFS_VERSION	"/sys/module/ksmbd/version"
 
+int daemon_start_cmd(int no_detach, int systemd_service);
+int daemon_shutdown_cmd(void);
+int daemon_debug_cmd(char *debug_type);
+int daemon_version_cmd(void);
+
+typedef enum {
+	KSMBD_CMD_DAEMON_NONE = 0,
+	KSMBD_CMD_DAEMON_START,
+	KSMBD_CMD_DAEMON_SHUTDOWN,
+	KSMBD_CMD_DAEMON_DEBUG,
+	KSMBD_CMD_DAEMON_VERSION,
+	KSMBD_CMD_DAEMON_MAX
+} ksmbd_daemon_cmd;
+
 static const char * const debug_type_strings[] = {
 	"all", "smb", "auth", "vfs", "oplock", "ipc", "conn", "rdma"
 };
 
+/* List of supported subcommands */
+static const char *ksmbd_daemon_cmds_str[] ={
+	"none",
+	"start",
+	"shutdown",
+	"debug",
+	"version",
+};
+
 static struct option daemon_opts[] = {
 	{ "port", required_argument, NULL, 'p' },
 	{ "config", required_argument, NULL, 'c' },
@@ -26,4 +49,7 @@ static struct option daemon_opts[] = {
 	{ 0, 0, 0, 0 },
 };
 
+void daemon_usage(ksmbd_daemon_cmd cmd);
+int daemon_cmd(int argc, char *argv[]);
+
 #endif /* __DAEMON_H__ */
diff --git a/daemon/ipc.c b/daemon/ipc.c
index b793a1e101b0..a5ff31dcb7b0 100644
--- a/daemon/ipc.c
+++ b/daemon/ipc.c
@@ -31,6 +31,7 @@ struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
 	struct ksmbd_ipc_msg *msg;
 	size_t msg_sz = sz + sizeof(struct ksmbd_ipc_msg) + 1;
 
+	/* FIXME: shouldn't we fail here? */
 	if (msg_sz > KSMBD_IPC_MAX_MESSAGE_SIZE)
 		pr_err("IPC message is too large: %zu\n", msg_sz);
 
@@ -71,7 +72,7 @@ static int parse_reload_configs(const char *db, const char *smbconf)
 	usm_remove_all_users();
 	ret = cp_parse_db(db);
 	if (ret == -ENOENT) {
-		pr_err("User database file does not exist. %s\n",
+		pr_warn("User database file does not exist. %s\n",
 		       "Only guest sessions (if permitted) will work.");
 	} else if (ret) {
 		pr_err("Unable to parse user database\n");
@@ -91,7 +92,7 @@ static int handle_generic_event(struct nl_cache_ops *unused,
 				void *arg)
 {
 	if (ksmbd_health_status & KSMBD_SHOULD_RELOAD_CONFIG) {
-		parse_reload_configs(global_conf.db, global_conf.smbconf);
+		parse_reload_configs(global_conf.users_db, global_conf.smbconf);
 		ksmbd_health_status &= ~KSMBD_SHOULD_RELOAD_CONFIG;
 	}
 
@@ -108,7 +109,7 @@ static int nlink_msg_cb(struct nl_msg *msg, void *arg)
 	struct genlmsghdr *gnlh = genlmsg_hdr(nlmsg_hdr(msg));
 
 	if (gnlh->version != KSMBD_GENL_VERSION) {
-		pr_err("IPC message version mistamtch: %d\n", gnlh->version);
+		pr_err("IPC message version mismatch: %d\n", gnlh->version);
 		return NL_SKIP;
 	}
 
@@ -124,7 +125,7 @@ static int handle_unsupported_event(struct nl_cache_ops *unused,
 				    struct genl_info *info,
 				    void *arg)
 {
-	pr_err("Unsupported IPC event %d, ignore.\n", cmd->c_id);
+	pr_warn("Unsupported IPC event %d, ignore.\n", cmd->c_id);
 	return NL_SKIP;
 }
 
diff --git a/daemon/rpc.c b/daemon/rpc.c
index ab2a7c6dfebe..0dbbbe6e9be7 100644
--- a/daemon/rpc.c
+++ b/daemon/rpc.c
@@ -588,7 +588,7 @@ static int __max_entries(struct ksmbd_dcerpc *dce, struct ksmbd_rpc_pipe *pipe)
 		return pipe->num_entries;
 
 	if (!dce->entry_size) {
-		pr_err("No ->entry_size() callback was provided\n");
+		pr_warn("No ->entry_size() callback was provided\n");
 		return pipe->num_entries;
 	}
 
@@ -1135,7 +1135,7 @@ int rpc_write_request(struct ksmbd_rpc_command *req,
 		return KSMBD_RPC_OK;
 
 	if (pipe->num_entries)
-		pr_err("RPC: A call on unflushed pipe. Pending %d\n",
+		pr_warn("RPC: A call on unflushed pipe. Pending %d\n",
 			pipe->num_entries);
 
 	dce = pipe->dce;
@@ -1208,6 +1208,6 @@ int rpc_close_request(struct ksmbd_rpc_command *req,
 		return 0;
 	}
 
-	pr_err("RPC: unknown pipe ID: %d\n", req->handle);
+	pr_warn("RPC: unknown pipe ID: %d\n", req->handle);
 	return KSMBD_RPC_OK;
 }
diff --git a/daemon/worker.c b/daemon/worker.c
index 0ddd88cea12c..eb9e646d4985 100644
--- a/daemon/worker.c
+++ b/daemon/worker.c
@@ -329,16 +329,17 @@ int wp_init(void)
 				 MAX_WORKER_THREADS,
 				 0,
 				 &err);
-	if (!pool) {
-		if (err) {
-			pr_err("Can't create pool: %s\n", err->message);
-			g_error_free(err);
-		}
+	if (!pool)
 		goto out_error;
-	}
 
 	return 0;
+
 out_error:
+	if (err) {
+		pr_err("Can't create pool: %s\n", err->message);
+		g_error_free(err);
+	}
+
 	wp_destroy();
 	return -ENOMEM;
 }
diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index 978cbe148eac..c9831c16596a 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -57,7 +57,7 @@ struct smbconf_global {
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
 	char			*krb5_service_name;
-	char			*db;
+	char			*users_db;
 	char			*smbconf;
 };
 
-- 
2.34.1

