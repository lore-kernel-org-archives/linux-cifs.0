Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9D3C61DA4
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Mar 2023 12:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCEMfA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCEMe7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Mar 2023 07:34:59 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483A11BD1
        for <linux-cifs@vger.kernel.org>; Sun,  5 Mar 2023 04:34:57 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id y10so4080057pfi.8
        for <linux-cifs@vger.kernel.org>; Sun, 05 Mar 2023 04:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678019696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/Sav/z4jStbwj4LP4lq+DnMmWl3QrYqg63iHjU8heY=;
        b=685MGumMyyRgrTav84cme8mvEv9KgHlN6x8ALW4WOHKo2ggdPtQk+ujYZzdGITOAtS
         SiSGu/Cqy4KlR8nhpR/bk6J311P+23zzXTcCUezvs8Kyk3DWsuQoUbE7QjXTjMEhqcx1
         WRTUd9Em9DKVlnwOmOOfqQmvnKT3ZZKT72Rm5bXhgIS/ROX93r48BQI79VAPe66vuu+0
         iZ+Y6uxthOCmO8/hFEi6cCnVYsONEAg4HmqqgLOXlSqi19uWZGOzWzIBGVXUZKjyi/+5
         K8PE4KGikbrCVzKQcQwiXJMD0O7y/MPbC80BaYSMeEyhZFuTX1l2++Hsh/iCRLT5mqQ0
         2lNg==
X-Gm-Message-State: AO0yUKWWkdfnh3Zos7c8cu/K4pSZeeEGfyFjpD22Le/f4JKdzWqmWkn3
        gMq0nDhojW2oWezUDJt7Gc0Z6j94ccY=
X-Google-Smtp-Source: AK7set9aB8CRHpCIKLp12gxaqtWLneQpmYEwz9bXjr2YIkOgG7J+V/zNrXM4MHvDZ/cZQ5QuMBy9/Q==
X-Received: by 2002:aa7:9f81:0:b0:60b:81ae:c6d2 with SMTP id z1-20020aa79f81000000b0060b81aec6d2mr7603209pfr.27.1678019696512;
        Sun, 05 Mar 2023 04:34:56 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e21-20020aa78255000000b005a8dcd32851sm4683257pfn.11.2023.03.05.04.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 04:34:55 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 1/2] ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
Date:   Sun,  5 Mar 2023 21:34:42 +0900
Message-Id: <20230305123443.21509-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Smatch static checker warning:
 fs/ksmbd/smb2pdu.c:7759 smb2_ioctl()
 warn: no lower bound on 'off'

Fix unexpected result that could caused from negative off and bfz.

Fixes: b5e5f9dfc915 ("ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 81e987114206..b7a420e0fcc4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7757,7 +7757,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 		off = le64_to_cpu(zero_data->FileOffset);
 		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
-		if (off > bfz) {
+		if (off < 0 || bfz < 0 || off > bfz) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.25.1

