Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D12248A0
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884149; cv=none; b=HduKyVvLhn825cx/4S/fZ9QMFazxFLsJBO7WmqEG1/dKfZt1EAmGr00nmKIWN12Z0NhgpU7wAYctqPUMQ0tgLIts9nktgTVvibAMk/fWFmI+PMAogRdq4I7vpP/DMJRQML/1EZdHfe+7XRTxiZEbRcPgrqYWuWUCumByqjjFF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884149; c=relaxed/simple;
	bh=aFIrwscsM3f/OsknSi22nX6hN0mT+0iDN+pEtxzjGRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWCqz6tLR5wwdykUQglm5lmc/yOAgg1rmet0H5aCma0yDfMpMwHOkUrn4BcagxAB3vo/Mn6mJSBWUlkUx41mMchubSoGX28Tpv1jFstGPxkbJGxEbeN9eL4Ybi+QCOUWkVc1DV8T9iuu39KpUT3OH6BhpkxWqLRviUssTeujvJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J35FzHre; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J35FzHre"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23228b9d684so49378845ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 10:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884147; x=1749488947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbeMydlpBKnJriiyQjoZXbaCDjFrTu85VLS3ZQbl5Os=;
        b=J35FzHrek0jhfZBiIf6bAHF8AOmjkeHyxfTuDfnn0DPLrv/uEqufugpfTRR3qp6FgX
         1Lq4KxozG2lYQMRywf6tO+U1+8jAkiOV1WlmVUStFyTwBKI2OWdZ4tN2l45nNbq9Sz4F
         qtWQWYL9J3avi/3b1SSDZ03jaMDDTPme2kXleowWCdtksKanNm4R7HQyUiRV9t+Zhppy
         mjpf4rRCRwy4uhioWZ45tgojpHSaequoMezxondbNrGGE6zKtGf9uTuGlifCSwRiUXo+
         eEntiXqRvnvzbgIHWXWlfB4/Wb/qB8qSY7HfsmoQ6NWBeQI3LUt2B43oVRW9B8aPcHOe
         yLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884147; x=1749488947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbeMydlpBKnJriiyQjoZXbaCDjFrTu85VLS3ZQbl5Os=;
        b=DVUJAXbVFJwVE86CeAYuh5+RXj5rk0eeolEYyZ5mBDtEANugPhU1sthEtUKSOMCLwF
         /X61kDT997awQ2QwWHgVbZFtV8JUzeiZJMASZHZ+KKpxyMylIOhQnDFxHq/Gm+xqmWJJ
         s+FIPcHdX148LfZ5TR+z3rHf2bFFglG8GQckyvYHVSck2y1Hzbdf7mKtlfXj7/BC0sZx
         w9DOlozNMfDdlxmm9emEtUfdxzcmRcMi6pLDocR2qI+S0PxRtfs3SjeHY5hB7KLWvsLL
         vYkSqKtqCwQasApb9uXi3uUDTiUKmThCUaei6b8sIVPI15di8J4CPrs2T/Vx4fc+xxUe
         c8UA==
X-Gm-Message-State: AOJu0Ywprk/N7d5ol4fvlW0CLE1VWsAwgz9EQpP3kwT/u6fUczZyLApz
	PH68CaP4PWuFyEbNoGDIIMiNSVULAB1uqRHGnq7h6TBFbv9nkaAlhyLGsiJfIQ==
X-Gm-Gg: ASbGncuUU+sj1r/vnEDzN7MjfW6FdznXVFkN0lsQ3Y+1zCNsQhq7NSZ9q/yJrOHGpu8
	pPUiJTtexHc4TqdBv3ooDXOFfpyMHNgFCGkrcptaUksav481EbZwDMNSvvhd35vvcSgilOMiEqz
	/pKwWZcVo+Rc5NGGofVKH1lL/+aULKpZ/lAAv1DvCzoUp/NJNIUybASksW4xPr5SNSm5iPjnlfF
	ttOmJxc6SgC54R3VKsUdPWv7jB0bm2eFoFpT3Kdl8TTw6QZXClhAiK6qJ+fIGZV2zuAad9dCkxL
	cUt+0GD+hfOvMXVaCzv1pu0KKKCQw1D0dEcwyLKBVO/5MS4fxrxGHRad0rEy9kmL3Ylf+1ndVAd
	ucPCCGA==
X-Google-Smtp-Source: AGHT+IGfNTvYUgj97FGT/L1fwaVdfyxxOmsHHVcoj7bt59ulZOx1yeAowJ+i8tBWIs1MhDw8gIPt1w==
X-Received: by 2002:a17:902:dacd:b0:234:8ac5:3f50 with SMTP id d9443c01a7336-235395a1964mr190882675ad.33.1748884146835;
        Mon, 02 Jun 2025 10:09:06 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:06 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 6/6] cifs: do not disable interface polling on failure
Date: Mon,  2 Jun 2025 22:37:17 +0530
Message-ID: <20250602170842.809099-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
References: <20250602170842.809099-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When a server has multichannel enabled, we keep polling the server
for interfaces periodically. However, when this query fails, we
disable the polling. This can be problematic as it takes away the
chance for the server to start advertizing again.

This change reschedules the delayed work, even if the current call
failed. That way, multichannel sessions can recover.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 6 +-----
 fs/smb/client/smb2pdu.c | 9 +++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 024817d40c5f..28bc33496623 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -116,13 +116,9 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	rc = server->ops->query_server_interfaces(xid, tcon, false);
 	free_xid(xid);
 
-	if (rc) {
-		if (rc == -EOPNOTSUPP)
-			return;
-
+	if (rc)
 		cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
 				__func__, rc);
-	}
 
 	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 59a6b86c3786..50c9e7ba15b0 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -423,6 +423,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		free_xid(xid);
 		ses->flags &= ~CIFS_SES_FLAGS_PENDING_QUERY_INTERFACES;
 
+		/* regardless of rc value, setup polling */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+
 		mutex_unlock(&ses->session_mutex);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
@@ -443,11 +447,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		if (ses->chan_max > ses->chan_count &&
 		    ses->iface_count &&
 		    !SERVER_IS_CHAN(server)) {
-			if (ses->chan_count == 1) {
+			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
-				queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-						 (SMB_INTERFACE_POLL_INTERVAL * HZ));
-			}
 
 			cifs_try_adding_channels(ses);
 		}
-- 
2.43.0

