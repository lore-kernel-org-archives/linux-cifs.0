Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3425C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjJ3LA7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjJ3LA6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A9F8E
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-5aa481d53e5so2527880a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663655; x=1699268455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANtRK5CIMrRcnxqCNV/cGBCNsANqWR7d1jq+KVeQWF8=;
        b=dogt0l9dQnwrWb6HmW7g3Axhek19+v4yNEicQ93T91JfDEZcHUm17epWyCqzvxTPCt
         aHYvBciPgd+FoD1ZbxjsKs7LZe/grQtGZRU+11aZLJbvmjyyR8IR6fL+yArPlbc5Olbs
         XWsuCYwUkicjMluw4JuQCNUEzdIijn7VAay14haXrMXKfwUslGDOHH0QsJ/f7QXg+MCu
         J3sXJTPPKbRlBWf6vZIZXFI4EoY/KTLiFG8yU8TQaD/0fLBWXh1mgv2sc7BuLXB5bVbZ
         +7sbJOmCZShJFX/7lymguZOxG6u9fS5ypETwxmJC+lLt1/ycQ8PLQMgA6Tejuh74EN9n
         sUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663655; x=1699268455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANtRK5CIMrRcnxqCNV/cGBCNsANqWR7d1jq+KVeQWF8=;
        b=DgKmgsiWGXlbvIvkGDQFzGHuWxiA340AVO1Cmg33FXwNvZ/3fjabYEKejS8MwP5NWQ
         Id+CONmkQEaeyLisY2UtmnKLudSay4EA6p6EFxz50RuhS9Gkx4khgxRg3ihpeFOj5IpF
         KBeCYx1CV4yKMAUk2qZAvxvsj1zJzejPaAdsoS+KRbsa3VqSKtFTb1kTQU8XRQklqcws
         j0TA6Yb8H67GUVSjlzXbknv0ge18sA6KzFMN2soeIaP1/oVImGjDC7fnpPweB8Nnl/Db
         gQKvhAPYY66Tq82x7ltBAt5gbiT6QOp12DaOLyXFntyqOnJEqW7seVD5AuNfRC+SFw6r
         TOBw==
X-Gm-Message-State: AOJu0Yy1jGO35yd2P70GSiGMewiaHYBDFEwbevudP8u78RLiMD9HWIva
        QqydTx0Eq2nNJwcIvEDZZm0=
X-Google-Smtp-Source: AGHT+IGA1vo0Cff6eRm5JxcBxa66prGWn8wrTxcHsele2EsQTd5E4SGAjM3KBjfxqjRyV6jKrdNpow==
X-Received: by 2002:a05:6a21:6da1:b0:175:7085:ba18 with SMTP id wl33-20020a056a216da100b001757085ba18mr8223932pzb.58.1698663655099;
        Mon, 30 Oct 2023 04:00:55 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:54 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 11/14] cifs: handle when server starts supporting multichannel
Date:   Mon, 30 Oct 2023 11:00:17 +0000
Message-Id: <20231030110020.45627-11-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

When the user mounts with multichannel option, but the
server does not support it, there can be a time in future
where it can be supported.

With this change, such a case is handled.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsproto.h |  4 ++++
 fs/smb/client/connect.c   |  6 +++++-
 fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++++++++++++++---
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 65c84b3d1a65..5a4c1f1e0d91 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -132,6 +132,10 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *in_buf,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
+
+void
+smb2_query_server_interfaces(struct work_struct *work);
+
 void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e71aa33bf026..149cde77500e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -116,7 +116,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	return rc;
 }
 
-static void smb2_query_server_interfaces(struct work_struct *work)
+void
+smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
 	int xid;
@@ -134,6 +135,9 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	if (rc) {
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
+
+		if (rc == -EOPNOTSUPP)
+			return;
 	}
 
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b7665155f4e2..2617437a4627 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -163,6 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct nls_table *nls_codepage = NULL;
 	struct cifs_ses *ses;
+	int xid;
 
 	/*
 	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
@@ -307,17 +308,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		tcon->need_reopen_files = true;
 
 	rc = cifs_tree_connect(0, tcon, nls_codepage);
-	mutex_unlock(&ses->session_mutex);
 
 	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc) {
 		/* If sess reconnected but tcon didn't, something strange ... */
+		mutex_unlock(&ses->session_mutex);
 		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
 		goto out;
 	}
 
-	if (smb2_command != SMB2_INTERNAL_CMD)
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+	if (!rc &&
+	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		mutex_unlock(&ses->session_mutex);
+
+		/*
+		 * query server network interfaces, in case they change
+		 */
+		xid = get_xid();
+		rc = SMB3_request_interfaces(xid, tcon, false);
+		free_xid(xid);
+
+		if (rc)
+			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
+				 __func__, rc);
+
+		if (ses->chan_max > ses->chan_count &&
+		    !SERVER_IS_CHAN(server)) {
+			if (ses->chan_count == 1)
+				cifs_dbg(VFS, "server %s supports multichannel now\n",
+					 ses->server->hostname);
+
+			cifs_try_adding_channels(tcon->cifs_sb, ses);
+		}
+	} else {
+		mutex_unlock(&ses->session_mutex);
+	}
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
-- 
2.34.1

