Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C248FC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjJ3LAr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjJ3LAp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:45 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857CB3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:42 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c9b7c234a7so38052545ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663642; x=1699268442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juopXulIPRUS5UvLW/eHiGvTVVvlKCYB2NS5V7NQG3A=;
        b=cL7936BXBjAXpcpMQJMXzIK/vGtq/Uod8vLKVUDgfQRzIniyfqbNc9XoHMImyIyb35
         gzn4J0owcXLfWaOiGsV2rJbsc9a8ydIbPHHu8VU3cZTYj5ATesfoxTWRpSmT3YOa8ti7
         M03sIoon0mo89mVwf8LjQH7oSxfAkNjc1AEeKsc84Id3CZB1J5N/ik1PZAn3DX7KhEoz
         wvwhoTIGMpP6io3BeMrFG2VxxLmyV/sYgFnHHL6oVHr7n310bSAmCt3fPYK2aVv4FhDE
         pNsElQxI/o3TFgVsaVd8Nuie+3+GL9WMEEQVmRU4rHMaTDnnWmW594l94PIfXIv/dm90
         QIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663642; x=1699268442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juopXulIPRUS5UvLW/eHiGvTVVvlKCYB2NS5V7NQG3A=;
        b=rGPgpHZZUByRpJXCjOHL8dK0cZ0NfGCcCSaOZv7icxzvDnNotfsp4zprKjl1EBnorR
         fOvAXSqNgVAOyDIiXv/UV74zIj+feDhgPWzp9f7Oeo0mkZzO+Jjsd2aLcGgtBtNXpSlG
         JN6QJNo6IZ9tj0Kdzmczk2jhE3wQYot2mzXY/xAom2GiaUoofK0dfbyP4GzSKjaTt4iK
         wwMquC7rFkEDJxYsrLFgh+FzBgm0LLOK+TfoRFhYQnGp/vKzLZEw9zSodwpm5X5Y2ZwX
         jK/JswW4xFJP8sK2tQoVTVWhEX4Fwnt3II+/xeFVQccl4h9LrkagINBNZ/7OvFr70X5k
         Ll2g==
X-Gm-Message-State: AOJu0YyBeYjXxla9Q0uRCgemAY9vdIS7+lkNY4cVc/INPd4AAQIPoy4d
        AybgDhF1Pw1MwWZwpSorfG0=
X-Google-Smtp-Source: AGHT+IEE3e/BD5Wzi/VcE8wg5uSoN16kO/2+cGTsD1JLxEfCW1FUqwb9DoHEYYxDfHNcbYkealG42g==
X-Received: by 2002:a17:902:d2d2:b0:1cc:558a:6b02 with SMTP id n18-20020a170902d2d200b001cc558a6b02mr1037443plc.64.1698663641821;
        Mon, 30 Oct 2023 04:00:41 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:41 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 06/14] cifs: handle cases where a channel is closed
Date:   Mon, 30 Oct 2023 11:00:12 +0000
Message-Id: <20231030110020.45627-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

So far, SMB multichannel could only scale up, but not
scale down the number of channels. In this series of
patch, we now allow the client to deal with the case
of multichannel disabled on the server when the share
is mounted. With that change, we now need the ability
to scale down the channels.

This change allows the client to deal with cases of
missing channels more gracefully.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c    |  5 +++++
 fs/smb/client/cifsglob.h      |  1 +
 fs/smb/client/cifsproto.h     |  2 +-
 fs/smb/client/connect.c       | 10 ++++++++--
 fs/smb/client/sess.c          | 25 +++++++++++++++++++++----
 fs/smb/client/smb2transport.c |  8 +++++++-
 6 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index a9dfecc397a8..9fca09539728 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -136,6 +136,11 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 {
 	struct TCP_Server_Info *server = chan->server;
 
+	if (!server) {
+		seq_printf(m, "\n\n\t\tChannel: %d DISABLED", i+1);
+		return;
+	}
+
 	seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
 		   "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
 		   "\n\t\tTCP status: %d Instance: %d"
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 02082621d8e0..552ed441281a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1050,6 +1050,7 @@ struct cifs_ses {
 	spinlock_t chan_lock;
 	/* ========= begin: protected by chan_lock ======== */
 #define CIFS_MAX_CHANNELS 16
+#define CIFS_INVAL_CHAN_INDEX (-1)
 #define CIFS_ALL_CHANNELS_SET(ses)	\
 	((1UL << (ses)->chan_count) - 1)
 #define CIFS_ALL_CHANS_GOOD(ses)		\
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 0c37eefa18a5..65c84b3d1a65 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -616,7 +616,7 @@ bool is_server_using_iface(struct TCP_Server_Info *server,
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
-unsigned int
+int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
 			struct TCP_Server_Info *server);
 void
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 97c9a32cff36..8393977e21ee 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -173,8 +173,12 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
+			if (!ses->chans[i].server)
+				continue;
+
 			spin_lock(&ses->chans[i].server->srv_lock);
-			ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+			if (ses->chans[i].server->tcpStatus != CifsExiting)
+				ses->chans[i].server->tcpStatus = CifsNeedReconnect;
 			spin_unlock(&ses->chans[i].server->srv_lock);
 		}
 		spin_unlock(&ses->chan_lock);
@@ -2033,7 +2037,9 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 				kref_put(&ses->chans[i].iface->refcount, release_iface);
 				ses->chans[i].iface = NULL;
 			}
-			cifs_put_tcp_session(ses->chans[i].server, 0);
+
+			if (ses->chans[i].server)
+				cifs_put_tcp_session(ses->chans[i].server, 0);
 			ses->chans[i].server = NULL;
 		}
 	}
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index c899b05c92f7..9d2228c2d7e5 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -69,7 +69,7 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
 
 /* channel helper functions. assumed that chan_lock is held by caller. */
 
-unsigned int
+int
 cifs_ses_get_chan_index(struct cifs_ses *ses,
 			struct TCP_Server_Info *server)
 {
@@ -85,14 +85,16 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
 		cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
 			 server->conn_id);
 	WARN_ON(1);
-	return 0;
+	return CIFS_INVAL_CHAN_INDEX;
 }
 
 void
 cifs_chan_set_in_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
-	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	ses->chans[chan_index].in_reconnect = true;
 }
@@ -102,6 +104,8 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	ses->chans[chan_index].in_reconnect = false;
 }
@@ -111,6 +115,8 @@ cifs_chan_in_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
 }
@@ -120,6 +126,8 @@ cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	set_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
@@ -131,6 +139,8 @@ cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return;
 
 	clear_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Cleared reconnect bitmask for chan %u; now 0x%lx\n",
@@ -142,6 +152,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return CIFS_CHAN_NEEDS_RECONNECT(ses, chan_index);
 }
@@ -151,6 +163,8 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server)
 {
 	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return true;	/* err on the safer side */
 
 	return ses->chans[chan_index].iface &&
 		ses->chans[chan_index].iface->is_active;
@@ -269,7 +283,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
-	if (!chan_index) {
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
 		spin_unlock(&ses->chan_lock);
 		return 0;
 	}
@@ -319,6 +333,9 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	spin_lock(&ses->chan_lock);
 	chan_index = cifs_ses_get_chan_index(ses, server);
+	if (chan_index == CIFS_INVAL_CHAN_INDEX)
+		return 0;
+
 	ses->chans[chan_index].iface = iface;
 
 	/* No iface is found. if secondary chan, drop connection */
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 23c50ed7d4b5..84ea67301303 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -413,7 +413,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
 		      ses->ses_status == SES_GOOD);
 
 	chan_index = cifs_ses_get_chan_index(ses, server);
-	/* TODO: introduce ref counting for channels when the can be freed */
+	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+		spin_unlock(&ses->chan_lock);
+		spin_unlock(&ses->ses_lock);
+
+		return -EINVAL;
+	}
+
 	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 
-- 
2.34.1

