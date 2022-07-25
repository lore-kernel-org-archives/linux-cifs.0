Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DD6C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 22:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiGYWjN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiGYWiQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 18:38:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B43C26AE3
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 15:37:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5F5CB3371E;
        Mon, 25 Jul 2022 22:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658788652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUcksyW6KX9DHhvFx56b1YxkPMLbPrdRp10hZO6JiVU=;
        b=QDj0pj3TdX5Rh/T6ahOKE6rAtQPXc0xmo9AjeSfFFfOIfDmncpNpnOQG2o2RDCykeGA5Lh
        IXmuV8rOnAIgXeKmW5kEVd0k15TBIHX/zPs94h8PpqEWJyh63le5XyJsjMWMe/tujslKZN
        u5fj8CLBg8L37qAk7EwXbpUnYoYnv1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658788652;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUcksyW6KX9DHhvFx56b1YxkPMLbPrdRp10hZO6JiVU=;
        b=AYwds0225ju6FmwgsI7RGg5hUe6ljIqJe0pJgiN1nT6+RwjqWH11FpO3ir33mk/fuiyShx
        0TtaXBVREegZ8kBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 960C513ABB;
        Mon, 25 Jul 2022 22:37:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vjcvFisb32IGRwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 22:37:31 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 05/10] cifs: convert server info vars to snake_case
Date:   Mon, 25 Jul 2022 19:37:02 -0300
Message-Id: <20220725223707.14477-6-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725223707.14477-1-ematsumiya@suse.de>
References: <20220725223707.14477-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename cifs_server_info variables that were still in CamelCase or
Camel_Case to snake_case.

Rename [Alloc,Delete]MidQEntry() functions to
cifs_{alloc,delete}_mid_q_entry().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    |  4 +-
 fs/cifs/cifsencrypt.c   |  2 +-
 fs/cifs/cifsglob.h      | 24 ++++++------
 fs/cifs/cifsproto.h     |  4 +-
 fs/cifs/cifssmb.c       | 38 +++++++++----------
 fs/cifs/connect.c       | 84 ++++++++++++++++++++---------------------
 fs/cifs/file.c          |  8 ++--
 fs/cifs/inode.c         |  8 ++--
 fs/cifs/readdir.c       |  2 +-
 fs/cifs/sess.c          |  2 +-
 fs/cifs/smb1ops.c       | 12 +++---
 fs/cifs/smb2file.c      |  8 ++--
 fs/cifs/smb2ops.c       | 36 +++++++++---------
 fs/cifs/smb2pdu.c       | 20 +++++-----
 fs/cifs/smb2transport.c | 10 ++---
 fs/cifs/transport.c     | 54 +++++++++++++-------------
 16 files changed, 158 insertions(+), 158 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 50bf6d849285..eb24928e1298 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -136,7 +136,7 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   i+1, server->conn_id,
 		   server->credits,
 		   server->dialect,
-		   server->tcpStatus,
+		   server->status,
 		   server->reconnect_instance,
 		   server->srv_count,
 		   server->sec_mode,
@@ -364,7 +364,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "\nRDMA ");
 		seq_printf(m, "\nTCP status: %d Instance: %d"
 				"\nLocal Users To Server: %d SecMode: 0x%x Req On Wire: %d",
-				server->tcpStatus,
+				server->status,
 				server->reconnect_instance,
 				server->srv_count,
 				server->sec_mode, in_flight(server));
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index ba70b8a50b3e..7d8020b90220 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -143,7 +143,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
-	    server->tcpStatus == CifsNeedNegotiate) {
+	    server->status == CifsNeedNegotiate) {
 		spin_unlock(&g_servers_lock);
 		return rc;
 	}
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0d3b2487e7d7..12b6aafa5fa6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -608,11 +608,11 @@ struct cifs_server_info {
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
-	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
+	char server_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
 	struct smb_version_values	*vals;
-	/* updates to tcpStatus protected by g_servers_lock */
-	enum statusEnum tcpStatus; /* what we think the status is */
+	/* updates to status protected by g_servers_lock */
+	enum statusEnum status; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
@@ -635,7 +635,7 @@ struct cifs_server_info {
 	struct mutex _srv_mutex;
 	unsigned int nofs_flag;
 	struct task_struct *tsk;
-	char server_GUID[16];
+	char server_guid[16];
 	__u16 sec_mode;
 	bool sign; /* is signing enabled on this connection? */
 	bool ignore_signature:1; /* skip validation of signatures in SMB2/3 rsp */
@@ -646,19 +646,19 @@ struct cifs_server_info {
 	__u8 client_guid[SMB2_CLIENT_GUID_SIZE]; /* Client GUID */
 	u16 dialect; /* dialect index that server chose */
 	bool oplocks:1; /* enable oplocks */
-	unsigned int maxReq;	/* Clients should submit no more */
-	/* than maxReq distinct unanswered SMBs to the server when using  */
+	unsigned int max_req;	/* Clients should submit no more */
+	/* than max_req distinct unanswered SMBs to the server when using  */
 	/* multiplexed reads or writes (for SMB1/CIFS only, not SMB2/SMB3) */
-	unsigned int maxBuf;	/* maxBuf specifies the maximum */
+	unsigned int max_buf;	/* max_buf specifies the maximum */
 	/* message size the server can send or receive for non-raw SMBs */
-	/* maxBuf is returned by SMB NegotiateProtocol so maxBuf is only 0 */
+	/* max_buf is returned by SMB NegotiateProtocol so max_buf is only 0 */
 	/* when socket is setup (and during reconnect) before NegProt sent */
 	unsigned int max_rw;	/* maxRw specifies the maximum */
 	/* message size the server can send or receive for */
 	/* SMB_COM_WRITE_RAW or SMB_COM_READ_RAW. */
 	unsigned int capabilities; /* selective disabling of caps by smb sess */
-	int timeAdj;  /* Adjust for difference in server time zone in sec */
-	__u64 CurrentMid;         /* multiplex id - rotating counter, protected by g_mid_lock */
+	int time_adjust;  /* Adjust for difference in server time zone in sec */
+	__u64 current_mid;         /* multiplex id - rotating counter, protected by g_mid_lock */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
@@ -1908,8 +1908,8 @@ require use of the stronger protocol */
  *	list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
- *      updates to ses->status and cifs_server_info->tcpStatus
- *      updates to server->CurrentMid
+ *      updates to ses->status and cifs_server_info->status
+ *      updates to server->current_mid
  *  g_servers_lock protects:
  *	list operations on tcp and SMB session lists
  *  tcon->open_file_lock protects the list of open files hanging off the tcon
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 265a4f25ac93..fce0fd8b1024 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -79,9 +79,9 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
-extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
+extern struct mid_q_entry *cifs_alloc_mid_q_entry(const struct smb_hdr *smb_buffer,
 					struct cifs_server_info *server);
-extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern void cifs_delete_mid_q_entry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
 extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index fd5bcebe1abf..326db1db353e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -154,9 +154,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
+	while (server->status == CifsNeedReconnect) {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
+						      (server->status != CifsNeedReconnect),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -166,7 +166,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
+		if (server->status != CifsNeedReconnect) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -199,10 +199,10 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
 	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
+	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedReconnect) {
+	if (server->status == CifsNeedReconnect) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
@@ -435,13 +435,13 @@ decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 	spin_lock(&g_servers_lock);
 	if (server->srv_count > 1) {
 		spin_unlock(&g_servers_lock);
-		if (memcmp(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE) != 0) {
+		if (memcmp(server->server_guid, guid, SMB1_CLIENT_GUID_SIZE) != 0) {
 			cifs_dbg(FYI, "server UID changed\n");
-			memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
+			memcpy(server->server_guid, guid, SMB1_CLIENT_GUID_SIZE);
 		}
 	} else {
 		spin_unlock(&g_servers_lock);
-		memcpy(server->server_GUID, guid, SMB1_CLIENT_GUID_SIZE);
+		memcpy(server->server_guid, guid, SMB1_CLIENT_GUID_SIZE);
 	}
 
 	if (count == SMB1_CLIENT_GUID_SIZE) {
@@ -591,18 +591,18 @@ CIFSSMBNegotiate(const unsigned int xid,
 
 	/* one byte, so no need to convert this or EncryptionKeyLen from
 	   little endian */
-	server->maxReq = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
+	server->max_req = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
 			       cifs_max_pending);
-	set_credits(server, server->maxReq);
+	set_credits(server, server->max_req);
 	/* probably no need to store and check maxvcs */
-	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
+	server->max_buf = le32_to_cpu(pSMBr->MaxBufferSize);
 	/* set up max_read for readahead check */
-	server->max_read = server->maxBuf;
+	server->max_read = server->max_buf;
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
-	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->maxBuf);
+	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->max_buf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
-	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
-	server->timeAdj *= 60;
+	server->time_adjust = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
+	server->time_adjust *= 60;
 
 	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
 		server->negflavor = CIFS_NEGFLAVOR_UNENCAP;
@@ -684,7 +684,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct cifs_server_info *server = mid->callback_data;
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -1607,7 +1607,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	}
 
 	queue_work(cifsiod_wq, &rdata->work);
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -1849,7 +1849,7 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (tcon->ses->capabilities & CAP_LARGE_WRITE_X) {
 		bytes_sent = min_t(const unsigned int, CIFSMaxBufSize, count);
 	} else {
-		bytes_sent = (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE)
+		bytes_sent = (tcon->ses->server->max_buf - MAX_CIFS_HDR_SIZE)
 			 & ~0xFF;
 	}
 
@@ -2132,7 +2132,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 	}
 
 	queue_work(cifsiod_wq, &wdata->work);
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(tcon->ses->server, &credits, 0);
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d8a003c27cf0..4ab1933fca76 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -186,7 +186,7 @@ static void cifs_resolve_server(struct work_struct *work)
 }
 
 /*
- * Update the tcpStatus for the server.
+ * Update the status for the server.
  * This is used to signal the cifsd thread to call cifs_reconnect
  * ONLY cifsd thread should call cifs_reconnect. For any other
  * thread, use this function
@@ -207,7 +207,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!all_channels) {
-		pserver->tcpStatus = CifsNeedReconnect;
+		pserver->status = CifsNeedReconnect;
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -215,7 +215,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++)
-			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+			ses->chans[i].server->status = CifsNeedReconnect;
 		spin_unlock(&ses->chan_lock);
 	}
 	spin_unlock(&g_servers_lock);
@@ -298,7 +298,7 @@ cifs_abort_connection(struct cifs_server_info *server)
 	struct mid_q_entry *mid, *nmid;
 	struct list_head retry_list;
 
-	server->maxBuf = 0;
+	server->max_buf = 0;
 	server->max_read = 0;
 
 	/* do not want to be sending data on a socket we are freeing */
@@ -352,7 +352,7 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 {
 	spin_lock(&g_servers_lock);
 	server->nr_targets = num_targets;
-	if (server->tcpStatus == CifsExiting) {
+	if (server->status == CifsExiting) {
 		/* the demux thread will exit normally next time through the loop */
 		spin_unlock(&g_servers_lock);
 		wake_up(&server->response_q);
@@ -360,9 +360,9 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 	}
 
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
-	trace_smb3_reconnect(server->CurrentMid, server->conn_id,
+	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->tcpStatus = CifsNeedReconnect;
+	server->status = CifsNeedReconnect;
 
 	spin_unlock(&g_servers_lock);
 	return true;
@@ -415,17 +415,17 @@ static int __cifs_reconnect(struct cifs_server_info *server,
 			atomic_inc(&g_server_reconnect_count);
 			set_credits(server, 1);
 			spin_lock(&g_servers_lock);
-			if (server->tcpStatus != CifsExiting)
-				server->tcpStatus = CifsNeedNegotiate;
+			if (server->status != CifsExiting)
+				server->status = CifsNeedNegotiate;
 			spin_unlock(&g_servers_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
 			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
-	} while (server->tcpStatus == CifsNeedReconnect);
+	} while (server->status == CifsNeedReconnect);
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedNegotiate)
+	if (server->status == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 	spin_unlock(&g_servers_lock);
 
@@ -542,13 +542,13 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 		atomic_inc(&g_server_reconnect_count);
 		set_credits(server, 1);
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus != CifsExiting)
-			server->tcpStatus = CifsNeedNegotiate;
+		if (server->status != CifsExiting)
+			server->status = CifsNeedNegotiate;
 		spin_unlock(&g_servers_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
-	} while (server->tcpStatus == CifsNeedReconnect);
+	} while (server->status == CifsNeedReconnect);
 
 	if (target_hint)
 		dfs_cache_noreq_update_tgthint(refpath, target_hint);
@@ -557,7 +557,7 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 
 	/* Need to set up echo worker again once connection has been established */
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedNegotiate)
+	if (server->status == CifsNeedNegotiate)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
 	spin_unlock(&g_servers_lock);
@@ -604,9 +604,9 @@ cifs_echo_request(struct work_struct *work)
 	 * Also, no need to ping if we got a response recently.
 	 */
 
-	if (server->tcpStatus == CifsNeedReconnect ||
-	    server->tcpStatus == CifsExiting ||
-	    server->tcpStatus == CifsNew ||
+	if (server->status == CifsNeedReconnect ||
+	    server->status == CifsExiting ||
+	    server->status == CifsNew ||
 	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
 	    time_before(jiffies, server->lstrp + server->echo_interval - HZ))
 		goto requeue_echo;
@@ -671,8 +671,8 @@ server_unresponsive(struct cifs_server_info *server)
 	 *     a response in >60s.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((server->tcpStatus == CifsGood ||
-	    server->tcpStatus == CifsNeedNegotiate) &&
+	if ((server->status == CifsGood ||
+	    server->status == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		spin_unlock(&g_servers_lock);
@@ -727,12 +727,12 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus == CifsExiting) {
+		if (server->status == CifsExiting) {
 			spin_unlock(&g_servers_lock);
 			return -ESHUTDOWN;
 		}
 
-		if (server->tcpStatus == CifsNeedReconnect) {
+		if (server->status == CifsNeedReconnect) {
 			spin_unlock(&g_servers_lock);
 			cifs_reconnect(server, false);
 			return -ECONNABORTED;
@@ -744,7 +744,7 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 		    length == -EINTR) {
 			/*
 			 * Minimum sleep to prevent looping, allowing socket
-			 * to clear and app threads to set tcpStatus
+			 * to clear and app threads to set status
 			 * CifsNeedReconnect if server hung.
 			 */
 			usleep_range(1000, 2000);
@@ -916,7 +916,7 @@ static void clean_demultiplex_info(struct cifs_server_info *server)
 	cancel_delayed_work_sync(&server->resolve);
 
 	spin_lock(&g_servers_lock);
-	server->tcpStatus = CifsExiting;
+	server->status = CifsExiting;
 	spin_unlock(&g_servers_lock);
 	wake_up_all(&server->response_q);
 
@@ -1091,7 +1091,7 @@ smb2_add_credits_from_hdr(char *buffer, struct cifs_server_info *server)
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 
-		trace_smb3_hdr_credits(server->CurrentMid,
+		trace_smb3_hdr_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits,
 				le16_to_cpu(shdr->CreditRequest), in_flight);
 		cifs_server_dbg(FYI, "%s: added %u credits total=%d\n",
@@ -1123,7 +1123,7 @@ cifs_demultiplex_thread(void *p)
 
 	set_freezable();
 	allow_kernel_signal(SIGKILL);
-	while (server->tcpStatus != CifsExiting) {
+	while (server->status != CifsExiting) {
 		if (try_to_freeze())
 			continue;
 
@@ -1534,7 +1534,7 @@ cifs_put_server(struct cifs_server_info *server, int from_reconnect)
 		cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&g_servers_lock);
-	server->tcpStatus = CifsExiting;
+	server->status = CifsExiting;
 	spin_unlock(&g_servers_lock);
 
 	cifs_crypto_secmech_release(server);
@@ -1603,7 +1603,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	mutex_init(&server->_srv_mutex);
 	memcpy(server->workstation_RFC1001_name,
 		ctx->source_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
-	memcpy(server->server_RFC1001_name,
+	memcpy(server->server_rfc1001_name,
 		ctx->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	server->session_estab = false;
 	server->sequence_number = 0;
@@ -1632,9 +1632,9 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
-	 * no need to spinlock this init of tcpStatus or srv_count
+	 * no need to spinlock this init of status or srv_count
 	 */
-	server->tcpStatus = CifsNew;
+	server->status = CifsNew;
 	++server->srv_count;
 
 	if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
@@ -1682,10 +1682,10 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
-	 * no need to spinlock this update of tcpStatus
+	 * no need to spinlock this update of status
 	 */
 	spin_lock(&g_servers_lock);
-	server->tcpStatus = CifsNeedNegotiate;
+	server->status = CifsNeedNegotiate;
 	spin_unlock(&g_servers_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
@@ -2767,10 +2767,10 @@ ip_rfc1001_connect(struct cifs_server_info *server)
 	if (ses_init_buf) {
 		ses_init_buf->trailer.session_req.called_len = 32;
 
-		if (server->server_RFC1001_name[0] != 0)
+		if (server->server_rfc1001_name[0] != 0)
 			rfc1002mangle(ses_init_buf->trailer.
 				      session_req.called_name,
-				      server->server_RFC1001_name,
+				      server->server_rfc1001_name,
 				      RFC1001_NAME_LEN_WITH_NULL);
 		else
 			rfc1002mangle(ses_init_buf->trailer.
@@ -3179,7 +3179,7 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 		 */
 		reset_cifs_unix_caps(xid, tcon, cifs_sb, ctx);
 		spin_lock(&g_servers_lock);
-		if ((tcon->ses->server->tcpStatus == CifsNeedReconnect) &&
+		if ((tcon->ses->server->status == CifsNeedReconnect) &&
 		    (le64_to_cpu(tcon->fsUnixInfo.Capability) &
 		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)) {
 			spin_unlock(&g_servers_lock);
@@ -3988,25 +3988,25 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
 	if (!server->ops->need_neg(server) ||
-	    server->tcpStatus != CifsNeedNegotiate) {
+	    server->status != CifsNeedNegotiate) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	server->tcpStatus = CifsInNegotiate;
+	server->status = CifsInNegotiate;
 	spin_unlock(&g_servers_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
 	if (rc == 0) {
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus == CifsInNegotiate)
-			server->tcpStatus = CifsGood;
+		if (server->status == CifsInNegotiate)
+			server->status = CifsGood;
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus == CifsInNegotiate)
-			server->tcpStatus = CifsNeedNegotiate;
+		if (server->status == CifsInNegotiate)
+			server->status = CifsNeedNegotiate;
 		spin_unlock(&g_servers_lock);
 	}
 
@@ -4067,7 +4067,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
-		 server->sec_mode, server->capabilities, server->timeAdj);
+		 server->sec_mode, server->capabilities, server->time_adjust);
 
 	if (server->ops->sess_setup)
 		rc = server->ops->sess_setup(xid, ses, server, nls_info);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6d2efcdcfe7e..c3561ac3c6d8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1267,10 +1267,10 @@ cifs_push_mandatory_locks(struct cifs_file_info *cfile)
 	tcon = tlink_tcon(cfile->tlink);
 
 	/*
-	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * Accessing max_buf is racy with cifs_reconnect - need to store value
 	 * and check it before using.
 	 */
-	max_buf = tcon->ses->server->maxBuf;
+	max_buf = tcon->ses->server->max_buf;
 	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE))) {
 		free_xid(xid);
 		return -EINVAL;
@@ -1611,10 +1611,10 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 	INIT_LIST_HEAD(&tmp_llist);
 
 	/*
-	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * Accessing max_buf is racy with cifs_reconnect - need to store value
 	 * and check it before using.
 	 */
-	max_buf = tcon->ses->server->maxBuf;
+	max_buf = tcon->ses->server->max_buf;
 	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE)))
 		return -EINVAL;
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6ae0c063841e..7dbbb2e4dafd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -613,8 +613,8 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
 	if (adjust_tz) {
-		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
-		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
+		fattr->cf_ctime.tv_sec += tcon->ses->server->time_adjust;
+		fattr->cf_mtime.tv_sec += tcon->ses->server->time_adjust;
 	}
 
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
@@ -669,8 +669,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
 
 	if (adjust_tz) {
-		fattr->cf_ctime.tv_sec += tcon->ses->server->timeAdj;
-		fattr->cf_mtime.tv_sec += tcon->ses->server->timeAdj;
+		fattr->cf_ctime.tv_sec += tcon->ses->server->time_adjust;
+		fattr->cf_mtime.tv_sec += tcon->ses->server->time_adjust;
 	}
 
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 2820aa1f16ec..dbdabb83ea03 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -318,7 +318,7 @@ static void
 cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 		       struct cifs_sb_info *cifs_sb)
 {
-	int offset = cifs_sb_master_tcon(cifs_sb)->ses->server->timeAdj;
+	int offset = cifs_sb_master_tcon(cifs_sb)->ses->server->time_adjust;
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_atime = cnvrtDosUnixTm(info->LastAccessDate,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index c63d9a5058ea..2584b150a648 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -514,7 +514,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses,
 	pSMB->req.MaxBufferSize = cpu_to_le16(min_t(u32,
 					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4,
 					USHRT_MAX));
-	pSMB->req.MaxMpxCount = cpu_to_le16(server->maxReq);
+	pSMB->req.MaxMpxCount = cpu_to_le16(server->max_req);
 	pSMB->req.VcNumber = cpu_to_le16(1);
 
 	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 1f4f7d78dfee..8b2a504c92f1 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -169,7 +169,7 @@ cifs_get_next_mid(struct cifs_server_info *server)
 	spin_lock(&g_mid_lock);
 
 	/* mid is 16 bit only for CIFS/SMB */
-	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
+	cur_mid = (__u16)((server->current_mid) & 0xffff);
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
 	cur_mid++;
@@ -220,7 +220,7 @@ cifs_get_next_mid(struct cifs_server_info *server)
 
 		if (!collision) {
 			mid = (__u64)cur_mid;
-			server->CurrentMid = mid;
+			server->current_mid = mid;
 			break;
 		}
 		cur_mid++;
@@ -416,7 +416,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct cifs_server_info *server,
 static bool
 cifs_need_neg(struct cifs_server_info *server)
 {
-	return server->maxBuf == 0;
+	return server->max_buf == 0;
 }
 
 static int
@@ -463,7 +463,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
 	    (!(server->capabilities & CAP_UNIX) && server->sign))
 		wsize = min_t(unsigned int, wsize,
-				server->maxBuf - sizeof(WRITE_REQ) + 4);
+				server->max_buf - sizeof(WRITE_REQ) + 4);
 
 	/* hard limit of CIFS_MAX_WSIZE */
 	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
@@ -495,7 +495,7 @@ cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	else if (server->capabilities & CAP_LARGE_READ_X)
 		defsize = CIFS_DEFAULT_NON_POSIX_RSIZE;
 	else
-		defsize = server->maxBuf - sizeof(READ_RSP);
+		defsize = server->max_buf - sizeof(READ_RSP);
 
 	rsize = ctx->rsize ? ctx->rsize : defsize;
 
@@ -1024,7 +1024,7 @@ cifs_dir_needs_close(struct cifs_file_info *cfile)
 static bool
 cifs_can_echo(struct cifs_server_info *server)
 {
-	if (server->tcpStatus == CifsGood)
+	if (server->status == CifsGood)
 		return true;
 
 	return false;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 25397786a781..79b28a52f67e 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -116,10 +116,10 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 	INIT_LIST_HEAD(&tmp_llist);
 
 	/*
-	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * Accessing max_buf is racy with cifs_reconnect - need to store value
 	 * and check it before using.
 	 */
-	max_buf = tcon->ses->server->maxBuf;
+	max_buf = tcon->ses->server->max_buf;
 	if (max_buf < sizeof(struct smb2_lock_element))
 		return -EINVAL;
 
@@ -257,10 +257,10 @@ smb2_push_mandatory_locks(struct cifs_file_info *cfile)
 	xid = get_xid();
 
 	/*
-	 * Accessing maxBuf is racy with cifs_reconnect - need to store value
+	 * Accessing max_buf is racy with cifs_reconnect - need to store value
 	 * and check it for zero before using.
 	 */
-	max_buf = tlink_tcon(cfile->tlink)->ses->server->maxBuf;
+	max_buf = tlink_tcon(cfile->tlink)->ses->server->max_buf;
 	if (max_buf < sizeof(struct smb2_lock_element)) {
 		free_xid(xid);
 		return -EINVAL;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5d5b05277c45..41d1237bb24c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -86,7 +86,7 @@ smb2_add_credits(struct cifs_server_info *server,
 	if (*val > 65000) {
 		*val = 65000; /* Don't get near 64K credits, avoid srv bugs */
 		pr_warn_once("server overflowed SMB3 credits\n");
-		trace_smb3_overflow_credits(server->CurrentMid,
+		trace_smb3_overflow_credits(server->current_mid,
 					    server->conn_id, server->hostname, *val,
 					    add, server->in_flight);
 	}
@@ -112,7 +112,7 @@ smb2_add_credits(struct cifs_server_info *server,
 	wake_up(&server->request_q);
 
 	if (reconnect_detected) {
-		trace_smb3_reconnect_detected(server->CurrentMid,
+		trace_smb3_reconnect_detected(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 
 		cifs_dbg(FYI, "trying to put %d credits from the old server instance %d\n",
@@ -120,15 +120,15 @@ smb2_add_credits(struct cifs_server_info *server,
 	}
 
 	if (reconnect_with_invalid_credits) {
-		trace_smb3_reconnect_with_invalid_credits(server->CurrentMid,
+		trace_smb3_reconnect_with_invalid_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 		cifs_dbg(FYI, "Negotiate operation when server credits is non-zero. Optype: %d, server credits: %d, credits added: %d\n",
 			 optype, scredits, add);
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedReconnect
-	    || server->tcpStatus == CifsExiting) {
+	if (server->status == CifsNeedReconnect
+	    || server->status == CifsExiting) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -152,7 +152,7 @@ smb2_add_credits(struct cifs_server_info *server,
 		break;
 	}
 
-	trace_smb3_add_credits(server->CurrentMid,
+	trace_smb3_add_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 	cifs_dbg(FYI, "%s: added %u credits total=%d\n", __func__, add, scredits);
 }
@@ -170,7 +170,7 @@ smb2_set_credits(struct cifs_server_info *server, const int val)
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 
-	trace_smb3_set_credits(server->CurrentMid,
+	trace_smb3_set_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, val, in_flight);
 	cifs_dbg(FYI, "%s: set %u credits\n", __func__, val);
 
@@ -219,7 +219,7 @@ smb2_wait_mtu_credits(struct cifs_server_info *server, unsigned int size,
 		} else {
 			spin_unlock(&server->req_lock);
 			spin_lock(&g_servers_lock);
-			if (server->tcpStatus == CifsExiting) {
+			if (server->status == CifsExiting) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -254,7 +254,7 @@ smb2_wait_mtu_credits(struct cifs_server_info *server, unsigned int size,
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 
-	trace_smb3_wait_credits(server->CurrentMid,
+	trace_smb3_wait_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, -(credits->value), in_flight);
 	cifs_dbg(FYI, "%s: removed %u credits total=%d\n",
 			__func__, credits->value, scredits);
@@ -274,7 +274,7 @@ smb2_adjust_credits(struct cifs_server_info *server,
 		return 0;
 
 	if (credits->value < new_val) {
-		trace_smb3_too_many_credits(server->CurrentMid,
+		trace_smb3_too_many_credits(server->current_mid,
 				server->conn_id, server->hostname, 0, credits->value - new_val, 0);
 		cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
 				credits->value, new_val);
@@ -289,7 +289,7 @@ smb2_adjust_credits(struct cifs_server_info *server,
 		in_flight = server->in_flight;
 		spin_unlock(&server->req_lock);
 
-		trace_smb3_reconnect_detected(server->CurrentMid,
+		trace_smb3_reconnect_detected(server->current_mid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
 		cifs_server_dbg(VFS, "trying to return %d credits to old session\n",
@@ -303,7 +303,7 @@ smb2_adjust_credits(struct cifs_server_info *server,
 	spin_unlock(&server->req_lock);
 	wake_up(&server->request_q);
 
-	trace_smb3_adj_credits(server->CurrentMid,
+	trace_smb3_adj_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
 	cifs_dbg(FYI, "%s: adjust added %u credits total=%d\n",
@@ -320,7 +320,7 @@ smb2_get_next_mid(struct cifs_server_info *server)
 	__u64 mid;
 	/* for SMB2 we need the current value */
 	spin_lock(&g_mid_lock);
-	mid = server->CurrentMid++;
+	mid = server->current_mid++;
 	spin_unlock(&g_mid_lock);
 	return mid;
 }
@@ -329,8 +329,8 @@ static void
 smb2_revert_current_mid(struct cifs_server_info *server, const unsigned int val)
 {
 	spin_lock(&g_mid_lock);
-	if (server->CurrentMid >= val)
-		server->CurrentMid -= val;
+	if (server->current_mid >= val)
+		server->current_mid -= val;
 	spin_unlock(&g_mid_lock);
 }
 
@@ -404,7 +404,7 @@ smb2_negotiate(const unsigned int xid,
 	int rc;
 
 	spin_lock(&g_mid_lock);
-	server->CurrentMid = 0;
+	server->current_mid = 0;
 	spin_unlock(&g_mid_lock);
 	rc = SMB2_negotiate(xid, ses, server);
 	/* BB we probably don't need to retry with modern servers */
@@ -2532,7 +2532,7 @@ smb2_is_status_pending(char *buf, struct cifs_server_info *server)
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 
-		trace_smb3_pend_credits(server->CurrentMid,
+		trace_smb3_pend_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits,
 				le16_to_cpu(shdr->CreditRequest), in_flight);
 		cifs_dbg(FYI, "%s: status pending add %u credits total=%d\n",
@@ -5080,7 +5080,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 		} else {
 			spin_lock(&g_servers_lock);
 			spin_lock(&g_mid_lock);
-			if (dw->server->tcpStatus == CifsNeedReconnect) {
+			if (dw->server->status == CifsNeedReconnect) {
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 26a4e37efc06..b5bdd7356d59 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -191,7 +191,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
+	while (server->status == CifsNeedReconnect) {
 		/*
 		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
 		 * here since they are implicitly done when session drops.
@@ -208,7 +208,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
+						      (server->status != CifsNeedReconnect),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -218,7 +218,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
+		if (server->status != CifsNeedReconnect) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -254,10 +254,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
 	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
+	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedReconnect) {
+	if (server->status == CifsNeedReconnect) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
@@ -1032,7 +1032,7 @@ SMB2_negotiate(const unsigned int xid,
 	/* SMB2 only has an extended negflavor */
 	server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
 	/* set it to the maximum buffer size value we can send with 1 credit */
-	server->maxBuf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
+	server->max_buf = min_t(unsigned int, le32_to_cpu(rsp->MaxTransactSize),
 			       SMB2_MAX_BUFFER_SIZE);
 	server->max_read = le32_to_cpu(rsp->MaxReadSize);
 	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
@@ -3776,7 +3776,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 		credits.instance = server->reconnect_instance;
 	}
 
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -4201,7 +4201,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				     rdata->offset, rdata->got_bytes);
 
 	queue_work(cifsiod_wq, &rdata->work);
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -4440,7 +4440,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 				      wdata->offset, wdata->bytes);
 
 	queue_work(cifsiod_wq, &wdata->work);
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -4874,7 +4874,7 @@ int SMB2_query_directory_init(const unsigned int xid,
 	 * BB could be 30 bytes or so longer if we used SMB2 specific
 	 * buffer lengths, but this is safe and close enough.
 	 */
-	output_size = min_t(unsigned int, output_size, server->maxBuf);
+	output_size = min_t(unsigned int, output_size, server->max_buf);
 	output_size = min_t(unsigned int, output_size, 2 << 15);
 	req->OutputBufferLength = cpu_to_le32(output_size);
 
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index a422bcd02420..4417953ecbb2 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -763,18 +763,18 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
 {
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsExiting) {
+	if (server->status == CifsExiting) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
 
-	if (server->tcpStatus == CifsNeedReconnect) {
+	if (server->status == CifsNeedReconnect) {
 		spin_unlock(&g_servers_lock);
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
-	if (server->tcpStatus == CifsNeedNegotiate &&
+	if (server->status == CifsNeedNegotiate &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return -EAGAIN;
@@ -870,7 +870,7 @@ smb2_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 	struct mid_q_entry *mid;
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsNeedNegotiate &&
+	if (server->status == CifsNeedNegotiate &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return ERR_PTR(-EAGAIN);
@@ -888,7 +888,7 @@ smb2_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		DeleteMidQEntry(mid);
+		cifs_delete_mid_q_entry(mid);
 		return ERR_PTR(rc);
 	}
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 71cc66b8f8d2..22ed055c0c39 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -38,12 +38,12 @@ cifs_wake_up_task(struct mid_q_entry *mid)
 }
 
 struct mid_q_entry *
-AllocMidQEntry(const struct smb_hdr *smb_buffer, struct cifs_server_info *server)
+cifs_alloc_mid_q_entry(const struct smb_hdr *smb_buffer, struct cifs_server_info *server)
 {
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cifs_dbg(VFS, "Null TCP session in AllocMidQEntry\n");
+		cifs_dbg(VFS, "Null TCP session in cifs_alloc_mid_q_entry\n");
 		return NULL;
 	}
 
@@ -159,7 +159,7 @@ void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
 	spin_unlock(&g_mid_lock);
 }
 
-void DeleteMidQEntry(struct mid_q_entry *midEntry)
+void cifs_delete_mid_q_entry(struct mid_q_entry *midEntry)
 {
 	cifs_mid_q_entry_release(midEntry);
 }
@@ -174,7 +174,7 @@ cifs_delete_mid(struct mid_q_entry *mid)
 	}
 	spin_unlock(&g_mid_lock);
 
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 }
 
 /*
@@ -431,7 +431,7 @@ __smb_send_rqst(struct cifs_server_info *server, int num_rqst,
 		 * socket so the server throws away the partial SMB
 		 */
 		cifs_signal_cifsd_for_reconnect(server, false);
-		trace_smb3_partial_send_reconnect(server->CurrentMid,
+		trace_smb3_partial_send_reconnect(server->current_mid,
 						  server->conn_id, server->hostname);
 	}
 smbd_done:
@@ -541,7 +541,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 		in_flight = server->in_flight;
 		spin_unlock(&server->req_lock);
 
-		trace_smb3_nblk_credits(server->CurrentMid,
+		trace_smb3_nblk_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits, -1, in_flight);
 		cifs_dbg(FYI, "%s: remove %u credits total=%d\n",
 				__func__, 1, scredits);
@@ -564,7 +564,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 				in_flight = server->in_flight;
 				spin_unlock(&server->req_lock);
 
-				trace_smb3_credit_timeout(server->CurrentMid,
+				trace_smb3_credit_timeout(server->current_mid,
 						server->conn_id, server->hostname, scredits,
 						num_credits, in_flight);
 				cifs_server_dbg(VFS, "wait timed out after %d ms\n",
@@ -578,7 +578,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 			spin_unlock(&server->req_lock);
 
 			spin_lock(&g_servers_lock);
-			if (server->tcpStatus == CifsExiting) {
+			if (server->status == CifsExiting) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -617,7 +617,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 					spin_unlock(&server->req_lock);
 
 					trace_smb3_credit_timeout(
-							server->CurrentMid,
+							server->current_mid,
 							server->conn_id, server->hostname,
 							scredits, num_credits, in_flight);
 					cifs_server_dbg(VFS, "wait timed out after %d ms\n",
@@ -647,7 +647,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 			in_flight = server->in_flight;
 			spin_unlock(&server->req_lock);
 
-			trace_smb3_waitff_credits(server->CurrentMid,
+			trace_smb3_waitff_credits(server->current_mid,
 					server->conn_id, server->hostname, scredits,
 					-(num_credits), in_flight);
 			cifs_dbg(FYI, "%s: remove %u credits total=%d\n",
@@ -698,7 +698,7 @@ wait_for_compound_request(struct cifs_server_info *server, int num,
 		 */
 		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
-			trace_smb3_insufficient_credits(server->CurrentMid,
+			trace_smb3_insufficient_credits(server->current_mid,
 					server->conn_id, server->hostname, scredits,
 					num, in_flight);
 			cifs_dbg(FYI, "%s: %d requests in flight, needed %d total=%d\n",
@@ -745,7 +745,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	}
 	spin_unlock(&g_servers_lock);
 
-	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
+	*ppmidQ = cifs_alloc_mid_q_entry(in_buf, ses->server);
 	if (*ppmidQ == NULL)
 		return -ENOMEM;
 	spin_lock(&g_mid_lock);
@@ -782,13 +782,13 @@ cifs_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 	if (server->sign)
 		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	mid = AllocMidQEntry(hdr, server);
+	mid = cifs_alloc_mid_q_entry(hdr, server);
 	if (mid == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
-		DeleteMidQEntry(mid);
+		cifs_delete_mid_q_entry(mid);
 		return ERR_PTR(rc);
 	}
 
@@ -937,7 +937,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct cifs_server_info *server)
 	}
 	spin_unlock(&g_mid_lock);
 
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 	return rc;
 }
 
@@ -1026,7 +1026,7 @@ static void
 cifs_cancelled_callback(struct mid_q_entry *mid)
 {
 	cifs_compound_callback(mid);
-	DeleteMidQEntry(mid);
+	cifs_delete_mid_q_entry(mid);
 }
 
 /*
@@ -1079,7 +1079,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsExiting) {
+	if (server->status == CifsExiting) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1361,7 +1361,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsExiting) {
+	if (server->status == CifsExiting) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1369,7 +1369,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	/* Ensure that we do not send more than 50 overlapping requests
 	   to the same server. We may make this configurable later or
-	   use ses->maxReq */
+	   use ses->max_req */
 
 	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 		cifs_server_dbg(VFS, "Invalid length, greater than maximum frame, %d\n",
@@ -1422,7 +1422,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		spin_lock(&g_mid_lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 			/* no longer considered to be "in-flight" */
-			midQ->callback = DeleteMidQEntry;
+			midQ->callback = cifs_delete_mid_q_entry;
 			spin_unlock(&g_mid_lock);
 			add_credits(server, &credits, 0);
 			return rc;
@@ -1506,7 +1506,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->tcpStatus == CifsExiting) {
+	if (server->status == CifsExiting) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1514,7 +1514,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Ensure that we do not send more than 50 overlapping requests
 	   to the same server. We may make this configurable later or
-	   use ses->maxReq */
+	   use ses->max_req */
 
 	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
 		cifs_tcon_dbg(VFS, "Invalid length, greater than maximum frame, %d\n",
@@ -1564,15 +1564,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(server->response_q,
 		(!(midQ->mid_state == MID_REQUEST_SUBMITTED)) ||
-		((server->tcpStatus != CifsGood) &&
-		 (server->tcpStatus != CifsNew)));
+		((server->status != CifsGood) &&
+		 (server->status != CifsNew)));
 
 	/* Were we interrupted by a signal ? */
 	spin_lock(&g_servers_lock);
 	if ((rc == -ERESTARTSYS) &&
 		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
-		((server->tcpStatus == CifsGood) ||
-		 (server->tcpStatus == CifsNew))) {
+		((server->status == CifsGood) ||
+		 (server->status == CifsNew))) {
 		spin_unlock(&g_servers_lock);
 
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
@@ -1603,7 +1603,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			spin_lock(&g_mid_lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
 				/* no longer considered to be "in-flight" */
-				midQ->callback = DeleteMidQEntry;
+				midQ->callback = cifs_delete_mid_q_entry;
 				spin_unlock(&g_mid_lock);
 				return rc;
 			}
-- 
2.35.3

