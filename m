Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BF2C636CC
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Feb 2023 09:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjBHJlu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Feb 2023 04:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjBHJln (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Feb 2023 04:41:43 -0500
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83D042DD7
        for <linux-cifs@vger.kernel.org>; Wed,  8 Feb 2023 01:41:16 -0800 (PST)
Received: by mail-pj1-f52.google.com with SMTP id bg10-20020a17090b0d8a00b00230c7f312d4so1718491pjb.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Feb 2023 01:41:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsPBh0g0XI+2QXoTdEsVJFe9AVczky+dTLFIfFOENx4=;
        b=MSIlSxVC3LqhDk8tbuKgL5Cw/FrqKTr0OaW6R5MOv5tf0wiIUFDjad3mdzo9DZPIOA
         uMFcDz6DySnhzbOncV73+2yRB8jMHzhsosLe08lDMBV3S2UGZFO2HFCLTfCkgMOR7C4/
         arOJ00+9i+AqpzyxE6/9zX8kE14y9sSqnmhhzgE0JQOTDRmRggBmsisNs8kVukD1mM+w
         WV8bDQlzX/WLNy9e4+2H7w6bdTiXNLpzRMNLzMAirKK0WO5oLL7IZOac+DbxBTBk543n
         HL7n3go7plCjjExfl8QjktsplHF8D1C6LxlEogMAmyUDaXHEIy6ejVXQ6BNdw93zoIrB
         zitQ==
X-Gm-Message-State: AO0yUKUxE8VziSKjCzY5KQk6hrrdKdFHqeV3kJNhsOFBC55snLoYTElS
        p23L3LHcePpt77aVJEuigUA+EHVVV88=
X-Google-Smtp-Source: AK7set/p/s9pHVaYjKVSDF/AkWldhJyEcQkoh3g0jQInUiuAppv1czU750SBJNomKAxYPvDCvPwCPw==
X-Received: by 2002:a17:902:c944:b0:196:4652:7cff with SMTP id i4-20020a170902c94400b0019646527cffmr7325035pla.11.1675849275009;
        Wed, 08 Feb 2023 01:41:15 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902b49100b001993411d66bsm1042976plr.272.2023.02.08.01.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 01:41:14 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: do not allow the actual frame length to be smaller than the rfc10024 length
Date:   Wed,  8 Feb 2023 18:41:04 +0900
Message-Id: <20230208094104.10766-1-linkinjeon@kernel.org>
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
Also, cifs client pad smb2 tree connect to 2bytes.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index a717aa9b4af8..fc44f08b5939 100644
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
-			goto validate_credit;
-		}
+		if (command == SMB2_NEGOTIATE_HE)
+			goto validate_credit;
+
+		/*
+		 * cifs client pads smb2 tree connect to 2 bytes.
+		 */
+		if (clc_len + 2 == len)
+			goto validate_credit;
 
-		ksmbd_debug(SMB,
+		pr_err_ratelimited(
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
 			    le64_to_cpu(hdr->MessageId));
-- 
2.25.1

