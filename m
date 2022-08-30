Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0882ECAAD4
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 22:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiH3WwA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiH3Wv7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 18:51:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A17677F
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 15:51:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3378221E21;
        Tue, 30 Aug 2022 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661899917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rd2oE4E7U1bdlSo2fFNd9xGlUJk87gBLliZEqZQIaJU=;
        b=uxc7j+3Pt1fzW/AarHfK/Fak9Wco99EeLcU4+GtlkppZNosuIwJ9aKqBm4PdKsZ76hR9QP
        KmH2+jC2r8P+N8YOccGHZuPTgao70q3rLdoWsZyKlzOoSDWpYVUoboGa7ucyQggXGCewO9
        yhMZ+tpVGX5s6t0SQaN0MI3xFj/bubg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661899917;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rd2oE4E7U1bdlSo2fFNd9xGlUJk87gBLliZEqZQIaJU=;
        b=+iqyXaSBJjINMVSeO/GN11XUDOlre9MqgFk6yBIyUffxLK9a6tyLt47ZYKSapZkURN0Jzy
        FeoBJ6r1ec+MliBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE7AB13ACF;
        Tue, 30 Aug 2022 22:51:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vYK+HIyUDmNGcQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 30 Aug 2022 22:51:56 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: fix small mempool leak in SMB2_negotiate()
Date:   Tue, 30 Aug 2022 19:51:51 -0300
Message-Id: <20220830225151.26201-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In some cases of failure (dialect mismatches) in SMB2_negotiate(), after
the request is sent, the checks would return -EIO when they should be
rather setting rc = -EIO and jumping to neg_exit to free the response
buffer from mempool.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb2pdu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 128e44e57528..6352ab32c7e7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -965,16 +965,17 @@ SMB2_negotiate(const unsigned int xid,
 	} else if (rc != 0)
 		goto neg_exit;
 
+	rc = -EIO;
 	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb311_operations;
@@ -985,7 +986,7 @@ SMB2_negotiate(const unsigned int xid,
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_server_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			server->ops = &smb21_operations;
@@ -999,7 +1000,7 @@ SMB2_negotiate(const unsigned int xid,
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_server_dbg(VFS, "Invalid 0x%x dialect returned: not requested\n",
 				le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
@@ -1017,9 +1018,10 @@ SMB2_negotiate(const unsigned int xid,
 	else {
 		cifs_server_dbg(VFS, "Invalid dialect returned by server 0x%x\n",
 				le16_to_cpu(rsp->DialectRevision));
-		rc = -EIO;
 		goto neg_exit;
 	}
+
+	rc = 0;
 	server->dialect = le16_to_cpu(rsp->DialectRevision);
 
 	/*
-- 
2.35.3

