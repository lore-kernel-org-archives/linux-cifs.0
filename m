Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A5EC54EAA
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 23:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjA3Xdm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 18:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjA3Xdk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 18:33:40 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7162BEE3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 15:33:38 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EC5CA7FEB4;
        Mon, 30 Jan 2023 23:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675121616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iiW56G6nq6kEemrfRoUVg0HqDM2CJoIzw7mWn7G5GRk=;
        b=J0KkkDCyWSDMLiMfoGHPerz6yAvsVAVWHEo2bwJzkrvH8xB09jBIzfrMd6ttuvnr1XspzS
        FbbyadFeL6w1KjxPO3n64jDIJCX09YB7e1yzbDCnrlhVvEoGJGAT8orSEPmSWYmrxll/4P
        acGcCeUrK6lp/qfLbKyrEyfQSPMzYBhuB/oDoWtBOKrQnsB//S5z8mAAN3hcxgMoH/yv4M
        2kHEtYu+BbS/jdUOYFEVOCd8fjTy9JMrpH6yw/Nm3AeXfg6Hkiz+dk+hnebtYhGqlje85l
        YGkks1gD39mmo6oLW+2rU2mTjQ91Sg2aWncLsYMflWirGeQv8lK/zmrpOrS1KQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: prevent data race in smb2_reconnect()
Date:   Mon, 30 Jan 2023 20:33:29 -0300
Message-Id: <20230130233329.7074-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
to waiting the server to be reconnected in smb2_reconnect().  It is
set in cifs_tcp_ses_needs_reconnect() and protected by
TCP_Server_Info::srv_lock.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2pdu.c | 119 +++++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2c9ffa921e6f..2d5c3df2277d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -139,6 +139,66 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
+static int wait_for_server_reconnect(struct TCP_Server_Info *server,
+				     __le16 smb2_command, bool retry)
+{
+	int timeout = 10;
+	int rc;
+
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus != CifsNeedReconnect) {
+		spin_unlock(&server->srv_lock);
+		return 0;
+	}
+	timeout *= server->nr_targets;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+	 * here since they are implicitly done when session drops.
+	 */
+	switch (smb2_command) {
+	/*
+	 * BB Should we keep oplock break and add flush to exceptions?
+	 */
+	case SMB2_TREE_DISCONNECT:
+	case SMB2_CANCEL:
+	case SMB2_CLOSE:
+	case SMB2_OPLOCK_BREAK:
+		return -EAGAIN;
+	}
+
+	/*
+	 * Give demultiplex thread up to 10 seconds to each target available for
+	 * reconnect -- should be greater than cifs socket timeout which is 7
+	 * seconds.
+	 *
+	 * On "soft" mounts we wait once. Hard mounts keep retrying until
+	 * process is killed or server comes back on-line.
+	 */
+	do {
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      timeout * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
+				 __func__);
+			return -ERESTARTSYS;
+		}
+
+		/* are we still trying to reconnect? */
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsNeedReconnect) {
+			spin_unlock(&server->srv_lock);
+			return 0;
+		}
+		spin_unlock(&server->srv_lock);
+	} while (retry);
+
+	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
+	return -EHOSTDOWN;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
@@ -146,7 +206,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
-	int retries;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -184,61 +243,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
+	rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
+	if (rc)
+		return rc;
+
 	ses = tcon->ses;
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
-		/*
-		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-		 * here since they are implicitly done when session drops.
-		 */
-		switch (smb2_command) {
-		/*
-		 * BB Should we keep oplock break and add flush to exceptions?
-		 */
-		case SMB2_TREE_DISCONNECT:
-		case SMB2_CANCEL:
-		case SMB2_CLOSE:
-		case SMB2_OPLOCK_BREAK:
-			return -EAGAIN;
-		}
-
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      10 * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			break;
-		}
-		spin_unlock(&server->srv_lock);
-
-		if (retries && --retries)
-			continue;
-
-		/*
-		 * on "soft" mounts we wait once. Hard mounts keep
-		 * retrying until process is killed or server comes
-		 * back on-line
-		 */
-		if (!tcon->retry) {
-			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
-			return -EHOSTDOWN;
-		}
-		retries = server->nr_targets;
-	}
 
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
-- 
2.39.1

