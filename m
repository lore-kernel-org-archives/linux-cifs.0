Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FACC04A68
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jul 2022 13:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiG1NdV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiG1NdU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 09:33:20 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AAD14095
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:20 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id iw1so1817524plb.6
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yEn7DCgaxfbQ3fzKRUT6yNBskpKs/LDAn68uZ/rxk28=;
        b=xlCa7R6ZdMZ+P84gYOw4lBBBmV83LUn1htB+GzQ5CJs0+aYqIwRFnWd1lI1p4NAIYj
         VtbIx17y8eN+2WJXq+NgnI6WSF3gyqo9IpMd10DLmAgHJ0nnRJK4THs8ZNI7a3r2ZmzE
         OQApzqcBKaqGsZ078REGlE57wSidwd2AraX7R/Fd+dME1CEbPv+9PEZBV4kh1RuK/jUf
         eWimrLlwW1430ZSvbN/M7TUiaR0TuGDHFVg7hVE1hvealhCWVxfj7toNMNh8LZCWlVI0
         yR6+8B7gCsCtqj+ogux6zy5bcB9MpIJHX4Fa+ajB+dPSFx3dJEYU1/7GeOc0KwGedpry
         +DEg==
X-Gm-Message-State: AJIora9YvFbQMxoTLoMDeo76BYSNtF4hFFMejqLEmx5dMCDMCRSvltKx
        86wjyZIVXm956uFsoc5xoe6iN2G7KDY=
X-Google-Smtp-Source: AGRyM1v+CiYOOdv5JI8CC6OxKBXUqoeUGbgmIRMee6f4XToTwmt+SGwBGPMTZ/kB6pPJKcEytiCOvw==
X-Received: by 2002:a17:903:1ca:b0:16c:4e2f:9294 with SMTP id e10-20020a17090301ca00b0016c4e2f9294mr26900968plh.30.1659015199352;
        Thu, 28 Jul 2022 06:33:19 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id m14-20020a63710e000000b0041b667a1b69sm960078pgc.36.2022.07.28.06.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:33:18 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 1/5] ksmbd: fix memory leak in smb2_handle_negotiate
Date:   Thu, 28 Jul 2022 22:28:18 +0900
Message-Id: <20220728132822.6311-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The allocated memory didn't free under an error
path in smb2_handle_negotiate().

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17815
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1f4f2d5217a6..41ef076af072 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1142,12 +1142,16 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 			       status);
 			rsp->hdr.Status = status;
 			rc = -EINVAL;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 
 		rc = init_smb3_11_server(conn);
 		if (rc < 0) {
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 
-- 
2.25.1

