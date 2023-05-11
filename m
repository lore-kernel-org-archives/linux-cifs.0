Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94110C7EE22
	for <linux-cifs@archiver.kernel.org>; Thu, 11 May 2023 12:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbjEKMA0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 May 2023 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbjEKMAB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 May 2023 08:00:01 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4749055B3
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2ac88d9edf3so80973461fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683806390; x=1686398390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AULvzv+57dD5HpSWPkpxyceRhii29y9Rzv9p/7gtLz8=;
        b=soo7gel61xLJPPvWmBpSRpISycpQ4XMSOLDpuxsIg8UcYukLYcg7kMmXk/2zJzG1nW
         dsU8I+b6+EeJC/RPFjsri77SgRQ6hq2riwqwbxPxb9BPmFrHaOXA8XlBqwiqx0GubS/i
         Mhuqa/PtIduAVK1dEpaA3MpUlLbL32Xbmw+sH+jktUlv+lmF4kpGzKSikAVGP0VgKPOp
         YCj4v5oEg1jhayDSX8iKc90tIlislQLi37GCRWiSDvFSwFEkSlw0s6Y42ltaRe+/B46x
         HB3CKfzsllSPT5KE0DczkqM0Ns6TrGXqPqX3xl8eTKyXRx+KvTrVcbjwXkVi5//X0Zuv
         BYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683806390; x=1686398390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AULvzv+57dD5HpSWPkpxyceRhii29y9Rzv9p/7gtLz8=;
        b=aQ+xUUC8NunlOWebS4Kde4e0xHzk4abrNyZFRHwebWME+5wK7vz73rJk1z+P3V0j8U
         0OuQcD+601uMBGFHqe7pccGZM9TPjHtpGWkZaUFVizqmU94P5W+oA4QiXAneCwyWZezB
         hrePv2MiAvcggartvkx1xdt9EdUBoKmdnrVyOAgwy8nMjJ+Ka7Ie7cFVo4s+75eaxfp4
         Ckx96UXpn5r8Lt1v+UQdU8P2jwDc+hHAly701dcTXmgHauPCv6N2ziYm/fYt3TQFsUMh
         4l1sbZ1j15zqM/55qv226pEUzYRYo5gPplIOzQFv2hXEfecQMgvJo0UaTcWWVu3VLTaB
         kb7g==
X-Gm-Message-State: AC+VfDxZhQGJhlaHRZ6gBTVqaTMjd2qen8GTQrM32gOXKnoQb88x2L4n
        fgAzaSFkF6ViI0x3GrLdMQ/z9Q==
X-Google-Smtp-Source: ACHHUZ4YcTu6FF7odIThWKYfIjWHhaQ1ovlMhVuhR/qJ6RT8psLdgX3PwvbGJutv6zmhIytcpYTEfA==
X-Received: by 2002:a05:6512:3744:b0:4e7:dd1e:e521 with SMTP id a4-20020a056512374400b004e7dd1ee521mr2323684lfs.9.1683806390306;
        Thu, 11 May 2023 04:59:50 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id f16-20020ac25090000000b004cb23904bd9sm1100841lfm.144.2023.05.11.04.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:59:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 11 May 2023 13:59:21 +0200
Subject: [PATCH 04/12] riscv: mm: init: Pass a pointer to virt_to_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v1-4-6c4698dcf9c8@linaro.org>
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

Functions that work on a pointer to virtual memory such as
virt_to_pfn() and users of that function such as
virt_to_page() are supposed to pass a pointer to virtual
memory, ideally a (void *) or other pointer. However since
many architectures implement virt_to_pfn() as a macro,
this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this in the RISCV mm init code, so we can implement
a strongly typed virt_to_pfn().

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

