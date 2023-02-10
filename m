Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4956CC05027
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Feb 2023 15:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjBJPqf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Feb 2023 10:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBJPqe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Feb 2023 10:46:34 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5875FDA
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 07:46:34 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so5884833pjw.2
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 07:46:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDMPiyTXzM2WIy53/gEJDzOyuyMwr9yxPO/f5ylbAL8=;
        b=PZHIzO3glPSvEYfu/+LDY4+9uKIoPPub9YSjwFMif2rO0T7AqftvXP4mipvnKX0+Y6
         DTaR1Kq+PBVpDdmGPTfTcwyfHLPF1QAXmmobiOuKAF4eeR/mcTC2IgIV0NzzPUuP1pou
         PC7uC18LqYdOGk65Jqz1LxTJTX+fMRSMRM3jZZzG4a9zqgeV31pEOraehldvqbrJ0Mtd
         DqObcCZBjQDcZLuFpd80nd/Q2krTU4MwifkX48PsdqdgZtp6M3tEqpa9USs1jUCw/Svb
         Vy0BnK+NByxHAEdvsMtagz1JnonvyQlEdT6RjEjBFfkPfDGS0V5sZxnMMte+GSBFJqdf
         MIbw==
X-Gm-Message-State: AO0yUKXU4ZHjs7qLkvfGIUNopxld+vhJPcG8JJLKxgn2FdvQ5Ooa59N+
        nfaPwzYYcTa+sSWPEDf0tz54k34izYE=
X-Google-Smtp-Source: AK7set+2xl35CuZgMem13zMKFDox3x+wq7LnzZG4fTJb0G/j/H0Z1JYRa4mM5FZ3EmBUchdQqw2FeQ==
X-Received: by 2002:a17:903:1c2:b0:196:6577:5a96 with SMTP id e2-20020a17090301c200b0019665775a96mr19327466plh.30.1676043993190;
        Fri, 10 Feb 2023 07:46:33 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0019a7c890c5asm488756pls.263.2023.02.10.07.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:46:32 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length
Date:   Sat, 11 Feb 2023 00:46:20 +0900
Message-Id: <20230210154620.12645-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd allowed the actual frame length to be smaller than the rfc1002
length. If allowed, it is possible to allocates a large amount of memory
that can be limited by credit management and can eventually cause memory
exhaustion problem. This patch do not allow it except SMB2 Negotiate
request which will be validated when message handling proceeds.
Also, Allow a message that padded to 8byte boundary.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - Allow a message that padded to 8byte boundary.

 fs/ksmbd/smb2misc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index a717aa9b4af8..fbdde426dd01 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 			goto validate_credit;
 
 		/*
-		 * windows client also pad up to 8 bytes when compounding.
-		 * If pad is longer than eight bytes, log the server behavior
-		 * (once), since may indicate a problem but allow it and
-		 * continue since the frame is parseable.
+		 * SMB2 NEGOTIATE request will be validated when message
+		 * handling proceeds.
 		 */
-		if (clc_len < len) {
-			ksmbd_debug(SMB,
-				    "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
-				    len, clc_len, command,
-				    le64_to_cpu(hdr->MessageId));
+		if (command == SMB2_NEGOTIATE_HE)
+			goto validate_credit;
+
+		/*
+		 * Allow a message that padded to 8byte boundary.
+		 */
+		if (clc_len < len && (len - clc_len) < 8)
 			goto validate_credit;
-		}
 
-		ksmbd_debug(SMB,
+		pr_err_ratelimited(
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
 			    le64_to_cpu(hdr->MessageId));
-- 
2.25.1

