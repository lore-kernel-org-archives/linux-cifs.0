Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF1CC001DB
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Aug 2023 23:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjHEXvg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Aug 2023 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjHEXvg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Aug 2023 19:51:36 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF9C171F
        for <linux-cifs@vger.kernel.org>; Sat,  5 Aug 2023 16:51:35 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bbff6b2679so21598525ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 05 Aug 2023 16:51:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691279495; x=1691884295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iditb/ZFOAXj+I4a6gaYv5U2EiR6wsrv7juI7vdeFGE=;
        b=KVkcR5Jrh4YdKHgwzWe3yV2clvuwbSJ5VB0v+TdQCxhZSly+418QDWgkCqvIPE0hth
         WPG0B5vdvaTw2ffQUqU5KpKLpgdHQsPQeYlsB4gCCyhP+dPR9vohCM/2KyI93tBwEo5G
         JwD/81kr+qIxopFOCNGsr8vzmxehK1jNaRh56U2Oo1oGnyXArl+m51PZHz4Amxpb9ilT
         e70ts7j4Ui8+x9hVpBHTKZOTOvFMQxH123DaOc2av+xC9YvTyLGQ5F/fsxSTLQIU+yl2
         56hhsktyjH6FXbQhIbbK0YmscvLplaVvaEphF/yprVGq3a11Dk6GtkyD37+GFM9gDlxb
         A+Ag==
X-Gm-Message-State: AOJu0YxRULEzq7N2lfAnxeWcalNls8AHBSF8MlOqdnuPWoSMuFRB0Dxc
        SGtjm1+B9mIdsCy+PWSod1xbwixsunGsNg==
X-Google-Smtp-Source: AGHT+IEN7ZFT+5elI2zfCvPmQxmQSh/3ATvN8dFwOhtQ5NO+h9rwZc+3crdnIu3dM/gF5WFxDqAlWQ==
X-Received: by 2002:a17:902:ecc8:b0:1bb:32de:95c5 with SMTP id a8-20020a170902ecc800b001bb32de95c5mr5257441plh.65.1691279494783;
        Sat, 05 Aug 2023 16:51:34 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id v24-20020a1709028d9800b001b8c6662094sm4006963plo.188.2023.08.05.16.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Aug 2023 16:51:34 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH] ksmbd: fix wrong next length validation of ea buffer in smb2_set_ea()
Date:   Sun,  6 Aug 2023 08:51:06 +0900
Message-Id: <20230805235106.8845-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are multiple smb2_ea_info buffers in FILE_FULL_EA_INFORMATION request
from client. ksmbd find next smb2_ea_info using ->NextEntryOffset of
current smb2_ea_info. ksmbd need to validate buffer length Before
accessing the next ea. ksmbd should check buffer length using buf_len,
not next variable. next is the start offset of current ea that got from
previous ea.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21598
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9849d7489345..7cc1b0c47d0a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2324,9 +2324,16 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			break;
 		buf_len -= next;
 		eabuf = (struct smb2_ea_info *)((char *)eabuf + next);
-		if (next < (u32)eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
+		if (buf_len < sizeof(struct smb2_ea_info)) {
+			rc = -EINVAL;
 			break;
+		}
 
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+				le16_to_cpu(eabuf->EaValueLength)) {
+			rc = -EINVAL;
+			break;
+		}
 	} while (next != 0);
 
 	kfree(attr_name);
-- 
2.25.1

