Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838E1C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Feb 2022 09:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiBAJPY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Feb 2022 04:15:24 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:43633 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiBAJPY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Feb 2022 04:15:24 -0500
Received: by mail-pj1-f47.google.com with SMTP id qe6-20020a17090b4f8600b001b7aaad65b9so1803390pjb.2
        for <linux-cifs@vger.kernel.org>; Tue, 01 Feb 2022 01:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aL3O2Vf3cVDHKRDVp1GoVcvdxlOn+9IHPjP/B8lDW6k=;
        b=nxveMoNRQV7lPIZyrXxVjwJWc4oOzF4xz4we1M6Inf1hihcBOGNaRwsNSbK5eLgVki
         QitzXzFNKt394w2Ua9asDDWw1KWBKzqSmCdWMt17b7imwjDu0jGgrKNh0TPpySqJwIz6
         LNnhUfsx8HJdv7h2yPvAHx17OlG/1n5s/XRBl62w4fviryvbU/IhLr74ovI4ChUWPWRy
         gPgcBaZi1rCbir2dr/JzbJQx9zIU0M8e2CgWzDs79yQZJ87/NyINz+DwjoDzZnfhpAX/
         t+8z1ghmSZzYynROf5RtEJ3nzfnYgyBjTvlrsgApBeay8JrL2J3XJUwxbuAhaBtWOZzX
         ODhA==
X-Gm-Message-State: AOAM5300XegL8xnVcqo1cqlDOqd8R9mHoCeLKOK32r+k4bTlT7V9N6/f
        X/WwyTGhnD3K9hwO2lewbyxZiCr0Gdg=
X-Google-Smtp-Source: ABdhPJxUWn3MoQJ2IFl0aVCRgzAjAQWAmpoNsVUFTi4ND5mdOvawNOAywg/Q0wJVdfFAaBDvWKke4w==
X-Received: by 2002:a17:90b:3841:: with SMTP id nl1mr1260338pjb.50.1643706923538;
        Tue, 01 Feb 2022 01:15:23 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id n3sm20152599pfu.84.2022.02.01.01.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 01:15:23 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>
Subject: [PATCH v2] ksmbd: reduce smb direct max read/write size
Date:   Tue,  1 Feb 2022 18:15:12 +0900
Message-Id: <20220201091512.11167-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd does not support more than one Buffer Descriptor V1 element in
an smbdirect protocol request. Reducing the maximum read/write size to
about 512KB allows interoperability with Windows over a wider variety
of RDMA NICs, as an interim workaround.

Cc: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - update patch description (Written by Tom Talpey).

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

