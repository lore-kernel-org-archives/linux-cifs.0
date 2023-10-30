Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C66C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjJ3LAu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjJ3LAs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A980A2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1cc5b705769so1669295ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663644; x=1699268444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbxzwsYML2TG9HjAaC8hFOUftGKDbbj8oRkfNsQrJGA=;
        b=YpN5s6DJgceXik7lBazXetZrphV3vAtQuDDMxr3Zgg3AFdCfF2OBhwPMDgTJEyEd1w
         dW0LxJQtJS2iozgeiow6U5uu/+t1yUI1fwf8fmRLJkc4w/2dXHSnrSH8EREj0FJjjtmn
         sC8gA26PdgFJ0UbTcVtSVky7/ijid08Iq3NwuTxdjVBHzQpUDB3ij7BoNKB8Nzx9kPn5
         jHiVPYUsY4TZng7lEyBcTn6tsz+82HTPGpToeeFeutC1sZeut9iFPk5HO0YhvM1Jdnh4
         KD8/JWdkAD5xzIM8rP49TwOq2i32qzdsFqhiDS8JzzjwKiEBl8BiM9abwqZbshm1iHNw
         NeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663644; x=1699268444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbxzwsYML2TG9HjAaC8hFOUftGKDbbj8oRkfNsQrJGA=;
        b=a0lVHb2vuu5jR9QYIDhKgbOKaaaFbervEjqI90cz8XwoXFL/I3yq5WHeDUjm5fYDgl
         nm8bOtWwdjIEq0j6+n6qT0kQQx3BP41r8PrkPC4GrUu8aZU4SQG4Z6zzG0BLVFXR3xKg
         PQTjo7a8Kfyc9uPrftF6XpqWkmAPPCpKu69PTYyt1lKEjP8UFKujX6RcmMyE5l4chIQG
         D0CLPF4VaZ0m4FTRxNwJ9LXdz39n2Eo/ZIdHwnB6noFo/d3xYq/L++RjpSuNa7VAN3HD
         M+qcj//0ATvF03Xf9kOxS1rfilbaePkqZMZllHUeOf1Gee+DTu5JkC3iBtidNLCsLVSb
         vf1w==
X-Gm-Message-State: AOJu0YzvdZnNuncuFjncfkiY4eMXHv/2um6VK959N8E1j8ZLW6wZ3j7V
        2iXpmDWdu+E+af0VaKA9QGrq1mTPmlyRZw==
X-Google-Smtp-Source: AGHT+IFb7mvdmTS/GRL/xLdFpjH5ZZfqX7Tgi6Pn3Rh//f9BI2TraqH9+8jtpHM2tovHy/jYcj/jvA==
X-Received: by 2002:a17:902:c1cb:b0:1cc:29ed:96ae with SMTP id c11-20020a170902c1cb00b001cc29ed96aemr7824865plc.41.1698663644447;
        Mon, 30 Oct 2023 04:00:44 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:44 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 07/14] cifs: distribute channels across interfaces based on speed
Date:   Mon, 30 Oct 2023 11:00:13 +0000
Message-Id: <20231030110020.45627-7-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

Today, if the server interfaces RSS capable, we simply
choose the fastest interface to setup a channel. This is not
a scalable approach, and does not make a lot of attempt to
distribute the connections.

This change does a weighted distribution of channels across
all the available server interfaces, where the weight is
a function of the advertised interface speed.

Also make sure that we don't mix rdma and non-rdma for channels.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 16 ++++++++
 fs/smb/client/cifsglob.h   |  2 +
 fs/smb/client/sess.c       | 83 +++++++++++++++++++++++++++++++-------
 3 files changed, 87 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 9fca09539728..e23fcabb78d6 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -284,6 +284,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifs_server_iface *iface;
+	size_t iface_weight = 0, iface_min_speed = 0;
+	struct cifs_server_iface *last_iface = NULL;
 	int c, i, j;
 
 	seq_puts(m,
@@ -543,11 +545,25 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					   "\tLast updated: %lu seconds ago",
 					   ses->iface_count,
 					   (jiffies - ses->iface_last_update) / HZ);
+
+			last_iface = list_last_entry(&ses->iface_list,
+						     struct cifs_server_iface,
+						     iface_head);
+			iface_min_speed = last_iface->speed;
+
 			j = 0;
 			list_for_each_entry(iface, &ses->iface_list,
 						 iface_head) {
 				seq_printf(m, "\n\t%d)", ++j);
 				cifs_dump_iface(m, iface);
+
+				iface_weight = iface->speed / iface_min_speed;
+				seq_printf(m, "\t\tWeight (cur,total): (%zu,%zu)"
+					   "\n\t\tAllocated channels: %u\n",
+					   iface->weight_fulfilled,
+					   iface_weight,
+					   iface->num_channels);
+
 				if (is_ses_using_iface(ses, iface))
 					seq_puts(m, "\t\t[CONNECTED]\n");
 			}
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 552ed441281a..81e7a45f413d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -969,6 +969,8 @@ struct cifs_server_iface {
 	struct list_head iface_head;
 	struct kref refcount;
 	size_t speed;
+	size_t weight_fulfilled;
+	unsigned int num_channels;
 	unsigned int rdma_capable : 1;
 	unsigned int rss_capable : 1;
 	unsigned int is_active : 1; /* unset if non existent */
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 9d2228c2d7e5..d009994f82cf 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -178,7 +178,9 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	int left;
 	int rc = 0;
 	int tries = 0;
+	size_t iface_weight = 0, iface_min_speed = 0;
 	struct cifs_server_iface *iface = NULL, *niface = NULL;
+	struct cifs_server_iface *last_iface = NULL;
 
 	spin_lock(&ses->chan_lock);
 
@@ -206,21 +208,11 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	}
 	spin_unlock(&ses->chan_lock);
 
-	/*
-	 * Keep connecting to same, fastest, iface for all channels as
-	 * long as its RSS. Try next fastest one if not RSS or channel
-	 * creation fails.
-	 */
-	spin_lock(&ses->iface_lock);
-	iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
-				 iface_head);
-	spin_unlock(&ses->iface_lock);
-
 	while (left > 0) {
 
 		tries++;
 		if (tries > 3*ses->chan_max) {
-			cifs_dbg(FYI, "too many channel open attempts (%d channels left to open)\n",
+			cifs_dbg(VFS, "too many channel open attempts (%d channels left to open)\n",
 				 left);
 			break;
 		}
@@ -228,17 +220,34 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		spin_lock(&ses->iface_lock);
 		if (!ses->iface_count) {
 			spin_unlock(&ses->iface_lock);
+			cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
 			break;
 		}
 
+		if (!iface)
+			iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
+						 iface_head);
+		last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
+					     iface_head);
+		iface_min_speed = last_iface->speed;
+
 		list_for_each_entry_safe_from(iface, niface, &ses->iface_list,
 				    iface_head) {
+			/* do not mix rdma and non-rdma interfaces */
+			if (iface->rdma_capable != ses->server->rdma)
+				continue;
+
 			/* skip ifaces that are unusable */
 			if (!iface->is_active ||
 			    (is_ses_using_iface(ses, iface) &&
-			     !iface->rss_capable)) {
+			     !iface->rss_capable))
+				continue;
+
+			/* check if we already allocated enough channels */
+			iface_weight = iface->speed / iface_min_speed;
+
+			if (iface->weight_fulfilled >= iface_weight)
 				continue;
-			}
 
 			/* take ref before unlock */
 			kref_get(&iface->refcount);
@@ -255,10 +264,21 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 				continue;
 			}
 
-			cifs_dbg(FYI, "successfully opened new channel on iface:%pIS\n",
+			iface->num_channels++;
+			iface->weight_fulfilled++;
+			cifs_dbg(VFS, "successfully opened new channel on iface:%pIS\n",
 				 &iface->sockaddr);
 			break;
 		}
+
+		/* reached end of list. reset weight_fulfilled and start over */
+		if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+			list_for_each_entry(iface, &ses->iface_list, iface_head)
+				iface->weight_fulfilled = 0;
+			spin_unlock(&ses->iface_lock);
+			iface = NULL;
+			continue;
+		}
 		spin_unlock(&ses->iface_lock);
 
 		left--;
@@ -277,8 +297,10 @@ int
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
 	unsigned int chan_index;
+	size_t iface_weight = 0, iface_min_speed = 0;
 	struct cifs_server_iface *iface = NULL;
 	struct cifs_server_iface *old_iface = NULL;
+	struct cifs_server_iface *last_iface = NULL;
 	int rc = 0;
 
 	spin_lock(&ses->chan_lock);
@@ -298,13 +320,34 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_unlock(&ses->chan_lock);
 
 	spin_lock(&ses->iface_lock);
+	if (!ses->iface_count) {
+		spin_unlock(&ses->iface_lock);
+		cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
+		return 0;
+	}
+
+	last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
+				     iface_head);
+	iface_min_speed = last_iface->speed;
+
 	/* then look for a new one */
 	list_for_each_entry(iface, &ses->iface_list, iface_head) {
+		/* do not mix rdma and non-rdma interfaces */
+		if (iface->rdma_capable != server->rdma)
+			continue;
+
 		if (!iface->is_active ||
 		    (is_ses_using_iface(ses, iface) &&
 		     !iface->rss_capable)) {
 			continue;
 		}
+
+		/* check if we already allocated enough channels */
+		iface_weight = iface->speed / iface_min_speed;
+
+		if (iface->weight_fulfilled >= iface_weight)
+			continue;
+
 		kref_get(&iface->refcount);
 		break;
 	}
@@ -320,10 +363,22 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
+
+		old_iface->num_channels--;
+		if (old_iface->weight_fulfilled)
+			old_iface->weight_fulfilled--;
+		iface->num_channels++;
+		iface->weight_fulfilled++;
+
 		kref_put(&old_iface->refcount, release_iface);
 	} else if (old_iface) {
 		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
 			 &old_iface->sockaddr);
+
+		old_iface->num_channels--;
+		if (old_iface->weight_fulfilled)
+			old_iface->weight_fulfilled--;
+
 		kref_put(&old_iface->refcount, release_iface);
 	} else {
 		WARN_ON(!iface);
-- 
2.34.1

