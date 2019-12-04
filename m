Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE36C43603
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 14:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF25620675
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 14:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="ZrRPLNlL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfLDOZe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:25:34 -0500
Received: from mx.cjr.nz ([51.158.111.142]:13358 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfLDOZe (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Dec 2019 09:25:34 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E6AC5809F8;
        Wed,  4 Dec 2019 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1575469532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xhTJDypOiEcGx6PN4UpfDsxOnr1U23+8K8R/nbirtcU=;
        b=ZrRPLNlLsDc655OXv5QfIPjsFiQ16yGfG1joJJt3ucvxdauV/C2sTD0hmdsMbRVTH0Mhgm
        LlT0dkoXlEFzmp3jpI0DQersPgvmXdEy2tEhnwSDuODoMb9xPcaBDnQ7Ejt5ruN+gd8MlU
        /dke5E61d96lXFAKAxn9MQckPM41qm7S0Xe5L5oHMKyutwkWPDILZqkg5Ak0hGW624wRwx
        5hYe0GvIV0ScFJt4HAwtNzFr1v07n8WtFiJgRquCSEV8I/4hIM0YWkRjfP3S3wXzMZ9KxN
        Obdr3xFE1h1c3h4suDmodWvVUe/FUe/zV8/Cq4HhtRRFi5DRx1AqkWRfPszpng==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] cifs: Fix lookup of SMB connections on multichannel
Date:   Wed,  4 Dec 2019 11:25:06 -0300
Message-Id: <20191204142506.12545-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With the addition of SMB session channels, we introduced new TCP
server pointers that have no sessions or tcons associated with them.

In this case, when we started looking for TCP connections, we might
end up picking session channel rather than the master connection,
hence failing to get either a session or a tcon.

In order to fix that, this patch introduces a new "is_channel" field
to TCP_Server_Info structure so we can skip session channels during
lookup of connections.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/connect.c  | 6 +++++-
 fs/cifs/sess.c     | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5b976e01dd6b..fd0262ce5ad5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -777,6 +777,7 @@ struct TCP_Server_Info {
 	 */
 	int nr_targets;
 	bool noblockcnt; /* use non-blocking connect() */
+	bool is_channel; /* if a session channel */
 };
 
 struct cifs_credits {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 86d1baedf21c..05ea0e2b7e0e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2712,7 +2712,11 @@ cifs_find_tcp_session(struct smb_vol *vol)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!match_server(server, vol))
+		/*
+		 * Skip ses channels since they're only handled in lower layers
+		 * (e.g. cifs_send_recv).
+		 */
+		if (server->is_channel || !match_server(server, vol))
 			continue;
 
 		++server->srv_count;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index fb3bdc44775c..d95137304224 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -213,6 +213,9 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 		chan->server = NULL;
 		goto out;
 	}
+	spin_lock(&cifs_tcp_ses_lock);
+	chan->server->is_channel = true;
+	spin_unlock(&cifs_tcp_ses_lock);
 
 	/*
 	 * We need to allocate the server crypto now as we will need
-- 
2.24.0

