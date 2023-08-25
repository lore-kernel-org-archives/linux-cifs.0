Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B960C71133
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343860AbjHYOtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343897AbjHYOtf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 10:49:35 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF1F2127
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:33 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-68a3e271491so813838b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692974973; x=1693579773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vDyNSywzmPX/ucLdVYc/IA9y3uXrOJxBBVODBmdFAZ4=;
        b=Q/oFxNYtsE2jLepV1LoRqAVKiDcL6ca5jTPcD2wWaahPG6TglVdHkunHbvDDyCxAWW
         0l3Uka607rnCIQFPK9GDR0B/qo1KT5t6mWvbDd7HTdOE3MCoGJ4ASwzE1AVrOGZHLhEh
         Ht46oJEixM1jIktNfunUf3jx4pT9ClvqCVtizF1UY8h974Z8uZJHP9KNFmu9T6n8y+l9
         6oCppLje38PW886D0lwgxEcb+wboIsJ6yTTQ0HiTrvrF5OB3gEMeU7RG9xWkvDX/sjkp
         MjghrPEK+r0716EZA995h5D0KX0mFr+GswbFftVKnHGkypPNTQNKWHK82FfKnnfU+ad9
         /Ozw==
X-Gm-Message-State: AOJu0YwGBYGKz7kj5puX2Bz7bwvt6p/jed84tay3ousMp737fi1e2GNj
        LafKQLEIrWIG47/mQE6BlNVRhvqP+xw=
X-Google-Smtp-Source: AGHT+IGnAzk6NkhRDQtA6PjDY+O3eEykAsa/hQ3XWtu5+okPfmP45h/C/b5bgHvUyVSz8ye+HScoRQ==
X-Received: by 2002:a05:6a20:13c7:b0:147:e55f:cced with SMTP id ho7-20020a056a2013c700b00147e55fccedmr16204429pzc.49.1692974972784;
        Fri, 25 Aug 2023 07:49:32 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id jh12-20020a170903328c00b001bee782a1desm1798020plb.181.2023.08.25.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 07:49:32 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 1/3] ksmbd: fix wrong DataOffset validation of create context
Date:   Fri, 25 Aug 2023 23:48:46 +0900
Message-Id: <20230825144848.9034-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ->DataOffset of create context is 0, DataBuffer size is not correctly
validated. This patch change wrong validation code and consider tag
length in request.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21824
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 6bc8a1e48171..9bc0103720f5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1481,7 +1481,7 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag, i
 		    name_len < 4 ||
 		    name_off + name_len > cc_len ||
 		    (value_off & 0x7) != 0 ||
-		    (value_off && (value_off < name_off + name_len)) ||
+		    (value_len && value_off < name_off + (name_len < 8 ? 8 : name_len)) ||
 		    ((u64)value_off + value_len > cc_len))
 			return ERR_PTR(-EINVAL);
 
-- 
2.25.1

