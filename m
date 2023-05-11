Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFD7C77B7C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 May 2023 12:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbjEKMBR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 May 2023 08:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbjEKMA0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 May 2023 08:00:26 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCCBAD07
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:59 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f13c577e36so9471917e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683806399; x=1686398399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHjA668SX6CTsxzYO8Z8nc4Ecy//EJfwtQFWj2t6kqU=;
        b=Kbc555pcdKJLogrS9D2fpTuZbCLYtRRslUUmtE3xLf7EzdNZYf1OzcE9wV1Z90iGk3
         NIk4MKV6b+X0k2N3VL5lQ56i9UXtaetINfk3JT4UgzFD7yBuaWIOfZWXEKT5PzupCvP/
         bamqIQqMgGCRriAPRj2xemXl7nSVYfhgFkSm0NP8XdgPgFP+JDpOUwXIwzQsFylS4IVi
         tfsy8c7iyORHTNygYljmk4DBR7XlBqGcbH84OblELC60Ek8nQDNUr7Skn4YvyNLuLFxu
         E+aTQ0Z1NbLg7cPj3DH6p8fVNfeCCf6YY3IJLOUYGk/XToeDr9UU3eGzOCWV1mI1abGA
         My9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683806399; x=1686398399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHjA668SX6CTsxzYO8Z8nc4Ecy//EJfwtQFWj2t6kqU=;
        b=B+4L7AaODYoYmqSjoo5DWX1h0u0+fHLxBDHZklUGEnvXE60r3/jBsApkgFqfS1jGWo
         cguQk7wVPdZHEu4o5Jpunfy/JtGLc2AJg5pNr5u09IJiN/1kZzOT8oDT5nllVwn7RLCa
         ieryKDp/954w+9VLj8MZuENPJnwc7VtVfzH4lse9pV/8Aw2XWkOqsoBrWTSc44UbJZnQ
         E0mIILHDtExZLhp1Aiwdvb7R8Ey9IBN1qoNQeDAaDi+nyGEMayyqFQ5CIJa1TNBDBvcC
         qzRDvssW30L+bYtOx3oAyweZ+xE9d9428oVT3GvOVCv+aEVyEHjxY1qD86o9cEpC3Iuy
         imGg==
X-Gm-Message-State: AC+VfDzIklrorkoCUXg9MdMQb2JtMVJMhOFsaISGbQ6IvQZxtr6yIngo
        xCrE6GIRm0kyCgt8MitTDj5ZRQ==
X-Google-Smtp-Source: ACHHUZ5Tk4UWnqnRlmgGPDZhdIZdZccQAMG3sQLb+3VXhq0OP50ACPtrgCCvBe8ZpLc4O18r3rteNw==
X-Received: by 2002:ac2:4e51:0:b0:4ee:e10f:8e5d with SMTP id f17-20020ac24e51000000b004eee10f8e5dmr2439363lfr.4.1683806398938;
        Thu, 11 May 2023 04:59:58 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id f16-20020ac25090000000b004cb23904bd9sm1100841lfm.144.2023.05.11.04.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:59:58 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 11 May 2023 13:59:29 +0200
Subject: [PATCH 12/12] m68k/mm: Make pfn accessors static inlines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v1-12-6c4698dcf9c8@linaro.org>
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

For symmetry, do the same with pfn_to_virt().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/m68k/include/asm/page_mm.h | 11 +++++++++--
 arch/m68k/include/asm/page_no.h | 11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
index 3903db2e8da7..40bcc6aa33da 100644
--- a/arch/m68k/include/asm/page_mm.h
+++ b/arch/m68k/include/asm/page_mm.h
@@ -121,8 +121,15 @@ static inline void *__va(unsigned long x)
  * TODO: implement (fast) pfn<->pgdat_idx conversion functions, this makes lots
  * of the shifts unnecessary.
  */
-#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
+static inline unsigned long virt_to_pfn(const void *kaddr)
+{
+	return __pa(kaddr) >> PAGE_SHIFT;
+}
+
+static inline void * pfn_to_virt(unsigned long pfn)
+{
+	return __va(pfn << PAGE_SHIFT);
+}
 
 extern int m68k_virt_to_node_shift;
 
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 060e4c0e7605..f1daf466a57b 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -19,8 +19,15 @@ extern unsigned long memory_end;
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
 
-#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
-#define pfn_to_virt(pfn)	__va((pfn) << PAGE_SHIFT)
+static inline unsigned long virt_to_pfn(const void *kaddr)
+{
+	return __pa(kaddr) >> PAGE_SHIFT;
+}
+
+static inline void * pfn_to_virt(unsigned long pfn)
+{
+	return __va(pfn << PAGE_SHIFT);
+}
 
 #define virt_to_page(addr)	(mem_map + (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT))
 #define page_to_virt(page)	__va(((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET))

-- 
2.34.1

