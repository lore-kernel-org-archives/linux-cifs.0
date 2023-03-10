Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7616EC6FA99
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbjCJPpI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjCJPou (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:50 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CC612F0F
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:07 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u5so5959491plq.7
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUwMxf1D4oTW/BJql9s4uQVb7EF+zHYfM1JkrTVpVS8=;
        b=Sz3h5XckA9TMYPnaCWJ6nCBs4fg6DKZLx6vpjg+4o7/wXm90EfS8mXJ2dL1E59/JVM
         XTdGLTImVp9tZ/e1kCsMdQvnjZ5vCDhDF8zLBLg9tShsI4GjeU51M0tkx4lahw6yQ+vi
         FI2tMtFsJOFJ4fz16j08hXnpsihGR/N27d3KIVTKwwEhYEFiBStlEwGrTp8hBWucFLFU
         sZH1GY8+On8a8yqO+E52LYp0nLKe1vFWsDa0ZUDW3AingiXe+DTwQ6OfEsHOBTbRmPll
         Xv9Qv9QKYVoGq40xjFFZBOOpPzVbr9hNEAnQeaSz2C+sQ/r9+MLKT7Kzia3FvWdiGAHQ
         araA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YUwMxf1D4oTW/BJql9s4uQVb7EF+zHYfM1JkrTVpVS8=;
        b=q+oXYQU0jENJxBXw1dMIv1F6kaInysBjQpb/+KfiVvgPiyR5mFDUgBG6pAOIZdSKkG
         Xc+oYbTTzR2wwcd5exB8nFjCcqxus0pQ+ld7FnKRtBr03zM5YGRLyp473e9x5+K7N9Qz
         YwDm0vK5+vI/PCQG444AdDxAkWg54oY4qBID4QrG7DNEtYDBN+e0eB2sE7mXmI84S/PK
         nSBHflcSgd8VOtCOyHX3FO5dRwcWPZS/487T1E8ZaOuhkT61QhcyCE2Sg+eTHxPvFrQq
         ivvSkqAVgCUuazKo2159xDr1GnrgwEafOX5cIHybMLRLFzJRM5oZ0mUm313p1sUdwVCC
         kzYg==
X-Gm-Message-State: AO0yUKU2GHmQmTqp4wPBd7R92Uxn7ybeAACYQRa3LQ28SmvRdLUOZGL/
        5ht1QeJdAQ1+Pxhr4dL2xpg=
X-Google-Smtp-Source: AK7set/z5eTZ8yWN5p+YzTH3UGiJxJQCU23Ew2Ror3ur2AdLE6jRTH3IscuO9tPDab5FOs1DB3dzdA==
X-Received: by 2002:a17:90b:1d8f:b0:237:161e:3329 with SMTP id pf15-20020a17090b1d8f00b00237161e3329mr25955288pjb.40.1678462386695;
        Fri, 10 Mar 2023 07:33:06 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:06 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 03/11] cifs: avoid race conditions with parallel reconnects
Date:   Fri, 10 Mar 2023 15:32:02 +0000
Message-Id: <20230310153211.10982-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When multiple processes/channels do reconnects in parallel
we used to return success immediately
negotiate/session-setup/tree-connect, causing race conditions
between processes that enter the function in parallel.
This caused several errors related to session not found to
show up during parallel reconnects.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/cifs_debug.c    |   5 ++
 fs/cifs/cifsglob.h      |  14 +++-
 fs/cifs/connect.c       | 145 ++++++++++++++++++++++++++++++++++++----
 fs/cifs/dfs.c           |  33 +++++++++
 fs/cifs/misc.c          |   2 +
 fs/cifs/sess.c          |   8 ++-
 fs/cifs/smb2pdu.c       |  35 +++++-----
 fs/cifs/smb2transport.c |  17 ++++-
 8 files changed, 225 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 1911f7016fa1..4391c7aac3cb 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -406,6 +406,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->capabilities, ses->ses_status);
 			}
 
+			if (ses->chan_count > 1)
+				seq_printf(m, "\n\tChannel reconnect bitmaps: 0x%lx 0x%lx",
+					   ses->chans_need_reconnect,
+					   ses->chans_in_reconnect);
+
 			seq_printf(m, "\n\tSecurity type: %s ",
 				get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8a37b1553dc6..81ff13e41f97 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -624,6 +624,7 @@ struct TCP_Server_Info {
 #ifdef CONFIG_NET_NS
 	struct net *net;
 #endif
+	wait_queue_head_t reconnect_q;	/* for handling parallel reconnects */
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 	spinlock_t mid_lock;  /* protect mid queue and it's entries */
@@ -1002,7 +1003,6 @@ iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
 }
 
 struct cifs_chan {
-	unsigned int in_reconnect : 1; /* if session setup in progress for this channel */
 	struct TCP_Server_Info *server;
 	struct cifs_server_iface *iface; /* interface in use */
 	__u8 signkey[SMB3_SIGN_KEY_SIZE];
@@ -1017,6 +1017,7 @@ struct cifs_ses {
 	struct list_head tcon_list;
 	struct cifs_tcon *tcon_ipc;
 	spinlock_t ses_lock;  /* protect anything here that is not protected */
+	wait_queue_head_t reconnect_q;	/* for handling parallel reconnects */
 	struct mutex session_mutex;
 	struct TCP_Server_Info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
@@ -1076,7 +1077,9 @@ struct cifs_ses {
 #define CIFS_CHAN_NEEDS_RECONNECT(ses, index)	\
 	test_bit((index), &(ses)->chans_need_reconnect)
 #define CIFS_CHAN_IN_RECONNECT(ses, index)	\
-	((ses)->chans[(index)].in_reconnect)
+	test_bit((index), &(ses)->chans_in_reconnect)
+#define CIFS_ALL_CHANS_IN_RECONNECT(ses)	\
+	((ses)->chans_in_reconnect == CIFS_ALL_CHANNELS_SET(ses))
 
 	struct cifs_chan chans[CIFS_MAX_CHANNELS];
 	size_t chan_count;
@@ -1092,8 +1095,14 @@ struct cifs_ses {
 	 * channels are marked for needing reconnection. This will
 	 * enable the sessions on top to continue to live till any
 	 * of the channels below are active.
+	 *
+	 * chans_in_reconnect is a bitmap indicating which channels
+	 * are in the process of reconnecting. This is needed
+	 * to avoid race conditions between processes which
+	 * do channel binding in parallel.
 	 */
 	unsigned long chans_need_reconnect;
+	unsigned long chans_in_reconnect;
 	/* ========= end: protected by chan_lock ======== */
 	struct cifs_ses *dfs_root_ses;
 };
@@ -1145,6 +1154,7 @@ struct cifs_tcon {
 	int tc_count;
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
+	wait_queue_head_t reconnect_q;	/* for handling parallel reconnects */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
 	atomic_t num_remote_opens; /* num of all network opens on server */
 	struct list_head openFileList;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3d07729c91a1..7b103f69432e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -212,8 +212,10 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			cifs_chan_update_iface(ses, server);
 
 		spin_lock(&ses->chan_lock);
-		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server))
-			goto next_session;
+		if (!mark_smb_session && cifs_chan_needs_reconnect(ses, server)) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
 
 		if (mark_smb_session)
 			CIFS_SET_ALL_CHANS_NEED_RECONNECT(ses);
@@ -221,22 +223,28 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			cifs_chan_set_need_reconnect(ses, server);
 
 		/* If all channels need reconnect, then tcon needs reconnect */
-		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses))
-			goto next_session;
+		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
+			spin_unlock(&ses->chan_lock);
+			continue;
+		}
+		spin_unlock(&ses->chan_lock);
 
+		spin_lock(&ses->ses_lock);
 		ses->ses_status = SES_NEED_RECON;
+		spin_unlock(&ses->ses_lock);
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
+			spin_lock(&tcon->tc_lock);
 			tcon->status = TID_NEED_RECON;
+			spin_unlock(&tcon->tc_lock);
 		}
 		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
+			spin_lock(&ses->tcon_ipc->tc_lock);
 			ses->tcon_ipc->status = TID_NEED_RECON;
+			spin_unlock(&ses->tcon_ipc->tc_lock);
 		}
-
-next_session:
-		spin_unlock(&ses->chan_lock);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 }
@@ -1596,6 +1604,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	}
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
+	init_waitqueue_head(&tcp_ses->reconnect_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
 	mutex_init(&tcp_ses->_srv_mutex);
 	memcpy(tcp_ses->workstation_RFC1001_name,
@@ -3648,17 +3657,55 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 			struct TCP_Server_Info *server)
 {
 	int rc = 0;
+	int retries = server->nr_targets;
 
 	if (!server->ops->need_neg || !server->ops->negotiate)
 		return -ENOSYS;
 
+check_again:
 	/* only send once per connect */
 	spin_lock(&server->srv_lock);
-	if (!server->ops->need_neg(server) ||
+	if (server->tcpStatus != CifsGood &&
+	    server->tcpStatus != CifsNew &&
 	    server->tcpStatus != CifsNeedNegotiate) {
+		spin_unlock(&server->srv_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (!server->ops->need_neg(server) &&
+	    server->tcpStatus == CifsGood) {
 		spin_unlock(&server->srv_lock);
 		return 0;
 	}
+
+	/* another process is in the processs of negotiating */
+	while (server->tcpStatus == CifsInNegotiate) {
+		spin_unlock(&server->srv_lock);
+		rc = wait_event_interruptible_timeout(server->reconnect_q,
+						      (server->tcpStatus != CifsInNegotiate),
+						      HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting negotiate due to a received signal by the process\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+		spin_lock(&server->srv_lock);
+
+		/* are we still waiting for others */
+		if (server->tcpStatus != CifsInNegotiate) {
+			spin_unlock(&server->srv_lock);
+			goto check_again;
+		}
+
+		if (retries && --retries)
+			continue;
+
+		cifs_dbg(FYI, "gave up waiting on CifsInNegotiate\n");
+		spin_unlock(&server->srv_lock);
+		return -EHOSTDOWN;
+	}
+
+	/* now mark the server so that others don't reach here */
 	server->tcpStatus = CifsInNegotiate;
 	spin_unlock(&server->srv_lock);
 
@@ -3676,6 +3723,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 			server->tcpStatus = CifsNeedNegotiate;
 		spin_unlock(&server->srv_lock);
 	}
+	wake_up(&server->reconnect_q);
 
 	return rc;
 }
@@ -3690,25 +3738,63 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
 	bool is_binding = false;
+	int retries;
+
+check_again:
+	retries = 5;
 
 	spin_lock(&ses->ses_lock);
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
 		spin_unlock(&ses->ses_lock);
-		return 0;
+		return -EHOSTDOWN;
 	}
 
 	/* only send once per connect */
 	spin_lock(&ses->chan_lock);
-	if (CIFS_ALL_CHANS_GOOD(ses) ||
-	    cifs_chan_in_reconnect(ses, server)) {
+	if (CIFS_ALL_CHANS_GOOD(ses)) {
+		if (ses->ses_status == SES_NEED_RECON)
+			ses->ses_status = SES_GOOD;
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 		return 0;
 	}
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
+
+	/* another process is in the processs of sess setup */
+	while (cifs_chan_in_reconnect(ses, server)) {
+		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
+		rc = wait_event_interruptible_timeout(ses->reconnect_q,
+						      (!cifs_chan_in_reconnect(ses, server)),
+						      HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting sess setup due to a received signal by the process\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+		spin_lock(&ses->ses_lock);
+		spin_lock(&ses->chan_lock);
+
+		/* are we still trying to reconnect? */
+		if (!cifs_chan_in_reconnect(ses, server)) {
+			spin_unlock(&ses->chan_lock);
+			spin_unlock(&ses->ses_lock);
+			goto check_again;
+		}
+
+		if (retries && --retries)
+			continue;
+
+		cifs_dbg(FYI, "gave up waiting on cifs_chan_in_reconnect\n");
+		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
+		return -EHOSTDOWN;
+	}
+
+	/* now mark the session so that others don't reach here */
 	cifs_chan_set_in_reconnect(ses, server);
+	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
 	spin_unlock(&ses->chan_lock);
 
 	if (!is_binding)
@@ -3762,6 +3848,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 	}
+	wake_up(&ses->reconnect_q);
 
 	return rc;
 }
@@ -4035,6 +4122,10 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 {
 	int rc;
 	const struct smb_version_operations *ops = tcon->ses->server->ops;
+	int retries;
+
+check_again:
+	retries = 5;
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
@@ -4050,6 +4141,35 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
+
+	/* another process is in the processs of negotiating */
+	while (tcon->status == TID_IN_TCON) {
+		spin_unlock(&tcon->tc_lock);
+		rc = wait_event_interruptible_timeout(tcon->reconnect_q,
+						      (tcon->status != TID_IN_TCON),
+						      HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting tree connect due to a received signal by the process\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+		spin_lock(&tcon->tc_lock);
+
+		/* are we still trying to reconnect? */
+		if (tcon->status != TID_IN_TCON) {
+			spin_unlock(&tcon->tc_lock);
+			goto check_again;
+		}
+
+		if (retries && --retries)
+			continue;
+
+		cifs_dbg(FYI, "gave up waiting on TID_IN_TCON\n");
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	/* now mark the tcon so that others don't reach here */
 	tcon->status = TID_IN_TCON;
 	spin_unlock(&tcon->tc_lock);
 
@@ -4066,6 +4186,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		tcon->need_reconnect = false;
 		spin_unlock(&tcon->tc_lock);
 	}
+	wake_up(&tcon->reconnect_q);
 
 	return rc;
 }
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index d37af02902c5..013a399088c3 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -476,6 +476,10 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
 	char *tree;
 	struct dfs_info3_param ref = {0};
+	int retries;
+
+check_again:
+	retries = 5;
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
@@ -491,6 +495,35 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
+
+	/* another process is in the processs of negotiating */
+	while (tcon->status == TID_IN_TCON) {
+		spin_unlock(&tcon->tc_lock);
+		rc = wait_event_interruptible_timeout(tcon->reconnect_q,
+						      (tcon->status != TID_IN_TCON),
+						      HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting tree connect due to a received signal by the process\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+		spin_lock(&tcon->tc_lock);
+
+		/* are we still trying to reconnect? */
+		if (tcon->status != TID_IN_TCON) {
+			spin_unlock(&tcon->tc_lock);
+			goto check_again;
+		}
+
+		if (retries && --retries)
+			continue;
+
+		cifs_dbg(FYI, "gave up waiting on TID_IN_TCON\n");
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	/* now mark the tcon so that others don't reach here */
 	tcon->status = TID_IN_TCON;
 	spin_unlock(&tcon->tc_lock);
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a0d286ee723d..5a974689fde9 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -80,6 +80,7 @@ sesInfoAlloc(void)
 		spin_lock_init(&ret_buf->iface_lock);
 		INIT_LIST_HEAD(&ret_buf->iface_list);
 		spin_lock_init(&ret_buf->chan_lock);
+		init_waitqueue_head(&ret_buf->reconnect_q);
 	}
 	return ret_buf;
 }
@@ -134,6 +135,7 @@ tconInfoAlloc(void)
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
+	init_waitqueue_head(&ret_buf->reconnect_q);
 
 	return ret_buf;
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d2cbae4b5d21..b8bfebe4498e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -94,7 +94,9 @@ cifs_chan_set_in_reconnect(struct cifs_ses *ses,
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
 
-	ses->chans[chan_index].in_reconnect = true;
+	set_bit(chan_index, &ses->chans_in_reconnect);
+	cifs_dbg(FYI, "Set in-reconnect bitmask for chan %u; now 0x%lx\n",
+		 chan_index, ses->chans_in_reconnect);
 }
 
 void
@@ -103,7 +105,9 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
 
-	ses->chans[chan_index].in_reconnect = false;
+	clear_bit(chan_index, &ses->chans_in_reconnect);
+	cifs_dbg(FYI, "Cleared in-reconnect bitmask for chan %u; now 0x%lx\n",
+		 chan_index, ses->chans_in_reconnect);
 }
 
 bool
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0e53265e1462..52318a79c848 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -215,8 +215,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		return 0;
 	}
 	spin_unlock(&ses->chan_lock);
-	cifs_dbg(FYI, "sess reconnect mask: 0x%lx, tcon reconnect: %d",
+	cifs_dbg(FYI, "sess reconnect masks: 0x%lx 0x%lx, tcon reconnect: %d",
 		 tcon->ses->chans_need_reconnect,
+		 tcon->ses->chans_in_reconnect,
 		 tcon->need_reconnect);
 
 	nls_codepage = load_nls_default();
@@ -238,9 +239,12 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * need to prevent multiple threads trying to simultaneously
 	 * reconnect the same SMB session
 	 */
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	if (!cifs_chan_needs_reconnect(ses, server)) {
+	if (!cifs_chan_needs_reconnect(ses, server) &&
+	    ses->ses_status == SES_GOOD) {
 		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
 
 		/* this means that we only need to tree connect */
 		if (tcon->need_reconnect)
@@ -249,6 +253,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		goto out;
 	}
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(0, ses, server);
@@ -284,7 +289,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc) {
 		/* If sess reconnected but tcon didn't, something strange ... */
-		pr_warn_once("reconnect tcon failed rc = %d\n", rc);
+		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
 		goto out;
 	}
 
@@ -1256,9 +1261,9 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	if (rc)
 		return rc;
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	if (is_binding) {
 		req->hdr.SessionId = cpu_to_le64(ses->Suid);
@@ -1416,9 +1421,9 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep session key if binding */
 	if (!is_binding) {
@@ -1542,9 +1547,9 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep existing ses id and flags if binding */
 	if (!is_binding) {
@@ -1610,9 +1615,9 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 
-	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
-	spin_unlock(&ses->chan_lock);
+	spin_lock(&ses->ses_lock);
+	is_binding = (ses->ses_status == SES_GOOD);
+	spin_unlock(&ses->ses_lock);
 
 	/* keep existing ses id and flags if binding */
 	if (!is_binding) {
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index d827b7547ffa..790acf65a092 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -81,6 +81,7 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	struct cifs_ses *ses = NULL;
 	int i;
 	int rc = 0;
+	bool is_binding = false;
 
 	spin_lock(&cifs_tcp_ses_lock);
 
@@ -97,9 +98,12 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	goto out;
 
 found:
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	if (cifs_chan_needs_reconnect(ses, server) &&
-	    !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
+
+	is_binding = (cifs_chan_needs_reconnect(ses, server) &&
+		      ses->ses_status == SES_GOOD);
+	if (is_binding) {
 		/*
 		 * If we are in the process of binding a new channel
 		 * to an existing session, use the master connection
@@ -107,6 +111,7 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 		 */
 		memcpy(key, ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
 		goto out;
 	}
 
@@ -119,10 +124,12 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 		if (chan->server == server) {
 			memcpy(key, chan->signkey, SMB3_SIGN_KEY_SIZE);
 			spin_unlock(&ses->chan_lock);
+			spin_unlock(&ses->ses_lock);
 			goto out;
 		}
 	}
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
 	cifs_dbg(VFS,
 		 "%s: Could not find channel signing key for session 0x%llx\n",
@@ -392,11 +399,15 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	bool is_binding = false;
 	int chan_index = 0;
 
+	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
-	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
+	is_binding = (cifs_chan_needs_reconnect(ses, server) &&
+		      ses->ses_status == SES_GOOD);
+
 	chan_index = cifs_ses_get_chan_index(ses, server);
 	/* TODO: introduce ref counting for channels when the can be freed */
 	spin_unlock(&ses->chan_lock);
+	spin_unlock(&ses->ses_lock);
 
 	/*
 	 * All channels use the same encryption/decryption keys but
-- 
2.34.1

