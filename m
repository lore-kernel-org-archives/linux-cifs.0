Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65225C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjJ3LAi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjJ3LAg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0228A2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc3c51f830so6434185ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663634; x=1699268434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICzSLXeoD0ITnkAtcKn86VcbHdl72JGenBPNIvo1dvo=;
        b=m6IanPKRN4m2emMDJX8oODecfM9nLkB3xb2lhjhT31S6mHh7gH+RdTyd32ItGHR1bE
         x0glxhP6erxP1KPlwk4Y5M+D51pOtNGy2R9VfNGNLBVdxPW43VPxg8sw1RJfhVYToAxs
         XPxkoN+rKtqrbhITjFgFArPI5HI9Su23PJIQAuuP0Q7IbvfXy0KE/1scc5irMWa/1/lV
         mHDoCwS+nVtptvup8wSZSBuuFASBz3L50D2TvEWA+xQOeCw7Qxi+/RjDIa/qaQ1VX7LM
         OKK1AwJTbKlpwOrQaFzJrD4ve84WnhLOgtRRva7pv6YXmqI+adgbTOz2SxWKGD79odnd
         bgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663634; x=1699268434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICzSLXeoD0ITnkAtcKn86VcbHdl72JGenBPNIvo1dvo=;
        b=SXx8oRarSsBvDKfqyHXUBMswdaE/fQ6aA/nB0IRY+o4zAl6+7lTW0b4zuGA8Krf7os
         VPAi1xUJLEvWo4UV2nlDEK9Zu6ixtm3NayuH2iZPJ5RuLWyO0npGRS2Qcc9uZmQcEJXN
         4LBZ1pnPNBVzRguyd8Pd6CsNIqXdaWiWPreqaAH7ricR6EkoNYr68rW432OtsnMUaJFy
         OvldBSwFkbIF1qrWk8lIMFCA/4FRSyCxtUWBSAqI1x7H8JJJlilB4BMy5XxeMnqOWNHr
         saTwde0KwiW7FxNGLnr8X7WS/WLMaCjyFEDuvbXOAR0qZkn+py+3pLivWm117eoe+2en
         1r8Q==
X-Gm-Message-State: AOJu0YxhVfytcFtF5+epYJS3CM51xQkZed/LiW7fpBmwtg4DOOrVIXDK
        AXiLf3JrL7ecYgkGtJwRHNNizXw0PuMWBA==
X-Google-Smtp-Source: AGHT+IF9CWeKcH6VfQK1PeONsH0DBSMb6lITp0zU6X0W7S0DhQ+jKu1cRGv4C9+7jhdqWGcKyPG5Zg==
X-Received: by 2002:a17:902:c94d:b0:1cc:4e78:d10f with SMTP id i13-20020a170902c94d00b001cc4e78d10fmr1709194pla.8.1698663633954;
        Mon, 30 Oct 2023 04:00:33 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:33 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 03/14] cifs: reconnect helper should set reconnect for the right channel
Date:   Mon, 30 Oct 2023 11:00:09 +0000
Message-Id: <20231030110020.45627-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

We introduced a helper function to be used by non-cifsd threads to
mark the connection for reconnect. For multichannel, when only
a particular channel needs to be reconnected, this had a bug.

This change fixes that by marking that particular channel
for reconnect.

Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 15a1c86482ed..c993c7a3415a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -160,13 +160,14 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
-	spin_lock(&pserver->srv_lock);
+	/* if we need to signal just this channel */
 	if (!all_channels) {
-		pserver->tcpStatus = CifsNeedReconnect;
-		spin_unlock(&pserver->srv_lock);
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsExiting)
+			server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&server->srv_lock);
 		return;
 	}
-	spin_unlock(&pserver->srv_lock);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
-- 
2.34.1

