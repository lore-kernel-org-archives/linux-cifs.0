Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B478C4167B
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 15:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiL2PeW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 10:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiL2PeU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 10:34:20 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27B413DF2
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 07:34:19 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3E2A18078D;
        Thu, 29 Dec 2022 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1672328058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ClyLlJqgyrtyL88TEIXrxUysVhBfR4ALYQnqNhQAis=;
        b=w3dTKqV7+vXuRyv/T0NcYTMjJC13Vl73tbufT4TLo4zeGmr1uRyOLVsEdXY2bEATmVNWQJ
        LET6VQ3fwCwvG5ZY/M8HS8slNbr6hLpqi5n9GIvdZp5sZscFnq5GVhx1uz1U2PLkROWdXu
        U8o8glLu+xGR74yg1nyrKRu3DDGRoLqqpNXHmp3hXSwTMh8xYON1hamuyChrFqHrRplbBO
        F1eWHyWOQ4xfOwgYhwL6vNrHNGXAgnfMpfzyEAWMSVNnjdo+CCckIfLiqbaPMxA0htG2ZM
        q1yyGo3F93r4x0ucmvwa6zlG0mvQH7P3MFko8M3CJ8a8GndYq0Cw/3HzexcsBg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/2] cifs: fix race in assemble_neg_contexts()
Date:   Thu, 29 Dec 2022 12:33:56 -0300
Message-Id: <20221229153356.8221-2-pc@cjr.nz>
In-Reply-To: <20221229153356.8221-1-pc@cjr.nz>
References: <20221229153356.8221-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Serialise access of TCP_Server_Info::hostname in
assemble_neg_contexts() by holding the server's mutex otherwise it
might end up accessing an already-freed hostname pointer from
cifs_reconnect() or cifs_resolve_server().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2pdu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a5695748a89b..2c484d47c592 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -541,9 +541,10 @@ static void
 assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
-	char *pneg_ctxt;
-	char *hostname = NULL;
 	unsigned int ctxt_len, neg_context_count;
+	struct TCP_Server_Info *pserver;
+	char *pneg_ctxt;
+	char *hostname;
 
 	if (*total_len > 200) {
 		/* In case length corrupted don't want to overrun smb buffer */
@@ -574,8 +575,9 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	 * secondary channels don't have the hostname field populated
 	 * use the hostname field in the primary channel instead
 	 */
-	hostname = CIFS_SERVER_IS_CHAN(server) ?
-		server->primary_server->hostname : server->hostname;
+	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
+	cifs_server_lock(pserver);
+	hostname = pserver->hostname;
 	if (hostname && (hostname[0] != 0)) {
 		ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
 					      hostname);
@@ -584,6 +586,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		neg_context_count = 3;
 	} else
 		neg_context_count = 2;
+	cifs_server_unlock(pserver);
 
 	build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
 	*total_len += sizeof(struct smb2_posix_neg_context);
-- 
2.39.0

