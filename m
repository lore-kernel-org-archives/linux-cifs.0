Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AAEC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 04:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767B660FDA
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Oct 2021 04:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhJOEsJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Oct 2021 00:48:09 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34452 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhJOEsI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Oct 2021 00:48:08 -0400
Received: by mail-pl1-f171.google.com with SMTP id g5so5659269plg.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 21:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nB2/f2Bq9mvMFtcHgn/LPMxNOoIYF+8+gz3V+7mMCn4=;
        b=af63wDgebrgJUgBsBJCRWMtdffB9bw4EbNv+wun3s8myQ5ftZjojBnx/IKbxRi+Cbk
         dKZmevF4RZDiJdUN2c51a92p++nay7xKW/H8vIpsrNx8vQme5AyWlfITZo0bS+2CSwCK
         fMGIIv9ZTPNdMhQ6Kp2f6ZGWkZfWH97GzHnwGwRt6m0wU6kWy7XVnfzKiLhUPW3tRcIY
         JYc5s+UYTHUaA3mM2dafBdvhMc6ean0xHgA83ot7ZVZIxqgosijTKwdvv0aBw3PuM8bI
         Jd9n5/DonN7R96Y+Zxv7Qn0geuBF/a0HmAEj6OncNvVWfm8ME0FBm2WCDrekct4SVOfE
         OQcg==
X-Gm-Message-State: AOAM531DRUBls3HdkW6aNMbmCsKLE0VuiIEQdqMmVi9u4K7Xp6i2UZef
        EwncfCv2pwcUxGGydXqM/+tAarqC+yWQYg==
X-Google-Smtp-Source: ABdhPJyu7IVBW54QO8KLpFeQwovrx1TSDy2nke+WmMet0Szszu8Veilwmo86PLr/BAfcg4PqZrxbpw==
X-Received: by 2002:a17:902:8f90:b0:13e:a44e:2d3c with SMTP id z16-20020a1709028f9000b0013ea44e2d3cmr9127332plo.85.1634273162733;
        Thu, 14 Oct 2021 21:46:02 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id ls7sm4105243pjb.16.2021.10.14.21.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 21:46:02 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
Subject: [PATCH v2] ksmbd: validate credit charge after validating SMB2 PDU body size
Date:   Fri, 15 Oct 2021 13:45:53 +0900
Message-Id: <20211015044553.70582-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ralph Boehme <slow@samba.org>

smb2_validate_credit_charge() accesses fields in the SMB2 PDU body,
but until smb2_calc_size() is called the PDU has not yet been verified
to be large enough to access the PDU dynamic part length field.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 v2:
  - add goto statement not to skip to validate credit charge.
  - fix conflict with credit management patch.

 fs/ksmbd/smb2misc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index e7e441c8f050..030ca57c3784 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -400,26 +400,20 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		}
 	}
 
-	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(work->conn, hdr)) {
-		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
-		return 1;
-	}
-
 	if (smb2_calc_size(hdr, &clc_len))
 		return 1;
 
 	if (len != clc_len) {
 		/* client can return one byte more due to implied bcc[0] */
 		if (clc_len == len + 1)
-			return 0;
+			goto validate_credit;
 
 		/*
 		 * Some windows servers (win2016) will pad also the final
 		 * PDU in a compound to 8 bytes.
 		 */
 		if (ALIGN(clc_len, 8) == len)
-			return 0;
+			goto validate_credit;
 
 		/*
 		 * windows client also pad up to 8 bytes when compounding.
@@ -432,7 +426,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 				    "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
 				    len, clc_len, command,
 				    le64_to_cpu(hdr->MessageId));
-			return 0;
+			goto validate_credit;
 		}
 
 		ksmbd_debug(SMB,
@@ -443,6 +437,13 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
+validate_credit:
+	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
+	    smb2_validate_credit_charge(work->conn, hdr)) {
+		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

