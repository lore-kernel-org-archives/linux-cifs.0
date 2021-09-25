Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F126BC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC33060EE4
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 13:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245021AbhIYNSh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 09:18:37 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43694 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234877AbhIYNSg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 09:18:36 -0400
Received: by mail-pg1-f182.google.com with SMTP id r2so12722081pgl.10
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 06:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vsnp243rrE/Z2M0xyhi0rHiatJF+QPPm330KlfYLJPI=;
        b=5hgyGOoDsX8XcBEBErxuM9vxigXK36hia4qtIVr/bXMFU4nycJOks1R2MqZKQSGx0S
         G3gxTdPIFuPepAatHvs06XTCLhErzU8o29/sqpM9VVtiJ0qHLKdpA+ldgswDFf+/J/OT
         AW3xaFFTuYeQAOXsTUOqLxXoi8VJswSb8qjTZf8+IIcO6pZFilY+IcOJN6KsPAFGY1yI
         fhPwVpry5nCEjInJ74PCBMmdg2+nCKtZu0xzu/DEjuHymnm5Jl+Q2u8vZU4QU7F/Q77z
         hKFNxRqlWWEcYS1WByVlhohys/6FCJ1kAp+veXDJjdThrUBxI/TqefpzJ7r8hhOAYcj1
         vVWA==
X-Gm-Message-State: AOAM531L92eAi0RWbTjJQ6I7+5WN7wZf+/QiVRfiJhVsBWNkNGI4C8+s
        qhcCRWEG3mxh1c9m1SDtoDBr1VEEBxwiEw==
X-Google-Smtp-Source: ABdhPJzPaLPT4uRtGb309XvKJdzM7BFaws+jjgsfEVEht5CVAwZoiZqIyc20T7m2S/JUuR6PYcJVQg==
X-Received: by 2002:aa7:96d9:0:b0:44b:28ec:b07d with SMTP id h25-20020aa796d9000000b0044b28ecb07dmr14426181pfq.85.1632575821441;
        Sat, 25 Sep 2021 06:17:01 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x8sm4714698pjf.43.2021.09.25.06.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:17:01 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/7] ksmbd: remove RFC1002 check in smb2 request
Date:   Sat, 25 Sep 2021 22:16:19 +0900
Message-Id: <20210925131625.29617-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210925131625.29617-1-linkinjeon@kernel.org>
References: <20210925131625.29617-1-linkinjeon@kernel.org>
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
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
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

