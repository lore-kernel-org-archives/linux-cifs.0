Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9678DC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B0B20661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ff9yYYCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfCEXwG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:52:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38258 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfCEXwF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:52:05 -0500
Received: by mail-pg1-f194.google.com with SMTP id m2so6782307pgl.5
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Can4H29Q3ejASXFiT++BZu4BbfjNyHVeu+ayDMCQ3RU=;
        b=Ff9yYYCIETFWqDY2Ek7ZPJLfb9DCPoe74sBtKemyHv22Su9LwEe2kDHrgu3XFKXxmm
         Pm0qMJfOSMKCrpceeWL0OAK/1rxPPm4gDBVN0WoQBcvxkwZNpFxhNnpFxtjE+LjsmrSK
         eWVQRb8ItxEM2HcxAySVXOYx5XUOj3g5kDuFyye8O6Tud4IIEocBPEVHP6AiEkDvAGtP
         DUtyg6uDb5NloeVmPMhCnRwtUu4y/jVfFL92x2TA3J1SPuMVDpDX5DSlYX4eQqLiy5iT
         mg4Kloxi27qCjjVpw7nxb8aiJCtKhoyMgnIf4mQN9iH+iyFJl2DwJP5pk1OKbNxqn5QL
         fdog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Can4H29Q3ejASXFiT++BZu4BbfjNyHVeu+ayDMCQ3RU=;
        b=XZ4W6uI7G5kouMHy/SIKXKfozKUCO/ZG3DHhJUDs46pNsb3YemdwfEqcHpoIwQRglA
         AORATJrHJ3xwtNc1I2Ka46namVnTYVQQ6oRiDUyzG9XQ3Ny6XJErF5MTQf70ye00Ryzf
         OZFevd9r2VDGdckd1EcdzuBOW5OkY+cVG+2SyE0p5n++h+y4JhUctGJvh7DJhEMGehxs
         7KHYgdAMPGVVIDT2V/pKdBg5NCS9IpT5leDID4rG9AXrPlBvW6GJf9KZbM+uqzjKn9Iy
         NxHLbEDTq235BHxy6cCdjkFOhFbz01bWLDS3f/pRBsntjuJpXH+a99a+QBNHNF2w3a3a
         7RKw==
X-Gm-Message-State: APjAAAXX7qyQnRZ9m2bMzq3ZGFQrZnie40sHrqMU9fdVMTzX6mqiC1QV
        eIplrMD+56nE3WBEkDzG9Xo5Z3E=
X-Google-Smtp-Source: APXvYqzVyxnGhsYaB/Xn4wKiIQtbkVyW7P05HyskNzfmKARg18okRxJHDF2boEE/AWLbXDYQ1Xl4Ng==
X-Received: by 2002:a17:902:25ab:: with SMTP id y40mr3851631pla.62.1551829924687;
        Tue, 05 Mar 2019 15:52:04 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:1:a18d:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id l64sm50342pga.87.2019.03.05.15.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Mar 2019 15:52:03 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH] CIFS: Fix read after write for files with read caching
Date:   Tue,  5 Mar 2019 15:51:54 -0800
Message-Id: <1551829917-48772-2-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
References: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we have a READ lease for a file and have just issued a write
operation to the server we need to purge the cache and set oplock/lease
level to NONE to avoid reading stale data. Currently we do that
only if a write operation succedeed thus not covering cases when
a request was sent to the server but a negative error code was
returned later for some other reasons (e.g. -EIOCBQUEUED or -EINTR).
Fix this by turning off caching regardless of the error code being
returned.

The patches fixes generic tests 075 and 112 from the xfs-tests.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b53f33..4c144c1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3096,14 +3096,16 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written = cifs_user_writev(iocb, from);
-	if (written > 0 && CIFS_CACHE_READ(cinode)) {
+	if (CIFS_CACHE_READ(cinode)) {
 		/*
-		 * Windows 7 server can delay breaking level2 oplock if a write
-		 * request comes - break it on the client to prevent reading
-		 * an old data.
+		 * We have read level caching and we have just sent a write
+		 * request to the server thus making data in the cache stale.
+		 * Zap the cache and set oplock/lease level to NONE to avoid
+		 * reading stale data from the cache. All subsequent read
+		 * operations will read new data from the server.
 		 */
 		cifs_zap_mapping(inode);
-		cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
+		cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=%p after write\n",
 			 inode);
 		cinode->oplock = 0;
 	}
-- 
2.7.4

