Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4088C74A5B
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Mar 2023 13:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjCUNdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCUNdq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Mar 2023 09:33:46 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC99028E9F
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 06:33:44 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so15907810pjt.5
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 06:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mnk+C8m98fVgHWfU13eOvYyyajtr+JUw+B2sPXyLS0I=;
        b=103bMkIXepw5lHOSsU+gMxY8aC2nKYMP8F5UupmOC40nWfXWExpd2nyKn0bbV1B/fv
         6AmkL73ma0IS3GmVBZ1ipnkFv7302BJVMoA1pehqyZ8h3oe3aEcwdVS6YWQFy1WvqeTQ
         OGuX23cCZXgKQ9rTdB+qHsaeWVIYmpsmzq5iaF6uJ3vv5BOCWZACh/8tIvGd8lDudRXg
         DnSvlNo9/WbFIr9VEoHsZKF6Ms/HEB9ZNB3oul6n0Wa+Ve5qaLgoaFgk4f2KIynGyUgw
         7sTDniWyBbrrNQQjV5lPAZ1epq/W8OPs11KetLveLWGCH7FUJRFEiKTRL0Hjz0/WkkIk
         cJjw==
X-Gm-Message-State: AO0yUKUI1ETBXV1TXXuoVwBojlEB0e9vRyqHC51pNWRiBfPkXVRlFDV5
        9x1V9Aex28Ek2B+bYlEeK3b0CRCIjqM=
X-Google-Smtp-Source: AK7set9OX6xe8G4A8Hqnb6HDW0DJ/wwQEnMDYggHTPpTUx3gmRg6R5IceIVYos3xfwGSQwJRMadtkw==
X-Received: by 2002:a17:903:2312:b0:1a1:6584:31b0 with SMTP id d18-20020a170903231200b001a1658431b0mr2939381plh.30.1679405623954;
        Tue, 21 Mar 2023 06:33:43 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902b70400b001a1c2eb3950sm5487224pls.22.2023.03.21.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:33:43 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect
Date:   Tue, 21 Mar 2023 22:33:11 +0900
Message-Id: <20230321133312.103789-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321133312.103789-1-linkinjeon@kernel.org>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd returned "Input/output error" when mounting with vers=2.0 to
ksmbd. It should return STATUS_NOT_SUPPORTED on unsupported smb2.0
dialect.

Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index fa2b54df6ee6..079c9e76818d 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -434,7 +434,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB21_PROT_ID &&
+	return (conn->dialect >= SMB20_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
@@ -465,7 +465,7 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
+	if (command == SMB2_NEGOTIATE_HE) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;
-- 
2.25.1

