Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFEFC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 23:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiFMXCF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiFMXB7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 19:01:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506E03205E
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:01:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e9so6939051pju.5
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GW0YonjkueH+047BxZsXnZQD3obnI59nyCsoVaQzIBs=;
        b=ERCvJsd70F2QgRNcdd3c3xeW6tb7SslxyMl223LZBxj9MMtAObMJ0slr3uCV1zGnHb
         /20vioUeXGuRJ91PAIYghzGP1P3Qzu0+05w8G7TyZZjCBCpZ9aE5xsUwvb7kH1F6htmb
         KwsNM+qY4q+WKLD53MMO2Ol/V5nVJ9hpksNa59y61+hXGWXne5DHWGr+432zZp1dHgb7
         5VLALscF1jIFTQCwPZOA04VQZtSAbMZLxaueYiVW+4LdWBn6SaWXxWc52bWYggncfReq
         3EJMfp3slJibfBoSZbS2EEP7DUZLDAhYxj0OEasfdpm4FZMxXOi+tTUOWeQSe/le8N6h
         Nvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GW0YonjkueH+047BxZsXnZQD3obnI59nyCsoVaQzIBs=;
        b=iN247aUIQtms+bCYlUzgjanje1ROCeOetWSWecobUikBA16INOtrK2JoqOoaONdIXO
         xiUThyCL/he/NxNCtH5znZ+d5VBBaw4MZJALvNSRW4JyO0jRHwfTKEWZfAF36r4wVlsQ
         DpoDZOv3pFUw3WjjXJU9zXQxtaGW10FyzR3nw/HAjC499LV+hd0jS/7LhCdcYgXiWd1v
         9xApfYEcE5lp3BUeGo2aIkBbxGK81NOo4QCZOSpDcriS5QAlpu20GdhDpeURvggy6szC
         XFXStFNPDAf/Po8rgKEI2k+lVA6xFm4J7n/GPGMV0oZqZO21/PGI73bJYlYP07sv0fGc
         0KTQ==
X-Gm-Message-State: AJIora/uk2ZSoax8I02Nzy2+9VLk4omvScVZmaawd0Mbx8rmzEKyHNg4
        M2iRiJjm6lVjnI37eEUQdril6AmtdBM=
X-Google-Smtp-Source: AGRyM1tCyRhKGSgHvah67bvynXvbD66XLT0/qv2/2Z4bfGGvKJL7wPICaoQj7UGj0YtLR2n24CSooQ==
X-Received: by 2002:a17:90a:cc0d:b0:1e3:1256:faa3 with SMTP id b13-20020a17090acc0d00b001e31256faa3mr1113481pju.107.1655161312031;
        Mon, 13 Jun 2022 16:01:52 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id o186-20020a62cdc3000000b0051c78a77702sm6097603pfg.176.2022.06.13.16.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:01:51 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 1/2] ksmbd: remove duplicate flag set in smb2_write
Date:   Tue, 14 Jun 2022 08:01:18 +0900
Message-Id: <20220613230119.73475-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The writethrough flag is set again if
is_rdma_channel is false.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e6f4ccc12f49..553aad4ca6fa 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6506,9 +6506,6 @@ int smb2_write(struct ksmbd_work *work)
 				    le16_to_cpu(req->DataOffset));
 
 		ksmbd_debug(SMB, "flags %u\n", le32_to_cpu(req->Flags));
-		if (le32_to_cpu(req->Flags) & SMB2_WRITEFLAG_WRITE_THROUGH)
-			writethrough = true;
-
 		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
 			    fp->filp->f_path.dentry, offset, length);
 		err = ksmbd_vfs_write(work, fp, data_buf, length, &offset,
-- 
2.25.1

