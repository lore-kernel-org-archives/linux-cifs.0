Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C33AC7EE23
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 14:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbjEWOIR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 10:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbjEWOHX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 10:07:23 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ABFE5A
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:58 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f4b384c09fso2310231e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684850756; x=1687442756;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=721W88MgL2sNJMPnk6EOnDreN0TGHiKcLljkK4k+Xz4=;
        b=fzeFctH+wspWO49TnIPElwVca6DLjWLQwYxkWmX/Iy1UmULCTqkJMiM0qA8MXZ/96E
         Dtzvq/Nx1wNuktXBNrc7rb+BddK3eOpeRmaIEM+nRheV+Bmapv0H53LUZOJqTGNjV3bP
         zWDe7Noi+kppHqm/7HwhlAvjZPM0NdHk76Cr/uat1pZJDm0mz4HCGb4uRkPCQwNqiDYu
         JW0aKwNZrkes49GmhKEiOFOCDjns4pmVJcNZeTw7Y/+UpIuTv7ewPTXRg18mgR0J2Qx3
         I7hqjEkHLpYieL/NE9aRDNlp28sfW4e7RnZIt0ZnBTCL9b1MxLrV2Xk0Mrq3ZmPvUUoO
         qQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850756; x=1687442756;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=721W88MgL2sNJMPnk6EOnDreN0TGHiKcLljkK4k+Xz4=;
        b=QJfbcU4PN0WRJc0i4KONwNvHVtCJu78MqE7j6APup0sCgZeFAgJ2wK78Ub/fZBx3UY
         BUpUR8eaTmzJxQJIXj2u6wXsrzhFD6MNzLmIo9F2zUI+WU7/sePwrmDgDkAaX56UxE7V
         DOrgZtoUXQ4m3qUNfg2qAhtA6ncJj2ibiZ2Dvhh8+7Ssy+BV5mEPQFwnLxEsqUBVmPyd
         ro3LE0t3AXFfh3/PGqHQ3GNz7mBr+UOL7L4XMbtIoY6Uz4VYcLL2aqXMvvGE4AAu/wpW
         1ehec2qlGQ0OpAhdvIoqqM9mGSNVHlAR4XFAU5T6g9gxmmlaD11ZyHrUAZk2Y6vWNT+a
         bxGQ==
X-Gm-Message-State: AC+VfDxggh+WGU4x/MTlLXbufmeZDoOzfINLINsYEz7chAdiA7rKqk+E
        jt4+f/YAF0ylppvFakjMLK3X/kmJb9zUGm9b/Fs=
X-Google-Smtp-Source: ACHHUZ5UFM6na3wkD054/zYIWV2BKg/wO+VAD3UUEzInrp7pevvoaoeYweWFaAj8kQad51xlmVIoxg==
X-Received: by 2002:ac2:44c8:0:b0:4f1:b3ab:cd61 with SMTP id d8-20020ac244c8000000b004f1b3abcd61mr3958413lfm.61.1684850756424;
        Tue, 23 May 2023 07:05:56 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id h28-20020ac2597c000000b004e9bf853c27sm1346562lfp.70.2023.05.23.07.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:05:56 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 May 2023 16:05:35 +0200
Subject: [PATCH v3 11/12] arm64: memory: Make virt_to_pfn() a static inline
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v3-11-a16c19c03583@linaro.org>
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

Making virt_to_pfn() a static inline taking a strongly typed
(const void *) makes the contract of a passing a pointer of that
type to the function explicit and exposes any misuse of the
macro virt_to_pfn() acting polymorphic and accepting many types
such as (void *), (unitptr_t) or (unsigned long) as arguments
without warnings.

Since arm64 is using <asm-generic/memory_model.h> to provide
__phys_to_pfn() we need to move the inclusion of that header
up, so we can resolve the static inline at compile time.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/include/asm/memory.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index c735afdf639b..4d85212b622e 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -331,6 +331,14 @@ static inline void *phys_to_virt(phys_addr_t x)
 	return (void *)(__phys_to_virt(x));
 }
 
+/* Needed already here for resolving __phys_to_pfn() in virt_to_pfn() */
+#include <asm-generic/memory_model.h>
+
+static inline unsigned long virt_to_pfn(const void *kaddr)
+{
+	return __phys_to_pfn(virt_to_phys(kaddr));
+}
+
 /*
  * Drivers should NOT use these either.
  */
@@ -339,7 +347,6 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define __pa_nodebug(x)		__virt_to_phys_nodebug((unsigned long)(x))
 #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
-#define virt_to_pfn(x)		__phys_to_pfn(__virt_to_phys((unsigned long)(x)))
 #define sym_to_pfn(x)		__phys_to_pfn(__pa_symbol(x))
 
 /*

-- 
2.34.1

