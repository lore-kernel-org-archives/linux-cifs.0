Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B171C77B73
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjEVHBn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjEVHBC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:01:02 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2472D2
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:47 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2af278ca45eso32454481fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738846; x=1687330846;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cbjvTSrc7JXib/jYCtsnbT8Pj+twUmj4f7HYrh8lbjo=;
        b=mY0aNW1/EfjKDkZ/iGL1m6Zy8Fuo6cIs8D94rSpcZbEbpG1ej+LIXwwg8IjfW1ubMf
         naeqWo2Tcv4U7TJhz9Le9MuCuBLyv4D3QBwlIS3zm4uuM0sDBiKrRy1hwX60LW4us3Fy
         lkizvvt3WsoYNWJw4yNFIDsi+sL5v4YZ3faevgqnaAPtaHVH/NygExxLIfBKibX15pwh
         tHGJ8JNozxqi8y1yMVmjsLj2PaJE+bFjBQdfzX3wucmA58zcUBePI0oa6lqw7Yl8bVB9
         VaJ8pSouLbJ41Y6QU3Shc7N4h3wuDh4QnygF5tReoR09XiD0FLth1k8KkiUU3nySSVUd
         z1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738846; x=1687330846;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbjvTSrc7JXib/jYCtsnbT8Pj+twUmj4f7HYrh8lbjo=;
        b=gWPEekEqHwETQfPyuuUcv6kxZAZf5jWa7bIj/7i72/Dw2CYRZctYfCNhTddGDm7YHL
         Q4MMQYjiYLEhePiWS8h7qvNcnNMdOwfmJE3nKlygpPXhKoOvJuJsHoyaDnq47/ucarAQ
         iVdAirExDFmbIfC/JCwtF1XSX+hDscl8e8FCYlXNbh1AZgdzl2LuUuZJIxupTGLJEAIC
         tO1wl4FCApUevDMQ0m4m2/Vn6IT1oGbKuJwF4Oepbql4RTlKt3P4W0I06aDlSSy5Voq3
         197u0dWoO5P6zgSEWt+uW2yM/dHeAYjCbKrSOUjLpH9tShCPdJPBztvXP+SEbVpoTdI/
         8oRg==
X-Gm-Message-State: AC+VfDzWzP7hnFhjcC+D88d5EYPDN6hE7O5+k8dyBSmx3cgL9LIisFr3
        nvi6KpD+mCkBUOwUV0jvD73LYQ==
X-Google-Smtp-Source: ACHHUZ4bp1LXNo/+2W/IeTUTw0QnGh8DL7r/PmOoEgOM0R51k/v0tTn2gSTtsQZtS0itui0SFJl/Iw==
X-Received: by 2002:a2e:88d1:0:b0:2a9:9e99:a508 with SMTP id a17-20020a2e88d1000000b002a99e99a508mr3233749ljk.53.1684738845921;
        Mon, 22 May 2023 00:00:45 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:45 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:42 +0200
Subject: [PATCH v2 07/12] netfs: Pass a pointer to virt_to_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-7-0948d38bddab@linaro.org>
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

Like the other calls in this function virt_to_page() expects
a pointer, not an integer.

However since many architectures implement virt_to_pfn() as
a macro, this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this up with an explicit cast.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/netfs/iterator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index 8a4c86687429..0431ec4a7298 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -240,7 +240,7 @@ static ssize_t netfs_extract_kvec_to_sg(struct iov_iter *iter,
 			if (is_vmalloc_or_module_addr((void *)kaddr))
 				page = vmalloc_to_page((void *)kaddr);
 			else
-				page = virt_to_page(kaddr);
+				page = virt_to_page((void *)kaddr);
 
 			sg_set_page(sg, page, len, off);
 			sgtable->nents++;

-- 
2.34.1

