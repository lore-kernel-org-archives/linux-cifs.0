Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391A8C43462
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 026B7611CB
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbhDASEJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbhDASAm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 14:00:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFBAC0613AA;
        Thu,  1 Apr 2021 04:39:42 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x7so1479901wrw.10;
        Thu, 01 Apr 2021 04:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=uG5kp6AR60MZkAQXLptUHPA/6zNjsruLGdIq/mc434k=;
        b=rB7/nuCMTPXj9vPzc0ILrIRFRTkz8wShlmfJ1IHage/FeP0jSqbFrzvI9w7/qOXlEg
         bfdH/0PB6bmNkBbzGKCw27lJ9Qxj1aOM1QWJ3YN71KSd6J2V7TKh2ZiNYUDKvHJWAbHk
         /FjE/wVgaTVUYYMuc6MQruk7vAEQAVdkxqu/cU1hxRbM0icTENPIYgxA8RtcEOEOrtHH
         WRwR3F2FGR51SwCsvk50SPkURNbfpnRGZ1fc9o0OPNBhWFzMFpOD64z7t2YYcp14hdPW
         kTuluLXNjFLY3YrHwE+cGOIH6ihFEDXuwyw/Z3TBS1U5i/SUGE21LG52mt7AGmkgAnYa
         jPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uG5kp6AR60MZkAQXLptUHPA/6zNjsruLGdIq/mc434k=;
        b=RVC+SSxQB0oykGHgQ1roTThaNz/7uA47bmhMbihj1nc5XUXmxbyXxk00eFp9I1xxwM
         VVC/M7lnGgZuNBWWWJEg7fGV8rAhPIhMO3uCfFAavcgcV/75v/fsRZKiXXNWFZvm8bPt
         v7DCqCl6CvMvSHe7aabaoBvSfI+rrXm24P4bVcz+lMYe6+Ntw/UAYDVrSFTGhFijditC
         vPsfelAH3RkzpA6Nb0ZUEPmH5RkG+KIS3KJjuf7orOJ1VGAMDqfyTSXxUqEj9rnIUNCf
         sDl222nroXoaQe6QiWodR/zBcmr9PLYSXjh71ERY8wv6tTEplE1PxPKGU/QAN/rCSm7Y
         ov9A==
X-Gm-Message-State: AOAM531PjeaU0IOgNvb73KY0CAYOBZlnPTa+nkH7mkd2CKstNj810nv3
        8AHvmewLyJiSA9zLOY+0bhg=
X-Google-Smtp-Source: ABdhPJygMOyjnxpej1Bdp2/XSZz306Cb4NzhLPK4Ay5aPBRHLLgTLLYCEMdDowWA2/OHpeEHI2rMuw==
X-Received: by 2002:a5d:6d05:: with SMTP id e5mr8834723wrq.324.1617277181341;
        Thu, 01 Apr 2021 04:39:41 -0700 (PDT)
Received: from LEGION ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id b15sm9292185wrx.73.2021.04.01.04.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 04:39:40 -0700 (PDT)
Date:   Thu, 1 Apr 2021 16:39:33 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, open list:
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, colin.king@canonical.com,
        dan.carpenter@oracle.com, ;
Illegal-Object: Syntax error in To: address found on vger.kernel.org:
        To:     ;
                        ^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Cc:     musamaanjum@gmail.com
Subject: [PATCH] cifsd: use kfree to free memory allocated by kzalloc
Message-ID: <20210401113933.GA2828895@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

kfree should be used to free memory allocated by kzalloc to avoid
any overhead and for maintaining consistency.

Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
This one place was left in earlier patch. I've already received
responsse on that patch. I'm sending a separate patch.

 fs/cifsd/transport_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifsd/transport_tcp.c b/fs/cifsd/transport_tcp.c
index 67163efcf472..040881893417 100644
--- a/fs/cifsd/transport_tcp.c
+++ b/fs/cifsd/transport_tcp.c
@@ -551,7 +551,7 @@ void ksmbd_tcp_destroy(void)
 	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
 		list_del(&iface->entry);
 		kfree(iface->name);
-		ksmbd_free(iface);
+		kfree(iface);
 	}
 }
 
-- 
2.25.1

