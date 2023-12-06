Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKsNUeqS"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D50C10C7
	for <linux-cifs@vger.kernel.org>; Wed,  6 Dec 2023 08:37:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1d0a5422c80so31623555ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 06 Dec 2023 08:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701880668; x=1702485468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CqN6iCwxlekt6nXhJDS8xRamzh56QwBfoTwI9T9jg0U=;
        b=QKsNUeqSPFSzYmEVmL1ewPWPTUmDptEIm18/UcwgOKjMt7KMOiGfRGiY6uQA22ZjqW
         Kwmr6ZqT1tXSbCR7m2gD0jz7z2+oDpwU4JsAGBT7PYnqc9mgslMluw3BY45uIQ3r0eJq
         UOhXN5dgusgmtdlsDs1qDQgyDyy3ZgHkUz8CYNO+OaiTsMaX/QCnn/nb0V3teRh6GrLo
         UeCq1Yi0HIQZGCslpQBGx5BtVvEspxuJaW3aq5Gdl9n4DoyrKA1mPgnN0Ff5fcvc2Cxw
         k08dQEl0YMnd3w0fdgsoXaKdFEVJN+P8gxjFKNN6RlCVT4qBEOhH5n017HktOQJCZ+FF
         Ak4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701880668; x=1702485468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CqN6iCwxlekt6nXhJDS8xRamzh56QwBfoTwI9T9jg0U=;
        b=KxjqOREEsKBiqQYqXSvQB3X3bNsu6vcF1TMWUuqvMchcq1D4en6rEmvLqPg7fRZGFj
         eBWN1VlKuTcvVa+1dwE6GK+lA6eLV+H3bROcPv27U7lICEzZgt5hJ1odLD0JqZGlVFqf
         rIHXyhB69HEnErRNR2sSWcxH05BtKUZtswjqe+AMnT7t2eBoNhEl+Q6YVEgdt3PWer99
         yDwU89yUzTWg4SWyV0K3e8tsCXNyMMJFh//DdpfII9fPDUENq6JKHfKlqAsRidoezbfw
         xNrwPuQYUavd0PXVgSB85YIKsHo6aD3UIQMTlVSV+oj5WDRXkNbllBEUwqFBxXOfq86v
         XmHQ==
X-Gm-Message-State: AOJu0YzM2q2A1z+f+7AUcyj73ttKGXuCSbYeh8OPUqs5IvNdoV1022Cx
	BizkeeLQ5SXNOkzVAdM72NI/IRUF+hVf2g==
X-Google-Smtp-Source: AGHT+IHm4BXi9IEQncZ7Zs545MBOR78WBe4YkooqysPGpmSUXRBVx4f/P8fa5hW8C8DJfsYuP7ydMQ==
X-Received: by 2002:a17:90b:3b47:b0:286:a93c:5b29 with SMTP id ot7-20020a17090b3b4700b00286a93c5b29mr1236006pjb.12.1701880667618;
        Wed, 06 Dec 2023 08:37:47 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id qj4-20020a17090b28c400b00286be9fb3fdsm31069pjb.40.2023.12.06.08.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:37:47 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm.hsk@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/3] Revert "cifs: reconnect work should have reference on server struct"
Date: Wed,  6 Dec 2023 16:37:37 +0000
Message-Id: <20231206163738.4118-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

This reverts commit 19a4b9d6c372cab6a3b2c9a061a236136fe95274.

This earlier commit was making an assumption that each mod_delayed_work
called for the reconnect work would result in smb2_reconnect_server
being called twice. This assumption turns out to be untrue. So reverting
this change for now.

I will submit a follow-up patch to fix the actual problem in a different
way.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 27 ++++++---------------------
 fs/smb/client/smb2pdu.c | 23 ++++++++++-------------
 2 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index f896f60c924b..e07975173cf4 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -402,13 +402,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-
-			/* increase ref count which reconnect work will drop */
-			spin_lock(&cifs_tcp_ses_lock);
-			server->srv_count++;
-			spin_unlock(&cifs_tcp_ses_lock);
-			if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-				cifs_put_tcp_session(server, false);
+			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -538,13 +532,7 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-
-		/* increase ref count which reconnect work will drop */
-		spin_lock(&cifs_tcp_ses_lock);
-		server->srv_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
-		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-			cifs_put_tcp_session(server, false);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	mutex_lock(&server->refpath_lock);
@@ -1626,19 +1614,16 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cancel_delayed_work_sync(&server->echo);
 
-	if (from_reconnect) {
+	if (from_reconnect)
 		/*
 		 * Avoid deadlock here: reconnect work calls
 		 * cifs_put_tcp_session() at its end. Need to be sure
 		 * that reconnect work does nothing with server pointer after
 		 * that step.
 		 */
-		if (cancel_delayed_work(&server->reconnect))
-			cifs_put_tcp_session(server, from_reconnect);
-	} else {
-		if (cancel_delayed_work_sync(&server->reconnect))
-			cifs_put_tcp_session(server, from_reconnect);
-	}
+		cancel_delayed_work(&server->reconnect);
+	else
+		cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2eb29fa278c3..92b56c37b328 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3954,6 +3954,12 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
+	/*
+	 * Get the reference to server struct to be sure that the last call of
+	 * cifs_put_tcon() in the loop below won't release the server pointer.
+	 */
+	if (tcon_exist || ses_exist)
+		server->srv_count++;
 
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -4001,17 +4007,13 @@ void smb2_reconnect_server(struct work_struct *work)
 
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
-	if (resched) {
+	if (resched)
 		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
-		mutex_unlock(&pserver->reconnect_mutex);
-
-		/* no need to put tcp session as we're retrying */
-		return;
-	}
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	cifs_put_tcp_session(server, true);
+	if (tcon_exist || ses_exist)
+		cifs_put_tcp_session(server, 1);
 }
 
 int
@@ -4031,12 +4033,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		spin_lock(&cifs_tcp_ses_lock);
-		server->srv_count++;
-		spin_unlock(&cifs_tcp_ses_lock);
-		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
-			cifs_put_tcp_session(server, false);
-
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.34.1

