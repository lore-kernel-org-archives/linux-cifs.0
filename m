Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC26C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 06:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 441982087C
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 06:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R6GVxPvg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfCNGR1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 02:17:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42264 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfCNGR1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 02:17:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id b2so3268991pgl.9;
        Wed, 13 Mar 2019 23:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uQ5tnxfdXg1r8T/NAFOm0Y6O6vHbO4Hx3V9MG42DhDg=;
        b=R6GVxPvgxaw2yFfky03ukySwHz4beQrZ6POmxkBnuQ9YwH3+4VoARDsOdbg9BRxrKK
         CqMwPSdaWipQZFFeu1G4/CX+V+sFB1tofFka9aGbUfHluUoxd78NpJyPczhGmbgpxVQM
         Y7X9+5Ljl+0wquvT16rUPHL7HCGLrY4VaYF3MXKUWAto1x9iDER67IMChTNw2Nn0mcyT
         qi4V4ihZT1/kyVQHCB1W9qk++ROdu4TE8CAdrjTA76NEG8O36oExhANBdXzSW+khUMdq
         vpo2FCjW/ScEogVP2UNyvSqp7dgONA5LBv4U59EJr37ClCCahurusUKUdenUSmLJz1lT
         KOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uQ5tnxfdXg1r8T/NAFOm0Y6O6vHbO4Hx3V9MG42DhDg=;
        b=kviPfB0APbbwqFUegMY1U+iSrdF0jX4++7yUlGPamfdi16ucmP+VcBg7YiweraqAS4
         wvoVk755zv4z/2/XUDhy54Bc0p9/O4UpURz9U5n5vQDi1HJpHf1NY/ojmJ+1NZjPTj+d
         AGLvIvumsY/opj/rn1Lqa8DZqv9iEtcJQgGSEm8L9ZRc7uz8hGFXyAcvhXKFiupCItIb
         RkLLueZtmSE5omW+pHwYd8wyQW0ZzN9vEbAwNQTpgcnmU1DIfmh2Ffa7qtN3shpaI0Gs
         6YpyUhH9lp2YBzoF3BnCuQAT191Z+hwFHEckE4P9dSps+5GzT3tJJ+3n4BbnBNAAQZyo
         14uA==
X-Gm-Message-State: APjAAAUGVMHNd9EZTAayLWRuyJHP/9UibBJWW3LlBscV8NuD57ZCeSrF
        TXQx1lXh+98ynw2B4ZIGf2N/RYsE
X-Google-Smtp-Source: APXvYqwADvqf1uJTeu0+pQsXQxNHYKu0+X6A2lgmrJ/Eujsf9YfZ4rRK26L4nZQAxlGukTf84fM7eQ==
X-Received: by 2002:a17:902:bf05:: with SMTP id bi5mr22906286plb.252.1552544246955;
        Wed, 13 Mar 2019 23:17:26 -0700 (PDT)
Received: from localhost.localdomain ([175.223.23.218])
        by smtp.gmail.com with ESMTPSA id b6sm21895920pfo.27.2019.03.13.23.17.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 23:17:26 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/2] cifs: remove unused status severity defines
Date:   Thu, 14 Mar 2019 15:17:15 +0900
Message-Id: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

STATUS_SEVERITY_* do not appear to be used by anyone, so
drop them. Besides, the name of __constant_cpu_to_le32()
is misspelled there: __constanst_cpu_to_le32().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 fs/cifs/smb2status.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/cifs/smb2status.h b/fs/cifs/smb2status.h
index 3d5f62150de4..e9da9c6da277 100644
--- a/fs/cifs/smb2status.h
+++ b/fs/cifs/smb2status.h
@@ -29,11 +29,6 @@
  *  C is set if "customer defined" error, N bit is reserved and MBZ
  */
 
-#define STATUS_SEVERITY_SUCCESS __constant_cpu_to_le32(0x0000)
-#define STATUS_SEVERITY_INFORMATIONAL __constanst_cpu_to_le32(0x0001)
-#define STATUS_SEVERITY_WARNING __constanst_cpu_to_le32(0x0002)
-#define STATUS_SEVERITY_ERROR __constanst_cpu_to_le32(0x0003)
-
 struct ntstatus {
 	/* Facility is the high 12 bits of the following field */
 	__le32 Facility; /* low 2 bits Severity, next is Customer, then rsrvd */
-- 
2.21.0

