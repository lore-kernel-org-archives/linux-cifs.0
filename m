Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C678C7EE29
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 14:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbjEWOHX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 10:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237126AbjEWOHM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 10:07:12 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2726912B
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:50 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f3a99b9177so6333276e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684850749; x=1687442749;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZOtWVS1lCOxds2QCY7M+hAIKv6XvV3Hqis31ERV0mU=;
        b=jQFz6Zi2QlqzFhgg609+OdU2cVzXhTGama6kh7r3qdlPmt1t9W7hOhsu94u+OwaOb4
         qZCyO9HFjWxC1UNvj7aH4gjawmqX/FfvnrnEMqAdWBJ1gKgK3OsCh2be1l8goABkGeca
         4qq5vjGppvB0Ff3wZVKpQwbjqPgJrSjep7pLQRAqJ0vCR1bSNUwj/9E5GGjNWZG6UBIQ
         laVwoCR2Q+OLiyyzutCe6jstO9ARgNPtspYX4FMnjz5PkCuGHkQ+phxAPeufD6G8i1or
         2yIWRKaSDcAN6pWjBjwXMvm/DRKg3Ys05cggpxTJlPQbn2mQmxpWJNhzydJrgvcQ4AmW
         jBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850749; x=1687442749;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZOtWVS1lCOxds2QCY7M+hAIKv6XvV3Hqis31ERV0mU=;
        b=IMxAleINSpLn3ahpH1sGHDVnUM7aV+0axBS02Vbh4T0mxduhLgp8ep75pYXB5PPf3s
         NP4UKv6KWqGgt0lDVEhSMetvkqHjcVvWi+VrB7nBWYo4FdV3A7P1p7jqMMhwCaSlYxmv
         r+NopJkqqkL/rNRY/T4NVKa6hXVpBvsBjd9R2W19FsgTScBwiLbvDB1+yACo5h4zLEEk
         6Ge3GiT0Jb75qbz9m4tJiO+c76+3uKymRCiZStdmAJvifAS6d7GurkqKHsg0TFYjWLBz
         9FknRw1lbiVSW/zJsyqZekdajQIHAekR+2lHTpZ9imgZZQ/C22PYW6xi88Xol8Yw39K/
         o9gw==
X-Gm-Message-State: AC+VfDwfan5bXARiFEj6OcGS0hMBlMQJRjCFX5wY5V6RP0q0bkedTLS6
        Ppu2Ji9awGsRR6oEzC2vc7fL5lwVhFraXu3lfWE=
X-Google-Smtp-Source: ACHHUZ7//7IWxqZNm6Gka+LjfJMyuUS9SSINKAocHmPnom7yVCqmEeps0sj76NQaN9sPKxOw8HiGaQ==
X-Received: by 2002:ac2:593c:0:b0:4f3:b588:48d0 with SMTP id v28-20020ac2593c000000b004f3b58848d0mr3291847lfi.14.1684850749081;
        Tue, 23 May 2023 07:05:49 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id h28-20020ac2597c000000b004e9bf853c27sm1346562lfp.70.2023.05.23.07.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:05:48 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 May 2023 16:05:28 +0200
Subject: [PATCH v3 04/12] riscv: mm: init: Pass a pointer to virt_to_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v3-4-a16c19c03583@linaro.org>
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
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Ghiti <alexghiti@rivosinc.com>
X-Mailer: b4 0.12.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this in the RISCV mm init code, so we can implement
a strongly typed virt_to_pfn().

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/riscv/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 747e5b1ef02d..2f7a7c345a6a 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -356,7 +356,7 @@ static phys_addr_t __init alloc_pte_late(uintptr_t va)
 	unsigned long vaddr;
 
 	vaddr = __get_free_page(GFP_KERNEL);
-	BUG_ON(!vaddr || !pgtable_pte_page_ctor(virt_to_page(vaddr)));
+	BUG_ON(!vaddr || !pgtable_pte_page_ctor(virt_to_page((void *)vaddr)));
 
 	return __pa(vaddr);
 }
@@ -439,7 +439,7 @@ static phys_addr_t __init alloc_pmd_late(uintptr_t va)
 	unsigned long vaddr;
 
 	vaddr = __get_free_page(GFP_KERNEL);
-	BUG_ON(!vaddr || !pgtable_pmd_page_ctor(virt_to_page(vaddr)));
+	BUG_ON(!vaddr || !pgtable_pmd_page_ctor(virt_to_page((void *)vaddr)));
 
 	return __pa(vaddr);
 }

-- 
2.34.1

