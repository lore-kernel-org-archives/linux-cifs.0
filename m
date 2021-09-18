Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C726C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 09:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251AB60F6C
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 09:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhIRJrF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 05:47:05 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:38816 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbhIRJrE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 05:47:04 -0400
Received: by mail-pl1-f169.google.com with SMTP id 5so7818715plo.5
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 02:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=et4+Jo6bdmEUHnw9w3hVIqpmkaVnpeuQHHFJHbkbiYk=;
        b=NePqe2ZrPGBH2iWVuxEOMz/bXMmHvhc6nkxGVSn3BMaEKbmv1M9p7HcJsAO7O1GNE+
         rpQy5v5xr9nVenxfuw4wlz+XU0YJdgFTCWTQgy17Zii/1AczvfNV5QHd49DLhxXx6T+l
         IZQWU4ZyjJKCP/lLJ2oBUxqpAXYxdNDkqvbj3vOUR8wwxg/4kL9tN3r0zu1+vbd2edGp
         zrIJXvjMSqHrcrcUJ4/YuYXni6YRX1epCMiuEYMpyB8vlGPfTCWPSNYZO28y6zqW/7G8
         pPBBh5/A67QJb4RKCBuxQpDT5aZT+0f8pNf/IKUj7irdmppMgvWb6XBMDs9B1Kj/6Ahq
         x/Hg==
X-Gm-Message-State: AOAM532gvyyMFRrd72ea8R1vpHAGulNVzqXj6NpsuTr+DDWggtM9kvhX
        gckjTSBj7fxZ5E76iepHh1Q/BscpN4EW1A==
X-Google-Smtp-Source: ABdhPJw7/pEdXNiXV1Ao/GRRAGRmRZdsqDOAjURWYtQbCcag/7Fe1v85BvtG5PKQbbWzIYoFtozmRw==
X-Received: by 2002:a17:90a:890a:: with SMTP id u10mr17724050pjn.40.1631958341160;
        Sat, 18 Sep 2021 02:45:41 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id l10sm8928966pgn.22.2021.09.18.02.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 02:45:40 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3/4] ksmbd: add validatioin for FILE_FULL_EA_INFORMATION of smb2_get_info
Date:   Sat, 18 Sep 2021 18:45:12 +0900
Message-Id: <20210918094513.89480-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210918094513.89480-1-linkinjeon@kernel.org>
References: <20210918094513.89480-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add validation to check whether req->InputBufferLength is smaller than
smb2_ea_info_req structure size.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e589e8cc389f..e92af212583e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4059,6 +4059,10 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 	path = &fp->filp->f_path;
 	/* single EA entry is requested with given user.* name */
 	if (req->InputBufferLength) {
+		if (le32_to_cpu(req->InputBufferLength) <
+		    sizeof(struct smb2_ea_info_req))
+			return -EINVAL;
+
 		ea_req = (struct smb2_ea_info_req *)req->Buffer;
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
-- 
2.25.1

