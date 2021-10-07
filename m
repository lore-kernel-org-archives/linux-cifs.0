Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B557C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 22:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6EEC610C8
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 22:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhJGWdS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 18:33:18 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:39574 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbhJGWdR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 18:33:17 -0400
Received: by mail-pg1-f174.google.com with SMTP id g184so1200625pgc.6
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 15:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TyKYglWsxf9eRRcfez0qOnKOvywa1p6bYkYnOj4KSms=;
        b=lF3vi2ztEa0JP/op2i6kJsWKw/zUYIK2ACZZ1DwLc6Q16qUOGcj/HcUCafv/ALowa8
         BaJKAfOFDnF+xcCk6JFPUQvJIXe56E4sEQQSG5ARSJrlKOY+bXod7QMP/+/Xhc1DyT7F
         9naUOuCKjitkNsdgup6wuUwfKa63KLBBYXog4p30IxJNpnwdM+rrNOtthcjTQbXs3Fpa
         DQ799jmP76TZcH9o7oVejmmjsZTmNLjVMbqboheSUheJF/ZjycsiT+v24BAt3Bcvp8w0
         h1FoCxhw6S9DP5H0oCiUsElKDtS5WsqyALi7Q2AhaJe5NFlL4WDQUCQjl4D9MO4i6zAx
         dqhQ==
X-Gm-Message-State: AOAM530BgrcRBx6ajfndMk75KiHqhFLh71REJmMWEzLtpOO5+gi6EItJ
        6zDpMUSpoDACD/2V27eU88FWY9/bnPT1DA==
X-Google-Smtp-Source: ABdhPJwTfY2oHxKoBhRG80lvTG6eLg2YzXkikwCXDge9dDKGx8ao9wS2A0HUqs2in7znnoWxi9xvOA==
X-Received: by 2002:aa7:8298:0:b029:338:340:a085 with SMTP id s24-20020aa782980000b02903380340a085mr6966493pfm.46.1633645882775;
        Thu, 07 Oct 2021 15:31:22 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id x11sm419167pfh.75.2021.10.07.15.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:31:22 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH] ksmbd: limit read/write/trans buffer size not to exceed 8MB
Date:   Fri,  8 Oct 2021 07:31:02 +0900
Message-Id: <20211007223103.5340-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd limit read/write/trans buffer size not to exceed 8MB like samba.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2ops.c | 3 +++
 fs/ksmbd/smb2pdu.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index b06456eb587b..97027c0962d3 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 
 void init_smb2_max_read_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, SMB_MAX_IOSIZE);
 	smb21_server_values.max_read_size = sz;
 	smb30_server_values.max_read_size = sz;
 	smb302_server_values.max_read_size = sz;
@@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
 
 void init_smb2_max_write_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, SMB_MAX_IOSIZE);
 	smb21_server_values.max_write_size = sz;
 	smb30_server_values.max_write_size = sz;
 	smb302_server_values.max_write_size = sz;
@@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
 
 void init_smb2_max_trans_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, SMB_MAX_IOSIZE);
 	smb21_server_values.max_trans_size = sz;
 	smb30_server_values.max_trans_size = sz;
 	smb302_server_values.max_trans_size = sz;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index a6dec5ec6a54..b66c562e90e3 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -113,6 +113,7 @@
 #define SMB21_DEFAULT_IOSIZE	(1024 * 1024)
 #define SMB3_DEFAULT_IOSIZE	(4 * 1024 * 1024)
 #define SMB3_DEFAULT_TRANS_SIZE	(1024 * 1024)
+#define SMB_MAX_IOSIZE	(8 * 1024 * 1024)
 
 /*
  * SMB2 Header Definition
-- 
2.25.1

