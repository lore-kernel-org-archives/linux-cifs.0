Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE43C3DA66
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Aug 2023 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343863AbjHYOtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343910AbjHYOtk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Aug 2023 10:49:40 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D72119
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:37 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c09673b006so7503435ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 25 Aug 2023 07:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692974976; x=1693579776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f3DI36WNdRKRJ8jT0b6JWEBzJ5oQWCD9tqcC8NDl9nI=;
        b=ZBH1MdHFsSXS3ZPYa3DBYgRvzasqtNRVUuU9XCE5glSHQR9U4ybT5A59JHDVshFURk
         TNUofmQ/Gkj8ygvqKC5jUBdDv9tTghR2WQxPOP0wP/Ric2NTNB/pYdSUtQzzr6MWIq7O
         OKTZC2WLgDkTmB6FlxeKBCmFtgVtMon3djBqVSYRMkDoAI8V3Ku3ZXbRJ4cd1BG2YXus
         VMADkI6I/5ZTzZd2ai/bLE24D0cnpJ9un6JlJIcBZ4J1aFo/aWlSweUdV9SKNHUj1s95
         Q5e1RRk76DlUL0lMP+LgZvu7okIJTj0CqTuiJcS8LyKymH87eQ6/h03EoV2j6b6zRGVw
         arAA==
X-Gm-Message-State: AOJu0YyMURxU1mH+2XCFw9KfO8FyKH5n2fsBY7QNTHIneOfFeT3ZrIEH
        A+EW2lhA4L6YkPcmuM8ZaC04ZxrN04o=
X-Google-Smtp-Source: AGHT+IH2GJv0YkTHCUxFd4VwMLoWWjVg8upoNtaMLR+VVGUlul/j9zKtAve4LxHWMEwrMeWiUFyolg==
X-Received: by 2002:a17:902:ea06:b0:1c0:a5c9:e05a with SMTP id s6-20020a170902ea0600b001c0a5c9e05amr9839760plg.43.1692974976596;
        Fri, 25 Aug 2023 07:49:36 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id jh12-20020a170903328c00b001bee782a1desm1798020plb.181.2023.08.25.07.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 07:49:36 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 2/3] ksmbd: fix slub overflow in ksmbd_decode_ntlmssp_auth_blob()
Date:   Fri, 25 Aug 2023 23:48:47 +0900
Message-Id: <20230825144848.9034-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230825144848.9034-1-linkinjeon@kernel.org>
References: <20230825144848.9034-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If authblob->SessionKey.Length is bigger than session key
size(CIFS_KEY_SIZE), slub overflow can happen in key exchange codes.
cifs_arc4_crypt copy to session key array from SessionKey from client.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21940
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/auth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index af7b2cdba126..229a6527870d 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -355,6 +355,9 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 		if (blob_len < (u64)sess_key_off + sess_key_len)
 			return -EINVAL;
 
+		if (sess_key_len > CIFS_KEY_SIZE)
+			return -EINVAL;
+
 		ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
 		if (!ctx_arc4)
 			return -ENOMEM;
-- 
2.25.1

