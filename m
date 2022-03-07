Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70728C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiCGBfL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiCGBfJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:09 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF81B13F0F
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8CAA81F38E;
        Mon,  7 Mar 2022 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yppu1R8h359jajMr3n2ZHRnQDxR9TRl0JhDM9sUqZdE=;
        b=HmolPeQYlq09rZXzfehQgy7zCRtWqJVO+WWW/Qi7xEegDt+JRBOUD6e+nEQe57HsEPA1zE
        q+E8piH2B+N6enBrWcUJjvPIDm1s4FHRb1pyCaAXH8ldjlXzkEe5M5hvRQ3wenIUoovdvm
        aV6R+1S6Fr23I4Ol5qhU+/FiIjcQCR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616854;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yppu1R8h359jajMr3n2ZHRnQDxR9TRl0JhDM9sUqZdE=;
        b=PjSLb8EFlBILemqol60ACjAQr/RS8egHMQ1PytZzzrNuMlrY+FpfJrzd89ynmuAxBo9CD9
        99gjBFLQdhagSNAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0CBE21340A;
        Mon,  7 Mar 2022 01:34:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NhgmMBVhJWIWdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:13 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 2/9] ksmbd-tools: move control functions to daemon
Date:   Sun,  6 Mar 2022 22:33:37 -0300
Message-Id: <20220307013344.29064-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move the control functionality to the daemon command.

This commit builds, but doesn't work since the commands will be
implemented in a next patch from this series.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 Makefile.am          |   2 +-
 configure.ac         |   1 -
 control/Makefile.am  |   7 ---
 control/control.c    | 128 -------------------------------------------
 daemon/daemon.c      |  85 +++++++++++++++++++++++++++-
 daemon/daemon.h      |  29 ++++++++++
 include/ksmbdtools.h |   1 +
 lib/ksmbdtools.c     |  24 ++++++++
 8 files changed, 139 insertions(+), 138 deletions(-)
 delete mode 100644 control/Makefile.am
 delete mode 100644 control/control.c
 create mode 100644 daemon/daemon.h

diff --git a/Makefile.am b/Makefile.am
index e3ee928691bf..b4e205895825 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = lib daemon user share control
+SUBDIRS = lib daemon user share
 
 # other stuff
 EXTRA_DIST =			\
diff --git a/configure.ac b/configure.ac
index 1f107805325f..d7ec538cbbf0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -65,7 +65,6 @@ AC_CONFIG_FILES([
 	daemon/Makefile
 	user/Makefile
 	share/Makefile
-	control/Makefile
 ])
 
 AC_OUTPUT
diff --git a/control/Makefile.am b/control/Makefile.am
deleted file mode 100644
index 0b3559ab60ed..000000000000
--- a/control/Makefile.am
+++ /dev/null
@@ -1,7 +0,0 @@
-AM_CFLAGS = -I$(top_srcdir)/include $(GLIB_CFLAGS) $(LIBNL_CFLAGS) -fno-common
-LIBS = $(GLIB_LIBS)
-ksmbd_control_LDADD = $(top_builddir)/lib/libksmbdtools.a
-
-sbin_PROGRAMS = ksmbd.control
-
-ksmbd_control_SOURCES = control.c
diff --git a/control/control.c b/control/control.c
deleted file mode 100644
index 780a48ab9259..000000000000
--- a/control/control.c
+++ /dev/null
@@ -1,128 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *   Copyright (C) 2020 Samsung Electronics Co., Ltd.
- *
- *   linux-cifsd-devel@lists.sourceforge.net
- */
-
-#include <getopt.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include "ksmbdtools.h"
-#include "version.h"
-
-static void usage(void)
-{
-	fprintf(stderr, "Usage: ksmbd.control\n");
-	fprintf(stderr, "\t-s | --shutdown\n");
-	fprintf(stderr, "\t-d | --debug=all or [smb, auth, etc...]\n");
-	fprintf(stderr, "\t-c | --ksmbd-version\n");
-	fprintf(stderr, "\t-V | --version\n");
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
-static int ksmbd_control_shutdown(void)
-{
-	int fd, ret;
-
-	terminate_ksmbd_daemon();
-
-	fd = open("/sys/class/ksmbd-control/kill_server", O_WRONLY);
-	if (fd < 0) {
-		pr_err("open failed: %d\n", errno);
-		return EXIT_FAILURE;
-	}
-
-	ret = write(fd, "hard", 4);
-	close(fd);
-	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
-}
-
-static int ksmbd_control_show_version(void)
-{
-	int fd, ret;
-	char ver[255] = {0};
-
-	fd = open("/sys/module/ksmbd/version", O_RDONLY);
-	if (fd < 0) {
-		pr_err("open failed: %d\n", errno);
-		return EXIT_FAILURE;
-	}
-
-	ret = read(fd, ver, 255);
-	close(fd);
-	if (ret != -1)
-		pr_info("ksmbd version : %s\n", ver);
-	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
-}
-
-static int ksmbd_control_debug(char *comp)
-{
-	int fd, ret;
-	char buf[255] = {0};
-
-	fd = open("/sys/class/ksmbd-control/debug", O_RDWR);
-	if (fd < 0) {
-		pr_err("open failed: %d\n", errno);
-		return EXIT_FAILURE;
-	}
-
-	ret = write(fd, comp, strlen(comp));
-	if (ret < 0)
-		goto out;
-	ret = read(fd, buf, 255);
-	if (ret < 0)
-		goto out;
-
-	pr_info("%s\n", buf);
-out:
-	close(fd);
-	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
-}
-
-int main(int argc, char *argv[])
-{
-	int ret = EXIT_FAILURE;
-	int c;
-
-	set_logger_app_name("ksmbd.control");
-
-	if (getuid() != 0) {
-		pr_err("Please try it as root.\n");
-		return ret;
-	}
-
-	opterr = 0;
-	while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
-		switch (c) {
-		case 's':
-			ret = ksmbd_control_shutdown();
-			break;
-		case 'd':
-			ret = ksmbd_control_debug(optarg);
-			break;
-		case 'c':
-			ret = ksmbd_control_show_version();
-			break;
-		case 'V':
-			show_version();
-			break;
-		case '?':
-		case 'h':
-		default:
-			usage();
-	}
-
-	if (argc < 2)
-		usage();
-
-	return ret;
-}
diff --git a/daemon/daemon.c b/daemon/daemon.c
index a3a683222a92..946f500bc977 100644
--- a/daemon/daemon.c
+++ b/daemon/daemon.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
+ *   Copyright (C) 2021 SUSE LLC
  *
  *   linux-cifsd-devel@lists.sourceforge.net
  */
@@ -13,6 +14,7 @@
 
 #include <stdlib.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <unistd.h>
 #include <getopt.h>
 #include <fcntl.h>
@@ -24,6 +26,7 @@
 #include "ipc.h"
 #include "rpc.h"
 #include "worker.h"
+#include "daemon.h"
 #include "config_parser.h"
 #include "management/user.h"
 #include "management/share.h"
@@ -555,12 +558,92 @@ static struct option opts[] = {
 	{NULL,		0,			NULL,	 0  }
 };
 
+int daemon_shutdown_cmd(void)
+{
+	int fd, ret;
+
+	if (get_running_pid() == -ENOENT) {
+		pr_info("Server is not running.\n");
+		exit(EXIT_FAILURE);
+	}
+
+	terminate_ksmbd_daemon();
+
+	fd = open(KSMBD_SYSFS_KILL_SERVER, O_WRONLY);
+	if (fd < 0) {
+		pr_debug("open failed (%d): %s\n", errno, strerr(errno));
+		return fd;
+	}
+
+	ret = write(fd, "hard", 4);
+	close(fd);
+	return ret;
+}
+
+int daemon_debug_cmd(char *debug_type)
+{
+	int i, fd, ret;
+	bool valid = false;
+	char buf[255] = { 0 };
+
+	for (i = 0; i < ARRAY_SIZE(debug_type_strings); i++) {
+		if (!strcmp(debug_type, debug_type_strings[i])) {
+			valid = true;
+			break;
+		}
+	}
+
+	if (!valid)
+		return -EINVAL;
+
+	ret = fd = open(KSMBD_SYSFS_DEBUG, O_RDWR);
+	if (fd < 0)
+		goto err_open;
+
+	ret = write(fd, debug_type, strlen(debug_type));
+	if (ret < 0)
+		goto err;
+
+	ret = read(fd, buf, 255);
+	if (ret < 0)
+		goto err;
+
+	pr_info("debug: %s\n", buf);
+err:
+	close(fd);
+err_open:
+	if (ret == -EBADF)
+		pr_debug("Can't open %s. Is ksmbd kernel module loaded?\n");
+	return ret;
+}
+
+int daemon_version_cmd(void)
+{
+	int fd, ret;
+	char version[255] = { 0 };
+
+	ret = fd = open(KSMBD_SYSFS_VERSION, O_RDONLY);
+	if (fd < 0)
+		goto err;
+
+	ret = read(fd, version, 255);
+	close(fd);
+
+err:
+	if (ret < 0)
+		pr_err("%s. Is kernel module loaded?\n", strerr(errno));
+	else
+		pr_info("ksmbd module version: %s\n", version);
+
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int systemd_service = 0;
 	int c;
 
-	set_logger_app_name("ksmbd.mountd");
+	set_logger_app_name("ksmbd.daemon");
 	memset(&global_conf, 0x00, sizeof(struct smbconf_global));
 	global_conf.pwddb = PATH_PWDDB;
 	global_conf.smbconf = PATH_SMBCONF;
diff --git a/daemon/daemon.h b/daemon/daemon.h
new file mode 100644
index 000000000000..ca064b2b732d
--- /dev/null
+++ b/daemon/daemon.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2021 SUSE LLC
+ *
+ *   linux-cifsd-devel@lists.sourceforge.net
+ */
+
+#ifndef __DAEMON_H__
+#define __DAEMON_H__
+
+#define KSMBD_SYSFS_KILL_SERVER "/sys/class/ksmbd-control/kill_server"
+#define KSMBD_SYSFS_DEBUG	"/sys/class/ksmbd-control/debug"
+#define KSMBD_SYSFS_VERSION	"/sys/module/ksmbd/version"
+
+static const char * const debug_type_strings[] = {
+	"all", "smb", "auth", "vfs", "oplock", "ipc", "conn", "rdma"
+};
+
+static struct option daemon_opts[] = {
+	{ "port", required_argument, NULL, 'p' },
+	{ "config", required_argument, NULL, 'c' },
+	{ "usersdb", required_argument, NULL, 'u' },
+	{ "nodetach", no_argument, NULL, 'n' },
+	{ "systemd", no_argument, NULL, 's' },
+	{ "help", no_argument, NULL, 'h' },
+	{ 0, 0, 0, 0 },
+};
+
+#endif /* __DAEMON_H__ */
diff --git a/include/ksmbdtools.h b/include/ksmbdtools.h
index c51673e0253f..170ce23ead2c 100644
--- a/include/ksmbdtools.h
+++ b/include/ksmbdtools.h
@@ -168,6 +168,7 @@ enum charset_idx {
 
 extern char *ksmbd_conv_charsets[KSMBD_CHARSET_MAX + 1];
 
+int get_running_pid(void);
 void notify_ksmbd_daemon(void);
 void terminate_ksmbd_daemon(void);
 int test_file_access(char *conf);
diff --git a/lib/ksmbdtools.c b/lib/ksmbdtools.c
index 91d82946f6d6..b636f34af98e 100644
--- a/lib/ksmbdtools.c
+++ b/lib/ksmbdtools.c
@@ -255,6 +255,30 @@ void terminate_ksmbd_daemon(void)
 	send_signal_to_ksmbd_daemon(SIGTERM);
 }
 
+int get_running_pid(void)
+{
+	char daemon_pid[10] = { 0 };
+	pid_t pid = 0;
+	int fd;
+
+	fd = open(KSMBD_LOCK_FILE, O_RDONLY);
+	if (fd < 0) {
+		pr_info("Can't open lock file %s: %s\n", KSMBD_LOCK_FILE, strerr(errno));
+		return -ENOENT;
+	}
+
+	if (read(fd, &daemon_pid, sizeof(daemon_pid)) == -1) {
+		pr_err("Unable to read lock file: %s\n", strerr(errno));
+		close(fd);
+		return -EINVAL;
+	}
+
+	close(fd);
+	pid = strtol(daemon_pid, NULL, 10);
+
+	return pid;
+}
+
 int test_file_access(char *conf)
 {
 	int fd = open(conf, O_RDWR | O_CREAT, S_IRWXU | S_IRGRP);
-- 
2.34.1

