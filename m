Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E08AC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiCGBfO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiCGBfM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:12 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D26313EAB
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0A396210ED;
        Mon,  7 Mar 2022 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeM4ryfZPtgrggTEPep42lZ/UfnOePBQDuR/Lsw93Xc=;
        b=kvXo39hagfDfpJ8FcKbEGXegwTV/5v0WR6o3V9HMcDSNaeKjQdkwVyvuBw3vB6uHIxFHaT
        3gS9KPTnIH7uVJ5i/LTxz5CdEkgbOWZglvjzODbomy651KByHgXHLNETTMqOmikYb/VTlI
        QbPhEM8Tmmnk5Wrrqr03Oc/iswsVa9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616858;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeM4ryfZPtgrggTEPep42lZ/UfnOePBQDuR/Lsw93Xc=;
        b=Nla4mUEAlLr8cJflp88UFIsA3yQHUMhEDldyhcFBaIxNAouslxqAB7k4xAfYUUoCz/sHtf
        rlU/SeuBMAAoKsDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 736FF1340A;
        Mon,  7 Mar 2022 01:34:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tkWZDRlhJWIbdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:17 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 3/9] ksmbd-tools: use quotes for local includes
Date:   Sun,  6 Mar 2022 22:33:38 -0300
Message-Id: <20220307013344.29064-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cosmetic only, but better practice.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 daemon/ipc.c                 | 16 ++++++++--------
 daemon/rpc.c                 | 17 +++++++++--------
 daemon/rpc_lsarpc.c          | 13 +++++++------
 daemon/rpc_samr.c            | 13 +++++++------
 daemon/rpc_srvsvc.c          | 11 ++++++-----
 daemon/rpc_wkssvc.c          | 10 +++++-----
 daemon/smbacl.c              |  4 ++--
 daemon/worker.c              | 19 ++++++++++---------
 lib/config_parser.c          | 11 ++++++-----
 lib/ksmbdtools.c             |  2 +-
 lib/management/spnego.c      |  6 +++---
 lib/management/spnego_krb5.c |  4 ++--
 share/share_admin.c          | 12 +++++-------
 user/md4_hash.c              |  2 +-
 user/user_admin.c            | 16 +++++++---------
 15 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/daemon/ipc.c b/daemon/ipc.c
index eded431e8112..c46cbc174175 100644
--- a/daemon/ipc.c
+++ b/daemon/ipc.c
@@ -15,14 +15,14 @@
 #include <linux/genetlink.h>
 #include <netlink/genl/mngt.h>
 
-#include <linux/ksmbd_server.h>
-
-#include <ksmbdtools.h>
-#include <ipc.h>
-#include <worker.h>
-#include <config_parser.h>
-#include <management/user.h>
-#include <management/share.h>
+#include "linux/ksmbd_server.h"
+
+#include "ksmbdtools.h"
+#include "ipc.h"
+#include "worker.h"
+#include "config_parser.h"
+#include "management/user.h"
+#include "management/share.h"
 
 static struct nl_sock *sk;
 
diff --git a/daemon/rpc.c b/daemon/rpc.c
index 2361634f1a55..ab2a7c6dfebe 100644
--- a/daemon/rpc.c
+++ b/daemon/rpc.c
@@ -9,14 +9,15 @@
 #include <endian.h>
 #include <glib.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
-
-#include <rpc.h>
-#include <rpc_srvsvc.h>
-#include <rpc_wkssvc.h>
-#include <rpc_samr.h>
-#include <rpc_lsarpc.h>
-#include <ksmbdtools.h>
+
+#include "linux/ksmbd_server.h"
+
+#include "rpc.h"
+#include "rpc_srvsvc.h"
+#include "rpc_wkssvc.h"
+#include "rpc_samr.h"
+#include "rpc_lsarpc.h"
+#include "ksmbdtools.h"
 
 static GHashTable	*pipes_table;
 static GRWLock		pipes_table_lock;
diff --git a/daemon/rpc_lsarpc.c b/daemon/rpc_lsarpc.c
index 5caf4d9ef3ac..23fc68c3810b 100644
--- a/daemon/rpc_lsarpc.c
+++ b/daemon/rpc_lsarpc.c
@@ -10,13 +10,14 @@
 #include <glib.h>
 #include <pwd.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
 
-#include <management/user.h>
-#include <rpc.h>
-#include <rpc_lsarpc.h>
-#include <smbacl.h>
-#include <ksmbdtools.h>
+#include "linux/ksmbd_server.h"
+
+#include "management/user.h"
+#include "rpc.h"
+#include "rpc_lsarpc.h"
+#include "smbacl.h"
+#include "ksmbdtools.h"
 
 #define LSARPC_OPNUM_DS_ROLE_GET_PRIMARY_DOMAIN_INFO	0
 #define LSARPC_OPNUM_OPEN_POLICY2			44
diff --git a/daemon/rpc_samr.c b/daemon/rpc_samr.c
index 95c607c101a3..396e38f58013 100644
--- a/daemon/rpc_samr.c
+++ b/daemon/rpc_samr.c
@@ -9,13 +9,14 @@
 #include <endian.h>
 #include <glib.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
 
-#include <management/user.h>
-#include <rpc.h>
-#include <rpc_samr.h>
-#include <smbacl.h>
-#include <ksmbdtools.h>
+#include "linux/ksmbd_server.h"
+
+#include "management/user.h"
+#include "rpc.h"
+#include "rpc_samr.h"
+#include "smbacl.h"
+#include "ksmbdtools.h"
 
 #define SAMR_OPNUM_CONNECT5		64
 #define SAMR_OPNUM_ENUM_DOMAIN		6
diff --git a/daemon/rpc_srvsvc.c b/daemon/rpc_srvsvc.c
index f3b4d069031a..c3ec1c2bccd5 100644
--- a/daemon/rpc_srvsvc.c
+++ b/daemon/rpc_srvsvc.c
@@ -9,13 +9,14 @@
 #include <endian.h>
 #include <glib.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
 
-#include <management/share.h>
+#include "linux/ksmbd_server.h"
+ 
+#include "management/share.h"
 
-#include <rpc.h>
-#include <rpc_srvsvc.h>
-#include <ksmbdtools.h>
+#include "rpc.h"
+#include "rpc_srvsvc.h"
+#include "ksmbdtools.h"
 
 #define SHARE_TYPE_TEMP			0x40000000
 #define SHARE_TYPE_HIDDEN		0x80000000
diff --git a/daemon/rpc_wkssvc.c b/daemon/rpc_wkssvc.c
index 32b7893eb2c6..a84f99b41888 100644
--- a/daemon/rpc_wkssvc.c
+++ b/daemon/rpc_wkssvc.c
@@ -9,13 +9,13 @@
 #include <endian.h>
 #include <glib.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
 
-#include <management/share.h>
+#include "linux/ksmbd_server.h"
 
-#include <rpc.h>
-#include <rpc_wkssvc.h>
-#include <ksmbdtools.h>
+#include "management/share.h"
+#include "rpc.h"
+#include "rpc_wkssvc.h"
+#include "ksmbdtools.h"
 
 #define WKSSVC_NETWKSTA_GET_INFO	(0)
 
diff --git a/daemon/smbacl.c b/daemon/smbacl.c
index 66531c3bebea..a0ce2878fa18 100644
--- a/daemon/smbacl.c
+++ b/daemon/smbacl.c
@@ -6,8 +6,8 @@
  *   Author(s): Namjae Jeon (linkinjeon@kernel.org)
  */
 
-#include <smbacl.h>
-#include <ksmbdtools.h>
+#include "smbacl.h"
+#include "ksmbdtools.h"
 #include <glib.h>
 #include <glib/gprintf.h>
 
diff --git a/daemon/worker.c b/daemon/worker.c
index 70f2655b36c3..0ddd88cea12c 100644
--- a/daemon/worker.c
+++ b/daemon/worker.c
@@ -7,17 +7,18 @@
 #include <memory.h>
 #include <glib.h>
 #include <errno.h>
-#include <linux/ksmbd_server.h>
 
-#include <ksmbdtools.h>
-#include <worker.h>
-#include <ipc.h>
-#include <rpc.h>
+#include "linux/ksmbd_server.h"
 
-#include <management/user.h>
-#include <management/share.h>
-#include <management/tree_conn.h>
-#include <management/spnego.h>
+#include "ksmbdtools.h"
+#include "worker.h"
+#include "ipc.h"
+#include "rpc.h"
+
+#include "management/user.h"
+#include "management/share.h"
+#include "management/tree_conn.h"
+#include "management/spnego.h"
 
 #define MAX_WORKER_THREADS	4
 static GThreadPool *pool;
diff --git a/lib/config_parser.c b/lib/config_parser.c
index aa1dbf2a403e..20e27c3ab8ec 100644
--- a/lib/config_parser.c
+++ b/lib/config_parser.c
@@ -12,12 +12,13 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <linux/ksmbd_server.h>
 
-#include <config_parser.h>
-#include <ksmbdtools.h>
-#include <management/user.h>
-#include <management/share.h>
+#include "linux/ksmbd_server.h"
+
+#include "config_parser.h"
+#include "ksmbdtools.h"
+#include "management/user.h"
+#include "management/share.h"
 
 struct smbconf_global global_conf;
 struct smbconf_parser parser;
diff --git a/lib/ksmbdtools.c b/lib/ksmbdtools.c
index b636f34af98e..126b20c6a56a 100644
--- a/lib/ksmbdtools.c
+++ b/lib/ksmbdtools.c
@@ -13,7 +13,7 @@
 #include <fcntl.h>
 
 #include <stdio.h>
-#include <ksmbdtools.h>
+#include "ksmbdtools.h"
 
 static const char *app_name = "unknown";
 static int log_open;
diff --git a/lib/management/spnego.c b/lib/management/spnego.c
index 473caf66e036..685d88beebc3 100644
--- a/lib/management/spnego.c
+++ b/lib/management/spnego.c
@@ -19,9 +19,9 @@
 #include <stdint.h>
 #include <stdbool.h>
 
-#include <linux/ksmbd_server.h>
-#include <management/spnego.h>
-#include <asn1.h>
+#include "linux/ksmbd_server.h"
+#include "management/spnego.h"
+#include "asn1.h"
 #include "spnego_mech.h"
 
 static struct spnego_mech_ctx mech_ctxs[SPNEGO_MAX_MECHS];
diff --git a/lib/management/spnego_krb5.c b/lib/management/spnego_krb5.c
index 4bf7585bfb09..9e1516642145 100644
--- a/lib/management/spnego_krb5.c
+++ b/lib/management/spnego_krb5.c
@@ -15,8 +15,8 @@
 #include <netdb.h>
 #include <krb5.h>
 
-#include <management/spnego.h>
-#include <asn1.h>
+#include "management/spnego.h"
+#include "asn1.h"
 #include "spnego_mech.h"
 
 struct spnego_krb5_ctx {
diff --git a/share/share_admin.c b/share/share_admin.c
index 8365f872d620..0ff13d8017dd 100644
--- a/share/share_admin.c
+++ b/share/share_admin.c
@@ -13,13 +13,11 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 
-#include <config_parser.h>
-#include <ksmbdtools.h>
-
-#include <management/share.h>
-
-#include <linux/ksmbd_server.h>
-#include <share_admin.h>
+#include "config_parser.h"
+#include "ksmbdtools.h"
+#include "management/share.h"
+#include "linux/ksmbd_server.h"
+#include "share_admin.h"
 
 static int conf_fd = -1;
 static char wbuf[16384];
diff --git a/user/md4_hash.c b/user/md4_hash.c
index 1dd4f61ac82a..3ef0996557c8 100644
--- a/user/md4_hash.c
+++ b/user/md4_hash.c
@@ -19,8 +19,8 @@
 
 #include <stdlib.h>
 #include <memory.h>
-#include <md4_hash.h>
 #include <asm/byteorder.h>
+#include "md4_hash.h"
 
 #define u8 unsigned char
 #define u32 unsigned int
diff --git a/user/user_admin.c b/user/user_admin.c
index 4e8591517c48..95b05ea33f28 100644
--- a/user/user_admin.c
+++ b/user/user_admin.c
@@ -14,15 +14,13 @@
 #include <fcntl.h>
 #include <termios.h>
 
-#include <config_parser.h>
-#include <ksmbdtools.h>
-
-#include <md4_hash.h>
-#include <user_admin.h>
-#include <management/user.h>
-#include <management/share.h>
-
-#include <linux/ksmbd_server.h>
+#include "config_parser.h"
+#include "ksmbdtools.h"
+#include "md4_hash.h"
+#include "user_admin.h"
+#include "management/user.h"
+#include "management/share.h"
+#include "linux/ksmbd_server.h"
 
 #define MAX_NT_PWD_LEN 129
 
-- 
2.34.1

