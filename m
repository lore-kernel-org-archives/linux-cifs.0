Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682A2C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4106E60273
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhJLBWT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:22:19 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:40946 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhJLBWQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 21:22:16 -0400
Received: by mail-pj1-f43.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so670977pjb.5
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o+NfP/luJfuczRoYwORyFX75axNITZEKX22B5VbtgP8=;
        b=rbVHY4x/K8L+oH1MGC7keqt4COFLz9PhSJFmfPPWodOte9VryWkTUq192TFXAyAqom
         Qjp3Y9n6XTLgM4VsKwtGKt5NiApeRTmr183RnB0gjNwWFJctopchOxNU+DawxSPQiinn
         HDkunsLvvWsBOeGUYEHwSQST+idtj0NOVYUg2mFORei0Uf/Zfhdku0aEvqOOXvUZ4kI7
         ZaQ+LJ7hXvaUEqJhQsA3OniFfs+z0kflE7E6/oZ1xGSiyiaekbhvY8XBVL8TfBIjkcje
         ik/rK0TK8FacilYj9BREtMHcJi6iFwj+pPwoSisgky20JoY/MSyzbvlPj3aRY6tNjbek
         sOzg==
X-Gm-Message-State: AOAM532AUfPElJG7EFujWEdZY87Ol/tLGknEpmRnQiMGQfl4hk8+UVMz
        eN50+E0Qyanu08W7nXQ6duw9fcLtg9tR9w==
X-Google-Smtp-Source: ABdhPJza3Dee+27tJmEbY517eG4qcRbYe38Qq3MDdZieobYzeMbjGfgaBkw1ZlnsnIuHnxWxXZf71A==
X-Received: by 2002:a17:902:8bc4:b029:12b:8470:e29e with SMTP id r4-20020a1709028bc4b029012b8470e29emr27295836plo.2.1634001614264;
        Mon, 11 Oct 2021 18:20:14 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c24sm10145386pgj.63.2021.10.11.18.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 18:20:13 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix potencial 32bit overflow from data area check in smb2_write
Date:   Tue, 12 Oct 2021 10:20:04 +0900
Message-Id: <20211012012006.5037-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DataOffset and Length validation can be potencial 32bit overflow.
This patch fix it.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 79b296abe04e..7b4689f2df49 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6197,8 +6197,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 	    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 		data_buf = (char *)&req->Buffer[0];
 	} else {
-		if ((le16_to_cpu(req->DataOffset) > get_rfc1002_len(req)) ||
-		    (le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req))) {
+		if ((u64)le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req)) {
 			pr_err("invalid write data offset %u, smb_len %u\n",
 			       le16_to_cpu(req->DataOffset),
 			       get_rfc1002_len(req));
@@ -6356,8 +6355,7 @@ int smb2_write(struct ksmbd_work *work)
 		    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 			data_buf = (char *)&req->Buffer[0];
 		} else {
-			if ((le16_to_cpu(req->DataOffset) > get_rfc1002_len(req)) ||
-			    (le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req))) {
+			if ((u64)le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req)) {
 				pr_err("invalid write data offset %u, smb_len %u\n",
 				       le16_to_cpu(req->DataOffset),
 				       get_rfc1002_len(req));
-- 
2.25.1

