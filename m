Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C7AC7EE26
	for <linux-cifs@archiver.kernel.org>; Thu, 11 May 2023 12:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbjEKMAx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 May 2023 08:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbjEKMAX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 May 2023 08:00:23 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBEC7D82
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f13d8f74abso9600351e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683806395; x=1686398395;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ldVw9wlzEkzEKLn5PMVleGqWnYMQxC7MlxWwEOwXVk4=;
        b=sersNdtzW5iLzGVupNMmSJvBYmwrZ//xZBxoOUDkXI1JTW4CI6ctj4FhudGratDn9k
         cRnkGze5UhsFvb3lR7Z7ykzxMMc0MSELwIy7erx+30m7guaXslAKu512vsaLide2fBN8
         bzO6LMr/4P01YQk5JchLInzlvvtZaYnfs9CHAIEYLUvt9rNDqzoX36kf+ZRPAeMUF63R
         CCLsu72Nt/qnplWuj/eGGivCt82mEPHLpvvAQfOpT7G7x9ZKs78aN4p4kFH/Q3ORHnfo
         F+xP25avZTDsQROtfUVMJN8MesmV4EWv4hDtLKEn2U2w6S7bTHItXBK0WvgvggA3JEzW
         4KRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683806395; x=1686398395;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldVw9wlzEkzEKLn5PMVleGqWnYMQxC7MlxWwEOwXVk4=;
        b=ZZ/BqdeXaDk6MvZlMmauGNejTcqO4HJxHg/B7LKQynw4Gdc0slM97bR+jAoZtMNGGI
         CQo+A396mptixJswPXMP3KFMu3zv73geC9hpI8h8iU3VcueX5AavQgkSprtSi+QGBJU/
         392QzoRjGqe0kxYN6R6YK9njppJAmMs4r5XAfxbLPm6vy9c10xqR/UwhxwHYqsxpb0u1
         iBD87RaXPiFaNXy6T7znDM2Skrl0iC8BOylSDC2Le+qq+snC5GonU2y3n95WCW2Fg1BO
         dL7IaxjlPOzoDsoL3i17i2jSLk7TxNAAj6uJt/G14l8WuUozpw65WLAwamM9bjZ7YkUM
         Vfiw==
X-Gm-Message-State: AC+VfDziIOqJBWpXaWnRYfsF6Pn6P3A1u4i4EE1NbqopDdbsZBA4qHIe
        69si7G5S5Vi6Ep74TyI2OURnVg==
X-Google-Smtp-Source: ACHHUZ6cUHNYU0J4SZMS7pZsEER32rUvhWP5SmpZGGTwBMJBiTrayLkP7UYjW+7FVQQ8Tu7K7BVxbQ==
X-Received: by 2002:ac2:5339:0:b0:4ef:f725:ae2f with SMTP id f25-20020ac25339000000b004eff725ae2fmr3438930lfh.37.1683806395538;
        Thu, 11 May 2023 04:59:55 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id f16-20020ac25090000000b004cb23904bd9sm1100841lfm.144.2023.05.11.04.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:59:55 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 11 May 2023 13:59:26 +0200
Subject: [PATCH 09/12] asm-generic/page.h: Make pfn accessors static
 inlines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v1-9-6c4698dcf9c8@linaro.org>
References: <20230503-virt-to-pfn-v6-4-rc1-v1-0-6c4698dcf9c8@linaro.org>
In-Reply-To: <20230503-virt-to-pfn-v6-4-rc1-v1-0-6c4698dcf9c8@linaro.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-snps-arc@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Making virt_to_pfn() a static inline taking a strongly typed
(const void *) makes the contract of a passing a pointer of that
type to the function explicit and exposes any misuse of the
macro virt_to_pfn() acting polymorphic and accepting many types
such as (void *), (unitptr_t) or (unsigned long) as arguments
without warnings.

For symmetry we do the same change for pfn_to_virt.

Immediately define virt_to_pfn and pfn_to_virt to the static
inline after the static inline since this style of defining
functions is used for the generic helpers.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/asm-generic/page.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index c0be2edeb484..e8ef12bb858c 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -74,8 +74,16 @@ extern unsigned long memory_end;
 #define __va(x) ((void *)((unsigned long) (x)))
 #define __pa(x) ((unsigned long) (x))
 
-#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
+static inline unsigned long virt_to_pfn(const void *kaddr)
+{
+	return __pa(kaddr) >> PAGE_SHIFT;
+}
+#define virt_to_pfn virt_to_pfn
+static inline void * pfn_to_virt(unsigned long pfn)
+{
+	return __va(pfn) << PAGE_SHIFT;
+}
+#define pfn_to_virt pfn_to_virt
 
 #define virt_to_page(addr)	pfn_to_page(virt_to_pfn(addr))
 #define page_to_virt(page)	pfn_to_virt(page_to_pfn(page))

-- 
2.34.1

