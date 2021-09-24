Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17535C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0183E61039
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbhIXCOs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:14:48 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:38832 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243910AbhIXCOs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 22:14:48 -0400
Received: by mail-pj1-f44.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so8416802pjc.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eF4T0lhY4vIRQ6JIUBjGHHoCRAUP7cxndEibelq9Os0=;
        b=pPL4z02Mw6Lrf90uXnRRO24VdiBvuNV0/8tn7L3EryzgkUa2gsuzR+erFxJvcG2PFa
         QYpXuA2DQ58nvG2l5hLZjzoxLWVCYp0vgpcKxmxUlzURi6DGA795MmmQibjVsw5aYALW
         0ivPv+ZflIqGClg9lShn6DNPWtWsBKZyqAbKtgIz3KDVH4ndWCsP3dIuysQA7mHten8I
         4zGMJYkpSsCqyfchThr5VkkVsuulBfD+FkXXtygstEOBhT5TEYh3x8iU4BDHaHa34q5x
         eM0tvkeN73uRg9Ff+jOfmSeEyBlrP+es7mTFsHFmIfm2od1UBepTSUJz0Xk7tdnaFl5l
         VtsQ==
X-Gm-Message-State: AOAM533tJSAHrgHtwvLWSbBTTZHPowvDYfLr2gaFrwExYIViW4Yl6FCz
        rOv1laLWYjhzeHZh0hduJAiQecZWJXHZOA==
X-Google-Smtp-Source: ABdhPJyxdL1MIFjoKRhOQYaM3/iDiMtQ5J2gOcqDamVnX1SG0COnKED1lUvQT4eOEEa8uzrH2u8tgg==
X-Received: by 2002:a17:902:82c2:b0:13c:916b:96a with SMTP id u2-20020a17090282c200b0013c916b096amr6760550plz.61.1632449595525;
        Thu, 23 Sep 2021 19:13:15 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c16sm6724746pfo.163.2021.09.23.19.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:13:15 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/7] ksmbd: remove RFC1002 check in smb2 request
Date:   Fri, 24 Sep 2021 11:12:50 +0900
Message-Id: <20210924021254.27096-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924021254.27096-1-linkinjeon@kernel.org>
References: <20210924021254.27096-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

In smb_common.c you have this function :   ksmbd_smb_request() which
is called from connection.c once you have read the initial 4 bytes for
the next length+smb2 blob.

It checks the first byte of this 4 byte preamble for valid values,
i.e. a NETBIOSoverTCP SESSION_MESSAGE or a SESSION_KEEP_ALIVE.

We don't need to check this for ksmbd since it only implements SMB2
over TCP port 445.
The netbios stuff was only used in very old servers when SMB ran over
TCP port 139.
Now that we run over TCP port 445, this is actually not a NB header anymore
and you can just treat it as a 4 byte length field that must be less
than 16Mbyte. and remove the references to the RFC1002 constants that no
longer applies.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 15 +--------------
 fs/ksmbd/smb_common.h |  8 --------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 40f4fafa2e11..5901b2884c60 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -155,20 +155,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
  */
 bool ksmbd_smb_request(struct ksmbd_conn *conn)
 {
-	int type = *(char *)conn->request_buf;
-
-	switch (type) {
-	case RFC1002_SESSION_MESSAGE:
-		/* Regular SMB request */
-		return true;
-	case RFC1002_SESSION_KEEP_ALIVE:
-		ksmbd_debug(SMB, "RFC 1002 session keep alive\n");
-		break;
-	default:
-		ksmbd_debug(SMB, "RFC 1002 unknown request type 0x%x\n", type);
-	}
-
-	return false;
+	return conn->request_buf[0] == 0;
 }
 
 static bool supported_protocol(int idx)
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index 0a6af447cc45..994abede27e9 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -48,14 +48,6 @@
 #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
-/* RFC 1002 session packet types */
-#define RFC1002_SESSION_MESSAGE			0x00
-#define RFC1002_SESSION_REQUEST			0x81
-#define RFC1002_POSITIVE_SESSION_RESPONSE	0x82
-#define RFC1002_NEGATIVE_SESSION_RESPONSE	0x83
-#define RFC1002_RETARGET_SESSION_RESPONSE	0x84
-#define RFC1002_SESSION_KEEP_ALIVE		0x85
-
 /* Responses when opening a file. */
 #define F_SUPERSEDED	0
 #define F_OPENED	1
-- 
2.25.1

