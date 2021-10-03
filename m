Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A36C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAC361AE0
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 04:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhJCEdE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Oct 2021 00:33:04 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:40560 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJCEdD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Oct 2021 00:33:03 -0400
Received: by mail-pf1-f181.google.com with SMTP id y8so11561487pfa.7
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 21:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aqG+PiBsuD9YBGcDWEmbTTjraYxy41A8XoG9qAESQB8=;
        b=OPKNyJ5pFGx0j3OpXviB4VKKOJjIj4SD+jz4pv4Ofms7Xjxlwt/LSed7m7jfG1Rg/E
         /msIQ05WeH4PymmcwgammSrCr49AwmNDjcx8rtqUpvlEiuscgF9T/17QCHjqhBbdyRcZ
         J+lkgkdOP/l4x8S1RRHKWoAPohk0xoTxzvxQpbsracBVefwSi3LdxF86wC6CUF1+i/zi
         dj2sHJduDTnUGPUkw+zPxFwGeyMj8tuPXCO/5cK9RzQlJ0+otMDwNfmSrgxLM8HS4XDF
         u7RDjPXCjpypBwfdgad56kXizWyiEz4Aq5wnm476pHzIkJnDAXF1ovnJH7uZElUfrmDJ
         Sa+Q==
X-Gm-Message-State: AOAM5302E35j2VJ/ltBLa8yrA5o4luwQS0tPJ0tdBEm6oi41yaTB//zs
        PdechxOfg85Kk71e6EoLDQMi96/8oQfwyQ==
X-Google-Smtp-Source: ABdhPJwcs8r71dB8af5l7bguDSaPN7ZFMdnUpuuMSRBExoC7qq54+lxUkJyS56F2c//Fd1Jq05aWJg==
X-Received: by 2002:a65:47cd:: with SMTP id f13mr5394246pgs.439.1633235476842;
        Sat, 02 Oct 2021 21:31:16 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id w136sm3845782pfc.50.2021.10.02.21.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 21:31:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 1/3] ksmbd: use buf_data_size instead of recalculation in smb3_decrypt_req()
Date:   Sun,  3 Oct 2021 13:31:03 +0900
Message-Id: <20211003043105.10453-1-linkinjeon@kernel.org>
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
 fs/ksmbd/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b06361313889..4d1be224dd8e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8457,15 +8457,13 @@ int smb3_decrypt_req(struct ksmbd_work *work)
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

