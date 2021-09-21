Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF35DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 22:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C23C661107
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 22:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhIUWxA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:53:00 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:37802 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhIUWw7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 18:52:59 -0400
Received: by mail-pf1-f176.google.com with SMTP id j6so983906pfa.4
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 15:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ucg+j7F1oU0EVCrtP7KfvBr0C46ii/UDAZ4jZdbZ+6I=;
        b=J2Oi0uuVxTL0sHK8tSwIQIAmhB08I55P8okBtKhmZ4NpkIWgNcre3orqEpA1ekL7lG
         8lJruf2kb4Azz7F+LSQpdIJEnttqgTlBJAuSvThEioat5iScWscaZklSVE6opWn6kOh2
         KHxU98EwwUnmCYxi9rr32kxKoXkrFGWqbW1NHlBAbBTj1sJDeTGCMG4gDCqd3UNexp2r
         Ni9z6c4WGQJosdwL4EdRnWv7fUXXvyTKIL4ErYoxWdaAGR7fviutrXGDC2JQxoazqILf
         SD3XuNx9A+euxDGYuE7n9ADWKJQjLlauO/5rzTGQvXvrHh8bQ4lLlRm34lydTei4P7Br
         bPFw==
X-Gm-Message-State: AOAM532MrPaCR/sLNiVBmDmO9bm/x8uUqgDUbkMoq/zkoh52RiwU6zxx
        MrzrFBNfDjHLzgWELe1+3efzs1RemS8MQw==
X-Google-Smtp-Source: ABdhPJzXSKKx0I5zkfLKC7SnTMyWVMu2Vf1GuOmFxHQ5BwNwV1e6ocjl6A4h9E5oHtRyRI3urHuG4g==
X-Received: by 2002:a63:6f42:: with SMTP id k63mr30112967pgc.358.1632264690197;
        Tue, 21 Sep 2021 15:51:30 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id e18sm167053pfj.159.2021.09.21.15.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:51:29 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH v2 3/3] ksmbd: fix invalid request buffer access in compound request
Date:   Wed, 22 Sep 2021 07:51:09 +0900
Message-Id: <20210921225109.6388-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921225109.6388-1-linkinjeon@kernel.org>
References: <20210921225109.6388-1-linkinjeon@kernel.org>
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
 v2:
  - fix integer overflow from work->next_smb2_rcv_hdr_off.

 fs/ksmbd/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1fe37ad4e5bc..cae796ea1148 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 
 	hdr = ksmbd_req_buf_next(work);
 	if (le32_to_cpu(hdr->NextCommand) > 0) {
+		if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->NextCommand) >
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

