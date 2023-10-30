Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FBBC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjJ3LBD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjJ3LBC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:01:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717A9B3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:58 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6b89ab5ddb7so4336876b3a.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663658; x=1699268458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zq0easth6d3aqIW4iTipq/gwSsWnm9owuLJTgsRttFo=;
        b=G25W4hNDmN4t5Q/GprlNgdj24BkJ+fU1NZr5kCTQf3cjNAPGf6VQiN6BXJr9KtA74x
         YY1DbMzY0+5KzvcxafGe7XHom3O/Ti3R+EI/kgZOxVAbXWYpjCRD2RTRk9m9iXGHrHPQ
         Fi7xx6lTlBRlyzrna2meGY/2HBkzxH2sznq9hFz+hAZgTtQ11dY6RydNFnwKBpCio6vk
         Ppse2bhFX63sKczPg4GGJ6CG3IGcbSTYjb+GaBBZXI7t9JrBZN/dF+5vbHcnz+FuyXQ6
         xf8sKmwXrorjtma1O0p/QPMhQ84qA/1abzAaTEUCnU9D9lwwIWaCIIqAwdYVF4o6zfAs
         KrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663658; x=1699268458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zq0easth6d3aqIW4iTipq/gwSsWnm9owuLJTgsRttFo=;
        b=HRgs8cIKAOG5tNVbWR0QBWxI+XCc5VJ1xc63ZS1bfVgZy54BUV8VkzCM/HMruaUA/u
         k8IvxVE3GqYbw+qorBLDV0HgOYAy0XP2w71YY3iLJFRcunEj+BrJyTnzD9utfjgfp5tj
         x/Q2BlIWa0JMGR3yj75/ysGPJdepglxwVGNLUptN0S+aZaexv4VsRus2PilBpiw4lWjK
         VjPTwfjez3d4ZJYeWOm42YhJoY1wyhwj4yoP5dWmAHZkrXPH6YXRumPvSr+1miJszFlo
         fEwMrKuFqmR7JOImpOX7bb05Y6qPC9iEEM2LkDX1D0yu6kXDCZbeYJPJWDkWNiO4rlLj
         s2+w==
X-Gm-Message-State: AOJu0Ywp/cmj8mefErdcTC1SL7AuvuXLI42gLWGOP8VHnMIKZJ/2CZcA
        HF3Y9iFu89YKvGWbgHLQjr4=
X-Google-Smtp-Source: AGHT+IEzHaheRjDSK4lU9H8srFUxWqKjt5wtmL/Kn2wuvU1ouEIfvSzKP3vgMTe1vf0YYhNhRNY0ig==
X-Received: by 2002:a05:6a20:7f93:b0:161:2cf2:75ec with SMTP id d19-20020a056a207f9300b001612cf275ecmr14205307pzj.49.1698663657755;
        Mon, 30 Oct 2023 04:00:57 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:57 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 12/14] cifs: handle when server stops supporting multichannel
Date:   Mon, 30 Oct 2023 11:00:18 +0000
Message-Id: <20231030110020.45627-12-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

When a server stops supporting multichannel, we will
keep attempting reconnects to the secondary channels today.
Avoid this by freeing extra channels when negotiate
returns no multichannel support.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/connect.c   | 10 ++++++
 fs/smb/client/sess.c      | 64 ++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   | 70 ++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/transport.c |  2 +-
 6 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cdbc2cd207dc..1e1a5f3ab600 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -650,6 +650,7 @@ struct TCP_Server_Info {
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool nosharesock;
 	bool tcp_nodelay;
+	bool terminate;
 	unsigned int credits;  /* send no more requests at once */
 	unsigned int max_credits; /* can override large 32000 default at mnt */
 	unsigned int in_flight;  /* number of requests on the wire to server */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 5a4c1f1e0d91..828c3916cb88 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -644,6 +644,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
 bool
 cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
+void
+cifs_disable_secondary_channels(struct cifs_ses *ses);
 int
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 149cde77500e..6fe80d5d7c23 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -220,6 +220,14 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
+		/*
+		 * if channel has been marked for termination, nothing to do
+		 * for the channel. in fact, we cannot find the channel for the
+		 * server. So safe to exit here
+		 */
+		if (server->terminate)
+			break;
+
 		/* check if iface is still active */
 		if (!cifs_chan_is_iface_active(ses, server))
 			cifs_chan_update_iface(ses, server);
@@ -254,6 +262,8 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			spin_lock(&tcon->tc_lock);
 			tcon->status = TID_NEED_RECON;
 			spin_unlock(&tcon->tc_lock);
+
+			cancel_delayed_work_sync(&tcon->query_interfaces);
 		}
 		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 6843deed6119..51bcd78fc5bf 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -288,6 +288,60 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	return new_chan_count - old_chan_count;
 }
 
+/*
+ * called when multichannel is disabled by the server.
+ * this always gets called from smb2_reconnect
+ * and cannot get called in parallel threads.
+ */
+void
+cifs_disable_secondary_channels(struct cifs_ses *ses)
+{
+	int i, chan_count;
+	struct TCP_Server_Info *server;
+	struct cifs_server_iface *iface;
+
+	spin_lock(&ses->chan_lock);
+	chan_count = ses->chan_count;
+	if (chan_count == 1)
+		goto done;
+
+	ses->chan_count = 1;
+
+	/* for all secondary channels reset the need reconnect bit */
+	ses->chans_need_reconnect &= 1;
+
+	for (i = 1; i < chan_count; i++) {
+		iface = ses->chans[i].iface;
+		server = ses->chans[i].server;
+
+		if (iface) {
+			spin_lock(&ses->iface_lock);
+			kref_put(&iface->refcount, release_iface);
+			ses->chans[i].iface = NULL;
+			iface->num_channels--;
+			if (iface->weight_fulfilled)
+				iface->weight_fulfilled--;
+			spin_unlock(&ses->iface_lock);
+		}
+
+		spin_unlock(&ses->chan_lock);
+		if (server && !server->terminate) {
+			server->terminate = true;
+			cifs_signal_cifsd_for_reconnect(server, false);
+		}
+		spin_lock(&ses->chan_lock);
+
+		if (server) {
+			ses->chans[i].server = NULL;
+			cifs_put_tcp_session(server, false);
+		}
+
+	}
+
+done:
+	spin_unlock(&ses->chan_lock);
+}
+
 /*
  * update the iface for the channel if necessary.
  * will return 0 when iface is updated, 1 if removed, 2 otherwise
@@ -580,14 +634,10 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 
 out:
 	if (rc && chan->server) {
-		/*
-		 * we should avoid race with these delayed works before we
-		 * remove this channel
-		 */
-		cancel_delayed_work_sync(&chan->server->echo);
-		cancel_delayed_work_sync(&chan->server->reconnect);
+		cifs_put_tcp_session(chan->server, 0);
 
 		spin_lock(&ses->chan_lock);
+
 		/* we rely on all bits beyond chan_count to be clear */
 		cifs_chan_clear_need_reconnect(ses, chan->server);
 		ses->chan_count--;
@@ -597,8 +647,6 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
-
-		cifs_put_tcp_session(chan->server, 0);
 	}
 
 	kfree(ctx->UNC);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2617437a4627..d1d4d9100870 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -164,6 +164,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	struct nls_table *nls_codepage = NULL;
 	struct cifs_ses *ses;
 	int xid;
+	struct TCP_Server_Info *pserver;
+	unsigned int chan_index;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -224,6 +226,12 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			return -EAGAIN;
 		}
 	}
+
+	/* if server is marked for termination, cifsd will cleanup */
+	if (server->terminate) {
+		spin_unlock(&server->srv_lock);
+		return -EHOSTDOWN;
+	}
 	spin_unlock(&server->srv_lock);
 
 again:
@@ -242,12 +250,24 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		 tcon->need_reconnect);
 
 	mutex_lock(&ses->session_mutex);
+	/*
+	 * if this is called by delayed work, and the channel has been disabled
+	 * in parallel, the delayed work can continue to execute in parallel
+	 * there's a chance that this channel may not exist anymore
+	 */
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsExiting) {
+		spin_unlock(&server->srv_lock);
+		mutex_unlock(&ses->session_mutex);
+		rc = -EHOSTDOWN;
+		goto out;
+	}
+
 	/*
 	 * Recheck after acquire mutex. If another thread is negotiating
 	 * and the server never sends an answer the socket will be closed
 	 * and tcpStatus set to reconnect.
 	 */
-	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
@@ -284,6 +304,47 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (!rc) {
+		/*
+		 * if server stopped supporting multichannel
+		 * and the first channel reconnected, disable all the others.
+		 */
+		if (ses->chan_count > 1 &&
+		    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+			if (SERVER_IS_CHAN(server)) {
+				cifs_dbg(VFS, "server %s does not support " \
+					 "multichannel anymore. skipping secondary channel\n",
+					 ses->server->hostname);
+
+				spin_lock(&ses->chan_lock);
+				chan_index = cifs_ses_get_chan_index(ses, server);
+				if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+					spin_unlock(&ses->chan_lock);
+					goto skip_terminate;
+				}
+
+				ses->chans[chan_index].server = NULL;
+				cifs_put_tcp_session(server, 1);
+				spin_unlock(&ses->chan_lock);
+
+				server->terminate = true;
+				cifs_signal_cifsd_for_reconnect(server, false);
+
+				/* mark primary server as needing reconnect */
+				pserver = server->primary_server;
+				cifs_signal_cifsd_for_reconnect(pserver, false);
+
+skip_terminate:
+				mutex_unlock(&ses->session_mutex);
+				rc = -EHOSTDOWN;
+				goto out;
+			} else {
+				cifs_dbg(VFS, "server %s does not support " \
+					 "multichannel anymore. disabling all other channels\n",
+					 ses->server->hostname);
+				cifs_disable_secondary_channels(ses);
+			}
+		}
+
 		rc = cifs_setup_session(0, ses, server, nls_codepage);
 		if ((rc == -EACCES) && !tcon->retry) {
 			mutex_unlock(&ses->session_mutex);
@@ -3833,6 +3894,13 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* Prevent simultaneous reconnects that can corrupt tcon->rlist list */
 	mutex_lock(&pserver->reconnect_mutex);
 
+	/* if the server is marked for termination, drop the ref count here */
+	if (server->terminate) {
+		cifs_put_tcp_session(server, true);
+		mutex_unlock(&pserver->reconnect_mutex);
+		return;
+	}
+
 	INIT_LIST_HEAD(&tmp_list);
 	INIT_LIST_HEAD(&tmp_ses_list);
 	cifs_dbg(FYI, "Reconnecting tcons and channels\n");
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 14710afdc2a3..c60c65926933 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1032,7 +1032,7 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 	spin_lock(&ses->chan_lock);
 	for (i = 0; i < ses->chan_count; i++) {
 		server = ses->chans[i].server;
-		if (!server)
+		if (!server || server->terminate)
 			continue;
 
 		/*
-- 
2.34.1

