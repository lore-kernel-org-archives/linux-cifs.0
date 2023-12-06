Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnXSAdIu"
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD77D4F
	for <linux-cifs@vger.kernel.org>; Wed,  6 Dec 2023 08:37:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2886576cf18so5733a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Dec 2023 08:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701880670; x=1702485470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuH3ILYESFEVy0BtqJhi+L308nFbNw7mGWakcRFKU78=;
        b=bnXSAdIug2ZeFShiKuqb5uLm1kodNOj60Z9pFQNJgOdLbd0TnGeY7ZbyST4TCSv1Pb
         gkw8QzPyJVWsmJpPw1d59Mk+oiEps8LJ8ygfAQzQSKtjkzmonQuk66VOXymcHSW4NsWU
         9nVL904mvBdxunpupkNdLL+kxh4YznkFejceapdh1S536NcH/sJ2mdA+mvugiQcAjvdN
         UD6DDeKoFwMbMYc96Agn0tHrvoCoI/s3CEmMHQEvbi8nF4YpkAk76Xvil4+Eblur4Mbk
         /5bARwssaSx5BIxtuEhfaEGku1AyObPpALGoCFPwkxbpJTOr7u5cYr8IRzJc9LMAc57w
         BP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701880670; x=1702485470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NuH3ILYESFEVy0BtqJhi+L308nFbNw7mGWakcRFKU78=;
        b=FItUO4wK1K6QoVg8X0JTXfIUUi3mgl0Nl/Shw7vJPvZBHpX/4YD9FnQN1CRccY3rpy
         LgLCl2yKpJ5FG/hReUq1Uu76XgvQ2XTRA30xQDTCqkLXgopa+xGCsH0cv5GdLmzzYgvq
         NmEA/OeSQR3KvxQex8QXwYMnItOgeLtBnZEhPCx15DeyKljYJt0X7/9FJSlCZnifbWmh
         bg1byFki1r6jr101uaXAhj9/E/eIcLwJKd67XmsfGvXTwSCoWGbrl6uEaQlclIXI0qJ5
         TeKCDWG6neGU7t3ilQt2atNBipp9W9AXrNoypgYC44mPgxCAzWZZgtD59yJ+9neDs4Em
         NFOw==
X-Gm-Message-State: AOJu0Yw2bnEIcOQOsZChuDjFxXYO/1cMQWPPoGvvR1qAADoX3Os5eMEJ
	U/YYNvxWWo7da9/zQ9OKYLN0T3r6bwRhEg==
X-Google-Smtp-Source: AGHT+IHHYMjQNB9GpzHYIs92obLihk8dTQAkm+taClWMJbhdQBOOQw+HGQVNIjOrz9TYawd4C1tkYQ==
X-Received: by 2002:a17:90a:b296:b0:286:6cc1:26c with SMTP id c22-20020a17090ab29600b002866cc1026cmr1042073pjr.55.1701880670206;
        Wed, 06 Dec 2023 08:37:50 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id qj4-20020a17090b28c400b00286be9fb3fdsm31069pjb.40.2023.12.06.08.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:37:49 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm.hsk@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/3] cifs: reconnect worker should take reference on server struct unconditionally
Date: Wed,  6 Dec 2023 16:37:38 +0000
Message-Id: <20231206163738.4118-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231206163738.4118-1-sprasad@microsoft.com>
References: <20231206163738.4118-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Reconnect worker currently assumes that the server struct
is alive and only takes reference on the server if it needs
to call smb2_reconnect.

With the new ability to disable channels based on whether the
server has multichannel disabled, this becomes a problem when
we need to disable established channels. While disabling the
channels and deallocating the server, there could be reconnect
work that could not be cancelled (because it started).

This change forces the reconnect worker to unconditionally
take a reference on the server when it runs.

Also, this change now allows smb2_reconnect to know if it was
called by the reconnect worker. Based on this, the cifs_put_tcp_session
can decide whether it can cancel the reconnect work synchronously or not.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c |  8 ++++----
 fs/smb/client/smb2pdu.c | 29 +++++++++++++++--------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e07975173cf4..9dc6dc2754c2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1608,10 +1608,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	/* For secondary channels, we pick up ref-count on the primary server */
-	if (SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server->primary_server, from_reconnect);
-
 	cancel_delayed_work_sync(&server->echo);
 
 	if (from_reconnect)
@@ -1625,6 +1621,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
+	/* For secondary channels, we pick up ref-count on the primary server */
+	if (SERVER_IS_CHAN(server))
+		cifs_put_tcp_session(server->primary_server, from_reconnect);
+
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&server->srv_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 92b56c37b328..a7b7ed331a41 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -158,7 +158,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
-	       struct TCP_Server_Info *server)
+	       struct TCP_Server_Info *server, bool from_reconnect)
 {
 	int rc = 0;
 	struct nls_table *nls_codepage = NULL;
@@ -331,7 +331,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 				 * as cifs_put_tcp_session takes a higher lock
 				 * i.e. cifs_tcp_ses_lock
 				 */
-				cifs_put_tcp_session(server, 1);
+				cifs_put_tcp_session(server, from_reconnect);
 
 				server->terminate = true;
 				cifs_signal_cifsd_for_reconnect(server, false);
@@ -499,7 +499,7 @@ static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 {
 	int rc;
 
-	rc = smb2_reconnect(smb2_command, tcon, server);
+	rc = smb2_reconnect(smb2_command, tcon, server, false);
 	if (rc)
 		return rc;
 
@@ -3897,6 +3897,15 @@ void smb2_reconnect_server(struct work_struct *work)
 	int rc;
 	bool resched = false;
 
+	/* first check if ref count has reached 0, if not inc ref count */
+	spin_lock(&cifs_tcp_ses_lock);
+	if (!server->srv_count) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return;
+	}
+	server->srv_count++;
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
@@ -3954,17 +3963,10 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
-	/*
-	 * Get the reference to server struct to be sure that the last call of
-	 * cifs_put_tcon() in the loop below won't release the server pointer.
-	 */
-	if (tcon_exist || ses_exist)
-		server->srv_count++;
-
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
 		if (!rc)
 			cifs_reopen_persistent_handles(tcon);
 		else
@@ -3997,7 +3999,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -4012,8 +4014,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	if (tcon_exist || ses_exist)
-		cifs_put_tcp_session(server, 1);
+	cifs_put_tcp_session(server, true);
 }
 
 int
-- 
2.34.1

