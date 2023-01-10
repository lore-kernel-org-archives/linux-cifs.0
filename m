Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14690C46467
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 22:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbjAJW0D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjAJWZj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 17:25:39 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3766D516
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 14:23:37 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5A2C07FC04;
        Tue, 10 Jan 2023 22:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673389415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MK06wd6uF+lvMIr+BTKreOj/wd7Ai8ro+ykHbREJ2r8=;
        b=YTnt1cjj9JE3ZoPnpkqckbZU8mUZ1TYG6F7dYNdmNQTqVdsbpWaIeXtsEWVDOMytVAkjqm
        7lJ/9BCzpgPfL3zOOvcjoe3AjrpMEkc0hNC6mmbTudKyVwP1mA4krC8sPbxQBG1MYb21ni
        /MEh8lQije9GgDau2pyRz1q3nhT6kL6DdptqC1jvMuImdhIckiiVdtepAEtYYv55XFzPI/
        D7bjOJS5yPnjMf9en8TBi28W/UVhmJoHEZ0L7kTSApbQxoKEWCR6WKlbjn1gOcp/wTUnF4
        nfO+M6vfcDDN3GCRY63LL/yoMBNM/cmBywRDeogtYKWifLk7Ka0aM3FZlY9p0g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] cifs: do not query ifaces on smb1 mounts
Date:   Tue, 10 Jan 2023 19:23:21 -0300
Message-Id: <20230110222321.30860-1-pc@cjr.nz>
In-Reply-To: <20230109164146.1910-1-pc@cjr.nz>
References: <20230109164146.1910-1-pc@cjr.nz>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
v1 -> v2:
	remove cifs_tcon::iface_query_poll and then check version and
	server's capability multichannel

 fs/cifs/connect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d371259d6808..b2a04b4e89a5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2606,11 +2606,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,
 			  smb2_query_server_interfaces);
-	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	if (ses->server->dialect >= SMB30_PROT_ID &&
+	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		/* schedule query interfaces poll */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
-- 
2.39.0

