Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364B5EB64DA
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 08:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjGNI4x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbjGNI4w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 04:56:52 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6158A2120
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 01:56:49 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6b9b52724ccso864925a34.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 01:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689325008; x=1689929808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mttjMBzUqoIKG1b+qmHt6r2ztAyfJL97O64smzTfDxs=;
        b=X5H8zuYpiXvfLa4PERizv5uEvtXD1WYfAuGw/tTzEWZmae6KsSbogZsUJ5MNfBz30e
         ExuV+IZKWvch5sZpEPZ2mcoXUNQmvXI0xpkSHjTplA12sUFeuEfD7gKOfK1P+Bf4qoDb
         rdZtgLu73gjKB3D2gjpytjwsyFMAv+yq/hNYsuv4ABkIs5q49t541A3o8opAE5Xzz+PT
         n/7QdlkQS9f3Ev1UaOg9ouwPfEjvSEsY/nlS26EwXGQZBP7kSk3kw23sF/KNGiuJKBiF
         D6G1UOoeJLf+hEPiVSs8/qkwM4/WoxCB14mZ2HCEMc8OLiwMDLG24Gh3EpyNNALE/YwP
         Jcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689325008; x=1689929808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mttjMBzUqoIKG1b+qmHt6r2ztAyfJL97O64smzTfDxs=;
        b=GHmdSb+3GXN9sAKbAtCPtzVpn+Sct94FBc/UFolpAId2H9BR40N3ewb1tp3wvo0yFy
         XTDeSu3aX/Q/UrKNBEiHU6I5+8UT2RnQVXou00dN+gdBAe3yW2XkSkTG2sj7n71Bsf7O
         YYFEG7Ao2IvlL3aAdbKO2jZcRJYs/NqecBovkabnMcyrdcO2/R8pMyv04SUCmwg5ImIo
         oLbaRuGHhzg51cfXWPfgo9lEZ1LRgp6lA4bGzmwoHBvH4pEkPL3g5il6n3OUJlWdPOE+
         N0Tt3m3CNb5TaUtMSetz4h27yR5IvFsbxpfTPysUJQSsn4sSk30LRasUOyhcC+Zg+fqZ
         Excg==
X-Gm-Message-State: ABy/qLZJaLGgbLTD+Umf+sMr9yC7mbhaLb/7wOIbIbTHrEuc5WfKh8jP
        iYEJlhP2oya/agXJKPedVxPwNtWCfidTrg==
X-Google-Smtp-Source: APBJJlH0h1lAWoRaz/cEJbH3GX83mhWVuSzan5f0iz2uhjzLVO6fKwG5TbR499+BdTWi/AiCAiZRfw==
X-Received: by 2002:a05:6358:5916:b0:130:e0a9:a7b4 with SMTP id g22-20020a056358591600b00130e0a9a7b4mr5668568rwf.13.1689325008015;
        Fri, 14 Jul 2023 01:56:48 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id c11-20020aa78c0b000000b006765cb32558sm6702838pfd.139.2023.07.14.01.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 01:56:47 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/2] cifs: is_network_name_deleted should return a bool
Date:   Fri, 14 Jul 2023 08:56:34 +0000
Message-Id: <20230714085634.10808-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714085634.10808-1-sprasad@microsoft.com>
References: <20230714085634.10808-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently, is_network_name_deleted and it's implementations
do not return anything if the network name did get deleted.
So the function doesn't fully achieve what it advertizes.

Changed the function to return a bool instead. It will now
return true if the error returned is STATUS_NETWORK_NAME_DELETED
and the share (tree id) was found to be connected. It returns
false otherwise.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  2 +-
 fs/smb/client/connect.c  | 11 ++++++++---
 fs/smb/client/smb2ops.c  |  8 +++++---
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b212a4e16b39..bde9de6665a7 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -532,7 +532,7 @@ struct smb_version_operations {
 	/* Check for STATUS_IO_TIMEOUT */
 	bool (*is_status_io_timeout)(char *buf);
 	/* Check for STATUS_NETWORK_NAME_DELETED */
-	void (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
+	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
 };
 
 struct smb_version_values {
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 87047bd38485..6756ce4ff641 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1233,9 +1233,14 @@ cifs_demultiplex_thread(void *p)
 			if (mids[i] != NULL) {
 				mids[i]->resp_buf_size = server->pdu_size;
 
-				if (bufs[i] && server->ops->is_network_name_deleted)
-					server->ops->is_network_name_deleted(bufs[i],
-									server);
+				if (bufs[i] != NULL) {
+					if (server->ops->is_network_name_deleted &&
+					    server->ops->is_network_name_deleted(bufs[i],
+										 server)) {
+						cifs_server_dbg(FYI,
+								"Share deleted. Reconnect needed");
+					}
+				}
 
 				if (!mids[i]->multiRsp || mids[i]->multiEnd)
 					mids[i]->callback(mids[i]);
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 153b300621eb..d32477315abc 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2391,7 +2391,7 @@ smb2_is_status_io_timeout(char *buf)
 		return false;
 }
 
-static void
+static bool
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
@@ -2400,7 +2400,7 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 	struct cifs_tcon *tcon;
 
 	if (shdr->Status != STATUS_NETWORK_NAME_DELETED)
-		return;
+		return false;
 
 	/* If server is a channel, select the primary channel */
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -2415,11 +2415,13 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 				spin_unlock(&cifs_tcp_ses_lock);
 				pr_warn_once("Server share %s deleted.\n",
 					     tcon->tree_name);
-				return;
+				return true;
 			}
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
+
+	return false;
 }
 
 static int
-- 
2.34.1

