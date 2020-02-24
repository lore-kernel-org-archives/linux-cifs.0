Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7797BC11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42EAA2072D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xcc6/Id2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgBXNW5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:22:57 -0500
Received: from hr2.samba.org ([144.76.82.148]:44828 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBXNW4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:22:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=oKtVqKbb20xUuI7tPUlbVB6/6UscNAxAcxA6tg0uyWI=; b=xcc6/Id2kEFVwp2nORgD6LYUCi
        W27RQhxz081qd0gFywft85K/yZyfWTJgaBdbYnYJSxt2sfRevCUPfyXVXae/q5KDQ4X0v03kMqE4m
        PIMcfy20+ILS/KlV0YnJGq2/cogy8CCdtPtMddrZUCCXqsO47y3ilG/ndT8cjxxvTnZ+toHu4gl1j
        h6Sr5O/PKZgkBKVOVlU81LxR8TL6bS75MWtAq9eBLK6PsB3FmTUWe1eGlH/mLkDBcNUqpf2ICniB5
        yxCqmenUWSYsVHlXG3ZGktUrl8HWJvCu7akhBZ4uRdFt99DNVe5ye3nyKBtsVTfZkmL8s1Q4rrdAK
        pXrD/FXqcxome+Vk20qCLLnAVjAslCWVZRPQzy6eSccpinjKhWeexX/IpCRVstGHD3uHRpLjX83TN
        5JXBFSLhPa1q+XySfQ4MX/bp6d2WD6qJQgNCzxJYOxyUtnlZIJqiJ1mO8zGYkm5iR0UPF1zB+mKUh
        niLTrT07lc9+ZbQyQv6sRLzK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaT-00061e-8d; Mon, 24 Feb 2020 13:15:53 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 13/13] cifs: introduce the CifsInvalidCredentials session state
Date:   Mon, 24 Feb 2020 14:15:10 +0100
Message-Id: <20200224131510.20608-14-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1579050

If a session setup gets NT_STATUS_LOGON_FAILURE of
NT_STATUS_ACCOUNT_LOCKED_OUT, we're not able to make any further
progress with the credentials the kernel knowns about.

Instead of retrying for each new request, we should mark
the session with CifsInvalidCredentials (for know we only do that
for soft mounts). We consistently return -EKEYREVOKED for such sessions,
I guess that's better than -EHOSTDOWN.

A future addition would be an upcall to get new credentials from
userspace, or a way to use a magic file per session under /proc/fs/cifs/
to provide new credentials.

But for now we want to avoid that we lock out the users account,
by retrying every 2 seconds.

Note backports also need the other 12 patches before.

Fixes: b0dd940e582b6a6 ("cifs: fail i/o on soft mounts if sessionsetup errors out")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Stable <stable@vger.kernel.org>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_debug.c |   2 +
 fs/cifs/cifsfs.c     |   1 +
 fs/cifs/cifsglob.h   |   4 +-
 fs/cifs/connect.c    | 145 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 148 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 276e4b5ea8e0..c03a445e95bc 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -392,6 +392,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 			/* dump session id helpful for use with network trace */
 			seq_printf(m, " SessionId: 0x%llx", ses->Suid);
+			if (ses->status == CifsInvalidCredentials)
+				seq_printf(m, " InvalidCredentials!");
 			if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 				seq_puts(m, " encrypted");
 			if (ses->sign)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 46ebaf3f0824..9e2e5fa2cdff 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -650,6 +650,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
+		wake_up_all(&tcon->ses->server->demultiplex_q);
 		wake_up_all(&tcon->ses->server->request_q);
 		wake_up_all(&tcon->ses->server->response_q);
 		msleep(1); /* yield */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8393ed7ebf96..4494b35fa5c5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -114,7 +114,8 @@ enum statusEnum {
 	CifsGood,
 	CifsExiting,
 	CifsNeedReconnect,
-	CifsNeedNegotiate
+	CifsNeedNegotiate,
+	CifsInvalidCredentials,
 };
 
 enum securityEnum {
@@ -687,6 +688,7 @@ struct TCP_Server_Info {
 #endif
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
+	wait_queue_head_t demultiplex_q;
 	struct list_head pending_mid_q;
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7f4be85b7cc9..39c0a5154eb9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -480,6 +480,65 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 }
 #endif
 
+static bool
+server_should_poll_for_responses(struct TCP_Server_Info *server)
+{
+	switch (server->tcpStatus) {
+	case CifsNew:
+		return false;
+	case CifsExiting:
+		return false;
+	case CifsGood:
+		return true;
+	case CifsNeedReconnect:
+		return false;
+	case CifsNeedNegotiate:
+		return true;
+	case CifsInvalidCredentials:
+		/*
+		 * Only a session should have this state
+		 */
+		WARN(true, "BUG! server->tcpStatus=CifsInvalidCredentials\n");
+		return false;
+	}
+
+	WARN(true, "Unhandled server->tcpStatus=%u\n", server->tcpStatus);
+	return false;
+}
+
+static bool
+server_should_reconnect(struct TCP_Server_Info *server)
+{
+	struct cifs_ses *ses;
+	size_t num_valid = 0;
+	size_t num_invalid = 0;
+
+	/*
+	 * If we are in disconnected state, waiting for a reconnect,
+	 * we should only try to reconnect if there's a chance
+	 * of success, that's not the case of all sessions
+	 * are have invalid credentials.
+	 */
+	if (server->tcpStatus != CifsNeedReconnect)
+		return false;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->status != CifsInvalidCredentials) {
+			num_valid++;
+		} else {
+			num_invalid++;
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	if (num_invalid == 0 || num_valid != 0) {
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * cifs tcp session reconnection
  *
@@ -617,6 +676,17 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		try_to_freeze();
 
 		mutex_lock(&server->srv_mutex);
+
+		if (!server_should_reconnect(server)) {
+			cifs_dbg(VFS,
+				 "Server %s was disconnected. "
+				 "We should NOT reconnect...\n",
+				 server->hostname);
+			rc = -ECONNABORTED;
+			mutex_unlock(&server->srv_mutex);
+			break;
+		}
+
 		/*
 		 * Set up next DFS target server (if any) for reconnect. If DFS
 		 * feature is disabled, then we will retry last server we
@@ -669,8 +739,17 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 	put_tcp_super(sb);
 #endif
-	if (server->tcpStatus == CifsNeedNegotiate)
-		mod_delayed_work(cifsiod_wq, &server->echo, 0);
+	if (server->tcpStatus == CifsNeedNegotiate) {
+		/* unfreeze the demultiplex thread */
+		wake_up_all(&server->demultiplex_q);
+		/*
+		 * schedule a immediate reconnect of sessions
+		 * and tcons.
+		 */
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		/* reset the echo timer into the future. */
+		mod_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
+	}
 
 	wake_up(&server->response_q);
 	return rc;
@@ -872,6 +951,19 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
+		if (server_should_reconnect(server)) {
+			cifs_dbg(VFS, "Server %s was disconnected. Reconnecting...\n",
+				 server->hostname);
+			cifs_reconnect(server);
+			wake_up(&server->response_q);
+			return -ECONNABORTED;
+		}
+
+		if (!server_should_poll_for_responses(server)) {
+			cifs_dbg(FYI, "Only invalid credential sessions\n");
+			return -ECONNABORTED;
+		}
+
 		/* reconnect if no credits and no requests in flight */
 		if (zero_credits(server)) {
 			cifs_reconnect(server);
@@ -1222,6 +1314,22 @@ smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 	}
 }
 
+static bool cifs_demultiplex_thread_should_block(struct TCP_Server_Info *server)
+{
+	if (server->tcpStatus == CifsExiting) {
+		return false;
+	}
+
+	if (server_should_reconnect(server)) {
+		return false;
+	}
+
+	if (server_should_poll_for_responses(server)) {
+		return false;
+	}
+
+	return true;
+}
 
 static int
 cifs_demultiplex_thread(void *p)
@@ -1248,6 +1356,11 @@ cifs_demultiplex_thread(void *p)
 		if (try_to_freeze())
 			continue;
 
+		wait_event_freezable(server->demultiplex_q,
+				!cifs_demultiplex_thread_should_block(server));
+		if (server->tcpStatus == CifsExiting)
+			break;
+
 		if (!allocate_buffers(server))
 			continue;
 
@@ -2880,6 +2993,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->credits = 1;
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
+	init_waitqueue_head(&tcp_ses->demultiplex_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
 	mutex_init(&tcp_ses->srv_mutex);
 	memcpy(tcp_ses->workstation_RFC1001_name,
@@ -2967,6 +3081,13 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	cifs_fscache_get_client_cookie(tcp_ses);
 
+	/* unfreeze the demultiplex thread */
+	wake_up_all(&tcp_ses->demultiplex_q);
+	/*
+	 * we let the caller use cifs_connect_session_locked()
+	 * (directly or via cifs_get_smb_ses() and don't
+	 * schedule the reconnect timer.
+	 */
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
@@ -5454,6 +5575,10 @@ cifs_connect_session_locked(const unsigned int xid,
 {
 	int rc;
 
+	if (ses->status == CifsInvalidCredentials) {
+		return -EKEYREVOKED;
+	}
+
 	if (ses->server->tcpStatus == CifsNeedReconnect) {
 		return -EHOSTDOWN;
 	}
@@ -5463,7 +5588,12 @@ cifs_connect_session_locked(const unsigned int xid,
 		cifs_dbg(FYI, "Session needs reconnect\n");
 		rc = cifs_setup_session(xid, ses, nls_info);
 		if ((rc == -EACCES) && !retry) {
-			return -EHOSTDOWN;
+			cifs_dbg(VFS,
+				 "SessionSetup to Server %s failed, "
+				 "marking as CifsInvalidCredentials/EKEYREVOKED\n",
+				 ses->server->hostname);
+			ses->status = CifsInvalidCredentials;
+			return -EKEYREVOKED;
 		}
 	}
 
@@ -5505,6 +5635,10 @@ cifs_tcon_reconnect(struct cifs_tcon *tcon,
 
 	retries = server->nr_targets;
 
+	if (ses->status == CifsInvalidCredentials) {
+		return -EKEYREVOKED;
+	}
+
 	/*
 	 * Give demultiplex thread up to 10 seconds to each target available for
 	 * reconnect -- should be greater than cifs socket timeout which is 7
@@ -5515,6 +5649,7 @@ cifs_tcon_reconnect(struct cifs_tcon *tcon,
 			return -EAGAIN;
 		}
 
+		wake_up_all(&server->demultiplex_q);
 		rc = wait_event_interruptible_timeout(server->response_q,
 						      (server->tcpStatus != CifsNeedReconnect),
 						      10 * HZ);
@@ -5543,6 +5678,10 @@ cifs_tcon_reconnect(struct cifs_tcon *tcon,
 		retries = server->nr_targets;
 	}
 
+	if (ses->status == CifsInvalidCredentials) {
+		return -EKEYREVOKED;
+	}
+
 	if (!ses->need_reconnect && !tcon->need_reconnect)
 		return 0;
 
-- 
2.17.1

