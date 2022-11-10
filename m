Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593C8C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Nov 2022 20:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKJUa1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKJUaZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 15:30:25 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D1C38B1
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 12:30:24 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id bp15so5254161lfb.13
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 12:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQak/QQ0xC19lyj04tZJmGDoGfCaC6exeaUD1M1fKWc=;
        b=LsamcuxSTCuqFhrR4UsHiLxWRPB/ff6rlV6xAUe9vD2I9pc5kaj22PVtQmiRPcvYyX
         LRc8cNt+hSY4Hj7pEOyi+5bMUPL5zIPuUULHvK0jVMGo4YcksV0TtpPUbVbw+0HP+LAD
         bYex7YQ8qFz7ARXO1digViwuiI3/rNyR3njK9UvLK9kMqEvbnoIn6jSlmyJL7fsfF7Qt
         IEG4G3Shv48uzk8GB/VTALcfDIRwKTp6s7aud1Mfwbxy6Edo46K3rP5sZb7dPyFKg52f
         lmr5yAnZJeHvKwLy1d2Q6CSr/sRT8m16qlsAhRZ86aDiQwRvgeVhM3ALQOS87OhgNaFs
         pYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQak/QQ0xC19lyj04tZJmGDoGfCaC6exeaUD1M1fKWc=;
        b=oGI3Pq1OtcOUZcmTqG7FrEGy1oRHUqN1X84b5bm3+0glfFYo74qdiUY1+EgOwpN+qs
         xyb/YLNhNCa5T6vVH21zJ6ir6i5/NvXloFpBjA2mqBGVkrzmnVXcdo/mbHiKgsNfC8Io
         6u6TrPpf06Fn7kKzVC46fOMSOoREJRU7y7c9WySE6QyOyhMLJRjsJSAm9WpzBRsxCkty
         T8iMtiv3DDQ+ufm0GGmMaprRApXeio10nhymlFAeUlejr7+oGR1WeBBS57HqLV/ONdMP
         +ItlCn/eQENpqIjwuZrQ5QlUjdG8sGJuEwcz25U6P2ewPEdp7ZDY/PLLhwcquLnB1pW/
         iVwA==
X-Gm-Message-State: ACrzQf0rMtQlyw8EVMLNQjlNN4likpHRCBwOYeb/xuiGvgpgt9IbR8qT
        0m+WQqQBBctVWZn8UBLBEcKfM91UDeS0TGaePw8=
X-Google-Smtp-Source: AMsMyM5eio0XLR+Hz5mnJkxVkD0MmdVs5E/MvC9gaqzhBbX8RSpyvWOryVh9fBlShqWffxWAPjlMY9usir1TbjrFM30=
X-Received: by 2002:a05:6512:2588:b0:4af:eabe:dbf5 with SMTP id
 bf8-20020a056512258800b004afeabedbf5mr1770012lfb.668.1668112222843; Thu, 10
 Nov 2022 12:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20221110111939.135696-1-liujian56@huawei.com>
In-Reply-To: <20221110111939.135696-1-liujian56@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 10 Nov 2022 14:30:13 -0600
Message-ID: <CAH2r5ms6p4_PdihrLC+ZJ4W=YjqOmwYhDT-fF6swZ5SB0fP4Ww@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: use kfree in error path of cifs_writedata_alloc()
To:     David Howells <dhowells@redhat.com>, liujian56@huawei.com,
        ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The kvfree vs. kfree wasn't obvious to me

Is this just a "it's cleaner" patch? or a bug.  I thought kvfree will
call kfree in this case as mentioned in the link below

https://patchwork.kernel.org/project/dri-devel/patch/1447070170-8512-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp/

---------- Forwarded message ---------
From: Liu Jian <liujian56@huawei.com>
Date: Thu, Nov 10, 2022 at 5:14 AM
Subject: [PATCH] cifs: use kfree in error path of cifs_writedata_alloc()
To: <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
<sprasad@microsoft.com>, <tom@talpey.com>, <zhangxiaoxu5@huawei.com>,
<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Cc: <liujian56@huawei.com>


'pages' is allocated by kcalloc(), which should freed by kfree().

Fixes: 4153d789e299 ("cifs: Fix pages array leak when writedata alloc
failed in cifs_writedata_alloc()")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cd9698209930..9a250fee673f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2440,7 +2440,7 @@ cifs_writedata_alloc(unsigned int nr_pages,
work_func_t complete)
        if (pages) {
                writedata = cifs_writedata_direct_alloc(pages, complete);
                if (!writedata)
-                       kvfree(pages);
+                       kfree(pages);
        }

        return writedata;
--
2.17.1



-- 
Thanks,

Steve
