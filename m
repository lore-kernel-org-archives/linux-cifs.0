Return-Path: <SRS0=BDHi=EC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA9CC56202
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 10:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E359321D24
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 10:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897393AbgJ0KIb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Oct 2020 06:08:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:59534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897384AbgJ0KIa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 27 Oct 2020 06:08:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0D8BAD0D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2020 10:08:28 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH v2 03/11] cifs: Register generic netlink family
Date:   Tue, 27 Oct 2020 11:07:59 +0100
Message-Id: <20201027100807.21510-4-scabrero@suse.de>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201027100807.21510-1-scabrero@suse.de>
References: <20201027100807.21510-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Register a new generic netlink family to talk to the witness service
userspace daemon.

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/Kconfig                        | 11 +++++
 fs/cifs/Makefile                       |  2 +
 fs/cifs/cifsfs.c                       | 17 ++++++-
 fs/cifs/netlink.c                      | 68 ++++++++++++++++++++++++++
 fs/cifs/netlink.h                      | 16 ++++++
 include/uapi/linux/cifs/cifs_netlink.h | 31 ++++++++++++
 6 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 fs/cifs/netlink.c
 create mode 100644 fs/cifs/netlink.h
 create mode 100644 include/uapi/linux/cifs/cifs_netlink.h

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 604f65f4b6c5..664ac5c63d39 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -190,6 +190,17 @@ config CIFS_DFS_UPCALL
 	  servers if their addresses change or for implicit mounts of
 	  DFS junction points. If unsure, say Y.
 
+config CIFS_SWN_UPCALL
+	bool "SWN feature support"
+	depends on CIFS
+	help
+	  The Service Witness Protocol (SWN) is used to get notifications
+	  from a highly available server of resource state changes. This
+	  feature enables an upcall mechanism for CIFS which contacts an
+	  userspace daemon to establish the DCE/RPC connection to retrieve
+	  the cluster available interfaces and resource change notifications.
+	  If unsure, say Y.
+
 config CIFS_NFSD_EXPORT
 	bool "Allow nfsd to export CIFS file system"
 	depends on CIFS && BROKEN
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index cd17d0e50f2a..b88fd46ac597 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -18,6 +18,8 @@ cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
 
 cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o dfs_cache.o
 
+cifs-$(CONFIG_CIFS_SWN_UPCALL) += netlink.o
+
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 472cb7777e3e..8111d0109a2e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -55,6 +55,9 @@
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
+#ifdef CONFIG_CIFS_SWN_UPCALL
+#include "netlink.h"
+#endif
 
 /*
  * DOS dates from 1980/1/1 through 2107/12/31
@@ -1617,10 +1620,15 @@ init_cifs(void)
 	if (rc)
 		goto out_destroy_dfs_cache;
 #endif /* CONFIG_CIFS_UPCALL */
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	rc = cifs_genl_init();
+	if (rc)
+		goto out_register_key_type;
+#endif /* CONFIG_CIFS_SWN_UPCALL */
 
 	rc = init_cifs_idmap();
 	if (rc)
-		goto out_register_key_type;
+		goto out_cifs_swn_init;
 
 	rc = register_filesystem(&cifs_fs_type);
 	if (rc)
@@ -1636,7 +1644,11 @@ init_cifs(void)
 
 out_init_cifs_idmap:
 	exit_cifs_idmap();
+out_cifs_swn_init:
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	cifs_genl_exit();
 out_register_key_type:
+#endif
 #ifdef CONFIG_CIFS_UPCALL
 	exit_cifs_spnego();
 out_destroy_dfs_cache:
@@ -1673,6 +1685,9 @@ exit_cifs(void)
 	unregister_filesystem(&smb3_fs_type);
 	cifs_dfs_release_automount_timer();
 	exit_cifs_idmap();
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	cifs_genl_exit();
+#endif
 #ifdef CONFIG_CIFS_UPCALL
 	exit_cifs_spnego();
 #endif
diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
new file mode 100644
index 000000000000..5cd5dfee1132
--- /dev/null
+++ b/fs/cifs/netlink.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Netlink routines for CIFS
+ *
+ * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
+ */
+
+#include <net/genetlink.h>
+#include <uapi/linux/cifs/cifs_netlink.h>
+
+#include "cifsglob.h"
+#include "cifs_debug.h"
+
+static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
+};
+
+static struct genl_ops cifs_genl_ops[] = {
+};
+
+static const struct genl_multicast_group cifs_genl_mcgrps[] = {
+	[CIFS_GENL_MCGRP_SWN] = { .name = CIFS_GENL_MCGRP_SWN_NAME },
+};
+
+struct genl_family cifs_genl_family = {
+	.name		= CIFS_GENL_NAME,
+	.version	= CIFS_GENL_VERSION,
+	.hdrsize	= 0,
+	.maxattr	= CIFS_GENL_ATTR_MAX,
+	.module		= THIS_MODULE,
+	.policy		= cifs_genl_policy,
+	.ops		= cifs_genl_ops,
+	.n_ops		= ARRAY_SIZE(cifs_genl_ops),
+	.mcgrps		= cifs_genl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(cifs_genl_mcgrps),
+};
+
+/**
+ * cifs_genl_init - Register generic netlink family
+ *
+ * Return zero if initialized successfully, otherwise non-zero.
+ */
+int cifs_genl_init(void)
+{
+	int ret;
+
+	ret = genl_register_family(&cifs_genl_family);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: failed to register netlink family\n",
+				__func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * cifs_genl_exit - Unregister generic netlink family
+ */
+void cifs_genl_exit(void)
+{
+	int ret;
+
+	ret = genl_unregister_family(&cifs_genl_family);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: failed to unregister netlink family\n",
+				__func__);
+	}
+}
diff --git a/fs/cifs/netlink.h b/fs/cifs/netlink.h
new file mode 100644
index 000000000000..e2fa8ed24c54
--- /dev/null
+++ b/fs/cifs/netlink.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Netlink routines for CIFS
+ *
+ * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
+ */
+
+#ifndef _CIFS_NETLINK_H
+#define _CIFS_NETLINK_H
+
+extern struct genl_family cifs_genl_family;
+
+extern int cifs_genl_init(void);
+extern void cifs_genl_exit(void);
+
+#endif /* _CIFS_NETLINK_H */
diff --git a/include/uapi/linux/cifs/cifs_netlink.h b/include/uapi/linux/cifs/cifs_netlink.h
new file mode 100644
index 000000000000..cdb1bd78fbc7
--- /dev/null
+++ b/include/uapi/linux/cifs/cifs_netlink.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: LGPL-2.1+ WITH Linux-syscall-note */
+/*
+ * Netlink routines for CIFS
+ *
+ * Copyright (c) 2020 Samuel Cabrero <scabrero@suse.de>
+ */
+
+
+#ifndef _UAPILINUX_CIFS_NETLINK_H
+#define _UAPILINUX_CIFS_NETLINK_H
+
+#define CIFS_GENL_NAME			"cifs"
+#define CIFS_GENL_VERSION		0x1
+
+#define CIFS_GENL_MCGRP_SWN_NAME	"cifs_mcgrp_swn"
+
+enum cifs_genl_multicast_groups {
+	CIFS_GENL_MCGRP_SWN,
+};
+
+enum cifs_genl_attributes {
+	__CIFS_GENL_ATTR_MAX,
+};
+#define CIFS_GENL_ATTR_MAX (__CIFS_GENL_ATTR_MAX - 1)
+
+enum cifs_genl_commands {
+	__CIFS_GENL_CMD_MAX
+};
+#define CIFS_GENL_CMD_MAX (__CIFS_GENL_CMD_MAX - 1)
+
+#endif /* _UAPILINUX_CIFS_NETLINK_H */
-- 
2.29.0

