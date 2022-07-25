Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F1AC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 22:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiGYWiw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiGYWiL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 18:38:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C25F26555
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 15:37:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2BB0E1F8AE;
        Mon, 25 Jul 2022 22:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658788637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEIEzEZBJW+aB9sqJHK3NmqrMMnoSNw9AFBOl4ijsLs=;
        b=yPAaIXNj2TQUc4eX+aQSL/fNETtD9huRVngbWPezU+0ClSFAq/zbeP8jI3A1pwABAGGTx7
        3wjhycgCXkuRZLk2dSa3s6Jh84tmduMhOZocVp2za8GZTCl7T4fwZw9dhi76IlE0TE5ajP
        lleiwa64vWamOKc53NDoZBX/1o9P198=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658788637;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEIEzEZBJW+aB9sqJHK3NmqrMMnoSNw9AFBOl4ijsLs=;
        b=zbTebH0Ml61hswXQ+zx6ePzymcTPiOPX9/QyzMM9GeyTbdI3inWDlXQ4IzZo5fWA3IORcM
        ZZVBSqvYOMhm7EDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A068613ABB;
        Mon, 25 Jul 2022 22:37:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oJwBGRwb32LrRgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 22:37:16 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 01/10] cifs: rename xid/mid globals
Date:   Mon, 25 Jul 2022 19:36:58 -0300
Message-Id: <20220725223707.14477-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725223707.14477-1-ematsumiya@suse.de>
References: <20220725223707.14477-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename XID and MID global locks and counters.
Convert from CamelCase to snake_case.
Prepend "g_" to indicate a global.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    | 18 +++++++++---------
 fs/cifs/cifsfs.c        |  6 +++---
 fs/cifs/cifsglob.h      | 12 ++++++------
 fs/cifs/connect.c       | 14 +++++++-------
 fs/cifs/misc.c          | 22 +++++++++++-----------
 fs/cifs/smb1ops.c       | 10 +++++-----
 fs/cifs/smb2ops.c       | 24 ++++++++++++------------
 fs/cifs/smb2transport.c |  4 ++--
 fs/cifs/transport.c     | 38 +++++++++++++++++++-------------------
 9 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index a8e05ab5c9bf..246a9bc972fe 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -55,7 +55,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 		return;
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
 			 mid_entry->mid_state,
@@ -78,7 +78,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 				mid_entry->resp_buf, 62);
 		}
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
@@ -262,7 +262,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 #endif
 	seq_putc(m, '\n');
 	seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
-	seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
+	seq_printf(m, "Active VFS Requests: %d\n", g_total_active_xid);
 
 	seq_printf(m, "\nServers: ");
 
@@ -463,7 +463,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "\n\t\t[NONE]");
 
 		seq_puts(m, "\n\n\tMIDs: ");
-		spin_lock(&GlobalMid_Lock);
+		spin_lock(&g_mid_lock);
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			seq_printf(m, "\n\tState: %d com: %d pid:"
 					" %d cbdata: %p mid %llu\n",
@@ -473,7 +473,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					mid_entry->callback_data,
 					mid_entry->mid);
 		}
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 		seq_printf(m, "\n--\n");
 	}
 	if (c == 0)
@@ -507,10 +507,10 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		atomic_set(&tcpSesReconnectCount, 0);
 		atomic_set(&tconInfoReconnectCount, 0);
 
-		spin_lock(&GlobalMid_Lock);
+		spin_lock(&g_mid_lock);
 		GlobalMaxActiveXid = 0;
-		GlobalCurrentXid = 0;
-		spin_unlock(&GlobalMid_Lock);
+		g_current_xid = 0;
+		spin_unlock(&g_mid_lock);
 		spin_lock(&g_servers_lock);
 		list_for_each_entry(server, &g_servers_list, server_head) {
 			server->max_in_flight = 0;
@@ -575,7 +575,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 
 	seq_printf(m,
 		"Total vfs operations: %d maximum at one time: %d\n",
-		GlobalCurrentXid, GlobalMaxActiveXid);
+		g_current_xid, GlobalMaxActiveXid);
 
 	i = 0;
 	spin_lock(&g_servers_lock);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f40dffbc363d..88bee6544269 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1601,11 +1601,11 @@ init_cifs(void)
 #endif /* CONFIG_CIFS_STATS2 */
 
 	atomic_set(&mid_count, 0);
-	GlobalCurrentXid = 0;
-	GlobalTotalActiveXid = 0;
+	g_current_xid = 0;
+	g_total_active_xid = 0;
 	GlobalMaxActiveXid = 0;
 	spin_lock_init(&g_servers_lock);
-	spin_lock_init(&GlobalMid_Lock);
+	spin_lock_init(&g_mid_lock);
 
 	cifs_lock_secret = get_random_u32();
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 79b14f5f6afe..2701d741ddbd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -658,7 +658,7 @@ struct TCP_Server_Info {
 	/* SMB_COM_WRITE_RAW or SMB_COM_READ_RAW. */
 	unsigned int capabilities; /* selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
-	__u64 CurrentMid;         /* multiplex id - rotating counter, protected by GlobalMid_Lock */
+	__u64 CurrentMid;         /* multiplex id - rotating counter, protected by g_mid_lock */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
@@ -1904,7 +1904,7 @@ require use of the stronger protocol */
  *
  *  Spinlocks
  *  ---------
- *  GlobalMid_Lock protects:
+ *  g_mid_lock protects:
  *	list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
@@ -1958,10 +1958,10 @@ extern spinlock_t		g_servers_lock;
 /*
  * Global transaction id (XID) information
  */
-GLOBAL_EXTERN unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
-GLOBAL_EXTERN spinlock_t GlobalMid_Lock;  /* protects above & list operations */
+GLOBAL_EXTERN unsigned int g_current_xid;	/* protected by g_mid_lock */
+GLOBAL_EXTERN unsigned int g_total_active_xid; /* prot by g_mid_lock */
+GLOBAL_EXTERN unsigned int g_max_active_xid	/* prot by g_mid_lock */
+GLOBAL_EXTERN spinlock_t g_mid_lock;  /* protects above & list operations */
 					  /* on midQ entries */
 /*
  *  Global counters, updated atomically
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c0e712917fd6..e44e65cd53d2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -323,7 +323,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
 		kref_get(&mid->refcount);
 		if (mid->mid_state == MID_REQUEST_SUBMITTED)
@@ -331,7 +331,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 		list_move(&mid->qhead, &retry_list);
 		mid->mid_flags |= MID_DELETED;
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
@@ -849,7 +849,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
 #endif
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	if (!malformed)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
@@ -859,12 +859,12 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 	 * function has finished processing it is a bug.
 	 */
 	if (mid->mid_flags & MID_DELETED) {
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 	}
 }
 
@@ -948,7 +948,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		struct list_head *tmp, *tmp2;
 
 		INIT_LIST_HEAD(&dispose_list);
-		spin_lock(&GlobalMid_Lock);
+		spin_lock(&g_mid_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
@@ -957,7 +957,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 			list_move(&mid_entry->qhead, &dispose_list);
 			mid_entry->mid_flags |= MID_DELETED;
 		}
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index e88f33b8159f..9f450a1c947a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -38,27 +38,27 @@ _get_xid(void)
 {
 	unsigned int xid;
 
-	spin_lock(&GlobalMid_Lock);
-	GlobalTotalActiveXid++;
+	spin_lock(&g_mid_lock);
+	g_total_active_xid++;
 
 	/* keep high water mark for number of simultaneous ops in filesystem */
-	if (GlobalTotalActiveXid > GlobalMaxActiveXid)
-		GlobalMaxActiveXid = GlobalTotalActiveXid;
-	if (GlobalTotalActiveXid > 65000)
+	if (g_total_active_xid > GlobalMaxActiveXid)
+		GlobalMaxActiveXid = g_total_active_xid;
+	if (g_total_active_xid > 65000)
 		cifs_dbg(FYI, "warning: more than 65000 requests active\n");
-	xid = GlobalCurrentXid++;
-	spin_unlock(&GlobalMid_Lock);
+	xid = g_current_xid++;
+	spin_unlock(&g_mid_lock);
 	return xid;
 }
 
 void
 _free_xid(unsigned int xid)
 {
-	spin_lock(&GlobalMid_Lock);
-	/* if (GlobalTotalActiveXid == 0)
+	spin_lock(&g_mid_lock);
+	/* if (g_total_active_xid == 0)
 		BUG(); */
-	GlobalTotalActiveXid--;
-	spin_unlock(&GlobalMid_Lock);
+	g_total_active_xid--;
+	spin_unlock(&g_mid_lock);
 }
 
 struct cifs_ses *
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 2e20ee4dab7b..f557856be943 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -92,17 +92,17 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct mid_q_entry *mid;
 
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if (compare_mid(mid->mid, buf) &&
 		    mid->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
 			kref_get(&mid->refcount);
-			spin_unlock(&GlobalMid_Lock);
+			spin_unlock(&g_mid_lock);
 			return mid;
 		}
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	return NULL;
 }
 
@@ -166,7 +166,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	__u16 last_mid, cur_mid;
 	bool collision, reconnect = false;
 
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 
 	/* mid is 16 bit only for CIFS/SMB */
 	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
@@ -225,7 +225,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 		}
 		cur_mid++;
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 
 	if (reconnect) {
 		cifs_signal_cifsd_for_reconnect(server, false);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a268454868ba..7a8f3744b895 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -319,19 +319,19 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid;
 	/* for SMB2 we need the current value */
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	mid = server->CurrentMid++;
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	return mid;
 }
 
 static void
 smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 {
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	if (server->CurrentMid >= val)
 		server->CurrentMid -= val;
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 }
 
 static struct mid_q_entry *
@@ -346,7 +346,7 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 		return NULL;
 	}
 
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
@@ -356,11 +356,11 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 				list_del_init(&mid->qhead);
 				mid->mid_flags |= MID_DELETED;
 			}
-			spin_unlock(&GlobalMid_Lock);
+			spin_unlock(&g_mid_lock);
 			return mid;
 		}
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	return NULL;
 }
 
@@ -403,9 +403,9 @@ smb2_negotiate(const unsigned int xid,
 {
 	int rc;
 
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	server->CurrentMid = 0;
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	rc = SMB2_negotiate(xid, ses, server);
 	/* BB we probably don't need to retry with modern servers */
 	if (rc == -EAGAIN)
@@ -5079,10 +5079,10 @@ static void smb2_decrypt_offload(struct work_struct *work)
 			mid->callback(mid);
 		} else {
 			spin_lock(&g_servers_lock);
-			spin_lock(&GlobalMid_Lock);
+			spin_lock(&g_mid_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
 				mid->mid_state = MID_RETRY_NEEDED;
-				spin_unlock(&GlobalMid_Lock);
+				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
 				mid->callback(mid);
 			} else {
@@ -5090,7 +5090,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				mid->mid_flags &= ~(MID_DELETED);
 				list_add_tail(&mid->qhead,
 					&dw->server->pending_mid_q);
-				spin_unlock(&GlobalMid_Lock);
+				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
 			}
 		}
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 36c08e369841..12220cb4fc10 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -801,9 +801,9 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	*mid = smb2_mid_entry_alloc(shdr, server);
 	if (*mid == NULL)
 		return -ENOMEM;
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_add_tail(&(*mid)->qhead, &server->pending_mid_q);
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 
 	return 0;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5a7b4aa09720..81041c87db3e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -154,9 +154,9 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 
 void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
 {
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 }
 
 void DeleteMidQEntry(struct mid_q_entry *midEntry)
@@ -167,12 +167,12 @@ void DeleteMidQEntry(struct mid_q_entry *midEntry)
 void
 cifs_delete_mid(struct mid_q_entry *mid)
 {
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	if (!(mid->mid_flags & MID_DELETED)) {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 
 	DeleteMidQEntry(mid);
 }
@@ -748,9 +748,9 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
 	if (*ppmidQ == NULL)
 		return -ENOMEM;
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q);
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 	return 0;
 }
 
@@ -849,9 +849,9 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	mid->mid_state = MID_REQUEST_SUBMITTED;
 
 	/* put it on the pending_mid_q */
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	list_add_tail(&mid->qhead, &server->pending_mid_q);
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 
 	/*
 	 * Need to store the time in mid before calling I/O. For call_async,
@@ -912,10 +912,10 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: cmd=%d mid=%llu state=%d\n",
 		 __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_state);
 
-	spin_lock(&GlobalMid_Lock);
+	spin_lock(&g_mid_lock);
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 		return rc;
 	case MID_RETRY_NEEDED:
 		rc = -EAGAIN;
@@ -935,7 +935,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
 	}
-	spin_unlock(&GlobalMid_Lock);
+	spin_unlock(&g_mid_lock);
 
 	DeleteMidQEntry(mid);
 	return rc;
@@ -1208,14 +1208,14 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
-			spin_lock(&GlobalMid_Lock);
+			spin_lock(&g_mid_lock);
 			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
 			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
-			spin_unlock(&GlobalMid_Lock);
+			spin_unlock(&g_mid_lock);
 		}
 	}
 
@@ -1419,15 +1419,15 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = wait_for_response(server, midQ);
 	if (rc != 0) {
 		send_cancel(server, &rqst, midQ);
-		spin_lock(&GlobalMid_Lock);
+		spin_lock(&g_mid_lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
-			spin_unlock(&GlobalMid_Lock);
+			spin_unlock(&g_mid_lock);
 			add_credits(server, &credits, 0);
 			return rc;
 		}
-		spin_unlock(&GlobalMid_Lock);
+		spin_unlock(&g_mid_lock);
 	}
 
 	rc = cifs_sync_mid_result(midQ, server);
@@ -1600,14 +1600,14 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		rc = wait_for_response(server, midQ);
 		if (rc) {
 			send_cancel(server, &rqst, midQ);
-			spin_lock(&GlobalMid_Lock);
+			spin_lock(&g_mid_lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
-				spin_unlock(&GlobalMid_Lock);
+				spin_unlock(&g_mid_lock);
 				return rc;
 			}
-			spin_unlock(&GlobalMid_Lock);
+			spin_unlock(&g_mid_lock);
 		}
 
 		/* We got the response - restart system call. */
-- 
2.35.3

