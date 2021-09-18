Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B22C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 12:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3EA6127A
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 12:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhIRMEf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 08:04:35 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:35369 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhIRMEf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 08:04:35 -0400
Received: by mail-pl1-f172.google.com with SMTP id bb10so7970429plb.2
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 05:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sfaTcZ9ECzP+BDXEN3tLM2K8fVIhm3H//5XREoFsLrs=;
        b=uKnMKZYJcCuSa4yNaDvO/jG9BTJebJ5I4b8VjEP3uDUFnfVIcAArPEbefdbJ2HxVQ2
         zH935mD0wnuUJFko51y39WOgfQj+ltYrmExu8exD4zV+SC8B5f2gdoSWWwKtRXxuO8vd
         3wOy0Qgow+9VYRPIFAKHTyJw8JwojimxhH5TAcZRCsC7j9NwkAH8AC4pdx0Zq28nAjUq
         mITa0G6Zm4bbEAFjgkzpRsWcZP+EiS8fnTbE36pkCTj7rKdiQcTj7Ev/VdaMtEaXgzVb
         QyJcAlDpuCcr8cWW+Qms1KFjFSaCflmhlH9qaYaUgU5vidpGlBDgksI/ggZmKc5PbDNK
         Nahw==
X-Gm-Message-State: AOAM533i+SzBGVb5n285nLnVJvlvmUCT1sWPkc405lGcFmq1FNyqzbJu
        rMKhqOJXqdLaRvH7O2Iuhj4/JVgYnH79sQ==
X-Google-Smtp-Source: ABdhPJxT77JxAfm4ocdOt0l1rYL0KVZCWByiArsxvozwHQ9g9+m4retcXLpq2QrgSY4BMofIWoOZ8g==
X-Received: by 2002:a17:903:248:b0:138:d607:a8f4 with SMTP id j8-20020a170903024800b00138d607a8f4mr13887495plh.75.1631966591316;
        Sat, 18 Sep 2021 05:03:11 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id on6sm8788844pjb.19.2021.09.18.05.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 05:03:10 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
Date:   Sat, 18 Sep 2021 21:02:39 +0900
Message-Id: <20210918120239.96627-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Windows client expect to get default stream name(::DATA) in
FILE_STREAM_INFORMATION response even if there is no stream data in file.
This patch fix update failure when writing ppt or doc files.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 49a1ca75f427..301605e0cbf7 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4465,17 +4465,15 @@ static void get_file_stream_info(struct ksmbd_work *work,
 		file_info->NextEntryOffset = cpu_to_le32(next);
 	}
 
-	if (nbytes) {
+	if (!S_ISDIR(stat.mode)) {
 		file_info = (struct smb2_file_stream_info *)
 			&rsp->Buffer[nbytes];
 		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
 					      "::$DATA", 7, conn->local_nls, 0);
 		streamlen *= 2;
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = S_ISDIR(stat.mode) ? 0 :
-			cpu_to_le64(stat.size);
-		file_info->StreamAllocationSize = S_ISDIR(stat.mode) ? 0 :
-			cpu_to_le64(stat.size);
+		file_info->StreamSize = 0;
+		file_info->StreamAllocationSize = 0;
 		nbytes += sizeof(struct smb2_file_stream_info) + streamlen;
 	}
 
-- 
2.25.1

