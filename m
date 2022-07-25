Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AEBC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 15:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiGYP2r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 11:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiGYP2q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 11:28:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88141DECA
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 08:28:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3FB3034AF7;
        Mon, 25 Jul 2022 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658762923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Z2RCSUUCitpOBnkW0Bebcw7hpxixXOuBUiVmvta+pgk=;
        b=KNcq/Si+bJFpXJTGEPSutcZd0iTa07FPGaLTj1Qo0ZYnFqqerOOz5MN6ENc6A/p4xGdBN7
        ByVzcZEwDWQMUYtl+85Eu43GxtzQyXut3vJN0tVREAileI0GXRRqL1P7dJDH7uQ8C6V03P
        0aOgc30PkNfCFgaOFIT1UfEb6ze7O64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658762923;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Z2RCSUUCitpOBnkW0Bebcw7hpxixXOuBUiVmvta+pgk=;
        b=x3Na/nXS9vn5iE+j1Ok+qAaKFmasfWWW5DSeEZse6zbM1PVwdl/Z2vpB5G0lULsVrUgdiW
        8ng8a/aX+8LZrZDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 805D213ABB;
        Mon, 25 Jul 2022 15:28:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id w+B4Eaq23mJ1MgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 15:28:42 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2] cifs: split procfs from debug code
Date:   Mon, 25 Jul 2022 12:27:35 -0300
Message-Id: <20220725152734.15778-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Leave debugging helpers/functions in debug.h, and create a proc.c file
for procfs specifics.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2: Fix unused variable warnings and undefined symbol errors when
    CONFIG_CIFS_DEBUG is disabled, identified by kernel test robot.

 fs/cifs/Makefile                  |   2 +-
 fs/cifs/asn1.c                    |   2 +-
 fs/cifs/cifs_dfs_ref.c            |   2 +-
 fs/cifs/cifs_spnego.c             |   2 +-
 fs/cifs/cifs_swn.c                |   4 +-
 fs/cifs/cifs_unicode.c            |   2 +-
 fs/cifs/cifsacl.c                 |   2 +-
 fs/cifs/cifsencrypt.c             |   2 +-
 fs/cifs/cifsfs.c                  |   2 +-
 fs/cifs/cifssmb.c                 |   2 +-
 fs/cifs/connect.c                 |   2 +-
 fs/cifs/{cifs_debug.h => debug.h} | 106 +++++++++++++++++-----------
 fs/cifs/dfs_cache.c               |   2 +-
 fs/cifs/dir.c                     |   2 +-
 fs/cifs/dns_resolve.c             |   2 +-
 fs/cifs/export.c                  |   2 +-
 fs/cifs/file.c                    |   2 +-
 fs/cifs/fs_context.c              |   2 +-
 fs/cifs/fscache.c                 |   2 +-
 fs/cifs/inode.c                   |   2 +-
 fs/cifs/ioctl.c                   |   2 +-
 fs/cifs/link.c                    |   2 +-
 fs/cifs/misc.c                    |   6 +-
 fs/cifs/netlink.c                 |   2 +-
 fs/cifs/netmisc.c                 |   2 +-
 fs/cifs/{cifs_debug.c => proc.c}  | 111 ++++++------------------------
 fs/cifs/readdir.c                 |   2 +-
 fs/cifs/sess.c                    |  15 ++--
 fs/cifs/smb1ops.c                 |   2 +-
 fs/cifs/smb2file.c                |   2 +-
 fs/cifs/smb2inode.c               |   2 +-
 fs/cifs/smb2maperror.c            |   2 +-
 fs/cifs/smb2misc.c                |   2 +-
 fs/cifs/smb2ops.c                 |   2 +-
 fs/cifs/smb2pdu.c                 |   2 +-
 fs/cifs/smb2transport.c           |   2 +-
 fs/cifs/smbdirect.c               |   2 +-
 fs/cifs/smbencrypt.c              |   2 +-
 fs/cifs/transport.c               |   2 +-
 fs/cifs/xattr.c                   |   2 +-
 40 files changed, 137 insertions(+), 175 deletions(-)
 rename fs/cifs/{cifs_debug.h => debug.h} (62%)
 rename fs/cifs/{cifs_debug.c => proc.c} (92%)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 8c9f2c00be72..13a69a7ab43b 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -5,7 +5,7 @@
 ccflags-y += -I$(src)		# needed for trace events
 obj-$(CONFIG_CIFS) += cifs.o
 
-cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
+cifs-y := trace.o cifsfs.o cifssmb.o proc.o connect.o dir.o file.o \
 	  inode.o link.o misc.o netmisc.o smbencrypt.o transport.o \
 	  cifs_unicode.o nterr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o unc.o winucase.o \
diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index b5724ef9f182..40c3afe657ae 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/oid_registry.h>
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsproto.h"
 #include "cifs_spnego_negtokeninit.asn1.h"
 
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b0864da9ef43..4ff9c72c81f6 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -20,7 +20,7 @@
 #include "cifsproto.h"
 #include "cifsfs.h"
 #include "dns_resolve.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_unicode.h"
 #include "dfs_cache.h"
 #include "fs_context.h"
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 342717bf1dc2..4bbdd8a431e9 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -16,7 +16,7 @@
 #include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifs_spnego.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsproto.h"
 static const struct cred *spnego_cred;
 
diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 1e4c7cc5287f..ca3539eb9926 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -13,7 +13,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "fscache.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "netlink.h"
 
 static DEFINE_IDR(cifs_swnreg_idr);
@@ -508,6 +508,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 
 static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
 {
+#ifdef CONFIG_CIFS_DEBUG
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
 
@@ -515,6 +516,7 @@ static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_sto
 		cifs_dbg(FYI, "%s: move to %pI4\n", __func__, &ipv4->sin_addr);
 	else if (addr->ss_family == AF_INET6)
 		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
+#endif /* CONFIG_CIFS_DEBUG */
 
 	return cifs_swn_reconnect(swnreg->tcon, addr);
 }
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index e7582dd79179..1470a7ab1b95 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -11,7 +11,7 @@
 #include "cifs_uniupr.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 
 int cifs_remap(struct cifs_sb_info *cifs_sb)
 {
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bf861fef2f0c..a602c67c78c6 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -18,7 +18,7 @@
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "fs_context.h"
 
 /* security id for everyone/world system group */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 663cb9db4908..fc268e8112b1 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_unicode.h"
 #include "cifsproto.h"
 #include "ntlmssp.h"
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f909d9e9faaa..9cad86ddd54c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -33,7 +33,7 @@
 #define DECLARE_GLOBALS_HERE
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include <linux/mm.h>
 #include <linux/key-type.h>
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9ed21752f2df..b1ecd48680ee 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -28,7 +28,7 @@
 #include "cifsacl.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "smb2proto.h"
 #include "fscache.h"
 #include "smbdirect.h"
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6e670e7c2182..76766e347137 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -36,7 +36,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "ntlmssp.h"
 #include "nterr.h"
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/debug.h
similarity index 62%
rename from fs/cifs/cifs_debug.h
rename to fs/cifs/debug.h
index ee4ea2b60c0f..aff677b8e3f4 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/debug.h
@@ -5,20 +5,15 @@
  *   Modified by Steve French (sfrench@us.ibm.com)
  */
 
-#ifndef _H_CIFS_DEBUG
-#define _H_CIFS_DEBUG
+#ifndef _CIFS_DEBUG_H
+#define _CIFS_DEBUG_H
 
-#ifdef pr_fmt
 #undef pr_fmt
-#endif
-
 #define pr_fmt(fmt) "CIFS: " fmt
 
-void cifs_dump_mem(char *label, void *data, int length);
-void cifs_dump_detail(void *buf, struct TCP_Server_Info *ptcp_info);
-void cifs_dump_mids(struct TCP_Server_Info *);
-extern bool traceSMB;		/* flag which enables the function below */
+extern bool traceSMB; /* flag which enables the function below */
 void dump_smb(void *, int);
+
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
@@ -34,12 +29,9 @@ extern int cifsFYI;
 #define ONCE 8
 
 /*
- *	debug ON
- *	--------
+ * debug ON
  */
 #ifdef CONFIG_CIFS_DEBUG
-
-
 /*
  * When adding tracepoints and debug messages we have various choices.
  * Some considerations:
@@ -128,33 +120,67 @@ do {									\
 		cifs_tcon_dbg_func(ratelimited, type, fmt,		\
 				   ##__VA_ARGS__);			\
 } while (0)
-
+#else /* CONFIG_CIFS_DEBUG */
 /*
- *	debug OFF
- *	---------
+ * debug OFF
  */
-#else		/* _CIFS_DEBUG */
-#define cifs_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug(fmt, ##__VA_ARGS__);				\
-} while (0)
-
-#define cifs_server_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug("\\\\%s " fmt,					\
-			 server->hostname, ##__VA_ARGS__);		\
-} while (0)
-
-#define cifs_tcon_dbg(type, fmt, ...)					\
-do {									\
-	if (0)								\
-		pr_debug("%s " fmt, tcon->treeName, ##__VA_ARGS__);	\
-} while (0)
-
-#define cifs_info(fmt, ...)						\
-	pr_info(fmt, ##__VA_ARGS__)
-#endif
+#define cifs_dbg(type, fmt, ...)
+#define cifs_server_dbg(type, fmt, ...)
+#define cifs_tcon_dbg(type, fmt, ...)
+#define cifs_info(fmt, ...) pr_info(fmt, ##__VA_ARGS__)
+#endif /* CONFIG_CIFS_DEBUG */
 
-#endif				/* _H_CIFS_DEBUG */
+/*
+ * helpers
+ */
+static inline void cifs_dump_mem(char *label, void *data, int length)
+{
+	pr_debug("%s: dump of %d bytes of data at 0x%p\n", label, length, data);
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4, data, length, true);
+}
+
+static inline void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
+{
+#ifdef CONFIG_CIFS_DEBUG2
+	struct smb_hdr *smb = buf;
+	unsigned int len = server->ops->calc_smb_size(smb, server);
+
+	cifs_dbg(VFS, "Cmd: %d, Err: 0x%x, Flags: 0x%x, Flags2: 0x%x, Mid: %d, "
+		 "Pid: %d\n", smb->Command, smb->Status.CifsError, smb->Flags,
+		 smb->Flags2, smb->Mid, smb->Pid);
+	cifs_dbg(VFS, "smb buf: %p, len: %u\n", smb, len);
+#endif /* CONFIG_CIFS_DEBUG2 */
+}
+
+static inline void cifs_dump_mids(struct TCP_Server_Info *server)
+{
+#ifdef CONFIG_CIFS_DEBUG2
+	struct mid_q_entry *mid_entry;
+
+	if (server == NULL)
+		return;
+
+	cifs_dbg(VFS, "Dump pending requests:\n");
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+		cifs_dbg(VFS, "state: %d, cmd: %d, pid: %d, cbdata: %p, "
+			 "mid %llu\n", mid_entry->mid_state,
+			 le16_to_cpu(mid_entry->command), mid_entry->pid,
+			 mid_entry->callback_data, mid_entry->mid);
+#ifdef CONFIG_CIFS_STATS2
+		cifs_dbg(VFS, "is large_buf: %d, buf: %p, time rcv: %ld, "
+			 "now: %ld\n", mid_entry->large_buf, mid_entry->resp_buf,
+			 mid_entry->when_received, jiffies);
+#endif /* STATS2 */
+		cifs_dbg(VFS, "is multiRsp: %d, is multiEnd: %d\n",
+			 mid_entry->multiRsp, mid_entry->multiEnd);
+		if (mid_entry->resp_buf) {
+			cifs_dump_detail(mid_entry->resp_buf, server);
+			/* XXX: give a name to "62"? */
+			cifs_dump_mem("existing buf: ", mid_entry->resp_buf, 62);
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+#endif /* CONFIG_CIFS_DEBUG2 */
+}
+#endif /* _CIFS_DEBUG_H */
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 34a8f3baed5e..f3382851e6b3 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -16,7 +16,7 @@
 #include "smb2pdu.h"
 #include "smb2proto.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_unicode.h"
 #include "smb2glob.h"
 #include "dns_resolve.h"
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ce9b22aecfba..5d0de5e2216e 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -17,7 +17,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 0458d28d71aa..20acc0628b5b 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -17,7 +17,7 @@
 #include "dns_resolve.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 
 /**
  * dns_resolve_server_name_to_ip - Resolve UNC server name to ip address.
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 37c28415df1e..0b8a0d2de3eb 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -29,7 +29,7 @@
 #include <linux/fs.h>
 #include <linux/exportfs.h>
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsfs.h"
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 967663ad63a0..9cc0b063a60a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -27,7 +27,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "fscache.h"
 #include "smbdirect.h"
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..5dec703c0bc5 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -30,7 +30,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "ntlmssp.h"
 #include "nterr.h"
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 23ef56f55ce5..0b496b906997 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -8,7 +8,7 @@
  */
 #include "fscache.h"
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifsproto.h"
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3ad303dd5e5a..a7093f23c0f9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -19,7 +19,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fscache.h"
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0359b604bdbc..f696fa8c4f59 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -16,7 +16,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsfs.h"
 #include "cifs_ioctl.h"
 #include "smb2proto.h"
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index bbdf3281559c..9a02b0f173b8 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -13,7 +13,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "smb2proto.h"
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a825cc09a53e..15df70d852a1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -13,7 +13,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "smberr.h"
 #include "nterr.h"
 #include "cifs_unicode.h"
@@ -363,13 +363,15 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 	}
 
 	if (4 + rfclen != clc_len) {
-		__u16 mid = get_mid(smb);
+		__u16 mid __maybe_unused; /* for debug only */
 		/* check if bcc wrapped around for large read responses */
 		if ((rfclen > 64 * 1024) && (rfclen > clc_len)) {
 			/* check if lengths match mod 64K */
 			if (((4 + rfclen) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
+
+		mid = get_mid(smb);
 		cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
 			 clc_len, 4 + rfclen, mid);
 
diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
index 291cb606f149..ce6264a1c1ad 100644
--- a/fs/cifs/netlink.c
+++ b/fs/cifs/netlink.c
@@ -10,7 +10,7 @@
 
 #include "netlink.h"
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_swn.h"
 
 static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 28caae7aed1b..b699e386f14a 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -21,7 +21,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smberr.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "nterr.h"
 
 struct smb_to_posix_error {
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/proc.c
similarity index 92%
rename from fs/cifs/cifs_debug.c
rename to fs/cifs/proc.c
index aac4240893af..f5bdc413d7b5 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/proc.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- *
  *   Copyright (C) International Business Machines  Corp., 2000,2005
  *
  *   Modified by Steve French (sfrench@us.ibm.com)
@@ -14,7 +13,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsfs.h"
 #include "fs_context.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -25,65 +24,16 @@
 #endif
 #include "cifs_swn.h"
 
-void
-cifs_dump_mem(char *label, void *data, int length)
-{
-	pr_debug("%s: dump of %d bytes of data at 0x%p\n", label, length, data);
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
-		       data, length, true);
-}
-
-void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
-{
-#ifdef CONFIG_CIFS_DEBUG2
-	struct smb_hdr *smb = buf;
-
-	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d\n",
-		 smb->Command, smb->Status.CifsError,
-		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-		 server->ops->calc_smb_size(smb, server));
-#endif /* CONFIG_CIFS_DEBUG2 */
-}
-
-void cifs_dump_mids(struct TCP_Server_Info *server)
-{
-#ifdef CONFIG_CIFS_DEBUG2
-	struct mid_q_entry *mid_entry;
-
-	if (server == NULL)
-		return;
-
-	cifs_dbg(VFS, "Dump pending requests:\n");
-	spin_lock(&GlobalMid_Lock);
-	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
-		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
-			 mid_entry->mid_state,
-			 le16_to_cpu(mid_entry->command),
-			 mid_entry->pid,
-			 mid_entry->callback_data,
-			 mid_entry->mid);
-#ifdef CONFIG_CIFS_STATS2
-		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
-			 mid_entry->large_buf,
-			 mid_entry->resp_buf,
-			 mid_entry->when_received,
-			 jiffies);
-#endif /* STATS2 */
-		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
-			 mid_entry->multiRsp, mid_entry->multiEnd);
-		if (mid_entry->resp_buf) {
-			cifs_dump_detail(mid_entry->resp_buf, server);
-			cifs_dump_mem("existing buf: ",
-				mid_entry->resp_buf, 62);
-		}
-	}
-	spin_unlock(&GlobalMid_Lock);
-#endif /* CONFIG_CIFS_DEBUG2 */
-}
-
 #ifdef CONFIG_PROC_FS
-static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
+static struct proc_dir_entry *proc_fs_cifs;
+static const struct proc_ops cifsFYI_proc_ops;
+static const struct proc_ops cifs_lookup_cache_proc_ops;
+static const struct proc_ops traceSMB_proc_ops;
+static const struct proc_ops cifs_security_flags_proc_ops;
+static const struct proc_ops cifs_linux_ext_proc_ops;
+static const struct proc_ops cifs_mount_params_proc_ops;
+
+static void cifs_dump_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 {
 	__u32 dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
 
@@ -123,8 +73,7 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 	seq_putc(m, '\n');
 }
 
-static void
-cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
+static void cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 {
 	struct TCP_Server_Info *server = chan->server;
 
@@ -145,8 +94,7 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   atomic_read(&server->num_waiters));
 }
 
-static void
-cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
+static void cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 {
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
@@ -435,14 +383,14 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 			seq_printf(m, "\n\t%d) IPC: ", j);
 			if (ses->tcon_ipc)
-				cifs_debug_tcon(m, ses->tcon_ipc);
+				cifs_dump_tcon(m, ses->tcon_ipc);
 			else
 				seq_puts(m, "none\n");
 
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				++j;
 				seq_printf(m, "\n\t%d) ", j);
-				cifs_debug_tcon(m, tcon);
+				cifs_dump_tcon(m, tcon);
 			}
 
 			spin_lock(&ses->iface_lock);
@@ -669,16 +617,7 @@ PROC_FILE_DEFINE(smbd_send_credit_target);
 PROC_FILE_DEFINE(smbd_receive_credit_max);
 #endif
 
-static struct proc_dir_entry *proc_fs_cifs;
-static const struct proc_ops cifsFYI_proc_ops;
-static const struct proc_ops cifs_lookup_cache_proc_ops;
-static const struct proc_ops traceSMB_proc_ops;
-static const struct proc_ops cifs_security_flags_proc_ops;
-static const struct proc_ops cifs_linux_ext_proc_ops;
-static const struct proc_ops cifs_mount_params_proc_ops;
-
-void
-cifs_proc_init(void)
+void cifs_proc_init(void)
 {
 	proc_fs_cifs = proc_mkdir("fs/cifs", NULL);
 	if (proc_fs_cifs == NULL)
@@ -726,8 +665,7 @@ cifs_proc_init(void)
 #endif
 }
 
-void
-cifs_proc_clean(void)
+void cifs_proc_clean(void)
 {
 	if (proc_fs_cifs == NULL)
 		return;
@@ -906,8 +844,7 @@ static int cifs_security_flags_proc_open(struct inode *inode, struct file *file)
  * flags except for the ones corresponding to the given MUST flag. If there are
  * multiple MUST flags, then try to prefer more secure ones.
  */
-static void
-cifs_security_flags_handle_must_flags(unsigned int *flags)
+static void cifs_security_flags_handle_must_flags(unsigned int *flags)
 {
 	unsigned int signflags = *flags & CIFSSEC_MUST_SIGN;
 
@@ -1033,16 +970,8 @@ static const struct proc_ops cifs_mount_params_proc_ops = {
 	.proc_read	= seq_read,
 	.proc_lseek	= seq_lseek,
 	.proc_release	= single_release,
-	/* No need for write for now */
-	/* .proc_write	= cifs_mount_params_proc_write, */
 };
-
-#else
-inline void cifs_proc_init(void)
-{
-}
-
-inline void cifs_proc_clean(void)
-{
-}
+#else /* CONFIG_PROC_FS */
+inline void cifs_proc_init(void) {}
+inline void cifs_proc_clean(void) {}
 #endif /* PROC_FS */
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 384cabdf47ca..8ee9d21342c7 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -16,7 +16,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifsfs.h"
 #include "smb2proto.h"
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 02c8b2906196..32169765d4c7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -12,7 +12,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "ntlmssp.h"
 #include "nterr.h"
 #include <linux/utsname.h>
@@ -361,19 +361,22 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	struct smb3_fs_context ctx = {NULL};
 	static const char unc_fmt[] = "\\%s\\foo";
 	char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
-	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
-	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
-	int rc;
 	unsigned int xid = get_xid();
+	int rc;
 
-	if (iface->sockaddr.ss_family == AF_INET)
+#ifdef CONFIG_CIFS_DEBUG
+	if (iface->sockaddr.ss_family == AF_INET) {
+		struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
 		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI4)\n",
 			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
 			 &ipv4->sin_addr);
-	else
+	} else {
+		struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
 		cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ip:%pI6)\n",
 			 ses, iface->speed, iface->rdma_capable ? "yes" : "no",
 			 &ipv6->sin6_addr);
+	}
+#endif /* CONFIG_CIFS_DEBUG */
 
 	/*
 	 * Setup a ctx with mostly the same info as the existing
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 2e20ee4dab7b..a9d8597ac067 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -10,7 +10,7 @@
 #include <uapi/linux/magic.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifspdu.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index f5dcc4940b6d..434b4b14d746 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -15,7 +15,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fscache.h"
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8571a459c710..c5dee260521b 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -16,7 +16,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "fscache.h"
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 194799ddd382..14ccf4397aca 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -9,7 +9,7 @@
  */
 #include <linux/errno.h>
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
 #include "smb2status.h"
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 818cc4dee0e2..a67d6c7bc7e7 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -11,7 +11,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_unicode.h"
 #include "smb2status.h"
 #include "smb2glob.h"
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5bed8b584086..809a2b07d899 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -19,7 +19,7 @@
 #include "smb2pdu.h"
 #include "smb2proto.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_unicode.h"
 #include "smb2status.h"
 #include "smb2glob.h"
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 295ee8b88055..45c800cdb258 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -28,7 +28,7 @@
 #include "cifsproto.h"
 #include "smb2proto.h"
 #include "cifs_unicode.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "ntlmssp.h"
 #include "smb2status.h"
 #include "smb2glob.h"
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 53ff6bc11939..c9170646544c 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -22,7 +22,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "smb2status.h"
 #include "smb2glob.h"
 
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fbbec22bcc8..6c429869d009 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include "smbdirect.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
 
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 4a0487753869..a07c4c3ada64 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -22,7 +22,7 @@
 #include "cifs_unicode.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifsproto.h"
 #include "../smbfs_common/md4.h"
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index dac8d6f9b309..27842aa1294d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -24,7 +24,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "smb2proto.h"
 #include "smbdirect.h"
 
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 9d486fbbfbbd..d0980d19e87c 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -14,7 +14,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
-#include "cifs_debug.h"
+#include "debug.h"
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "cifs_ioctl.h"
-- 
2.35.3

