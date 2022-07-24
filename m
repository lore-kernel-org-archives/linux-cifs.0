Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C5EC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiGXPMb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXPMa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25F311164
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 610915C0E6;
        Sun, 24 Jul 2022 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9yU9Ucsmchutm9TD3uRtvg6dOMu1Yr1w6cDPaF+BK8=;
        b=k4EO5+O3dzXS3wuLsHJ/Z0UAD86pMQkvieRwENkGM8APIl2siLLbdnvcX+DEL8WwbYU3JO
        U5su2681crrHlBymy52E4DzC6akfQ2tSXf0w5gxONekqprHk9Wd1Gy4J1ra8rygwHZUxuL
        vl1xZphrWDXcwCLRJMWbmKvkrZS9Xok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9yU9Ucsmchutm9TD3uRtvg6dOMu1Yr1w6cDPaF+BK8=;
        b=aqVvRtO8pIZP541Unh7cI+nfY3cAT4VWdecKipBmmcXyDyoODpE/eYvecq5GWV2qpP+7Rz
        ZSw/2OhXRlXmqkAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D2F0B13A8D;
        Sun, 24 Jul 2022 15:12:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AtVnJFph3WJgMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:26 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 11/14] cifs: rename cifsFYI to debug_level
Date:   Sun, 24 Jul 2022 12:11:34 -0300
Message-Id: <20220724151137.7538-12-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename "cifsFYI" to "debug_level" to add more meaning to it.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/Kconfig        |  2 +-
 fs/cifs/cifs_debug.c   | 26 +++++++++++++-------------
 fs/cifs/cifs_debug.h   | 19 +++++++++----------
 fs/cifs/cifs_spnego.c  |  2 +-
 fs/cifs/cifsfs.c       |  4 ++--
 fs/cifs/netmisc.c      |  2 +-
 fs/cifs/smb2maperror.c |  2 +-
 fs/cifs/smb2misc.c     |  2 +-
 fs/cifs/transport.c    |  2 +-
 9 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 3b7e3b9e4fd2..5b3a6dbc6eda 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -61,7 +61,7 @@ config CIFS_STATS2
 	  Enabling this option will allow more detailed statistics on SMB
 	  request timing to be displayed in /proc/fs/cifs/DebugData and also
 	  allow optional logging of slow responses to dmesg (depending on the
-	  value of /proc/fs/cifs/cifsFYI). See Documentation/admin-guide/cifs/usage.rst
+	  value of /proc/fs/cifs/debug_level). See Documentation/admin-guide/cifs/usage.rst
 	  for more details. These additional statistics may have a minor effect
 	  on performance and memory utilization.
 
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index c88bea9d3ac3..0c08166f8f30 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -670,7 +670,7 @@ PROC_FILE_DEFINE(smbd_receive_credit_max);
 #endif
 
 static struct proc_dir_entry *proc_fs_cifs;
-static const struct proc_ops cifsFYI_proc_ops;
+static const struct proc_ops debug_level_proc_ops;
 static const struct proc_ops cifs_lookup_cache_proc_ops;
 static const struct proc_ops traceSMB_proc_ops;
 static const struct proc_ops cifs_security_flags_proc_ops;
@@ -691,7 +691,7 @@ cifs_proc_init(void)
 			cifs_debug_files_proc_show);
 
 	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
-	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
+	proc_create("debug_level", 0644, proc_fs_cifs, &debug_level_proc_ops);
 	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
 	proc_create("LinuxExtensionsEnabled", 0644, proc_fs_cifs,
 		    &cifs_linux_ext_proc_ops);
@@ -734,7 +734,7 @@ cifs_proc_clean(void)
 
 	remove_proc_entry("DebugData", proc_fs_cifs);
 	remove_proc_entry("open_files", proc_fs_cifs);
-	remove_proc_entry("cifsFYI", proc_fs_cifs);
+	remove_proc_entry("debug_level", proc_fs_cifs);
 	remove_proc_entry("traceSMB", proc_fs_cifs);
 	remove_proc_entry("Stats", proc_fs_cifs);
 	remove_proc_entry("SecurityFlags", proc_fs_cifs);
@@ -758,18 +758,18 @@ cifs_proc_clean(void)
 	remove_proc_entry("fs/cifs", NULL);
 }
 
-static int cifsFYI_proc_show(struct seq_file *m, void *v)
+static int debug_level_proc_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "%d\n", cifsFYI);
+	seq_printf(m, "%d\n", debug_level);
 	return 0;
 }
 
-static int cifsFYI_proc_open(struct inode *inode, struct file *file)
+static int debug_level_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, cifsFYI_proc_show, NULL);
+	return single_open(file, debug_level_proc_show, NULL);
 }
 
-static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
+static ssize_t debug_level_proc_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	char c[2] = { '\0' };
@@ -780,21 +780,21 @@ static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 	if (rc)
 		return rc;
 	if (strtobool(c, &bv) == 0)
-		cifsFYI = bv;
+		debug_level = bv;
 	else if ((c[0] > '1') && (c[0] <= '9'))
-		cifsFYI = (int) (c[0] - '0'); /* see cifs_debug.h for meanings */
+		debug_level = (int) (c[0] - '0'); /* see cifs_debug.h for meanings */
 	else
 		return -EINVAL;
 
 	return count;
 }
 
-static const struct proc_ops cifsFYI_proc_ops = {
-	.proc_open	= cifsFYI_proc_open,
+static const struct proc_ops debug_level_proc_ops = {
+	.proc_open	= debug_level_proc_open,
 	.proc_read	= seq_read,
 	.proc_lseek	= seq_lseek,
 	.proc_release	= single_release,
-	.proc_write	= cifsFYI_proc_write,
+	.proc_write	= debug_level_proc_write,
 };
 
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 2ac0e384fd12..3e5f9a68c62d 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -5,13 +5,10 @@
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
 
 void cifs_dump_mem(char *, void *, int );
@@ -19,13 +16,15 @@ void cifs_dump_detail(void *, struct cifs_server_info *);
 void cifs_dump_mids(struct cifs_server_info *);
 extern bool traceSMB;		/* flag which enables the function below */
 void dump_smb(void *, int);
+
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
 
 #define VFS 1
 #define FYI 2
-extern int cifsFYI;
+extern int debug_level;
+
 #ifdef CONFIG_CIFS_DEBUG2
 #define NOISY 4
 #else
@@ -61,7 +60,7 @@ extern int cifsFYI;
 /* information message: e.g., configuration, major event */
 #define cifs_dbg_func(ratefunc, type, fmt, ...)				\
 do {									\
-	if ((type) & FYI && cifsFYI & CIFS_INFO) {			\
+	if ((type) & FYI && debug_level & CIFS_INFO) {			\
 		pr_debug_ ## ratefunc("%s: " fmt,			\
 				      __FILE__, ##__VA_ARGS__);		\
 	} else if ((type) & VFS) {					\
@@ -84,7 +83,7 @@ do {									\
 	const char *sn = "";						\
 	if (server && server->hostname)					\
 		sn = server->hostname;					\
-	if ((type) & FYI && cifsFYI & CIFS_INFO) {			\
+	if ((type) & FYI && debug_level & CIFS_INFO) {			\
 		pr_debug_ ## ratefunc("%s: \\\\%s " fmt,		\
 				      __FILE__, sn, ##__VA_ARGS__);	\
 	} else if ((type) & VFS) {					\
@@ -110,7 +109,7 @@ do {									\
 	const char *tn = "";						\
 	if (tcon && tcon->treeName)					\
 		tn = tcon->treeName;					\
-	if ((type) & FYI && cifsFYI & CIFS_INFO) {			\
+	if ((type) & FYI && debug_level & CIFS_INFO) {			\
 		pr_debug_ ## ratefunc("%s: %s "	fmt,			\
 				      __FILE__, tn, ##__VA_ARGS__);	\
 	} else if ((type) & VFS) {					\
@@ -157,4 +156,4 @@ do {									\
 	pr_info(fmt, ##__VA_ARGS__)
 #endif
 
-#endif				/* _H_CIFS_DEBUG */
+#endif /* _CIFS_DEBUG_H */
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 60f551deb443..46a50aceb23d 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -162,7 +162,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	revert_creds(saved_cred);
 
 #ifdef CONFIG_CIFS_DEBUG2
-	if (cifsFYI && !IS_ERR(spnego_key)) {
+	if (debug_level && !IS_ERR(spnego_key)) {
 		struct cifs_spnego_msg *msg = spnego_key->payload.data[0];
 		cifs_dump_mem("SPNEGO reply blob:", msg->data, min(1024U,
 				msg->secblob_len + msg->sesskey_len));
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3a0eb78a3378..5bb51b8cd3bd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -56,7 +56,7 @@
 #define SMB_DATE_MIN (0<<9 | 1<<5 | 1)
 #define SMB_TIME_MAX (23<<11 | 59<<5 | 29)
 
-int cifsFYI = 0;
+int debug_level = 0;
 bool traceSMB;
 bool enable_oplocks = true;
 bool linuxExtEnabled = true;
@@ -856,7 +856,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	 * Prints in Kernel / CIFS log the attempted mount operation
 	 *	If CIFS_DEBUG && cifs_FYI
 	 */
-	if (cifsFYI)
+	if (debug_level)
 		cifs_dbg(FYI, "Devname: %s flags: %d\n", old_ctx->UNC, flags);
 	else
 		cifs_info("Attempting to mount %s\n", old_ctx->UNC);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 0efd58db351e..33beaf148223 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -827,7 +827,7 @@ map_smb_to_linux_error(char *buf, bool logErr)
 		__u32 err = le32_to_cpu(smb->Status.CifsError);
 		if (logErr && (err != (NT_STATUS_MORE_PROCESSING_REQUIRED)))
 			cifs_print_status(err);
-		else if (cifsFYI & CIFS_RC)
+		else if (debug_level & CIFS_RC)
 			cifs_print_status(err);
 		ntstatus_to_dos(err, &smberrclass, &smberrcode);
 	} else {
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 194799ddd382..1b0eae9c367b 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2456,7 +2456,7 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 	if (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
 	    (smb2err != STATUS_END_OF_FILE))
 		smb2_print_status(smb2err);
-	else if (cifsFYI & CIFS_RC)
+	else if (debug_level & CIFS_RC)
 		smb2_print_status(smb2err);
 
 	for (i = 0; i < sizeof(smb2_error_map_table) /
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index dbaee6343fdc..587362124842 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -260,7 +260,7 @@ smb2_check_message(char *buf, unsigned int len, struct cifs_server_info *server)
 			return 0;
 
 		/* Only log a message if len was really miscalculated */
-		if (unlikely(cifsFYI))
+		if (unlikely(debug_level))
 			cifs_dbg(FYI, "Server response too short: calculated "
 				 "length %u doesn't match read length %u (cmd=%d, mid=%llu)\n",
 				 calc_len, len, command, mid);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b681a0c9b03d..74ddf1201ab1 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -137,7 +137,7 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 
 		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
 			       midEntry->when_sent, midEntry->when_received);
-		if (cifsFYI & CIFS_TIMER) {
+		if (debug_level & CIFS_TIMER) {
 			pr_debug("slow rsp: cmd %d mid %llu",
 				 midEntry->command, midEntry->mid);
 			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-- 
2.35.3

