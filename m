Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BC0C7EE31
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 14:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbjEWOGv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbjEWOGu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 10:06:50 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29051121
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:48 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f00c33c3d6so8693102e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684850746; x=1687442746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYHNj4xOB3A9+sRrGGyA+CHl8mr8r8wePJEdzxz75NA=;
        b=yi3hcBL/sMAfGA15PDa1P8NdEmww4HzJP2F/sUwI9IpWl8FAr9D8nzxcXs3kk9VZLg
         gqW+uTf0Quu6EKOMoBtewB5My0WXhMod0GC8z1ZbYL4s/yewGksiSDol/qQUkOAwxxUP
         tWgq8rOI0YG+2kzNAd6LFlZQnU/w/sUVfPTphub78KgJsbXLOjbr0epF5+oc5rNWTcLT
         4z9nAmfx1uJBTtHPDaWVenyL8i5pZQeTVRUJb52fjzXC6jarDxR7o0xXXXnUa9XVKQra
         c4l8ZCAV1hnrQiBJbDsUuYXenW29rw/An0d2CKxpWMKMbNQerNNefqEtiX0g0tIAPTZn
         73Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850746; x=1687442746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYHNj4xOB3A9+sRrGGyA+CHl8mr8r8wePJEdzxz75NA=;
        b=cQKIqM2goMGd/Bo/Ehj15ROckE94vVlBXkuUZIRGuZarssBSBlIEgrIlVqhbVtqQ3m
         8JmKtDCusPTBsnKkvE4Rf29WnAiu/MF3ybbaMHbW861w19agO0qBGVbK5Ja5932le1Bd
         1CF/KM/hglpk0hJ/fS+2ExR3RMUTee8zB+3MAgnIh2CsXywGENAspeDJ11CW4gT0FzjY
         GczaMZwN1WjGY3pS++fdE15KxlFIZwOXTsYVn3vm2HUC0wBmuib65F6vR4fAhGlzaMSH
         r710WiFnSYCM9g/NCAKhOn2oDxqf3iO0mUAJ86dquLhsrsAsOLE7I8Y8MCUqPPFqWkBl
         XwMQ==
X-Gm-Message-State: AC+VfDwL3mGguSvQo7m/De3eT/xay8jVObCKZiGOcoyMNnaRTq9T4Upo
        XoAPBtQFIm4KWPpw3NE2PqAZ418noxifxlGIhcA=
X-Google-Smtp-Source: ACHHUZ7rLgS3uJwWiogUeDYb0+CYWWtRVMpUMIrByqwxVk0kXBZ79wUE4ySYqYt+Mam8+eVWY8llcQ==
X-Received: by 2002:ac2:43a2:0:b0:4f3:a1db:ad4 with SMTP id t2-20020ac243a2000000b004f3a1db0ad4mr4313623lfl.66.1684850745735;
        Tue, 23 May 2023 07:05:45 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id h28-20020ac2597c000000b004e9bf853c27sm1346562lfp.70.2023.05.23.07.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:05:45 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 May 2023 16:05:25 +0200
Subject: [PATCH v3 01/12] fs/proc/kcore.c: Pass a pointer to
 virt_addr_valid()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v3-1-a16c19c03583@linaro.org>
References: <20230503-virt-to-pfn-v6-4-rc1-v3-0-a16c19c03583@linaro.org>
In-Reply-To: <20230503-virt-to-pfn-v6-4-rc1-v3-0-a16c19c03583@linaro.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@linux-m68k.org>
Cc:     linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org,
        linux-snps-arc@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The virt_addr_valid() should be passed a pointer, the current
code passing a long unsigned int is just exploiting the
unintentional polymorphism of these calls being implemented
as preprocessor macros.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/proc/kcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 25b44b303b35..75708c66527f 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -199,7 +199,7 @@ kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
 	ent->addr = (unsigned long)page_to_virt(p);
 	ent->size = nr_pages << PAGE_SHIFT;
 
-	if (!virt_addr_valid(ent->addr))
+	if (!virt_addr_valid((void *)ent->addr))
 		goto free_out;
 
 	/* cut not-mapped area. ....from ppc-32 code. */

-- 
2.34.1

