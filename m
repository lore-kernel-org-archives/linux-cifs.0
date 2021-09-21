Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF595C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73B661100
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhIUMnT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 08:43:19 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:37530 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbhIUMnQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 08:43:16 -0400
Received: by mail-pg1-f179.google.com with SMTP id 17so20573574pgp.4
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 05:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgUSJFDCxfO+zJiv7fiOqhQzlx1nbgY517uQ/d2YFvg=;
        b=RVfIUct0aGcLZ9f7Ttxum/y40r0oyO6oOn/Ypedrkvaoi3nNdPwcOPpPp88z2zYTV6
         q6v/fbNcTDa6IeFCwyvMZbhGQmtjkd8ovQgCdAm1cAvDt+raFYax7kaUpB9bx2k9d4ZC
         ZYMlxn3U18LK/0mzSX7Mra8J4f39I+koyVQIj4J1bSCCg03uwF3e8ZfDt3FxEzK7R9MZ
         s12PGO2/bpqGLH+fhDzCqZ3p+Ydr0BcNKwFfoyd3Y1ifjsEFxbrw8LFGiTJSmyVkMecO
         6eTwhDRU8M5v9ogbm9LwvogEq5m+Poix4mrWUZCdklyHKiT/U8noZ5WeZPovPeP19YYu
         ntfg==
X-Gm-Message-State: AOAM531IABXOcgHLtD+msJm/3GEz6IQ3NDbJ8bSfbz5xSkGzMnjJc+zK
        H4ZSAWUqnCaB12z1JtczV1wedvXTxzexaw==
X-Google-Smtp-Source: ABdhPJwHFOBhoF9SDFfqUwqwfGjjFsVho0F+gz5Nc4J5gRGJH84gOIezg2sYiCSQQw/eZXM+ElSkxQ==
X-Received: by 2002:a63:7b54:: with SMTP id k20mr15007039pgn.137.1632228107710;
        Tue, 21 Sep 2021 05:41:47 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id a11sm17248354pfo.31.2021.09.21.05.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:41:47 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: remove RFC1002 check in smb2 request
Date:   Tue, 21 Sep 2021 21:41:37 +0900
Message-Id: <20210921124139.18312-1-linkinjeon@kernel.org>
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

