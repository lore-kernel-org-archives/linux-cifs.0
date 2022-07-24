Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99512C43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiGXPL5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXPL4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:11:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE410FE2
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:11:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A78C05C7CD;
        Sun, 24 Jul 2022 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9flc+HX4t9QxEe1bK6VVbUKKonCuw/9M727Ca2j6wOQ=;
        b=XSsfnkQ9e6e21z5ZaBfyuUe9M6kULC8zq9HtdstExfiI89YZbq8Pzf0W1oqM1hoqMT2r4O
        dAuuWLU2zxn2qnqr1C9MZEodzMtiVPGxW6yvubPUawHYGSJ+uECQsFM4MLmbMjslJZgBXB
        aSJfoilfcR6KjbhOKT2XMvGlpSQIQBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675511;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9flc+HX4t9QxEe1bK6VVbUKKonCuw/9M727Ca2j6wOQ=;
        b=bpQvFQFVOEsQSQsdftzCl/W7j49FgkSyhqJMkM/61HljuNf1IEke6axcCz4H21csaBvglL
        tlqPseL4ISjOjpDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A588A13A8D;
        Sun, 24 Jul 2022 15:11:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AVwZGjZh3WL0MAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:11:50 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 01/14] cifs: rename servers list, lock, functions, and vars
Date:   Sun, 24 Jul 2022 12:11:24 -0300
Message-Id: <20220724151137.7538-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Renames:

- global tcp_ses_server_{list,lock} to g_servers_{list,lock}
  (prepend "g_" to indicate global, and "servers" is more direct than
  "tcp_ses")
- list_head in the server struct from "tcp_ses_list" to "server_head",
  as that is used as an element and not as a list per se
- all TCP_Server_Info variables from "tcp_*" to "servers" or something
  similar to their previous name
- functions that used "tcp_ses" or "tcp_session" in their names to use
  "server"

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    |  24 +--
 fs/cifs/cifs_debug.h    |   4 +-
 fs/cifs/cifsencrypt.c   |   6 +-
 fs/cifs/cifsfs.c        |  14 +-
 fs/cifs/cifsglob.h      |  20 +-
 fs/cifs/cifsproto.h     |  12 +-
 fs/cifs/cifssmb.c       |  34 +--
 fs/cifs/connect.c       | 457 ++++++++++++++++++++--------------------
 fs/cifs/dfs_cache.c     |   6 +-
 fs/cifs/ioctl.c         |   6 +-
 fs/cifs/misc.c          |  16 +-
 fs/cifs/sess.c          |   6 +-
 fs/cifs/smb2misc.c      |  28 +--
 fs/cifs/smb2ops.c       |  40 ++--
 fs/cifs/smb2pdu.c       |  30 +--
 fs/cifs/smb2transport.c |  44 ++--
 fs/cifs/transport.c     |  56 ++---
 17 files changed, 404 insertions(+), 399 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index aac4240893af..a8e05ab5c9bf 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -181,8 +181,8 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 #else
 	seq_printf(m, " <filename>\n");
 #endif /* CIFS_DEBUG2 */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
@@ -206,7 +206,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	seq_putc(m, '\n');
 	return 0;
 }
@@ -267,8 +267,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "\nServers: ");
 
 	c = 0;
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		/* channel info will be printed as a part of sessions below */
 		if (CIFS_SERVER_IS_CHAN(server))
 			continue;
@@ -479,7 +479,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	if (c == 0)
 		seq_printf(m, "\n\t[NONE]");
 
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	seq_putc(m, '\n');
 	cifs_swn_dump(m);
 
@@ -511,8 +511,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		GlobalMaxActiveXid = 0;
 		GlobalCurrentXid = 0;
 		spin_unlock(&GlobalMid_Lock);
-		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		spin_lock(&g_servers_lock);
+		list_for_each_entry(server, &g_servers_list, server_head) {
 			server->max_in_flight = 0;
 #ifdef CONFIG_CIFS_STATS2
 			for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
@@ -535,7 +535,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				}
 			}
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else {
 		return rc;
 	}
@@ -578,8 +578,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 		GlobalCurrentXid, GlobalMaxActiveXid);
 
 	i = 0;
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		seq_printf(m, "\nMax requests in flight: %d", server->max_in_flight);
 #ifdef CONFIG_CIFS_STATS2
 		seq_puts(m, "\nTotal time spent processing by command. Time ");
@@ -611,7 +611,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	seq_putc(m, '\n');
 	return 0;
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index ee4ea2b60c0f..9e19f6c5f75b 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -14,8 +14,8 @@
 
 #define pr_fmt(fmt) "CIFS: " fmt
 
-void cifs_dump_mem(char *label, void *data, int length);
-void cifs_dump_detail(void *buf, struct TCP_Server_Info *ptcp_info);
+void cifs_dump_mem(char *, void *, int );
+void cifs_dump_detail(void *, struct TCP_Server_Info *);
 void cifs_dump_mids(struct TCP_Server_Info *);
 extern bool traceSMB;		/* flag which enables the function below */
 void dump_smb(void *, int);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 663cb9db4908..a416b87fbe1a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -141,13 +141,13 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	if ((cifs_pdu == NULL) || (server == NULL))
 		return -EINVAL;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
 	    server->tcpStatus == CifsNeedNegotiate) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return rc;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	if (!server->session_estab) {
 		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f909d9e9faaa..f40dffbc363d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -75,8 +75,8 @@ atomic_t small_buf_alloc_count;
 atomic_t total_buf_alloc_count;
 atomic_t total_small_buf_alloc_count;
 #endif/* STATS2 */
-struct list_head	cifs_tcp_ses_list;
-spinlock_t		cifs_tcp_ses_lock;
+struct list_head	g_servers_list;
+spinlock_t		g_servers_lock;
 static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
 module_param(CIFSMaxBufSize, uint, 0444);
@@ -711,16 +711,16 @@ static void cifs_umount_begin(struct super_block *sb)
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
 		/* we have other mounts to same share or we have
 		   already tried to force umount this and woken up
 		   all waiting network requests, nothing to do */
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	} else if (tcon->tc_count == 1)
 		tcon->status = TID_EXITING;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
@@ -1577,7 +1577,7 @@ init_cifs(void)
 {
 	int rc = 0;
 	cifs_proc_init();
-	INIT_LIST_HEAD(&cifs_tcp_ses_list);
+	INIT_LIST_HEAD(&g_servers_list);
 /*
  *  Initialize Global counters
  */
@@ -1604,7 +1604,7 @@ init_cifs(void)
 	GlobalCurrentXid = 0;
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
-	spin_lock_init(&cifs_tcp_ses_lock);
+	spin_lock_init(&g_servers_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
 	cifs_lock_secret = get_random_u32();
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9b7f409bfc8c..79b14f5f6afe 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -603,7 +603,7 @@ inc_rfc1001_len(void *buf, int count)
 }
 
 struct TCP_Server_Info {
-	struct list_head tcp_ses_list;
+	struct list_head server_head;
 	struct list_head smb_ses_list;
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
@@ -611,7 +611,7 @@ struct TCP_Server_Info {
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
 	struct smb_version_values	*vals;
-	/* updates to tcpStatus protected by cifs_tcp_ses_lock */
+	/* updates to tcpStatus protected by g_servers_lock */
 	enum statusEnum tcpStatus; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
@@ -1011,7 +1011,7 @@ struct cifs_ses {
 	struct mutex session_mutex;
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
-	enum ses_status_enum ses_status;  /* updates protected by cifs_tcp_ses_lock */
+	enum ses_status_enum ses_status;  /* updates protected by g_servers_lock */
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
@@ -1910,7 +1910,7 @@ require use of the stronger protocol */
  *      list operations on global DnotifyReqList
  *      updates to ses->status and TCP_Server_Info->tcpStatus
  *      updates to server->CurrentMid
- *  tcp_ses_lock protects:
+ *  g_servers_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
  *  inode->open_file_lock protects the openFileList hanging off the inode
@@ -1937,23 +1937,23 @@ require use of the stronger protocol */
 /*
  * the list of TCP_Server_Info structures, ie each of the sockets
  * connecting our client to a distinct server (ip address), is
- * chained together by cifs_tcp_ses_list. The list of all our SMB
+ * chained together by g_servers_list. The list of all our SMB
  * sessions (and from that the tree connections) can be found
- * by iterating over cifs_tcp_ses_list
+ * by iterating over g_servers_list
  */
-extern struct list_head		cifs_tcp_ses_list;
+extern struct list_head		g_servers_list;
 
 /*
- * This lock protects the cifs_tcp_ses_list, the list of smb sessions per
+ * This lock protects the g_servers_list, the list of smb sessions per
  * tcp session, and the list of tcon's per smb session. It also protects
  * the reference counters for the server, smb session, and tcon. It also
  * protects some fields in the TCP_Server_Info struct such as dstaddr. Finally,
  * changes to the tcon->tidStatus should be done while holding this lock.
- * generally the locks should be taken in order tcp_ses_lock before
+ * generally the locks should be taken in order g_servers_lock before
  * tcon->open_file_lock and that before file->file_info_lock since the
  * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
  */
-extern spinlock_t		cifs_tcp_ses_lock;
+extern spinlock_t		g_servers_lock;
 
 /*
  * Global transaction id (XID) information
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d59aebefa71c..3e161861b362 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -135,7 +135,7 @@ void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
 void
-cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
+cifs_mark_server_conns_for_reconnect(struct TCP_Server_Info *server,
 				      bool mark_smb_session);
 extern int cifs_reconnect(struct TCP_Server_Info *server,
 			  bool mark_smb_session);
@@ -278,9 +278,9 @@ extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
 				const char *path);
 extern struct TCP_Server_Info *
-cifs_get_tcp_session(struct smb3_fs_context *ctx,
+cifs_get_server(struct smb3_fs_context *ctx,
 		     struct TCP_Server_Info *primary_server);
-extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
+extern void cifs_put_server(struct TCP_Server_Info *server,
 				 int from_reconnect);
 extern void cifs_put_tcon(struct cifs_tcon *tcon);
 
@@ -564,7 +564,7 @@ extern int
 cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const char *devname);
 
 extern struct TCP_Server_Info *
-cifs_find_tcp_session(struct smb3_fs_context *ctx);
+cifs_find_server(struct smb3_fs_context *ctx);
 
 extern void cifs_put_smb_ses(struct cifs_ses *ses);
 
@@ -650,8 +650,8 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 			       int resp_buftype,
 			       struct cifs_search_info *srch_inf);
 
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
-void cifs_put_tcp_super(struct super_block *sb);
+struct super_block *cifs_get_server_super(struct TCP_Server_Info *server);
+void cifs_put_server_super(struct super_block *sb);
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
 char *extract_sharename(const char *unc);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9ed21752f2df..80ae1b280b11 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -74,13 +74,13 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	struct list_head *tmp1;
 
 	/* only send once per connect */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((tcon->ses->ses_status != SES_GOOD) || (tcon->status != TID_NEED_RECON)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 	tcon->status = TID_IN_FILES_INVALIDATE;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/* list all files open on tree connection and mark them invalid */
 	spin_lock(&tcon->open_file_lock);
@@ -98,10 +98,10 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
 	mutex_unlock(&tcon->crfid.fid_mutex);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
 		tcon->status = TID_NEED_TCON;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/*
 	 * BB Add call to invalidate_inodes(sb) for all superblocks mounted
@@ -134,18 +134,18 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * only tree disconnect, open, and write, (and ulogoff which does not
 	 * have tcon) are allowed as we start force umount
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->status == TID_EXITING) {
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb_command);
 			return -ENODEV;
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	retries = server->nr_targets;
 
@@ -165,12 +165,12 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		}
 
 		/* are we still trying to reconnect? */
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			break;
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		if (retries && --retries)
 			continue;
@@ -201,13 +201,13 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * and the server never sends an answer the socket will be closed
 	 * and tcpStatus set to reconnect.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -432,15 +432,15 @@ decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 	if (count < SMB1_CLIENT_GUID_SIZE)
 		return -EIO;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->srv_count > 1) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		if (memcmp(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE) != 0) {
 			cifs_dbg(FYI, "server UID changed\n");
 			memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
 		}
 	} else {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
 	}
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6e670e7c2182..c0e712917fd6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -119,10 +119,10 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 		goto requeue_resolve;
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	rc = cifs_convert_address((struct sockaddr *)&server->dstaddr, ipaddr,
 				  strlen(ipaddr));
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	kfree(ipaddr);
 
 	/* rc == 1 means success here */
@@ -205,10 +205,10 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	/* If server is a channel, select the primary channel */
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (!all_channels) {
 		pserver->tcpStatus = CifsNeedReconnect;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 
@@ -218,7 +218,7 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
 		spin_unlock(&ses->chan_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 }
 
 /*
@@ -232,7 +232,7 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
  * @mark_smb_session: whether even sessions need to be marked
  */
 void
-cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
+cifs_mark_server_conns_for_reconnect(struct TCP_Server_Info *server,
 				      bool mark_smb_session)
 {
 	struct TCP_Server_Info *pserver;
@@ -249,7 +249,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
 
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
 		/* check if iface is still active */
 		if (!cifs_chan_is_iface_active(ses, server)) {
@@ -258,9 +258,9 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			 * cifs_chan_update_iface to avoid deadlock
 			 */
 			ses->ses_count++;
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_chan_update_iface(ses, server);
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&g_servers_lock);
 			ses->ses_count--;
 		}
 
@@ -289,7 +289,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 next_session:
 		spin_unlock(&ses->chan_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 }
 
 static void
@@ -348,13 +348,13 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	}
 }
 
-static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
+static bool cifs_server_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
 {
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	server->nr_targets = num_targets;
 	if (server->tcpStatus == CifsExiting) {
 		/* the demux thread will exit normally next time through the loop */
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		wake_up(&server->response_q);
 		return false;
 	}
@@ -364,7 +364,7 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 			     server->hostname);
 	server->tcpStatus = CifsNeedReconnect;
 
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	return true;
 }
 
@@ -386,10 +386,10 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 {
 	int rc = 0;
 
-	if (!cifs_tcp_ses_needs_reconnect(server, 1))
+	if (!cifs_server_needs_reconnect(server, 1))
 		return 0;
 
-	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
+	cifs_mark_server_conns_for_reconnect(server, mark_smb_session);
 
 	cifs_abort_connection(server);
 
@@ -414,20 +414,20 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
 			set_credits(server, 1);
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&g_servers_lock);
 			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsNeedNegotiate;
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
 			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	wake_up(&server->response_q);
 	return rc;
@@ -510,7 +510,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	if (!num_targets)
 		num_targets = 1;
 
-	if (!cifs_tcp_ses_needs_reconnect(server, num_targets))
+	if (!cifs_server_needs_reconnect(server, num_targets))
 		return 0;
 
 	/*
@@ -518,7 +518,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	 * different server or share during failover.  It could be improved by adding some logic to
 	 * only do that in case it connects to a different server or share, though.
 	 */
-	cifs_mark_tcp_ses_conns_for_reconnect(server, true);
+	cifs_mark_server_conns_for_reconnect(server, true);
 
 	cifs_abort_connection(server);
 
@@ -541,10 +541,10 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		 */
 		atomic_inc(&tcpSesReconnectCount);
 		set_credits(server, 1);
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus != CifsExiting)
 			server->tcpStatus = CifsNeedNegotiate;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
@@ -556,11 +556,11 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 	dfs_cache_free_tgts(&tl);
 
 	/* Need to set up echo worker again once connection has been established */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	wake_up(&server->response_q);
 	return rc;
@@ -569,12 +569,12 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
 {
 	/* If tcp session is not an dfs connection, then reconnect to last target server */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (!server->is_dfs_conn) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return __cifs_reconnect(server, mark_smb_session);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	mutex_lock(&server->refpath_lock);
 	if (!server->origin_fullpath || !server->leaf_fullpath) {
@@ -670,18 +670,18 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		cifs_server_dbg(VFS, "has not responded in %lu seconds. Reconnecting...\n",
 			 (3 * server->echo_interval) / HZ);
 		cifs_reconnect(server, false);
 		return true;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	return false;
 }
@@ -726,18 +726,18 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 		else
 			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus == CifsExiting) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			return -ESHUTDOWN;
 		}
 
 		if (server->tcpStatus == CifsNeedReconnect) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_reconnect(server, false);
 			return -ECONNABORTED;
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		if (length == -ERESTARTSYS ||
 		    length == -EAGAIN ||
@@ -908,16 +908,16 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	int length;
 
 	/* take it off the list, if it's not already */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_del_init(&server->tcp_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
+	list_del_init(&server->server_head);
+	spin_unlock(&g_servers_lock);
 
 	cancel_delayed_work_sync(&server->echo);
 	cancel_delayed_work_sync(&server->resolve);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	server->tcpStatus = CifsExiting;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	wake_up_all(&server->response_q);
 
 	/* check if we have blocked requests that need to free */
@@ -1464,12 +1464,12 @@ static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *
 }
 
 struct TCP_Server_Info *
-cifs_find_tcp_session(struct smb3_fs_context *ctx)
+cifs_find_server(struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server;
 
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 #ifdef CONFIG_CIFS_DFS_UPCALL
 		/*
 		 * DFS failover implementation in cifs_reconnect() requires unique tcp sessions for
@@ -1488,22 +1488,22 @@ cifs_find_tcp_session(struct smb3_fs_context *ctx)
 			continue;
 
 		++server->srv_count;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		cifs_dbg(FYI, "Existing tcp session with server found\n");
 		return server;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	return NULL;
 }
 
 void
-cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
+cifs_put_server(struct TCP_Server_Info *server, int from_reconnect)
 {
 	struct task_struct *task;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (--server->srv_count > 0) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 
@@ -1512,12 +1512,12 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	put_net(cifs_net_ns(server));
 
-	list_del_init(&server->tcp_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	list_del_init(&server->server_head);
+	spin_unlock(&g_servers_lock);
 
 	/* For secondary channels, we pick up ref-count on the primary server */
 	if (CIFS_SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server->primary_server, from_reconnect);
+		cifs_put_server(server->primary_server, from_reconnect);
 
 	cancel_delayed_work_sync(&server->echo);
 	cancel_delayed_work_sync(&server->resolve);
@@ -1525,7 +1525,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	if (from_reconnect)
 		/*
 		 * Avoid deadlock here: reconnect work calls
-		 * cifs_put_tcp_session() at its end. Need to be sure
+		 * cifs_put_server() at its end. Need to be sure
 		 * that reconnect work does nothing with server pointer after
 		 * that step.
 		 */
@@ -1533,9 +1533,9 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	server->tcpStatus = CifsExiting;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	cifs_crypto_secmech_release(server);
 
@@ -1550,107 +1550,107 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 }
 
 struct TCP_Server_Info *
-cifs_get_tcp_session(struct smb3_fs_context *ctx,
+cifs_get_server(struct smb3_fs_context *ctx,
 		     struct TCP_Server_Info *primary_server)
 {
-	struct TCP_Server_Info *tcp_ses = NULL;
+	struct TCP_Server_Info *server = NULL;
 	int rc;
 
 	cifs_dbg(FYI, "UNC: %s\n", ctx->UNC);
 
-	/* see if we already have a matching tcp_ses */
-	tcp_ses = cifs_find_tcp_session(ctx);
-	if (tcp_ses)
-		return tcp_ses;
+	/* see if we already have a matching server */
+	server = cifs_find_server(ctx);
+	if (server)
+		return server;
 
-	tcp_ses = kzalloc(sizeof(struct TCP_Server_Info), GFP_KERNEL);
-	if (!tcp_ses) {
+	server = kzalloc(sizeof(struct TCP_Server_Info), GFP_KERNEL);
+	if (!server) {
 		rc = -ENOMEM;
 		goto out_err;
 	}
 
-	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
-	if (!tcp_ses->hostname) {
+	server->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
+	if (!server->hostname) {
 		rc = -ENOMEM;
 		goto out_err;
 	}
 
 	if (ctx->nosharesock)
-		tcp_ses->nosharesock = true;
-
-	tcp_ses->ops = ctx->ops;
-	tcp_ses->vals = ctx->vals;
-	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
-
-	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
-	tcp_ses->noblockcnt = ctx->rootfs;
-	tcp_ses->noblocksnd = ctx->noblocksnd || ctx->rootfs;
-	tcp_ses->noautotune = ctx->noautotune;
-	tcp_ses->tcp_nodelay = ctx->sockopt_tcp_nodelay;
-	tcp_ses->rdma = ctx->rdma;
-	tcp_ses->in_flight = 0;
-	tcp_ses->max_in_flight = 0;
-	tcp_ses->credits = 1;
+		server->nosharesock = true;
+
+	server->ops = ctx->ops;
+	server->vals = ctx->vals;
+	cifs_set_net_ns(server, get_net(current->nsproxy->net_ns));
+
+	server->conn_id = atomic_inc_return(&tcpSesNextId);
+	server->noblockcnt = ctx->rootfs;
+	server->noblocksnd = ctx->noblocksnd || ctx->rootfs;
+	server->noautotune = ctx->noautotune;
+	server->tcp_nodelay = ctx->sockopt_tcp_nodelay;
+	server->rdma = ctx->rdma;
+	server->in_flight = 0;
+	server->max_in_flight = 0;
+	server->credits = 1;
 	if (primary_server) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		++primary_server->srv_count;
-		tcp_ses->primary_server = primary_server;
-		spin_unlock(&cifs_tcp_ses_lock);
-	}
-	init_waitqueue_head(&tcp_ses->response_q);
-	init_waitqueue_head(&tcp_ses->request_q);
-	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
-	mutex_init(&tcp_ses->_srv_mutex);
-	memcpy(tcp_ses->workstation_RFC1001_name,
+		server->primary_server = primary_server;
+		spin_unlock(&g_servers_lock);
+	}
+	init_waitqueue_head(&server->response_q);
+	init_waitqueue_head(&server->request_q);
+	INIT_LIST_HEAD(&server->pending_mid_q);
+	mutex_init(&server->_srv_mutex);
+	memcpy(server->workstation_RFC1001_name,
 		ctx->source_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
-	memcpy(tcp_ses->server_RFC1001_name,
+	memcpy(server->server_RFC1001_name,
 		ctx->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
-	tcp_ses->session_estab = false;
-	tcp_ses->sequence_number = 0;
-	tcp_ses->reconnect_instance = 1;
-	tcp_ses->lstrp = jiffies;
-	tcp_ses->compress_algorithm = cpu_to_le16(ctx->compression);
-	spin_lock_init(&tcp_ses->req_lock);
-	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
-	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
-	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-	INIT_DELAYED_WORK(&tcp_ses->resolve, cifs_resolve_server);
-	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
-	mutex_init(&tcp_ses->reconnect_mutex);
+	server->session_estab = false;
+	server->sequence_number = 0;
+	server->reconnect_instance = 1;
+	server->lstrp = jiffies;
+	server->compress_algorithm = cpu_to_le16(ctx->compression);
+	spin_lock_init(&server->req_lock);
+	INIT_LIST_HEAD(&server->server_head);
+	INIT_LIST_HEAD(&server->smb_ses_list);
+	INIT_DELAYED_WORK(&server->echo, cifs_echo_request);
+	INIT_DELAYED_WORK(&server->resolve, cifs_resolve_server);
+	INIT_DELAYED_WORK(&server->reconnect, smb2_reconnect_server);
+	mutex_init(&server->reconnect_mutex);
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	mutex_init(&tcp_ses->refpath_lock);
+	mutex_init(&server->refpath_lock);
 #endif
-	memcpy(&tcp_ses->srcaddr, &ctx->srcaddr,
-	       sizeof(tcp_ses->srcaddr));
-	memcpy(&tcp_ses->dstaddr, &ctx->dstaddr,
-		sizeof(tcp_ses->dstaddr));
+	memcpy(&server->srcaddr, &ctx->srcaddr,
+	       sizeof(server->srcaddr));
+	memcpy(&server->dstaddr, &ctx->dstaddr,
+		sizeof(server->dstaddr));
 	if (ctx->use_client_guid)
-		memcpy(tcp_ses->client_guid, ctx->client_guid,
+		memcpy(server->client_guid, ctx->client_guid,
 		       SMB2_CLIENT_GUID_SIZE);
 	else
-		generate_random_uuid(tcp_ses->client_guid);
+		generate_random_uuid(server->client_guid);
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this init of tcpStatus or srv_count
 	 */
-	tcp_ses->tcpStatus = CifsNew;
-	++tcp_ses->srv_count;
+	server->tcpStatus = CifsNew;
+	++server->srv_count;
 
 	if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
 		ctx->echo_interval <= SMB_ECHO_INTERVAL_MAX)
-		tcp_ses->echo_interval = ctx->echo_interval * HZ;
+		server->echo_interval = ctx->echo_interval * HZ;
 	else
-		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
-	if (tcp_ses->rdma) {
+		server->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
+	if (server->rdma) {
 #ifndef CONFIG_CIFS_SMB_DIRECT
 		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
 		rc = -ENOENT;
 		goto out_err_crypto_release;
 #endif
-		tcp_ses->smbd_conn = smbd_get_connection(
-			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
-		if (tcp_ses->smbd_conn) {
+		server->smbd_conn = smbd_get_connection(
+			server, (struct sockaddr *)&ctx->dstaddr);
+		if (server->smbd_conn) {
 			cifs_dbg(VFS, "RDMA transport established\n");
 			rc = 0;
 			goto smbd_connected;
@@ -1659,7 +1659,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			goto out_err_crypto_release;
 		}
 	}
-	rc = ip_connect(tcp_ses);
+	rc = ip_connect(server);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
@@ -1670,60 +1670,60 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
-				  tcp_ses, "cifsd");
-	if (IS_ERR(tcp_ses->tsk)) {
-		rc = PTR_ERR(tcp_ses->tsk);
+	server->tsk = kthread_run(cifs_demultiplex_thread,
+				  server, "cifsd");
+	if (IS_ERR(server->tsk)) {
+		rc = PTR_ERR(server->tsk);
 		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
 		module_put(THIS_MODULE);
 		goto out_err_crypto_release;
 	}
-	tcp_ses->min_offload = ctx->min_offload;
+	server->min_offload = ctx->min_offload;
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this update of tcpStatus
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
-	tcp_ses->tcpStatus = CifsNeedNegotiate;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
+	server->tcpStatus = CifsNeedNegotiate;
+	spin_unlock(&g_servers_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
-		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+		server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
 	else
-		tcp_ses->max_credits = ctx->max_credits;
+		server->max_credits = ctx->max_credits;
 
-	tcp_ses->nr_targets = 1;
-	tcp_ses->ignore_signature = ctx->ignore_signature;
+	server->nr_targets = 1;
+	server->ignore_signature = ctx->ignore_signature;
 	/* thread spawned, put it on the list */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
+	list_add(&server->server_head, &g_servers_list);
+	spin_unlock(&g_servers_lock);
 
 	/* queue echo request delayed work */
-	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
+	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
 
 	/* queue dns resolution delayed work */
 	cifs_dbg(FYI, "%s: next dns resolution scheduled for %d seconds in the future\n",
 		 __func__, SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
 
-	queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
+	queue_delayed_work(cifsiod_wq, &server->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
 
-	return tcp_ses;
+	return server;
 
 out_err_crypto_release:
-	cifs_crypto_secmech_release(tcp_ses);
+	cifs_crypto_secmech_release(server);
 
-	put_net(cifs_net_ns(tcp_ses));
+	put_net(cifs_net_ns(server));
 
 out_err:
-	if (tcp_ses) {
-		if (CIFS_SERVER_IS_CHAN(tcp_ses))
-			cifs_put_tcp_session(tcp_ses->primary_server, false);
-		kfree(tcp_ses->hostname);
-		if (tcp_ses->ssocket)
-			sock_release(tcp_ses->ssocket);
-		kfree(tcp_ses);
+	if (server) {
+		if (CIFS_SERVER_IS_CHAN(server))
+			cifs_put_server(server->primary_server, false);
+		kfree(server->hostname);
+		if (server->ssocket)
+			sock_release(server->ssocket);
+		kfree(server);
 	}
 	return ERR_PTR(rc);
 }
@@ -1861,17 +1861,17 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
 	struct cifs_ses *ses;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		if (ses->ses_status == SES_EXITING)
 			continue;
 		if (!match_session(ses, ctx))
 			continue;
 		++ses->ses_count;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return ses;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	return NULL;
 }
 
@@ -1881,9 +1881,9 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	unsigned int chan_count;
 	struct TCP_Server_Info *server = ses->server;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (ses->ses_status == SES_EXITING) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 
@@ -1891,7 +1891,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	cifs_dbg(FYI, "%s: ses ipc: %s\n", __func__, ses->tcon_ipc ? ses->tcon_ipc->treeName : "NONE");
 
 	if (--ses->ses_count > 0) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 
@@ -1900,7 +1900,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 
 	if (ses->ses_status == SES_GOOD)
 		ses->ses_status = SES_EXITING;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	cifs_free_ipc(ses);
 
@@ -1913,9 +1913,9 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 		_free_xid(xid);
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_del_init(&ses->smb_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	chan_count = ses->chan_count;
 
@@ -1928,13 +1928,13 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 				kref_put(&ses->chans[i].iface->refcount, release_iface);
 				ses->chans[i].iface = NULL;
 			}
-			cifs_put_tcp_session(ses->chans[i].server, 0);
+			cifs_put_server(ses->chans[i].server, 0);
 			ses->chans[i].server = NULL;
 		}
 	}
 
 	sesInfoFree(ses);
-	cifs_put_tcp_session(server, 0);
+	cifs_put_server(server, 0);
 }
 
 #ifdef CONFIG_KEYS
@@ -2146,7 +2146,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 		spin_unlock(&ses->chan_lock);
 
 		/* existing SMB ses has a server reference already */
-		cifs_put_tcp_session(server, 0);
+		cifs_put_server(server, 0);
 		free_xid(xid);
 		return ses;
 	}
@@ -2219,9 +2219,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	 * note: the session becomes active soon after this. So you'll
 	 * need to lock before changing something in the session.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	free_xid(xid);
 
@@ -2259,15 +2259,15 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	struct cifs_tcon *tcon;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (!match_tcon(tcon, ctx))
 			continue;
 		++tcon->tc_count;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return tcon;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	return NULL;
 }
 
@@ -2286,9 +2286,9 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 
 	ses = tcon->ses;
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (--tcon->tc_count > 0) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
 
@@ -2296,7 +2296,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	WARN_ON(tcon->tc_count < 0);
 
 	list_del_init(&tcon->tcon_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/* cancel polling of interfaces */
 	cancel_delayed_work_sync(&tcon->query_interfaces);
@@ -2544,9 +2544,9 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	return tcon;
 
@@ -2643,27 +2643,27 @@ cifs_match_super(struct super_block *sb, void *data)
 	struct cifs_mnt_data *mnt_data = data;
 	struct smb3_fs_context *ctx;
 	struct cifs_sb_info *cifs_sb;
-	struct TCP_Server_Info *tcp_srv;
+	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
 	int rc = 0;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	cifs_sb = CIFS_SB(sb);
 	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 	if (tlink == NULL) {
 		/* can not match superblock if tlink were ever null */
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 	tcon = tlink_tcon(tlink);
 	ses = tcon->ses;
-	tcp_srv = ses->server;
+	server = ses->server;
 
 	ctx = mnt_data->ctx;
 
-	if (!match_server(tcp_srv, ctx) ||
+	if (!match_server(server, ctx) ||
 	    !match_session(ses, ctx) ||
 	    !match_tcon(tcon, ctx) ||
 	    !match_prepath(sb, mnt_data)) {
@@ -2673,7 +2673,7 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	rc = compare_mount_options(sb, mnt_data);
 out:
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	cifs_put_tlink(tlink);
 	return rc;
 }
@@ -3118,7 +3118,7 @@ static inline void mount_put_conns(struct mount_ctx *mnt_ctx)
 	else if (mnt_ctx->ses)
 		cifs_put_smb_ses(mnt_ctx->ses);
 	else if (mnt_ctx->server)
-		cifs_put_tcp_session(mnt_ctx->server, 0);
+		cifs_put_server(mnt_ctx->server, 0);
 	mnt_ctx->cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_POSIX_PATHS;
 	free_xid(mnt_ctx->xid);
 }
@@ -3137,7 +3137,7 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 	xid = get_xid();
 
 	/* get a reference to a tcp session */
-	server = cifs_get_tcp_session(ctx, NULL);
+	server = cifs_get_server(ctx, NULL);
 	if (IS_ERR(server)) {
 		rc = PTR_ERR(server);
 		server = NULL;
@@ -3178,15 +3178,15 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 		 * for just this mount.
 		 */
 		reset_cifs_unix_caps(xid, tcon, cifs_sb, ctx);
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if ((tcon->ses->server->tcpStatus == CifsNeedReconnect) &&
 		    (le64_to_cpu(tcon->fsUnixInfo.Capability) &
 		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			rc = -EACCES;
 			goto out;
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else
 		tcon->unix_ext = 0; /* server does not support them */
 
@@ -3269,9 +3269,9 @@ static int mount_get_dfs_conns(struct mount_ctx *mnt_ctx)
 	rc = mount_get_conns(mnt_ctx);
 	if (mnt_ctx->server) {
 		cifs_dbg(FYI, "%s: marking tcp session as a dfs connection\n", __func__);
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		mnt_ctx->server->is_dfs_conn = true;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	}
 	return rc;
 }
@@ -3514,9 +3514,9 @@ static int is_path_remote(struct mount_ctx *mnt_ctx)
 static void set_root_ses(struct mount_ctx *mnt_ctx)
 {
 	if (mnt_ctx->ses) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		mnt_ctx->ses->ses_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		dfs_cache_add_refsrv_session(&mnt_ctx->mount_id, mnt_ctx->ses);
 	}
 	mnt_ctx->root_ses = mnt_ctx->ses;
@@ -3986,28 +3986,28 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 		return -ENOSYS;
 
 	/* only send once per connect */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (!server->ops->need_neg(server) ||
 	    server->tcpStatus != CifsNeedNegotiate) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 	server->tcpStatus = CifsInNegotiate;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
 	if (rc == 0) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus == CifsInNegotiate)
 			server->tcpStatus = CifsGood;
 		else
 			rc = -EHOSTDOWN;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus == CifsInNegotiate)
 			server->tcpStatus = CifsNeedNegotiate;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	}
 
 	return rc;
@@ -4023,7 +4023,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
 	bool is_binding = false;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->dstaddr.ss_family == AF_INET6)
 		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
 	else
@@ -4032,7 +4032,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 
@@ -4041,7 +4041,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (CIFS_ALL_CHANS_GOOD(ses) ||
 	    cifs_chan_in_reconnect(ses, server)) {
 		spin_unlock(&ses->chan_lock);
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
@@ -4050,7 +4050,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 
 	if (!is_binding)
 		ses->ses_status = SES_IN_SETUP;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	if (!is_binding) {
 		ses->capabilities = server->capabilities;
@@ -4074,22 +4074,22 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 
 	if (rc) {
 		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (ses->ses_status == SES_IN_SETUP)
 			ses->ses_status = SES_NEED_RECON;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		spin_unlock(&ses->chan_lock);
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (ses->ses_status == SES_IN_SETUP)
 			ses->ses_status = SES_GOOD;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		cifs_chan_clear_need_reconnect(ses, server);
 		spin_unlock(&ses->chan_lock);
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	}
 
 	return rc;
@@ -4146,14 +4146,14 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	}
 
 	/* get a reference for the same TCP session */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	++master_tcon->ses->server->srv_count;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	ses = cifs_get_smb_ses(master_tcon->ses->server, ctx);
 	if (IS_ERR(ses)) {
 		tcon = (struct cifs_tcon *)ses;
-		cifs_put_tcp_session(master_tcon->ses->server, 0);
+		cifs_put_server(master_tcon->ses->server, 0);
 		goto out;
 	}
 
@@ -4400,8 +4400,10 @@ static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb
 	return rc;
 }
 
-static int target_share_matches_server(struct TCP_Server_Info *server, const char *tcp_host,
-				       size_t tcp_host_len, char *share, bool *target_match)
+static int target_share_matches_server(struct TCP_Server_Info *server,
+				       const char *server_name,
+				       size_t server_name_len, char *share,
+				       bool *target_match)
 {
 	int rc = 0;
 	const char *dfs_host;
@@ -4411,12 +4413,15 @@ static int target_share_matches_server(struct TCP_Server_Info *server, const cha
 	extract_unc_hostname(share, &dfs_host, &dfs_host_len);
 
 	/* Check if hostnames or addresses match */
-	if (dfs_host_len != tcp_host_len || strncasecmp(dfs_host, tcp_host, dfs_host_len) != 0) {
-		cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__, (int)dfs_host_len,
-			 dfs_host, (int)tcp_host_len, tcp_host);
+	if (dfs_host_len != server_name_len ||
+	    strncasecmp(dfs_host, server_name, dfs_host_len) != 0) {
+		cifs_dbg(FYI, "%s: %.*s doesn't match %.*s\n", __func__,
+			 (int)dfs_host_len, dfs_host, (int)server_name_len,
+			 server_name);
 		rc = match_target_ip(server, dfs_host, dfs_host_len, target_match);
 		if (rc)
-			cifs_dbg(VFS, "%s: failed to match target ip: %d\n", __func__, rc);
+			cifs_dbg(VFS, "%s: failed to match target ip: %d\n",
+				 __func__, rc);
 	}
 	return rc;
 }
@@ -4430,12 +4435,12 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 	const struct smb_version_operations *ops = server->ops;
 	struct cifs_tcon *ipc = tcon->ses->tcon_ipc;
 	char *share = NULL, *prefix = NULL;
-	const char *tcp_host;
-	size_t tcp_host_len;
+	const char *server_name;
+	size_t server_name_len;
 	struct dfs_cache_tgt_iterator *tit;
 	bool target_match;
 
-	extract_unc_hostname(server->hostname, &tcp_host, &tcp_host_len);
+	extract_unc_hostname(server->hostname, &server_name, &server_name_len);
 
 	tit = dfs_cache_get_tgt_iterator(tl);
 	if (!tit) {
@@ -4459,7 +4464,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 			break;
 		}
 
-		rc = target_share_matches_server(server, tcp_host, tcp_host_len, share,
+		rc = target_share_matches_server(server, server_name, server_name_len, share,
 						 &target_match);
 		if (rc)
 			break;
@@ -4553,15 +4558,15 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	struct dfs_info3_param ref = {0};
 
 	/* only send once per connect */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->ses->ses_status != SES_GOOD ||
 	    (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 	tcon->status = TID_IN_TCON;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
 	if (!tree) {
@@ -4575,7 +4580,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		goto out;
 	}
 
-	sb = cifs_get_tcp_super(server);
+	sb = cifs_get_server_super(server);
 	if (IS_ERR(sb)) {
 		rc = PTR_ERR(sb);
 		cifs_dbg(VFS, "%s: could not find superblock: %d\n", __func__, rc);
@@ -4597,18 +4602,18 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 out:
 	kfree(tree);
-	cifs_put_tcp_super(sb);
+	cifs_put_server_super(sb);
 
 	if (rc) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_NEED_TCON;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_GOOD;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
 
@@ -4621,27 +4626,27 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	const struct smb_version_operations *ops = tcon->ses->server->ops;
 
 	/* only send once per connect */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->ses->ses_status != SES_GOOD ||
 	    (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
 	tcon->status = TID_IN_TCON;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
 	if (rc) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_NEED_TCON;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	} else {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_GOOD;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
 
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 34a8f3baed5e..2e63ba80c893 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1524,8 +1524,8 @@ static void refresh_mounts(struct cifs_ses **sessions)
 
 	INIT_LIST_HEAD(&tcons);
 
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		if (!server->is_dfs_conn)
 			continue;
 
@@ -1538,7 +1538,7 @@ static void refresh_mounts(struct cifs_ses **sessions)
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	list_for_each_entry_safe(tcon, ntcon, &tcons, ulist) {
 		struct TCP_Server_Info *server = tcon->ses->server;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0359b604bdbc..35f931a7f6d1 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -229,8 +229,8 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		struct cifs_ses *ses_it = NULL;
 		struct TCP_Server_Info *server_it = NULL;
 
-		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
+		spin_lock(&g_servers_lock);
+		list_for_each_entry(server_it, &g_servers_list, server_head) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
 				if (ses_it->Suid == out.session_id) {
 					ses = ses_it;
@@ -246,7 +246,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 			}
 		}
 search_end:
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		if (!found) {
 			rc = -ENOENT;
 			goto out;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a825cc09a53e..e88f33b8159f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -465,7 +465,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 		return false;
 
 	/* look up tcon based on tid & uid */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &srv->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
@@ -489,16 +489,16 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				cifs_queue_oplock_break(netfile);
 
 				spin_unlock(&tcon->open_file_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_dbg(FYI, "No matching file for oplock break\n");
 			return true;
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
 	return true;
 }
@@ -1186,7 +1186,7 @@ struct super_cb_data {
 	struct super_block *sb;
 };
 
-static void tcp_super_cb(struct super_block *sb, void *arg)
+static void server_super_cb(struct super_block *sb, void *arg)
 {
 	struct super_cb_data *sd = arg;
 	struct TCP_Server_Info *server = sd->data;
@@ -1234,12 +1234,12 @@ static void __cifs_put_super(struct super_block *sb)
 		cifs_sb_deactive(sb);
 }
 
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server)
+struct super_block *cifs_get_server_super(struct TCP_Server_Info *server)
 {
-	return __cifs_get_super(tcp_super_cb, server);
+	return __cifs_get_super(server_super_cb, server);
 }
 
-void cifs_put_tcp_super(struct super_block *sb)
+void cifs_put_server_super(struct super_block *sb)
 {
 	__cifs_put_super(sb);
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 02c8b2906196..959a86c5e74c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -327,7 +327,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_unlock(&ses->chan_lock);
 
 	if (!iface && CIFS_SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server, false);
+		cifs_put_server(server, false);
 
 	return rc;
 }
@@ -433,7 +433,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	       SMB2_CLIENT_GUID_SIZE);
 	ctx.use_client_guid = true;
 
-	chan_server = cifs_get_tcp_session(&ctx, ses->server);
+	chan_server = cifs_get_server(&ctx, ses->server);
 
 	spin_lock(&ses->chan_lock);
 	chan = &ses->chans[ses->chan_count];
@@ -493,7 +493,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
 
-		cifs_put_tcp_session(chan->server, 0);
+		cifs_put_server(chan->server, 0);
 	}
 
 	return rc;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 818cc4dee0e2..9370cca778a8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -153,14 +153,14 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		struct cifs_ses *iter;
 
 		/* decrypt frame now that it is completely read in */
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
 			}
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		if (!ses) {
 			cifs_dbg(VFS, "no decryption - session id not found\n");
 			return 1;
@@ -618,8 +618,8 @@ smb2_is_valid_lease_break(char *buffer)
 	cifs_dbg(FYI, "Checking for lease break\n");
 
 	/* look up tcon based on tid & uid */
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
@@ -627,7 +627,7 @@ smb2_is_valid_lease_break(char *buffer)
 				    &tcon->stats.cifs_stats.num_oplock_brks);
 				if (smb2_tcon_has_lease(tcon, rsp)) {
 					spin_unlock(&tcon->open_file_lock);
-					spin_unlock(&cifs_tcp_ses_lock);
+					spin_unlock(&g_servers_lock);
 					return true;
 				}
 				open = smb2_tcon_find_pending_open_lease(tcon,
@@ -640,7 +640,7 @@ smb2_is_valid_lease_break(char *buffer)
 					memcpy(lease_key, open->lease_key,
 					       SMB2_LEASE_KEY_SIZE);
 					spin_unlock(&tcon->open_file_lock);
-					spin_unlock(&cifs_tcp_ses_lock);
+					spin_unlock(&g_servers_lock);
 					smb2_queue_pending_open_break(tlink,
 								      lease_key,
 								      rsp->NewLeaseState);
@@ -657,13 +657,13 @@ smb2_is_valid_lease_break(char *buffer)
 						  smb2_cached_lease_break);
 					queue_work(cifsiod_wq,
 						   &tcon->crfid.lease_break);
-					spin_unlock(&cifs_tcp_ses_lock);
+					spin_unlock(&g_servers_lock);
 					return true;
 				}
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
 	trace_smb3_lease_not_found(le32_to_cpu(rsp->CurrentLeaseState),
 				   le32_to_cpu(rsp->hdr.Id.SyncId.TreeId),
@@ -699,7 +699,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "oplock level 0x%x\n", rsp->OplockLevel);
 
 	/* look up tcon based on tid & uid */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
@@ -733,13 +733,13 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				cifs_queue_oplock_break(cfile);
 
 				spin_unlock(&tcon->open_file_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
 	trace_smb3_oplock_not_found(0 /* no xid */, rsp->PersistentFid,
 				  le32_to_cpu(rsp->hdr.Id.SyncId.TreeId),
@@ -807,12 +807,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	int rc;
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->tc_count <= 0) {
 		struct TCP_Server_Info *server = NULL;
 
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		if (tcon->ses)
 			server = tcon->ses->server;
@@ -823,7 +823,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		return 0;
 	}
 	tcon->tc_count++;
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
 					 persistent_fid, volatile_fid);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5bed8b584086..a268454868ba 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -126,13 +126,13 @@ smb2_add_credits(struct TCP_Server_Info *server,
 			 optype, scredits, add);
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedReconnect
 	    || server->tcpStatus == CifsExiting) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	switch (rc) {
 	case -1:
@@ -218,12 +218,12 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 			spin_lock(&server->req_lock);
 		} else {
 			spin_unlock(&server->req_lock);
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&g_servers_lock);
 			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 
 			spin_lock(&server->req_lock);
 			scredits = server->credits;
@@ -2581,19 +2581,19 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 	if (shdr->Status != STATUS_NETWORK_NAME_DELETED)
 		return;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				tcon->need_reconnect = true;
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				pr_warn_once("Server share %s deleted.\n",
 					     tcon->treeName);
 				return;
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 }
 
 static int
@@ -2939,13 +2939,13 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	tcon = ses->tcon_ipc;
 	if (tcon == NULL) {
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		tcon = list_first_entry_or_null(&ses->tcon_list,
 						struct cifs_tcon,
 						tcon_list);
 		if (tcon)
 			tcon->tc_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	}
 
 	if (tcon == NULL) {
@@ -3005,11 +3005,11 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
  out:
 	if (tcon && !tcon->ipc) {
 		/* ipc tcons are not refcounted */
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		tcon->tc_count--;
 		/* tc_count can never go negative */
 		WARN_ON(tcon->tc_count < 0);
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 	}
 	kfree(utf16_path);
 	kfree(dfs_req);
@@ -4557,19 +4557,19 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 	struct cifs_ses *ses;
 	u8 *ses_enc_key;
 
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	spin_lock(&g_servers_lock);
+	list_for_each_entry(server, &g_servers_list, server_head) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			if (ses->Suid == ses_id) {
 				ses_enc_key = enc ? ses->smb3encryptionkey :
 					ses->smb3decryptionkey;
 				memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				return 0;
 			}
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	return -EAGAIN;
 }
@@ -5078,12 +5078,12 @@ static void smb2_decrypt_offload(struct work_struct *work)
 
 			mid->callback(mid);
 		} else {
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&g_servers_lock);
 			spin_lock(&GlobalMid_Lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&GlobalMid_Lock);
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				mid->callback(mid);
 			} else {
 				mid->mid_state = MID_REQUEST_SUBMITTED;
@@ -5091,7 +5091,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				list_add_tail(&mid->qhead,
 					&dw->server->pending_mid_q);
 				spin_unlock(&GlobalMid_Lock);
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 			}
 		}
 		cifs_mid_q_entry_release(mid);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 295ee8b88055..f103ece8a3c9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -162,7 +162,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (smb2_command == SMB2_TREE_CONNECT || smb2_command == SMB2_IOCTL)
 		return 0;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (tcon->status == TID_EXITING) {
 		/*
 		 * only tree disconnect, open, and write,
@@ -172,13 +172,13 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		if ((smb2_command != SMB2_WRITE) &&
 		   (smb2_command != SMB2_CREATE) &&
 		   (smb2_command != SMB2_TREE_DISCONNECT)) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
 				 smb2_command);
 			return -ENODEV;
 		}
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	if ((!tcon->ses) || (tcon->ses->ses_status == SES_EXITING) ||
 	    (!tcon->ses->server) || !server)
 		return -EIO;
@@ -217,12 +217,12 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 
 		/* are we still trying to reconnect? */
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			break;
 		}
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		if (retries && --retries)
 			continue;
@@ -256,13 +256,13 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * and the server never sends an answer the socket will be closed
 	 * and tcpStatus set to reconnect.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -3803,7 +3803,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	INIT_LIST_HEAD(&tmp_ses_list);
 	cifs_dbg(FYI, "Reconnecting tcons and channels\n");
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 
 		tcon_selected = false;
@@ -3844,7 +3844,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	if (tcon_exist || ses_exist)
 		server->srv_count++;
 
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
 		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server);
@@ -3896,7 +3896,7 @@ void smb2_reconnect_server(struct work_struct *work)
 
 	/* now we can safely release srv struct */
 	if (tcon_exist || ses_exist)
-		cifs_put_tcp_session(server, 1);
+		cifs_put_server(server, 1);
 }
 
 int
@@ -3911,15 +3911,15 @@ SMB2_echo(struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "In echo request for conn_id %lld\n", server->conn_id);
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->ops->need_neg &&
 	    server->ops->need_neg(server)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		/* No need to send echo on newly established connections */
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		return rc;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	rc = smb2_plain_req_init(SMB2_ECHO, NULL, server,
 				 (void **)&req, &total_len);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 53ff6bc11939..36c08e369841 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -86,9 +86,9 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	int i;
 	int rc = 0;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 
-	list_for_each_entry(it, &cifs_tcp_ses_list, tcp_ses_list) {
+	list_for_each_entry(it, &g_servers_list, server_head) {
 		list_for_each_entry(ses, &it->smb_ses_list, smb_ses_list) {
 			if (ses->Suid == ses_id)
 				goto found;
@@ -133,7 +133,7 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	rc = -ENOENT;
 
 out:
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	return rc;
 }
 
@@ -157,9 +157,9 @@ smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
 {
 	struct cifs_ses *ses;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	ses = smb2_find_smb_ses_unlocked(server, ses_id);
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	return ses;
 }
@@ -190,19 +190,19 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	ses = smb2_find_smb_ses_unlocked(server, ses_id);
 	if (!ses) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return NULL;
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
 	if (!tcon) {
 		cifs_put_smb_ses(ses);
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return NULL;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	/* tcon already has a ref to ses, so we don't need ses anymore */
 	cifs_put_smb_ses(ses);
 
@@ -640,13 +640,13 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 	if (!is_signed)
 		return 0;
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->ops->need_neg &&
 	    server->ops->need_neg(server)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 	if (!is_binding && !server->session_estab) {
 		strncpy(shdr->Signature, "BSRSPYL", 8);
 		return 0;
@@ -762,28 +762,28 @@ static int
 smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
 {
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsExiting) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
 
 	if (server->tcpStatus == CifsNeedReconnect) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
 	if (server->tcpStatus == CifsNeedNegotiate &&
 	   shdr->Command != SMB2_NEGOTIATE) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return -EAGAIN;
 	}
 
 	if (ses->ses_status == SES_NEW) {
 		if ((shdr->Command != SMB2_SESSION_SETUP) &&
 		    (shdr->Command != SMB2_NEGOTIATE)) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
 		}
 		/* else ok - we are setting up session */
@@ -791,12 +791,12 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 
 	if (ses->ses_status == SES_EXITING) {
 		if (shdr->Command != SMB2_LOGOFF) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
 		}
 		/* else ok - we are shutting down the session */
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	*mid = smb2_mid_entry_alloc(shdr, server);
 	if (*mid == NULL)
@@ -869,13 +869,13 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsNeedNegotiate &&
 	   shdr->Command != SMB2_NEGOTIATE) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return ERR_PTR(-EAGAIN);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	smb2_seq_num_into_buf(server, shdr);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index dac8d6f9b309..5a7b4aa09720 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -577,12 +577,12 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		} else {
 			spin_unlock(&server->req_lock);
 
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&g_servers_lock);
 			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&cifs_tcp_ses_lock);
+				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 
 			/*
 			 * For normal commands, reserve the last MAX_COMPOUND
@@ -725,11 +725,11 @@ cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (ses->ses_status == SES_NEW) {
 		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
 			(in_buf->Command != SMB_COM_NEGOTIATE)) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
 		}
 		/* else ok - we are setting up session */
@@ -738,12 +738,12 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	if (ses->ses_status == SES_EXITING) {
 		/* check if SMB session is bad because we are setting it up */
 		if (in_buf->Command != SMB_COM_LOGOFF_ANDX) {
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
 		}
 		/* else ok - we are shutting down session */
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
 	if (*ppmidQ == NULL)
@@ -1078,12 +1078,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsExiting) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/*
 	 * Wait for all the requests to become available.
@@ -1186,17 +1186,17 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		cifs_server_lock(server);
 		smb311_update_preauth_hash(ses, server, rqst[0].rq_iov, rqst[0].rq_nvec);
 		cifs_server_unlock(server);
 
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	for (i = 0; i < num_rqst; i++) {
 		rc = wait_for_response(server, midQ[i]);
@@ -1259,19 +1259,19 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		struct kvec iov = {
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
 		};
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		cifs_server_lock(server);
 		smb311_update_preauth_hash(ses, server, &iov, 1);
 		cifs_server_unlock(server);
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 out:
 	/*
@@ -1360,12 +1360,12 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsExiting) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/* Ensure that we do not send more than 50 overlapping requests
 	   to the same server. We may make this configurable later or
@@ -1505,12 +1505,12 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return -EIO;
 	}
 
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if (server->tcpStatus == CifsExiting) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	/* Ensure that we do not send more than 50 overlapping requests
 	   to the same server. We may make this configurable later or
@@ -1568,12 +1568,12 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		 (server->tcpStatus != CifsNew)));
 
 	/* Were we interrupted by a signal ? */
-	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&g_servers_lock);
 	if ((rc == -ERESTARTSYS) &&
 		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
 		((server->tcpStatus == CifsGood) ||
 		 (server->tcpStatus == CifsNew))) {
-		spin_unlock(&cifs_tcp_ses_lock);
+		spin_unlock(&g_servers_lock);
 
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
@@ -1612,9 +1612,9 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 		/* We got the response - restart system call. */
 		rstart = 1;
-		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&g_servers_lock);
 	}
-	spin_unlock(&cifs_tcp_ses_lock);
+	spin_unlock(&g_servers_lock);
 
 	rc = cifs_sync_mid_result(midQ, server);
 	if (rc != 0)
-- 
2.35.3

