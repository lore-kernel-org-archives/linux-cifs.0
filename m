Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFADC7EE2F
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjEVHBF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjEVHAt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:00:49 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8AC119
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:44 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af2f4e719eso20343831fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738842; x=1687330842;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZOtWVS1lCOxds2QCY7M+hAIKv6XvV3Hqis31ERV0mU=;
        b=HPynyF9dBnm8kzZsPMGuzG4tGQ0wQ3Xr3WZ6xD7T/LfVcLe2V89yhp9749clY9crPm
         qG+Ir4rpDSBK6txtleKSHHAoDkcHodUiVZEGspM78lo5oN/1e608teWeY9dzCA81mmGY
         3yD/wym5h4WqSG+LrMozqn4fKUqn/qUP59x8v5zFk9cHktPKlbrYTkPbim+gsAhI7K0m
         5w8V6qXvcsdSkuS2CIyEV8/smObrHzuoNcRONSSEORXDMznpyIH08pgdb9ej7EcewhPn
         nAN3lOIxQfwpuzpgrFnVMITkhgAvyIakdv0L6ph868VTBX1lS5f2Q1HzQjhTiA+la9hW
         2/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738842; x=1687330842;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZOtWVS1lCOxds2QCY7M+hAIKv6XvV3Hqis31ERV0mU=;
        b=fFt1lIpam+lYPTwUKRBJPGjIbsky4N8Moh8/WGniTHRyxmvdY5N56a6J5qt+KuS6D8
         GZrvL2YNSN1AIsBiFOdg9UiLFNYIxif+uzMG9sp76EbioF76RafsH6BbmK8wMP/Q2kY2
         tV8nXS93kCgMTvEkd1teA9qX9gTwK8fYKEli/cp+jsq3m1tHD5FU2qNs8bH9jh8Z3avV
         iba4c/68Z82plXPHVfLMgDfUXcKb+jLn1po0C4oeABb7khuSsKJqRT/Ova6zNhTyYKwb
         PGiiZK3KsFduVTsL6k2WLl2gSGNfTejBipb5OaeG+8gr/RFnim5Sy7ndEitVdcv0nCyH
         qqnw==
X-Gm-Message-State: AC+VfDxNm4zZmSTe5fUmuhJNZ8ajJCKAsc/0JZopzgb2iUBjyRElf8vS
        3zE3hDsfkmVqgNJRBMDIZHvksQ==
X-Google-Smtp-Source: ACHHUZ5zHTlDIUBFfM+ANh6yrJchD5XWnUCxgGUoFmdvR1n+C8XuEEFdLcvym28BDAgE2gGiolXH+A==
X-Received: by 2002:a2e:a40d:0:b0:2a8:bd1f:a377 with SMTP id p13-20020a2ea40d000000b002a8bd1fa377mr3256924ljn.20.1684738842484;
        Mon, 22 May 2023 00:00:42 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:39 +0200
Subject: [PATCH v2 04/12] riscv: mm: init: Pass a pointer to virt_to_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-4-0948d38bddab@linaro.org>
References: <20230503-virt-to-pfn-v6-4-rc1-v2-0-0948d38bddab@linaro.org>
In-Reply-To: <20230503-virt-to-pfn-v6-4-rc1-v2-0-0948d38bddab@linaro.org>
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
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
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

