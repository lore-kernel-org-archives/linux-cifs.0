Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921D0C54EBD
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Jan 2023 16:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjAIQl5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbjAIQl4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Jan 2023 11:41:56 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476D38AFC
        for <linux-cifs@vger.kernel.org>; Mon,  9 Jan 2023 08:41:54 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 84FEB7FC01;
        Mon,  9 Jan 2023 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673282512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CO80if3HNq2TDNIK/FldymQU697MZGkCSKR2eGxt+d8=;
        b=VWzlfUv10EgNqOMrYUGD0w56q5j+vuQmLHleovipXeY79v79/0th9BgF0nVmDO2TohrIAJ
        EB/iMI9pvIsSTEnYhbnt58dc9485lu1rEZwmEn+OjDsEgSZVtgfmPC5dhIe18RlylTjjv/
        YIiiVXyRiMr7qyaF9zAPpGnNAJ5Ra2TdsIKaf6KKH84z5bL276hMNmE4oAUddhOJ5hk5HD
        Y88TayFcXG3gLoIGDi89aS9aQzEYu5yMdpx+uqXGV0fjiY8cYtz3KXmVSCOrrDZIEIHA2N
        NY7fhjRLUeLxTOGKcnSibMQPJD/dZX5+zOrFb9fgF3BQIR3xSVrXmhDuQthBhw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: do not query ifaces on smb1 mounts
Date:   Mon,  9 Jan 2023 13:41:46 -0300
Message-Id: <20230109164146.1910-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Users have reported the following error on every 600 seconds
(SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:

	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list

It's supported only by SMB2+, so do not query network interfaces on
SMB1 mounts.

Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/connect.c  | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cfdd5bf701a1..931e9d5b21f4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1240,6 +1240,7 @@ struct cifs_tcon {
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct list_head ulist; /* cache update list */
 #endif
+	bool			iface_query_poll:1;
 	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
 };
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d371259d6808..164beb365bfe 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2366,7 +2366,10 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* cancel polling of interfaces */
-	cancel_delayed_work_sync(&tcon->query_interfaces);
+	if (tcon->iface_query_poll) {
+		tcon->iface_query_poll = false;
+		cancel_delayed_work_sync(&tcon->query_interfaces);
+	}
 
 	if (tcon->use_witness) {
 		int rc;
@@ -2606,11 +2609,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	/* schedule query interfaces poll */
-	INIT_DELAYED_WORK(&tcon->query_interfaces,
-			  smb2_query_server_interfaces);
-	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	if (!is_smb1_server(ses->server)) {
+		/* schedule query interfaces poll */
+		tcon->iface_query_poll = true;
+		INIT_DELAYED_WORK(&tcon->query_interfaces,
+				  smb2_query_server_interfaces);
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
-- 
2.39.0

