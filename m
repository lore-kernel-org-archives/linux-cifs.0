Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E0AC7EE32
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjEVHAv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjEVHAs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:00:48 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA5109
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2af30d10d8fso18026181fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738841; x=1687330841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2CPc/Vm/Ur0JOy8kF/L6fs0qWXc+VKBrwCqiZQE3hiQ=;
        b=NrzO6oCPjwihy/7NbpJ3YcgsArRc78cEfJMpT9F0OLcbOW2y8Fl22oTOY/WH+QouJU
         4sULmDBFIIZPjR6Mx3pJe8TZEIahkyyb7WkWsNTDeKsKYKrPJekLb/gD1GgHaIpqlCsj
         6QSKMiFR3KohhV92qLpgW0jRCS603xx3WtBCfv+WNRiPUwpuMiR+QiKd4LB4eBXFxrTl
         iNaMwVqg/f8wzqRqyYInLs1GFw2HsoBArqyOCLOOOtgD3dLXhiOQx5YrwSt21rFQERmE
         n4MTcZbVb2/vJmHdtmzbg4g68dyWgt0y911Ry3rDmEQOUhiC9fxEWLl1Lpop3daP//x6
         ClCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738841; x=1687330841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2CPc/Vm/Ur0JOy8kF/L6fs0qWXc+VKBrwCqiZQE3hiQ=;
        b=Sj5NlaKmGJDmgnSqBoSM6hbolCOiiS8No73Eaa0RqmGcmxoLtvAd+LLXheOLw2s9Kb
         SKpNJhNrT7F9MdPXSaVExGwSoUF6Wf+Mm/Lx0sQOGzddChuF3qSFIs0sLmk+SJRyjmtj
         C7+BfGW+8AN6qwHlvSmDaa7LJ7vm85y0tWxv7qyIhkadw+D3MytQLVGo0zZPyekRlyNF
         cYNIdRgAHgYg/2+Yjm+xJIO9nN/hHJjS8gX7Mm6ERFmTK60vQU7QMjUGBO3uWilYQBb+
         APn2bqkSH+E+YHBh8Dl81GCsIhxc0sXPsRVjYVEwrLC5cKtV6Z1zwUI5LgEzd1Rsswii
         aMzQ==
X-Gm-Message-State: AC+VfDwBpj35dSR/IVSlCbgbz4YY+ip/sC/IPso9B2U1NML2VlWJ13i/
        vy6oH7tUJD4BqqSz+vT2zFFWHg==
X-Google-Smtp-Source: ACHHUZ7S6IGy02Ukp+GH6s4VTX+htMdSS2munmak/B09B+vgiuI0xUdVH1qun2fIij9DEbd2Ufrt5Q==
X-Received: by 2002:a2e:9115:0:b0:2a8:c42f:6913 with SMTP id m21-20020a2e9115000000b002a8c42f6913mr3287059ljg.36.1684738841185;
        Mon, 22 May 2023 00:00:41 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:40 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:38 +0200
Subject: [PATCH v2 03/12] ARC: init: Pass a pointer to virt_to_pfn() in
 init
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-3-0948d38bddab@linaro.org>
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

Fix up the offending call in arch/arc with an explicit cast.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arc/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/mm/init.c b/arch/arc/mm/init.c
index 2b89b6c53801..9f64d729c9f8 100644
--- a/arch/arc/mm/init.c
+++ b/arch/arc/mm/init.c
@@ -87,7 +87,7 @@ void __init setup_arch_memory(void)
 	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	/* first page of system - kernel .vector starts here */
-	min_low_pfn = virt_to_pfn(CONFIG_LINUX_RAM_BASE);
+	min_low_pfn = virt_to_pfn((void *)CONFIG_LINUX_RAM_BASE);
 
 	/* Last usable page of low mem */
 	max_low_pfn = max_pfn = PFN_DOWN(low_mem_start + low_mem_sz);

-- 
2.34.1

