Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C709DC7EE26
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 07:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjEVHBl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 03:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbjEVHAx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 03:00:53 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9747138
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:46 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2af29e51722so29528431fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 00:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684738845; x=1687330845;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AahUWbcM1gd1dIKV3ajpbH14PSzhJ7702+mo4mqS4bw=;
        b=BOx3hh3zVFySbprqCFUQMf+fnYuA2iUWep9gxTTyP5WeKKesv2gkIt/oZ6gEvNuPqI
         gsjbEjKEDWqEmE5Xz+Nt/ksrroHKs3LUAOgWVbkRN1Kydxt9EKFhkr8TpfFEhu56yyMK
         Fi4/TilXApxKBTJwYVjZxj/UXLWFIj9+4VoHAGULRBmHb3Zda8kO4YxVCQ0d2N/ryL0/
         trIrcEVfvwtXA0iflvfhHsiTC15IrKKRjozmZ4AWsaglSOB7UzCOIdwM2j6Z++exTmfV
         E97bpCK0CgHzzii3nCIaFh8KtL2mBA+CmhLDuwxHMJPOnCXsxBPehRvCb+Dc2MeynGDJ
         h1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738845; x=1687330845;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AahUWbcM1gd1dIKV3ajpbH14PSzhJ7702+mo4mqS4bw=;
        b=HudE3aYqb3OIcndjEiEFPyfqiCRoQpns0j5j1gVmwjH51yEY4gJvp45SyHkriRQpmP
         Gj5vf4Ps7AzYkvp+NO/s+bzfrGkcwT3uH2ZpqtoMs373UJ3ZVjfjPd2yTJgm9fOXwdFi
         oW9DNPCG0Mg0tHXLVnlz8xSWaKmlvrk+kZ1o2jyu89vK1Z7bIGyMwdNBuIpGy1Ses6Ns
         jxbR2JbLxj8zWw02JEKDj2NS096IKfjDDDPb/xXyJXkaxthCS/D8AB2fN2SVTc89eper
         e2hN5W3QndB+QKqSOBtr3T8s+QwDdKU900CSkA22pGXU46oRf2AaMLplL0X51V885cTQ
         tnpA==
X-Gm-Message-State: AC+VfDye8T4N8uAea3soQAo5WqDoIf3XmElY+BTX5HU8+Nbgrw4IC7Dr
        +eyotPeYmCZczPEuKZnPDBLxyw==
X-Google-Smtp-Source: ACHHUZ42e7ChwDWtOUUn4J77SbnYxbJJldABpTKqJYmVMK67oK/aQaDrAhMQZ3FMLOrwg7jn9I7vUw==
X-Received: by 2002:a2e:81d1:0:b0:2a7:a719:5943 with SMTP id s17-20020a2e81d1000000b002a7a7195943mr3785908ljg.40.1684738844861;
        Mon, 22 May 2023 00:00:44 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id q4-20020a2e8744000000b002adb98fdf81sm1010187ljj.7.2023.05.22.00.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:00:44 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 May 2023 09:00:41 +0200
Subject: [PATCH v2 06/12] cifs: Pass a pointer to virt_to_page() in
 cifsglob
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v2-6-0948d38bddab@linaro.org>
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
 fs/cifs/cifsglob.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 414685c5d530..3d29a4bbbc40 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2218,7 +2218,7 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 		} while (buflen);
 	} else {
 		sg_set_page(&sgtable->sgl[sgtable->nents++],
-			    virt_to_page(addr), buflen, off);
+			    virt_to_page((void *)addr), buflen, off);
 	}
 }
 

-- 
2.34.1

