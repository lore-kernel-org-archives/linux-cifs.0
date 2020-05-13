Return-Path: <SRS0=OaSP=63=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B24CA90AF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 11:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE60206CC
	for <linux-cifs@archiver.kernel.org>; Wed, 13 May 2020 11:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=forsedomani.com header.i=@forsedomani.com header.b="gBOprnuV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgEMLyW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 May 2020 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgEMLyW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 May 2020 07:54:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180A3C061A0C
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 04:54:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so7674581pgb.7
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2020 04:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forsedomani.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=uGHZqNBqBVLI/llN4bkmip1GPgyCXQWgKey6V7YjKTo=;
        b=gBOprnuV7+cDAefOss0XM9cftik5DWXhNZago5Lz0euKw8EKDcyDk0AQuecbsDpamd
         k/tO/+0saNfhpq6sE/yreSS3bd8GYMD2xor9LCrwNFfZ7gXC68ZLOPYFssFBUN1ekeHu
         OlVWkIWaloUbVjkBPGfvzOXN9rdLbnEUO3InGjStOfO8OPGSOs66zJuM5hw5aahq89y5
         PGU5f2/bbiIwMVW7DoyjcOWFP/Ka8MA+NPEQD4B/NDsFVYTtfjkYY9WWs3CmQU0NAiD9
         +y2ZKV/QrABDNEe+S99ZWRKj5CpcyPwEndRBnEfiCwWzr01UvPhi0moOjQNDj1XxCIkS
         2JfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uGHZqNBqBVLI/llN4bkmip1GPgyCXQWgKey6V7YjKTo=;
        b=LD9ES4LzcRVcPvkKj4SzMSvzXLX4kCINd1K73zo3Oxra0I+erK2ECaAKJsytCNuUmg
         VQVRBARCanwTFA6vtVLvmuaFYLZLJBoFJDy9xsFydV+rqjTCmEUN9yErq+bJjKj5zQqq
         lJ2FqEU5STOkfmLqzL1iGsEcZUQQr5xJfOQUL76uqiZB5QLRjOgjjCisbDyNNqI9fouK
         iJtjt4b0v7V9bA+PG1ahvc3f/Tq7b2kyF5fQMEPjOuNUuJu4IdPcwxP9RANVkqWtE/6b
         fIC/QvGuRQuucHlId+bZLyeCxcnSgVzZM4V5NumXY/0jnmMb7aWQNLRupI9qgih4O9By
         kOdA==
X-Gm-Message-State: AOAM533+S9rWVUK+gJ2/AXK3+uQmSIUIUt+9xao8J7/ZMbcQtzUp6Km1
        tiNs0j3dp77yjQLCoOwtsmQR51Mtf1yQCA==
X-Google-Smtp-Source: ABdhPJxzvVVOf57p/dbYlUnffsnvieg4CtTWo1Ec8O3Y+i6oQaEkP9rKS88m4J4AHEdcDJTn4DlYdg==
X-Received: by 2002:a63:ef09:: with SMTP id u9mr12739704pgh.406.1589370860931;
        Wed, 13 May 2020 04:54:20 -0700 (PDT)
Received: from localhost.localdomain (ppp118-209-213-103.bras2.mel11.internode.on.net. [118.209.213.103])
        by smtp.gmail.com with ESMTPSA id f29sm4397261pgf.63.2020.05.13.04.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 04:54:19 -0700 (PDT)
From:   Adam McCoy <adam@forsedomani.com>
To:     linux-cifs@vger.kernel.org
Cc:     Adam McCoy <adam@forsedomani.com>
Subject: [PATCH] cifs: fix leaked reference on requeued write
Date:   Wed, 13 May 2020 11:53:30 +0000
Message-Id: <20200513115330.5187-1-adam@forsedomani.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Failed async writes that are requeued may not clean up a refcount
on the file, which can result in a leaked open. This scenario arises
very reliably when using persistent handles and a reconnect occurs
while writing.

cifs_writev_requeue only releases the reference if the write fails
(rc != 0). The server->ops->async_writev operation will take its own
reference, so the initial reference can always be released.

Signed-off-by: Adam McCoy <adam@forsedomani.com>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 182b864b3075..5014a82391ff 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2152,8 +2152,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 			}
 		}
 
+		kref_put(&wdata2->refcount, cifs_writedata_release);
 		if (rc) {
-			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
 			i += nr_pages;
-- 
2.17.1

