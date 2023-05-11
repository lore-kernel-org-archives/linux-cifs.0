Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE8EC77B7C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 May 2023 12:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbjEKMA1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 May 2023 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbjEKMAC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 May 2023 08:00:02 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C659A240
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:54 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2ac88d9edf3so80974651fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 May 2023 04:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683806392; x=1686398392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zblD5qwa4O4tbk0UyG8/FxNMnBSv353Htd3W/ogLXhE=;
        b=wyPzOAzNl7rmMFYBpuSvqF8bhrq6s9qC3HUK0XdF1bjiigB5tF7/avNAx4obqKnEQ1
         5XDdVWTgJzXsRWcpD0IeKxuCUkF11nwjWijBb+G6T5OPprRNKDhkDqc9xd5QVgMzyrYY
         L4pIzqOjfuQxI7o931I1eoHt0E6G0OHcTKzBzLCxA+U45bYiMjQdWdAzAsrvS2ny+0vb
         k7hlG5IBE0zSUhp1t5xXUTTwH3SO9y19gebdMieRe9lXFfVvvxSdJSGDOae/gEYPgSY9
         RwLKQo1r9DKn1ZNPuZYIw5CEheKyIccgqvPNEdgrxsVlTPsrWGQMtl/h5sx8pPqkpO6r
         g93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683806392; x=1686398392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zblD5qwa4O4tbk0UyG8/FxNMnBSv353Htd3W/ogLXhE=;
        b=ee2srAKOrzlpxdixQsLk1DDbIXWVO5aYM9+eRaWzvSQoXIAON1X1GCpZC19IaKb2cQ
         7wh4WPw0IvJ+nQppSNOYs10Z5iNjdXZFJKmrCor6P30vxZL2sheDWe9l2jOXXpgKHgfA
         sJ7FFuebYl/vkyssuAdOIy/v67YYGiDno0pEkdIKhpY0NS9tsvQkI7TIC7FbAdqL38M3
         bAhyDLNBK2FmT1DmH6pKWzjpSDRDTGp5RIGLes7KO9D8H4j8ckmm4GupjnyzYRGrcFkh
         Iw6aHniq3EFSXuXwTHeiSR25TZD5ZlMRgsXfr0dhIrhkeeSsmVar3+qd//tAL2WQgLXR
         tGZw==
X-Gm-Message-State: AC+VfDyXugyc8ilkcVDcoSwFsp7pQ3y6wk6NYVipDQCERDVojmZaZL1h
        muANB4/CLv2FlOx8QO9FcwtPBg==
X-Google-Smtp-Source: ACHHUZ59KkD2PbSzrX68GhVPYYRxuWgdwfVNkMLT9EHS/L7M9SxIxBIJEQpBkI5jMhVr75d7lMVL9w==
X-Received: by 2002:a19:f605:0:b0:4f2:53fb:187 with SMTP id x5-20020a19f605000000b004f253fb0187mr2361851lfe.68.1683806392694;
        Thu, 11 May 2023 04:59:52 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id f16-20020ac25090000000b004cb23904bd9sm1100841lfm.144.2023.05.11.04.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 04:59:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 11 May 2023 13:59:23 +0200
Subject: [PATCH 06/12] cifs: Pass a pointer to virt_to_page() in cifsglob
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230503-virt-to-pfn-v6-4-rc1-v1-6-6c4698dcf9c8@linaro.org>
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

Like the other calls in this function virt_to_page() expects
a pointer, not an integer.

However since many architectures implement virt_to_pfn() as
a macro, this function becomes polymorphic and accepts both a
(unsigned long) and a (void *).

Fix this up with an explicit cast.

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

