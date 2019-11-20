Return-Path: <SRS0=JRKv=ZM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3987C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Nov 2019 16:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A70A7206F4
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Nov 2019 16:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfKTQQG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:16:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbfKTQQG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Nov 2019 11:16:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD353B2FA8;
        Wed, 20 Nov 2019 16:16:04 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 2/2] cifs: try harder to open new channels
Date:   Wed, 20 Nov 2019 17:15:59 +0100
Message-Id: <20191120161559.30295-2-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191120161559.30295-1-aaptel@suse.com>
References: <20191120161559.30295-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Previously we would only loop over the iface list once.
This patch tries to loop over multiple times until all channels are
opened. It will also try to reuse RSS ifaces.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/sess.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index ee6bf47b6cfe..fb3bdc44775c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -76,6 +76,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 	int left = ses->chan_max - ses->chan_count;
 	int i = 0;
 	int rc = 0;
+	int tries = 0;
 
 	if (left <= 0) {
 		cifs_dbg(FYI,
@@ -89,29 +90,40 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 		return 0;
 	}
 
-	/* ifaces are sorted by speed, try them in order */
-	for (i = 0; left > 0 && i < ses->iface_count; i++) {
+	/*
+	 * Keep connecting to same, fastest, iface for all channels as
+	 * long as its RSS. Try next fastest one if not RSS or channel
+	 * creation fails.
+	 */
+	while (left > 0) {
 		struct cifs_server_iface *iface;
 
+		tries++;
+		if (tries > 3*ses->chan_max) {
+			cifs_dbg(FYI, "too many attempt at opening channels (%d channels left to open)\n",
+				 left);
+			break;
+		}
+
 		iface = &ses->iface_list[i];
-		if (is_ses_using_iface(ses, iface) && !iface->rss_capable)
+		if (is_ses_using_iface(ses, iface) && !iface->rss_capable) {
+			i = (i+1) % ses->iface_count;
 			continue;
+		}
 
 		rc = cifs_ses_add_channel(ses, iface);
 		if (rc) {
-			cifs_dbg(FYI, "failed to open extra channel\n");
+			cifs_dbg(FYI, "failed to open extra channel on iface#%d rc=%d\n",
+				 i, rc);
+			i = (i+1) % ses->iface_count;
 			continue;
 		}
 
-		cifs_dbg(FYI, "successfully opened new channel\n");
+		cifs_dbg(FYI, "successfully opened new channel on iface#%d\n",
+			 i);
 		left--;
 	}
 
-	/*
-	 * TODO: if we still have channels left to open try to connect
-	 * to same RSS-capable iface multiple times
-	 */
-
 	return ses->chan_count - old_chan_count;
 }
 
-- 
2.16.4

