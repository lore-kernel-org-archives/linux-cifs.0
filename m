Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BABECCA48A
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 22:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbiGYWiy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiGYWiM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 18:38:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17942656C
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 15:37:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7E2081F8B0;
        Mon, 25 Jul 2022 22:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658788640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6tCwV//znBbsqXb2i3RHe9yoe7AotvDK9CfvlqjidyE=;
        b=gWcDNwxav6cLFUBClOxKewhWzbBGWS6O2oVLFWddzkcH3p6hJNPf4iqiGxz1llgftfkdR8
        yKL0mFwsNGpKB/mDPCeC3aIHlTfQ3ZQ5LX+PAxXLMxNWDm7/mgdaGl2Hhx0E66eV7DFUPf
        QH6WnAOKbUiWOof0corRGfp09NXfznM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658788640;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6tCwV//znBbsqXb2i3RHe9yoe7AotvDK9CfvlqjidyE=;
        b=bMRv45mINXZ4c04HchA6uuRxLGPUpO8cz8pxH6VRoR7sErAM9rI+g2ZbJz2HhStPXhHFLo
        4t0BAGDlr37HKJDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00F5713ABB;
        Mon, 25 Jul 2022 22:37:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LfGDLR8b32LwRgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 22:37:19 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 02/10] cifs: rename global counters
Date:   Mon, 25 Jul 2022 19:36:59 -0300
Message-Id: <20220725223707.14477-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725223707.14477-1-ematsumiya@suse.de>
References: <20220725223707.14477-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename global counters from CamelCase to snake_case.
Rename server counters from "tcpSes" to use "servers" instead.
Prepend "g_" to indicate global.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c | 16 ++++++++--------
 fs/cifs/cifsfs.c     | 14 +++++++-------
 fs/cifs/cifsglob.h   | 18 +++++++++---------
 fs/cifs/cifssmb.c    |  2 +-
 fs/cifs/connect.c    | 10 +++++-----
 fs/cifs/misc.c       | 12 ++++++------
 fs/cifs/smb2pdu.c    |  2 +-
 7 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 246a9bc972fe..2f0ca888330b 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -504,11 +504,11 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		atomic_set(&total_buf_alloc_count, 0);
 		atomic_set(&total_small_buf_alloc_count, 0);
 #endif /* CONFIG_CIFS_STATS2 */
-		atomic_set(&tcpSesReconnectCount, 0);
-		atomic_set(&tconInfoReconnectCount, 0);
+		atomic_set(&g_server_reconnect_count, 0);
+		atomic_set(&g_tcon_reconnect_count, 0);
 
 		spin_lock(&g_mid_lock);
-		GlobalMaxActiveXid = 0;
+		g_max_active_xid = 0;
 		g_current_xid = 0;
 		spin_unlock(&g_mid_lock);
 		spin_lock(&g_servers_lock);
@@ -554,12 +554,12 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 	struct cifs_tcon *tcon;
 
 	seq_printf(m, "Resources in use\nCIFS Session: %d\n",
-			sesInfoAllocCount.counter);
+			g_ses_alloc_count.counter);
 	seq_printf(m, "Share (unique mount targets): %d\n",
-			tconInfoAllocCount.counter);
+			g_tcon_alloc_count.counter);
 	seq_printf(m, "SMB Request/Response Buffer: %d Pool size: %d\n",
 			buf_alloc_count.counter,
-			cifs_min_rcv + tcpSesAllocCount.counter);
+			cifs_min_rcv + g_server_alloc_count.counter);
 	seq_printf(m, "SMB Small Req/Resp Buffer: %d Pool size: %d\n",
 			small_buf_alloc_count.counter, cifs_min_small);
 #ifdef CONFIG_CIFS_STATS2
@@ -571,11 +571,11 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "Operations (MIDs): %d\n", atomic_read(&mid_count));
 	seq_printf(m,
 		"\n%d session %d share reconnects\n",
-		tcpSesReconnectCount.counter, tconInfoReconnectCount.counter);
+		g_server_reconnect_count.counter, g_tcon_reconnect_count.counter);
 
 	seq_printf(m,
 		"Total vfs operations: %d maximum at one time: %d\n",
-		g_current_xid, GlobalMaxActiveXid);
+		g_current_xid, g_max_active_xid);
 
 	i = 0;
 	spin_lock(&g_servers_lock);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 88bee6544269..8083fffeac0a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1581,12 +1581,12 @@ init_cifs(void)
 /*
  *  Initialize Global counters
  */
-	atomic_set(&sesInfoAllocCount, 0);
-	atomic_set(&tconInfoAllocCount, 0);
-	atomic_set(&tcpSesNextId, 0);
-	atomic_set(&tcpSesAllocCount, 0);
-	atomic_set(&tcpSesReconnectCount, 0);
-	atomic_set(&tconInfoReconnectCount, 0);
+	atomic_set(&g_ses_alloc_count, 0);
+	atomic_set(&g_tcon_alloc_count, 0);
+	atomic_set(&g_server_next_id, 0);
+	atomic_set(&g_server_alloc_count, 0);
+	atomic_set(&g_server_reconnect_count, 0);
+	atomic_set(&g_tcon_reconnect_count, 0);
 
 	atomic_set(&buf_alloc_count, 0);
 	atomic_set(&small_buf_alloc_count, 0);
@@ -1603,7 +1603,7 @@ init_cifs(void)
 	atomic_set(&mid_count, 0);
 	g_current_xid = 0;
 	g_total_active_xid = 0;
-	GlobalMaxActiveXid = 0;
+	g_max_active_xid = 0;
 	spin_lock_init(&g_servers_lock);
 	spin_lock_init(&g_mid_lock);
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2701d741ddbd..fcaddcb07a90 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1958,20 +1958,20 @@ extern spinlock_t		g_servers_lock;
 /*
  * Global transaction id (XID) information
  */
-GLOBAL_EXTERN unsigned int g_current_xid;	/* protected by g_mid_lock */
+GLOBAL_EXTERN unsigned int g_current_xid; /* protected by g_mid_lock */
 GLOBAL_EXTERN unsigned int g_total_active_xid; /* prot by g_mid_lock */
-GLOBAL_EXTERN unsigned int g_max_active_xid	/* prot by g_mid_lock */
-GLOBAL_EXTERN spinlock_t g_mid_lock;  /* protects above & list operations */
+GLOBAL_EXTERN unsigned int g_max_active_xid; /* prot by g_mid_lock */
+GLOBAL_EXTERN spinlock_t g_mid_lock; /* protects above & list operations */
 					  /* on midQ entries */
 /*
  *  Global counters, updated atomically
  */
-GLOBAL_EXTERN atomic_t sesInfoAllocCount;
-GLOBAL_EXTERN atomic_t tconInfoAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesNextId;
-GLOBAL_EXTERN atomic_t tcpSesAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesReconnectCount;
-GLOBAL_EXTERN atomic_t tconInfoReconnectCount;
+GLOBAL_EXTERN atomic_t g_ses_alloc_count;
+GLOBAL_EXTERN atomic_t g_tcon_alloc_count;
+GLOBAL_EXTERN atomic_t g_server_next_id;
+GLOBAL_EXTERN atomic_t g_server_alloc_count;
+GLOBAL_EXTERN atomic_t g_server_reconnect_count;
+GLOBAL_EXTERN atomic_t g_tcon_reconnect_count;
 
 /* Various Debug counters */
 extern atomic_t buf_alloc_count;	/* current number allocated  */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 80ae1b280b11..ad9071372fa4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -248,7 +248,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		goto out;
 	}
 
-	atomic_inc(&tconInfoReconnectCount);
+	atomic_inc(&g_tcon_reconnect_count);
 
 	/* tell server Unix caps we support */
 	if (cap_unix(ses))
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e44e65cd53d2..3aa9c24731b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -412,7 +412,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			cifs_dbg(FYI, "%s: reconnect error %d\n", __func__, rc);
 			msleep(3000);
 		} else {
-			atomic_inc(&tcpSesReconnectCount);
+			atomic_inc(&g_server_reconnect_count);
 			set_credits(server, 1);
 			spin_lock(&g_servers_lock);
 			if (server->tcpStatus != CifsExiting)
@@ -539,7 +539,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		 * process waiting for reconnect will know it needs to re-establish session and tcon
 		 * through the reconnected target server.
 		 */
-		atomic_inc(&tcpSesReconnectCount);
+		atomic_inc(&g_server_reconnect_count);
 		set_credits(server, 1);
 		spin_lock(&g_servers_lock);
 		if (server->tcpStatus != CifsExiting)
@@ -994,7 +994,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 #endif
 	kfree(server);
 
-	length = atomic_dec_return(&tcpSesAllocCount);
+	length = atomic_dec_return(&g_server_alloc_count);
 	if (length > 0)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 }
@@ -1117,7 +1117,7 @@ cifs_demultiplex_thread(void *p)
 	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
 
-	length = atomic_inc_return(&tcpSesAllocCount);
+	length = atomic_inc_return(&g_server_alloc_count);
 	if (length > 1)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
@@ -1582,7 +1582,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	server->vals = ctx->vals;
 	cifs_set_net_ns(server, get_net(current->nsproxy->net_ns));
 
-	server->conn_id = atomic_inc_return(&tcpSesNextId);
+	server->conn_id = atomic_inc_return(&g_server_next_id);
 	server->noblockcnt = ctx->rootfs;
 	server->noblocksnd = ctx->noblocksnd || ctx->rootfs;
 	server->noautotune = ctx->noautotune;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 9f450a1c947a..8f2a06e47098 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -42,8 +42,8 @@ _get_xid(void)
 	g_total_active_xid++;
 
 	/* keep high water mark for number of simultaneous ops in filesystem */
-	if (g_total_active_xid > GlobalMaxActiveXid)
-		GlobalMaxActiveXid = g_total_active_xid;
+	if (g_total_active_xid > g_max_active_xid)
+		g_max_active_xid = g_total_active_xid;
 	if (g_total_active_xid > 65000)
 		cifs_dbg(FYI, "warning: more than 65000 requests active\n");
 	xid = g_current_xid++;
@@ -68,7 +68,7 @@ sesInfoAlloc(void)
 
 	ret_buf = kzalloc(sizeof(struct cifs_ses), GFP_KERNEL);
 	if (ret_buf) {
-		atomic_inc(&sesInfoAllocCount);
+		atomic_inc(&g_ses_alloc_count);
 		ret_buf->ses_status = SES_NEW;
 		++ret_buf->ses_count;
 		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
@@ -91,7 +91,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 		return;
 	}
 
-	atomic_dec(&sesInfoAllocCount);
+	atomic_dec(&g_ses_alloc_count);
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
@@ -123,7 +123,7 @@ tconInfoAlloc(void)
 	INIT_LIST_HEAD(&ret_buf->crfid.dirents.entries);
 	mutex_init(&ret_buf->crfid.dirents.de_mutex);
 
-	atomic_inc(&tconInfoAllocCount);
+	atomic_inc(&g_tcon_alloc_count);
 	ret_buf->status = TID_NEW;
 	++ret_buf->tc_count;
 	INIT_LIST_HEAD(&ret_buf->openFileList);
@@ -144,7 +144,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
 		cifs_dbg(FYI, "Null buffer passed to tconInfoFree\n");
 		return;
 	}
-	atomic_dec(&tconInfoAllocCount);
+	atomic_dec(&g_tcon_alloc_count);
 	kfree(buf_to_free->nativeFileSystem);
 	kfree_sensitive(buf_to_free->password);
 	kfree(buf_to_free->crfid.fid);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f103ece8a3c9..66c1f1afb453 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -321,7 +321,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (smb2_command != SMB2_INTERNAL_CMD)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
-	atomic_inc(&tconInfoReconnectCount);
+	atomic_inc(&g_tcon_reconnect_count);
 out:
 	/*
 	 * Check if handle based operation so we know whether we can continue
-- 
2.35.3

