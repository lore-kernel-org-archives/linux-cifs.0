Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401A2C3A5A3
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 03:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDBF205C9
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 03:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfH1DRu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 23:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbfH1DRu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 27 Aug 2019 23:17:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9ECFE10C6963;
        Wed, 28 Aug 2019 03:17:49 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AA0F5C220;
        Wed, 28 Aug 2019 03:17:48 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add new debugging macro cifs_server_dbg
Date:   Wed, 28 Aug 2019 13:17:42 +1000
Message-Id: <20190828031742.6234-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 28 Aug 2019 03:17:49 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

which can be used from contexts where we have a TCP_Server_Info *server.
This new macro will prepend the debugging string with "Server:<servername> "
which will help when debugging issues on hosts with many cifs connections
to several different servers.

Convert a bunch of callsites in connect.c from cifs_dbg to instead use
cifs_server_dbg.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_debug.h |  31 ++++++++
 fs/cifs/connect.c    | 194 +++++++++++++++++++++++++--------------------------
 2 files changed, 128 insertions(+), 97 deletions(-)

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 3d392620a2f4..567af916f103 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -80,6 +80,30 @@ do {							\
 			type, fmt, ##__VA_ARGS__);	\
 } while (0)
 
+#define cifs_server_dbg_func(ratefunc, type, fmt, ...)		\
+do {								\
+	if ((type) & FYI && cifsFYI & CIFS_INFO) {		\
+		pr_debug_ ## ratefunc("%s: Server:%s "	fmt,	\
+			__FILE__, server->hostname, ##__VA_ARGS__);\
+	} else if ((type) & VFS) {				\
+		pr_err_ ## ratefunc("CIFS VFS: Server:%s " fmt,	\
+			server->hostname, ##__VA_ARGS__);	\
+	} else if ((type) & NOISY && (NOISY != 0)) {		\
+		pr_debug_ ## ratefunc("Server:%s " fmt,		\
+			server->hostname, ##__VA_ARGS__);	\
+	}							\
+} while (0)
+
+#define cifs_server_dbg(type, fmt, ...)			\
+do {							\
+	if ((type) & ONCE)				\
+		cifs_server_dbg_func(once,		\
+			type, fmt, ##__VA_ARGS__);	\
+	else						\
+		cifs_server_dbg_func(ratelimited,	\
+			type, fmt, ##__VA_ARGS__);	\
+} while (0)
+
 /*
  *	debug OFF
  *	---------
@@ -91,6 +115,13 @@ do {									\
 		pr_debug(fmt, ##__VA_ARGS__);				\
 } while (0)
 
+#define cifs_server_dbg(type, fmt, ...)					\
+do {									\
+	if (0)								\
+		pr_debug("Server:%s " fmt,				\
+			 server->hostname, ##__VA_ARGS__);		\
+} while (0)
+
 #define cifs_info(fmt, ...)						\
 do {									\
 	pr_info("CIFS: "fmt, ##__VA_ARGS__);				\
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5299effa6f7d..31c4762748f5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -348,7 +348,7 @@ static int reconn_set_ipaddr(struct TCP_Server_Info *server)
 
 	unc = kmalloc(len, GFP_KERNEL);
 	if (!unc) {
-		cifs_dbg(FYI, "%s: failed to create UNC path\n", __func__);
+		cifs_server_dbg(FYI, "%s: failed to create UNC path\n", __func__);
 		return -ENOMEM;
 	}
 	scnprintf(unc, len, "\\\\%s", server->hostname);
@@ -429,7 +429,7 @@ static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
 			*tgt_it = dfs_cache_get_tgt_iterator(tgt_list);
 	}
 
-	cifs_dbg(FYI, "%s: UNC: %s\n", __func__, cifs_sb->origin_fullpath);
+	cifs_server_dbg(FYI, "%s: UNC: %s\n", __func__, cifs_sb->origin_fullpath);
 
 	name = dfs_cache_get_tgt_name(*tgt_it);
 
@@ -437,7 +437,7 @@ static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
 
 	server->hostname = extract_hostname(name);
 	if (IS_ERR(server->hostname)) {
-		cifs_dbg(FYI,
+		cifs_server_dbg(FYI,
 			 "%s: failed to extract hostname from target: %ld\n",
 			 __func__, PTR_ERR(server->hostname));
 	}
@@ -483,19 +483,19 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	cifs_sb = find_super_by_tcp(server);
 	if (IS_ERR(cifs_sb)) {
 		rc = PTR_ERR(cifs_sb);
-		cifs_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
+		cifs_server_dbg(FYI, "%s: will not do DFS failover: rc = %d\n",
 			 __func__, rc);
 		cifs_sb = NULL;
 	} else {
 		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list, &tgt_it);
 		if (rc && (rc != -EOPNOTSUPP)) {
-			cifs_dbg(VFS, "%s: no target servers for DFS failover\n",
+			cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
 				 __func__);
 		} else {
 			server->nr_targets = dfs_cache_get_nr_tgts(&tgt_list);
 		}
 	}
-	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
+	cifs_server_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
 		 server->nr_targets);
 	spin_lock(&GlobalMid_Lock);
 #endif
@@ -504,18 +504,17 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		next time through the loop */
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
-	} else
-		server->tcpStatus = CifsNeedReconnect;
+	} else		server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
 	server->max_read = 0;
 
-	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
+	cifs_server_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->CurrentMid, server->hostname);
 
 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
-	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n",
+	cifs_server_dbg(FYI, "%s: marking sessions and tcons for reconnect\n",
 		 __func__);
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
@@ -531,13 +530,13 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* do not want to be sending data on a socket we are freeing */
-	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
+	cifs_server_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
-		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
+		cifs_server_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
 			 server->ssocket->state, server->ssocket->flags);
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
+		cifs_server_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
 			 server->ssocket->state, server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
@@ -551,7 +550,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
-	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
+	cifs_server_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -562,7 +561,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	mutex_unlock(&server->srv_mutex);
 
-	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
+	cifs_server_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_safe(tmp, tmp2, &retry_list) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
@@ -589,14 +588,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		else
 			rc = generic_ip_connect(server);
 		if (rc) {
-			cifs_dbg(FYI, "reconnect error %d\n", rc);
+			cifs_server_dbg(FYI, "reconnect error %d\n", rc);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 			reconn_inval_dfs_target(server, cifs_sb, &tgt_list,
 						&tgt_it);
 #endif
 			rc = reconn_set_ipaddr(server);
 			if (rc) {
-				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
+				cifs_server_dbg(FYI, "%s: failed to resolve hostname: %d\n",
 					 __func__, rc);
 			}
 			mutex_unlock(&server->srv_mutex);
@@ -617,12 +616,12 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		rc = dfs_cache_noreq_update_tgthint(cifs_sb->origin_fullpath + 1,
 						    tgt_it);
 		if (rc) {
-			cifs_dbg(VFS, "%s: failed to update DFS target hint: rc = %d\n",
+			cifs_server_dbg(VFS, "%s: failed to update DFS target hint: rc = %d\n",
 				 __func__, rc);
 		}
 		rc = dfs_cache_update_vol(cifs_sb->origin_fullpath, server);
 		if (rc) {
-			cifs_dbg(VFS, "%s: failed to update vol info in DFS cache: rc = %d\n",
+			cifs_server_dbg(VFS, "%s: failed to update vol info in DFS cache: rc = %d\n",
 				 __func__, rc);
 		}
 		dfs_cache_free_tgts(&tgt_list);
@@ -665,8 +664,7 @@ cifs_echo_request(struct work_struct *work)
 
 	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
 	if (rc)
-		cifs_dbg(FYI, "Unable to send echo request to server: %s\n",
-			 server->hostname);
+		cifs_server_dbg(FYI, "Unable to send echo request to server.\n");
 
 requeue_echo:
 	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
@@ -678,7 +676,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->bigbuf) {
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
-			cifs_dbg(VFS, "No memory for large SMB response\n");
+			cifs_server_dbg(VFS, "No memory for large SMB response\n");
 			msleep(3000);
 			/* retry will check if exiting */
 			return false;
@@ -691,7 +689,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->smallbuf) {
 		server->smallbuf = (char *)cifs_small_buf_get();
 		if (!server->smallbuf) {
-			cifs_dbg(VFS, "No memory for SMB response\n");
+			cifs_server_dbg(VFS, "No memory for SMB response\n");
 			msleep(1000);
 			/* retry will check if exiting */
 			return false;
@@ -722,8 +720,8 @@ server_unresponsive(struct TCP_Server_Info *server)
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
-		cifs_dbg(VFS, "Server %s has not responded in %lu seconds. Reconnecting...\n",
-			 server->hostname, (3 * server->echo_interval) / HZ);
+		cifs_server_dbg(VFS, "has not responded in %lu seconds. Reconnecting...\n",
+			 (3 * server->echo_interval) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
@@ -794,7 +792,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 		}
 
 		if (length <= 0) {
-			cifs_dbg(FYI, "Received no data or error: %d\n", length);
+			cifs_server_dbg(FYI, "Received no data or error: %d\n", length);
 			cifs_reconnect(server);
 			return -ECONNABORTED;
 		}
@@ -837,17 +835,17 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		/* Regular SMB response */
 		return true;
 	case RFC1002_SESSION_KEEP_ALIVE:
-		cifs_dbg(FYI, "RFC 1002 session keep alive\n");
+		cifs_server_dbg(FYI, "RFC 1002 session keep alive\n");
 		break;
 	case RFC1002_POSITIVE_SESSION_RESPONSE:
-		cifs_dbg(FYI, "RFC 1002 positive session response\n");
+		cifs_server_dbg(FYI, "RFC 1002 positive session response\n");
 		break;
 	case RFC1002_NEGATIVE_SESSION_RESPONSE:
 		/*
 		 * We get this from Windows 98 instead of an error on
 		 * SMB negprot response.
 		 */
-		cifs_dbg(FYI, "RFC 1002 negative session response\n");
+		cifs_server_dbg(FYI, "RFC 1002 negative session response\n");
 		/* give server a second to clean up */
 		msleep(1000);
 		/*
@@ -861,7 +859,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		wake_up(&server->response_q);
 		break;
 	default:
-		cifs_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", type);
+		cifs_server_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", type);
 		cifs_reconnect(server);
 	}
 
@@ -956,7 +954,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+			cifs_server_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
 		}
@@ -965,7 +963,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
+			cifs_server_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 		}
@@ -982,7 +980,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 * least 45 seconds before giving up on a request getting a
 		 * response and going ahead and killing cifsd.
 		 */
-		cifs_dbg(FYI, "Wait for exit from demultiplex thread\n");
+		cifs_server_dbg(FYI, "Wait for exit from demultiplex thread\n");
 		msleep(46000);
 		/*
 		 * If threads still have not exited they are probably never
@@ -1008,7 +1006,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* make sure this will fit in a large buffer */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) -
 		server->vals->header_preamble_size) {
-		cifs_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
+		cifs_server_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -ECONNABORTED;
@@ -1106,7 +1104,7 @@ cifs_demultiplex_thread(void *p)
 	char *bufs[MAX_COMPOUND];
 
 	current->flags |= PF_MEMALLOC;
-	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
+	cifs_server_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
 
 	length = atomic_inc_return(&tcpSesAllocCount);
 	if (length > 1)
@@ -1140,7 +1138,7 @@ cifs_demultiplex_thread(void *p)
 		 */
 		pdu_length = get_rfc1002_length(buf);
 
-		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
+		cifs_server_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 next_pdu:
@@ -1149,7 +1147,7 @@ cifs_demultiplex_thread(void *p)
 		/* make sure we have enough to get to the MID */
 		if (server->pdu_size < HEADER_SIZE(server) - 1 -
 		    server->vals->header_preamble_size) {
-			cifs_dbg(VFS, "SMB response too short (%u bytes)\n",
+			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
 				 server->pdu_size);
 			cifs_reconnect(server);
 			wake_up(&server->response_q);
@@ -1220,9 +1218,9 @@ cifs_demultiplex_thread(void *p)
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
 				smb2_add_credits_from_hdr(bufs[i], server);
-				cifs_dbg(FYI, "Received oplock break\n");
+				cifs_server_dbg(FYI, "Received oplock break\n");
 			} else {
-				cifs_dbg(VFS, "No task to wake, unknown frame "
+				cifs_server_dbg(VFS, "No task to wake, unknown frame "
 					 "received! NumMids %d\n",
 					 atomic_read(&midCount));
 				cifs_dump_mem("Received Data is: ", bufs[i],
@@ -2601,7 +2599,7 @@ cifs_find_tcp_session(struct smb_vol *vol)
 
 		++server->srv_count;
 		spin_unlock(&cifs_tcp_ses_lock);
-		cifs_dbg(FYI, "Existing tcp session with server found\n");
+		cifs_server_dbg(FYI, "Existing tcp session with server found\n");
 		return server;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -2837,6 +2835,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb_vol *volume_info)
 {
 	int rc = 0, xid;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server = ses->server;
 	struct nls_table *nls_codepage;
 	char unc[SERVER_NAME_LENGTH + sizeof("//x/IPC$")] = {0};
 	bool seal = false;
@@ -2849,7 +2848,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb_vol *volume_info)
 		if (ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION)
 			seal = true;
 		else {
-			cifs_dbg(VFS,
+			cifs_server_dbg(VFS,
 				 "IPC: server doesn't support encryption\n");
 			return -EOPNOTSUPP;
 		}
@@ -2872,12 +2871,12 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb_vol *volume_info)
 	free_xid(xid);
 
 	if (rc) {
-		cifs_dbg(VFS, "failed to connect to IPC (rc=%d)\n", rc);
+		cifs_server_dbg(VFS, "failed to connect to IPC (rc=%d)\n", rc);
 		tconInfoFree(tcon);
 		goto out;
 	}
 
-	cifs_dbg(FYI, "IPC tcon rc = %d ipc tid = %d\n", rc, tcon->tid);
+	cifs_server_dbg(FYI, "IPC tcon rc = %d ipc tid = %d\n", rc, tcon->tid);
 
 	ses->tcon_ipc = tcon;
 out:
@@ -2895,6 +2894,7 @@ cifs_free_ipc(struct cifs_ses *ses)
 {
 	int rc = 0, xid;
 	struct cifs_tcon *tcon = ses->tcon_ipc;
+	struct TCP_Server_Info *server = ses->server;
 
 	if (tcon == NULL)
 		return 0;
@@ -2906,7 +2906,7 @@ cifs_free_ipc(struct cifs_ses *ses)
 	}
 
 	if (rc)
-		cifs_dbg(FYI, "failed to disconnect IPC tcon (rc=%d)\n", rc);
+		cifs_server_dbg(FYI, "failed to disconnect IPC tcon (rc=%d)\n", rc);
 
 	tconInfoFree(tcon);
 	ses->tcon_ipc = NULL;
@@ -2937,7 +2937,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	unsigned int rc, xid;
 	struct TCP_Server_Info *server = ses->server;
 
-	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
+	cifs_server_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	if (ses->status == CifsExiting) {
@@ -2958,7 +2958,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
-			cifs_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
+			cifs_server_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
 				__func__, rc);
 		_free_xid(xid);
 	}
@@ -3006,24 +3006,24 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 		sprintf(desc, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
 		break;
 	default:
-		cifs_dbg(FYI, "Bad ss_family (%hu)\n",
+		cifs_server_dbg(FYI, "Bad ss_family (%hu)\n",
 			 server->dstaddr.ss_family);
 		rc = -EINVAL;
 		goto out_err;
 	}
 
-	cifs_dbg(FYI, "%s: desc=%s\n", __func__, desc);
+	cifs_server_dbg(FYI, "%s: desc=%s\n", __func__, desc);
 	key = request_key(&key_type_logon, desc, "");
 	if (IS_ERR(key)) {
 		if (!ses->domainName) {
-			cifs_dbg(FYI, "domainName is NULL\n");
+			cifs_server_dbg(FYI, "domainName is NULL\n");
 			rc = PTR_ERR(key);
 			goto out_err;
 		}
 
 		/* didn't work, try to find a domain key */
 		sprintf(desc, "cifs:d:%s", ses->domainName);
-		cifs_dbg(FYI, "%s: desc=%s\n", __func__, desc);
+		cifs_server_dbg(FYI, "%s: desc=%s\n", __func__, desc);
 		key = request_key(&key_type_logon, desc, "");
 		if (IS_ERR(key)) {
 			rc = PTR_ERR(key);
@@ -3042,9 +3042,9 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
+	cifs_server_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
-		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
+		cifs_server_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);
 		rc = -EINVAL;
 		goto out_key_put;
@@ -3052,7 +3052,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 
 	len = delim - payload;
 	if (len > CIFS_MAX_USERNAME_LEN || len <= 0) {
-		cifs_dbg(FYI, "Bad value from username search (len=%zd)\n",
+		cifs_server_dbg(FYI, "Bad value from username search (len=%zd)\n",
 			 len);
 		rc = -EINVAL;
 		goto out_key_put;
@@ -3060,16 +3060,16 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 
 	vol->username = kstrndup(payload, len, GFP_KERNEL);
 	if (!vol->username) {
-		cifs_dbg(FYI, "Unable to allocate %zd bytes for username\n",
+		cifs_server_dbg(FYI, "Unable to allocate %zd bytes for username\n",
 			 len);
 		rc = -ENOMEM;
 		goto out_key_put;
 	}
-	cifs_dbg(FYI, "%s: username=%s\n", __func__, vol->username);
+	cifs_server_dbg(FYI, "%s: username=%s\n", __func__, vol->username);
 
 	len = key->datalen - (len + 1);
 	if (len > CIFS_MAX_PASSWORD_LEN || len <= 0) {
-		cifs_dbg(FYI, "Bad len for password search (len=%zd)\n", len);
+		cifs_server_dbg(FYI, "Bad len for password search (len=%zd)\n", len);
 		rc = -EINVAL;
 		kfree(vol->username);
 		vol->username = NULL;
@@ -3079,7 +3079,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	++delim;
 	vol->password = kstrndup(delim, len, GFP_KERNEL);
 	if (!vol->password) {
-		cifs_dbg(FYI, "Unable to allocate %zd bytes for password\n",
+		cifs_server_dbg(FYI, "Unable to allocate %zd bytes for password\n",
 			 len);
 		rc = -ENOMEM;
 		kfree(vol->username);
@@ -3096,7 +3096,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 					   strlen(ses->domainName),
 					   GFP_KERNEL);
 		if (!vol->domainname) {
-			cifs_dbg(FYI, "Unable to allocate %zd bytes for "
+			cifs_server_dbg(FYI, "Unable to allocate %zd bytes for "
 				 "domain\n", len);
 			rc = -ENOMEM;
 			kfree(vol->username);
@@ -3112,7 +3112,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	key_put(key);
 out_err:
 	kfree(desc);
-	cifs_dbg(FYI, "%s: returning %d\n", __func__, rc);
+	cifs_server_dbg(FYI, "%s: returning %d\n", __func__, rc);
 	return rc;
 }
 #else /* ! CONFIG_KEYS */
@@ -3144,7 +3144,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 
 	ses = cifs_find_smb_ses(server, volume_info);
 	if (ses) {
-		cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
+		cifs_server_dbg(FYI, "Existing smb sess found (status=%d)\n",
 			 ses->status);
 
 		mutex_lock(&ses->session_mutex);
@@ -3157,7 +3157,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 			return ERR_PTR(rc);
 		}
 		if (ses->need_reconnect) {
-			cifs_dbg(FYI, "Session needs reconnect\n");
+			cifs_server_dbg(FYI, "Session needs reconnect\n");
 			rc = cifs_setup_session(xid, ses,
 						volume_info->local_nls);
 			if (rc) {
@@ -3176,7 +3176,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		return ses;
 	}
 
-	cifs_dbg(FYI, "Existing smb sess not found\n");
+	cifs_server_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
 		goto get_ses_fail;
@@ -3331,6 +3331,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 {
 	int rc, xid;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server = ses->server;
 
 	tcon = cifs_find_tcon(ses, volume_info);
 	if (tcon) {
@@ -3338,7 +3339,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		 * tcon has refcount already incremented but we need to
 		 * decrement extra ses reference gotten by caller (case b)
 		 */
-		cifs_dbg(FYI, "Found match on UNC path\n");
+		cifs_server_dbg(FYI, "Found match on UNC path\n");
 		cifs_put_smb_ses(ses);
 		return tcon;
 	}
@@ -3355,8 +3356,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	}
 
 	if (volume_info->snapshot_time) {
-		if (ses->server->vals->protocol_id == 0) {
-			cifs_dbg(VFS,
+		if (server->vals->protocol_id == 0) {
+			cifs_server_dbg(VFS,
 			     "Use SMB2 or later for snapshot mount option\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
@@ -3365,8 +3366,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	}
 
 	if (volume_info->handle_timeout) {
-		if (ses->server->vals->protocol_id == 0) {
-			cifs_dbg(VFS,
+		if (server->vals->protocol_id == 0) {
+			cifs_server_dbg(VFS,
 			     "Use SMB2.1 or later for handle timeout option\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
@@ -3384,28 +3385,27 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	}
 
 	if (volume_info->seal) {
-		if (ses->server->vals->protocol_id == 0) {
-			cifs_dbg(VFS,
+		if (server->vals->protocol_id == 0) {
+			cifs_server_dbg(VFS,
 				 "SMB3 or later required for encryption\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
-		} else if (tcon->ses->server->capabilities &
-					SMB2_GLOBAL_CAP_ENCRYPTION)
+		} else if (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION)
 			tcon->seal = true;
 		else {
-			cifs_dbg(VFS, "Encryption is not supported on share\n");
+			cifs_server_dbg(VFS, "Encryption is not supported on share\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		}
 	}
 
 	if (volume_info->linux_ext) {
-		if (ses->server->posix_ext_supported) {
+		if (server->posix_ext_supported) {
 			tcon->posix_extensions = true;
 			printk_once(KERN_WARNING
 				"SMB3.11 POSIX Extensions are experimental\n");
 		} else {
-			cifs_dbg(VFS, "Server does not support mounting with posix SMB3.11 extensions.\n");
+			cifs_server_dbg(VFS, "does not support mounting with posix SMB3.11 extensions.\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		}
@@ -3416,38 +3416,38 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	 * SetFS as we do on SessSetup and reconnect?
 	 */
 	xid = get_xid();
-	rc = ses->server->ops->tree_connect(xid, ses, volume_info->UNC, tcon,
+	rc = server->ops->tree_connect(xid, ses, volume_info->UNC, tcon,
 					    volume_info->local_nls);
 	free_xid(xid);
-	cifs_dbg(FYI, "Tcon rc = %d\n", rc);
+	cifs_server_dbg(FYI, "Tcon rc = %d\n", rc);
 	if (rc)
 		goto out_fail;
 
 	tcon->use_persistent = false;
 	/* check if SMB2 or later, CIFS does not support persistent handles */
 	if (volume_info->persistent) {
-		if (ses->server->vals->protocol_id == 0) {
-			cifs_dbg(VFS,
+		if (server->vals->protocol_id == 0) {
+			cifs_server_dbg(VFS,
 			     "SMB3 or later required for persistent handles\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
-		} else if (ses->server->capabilities &
+		} else if (server->capabilities &
 			   SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
 			tcon->use_persistent = true;
 		else /* persistent handles requested but not supported */ {
-			cifs_dbg(VFS,
+			cifs_server_dbg(VFS,
 				"Persistent handles not supported on share\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		}
 	} else if ((tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
-	     && (ses->server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
+	     && (server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
 	     && (volume_info->nopersistent == false)) {
-		cifs_dbg(FYI, "enabling persistent handles\n");
+		cifs_server_dbg(FYI, "enabling persistent handles\n");
 		tcon->use_persistent = true;
 	} else if (volume_info->resilient) {
-		if (ses->server->vals->protocol_id == 0) {
-			cifs_dbg(VFS,
+		if (server->vals->protocol_id == 0) {
+			cifs_server_dbg(VFS,
 			     "SMB2.1 or later required for resilient handles\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
@@ -3659,10 +3659,10 @@ bind_socket(struct TCP_Server_Info *server)
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
-				cifs_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n",
+				cifs_server_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n",
 					 &saddr6->sin6_addr, rc);
 			else
-				cifs_dbg(VFS, "Failed to bind to: %pI4, error: %d\n",
+				cifs_server_dbg(VFS, "Failed to bind to: %pI4, error: %d\n",
 					 &saddr4->sin_addr.s_addr, rc);
 		}
 	}
@@ -3766,13 +3766,13 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
 				   IPPROTO_TCP, &socket, 1);
 		if (rc < 0) {
-			cifs_dbg(VFS, "Error %d creating socket\n", rc);
+			cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
 			server->ssocket = NULL;
 			return rc;
 		}
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cifs_dbg(FYI, "Socket created\n");
+		cifs_server_dbg(FYI, "Socket created\n");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
 		if (sfamily == AF_INET6)
@@ -3806,17 +3806,17 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
 				(char *)&val, sizeof(val));
 		if (rc)
-			cifs_dbg(FYI, "set TCP_NODELAY socket option error %d\n",
+			cifs_server_dbg(FYI, "set TCP_NODELAY socket option error %d\n",
 				 rc);
 	}
 
-	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
+	cifs_server_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
 	rc = socket->ops->connect(socket, saddr, slen, 0);
 	if (rc < 0) {
-		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
+		cifs_server_dbg(FYI, "Error %d connecting to server\n", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -4150,7 +4150,7 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 	if ((vol->persistent == true) && (!(ses->server->capabilities &
 					    SMB2_GLOBAL_CAP_PERSISTENT_HANDLES))) {
-		cifs_dbg(VFS, "persistent handles not supported by server\n");
+		cifs_server_dbg(VFS, "persistent handles not supported by server\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -4575,7 +4575,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 	if (full_path == NULL)
 		return -ENOMEM;
 
-	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
+	cifs_server_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
 
 	rc = server->ops->is_path_accessible(xid, tcon, cifs_sb,
 					     full_path);
@@ -4588,7 +4588,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
 			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
-			cifs_dbg(VFS, "cannot query dirs between root and final path, "
+			cifs_server_dbg(VFS, "cannot query dirs between root and final path, "
 				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
 			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 			rc = 0;
@@ -5075,11 +5075,11 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (linuxExtEnabled == 0)
 		ses->capabilities &= (~server->vals->cap_unix);
 
-	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
+	cifs_server_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
 	if (ses->auth_key.response) {
-		cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
+		cifs_server_dbg(FYI, "Free previous auth_key.response = %p\n",
 			 ses->auth_key.response);
 		kfree(ses->auth_key.response);
 		ses->auth_key.response = NULL;
@@ -5090,7 +5090,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		rc = server->ops->sess_setup(xid, ses, nls_info);
 
 	if (rc)
-		cifs_dbg(VFS, "Send error in SessSetup = %d\n", rc);
+		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 
 	return rc;
 }
-- 
2.13.6

