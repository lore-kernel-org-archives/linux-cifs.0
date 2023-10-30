Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F46C4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjJ3LA4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjJ3LAz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1211C0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c8a1541232so38205065ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663652; x=1699268452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2rHcIvsbGvPqhqUsa3jjoReaW4WV1bGbaJkMyFwPlQ=;
        b=icJphQnDErani1wQ/1G+/UAKR5uXxG3zCgn6sVUjXdooLq4Lanol74y1rsz8nQuonp
         WqQlTANH1p6Ci2/Pj4uSb0MsTTu1ceqKxg5agwG0bkX+/Q/kWx+bTYHylNOqXhNlYUR/
         n+983mPhFGr4xPuEH5n+8KMcIOoDOB60ecaH8qq326fDefZiDrTWqTQwvkq+XW15w9RD
         4DaCkdcHCqPCAoSFmLXCR2zIx0udEJfhehMsQ3Ci93wQVr0XQFneeU+nrJKpB255UWEH
         2V/lPgqeBdJsxc0AqMw7yUP63BMZ9Xf4IJ7kSZuuAw+fnsA5MWcLP4WLRhX8YfGf7Rbf
         JXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663652; x=1699268452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2rHcIvsbGvPqhqUsa3jjoReaW4WV1bGbaJkMyFwPlQ=;
        b=NvBAPc2Fom6+XAS5HODQylPRYOGGIwHwHMr0LBDP+b4nsN8308qrvt3QV/gjA7Ba+G
         GyipgaugLT1ygTI4B7rsxPjfREx3FhhOurVH1n2BEnT5QAypIGoZx4vto0J9YA99Q6TC
         MfExKPbzqXtjhBdPzh99UtZNBbC0+ifeinERVPv7UPi8KGojN7/UfpZ4EnWuTn0ArOFf
         pS/65SV033bLoCezAUwXB2PYrQ7m5N3xo57kRvMonQhbU7EpqJuOwzQZq5w4UwNUONOH
         ltQo3ql/i8Py/fi0UmmNTU1vkkZUWq/f3zupesLZqpsR/YLbADFZr/d7CrQTwqKSqFX6
         EeXg==
X-Gm-Message-State: AOJu0YzI9vOAZ+hJg5717zH+HRAsET5qaGWkaaQlc3+h2HFhXvrZC3mu
        I18DbqUjXn6TMy3MldXAWf1kKq8/NjEaRg==
X-Google-Smtp-Source: AGHT+IF4BAh+X7Yt7GNoJGm6Tc4Xcv1ztPi+0caPGJZ2W5OTgJFZlbV38qk5vqG8WbuBk3CKE3YBEw==
X-Received: by 2002:a17:902:ecce:b0:1cc:59a1:79c6 with SMTP id a14-20020a170902ecce00b001cc59a179c6mr672446plh.18.1698663652338;
        Mon, 30 Oct 2023 04:00:52 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:51 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 10/14] cifs: reconnect work should have reference on server struct
Date:   Mon, 30 Oct 2023 11:00:16 +0000
Message-Id: <20231030110020.45627-10-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

The delayed work for reconnect takes server struct
as a parameter. But it does so without holding a ref
to it. Normally, this may not show a problem as
the reconnect work is only cancelled on umount.

However, since we now plan to support scaling down of
channels, and the scale down can happen from reconnect
work itself, we need to fix it.

This change takes a reference on the server struct
before it is passed to the delayed work. And drops
the reference in the delayed work itself. Or if
the delayed work is successfully cancelled, by the
process that cancels it.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 27 +++++++++++++++++++++------
 fs/smb/client/smb2pdu.c | 23 +++++++++++++----------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 184075da5c6e..e71aa33bf026 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -389,7 +389,13 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 			spin_unlock(&server->srv_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
-			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+
+			/* increase ref count which reconnect work will drop */
+			spin_lock(&cifs_tcp_ses_lock);
+			server->srv_count++;
+			spin_unlock(&cifs_tcp_ses_lock);
+			if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+				cifs_put_tcp_session(server, false);
 		}
 	} while (server->tcpStatus == CifsNeedReconnect);
 
@@ -519,7 +525,13 @@ static int reconnect_dfs_server(struct TCP_Server_Info *server)
 		spin_unlock(&server->srv_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+
+		/* increase ref count which reconnect work will drop */
+		spin_lock(&cifs_tcp_ses_lock);
+		server->srv_count++;
+		spin_unlock(&cifs_tcp_ses_lock);
+		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+			cifs_put_tcp_session(server, false);
 	} while (server->tcpStatus == CifsNeedReconnect);
 
 	mutex_lock(&server->refpath_lock);
@@ -1601,16 +1613,19 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cancel_delayed_work_sync(&server->echo);
 
-	if (from_reconnect)
+	if (from_reconnect) {
 		/*
 		 * Avoid deadlock here: reconnect work calls
 		 * cifs_put_tcp_session() at its end. Need to be sure
 		 * that reconnect work does nothing with server pointer after
 		 * that step.
 		 */
-		cancel_delayed_work(&server->reconnect);
-	else
-		cancel_delayed_work_sync(&server->reconnect);
+		if (cancel_delayed_work(&server->reconnect))
+			cifs_put_tcp_session(server, from_reconnect);
+	} else {
+		if (cancel_delayed_work_sync(&server->reconnect))
+			cifs_put_tcp_session(server, from_reconnect);
+	}
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c75a80bb6d9e..b7665155f4e2 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3852,12 +3852,6 @@ void smb2_reconnect_server(struct work_struct *work)
 		}
 		spin_unlock(&ses->chan_lock);
 	}
-	/*
-	 * Get the reference to server struct to be sure that the last call of
-	 * cifs_put_tcon() in the loop below won't release the server pointer.
-	 */
-	if (tcon_exist || ses_exist)
-		server->srv_count++;
 
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -3905,13 +3899,17 @@ void smb2_reconnect_server(struct work_struct *work)
 
 done:
 	cifs_dbg(FYI, "Reconnecting tcons and channels finished\n");
-	if (resched)
+	if (resched) {
 		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
+		mutex_unlock(&pserver->reconnect_mutex);
+
+		/* no need to put tcp session as we're retrying */
+		return;
+	}
 	mutex_unlock(&pserver->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-	if (tcon_exist || ses_exist)
-		cifs_put_tcp_session(server, 1);
+	cifs_put_tcp_session(server, true);
 }
 
 int
@@ -3931,7 +3929,12 @@ SMB2_echo(struct TCP_Server_Info *server)
 	    server->ops->need_neg(server)) {
 		spin_unlock(&server->srv_lock);
 		/* No need to send echo on newly established connections */
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		spin_lock(&cifs_tcp_ses_lock);
+		server->srv_count++;
+		spin_unlock(&cifs_tcp_ses_lock);
+		if (mod_delayed_work(cifsiod_wq, &server->reconnect, 0))
+			cifs_put_tcp_session(server, false);
+
 		return rc;
 	}
 	spin_unlock(&server->srv_lock);
-- 
2.34.1

