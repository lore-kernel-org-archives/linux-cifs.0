Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496EBC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 22:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C3B9610E8
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 22:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhIUWwy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:52:54 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:40735 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhIUWwy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 18:52:54 -0400
Received: by mail-pj1-f44.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso3094563pjh.5
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 15:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgUSJFDCxfO+zJiv7fiOqhQzlx1nbgY517uQ/d2YFvg=;
        b=3+nJ0UlSi14frGrkO6699GXakz48e5sCnV9CLRDSqH/Ml6hua8bPQmtGOl8RLwYIPz
         K0F+lqkYE5wWxnw00UtZIBriYvUJIrRjxB/5PqW632whrOhs+rgRF/kMcHSFPCVBz7xH
         12wwvOeNa+wnBHH/FEf0eKkqXyffvw13pLEvobsZ7wpvg35tsiq44Qz6I3ZZz8wu4GK+
         gPum5FHGUcN6/5oJXoq4RPSMoS8C4ubCI9GYcP5LGTFWtPRgTkZ1qBqS8GYP7gRb1zUL
         2hMqiRPRHAwIp2iHyP+nZy7SWgca4MShLV2aN0WPJ4DpMhhVs4C2Ev2TkLcs1qXs1AOH
         N1Sg==
X-Gm-Message-State: AOAM532smqUsjpMiy26nec7s9pBIVU42Mk/FsmjVCOJIE5MB26ge156S
        qCQpP7C2kdCDqz+Ji3hIijjjON+WQFncXQ==
X-Google-Smtp-Source: ABdhPJxFX6a5m9HGjgSanTb5FUr+uj8pzzv+SsqymcyIyf7rURq7FLLu7so0mtA+Av0z/847wP87sw==
X-Received: by 2002:a17:90a:8505:: with SMTP id l5mr7961079pjn.173.1632264684653;
        Tue, 21 Sep 2021 15:51:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id e18sm167053pfj.159.2021.09.21.15.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:51:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/3] ksmbd: remove RFC1002 check in smb2 request
Date:   Wed, 22 Sep 2021 07:51:07 +0900
Message-Id: <20210921225109.6388-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
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

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 15 +--------------
 fs/ksmbd/smb_common.h |  8 --------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 43d3123d8b62..1da67217698d 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -149,20 +149,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
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
index 57c667c1be06..d7df19c97c4c 100644
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

