Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA85EC6FA99
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCJPpm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjCJPpW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:45:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B835A1A6
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id ky4so5992152plb.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nL29z0D9lgUhrq6VnTtNAoUi5dj6i6sq+n1nV6q7Au4=;
        b=pkoWJhaj/ZFNvAqFGniXp6aKpjrUrqK00H6e/i15/D9huHk0Pqd50ZUxEOI2CeiTB6
         mQlPIDotP8U+2RZaZBhGLywuK4PAa4eSsf/5iNwactQdmD+F5Wgbe4GqbzQWscj/o9sG
         oqEu6YCixRCrtNDkXknxa4NTjm4PTm4jynojyQ2kCwurcBzKzNdAyPJ8obdldvZEkC3T
         1ucpeH3SkLnBe89JNFkAfjL9S8dkgZ/Ji4k/CAbLjJvNGE8Plgb7zuwlfryXLXGL+n8p
         G3W3RyeKrw1zxmIvHqpgNSWtZzHiwoCjNoLxKfrRAET/dQdHvGUfoepn5Ysgz0VgB24v
         RgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nL29z0D9lgUhrq6VnTtNAoUi5dj6i6sq+n1nV6q7Au4=;
        b=ODHQhD7aBZpT1AF0pORon60w/O66Thki0itwFDhCu837nCl5htlNMATGE68GHpNA6t
         DuZggc6N3HkIWHNupfVqrZzARxB1UKzA7+L4AqM85xDI+AA5m8rSK1xg1w3+tsjxrx+W
         P4iA0oaE46JJ29ZY5rUCZBbokJD8WLwZ/mwIEW0bkCXmbbImZysCZ/bX5mcHPHm45dO6
         jSn75s/TM2kF1R5UZTzGn6d++Sy2o4BG0LNRLT9vecciMnGHJrUJSK32H0HjPcd8LrbI
         tqrekqYLE+LbdidF3GxK95UoGZwmbePj6ztf+iO8WagKjCqtsmkx6uItE1fyyaAwQdd0
         bbhA==
X-Gm-Message-State: AO0yUKWSCd83tNllTNMHBOCHBmEqAfLZS7bu0Sx0MC3b5Q5MDikXjfPR
        LPZ7qkYLUgOqvYlFaPea8J4=
X-Google-Smtp-Source: AK7set/Q/deQPDX7kQoAupUg44OKz+7+L0jbficRS/cY2gfFEcO0Mjm4VtBbY89dApXichkMU6YO0g==
X-Received: by 2002:a17:90b:1e41:b0:237:39b1:7b1 with SMTP id pi1-20020a17090b1e4100b0023739b107b1mr26908148pjb.39.1678462435496;
        Fri, 10 Mar 2023 07:33:55 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:55 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 10/11] cifs: handle when server stops supporting multichannel
Date:   Fri, 10 Mar 2023 15:32:09 +0000
Message-Id: <20230310153211.10982-10-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When a server stops supporting multichannel, we will
keep attempting reconnects to the secondary channels today.
Avoid this by freeing extra channels when negotiate
returns no multichannel support.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/connect.c   |  6 ++++++
 fs/cifs/sess.c      | 35 +++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   |  8 ++++++++
 4 files changed, 51 insertions(+)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 30fd81268eb7..343e582672b9 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -638,6 +638,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
 bool
 cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
+void
+cifs_disable_extra_channels(struct cifs_ses *ses);
 int
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b9af60417194..6375b08b9bcb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -130,6 +130,12 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	if (rc) {
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
+
+		if (rc == -EOPNOTSUPP) {
+			/* cancel polling of interfaces and do not resched */
+			cancel_delayed_work_sync(&tcon->query_interfaces);
+			return;
+		}
 	}
 
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 9b51b2309e9c..34ae292bdff2 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -274,6 +274,41 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	return new_chan_count - old_chan_count;
 }
 
+/*
+ * called when multichannel is disabled by the server
+ */
+void
+cifs_disable_extra_channels(struct cifs_ses *ses)
+{
+	int i, chan_count;
+	struct cifs_server_iface *iface = NULL;
+	struct TCP_Server_Info *server = NULL;
+
+	spin_lock(&ses->chan_lock);
+	chan_count = ses->chan_count;
+	ses->chan_count = 1;
+	for (i = 1; i < chan_count; i++) {
+		iface = ses->chans[i].iface;
+		server = ses->chans[i].server;
+		spin_unlock(&ses->chan_lock);
+
+		if (iface) {
+			spin_lock(&ses->iface_lock);
+			kref_put(&iface->refcount, release_iface);
+			iface->num_channels--;
+			if (--iface->weight_fulfilled < 0)
+				iface->weight_fulfilled = 0;
+			spin_unlock(&ses->iface_lock);
+		}
+		cifs_put_tcp_session(server, 0);
+
+		spin_lock(&ses->chan_lock);
+		ses->chans[i].iface = NULL;
+		ses->chans[i].server = NULL;
+	}
+	spin_unlock(&ses->chan_lock);
+}
+
 /*
  * update the iface for the channel if necessary.
  * will return 0 when iface is updated, 1 if removed, 2 otherwise
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a5e53cb1ac49..c7a8a6049291 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -411,6 +411,14 @@ smb2_negotiate(const unsigned int xid,
 	/* BB we probably don't need to retry with modern servers */
 	if (rc == -EAGAIN)
 		rc = -EHOSTDOWN;
+
+	if (!rc &&
+	    ses->chan_count > 1 &&
+	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		cifs_dbg(VFS, "server %s does not support multichannel anymore\n", ses->server->hostname);
+		cifs_disable_extra_channels(ses);
+	}
+
 	return rc;
 }
 
-- 
2.34.1

