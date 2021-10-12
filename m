Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6F6C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED7260FD7
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhJLBZd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:25:33 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41569 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhJLBZd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 21:25:33 -0400
Received: by mail-pj1-f49.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1312651pjb.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O/TJ0CmNJMAYG1c60nR+z4cCeC/QbrRaM4addy/NrD8=;
        b=rFlmmQ40GPQwS9SveJuXNcgMKWgMgoE3s1bMNzbvBJJbd3f0tZt+kPtThqeGLX6Qjq
         W386y+2YJy7ayEu9OwPDVbjbWc57/znAuiEi4Emg0SgBi49e73cgkSc+mxUdh9aW/HOW
         /nHD+RigF06vFprhZhZvPgymIeIp9gaV8r4kWrfvUFbK1+WMRdyd5AavQb7IPjDzfoCq
         FNIGMfmXIEfIAmYvs/xygExy9YOnDD9l8WpFqPBFtPkaoE7prPaIUkbBMWJ1zhO6lPK5
         thoLE123+P9gUXLi8O5+CQh5ybF4I6r+dZGp8KtF5QA7Piwvo6p+eYck0gwah3NauyN4
         6hMQ==
X-Gm-Message-State: AOAM530mQPE+MjkkYGZ1q5XxIXcD+tJBzSJwgcZsjFsJ8jlq6eJM/zEX
        v91IfoxPi1bP3jCFPt3DG7DriYouoGOO8A==
X-Google-Smtp-Source: ABdhPJxTQbI3ROIyFyYJ9na7V6jn4s18v30/J1xnQjqyVhg6z75IO+V1OwwlTbbX+dSc0zODyJ1XZw==
X-Received: by 2002:a17:90b:38d0:: with SMTP id nn16mr2686930pjb.96.1634001811656;
        Mon, 11 Oct 2021 18:23:31 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y17sm5575392pfn.96.2021.10.11.18.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 18:23:31 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3] ksmbd: limit read/write/trans buffer size not to exceed MAX_STREAM_PROT_LEN
Date:   Tue, 12 Oct 2021 10:23:13 +0900
Message-Id: <20211012012313.5701-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd limit read/write/trans buffer size not to exceed maximum stream
protocol length(0x00FFFFFF). And set the minimum value of max response
buffer size to 64KB. Windows client doesn't send session setup request
if ksmbd set max trans/read/write size lower than 64KB in smb2 negotiate.
It means windows allow at least 64 KB or more about this value.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - change 8MB limitation to MAX_STREAM_PROT_LEN.
 v3:
  - use clamp_val to set minimum value.
  - subtract MAX_SMB2_HDR_SIZE from MAX_STREAM_PROT_LEN.

 fs/ksmbd/smb2ops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index b06456eb587b..ede6d96dabbf 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 
 void init_smb2_max_read_size(unsigned int sz)
 {
+	sz = clamp_val(sz, 65536, MAX_STREAM_PROT_LEN - MAX_SMB2_HDR_SIZE);
 	smb21_server_values.max_read_size = sz;
 	smb30_server_values.max_read_size = sz;
 	smb302_server_values.max_read_size = sz;
@@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
 
 void init_smb2_max_write_size(unsigned int sz)
 {
+	sz = clamp_val(sz, 65536, MAX_STREAM_PROT_LEN - MAX_SMB2_HDR_SIZE);
 	smb21_server_values.max_write_size = sz;
 	smb30_server_values.max_write_size = sz;
 	smb302_server_values.max_write_size = sz;
@@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
 
 void init_smb2_max_trans_size(unsigned int sz)
 {
+	sz = clamp_val(sz, 65536, MAX_STREAM_PROT_LEN - MAX_SMB2_HDR_SIZE);
 	smb21_server_values.max_trans_size = sz;
 	smb30_server_values.max_trans_size = sz;
 	smb302_server_values.max_trans_size = sz;
-- 
2.25.1

