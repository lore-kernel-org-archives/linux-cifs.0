Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426AEC64EC4
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 22:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjB1WCS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 17:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjB1WCR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 17:02:17 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCE232E7B
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:02:14 -0800 (PST)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677621733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4a1OSwFoSrLwrmjz9AYt91K1pqTJrXUfO93+eEd9jI=;
        b=mpcM+Yr73iYR+1IVFL9YdDTFJDxrTvwLbW+TjPxyGgZP+LiFJnQ4SpCgrKK/OwbxGhzbIU
        m4CrbMQc/1hVeYeB/W5cz2oi+KCQ7SYTCXPncsAdKz59g9e2FT74OEXIeQKATIKBwdKfWw
        HFGrij476FAYIn6mToQoJVHCCkPEwMVOE5frPHcyOn9J9kF1Si5Eg9l4UerjFyXnrDS5Ov
        fPnzxhmIDh4d+oETcKyq3uawrmxWIvdRAXDrK6z1t6imOtDKsIe/5pZTMT876t3B4+RQxq
        CannUCZ8ZGv4G9lOBS5zbItEooGxuiczFNO4DUz7RXaSE7+AUlpbrguMVVjo0Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677621733; a=rsa-sha256;
        cv=none;
        b=EYnNKe+CMwCUUYP6ly3oGw8GxEJu4jsILjp/HAYTcfXHJCrwai4SH1RQcvr3NSCWBuLMeO
        WlqeCy10R8LSb7FfXytDBUDlvlyQskzhai+8T6x/omN6hMLrTaw6LbEYfYFlYku40deZO6
        dnXUJYjsMD+8S6dQHyPZDYhWKKQyVfY4EsjUaY8E43LDfi2qe1665tBThEgBIT5K6JbIXQ
        SF76mBOLojjBsm/Yh4vmwTPPb7ITlaHZe4HLtd0PRFuM+w8hIPDIkqdhIJ6XsOnLusb89y
        0tj/cDmgSUAVmf+ZcqTvMXoUj3A396mYR6LDR52R5RxVaAFSInup+FefRV2SLg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677621733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4a1OSwFoSrLwrmjz9AYt91K1pqTJrXUfO93+eEd9jI=;
        b=XbXqDuJakYzh+dBxXH7mDwKfQpnrKu8Z0Dk/+ecUdtsSQtgtsDsJpIOF1bguZu4xfKblCp
        DhWeSPvMBmBn6+H9oQVvxAN5zb3JwMfSccvw+25lB9CPeUSwiKsYlQw/gGb6JYbk0cXsEx
        M1GzYvCehpxZ9WCSmFc21+hfjsV++xCZBgraAQgqZMb9ZHba/5UdB2ZZER4UTHZZ57Gkk1
        Vr2tkTdECAcinneSBqiFtTBadEUlXWxoqATsPAkqtk33zRfmm3eZbE32SDSMrx3Le2T8HI
        kXC7wjK7J5KNYWfyr5GocOGmvgPLRy3HyqlamXmsYnNtp+m9wHK8rhR06Of9/w==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 2/2] cifs: prevent data race in cifs_reconnect_tcon()
Date:   Tue, 28 Feb 2023 19:01:55 -0300
Message-Id: <20230228220155.23394-2-pc@manguebit.com>
In-Reply-To: <20230228220155.23394-1-pc@manguebit.com>
References: <20230227135323.26712-1-pc@manguebit.com>
 <20230228220155.23394-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
to waiting the server to be reconnected in cifs_reconnect_tcon().  It
is set in cifs_tcp_ses_needs_reconnect() and protected by
TCP_Server_Info::srv_lock.

Create a new cifs_wait_for_server_reconnect() helper that can be used
by both SMB2+ and CIFS reconnect code.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
v1 -> v2: fixed double unlock pointed out by Steve

 fs/cifs/cifsproto.h |  1 +
 fs/cifs/cifssmb.c   | 43 ++----------------------
 fs/cifs/misc.c      | 44 ++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 82 ++++++++++++---------------------------------
 4 files changed, 69 insertions(+), 101 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 20a2f0f3f682..e2eff66eefab 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -694,5 +694,6 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 
 struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
 void cifs_put_tcon_super(struct super_block *sb);
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
 
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a24e4ddf8043..a43c78396dd8 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -72,7 +72,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
 	struct nls_table *nls_codepage;
-	int retries;
 
 	/*
 	 * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check for
@@ -102,45 +101,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&tcon->tc_lock);
 
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
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
+	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	if (rc)
+		return rc;
 
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 0c6c1fc8dae9..a0d286ee723d 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1266,3 +1266,47 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	return 0;
 }
 #endif
+
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
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
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ca9d7110ddcb..0e53265e1462 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -139,66 +139,6 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 	return;
 }
 
-static int wait_for_server_reconnect(struct TCP_Server_Info *server,
-				     __le16 smb2_command, bool retry)
-{
-	int timeout = 10;
-	int rc;
-
-	spin_lock(&server->srv_lock);
-	if (server->tcpStatus != CifsNeedReconnect) {
-		spin_unlock(&server->srv_lock);
-		return 0;
-	}
-	timeout *= server->nr_targets;
-	spin_unlock(&server->srv_lock);
-
-	/*
-	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-	 * here since they are implicitly done when session drops.
-	 */
-	switch (smb2_command) {
-	/*
-	 * BB Should we keep oplock break and add flush to exceptions?
-	 */
-	case SMB2_TREE_DISCONNECT:
-	case SMB2_CANCEL:
-	case SMB2_CLOSE:
-	case SMB2_OPLOCK_BREAK:
-		return -EAGAIN;
-	}
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 *
-	 * On "soft" mounts we wait once. Hard mounts keep retrying until
-	 * process is killed or server comes back on-line.
-	 */
-	do {
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      timeout * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
-				 __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus != CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			return 0;
-		}
-		spin_unlock(&server->srv_lock);
-	} while (retry);
-
-	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
-	return -EHOSTDOWN;
-}
-
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server)
@@ -243,7 +183,27 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
-	rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsNeedReconnect) {
+		/*
+		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+		 * here since they are implicitly done when session drops.
+		 */
+		switch (smb2_command) {
+		/*
+		 * BB Should we keep oplock break and add flush to exceptions?
+		 */
+		case SMB2_TREE_DISCONNECT:
+		case SMB2_CANCEL:
+		case SMB2_CLOSE:
+		case SMB2_OPLOCK_BREAK:
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock(&server->srv_lock);
+
+	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
 	if (rc)
 		return rc;
 
-- 
2.39.2

