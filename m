Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44785C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 03:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2007A60FC1
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Oct 2021 03:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhJHDbe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 23:31:34 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:53855 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJHDbe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 23:31:34 -0400
Received: by mail-pj1-f54.google.com with SMTP id ls18so6506062pjb.3
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 20:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+REYJPyFGlgzJKB3AvckVAO1PJD5GKoE48TFB4TSQ/E=;
        b=fAMnMgGsQe4GM0/H+jURHX+DAejwwkqwbSabDY5iNYV0u4VrLMZyJibh5Nli+pWwDM
         BnPXPnPK6madIKNIt6COccZnKPGNcBt0naxWXNAqvF0AfNhAkaS/7/hg03hja0d8xNEE
         RXZrOa4HoYUB0CmGPg8mRKmOnu9Thkuj01USS2Xyb6FE27RZ1+ADQln34OJQGZw7azkU
         AbMY/8yJ4x6cKal9A3JkTbHtA8f19UqtBDevep57cHr0hWaK1khKeqOpfjSWy9VkXp0W
         dU/P4LUiAd/cct4WBDugYKyqnUZsCuFhm5JLKGd2/6uPFDGCACTQMrHRIOCLN/t4Kt5b
         9Baw==
X-Gm-Message-State: AOAM530zhUy4qGZIB6/+1JiqUUX4Qp66amVaG72ki1gq8AgDp6BASDuP
        h1UwDLinmj/tiUuzotjPKzBWhr1CRGmW0g==
X-Google-Smtp-Source: ABdhPJxfkH7yAS1l30Wg7TqASG+3gHaluZluuXdY294WIui3UoA30xbS3sLUo6V9/gtl/4U0M1FY5g==
X-Received: by 2002:a17:90a:4502:: with SMTP id u2mr9497985pjg.186.1633663779447;
        Thu, 07 Oct 2021 20:29:39 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g3sm683615pgj.66.2021.10.07.20.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 20:29:39 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2] ksmbd: limit read/write/trans buffer size not to exceed MAX_STREAM_PROT_LEN
Date:   Fri,  8 Oct 2021 12:29:31 +0900
Message-Id: <20211008032931.60797-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd limit read/write/trans buffer size not to exceed
maximum stream protocol length(0x00FFFFFF).

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - change 8MB limitation to MAX_STREAM_PROT_LEN.

 fs/ksmbd/smb2ops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index b06456eb587b..63289872da97 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 
 void init_smb2_max_read_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, MAX_STREAM_PROT_LEN);
 	smb21_server_values.max_read_size = sz;
 	smb30_server_values.max_read_size = sz;
 	smb302_server_values.max_read_size = sz;
@@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
 
 void init_smb2_max_write_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, MAX_STREAM_PROT_LEN);
 	smb21_server_values.max_write_size = sz;
 	smb30_server_values.max_write_size = sz;
 	smb302_server_values.max_write_size = sz;
@@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
 
 void init_smb2_max_trans_size(unsigned int sz)
 {
+	sz = min_t(u32, sz, MAX_STREAM_PROT_LEN);
 	smb21_server_values.max_trans_size = sz;
 	smb30_server_values.max_trans_size = sz;
 	smb302_server_values.max_trans_size = sz;
-- 
2.25.1

