Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6672DCD6E7D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Oct 2023 14:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346706AbjJKOs0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Oct 2023 10:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbjJKOs0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Oct 2023 10:48:26 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D839794
        for <linux-cifs@vger.kernel.org>; Wed, 11 Oct 2023 07:48:24 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-690bf8fdd1aso5233102b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Oct 2023 07:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697035704; x=1697640504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IEGkN6P6TCIB4ESVyJmdYOmltlDozsLBHrVEFqMYCWM=;
        b=GplxlU971cXv5YE7A9z+rpX1Q1C8uEEOlCu/PrySgx+80S86gLxNMt8LJVpJuOZvdb
         nG43bCbbxAJRoJUnzzGW1AlO3eMW2r7tCeFJwA/TtAGqOA3pCPlgUDNDIxvXH9rMGivj
         AkGhXqguRuUkvx9WT+gb1PfT19ENs8SNCdWYX1gLGZEcqtLTmsNaeSMl0J15azaUVz6Y
         vbphstnpiKt6SPqlO96+6BbLbx1TSWmdZQmw6UEvnKidB4QkESelw1XfJKuCX3zFKJc/
         NOtXmKN6tPv0L0Agb49uBrlroRL6n/vZs9qV31kLM/1ZLZdiVkAXBjAC+OIAlv3LqipV
         ydiw==
X-Gm-Message-State: AOJu0YwnD0QwJiyN7dd56g/6czIS5QQJD/R7Q1lHLvgFwCUptZYsMyx5
        noDcXrnp4N9OueSYvNRBMT9CUC8TsRc=
X-Google-Smtp-Source: AGHT+IGOHAqIzx3MxKDuF+hfdYbjGtUoP4hS5zXnrm/9d5lPZo/IIAuyehozTfRwULwYDWfo1kEnQw==
X-Received: by 2002:a05:6a00:180c:b0:690:d008:8cfc with SMTP id y12-20020a056a00180c00b00690d0088cfcmr24131307pfa.32.1697035703766;
        Wed, 11 Oct 2023 07:48:23 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id ey5-20020a056a0038c500b0068ff6d21563sm10626059pfb.148.2023.10.11.07.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 07:48:23 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Coverity Scan <scan-admin@coverity.com>
Subject: [PATCH 1/2] ksmbd: fix Null pointer dereferences in ksmbd_update_fstate()
Date:   Wed, 11 Oct 2023 23:38:46 +0900
Message-Id: <20231011143847.9140-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Coverity Scan report the following one. This report is a false alarm.
Because fp is never NULL when rc is zero. This patch add null check for fp
in ksmbd_update_fstate to make alarm silence.

*** CID 1568583:  Null pointer dereferences  (FORWARD_NULL)
/fs/smb/server/smb2pdu.c: 3408 in smb2_open()
3402                    path_put(&path);
3403                    path_put(&parent_path);
3404            }
3405            ksmbd_revert_fsids(work);
3406     err_out1:
3407            if (!rc) {
>>>     CID 1568583:  Null pointer dereferences  (FORWARD_NULL)
>>>     Passing null pointer "fp" to "ksmbd_update_fstate", which dereferences it.
3408                    ksmbd_update_fstate(&work->sess->file_table, fp, FP_INITED);
3409                    rc = ksmbd_iov_pin_rsp(work, (void *)rsp, iov_len);
3410            }
3411            if (rc) {
3412                    if (rc == -EINVAL)
3413                            rsp->hdr.Status = STATUS_INVALID_PARAMETER;

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 1c5c39733652..c91eac6514dd 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -603,6 +603,9 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 void ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 			 unsigned int state)
 {
+	if (!fp)
+		return;
+
 	write_lock(&ft->lock);
 	fp->f_state = state;
 	write_unlock(&ft->lock);
-- 
2.25.1

