Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7DCC6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 10:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjCXKVk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 06:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCXKVj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 06:21:39 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC5E1CF72
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 03:21:38 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id s8so1550994lfr.8
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 03:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679653297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iiPqGDAwiO9tBBga24DOKUlNtvtvmLoA6ozOVXjP6FU=;
        b=I/Xc/RaUoUYhtVyq1+lFQR1EqlEFcV0gamzOB5zQEQizWomAmZTJlr2ooe10DOP3ab
         4q0NfguqIEZVsDtfmJRQ8X5hC0ckyKLpqTI0iykGLx+hRJ3Z/3eA6l4nXGuJVj7II0VZ
         Mj9d+cnneGKyISAFG78pZPzlAshHF5nOzXxm6nwFhKi9PhhUa5LjuEH96B0atBykeAQF
         XKp3BN/bxta0z9Obcsg4EqSw9gMeWfX0A+Ar/4Gul9rbdoFNYTpgQbXtDFOQygS5sJxY
         ExEc8Z5sdWS684X+M05Qta1BzZvKw8gR0ge+XqNFyfuCcyc91531103aP2faEkSeiF1n
         D0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679653297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iiPqGDAwiO9tBBga24DOKUlNtvtvmLoA6ozOVXjP6FU=;
        b=nsqDz+C9+qtlc2C8b0PFp9piPQch+2xNY6Gy14SO6lY1tC8mJ3W0Va09mkNQdo7k6G
         f4TqQDTMCNb9vKfflQbwO1Xlt8UwK45kRyoBTCVLjiCEN1JG+Cv/dPg0tGBHciDD64iy
         38YF/7XMMbu+0CEQRsx1JpthlKnJVuxPicza3ix9wd42s3m5Jyo7jq5mulUNra2AwDqw
         DTCpd36ht2h5jfFC9FklijMZaHDmKk45j2LGqla8TAILAIrti5LyggB/C8EVpihJ/Bja
         wn3bU2SMEEsknAxnfEAZW14GrSC8VJjtCNjJ5NGxIhT8dAHfYmYdSThSZruQH0yxiz6r
         U+yg==
X-Gm-Message-State: AAQBX9fg5BoNtmBvnENHfy3g1rSeWU2OSnMJ1BPrX7mJciqIcZaQIBjX
        p6s30EbGAVcrxSpNWbzLT1HG5w==
X-Google-Smtp-Source: AKy350b3CEQNireqjeuShd6gMgUsBmIKwXWLaJpT2c8VWtS9CCapDUHZAJ8B3pgBLiWq/mKiVD03/g==
X-Received: by 2002:a05:6512:1026:b0:4e2:9cc:5625 with SMTP id r6-20020a056512102600b004e209cc5625mr554513lfr.46.1679653296837;
        Fri, 24 Mar 2023 03:21:36 -0700 (PDT)
Received: from fedora.. ([85.235.12.219])
        by smtp.gmail.com with ESMTPSA id n11-20020a19550b000000b004eaf41933a4sm1094590lfe.59.2023.03.24.03.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 03:21:36 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] cifs: Pass a pointer to virt_to_page()
Date:   Fri, 24 Mar 2023 11:21:33 +0100
Message-Id: <20230324102133.711910-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Like the other calls in this function virt_to_page() expects
a pointer, not an integer.

However since many architectures implement virt_to_pfn() as
a macro, this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this up with an explicit cast.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 0362ebd4fa0f..964f07375a8d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2500,7 +2500,7 @@ static ssize_t smb_extract_kvec_to_rdma(struct iov_iter *iter,
 			if (is_vmalloc_or_module_addr((void *)kaddr))
 				page = vmalloc_to_page((void *)kaddr);
 			else
-				page = virt_to_page(kaddr);
+				page = virt_to_page((void *)kaddr);
 
 			if (!smb_set_sge(rdma, page, off, seg))
 				return -EIO;
-- 
2.34.1

