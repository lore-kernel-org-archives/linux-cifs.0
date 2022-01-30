Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEEAC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jan 2022 09:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbiA3JfB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 04:35:01 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:36799 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiA3JfB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jan 2022 04:35:01 -0500
Received: by mail-pf1-f174.google.com with SMTP id 192so10212482pfz.3
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 01:35:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lsuttai6p75hcwwPCm2Jdb0rN4+uDFqe4PEhjFJ8c98=;
        b=D9pDu0Yqluo8ZNMpm95sf00St+mVtPsqPY2EkUcc88IqilXFqr+g7iJRWq0wPs+aWt
         4PClz1hy7C3ktPrFyTsOxjyDDZPBMnbY1PpPRQEWp6148ntSsbIBNo450X2dwQC9Xffh
         F55WX0nRSSq4Ti2blyzjiuNZMZmleb7baZ5GIjgLeJV4s6uwBbD9omgRY3Mk8PQx+PJz
         xa7AHt+WIKl6rgaIGdo1jC2MclGQi9ncEczuHSdNGG7lKBwG8chxo4p8Z78uMhmNtlxg
         6SkKJkkwjlJIpA8JLJoHspPBBCJ1w4wWfuqFbJv03WxCUsLfjFKafKbvnICQlB2smpY2
         9JDQ==
X-Gm-Message-State: AOAM533rafofsouzZfsR5cV8JEfKAsseq8A0xLeKBz0iU98Fl5g4df+D
        5H6nhyzqyZ1hN0wJndGzm77BZiWewNU=
X-Google-Smtp-Source: ABdhPJz/1hMk1GVLLdzMBw9WokqnUWrmSQM06s62RIeVCM2lDrEUa7K4FF/NhNOdvkk7oWod59u0sQ==
X-Received: by 2002:a62:1852:: with SMTP id 79mr15792283pfy.69.1643535300571;
        Sun, 30 Jan 2022 01:35:00 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id l22sm14991798pfc.191.2022.01.30.01.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:35:00 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: reduce smb direct max read/write size
Date:   Sun, 30 Jan 2022 18:34:31 +0900
Message-Id: <20220130093433.8319-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To support RDMA in chelsio NICs, Reduce smb direct read/write size
to about 512KB. With this change, we have checked that a single buffer
descriptor was sent from Windows client, and intel X722 was operated at
that size.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 3c1ec1ac0b27..ba5a22bc2e6d 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 1048512;
+static int smb_direct_max_read_write_size = 524224;
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
-- 
2.25.1

