Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831E5C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 07:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5212C61003
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 07:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhDAHzn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhDAHzi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 03:55:38 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E259C0613E6;
        Thu,  1 Apr 2021 00:55:38 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x7so815031wrw.10;
        Thu, 01 Apr 2021 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=7AcUn3xoZZEmyhZhPx7msf+G6yuROMfX+4IPdOsLIXM=;
        b=RxBg1fbvLeuXaeUg1huVHZRHjz94Qh4n1oGBKmxL3+O4hVrFP/QZLEaMJJtuWx5peS
         C86Gs4KAR3AfFUhlo7TnuBHygbYOqQ2EDFgJt5/nmAvu+X4bEo8ZUYGJQHHMtrA3IbbA
         J98bVLid0BscpINMXFNQpNfwU7ZJqwwFjbBhUOFO1zuHN9oHEq67r+k/SdwqR4InY+AZ
         CEQDNg3cd2ogv18xq1wlEKEfaGjVOjSSCSS11huLMiiK3bw/EViUa0lbKc7uoUxPkGcf
         qt0hfVYh1ZT4DWuTe/NXQ3/xmJSRu8axOwQZl3xATHkgT8mrXxgvDwvry6acqY/gcwl2
         uP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7AcUn3xoZZEmyhZhPx7msf+G6yuROMfX+4IPdOsLIXM=;
        b=IT4Qj2N6DFfR6kGIp6SRpgKtHmnfcZuPXZYmbJc6V/hrNf0K1Y2oAohG/neJ1LSARn
         MENpcJKyIC5tpcTYqnQ5LI+s9YraGs17oXzZYBWENrO3N6q3gKgkC9cHpjO2mnlw+Qvp
         MgCEyV0uhu8RHKkPBelcxx2HeMx/d1VitaO+vpBbykrJdE+nYpXJGCwwZyCgdb6Xzg5k
         sP3HZqmmdrZC+M8/Sx7BCQl0Ab2TrKzNyzs38UmX3Jn73xRypAP5KfWPO5YMCArYc0S0
         DOBv+oLFnWprQN4TxCEEYbwZd+4Yf544PpqvTZAHHMmuBrb9URFKhyNGIU8STstSpjQ4
         YPsg==
X-Gm-Message-State: AOAM530j0hlzbUfBL059k5d+mBkGVIurr+fiTrad3i+i2ZNg3gJHha47
        ctG4Rx8wKQ0RID2E4berY/s=
X-Google-Smtp-Source: ABdhPJx2C+wSabSmL2kcvpy9eih/c6S2z6hMIMNLJtkMOgRseCk3g0CVYiJYoYZ2Stgf6DbUilowuQ==
X-Received: by 2002:a5d:6945:: with SMTP id r5mr7936051wrw.367.1617263737158;
        Thu, 01 Apr 2021 00:55:37 -0700 (PDT)
Received: from LEGION ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id j136sm7565881wmj.35.2021.04.01.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 00:55:36 -0700 (PDT)
Date:   Thu, 1 Apr 2021 12:55:31 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        "open list:COMMON INTERNET FILE SYSTEM SERVER (CIFSD)" 
        <linux-cifs@vger.kernel.org>,
        "open list:COMMON INTERNET FILE SYSTEM SERVER (CIFSD)" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, colin.king@canonical.com,
        dan.carpenter@oracle.com
Cc:     musamaanjum@gmail.com
Subject: [PATCH] cifsd: fix memory leak when loop ends
Message-ID: <20210401075531.GA2766105@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Memory is being allocated and if veto_list is zero, the loop breaks
without cleaning up the allocated memory. In this patch, the length
check has been moved before allocation. If loop breaks, the memory isn't
allocated in the first place. Thus the memory is being protected from
leaking.

Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
 fs/cifsd/mgmt/share_config.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifsd/mgmt/share_config.c b/fs/cifsd/mgmt/share_config.c
index db780febd692..b2bd789af945 100644
--- a/fs/cifsd/mgmt/share_config.c
+++ b/fs/cifsd/mgmt/share_config.c
@@ -92,14 +92,14 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	while (veto_list_sz > 0) {
 		struct ksmbd_veto_pattern *p;
 
-		p = kzalloc(sizeof(struct ksmbd_veto_pattern), GFP_KERNEL);
-		if (!p)
-			return -ENOMEM;
-
 		sz = strlen(veto_list);
 		if (!sz)
 			break;
 
+		p = kzalloc(sizeof(struct ksmbd_veto_pattern), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+
 		p->pattern = kstrdup(veto_list, GFP_KERNEL);
 		if (!p->pattern) {
 			ksmbd_free(p);
-- 
2.25.1

