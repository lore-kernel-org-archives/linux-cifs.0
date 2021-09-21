Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C4DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278F760EE7
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 12:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhIUMnX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 08:43:23 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:46048 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbhIUMnX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 08:43:23 -0400
Received: by mail-pg1-f173.google.com with SMTP id n18so20570712pgm.12
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 05:41:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2rPUyUebApkMdqLU1MJzy+93KaJ00Vx6WyrA/wf5aPE=;
        b=IuSqCdhynYsnPV3JTlzDJiZjtB/YbRSU+6KacnyEyWgFwKr9qLVU4KSWHiQMfpORkx
         C1DE+PCQsXhX7jk2rJFZLnPaMEWG6UZMYDUolmF73cfkmawipNZi2b/Yb51evrRMveVG
         jXak993cgUZV5lyO0fSHC7xWhNKMG6tDrrARINpMELUbsdboOUE5cVzcFdT6PLx1YQvj
         KNsnrXSOAK/6j6l/wjyejcUGw3XhJJklvmi4fkBwYLjVLDfre/yvNF/Gw9sQqgEWdhBO
         qIzyi7/kLtFwTG2tPGraRPSaPF5VX6cn+wHbJ9OjMZ0WGSMfzPNUjt5aLNkWLmelvj9u
         eMFg==
X-Gm-Message-State: AOAM533aP3KbR7feDsd/qfGJo+ZAcKClgC+YjhY7oe/eo2HaWxLaRK2t
        kQ+ckTQMnokeiFMSIvV8TnUFqUmc/4Ib6w==
X-Google-Smtp-Source: ABdhPJwfnKynKhRMXYeJNEOOiAghif8mFXygRjG1u0PXbUYinR5wtjZrOgBAy0spfnpLQIDd28M7Og==
X-Received: by 2002:a65:624b:: with SMTP id q11mr27872899pgv.232.1632228114473;
        Tue, 21 Sep 2021 05:41:54 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id a11sm17248354pfo.31.2021.09.21.05.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 05:41:54 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 3/3] ksmbd: fix invalid request buffer access in compound request
Date:   Tue, 21 Sep 2021 21:41:39 +0900
Message-Id: <20210921124139.18312-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921124139.18312-1-linkinjeon@kernel.org>
References: <20210921124139.18312-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie reported invalid request buffer access in chained command when
inserting garbage value to NextCommand of compound request.
This patch add validation check to avoid this issue.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1fe37ad4e5bc..cae796ea1148 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 
 	hdr = ksmbd_req_buf_next(work);
 	if (le32_to_cpu(hdr->NextCommand) > 0) {
+		if (work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->NextCommand) >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("next command(%u) offset exceeds smb msg size\n",
+			       hdr->NextCommand);
+			return false;
+		}
+
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-- 
2.25.1

