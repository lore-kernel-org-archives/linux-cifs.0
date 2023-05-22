Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17CAC77B73
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjEVHCH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjEVHBE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:01:04 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB74109
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2af1e290921so43966031fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738848; x=1687330848;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDtU5Jqmt1rhTrWGvrFpFNAhujSWuurCg4wxa03/anU=;
        b=EgeeaYxHiw9wjOAGc/5G+LN0c3KUHNjvlMLN8uS8AnOgASES7fyW/rsQOHqr9DJIm4
         Q8pNdnQ8gVkoZSj/+upHrsi/tavYgOTyzBUdlAtcr2Kh9ffmMPH4gQgxiD9jwMMKDMI+
         CuKr2WQEU8br9TaFssSRKesDxf+IahbGC5Zx0cbDL1B32MIMmQqJEpul0X/k5OkwgL/p
         biyoDSbwAxtoAdQjplEuS+uPbUVkhGZwVNA6jM4DVWvLhyshkUq3uEnshyu8D9Pr1j1Y
         dtZh4qZurb2FlkyA/lCRl9W6OQ/h4jDhIaJlJh3cxPH3CVc6wzd8qQhjtgUMnfkuf6pl
         /E1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738848; x=1687330848;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDtU5Jqmt1rhTrWGvrFpFNAhujSWuurCg4wxa03/anU=;
        b=hyQhhEczZLNYuQTZefK0mAcQFIHOsaZoUdpjHuaDLXKioXM+iA+uczMF9xtaKiHlQk
         hv7dAW9GZdaQ8zrEGR0p6QUfR8AMCXQE/ufPH1uPTxuROw9MhlCv/fjfFHuXMVJ7Y7y4
         tmKDKfEdgU+saUoEakrOsX8KL2nCb33gQi7WNeana8N7P0vyRfnmb2hwbzn7Y+O8lBdF
         75uRGX8qQaCMsHs3/ClMLBCXttFKRiO7lxZFZOuvV2pCN0N7MVIxKgtgX08QF6t7AYlz
         KRDkYwC3hJU4lXsMOcOC5loO5XbWAP8fFB/H/AlihTXG3e8qVlp87XwQ4LEXLYmmVxdd
         ly3A==
X-Gm-Message-State: AC+VfDznzaeZc2v3trATZx2LSjIk/t3wWmNL3Vry5FekLccb93Xlbwbw
        i7JoP51M84Au/8qic8MvX0kFnA==
X-Google-Smtp-Source: ACHHUZ6ayjAtOwTfIDOzMqX5t+1QrYhY8xbXfr8AsE31hPYz8DEGnh0exphBKO7gszaQlURwHEoueQ==
X-Received: by 2002:a2e:9588:0:b0:2ad:aa42:8c0b with SMTP id w8-20020a2e9588000000b002adaa428c0bmr3570722ljh.35.1684738848500;
        Mon, 22 May 2023 00:00:48 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:48 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:44 +0200
Subject: [PATCH v2 09/12] asm-generic/page.h: Make pfn accessors static
 inlines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-9-0948d38bddab@linaro.org>
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

