Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4810A3B
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIK8UF43"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3ba14203a34so6711800b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703849423; x=1704454223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q8Y+X8O65zr99OkgeK9rcPFY+oc6y4N3f60NZR3QHhA=;
        b=QIK8UF43K1nuJWJYBkblAB7YNu1zLHC6B4QCvAhgtxdYzugmNCqwDB0OeNMHpl+M8r
         rqw/s4RmA29rnE4ay587NObs4M93zila86EuCZu2wpm2NdBSEUv1TOHenj56lNRiTd3d
         JY0vyOAdRJKJ2HPqBOCHoHKrWrIVP7MEPVlkwlek7RwMbsJKtkWdLCql45yDIRM/GwWx
         IuKHQnYZQZyOaXOmeuFf77DrR+h7s29qLiZF3Pzhw+IpzGkrc2s/suN1/ya9/ORqjg8+
         oaJmMjkA8rrsRB8oPisBK4D/d+S4IAPEMxLyO+kHB2+c1Xhov7uyIJQ9LeTvPS43hSZ5
         MEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703849423; x=1704454223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8Y+X8O65zr99OkgeK9rcPFY+oc6y4N3f60NZR3QHhA=;
        b=s6r15My1szdTfDxqN6wlUAiCbhamn3RvRJMD46TCeIj8bYoUshsQXknARrxuToHTVJ
         K+q+2Tv9bO6AwSLoIWScD1LXCXwoEXi4CaEiFOzbwGXzD3bTn2Oh7wGA9GCj1kmXXLVK
         aPO/B7Qp8vLOtN23IsrRXaTk+MO6RFlA0qfgyrw5zSY8REVS8pSczZmHBzMDMIXwNNVb
         jAp8ikS7EAydT36G39wLSC33sm8m4JPCyAo6cS0wkAKJUg7rLv8PjwsItC4l8nVynd/B
         IAfz8Hcj4UUr5hoP2x4HzqnLhqXju0n/klrjd9jkxd+NDVBRB/wTxnrHktTiGFE1a0Ha
         t4wA==
X-Gm-Message-State: AOJu0YxJsmSWXUrv7XflVMIlSem1hgydNcuP5qy94UmdebyIaI1etiQ2
	UhlAukwVQUHqSfdQcb4udWM=
X-Google-Smtp-Source: AGHT+IFEQ37WPGPzWu+ZukKWeHH0B0HSDI3AXJrS3JthT93Ds3n1TjToSyZqW3+1dqwrD2rGBwXuiw==
X-Received: by 2002:a05:6808:140e:b0:3b9:e566:d4db with SMTP id w14-20020a056808140e00b003b9e566d4dbmr17833252oiv.78.1703849422978;
        Fri, 29 Dec 2023 03:30:22 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id p64-20020a625b43000000b006da11b8aa55sm3713279pfb.121.2023.12.29.03.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 03:30:22 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.com,
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: after disabling multichannel, mark tcon for reconnect
Date: Fri, 29 Dec 2023 11:30:07 +0000
Message-Id: <20231229113007.39009-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Once the server disables multichannel for an active multichannel
session, on the following reconnect, the client would reduce
the number of channels to 1. However, it could be the case that
the tree connect was active on one of these disabled channels.
This results in an unrecoverable state.

This change fixes that by making sure that whenever a channel
is being terminated, the session and tcon are marked for
reconnect too. This could mean a few redundant tree connect
calls to the server, but considering that this is not a frequent
event, we should be okay.

Fixes: ee1d21794e55 ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 44bfdd88a906..8b7cffba1ad5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -216,17 +216,21 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
+	/*
+	 * if the server has been marked for termination, there is a
+	 * chance that the remaining channels all need reconnect. To be
+	 * on the safer side, mark the session and trees for reconnect
+	 * for this scenario. This might cause a few redundant session
+	 * setup and tree connect requests, but it is better than not doing
+	 * a tree connect when needed, and all following requests failing
+	 */
+	if (server->terminate) {
+		mark_smb_session = true;
+		server = pserver;
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
-		/*
-		 * if channel has been marked for termination, nothing to do
-		 * for the channel. in fact, we cannot find the channel for the
-		 * server. So safe to exit here
-		 */
-		if (server->terminate)
-			break;
-
 		/* check if iface is still active */
 		if (!cifs_chan_is_iface_active(ses, server))
 			cifs_chan_update_iface(ses, server);
-- 
2.34.1

