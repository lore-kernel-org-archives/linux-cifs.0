Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456B2C77B75
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjEVHBm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjEVHAt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:00:49 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5A812D
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:45 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2af98eb6ef0so12513151fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738843; x=1687330843;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/3885L94lN4KFkmIG4KL0Z1VLtyVywWWWjhcZ8AdCI=;
        b=msJmmXilknfX0gustXHQKSFGoGGpP7zNrDPXSF8hGlzB+iOnAsG/9I6PNDaTC7tpuP
         LHrjj4nADiOaY1JF8IDevtTJnrfZzdlukdM5EjxmOQMluBLXF00uxSCrlJ7fF0ejN4JD
         Q4LwkNUmpBY3r0XYmP3BaT5xUCGJ3H0IrrWD/2ui8jqMelbfiq8VPrnWpZSMsASEmnHp
         U8ckmtBg7/nb/4CIadFGBoWiB71MX9sNNtt3ZXZuNUZ4nD1NSR0DTjKbTfHDFJKiWu3S
         oI2KEw+qKpXMHbdxZKQDP3RSyQcxiJeCdJJD4p+woUWbiPjn42x6zslxWBMZPoVgpmY0
         MXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738843; x=1687330843;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/3885L94lN4KFkmIG4KL0Z1VLtyVywWWWjhcZ8AdCI=;
        b=P5988oD+tzmVlzN7nEPhT7Pg3Ucjv4qHmjxRjlmF1JoM1gi4NNzsLxt1FD6Qj6UmGP
         AWxROiSGafRicqCpa3/iZjErLEqeSyqCKHy5WAm3aiufClKMz7+h6BdHY9x3TMUxjfKT
         M8aRM1oqrC5moPTmk72NJVv8szi8TnWyY3mltmBMRiecnBp3EkAKBndfd4iS16cnIfng
         qfsvT+XuEZ08rWvQ8a0HcXh9a80zKJ019nc9ksvwDeUgM6ISiB6I5i7jfF1iM/tZqbcp
         6h2JCRsj3N46/+Xx634TjjsICD2V+beNDhwtqLrafIi2lxbkPFv8mGm+KwAkCVtd2F2Y
         DXMQ==
X-Gm-Message-State: AC+VfDzn53ODtXkFw9599ZoemJhZUMWoND0USGxjsC/TW6boB+6pR+yk
        v0dH/SO+0XzymiMRVFYZEvrCEQ==
X-Google-Smtp-Source: ACHHUZ5h73hBaOd7t5s+aJ2lUS5QT6SygNvWWhdVE3CS8JGYJhqyww8xpReCDW9EkuzhCaG9HMhk0A==
X-Received: by 2002:a2e:9081:0:b0:2ac:8486:e318 with SMTP id l1-20020a2e9081000000b002ac8486e318mr3451294ljg.35.1684738843518;
        Mon, 22 May 2023 00:00:43 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:43 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:40 +0200
Subject: [PATCH v2 05/12] cifs: Pass a pointer to virt_to_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-5-0948d38bddab@linaro.org>
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
        Tom Talpey <tom@talpey.com>
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

Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 0362ebd4fa0f..964f07375a8d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2500,7 +2500,7 @@ static ssize_t smb_extract_kvec_to_rdma(struct iov_iter *iter,
 			if (is_vmalloc_or_module_addr((void *)kaddr))
 				page = vmalloc_to_page((void *)kaddr);
 			else
-				page = virt_to_page(kaddr);
+				page = virt_to_page((void *)kaddr);
 
 			if (!smb_set_sge(rdma, page, off, seg))
 				return -EIO;

-- 
2.34.1

