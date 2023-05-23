Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EF4C7EE23
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 14:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbjEWOIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 10:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbjEWOHN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 10:07:13 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3620BE45
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:56 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f3edc05aa5so3196240e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 07:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684850754; x=1687442754;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDtU5Jqmt1rhTrWGvrFpFNAhujSWuurCg4wxa03/anU=;
        b=HpmD5IFXXBYh79hB/QdHKbKxuFRZSDMi4b5OZGTylI/XbzqUU0nz4W2BvN6yvKss7I
         K1cwCwlsNLZKWtwDIbEgnBIwLeSRk9MusgogzqpLIGkeV6I3IpHf5ZImCV1dO7TmBmQd
         Jxo5lBjORGSyxFQpYfuSMr3vb6XHB27JbLUYvAKRm5hN6Vx2cqGdrc5nBtxembJzIGb+
         XkA5TOH4FTAGjGGX8LhKx2vDYw5pSIfYWUjWXmA8zVjBOfrxf/vDnuKaKLU2/n/3jNel
         W+4yMbxUSUGgrAJBjS8Un11ko0kSEr5ibGVEHRlBzUWYgh4gIdzzchv9ZLkOCYx4CEzT
         1cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850754; x=1687442754;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDtU5Jqmt1rhTrWGvrFpFNAhujSWuurCg4wxa03/anU=;
        b=O4E0J57Qm4C4u8pTGE8ilUNQDFMJ6jSoUUyrjFfKn9p6+6W2lkc9bLIEHoqEe68UDh
         b0pzVEHCxQY3lbS+3T3Ij9EPkNrnEdQOhN0q3+OXwjR4C4PsuT2iLr3t2sSl34rfuCzm
         EztdciyNh2BvkjlaZl5oPE5cFSiBI0JlP2qTtmAqE3dW9NNgIadYL+LlEvOg26kkHZY5
         a3U8chmUGexC7+5ft+GGoBqecbnkjRY5khUmRJL9KCTxD6u+UefcQy4vfnQ5YDD2hVn2
         De3kxyv8O/ZnM0BTG4VOHbWnBNcRw6PKWrQpg9iEHAnwTRT5uZ2W/byDh48IhzGCADwI
         Py0Q==
X-Gm-Message-State: AC+VfDxlmWfAd4jO7i9K+KseuEBlTg4rH6SjbfpVrFGI/0y1rOglVJAx
        STU24W+XiAkgYJ1LSJngy7onkIqlF4nvBHHCI3M=
X-Google-Smtp-Source: ACHHUZ7lHZmUmrpa6AszHCZQHgR8jjoC1zWdiC0X3jOoWePtInb6ZlpLCgb3B/kHs0cj9MvDG7f8Ew==
X-Received: by 2002:ac2:51a9:0:b0:4f3:b9bc:9d68 with SMTP id f9-20020ac251a9000000b004f3b9bc9d68mr2955818lfk.18.1684850754250;
        Tue, 23 May 2023 07:05:54 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id h28-20020ac2597c000000b004e9bf853c27sm1346562lfp.70.2023.05.23.07.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:05:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 May 2023 16:05:33 +0200
Subject: [PATCH v3 09/12] asm-generic/page.h: Make pfn accessors static
 inlines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v3-9-a16c19c03583@linaro.org>
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

For symmetry we do the same change for pfn_to_virt.

Immediately define virt_to_pfn and pfn_to_virt to the static
inline after the static inline since this style of defining
functions is used for the generic helpers.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/asm-generic/page.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index c0be2edeb484..9773582fd96e 100644
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
+static inline void *pfn_to_virt(unsigned long pfn)
+{
+	return __va(pfn) << PAGE_SHIFT;
+}
+#define pfn_to_virt pfn_to_virt
 
 #define virt_to_page(addr)	pfn_to_page(virt_to_pfn(addr))
 #define page_to_virt(page)	pfn_to_virt(page_to_pfn(page))

-- 
2.34.1

