Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAE4C4743C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A551E61406
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhFDW1n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:43 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9422 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhFDW1n (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:43 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id B3C5880BAC;
        Fri,  4 Jun 2021 22:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQ4A78kYxY+P9cz4ulaNwRTpL9i+XEDex9tzlOUDPIM=;
        b=dKd08qjuc0aNyOKN0nQVV3Pz6J2lL0M0rxirSbZ5hNF+iPLf35cCTm/oR39YKwqymHeaoJ
        i9DJ5wAryBOasxQUwLaDHiiniymp6cjogx6Rlo/8Aazf355XGQgJNrBrBgvsdKKJT3WY1H
        nn/QzsaCBUsw8Cbca57nf6vggVmHNh9ovnj/Byu+NJzxUTTxHjX9eAHwuTfeQZIDAG5mCZ
        HCcwW/Q2Tp/x0LjxW0zwkNrg7pcwSSyubfQ5QKVPWC+h+81h7XweYWtxWK2Ei6yIrxWSeN
        g6vpNs0hqYQENwFqVJWwSMmoJwuCWvVuo8GAWdL66+r4XrAo7o7yR4H8zf0Ymw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/7] cifs: do not send tree disconnect to ipc shares
Date:   Fri,  4 Jun 2021 19:25:27 -0300
Message-Id: <20210604222533.4760-2-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On session close, the IPC is closed and the server must release all
tcons of the session.  It doesn't matter if we send a ipc close or
not.

Besides, it will make the server to not close durable and resilient
files on session close, as specified in MS-SMB2 3.3.5.6 Receiving an
SMB2 LOGOFF Request.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 495c395f9def..5ac1bd17463d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1562,24 +1562,14 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 static int
 cifs_free_ipc(struct cifs_ses *ses)
 {
-	int rc = 0, xid;
 	struct cifs_tcon *tcon = ses->tcon_ipc;
 
 	if (tcon == NULL)
 		return 0;
 
-	if (ses->server->ops->tree_disconnect) {
-		xid = get_xid();
-		rc = ses->server->ops->tree_disconnect(xid, tcon);
-		free_xid(xid);
-	}
-
-	if (rc)
-		cifs_dbg(FYI, "failed to disconnect IPC tcon (rc=%d)\n", rc);
-
 	tconInfoFree(tcon);
 	ses->tcon_ipc = NULL;
-	return rc;
+	return 0;
 }
 
 static struct cifs_ses *
-- 
2.31.1

