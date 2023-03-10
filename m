Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DE4C64EC4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbjCJPp2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbjCJPpH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:45:07 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF89E192A
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x34so5715492pjj.0
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPRsolOFcQ08OS615HvQ6WjsCmMIeIIEZEMJU0TjORE=;
        b=V9O26sEI7vTrPOSKgwfOzOXwL4kzSHFt8q5kob61NgRy2wWeQzcljH95v+/C4/wF2I
         AWuD1/K1+KPfR627Fa4YCqOJUgFjOCTs6lnz8DI6dwdV+1shZaYLn2XX0/dfGXLPbo9p
         Wkg2uTAzp4tFwGPU9AT2c7O+E0HJpm8Y9Ieo5wLk5jfanaFqNE5ATRAjBpVCiY7doszB
         VuCkVj9Cbq9dRUR74BBJlbC+azXFX/iAp31AXU0PHVvvEO0SmBbHmTfsbu7NE3Wj07iE
         HKeXFPJ06UambVM/Cv4DCSsyQzU/kH72sF8+HC8WFA8DoaP8ijUTZjvXECJ00JVeWGOD
         D1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPRsolOFcQ08OS615HvQ6WjsCmMIeIIEZEMJU0TjORE=;
        b=0hEBcQLq3UqaDzm/oQKVmrv9h05Wyk9YokgBxd6WzpMCIrYf8/x64M4DY3K6kgsFAJ
         LK3N2vokvwCbK+/dvDB73a3nmYThPbtodXb/wrlHvJLcy+mCIOsTZaNXp2l8RcnfirOI
         lcy7FEO0LEir3WaLsTuMdClZZH2sr6CMPOe98aAWbSlEbCHiwtmHVUmra5/wn02rjuTv
         C7kK3e9SzoAxPFvYObzDlh/ypvsHYSOit7Pt23Mf6TBP8UXzxfp41FrKgOsCMhDxGR2d
         JWM+oVaAVeIW+V9d5/WkSp2xdWHPSmvIueMH3hvvMDFUPflEE/CLF2OG81kV+EQ3/Y4q
         9hXw==
X-Gm-Message-State: AO0yUKUYw1NCiL8fIWl5mGxTgTk2EL/81/QZmAhGHSkH+tEDjHIuwKaN
        Wlgt+WytSuXEMRzRC5XMemA=
X-Google-Smtp-Source: AK7set/eAHQM20J6VRUzTNtb4AYVqfn9InI0K5xhJwCgNZkNuryyFQS7ThCEav0daC7eP3WmJfHzPA==
X-Received: by 2002:a17:90b:3882:b0:22c:1e06:26ec with SMTP id mu2-20020a17090b388200b0022c1e0626ecmr26269154pjb.44.1678462421696;
        Fri, 10 Mar 2023 07:33:41 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:41 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 08/11] cifs: distribute channels across interfaces based on speed
Date:   Fri, 10 Mar 2023 15:32:07 +0000
Message-Id: <20230310153211.10982-8-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
 fs/cifs/cifs_debug.c | 16 +++++++++++
 fs/cifs/cifsglob.h   |  2 ++
 fs/cifs/sess.c       | 67 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 4391c7aac3cb..cee3af02e2c3 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -219,6 +219,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifs_server_iface *iface;
+	size_t iface_weight = 0, iface_min_speed = 0;
+	struct cifs_server_iface *last_iface = NULL;
 	int c, i, j;
 
 	seq_puts(m,
@@ -465,11 +467,25 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
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
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a11e7b10f607..e3ba5c979832 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -948,6 +948,8 @@ struct cifs_server_iface {
 	struct list_head iface_head;
 	struct kref refcount;
 	size_t speed;
+	size_t weight_fulfilled;
+	unsigned int num_channels;
 	unsigned int rdma_capable : 1;
 	unsigned int rss_capable : 1;
 	unsigned int is_active : 1; /* unset if non existent */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index b8bfebe4498e..78a7cfa75e91 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -167,7 +167,9 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	int left;
 	int rc = 0;
 	int tries = 0;
+	size_t iface_weight = 0, iface_min_speed = 0;
 	struct cifs_server_iface *iface = NULL, *niface = NULL;
+	struct cifs_server_iface *last_iface = NULL;
 
 	spin_lock(&ses->chan_lock);
 
@@ -196,21 +198,11 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
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
@@ -218,17 +210,34 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
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
@@ -245,10 +254,17 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
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
+		/* reached end of list. reset weight_fulfilled */
+		if (list_entry_is_head(iface, &ses->iface_list, iface_head))
+			list_for_each_entry(iface, &ses->iface_list, iface_head)
+				iface->weight_fulfilled = 0;
 		spin_unlock(&ses->iface_lock);
 
 		left--;
@@ -267,8 +283,10 @@ int
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
 	unsigned int chan_index;
+	size_t iface_weight = 0, iface_min_speed = 0;
 	struct cifs_server_iface *iface = NULL;
 	struct cifs_server_iface *old_iface = NULL;
+	struct cifs_server_iface *last_iface = NULL;
 	int rc = 0;
 
 	spin_lock(&ses->chan_lock);
@@ -288,13 +306,34 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
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
-- 
2.34.1

