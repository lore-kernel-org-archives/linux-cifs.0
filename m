Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DA1C76196
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Mar 2023 12:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjCaMa1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 Mar 2023 08:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCaMa0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 31 Mar 2023 08:30:26 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6AB1EFFF
        for <linux-cifs@vger.kernel.org>; Fri, 31 Mar 2023 05:30:24 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id br6so28619529lfb.11
        for <linux-cifs@vger.kernel.org>; Fri, 31 Mar 2023 05:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680265822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KT4QjW5w4lw+wLg7xksyBXK45yDAiL2fskDAOHftL2Y=;
        b=VoIqvf6ZZEzx8ksUhbeHvuex97JLP1Jpdc2l5MpsiSlbX4tPYuW+wF4T26j9BtM35e
         WJzMjzhhrfNJVRIAVQL0hLJySTqeFYF52WamkpFdHWk4GUFiI0KhDCqMat/QUWxVEHve
         WyunMjF6FgjSnKMD6qj+QOu0vYPtgy981dh9ijuCiXWBMzJHQRUpts3b+9MCImvd+ITz
         SV/BGD5xXD8oiWPSbJZ+nR0Xc6LoVCokmkBO5pySkhogeHMWT7lKASjJfXyrkZildhrH
         fUOWbMoLIIo8Zn7wMj3OCv5CH0M+wOnHQ/62aa+NAQ3+KmbO76USEHmlqyIB2tRoXZYT
         xTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680265822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KT4QjW5w4lw+wLg7xksyBXK45yDAiL2fskDAOHftL2Y=;
        b=WAjTE5hgEriKm5S8V0RgJm7+x8ldSTD1AwNbSs3ty3PZnsze93tx5mVILFO6xbIrMs
         x98VY2z8+7fmWodITB9+eeLMjZotPVPzEBVdRvyboLg4RhT3c2sWUah+Odk4oIlGRVXi
         vqZHr1HYIzDKnpEJd4/8GDamCKYc3V/zfstBSeW50gLJiAZSMO4TbD/U8N80raBsd500
         Il/U+/9J6TOjM2oBh7cYxQOsyrXo2m7+Ij5Yom29qH/1q1nCY0fG/j6vvWW16mjp8/IP
         6vaP8X85JVbMyaMC/pHdvBO/kdFWfcvBnwlrffql7iNw3beP7WFSzLDu+s71WAVYbFFM
         pkAg==
X-Gm-Message-State: AAQBX9fC43YzhrvjW65B8UlsALyoGDclO6iG0OhELTl14NNdEfIOwDr6
        AWVE74xoBo6q12lUYYStUIKGKQ==
X-Google-Smtp-Source: AKy350ZJsHAlHV/Qnrh6hhuhWUPN0PIsb9XRKurkgN+569rjjg9T9nORrh2ZLo2h3QM/tOLQWrH1cg==
X-Received: by 2002:a19:f00b:0:b0:4e8:6101:bce5 with SMTP id p11-20020a19f00b000000b004e86101bce5mr7747425lfc.39.1680265822507;
        Fri, 31 Mar 2023 05:30:22 -0700 (PDT)
Received: from Linus-Dell.lan ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id m7-20020a056512014700b004e9c1b30864sm360699lfo.222.2023.03.31.05.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:30:22 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] cifs: Pass a pointer to virt_to_page() in cifsglob
Date:   Fri, 31 Mar 2023 14:30:18 +0200
Message-Id: <20230331123018.919524-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
This is similar to a previous patch but a second instance
of the same problem.
---
 fs/cifs/cifsglob.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 08a73dcb7786..abe9b8f83f1b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2213,7 +2213,7 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 		} while (buflen);
 	} else {
 		sg_set_page(&sgtable->sgl[sgtable->nents++],
-			    virt_to_page(addr), buflen, off);
+			    virt_to_page((void *)addr), buflen, off);
 	}
 }
 
-- 
2.34.1

