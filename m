Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43558C64ED6
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Feb 2023 13:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjB0Nxn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Feb 2023 08:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjB0Nxm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Feb 2023 08:53:42 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C054486
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 05:53:41 -0800 (PST)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677506020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feELFml5agdvD3TnAJ7ks2qzg8YaYrQ2O2EBCE1qN9w=;
        b=cyqoEk5CPxz/IZtgT57l70Rc0WaGa+amqa0Ub5qmGJSrxgG7nRnpAGG6OS1XEaB7nULZLv
        aMHbSoNE8Fs0yC/iJR8nAnL+LVYCZrS7R/HrW9Tt+SLoPcHWXEvGrjTNh2wt/0Q4EXcpLD
        XA3PD/zMReJgTTqEfk9RvMmyodsraUdxAROIAevRTP9Em9c4RoF3ipinXTSLi1FM7zJhOm
        7/eNVuPQgGfZ3qyqIqSSLwlfBPbOTgtoNf82DtTJi0X+y8CSsZd98il8qkSpTEzIC1e0O7
        0VBRpNnqn+4GOUEud+/KGeHtIiAxMBND/oarOFnawlaL+CJdAcMBeVbIJsFnag==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677506020; a=rsa-sha256;
        cv=none;
        b=f7TUcLqY85Jhe1MG17MF//NvjXxO9WsaJ+D7KAxgxziMi1gl7w+BGFhle7RnNc0f40GP8X
        ORHxiMbnoKLK/onAtc1bpI0yfe/UVhr31bGSMLoa894IVusexm55DhrGR/cclg7zqePhpO
        a9JoL+ysmh0QHv/4I/VK9Pnd9tQ9vGIE9ky1xKtUzfB3fhm/2rGhWOM97LIYWkjYFkc/Yp
        cjWOVfn5lzEb4odS6RfY/FmIq/4ntyvJ/K5F1XaEF/r7trjXuu881SdeJvGdPwYcax3Ecb
        btWlIMjFoZU38RmzOw8xBtXNzC2iFhw0RC0Pt2DicJ9NGaF4pT3UYkyJurQQSw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677506020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=feELFml5agdvD3TnAJ7ks2qzg8YaYrQ2O2EBCE1qN9w=;
        b=hagcwPc07O5wdCkaK4tA1kr6Jy2GOetfXLvNbGkMLH92bu0lTl5muBdFByrE+zilQQmUAk
        TMT17FFXC2ac2z+dxEBGIWa/yjCnQtn1Q4hpauEinEqI3ti2mkUIT8/JhdxOaIjqzcdxgB
        G5s5UJkftYOSkJckvXb1FkFHDbQXM3ap3wgY6I3U1DSdAppqX3f90WJQWa6+o1NpOKyuKV
        ZbffXs17o1x4WNNaYqOsFOBwgnA1sQ/GPZBlEwlzbwc+9xGcvkOZNOTPNZX83ZPgU6m39+
        JU2i708HO8wfELVZw7l+AYjjVD0DFSK2/HC053eaR2PhKBy/brSyiTDpmtfFVg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/2] cifs: prevent data race in cifs_reconnect_tcon()
Date:   Mon, 27 Feb 2023 10:53:23 -0300
Message-Id: <20230227135323.26712-2-pc@manguebit.com>
In-Reply-To: <20230227135323.26712-1-pc@manguebit.com>
References: <20230227135323.26712-1-pc@manguebit.com>
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
index 003b0a522fea..5cd7db817bee 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1265,3 +1265,47 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
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
index ca9d7110ddcb..62c125e73b73 100644
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
+		spin_unlock(&server->srv_lock);
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

