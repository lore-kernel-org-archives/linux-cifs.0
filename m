Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F09C6FD1F
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjCJPpM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbjCJPow (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893D023A42
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:15 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i10so5950731plr.9
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DITosQCzkfmbNoLNERKbLhYxwr5RKQKfmVmxTFr0qlM=;
        b=fhDXYkbPpR/WhvAzNKEiO57qyrraLBy9mzB2e+o2P/UEre/uejzNCcaYp+prqtV/g3
         2TFafkL69ouhIlWrfoAiwYwyEbB9yG3YBPfrUU8yIPhhl6fXwKBaQ3c+pHEU9lO2OF4H
         J3GxU8zmJVHfCD/flI6kIp411x7MsoN4cxnK7sbzQCqs8cixtObNXikJRmaDM8N65GQE
         PTOAhlja/ljduLAzJ6lM78CfEeXwdxr5PqxjN79gP3lAQMAYJ0WQZcWK/J60TrZwsttr
         5lsu7t5eT8eYPkYU4cil+4KcDMAShwycW31ooXCf67Q+l87RdKOb4OHV/Tn4RnI3DV1U
         ebAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DITosQCzkfmbNoLNERKbLhYxwr5RKQKfmVmxTFr0qlM=;
        b=pAt8jGiZz7/j90j7TQ8/AhbqyZrexjD67I07p6J8Ddj+UHtOXcK92mEm6xfBslzC2W
         uuvTHgXe6ry0V/sv1UmzvHIRL6HnDFvmg1/w0l+VwXKIrPJ4wVlF6ENviZeamdyi6+gM
         eM8aRQSBNVOlGLkpIBsDloGZ3hloYbEDV6121rkpoQSLvR7RIofGcXVlkVcb1HbLKogV
         M27VH9z9UfigkyklwqfKkHI6/HSH+c7/seTdnv18EZRuhxOrznH+qGEvErFugrg3CVM3
         /yOtpRvMwXLN42HRySsMhk4HF8XzJLf7VPxO8x+Dj62blS2JVjh9pOXRI7E0Voo0WnyA
         7Kgg==
X-Gm-Message-State: AO0yUKXHQifJjc/myOQ9ei560wOK4JFW/0SB64bMxj7x4gDRsALsOmdD
        vqyfOT9PE1NIcL0IpURCgGOyDHul9+s4pstWeQs=
X-Google-Smtp-Source: AK7set96CyWwwMK9fefl4vMhy7HpIArjbgr5UNnieVgY12d41AD+AC6n6XtqEOa7rhFoUx9M+amrig==
X-Received: by 2002:a17:90b:3885:b0:234:409:9754 with SMTP id mu5-20020a17090b388500b0023404099754mr26129378pjb.45.1678462394723;
        Fri, 10 Mar 2023 07:33:14 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:14 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 04/11] cifs: serialize channel reconnects
Date:   Fri, 10 Mar 2023 15:32:03 +0000
Message-Id: <20230310153211.10982-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Parallel session reconnects are prone to race conditions
that are difficult to avoid cleanly. The changes so far do
ensure that parallel reconnects eventually go through.
But that can take multiple session setups on the same channel.

Avoiding that by serializing the session setups on parallel
channels. In doing so, we should avoid such issues.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/connect.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b103f69432e..4ea1e51c3fa5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -222,6 +222,11 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 		else
 			cifs_chan_set_need_reconnect(ses, server);
 
+		cifs_dbg(FYI, "%s: channel connect bitmaps: 0x%lx 0x%lx\n",
+			 __func__,
+			 ses->chans_need_reconnect,
+			 ses->chans_in_reconnect);
+
 		/* If all channels need reconnect, then tcon needs reconnect */
 		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
 			spin_unlock(&ses->chan_lock);
@@ -3744,6 +3749,11 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	retries = 5;
 
 	spin_lock(&ses->ses_lock);
+	cifs_dbg(FYI, "%s: channel connect bitmaps: 0x%lx 0x%lx\n",
+		 __func__,
+		 ses->chans_need_reconnect,
+		 ses->chans_in_reconnect);
+
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
@@ -3762,11 +3772,11 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	/* another process is in the processs of sess setup */
-	while (cifs_chan_in_reconnect(ses, server)) {
+	while (ses->chans_in_reconnect) {
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 		rc = wait_event_interruptible_timeout(ses->reconnect_q,
-						      (!cifs_chan_in_reconnect(ses, server)),
+						      (!ses->chans_in_reconnect),
 						      HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting sess setup due to a received signal by the process\n",
@@ -3776,8 +3786,8 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		spin_lock(&ses->ses_lock);
 		spin_lock(&ses->chan_lock);
 
-		/* are we still trying to reconnect? */
-		if (!cifs_chan_in_reconnect(ses, server)) {
+		/* did the bitmask change? */
+		if (!ses->chans_in_reconnect) {
 			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			goto check_again;
-- 
2.34.1

