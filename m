Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182CDC432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57AD2068F
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zi85fZsT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUTfW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:35:22 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45151 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTfW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 14:35:22 -0500
Received: by mail-pg1-f196.google.com with SMTP id k1so2103657pgg.12
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 11:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=A4i9vGteXzznrRtlUFwaID48FmlFRXabJu6tjiCk2aY=;
        b=Zi85fZsTYNRkBlyNWe04DRZpfqLMFJBx8zAN/FYeCtHFpMp0K1BtVxrF1Z0msI/q6h
         HnA6ZDqFaD6PldUBfXXa9W0t1J/YdLYYsbeWvP963Z4MoQuwRqlJM+DDE0m8Ov/9Z8MK
         cYvG7d4AEPTIE0UAcZRZyxbPU9rPzlPCfusJkAFgkJ83whr1bawPI/WRF4WwH+TTe+zD
         Z1BHx4ENsQREd0r+rUJTJ5KBMToj4mVWIlzATqfGJyNAMlWR+z18BGuwbaKnLCsLqezj
         6tlA/XoWrU1UxUEayqaYx1GU5SwXpmn8zoKkDkn0fwMSDEXoCZhhyllXvTLvguF0nelp
         hrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=A4i9vGteXzznrRtlUFwaID48FmlFRXabJu6tjiCk2aY=;
        b=GoD31rgKeZC3X/r6WKP8IDtw8a5+K21a2XtqdNZnXjYLkyOXk/027DMPgFvGbHPgj+
         /DWmWyLi8GGlFvEnJZQptrrA9DJdW7utW4dTenEhdtSGFZKgHgrQXxO41GxYhEWjqSRe
         F/pd5JR0v8sNjrLN7sv78uF8/HOtnF1q42g28LeSW8MvAWfY6vxgHweLESAyO9C9uFFI
         4rPeRaltWZofU0hpLrwOrnWj1oqmBDOMHGBmCIRmfqyG7zcIqrFOgMm+kIkD+8RXcmCm
         VDOOHECd7S+F1KsnsPrSdeje7dRSaD/MHzudWxRW9d2gkWzoIV58PGvF1j7U4VkBhMBE
         lXdw==
X-Gm-Message-State: APjAAAXsl+Qi1meQK4nDcMCd5URsFehCc5ycEdFiQb5vDEup03OKttLi
        QHHeMWp7vstY0ZRqrXpEEg==
X-Google-Smtp-Source: APXvYqxdHvU6rmC3Qg/jCMTTh8Zw9JzR3ePuiVovFjaSsTtgxYDPrSWLVcV3/dOz5WqYqpmKNk4SyQ==
X-Received: by 2002:a63:750f:: with SMTP id q15mr11496514pgc.422.1574364921859;
        Thu, 21 Nov 2019 11:35:21 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id h185sm3972216pgc.87.2019.11.21.11.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 11:35:21 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 2/3] CIFS: Fix NULL pointer dereference in mid callback
Date:   Thu, 21 Nov 2019 11:35:13 -0800
Message-Id: <20191121193514.3086-2-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191121193514.3086-1-pshilov@microsoft.com>
References: <20191121193514.3086-1-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a race between a system call processing thread
and the demultiplex thread when mid->resp_buf becomes NULL
and later is being accessed to get credits. It happens when
the 1st thread wakes up before a mid callback is called in
the 2nd one but the mid state has already been set to
MID_RESPONSE_RECEIVED. This causes NULL pointer dereference
in mid callback.

Fix this by saving credits from the response before we
update the mid state and then use this value in the mid
callback rather then accessing a response buffer.

Cc: Stable <stable@vger.kernel.org>
Fixes: ee258d79159afed5 ("CIFS: Move credit processing to mid callbacks for SMB3")
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/connect.c  | 15 +++++++++++++++
 fs/cifs/smb2ops.c  |  8 +-------
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 12b356b3799b..128364af4c37 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1510,6 +1510,7 @@ struct mid_q_entry {
 	struct TCP_Server_Info *server;	/* server corresponding to this mid */
 	__u64 mid;		/* multiplex id */
 	__u16 credits;		/* number of credits consumed by this mid */
+	__u16 credits_received;	/* number of credits from the response */
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
 	unsigned long when_alloc;  /* when mid was created */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8995c03056e3..e63d16d8048a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -897,6 +897,20 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 	spin_unlock(&GlobalMid_Lock);
 }
 
+static unsigned int
+smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+{
+	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buffer;
+
+	/*
+	 * SMB1 does not use credits.
+	 */
+	if (server->vals->header_preamble_size)
+		return 0;
+
+	return le16_to_cpu(shdr->CreditRequest);
+}
+
 static void
 handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	   char *buf, int malformed)
@@ -904,6 +918,7 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	if (server->ops->check_trans2 &&
 	    server->ops->check_trans2(mid, server, buf, malformed))
 		return;
+	mid->credits_received = smb2_get_credits_from_hdr(buf, server);
 	mid->resp_buf = buf;
 	mid->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3bbb65e58dd6..5a13687bf547 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -151,13 +151,7 @@ smb2_get_credits_field(struct TCP_Server_Info *server, const int optype)
 static unsigned int
 smb2_get_credits(struct mid_q_entry *mid)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)mid->resp_buf;
-
-	if (mid->mid_state == MID_RESPONSE_RECEIVED
-	    || mid->mid_state == MID_RESPONSE_MALFORMED)
-		return le16_to_cpu(shdr->CreditRequest);
-
-	return 0;
+	return mid->credits_received;
 }
 
 static int
-- 
2.17.1

