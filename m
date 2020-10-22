Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FCCC5DF9E
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 18:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CFDB2225F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 18:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901668AbgJVSNw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 14:13:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:58860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898343AbgJVSNw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Oct 2020 14:13:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C3C0B818
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 18:13:50 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH 07/11] cifs: Add witness information to debug data dump
Date:   Thu, 22 Oct 2020 20:13:35 +0200
Message-Id: <20201022181339.30771-8-scabrero@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022181339.30771-1-scabrero@suse.de>
References: <20201022181339.30771-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+ Indicate if witness feature is supported
+ Indicate if witness is used when dumping tcons
+ Dumps witness registrations. Example:
  Witness registrations:
  Id: 1 Refs: 1 Network name: 'fs.fover.ad'(y) Share name: 'share1'(y) \
    Ip address: 192.168.103.200(n)

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifs_debug.c | 13 +++++++++++++
 fs/cifs/cifs_swn.c   | 35 +++++++++++++++++++++++++++++++++++
 fs/cifs/cifs_swn.h   |  2 ++
 3 files changed, 50 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 53588d7517b4..b231dcf1d1f9 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -23,6 +23,9 @@
 #ifdef CONFIG_CIFS_SMB_DIRECT
 #include "smbdirect.h"
 #endif
+#ifdef CONFIG_CIFS_SWN_UPCALL
+#include "cifs_swn.h"
+#endif
 
 void
 cifs_dump_mem(char *label, void *data, int length)
@@ -115,6 +118,10 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 		seq_printf(m, " POSIX Extensions");
 	if (tcon->ses->server->ops->dump_share_caps)
 		tcon->ses->server->ops->dump_share_caps(m, tcon);
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	if (tcon->use_witness)
+		seq_puts(m, " Witness");
+#endif
 
 	if (tcon->need_reconnect)
 		seq_puts(m, "\tDISCONNECTED ");
@@ -262,6 +269,9 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, ",XATTR");
 #endif
 	seq_printf(m, ",ACL");
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	seq_puts(m, ",WITNESS");
+#endif
 	seq_putc(m, '\n');
 	seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
 	seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
@@ -462,6 +472,9 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	spin_unlock(&cifs_tcp_ses_lock);
 	seq_putc(m, '\n');
 
+#ifdef CONFIG_CIFS_SWN_UPCALL
+	cifs_swn_dump(m);
+#endif
 	/* BB add code to dump additional info such as TCP session info now */
 	return 0;
 }
diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 501d84893262..4396e21ef228 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -501,3 +501,38 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 
 	return 0;
 }
+
+void cifs_swn_dump(struct seq_file *m)
+{
+	struct cifs_swn_reg *swnreg;
+	struct sockaddr_in *sa;
+	struct sockaddr_in6 *sa6;
+	int id;
+
+	seq_puts(m, "Witness registrations:");
+
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
+		seq_printf(m, "\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: ",
+				id, kref_read(&swnreg->ref_count),
+				swnreg->net_name, swnreg->net_name_notify ? "(y)" : "(n)",
+				swnreg->share_name, swnreg->share_name_notify ? "(y)" : "(n)");
+		switch (swnreg->tcon->ses->server->dstaddr.ss_family) {
+		case AF_INET:
+			sa = (struct sockaddr_in *) &swnreg->tcon->ses->server->dstaddr;
+			seq_printf(m, "%pI4", &sa->sin_addr.s_addr);
+			break;
+		case AF_INET6:
+			sa6 = (struct sockaddr_in6 *) &swnreg->tcon->ses->server->dstaddr;
+			seq_printf(m, "%pI6", &sa6->sin6_addr.s6_addr);
+			if (sa6->sin6_scope_id)
+				seq_printf(m, "%%%u", sa6->sin6_scope_id);
+			break;
+		default:
+			seq_puts(m, "(unknown)");
+		}
+		seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
+	}
+	mutex_unlock(&cifs_swnreg_idr_mutex);
+	seq_puts(m, "\n");
+}
diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
index 7ef9ecedbd05..13b25cdc9295 100644
--- a/fs/cifs/cifs_swn.h
+++ b/fs/cifs/cifs_swn.h
@@ -18,4 +18,6 @@ extern int cifs_swn_unregister(struct cifs_tcon *tcon);
 
 extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
 
+extern void cifs_swn_dump(struct seq_file *m);
+
 #endif /* _CIFS_SWN_H */
-- 
2.28.0

