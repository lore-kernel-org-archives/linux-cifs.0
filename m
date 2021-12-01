Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D5FC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Dec 2021 20:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353002AbhLAUpS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Dec 2021 15:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352985AbhLAUoa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Dec 2021 15:44:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540D9C061574
        for <linux-cifs@vger.kernel.org>; Wed,  1 Dec 2021 12:41:08 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a9so55030167wrr.8
        for <linux-cifs@vger.kernel.org>; Wed, 01 Dec 2021 12:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6Mv/aqbVr/9XUswf4NQr4d22pxk4qTOyIAqaIZBTys=;
        b=Ojrx77V4BJCVgdrnzwH7Vt/SOr7VVNpYQRcdKi8+maCyzdkDXTdEujpsLhEkXruAzw
         RY/Sg+4W4tynV5jmRaDNxJL07bOedTk4nwg9BTSngl70VGXVCDsSXDCVvjTQtgWVc+dE
         cHPhEtvTXvWXnekxPDf/83X3XyC3MhMjHWCPMQm2YDzIcn2yueHvYLengt5SGcAfUA+7
         NrxcELjX1RQSc/+ACSlkKgACUDDLDYsRIaw4K+IQMcV9mnXJvnOnYaZlR/pvOLxroBtN
         yGez+67nMmVDOS0SAM2rkMB9etBUejIGl9TSEwEWRwFepfuwgYWRZUpXauB9IB3QEE1V
         zwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6Mv/aqbVr/9XUswf4NQr4d22pxk4qTOyIAqaIZBTys=;
        b=1SdM9d/pRMu6+uGZ05waQ1HWS7eU6efgcd3Dd7WoO4MRiBmvIW1COFdnZYwKuRSq3D
         kJ+I+TgCiWO399xMcOjy6QPI5qVTTLsPFKRs96+gbPaiOmwh+Bqe+EojL0zBzhZFuZ0+
         2Z38FsaahU6K6FgFNmLVE8dbYwxiAJLtxf+20omLsTFgNT/CP+cFGrKiFhx+fds9ZOHP
         D371dHkestIViEJ03IvnefPYsk1u8eUiJ0zYiCdMX8QCv2cbO0Eulay+rd0NA+oLLR7+
         bH4Mo6H6l0osPHYJ+zzUcDsI1TL5VQsbHL5yH0f4buIsjeOf1MunuUGd55nWmV1oRCy5
         p5hA==
X-Gm-Message-State: AOAM530f2qu2byFvAy0Wm17c8mpV1m75TECukWmzgO5rnAxytwgYZqgw
        N+SeDeQFhH2VFaZ0J+BJ4G63hplXnI4bjw==
X-Google-Smtp-Source: ABdhPJwmvwGz88w0IUomMTw4ex7hE1vTkmsHW9OSI+cHB2ak9+Vqt9SeK2yGzIHcX9yve/lFIaLjEg==
X-Received: by 2002:adf:d092:: with SMTP id y18mr9530336wrh.523.1638391266851;
        Wed, 01 Dec 2021 12:41:06 -0800 (PST)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id f13sm390622wmq.29.2021.12.01.12.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 12:41:06 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: Remove unused fields from ksmbd_file struct definition
Date:   Wed,  1 Dec 2021 21:40:50 +0100
Message-Id: <20211201204049.3617310-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These fields are remnants of the not upstreamed SMB1 code.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/vfs_cache.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
index 448576fbe4b7..36239ce31afd 100644
--- a/fs/ksmbd/vfs_cache.h
+++ b/fs/ksmbd/vfs_cache.h
@@ -96,16 +96,6 @@ struct ksmbd_file {
 
 	int				durable_timeout;
 
-	/* for SMB1 */
-	int				pid;
-
-	/* conflict lock fail count for SMB1 */
-	unsigned int			cflock_cnt;
-	/* last lock failure start offset for SMB1 */
-	unsigned long long		llock_fstart;
-
-	int				dirent_offset;
-
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
 	int				dot_dotdot[2];
-- 
2.25.1

