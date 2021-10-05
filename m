Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC890C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 01:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976F9613AC
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 01:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJEBWp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 21:22:45 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:34323 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEBWp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Oct 2021 21:22:45 -0400
Received: by mail-pj1-f49.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so936076pjb.1
        for <linux-cifs@vger.kernel.org>; Mon, 04 Oct 2021 18:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q0KjeZWQ0xizszROKEMOYM1F0ftvj+iTfL4eFuXNmiA=;
        b=BMEPDQOCdQLndsSiU3Lxhr3KlV97LFO+a1qkaEdPSjIMUx6Kw0TM1l9S0IDEjfNPMK
         flYZveDvuqM2UcYvGGTCtD0qMyrQZH4SrLPwf+gzLWVDpPvpEn1RVgd23S3urkQ+Hcsr
         BDZUzNvmJZDwuZXvXix6UhtOHjU+Kok5nzzZyzpYsdz7uG6+TWK4HnsDbWMYnG1bsRM3
         j6WCHF15Fs6x4oTGS8mySgLP74oYvzCNGle64RCXx8kjSdfS95fJ+JA68odx8OGasapG
         IpTBg7JHKNIenWXXn2q6YDtpycLRnRAR8ZRb/BwNn/iP1+bT5KT4Qt8tcCWXgk0Dos0a
         aAxQ==
X-Gm-Message-State: AOAM532zflSVQBaYvsXiBR9YTvzOMaw9/gmZzgYRcx/n7Hj7kGRTOT29
        mWqr7IgHVqq914aiMrbib4xnZmPyVK1OwA==
X-Google-Smtp-Source: ABdhPJz7RiYgv2S7qPD6654JFcUD/iktTb3bzjIyzrw4KYMW6MRYBj9qe+MUjDPPrieEug+pbQCTzA==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr385043pjg.79.1633396855035;
        Mon, 04 Oct 2021 18:20:55 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s38sm14939341pfw.209.2021.10.04.18.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 18:20:54 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
Date:   Tue,  5 Oct 2021 10:20:42 +0900
Message-Id: <20211005012042.4263-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom suggested to use buf_data_size that is already calculated, to verify
these offsets.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Suggested-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - change data type of buf_data_size to signed to validate
     smb2_transfrom_hdr size.
 fs/ksmbd/smb2pdu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b06361313889..bb030e4366ad 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8452,20 +8452,18 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	struct smb2_hdr *hdr;
 	unsigned int pdu_length = get_rfc1002_len(buf);
 	struct kvec iov[2];
-	unsigned int buf_data_size = pdu_length + 4 -
+	int buf_data_size = pdu_length + 4 -
 		sizeof(struct smb2_transform_hdr);
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
 	int rc = 0;
 
-	if (pdu_length + 4 <
-	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
+	if (buf_data_size < sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 <
-	    le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2_transform_hdr)) {
+	if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
-- 
2.25.1

