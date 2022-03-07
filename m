Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F04C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiCGBfb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiCGBfa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBEB5D5C8
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:37 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C2F9A1F38E;
        Mon,  7 Mar 2022 01:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pfW+RsNzUdaCfNn5wJgoXJ9e1veQxuzr1kVald3OfRo=;
        b=uvbMzMDHjh7z2uWA97XqHT2mA3NudPDmUbZ47k2C/kXa5hZM9J8rwak4elWox/mkY8qfUT
        6VNEvq5k8BQfu8izoatCgd37ggsfWov6um3oWU7PljnNjNI+U/ZlHpsxWcV0mrPhnJDMR6
        EZgD4QKkbe78O/KoybVDTh7L+qxOO+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616875;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pfW+RsNzUdaCfNn5wJgoXJ9e1veQxuzr1kVald3OfRo=;
        b=UTHulVHK0KBpWWlEP6bFngKM8kONGXZYhARXbDKAimBDzx8Vm33lYeMnlyoNRPe3SNUUAM
        J1pHMxQ0kZZJiaCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E6FD1340A;
        Mon,  7 Mar 2022 01:34:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0C+SOyphJWJGdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:34 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 8/9] Unify all programs into a single binary "ksmbdctl"
Date:   Sun,  6 Mar 2022 22:33:43 -0300
Message-Id: <20220307013344.29064-9-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This commit unifies all existing programs
(ksmbd.{adduser,addshare,control,mountd}) into a single ksmbdctl binary.

The intention is to make it more like other modern tools (e.g. git,
nvme, virsh, etc) which have more clear user interface, readable
commands, and also makes it easier to script.

Example commands:
  # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
  # ksmbdctl user add myuser
  # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
  # ksmbdctl daemon start

Besides adding a new "share list" command, any previously working
functionality shouldn't be affected.

Basic testing was done manually.

TODO:
- run more complex tests in more complex environments
- implement unit tests (for each command and subcommand)
- create an abstract command interface, to make it easier to add/modify
  commands

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 Makefile.am |  14 +++-
 ksmbdctl.c  | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+), 1 deletion(-)
 create mode 100644 ksmbdctl.c

diff --git a/Makefile.am b/Makefile.am
index b4e205895825..8059a360605b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,19 @@
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = lib daemon user share
+SUBDIRS = lib
+AM_CFLAGS = -Iinclude $(GLIB_CFLAGS) $(LIBNL_CFLAGS) -fno-common
+LIBS = $(GLIB_LIBS) $(LIBNL_LIBS) $(LIBKRB5_LIBS)
+ksmbdctl_LDADD = lib/libksmbdtools.a
+
+sbin_PROGRAMS = ksmbdctl
+
+ksmbdctl_SOURCES = share/share_admin.c share/share.c share/share_admin.h \
+		   ksmbdctl.c user/md4_hash.c user/user_admin.c user/user.c \
+		   user/md4_hash.h user/user_admin.h daemon/worker.c \
+		   daemon/ipc.c daemon/rpc.c  daemon/rpc_srvsvc.c \
+		   daemon/rpc_wkssvc.c daemon/daemon.c daemon/smbacl.c \
+		   daemon/rpc_samr.c daemon/rpc_lsarpc.c
 
 # other stuff
 EXTRA_DIST =			\
diff --git a/ksmbdctl.c b/ksmbdctl.c
new file mode 100644
index 000000000000..04e7cd7170fb
--- /dev/null
+++ b/ksmbdctl.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2021 SUSE LLC
+ *   Author: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ *   linux-cifsd-devel@lists.sourceforge.net
+ */
+
+#include <glib.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdbool.h>
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
+#include "share/share_admin.h"
+#include "user/user_admin.h"
+#include "daemon/daemon.h"
+#include "version.h"
+
+typedef enum {
+       KSMBD_CMD_NONE = 0,
+       KSMBD_CMD_SHARE,
+       KSMBD_CMD_USER,
+       KSMBD_CMD_DAEMON,
+       KSMBD_CMD_VERSION,
+       KSMBD_CMD_HELP,
+       KSMBD_CMD_MAX
+} ksmbd_cmd;
+
+/* List of supported commands */
+static const char *ksmbd_cmds_str[] = {
+       "none",
+       "share",
+       "user",
+       "daemon",
+       "version",
+       "help"
+};
+
+static ksmbd_cmd ksmbd_get_cmd(char *cmd)
+{
+       int i;
+
+       if (!cmd)
+               return KSMBD_CMD_NONE;
+
+       for (i = 1; i < KSMBD_CMD_MAX; i++)
+               if (!strcmp(cmd, ksmbd_cmds_str[i]))
+                       return (ksmbd_cmd)i;
+
+       return KSMBD_CMD_NONE;
+}
+
+static const char *ksmbd_get_cmd_str(ksmbd_cmd cmd)
+{
+       return ksmbd_cmds_str[(int)cmd];
+}
+
+ksmbd_cmd get_cmd_type(char *cmd)
+{
+       int i;
+
+       if (!cmd)
+               return KSMBD_CMD_NONE;
+
+       for (i = 1; i < KSMBD_CMD_MAX; i++)
+               if (!strcmp(cmd, ksmbd_cmds_str[i]))
+                       return i;
+
+       return KSMBD_CMD_NONE;
+}
+
+static void version(void)
+{
+	pr_out("ksmbd-tools version: %s\n", KSMBD_TOOLS_VERSION);
+}
+
+static void usage(ksmbd_cmd cmd)
+{
+	version();
+
+	switch (cmd) {
+	case KSMBD_CMD_SHARE:
+		share_usage(0);
+		break;
+	case KSMBD_CMD_USER:
+		user_usage(0);
+		break;
+	case KSMBD_CMD_DAEMON:
+		daemon_usage(0);
+		break;
+	case KSMBD_CMD_HELP:
+	default:
+		pr_out("Usage: ksmbdctl [-v] <command> [<option>] <args>\n\n");
+		pr_out("%-20s%s", "  -v", "Enable verbose output. Use -vv or -vvv for more verbose.\n\n");
+		pr_out("List of available commands:\n");
+		pr_out("%-20s%s", "  share", "Manage ksmbd shares\n");
+		pr_out("%-20s%s", "  user", "Manage ksmbd users\n");
+		pr_out("%-20s%s", "  daemon", "Manage ksmbd daemon\n");
+		pr_out("%-20s%s", "  version", "Show ksmbd version\n");
+		pr_out("%-20s%s", "  help", "Show this help menu\n\n");
+		break;
+	}
+
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = EXIT_FAILURE;
+	int cmd_argc, c;
+	char **cmd_argv;
+	int verbosity = 0;
+
+	if (geteuid() != 0) {
+		pr_out("You need to be root to run this program.\n");
+		return ret;
+	}
+
+	if (argc < 2)
+		usage(KSMBD_CMD_NONE);
+
+	while ((c = getopt(argc, argv, "-:v")) != EOF)
+		switch (c) {
+		case 'v':
+			verbosity++;
+			break;
+		case 1:
+			goto out_opt;
+			break;
+		case '?':
+		default:
+			usage(KSMBD_CMD_NONE);
+			break;
+		}
+
+out_opt:
+	log_level = verbosity > PR_DEBUG ? PR_DEBUG : verbosity;
+
+	/* check cmd */
+	ksmbd_cmd cmd = get_cmd_type(argv[optind-1]);
+
+	/* strip "ksmbdctl" from argv/argc */
+	cmd_argc = argc - 1;
+	if (verbosity)
+		cmd_argc--;
+
+	cmd_argv = &argv[optind-1];
+
+	switch (cmd) {
+	case KSMBD_CMD_SHARE:
+		ret = share_cmd(cmd_argc, cmd_argv);
+		break;
+	case KSMBD_CMD_USER:
+		ret = user_cmd(cmd_argc, cmd_argv);
+		break;
+	case KSMBD_CMD_DAEMON:
+		ret = daemon_cmd(cmd_argc, cmd_argv);
+		break;
+	case KSMBD_CMD_VERSION:
+		version();
+		break;
+	case KSMBD_CMD_HELP:
+	case KSMBD_CMD_NONE:
+	default:
+		usage(KSMBD_CMD_NONE);
+		break;
+	}
+
+	return ret;
+}
-- 
2.34.1

