Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC9BC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E60D6103C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 03:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbhIWDu7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 23:50:59 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:44681 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239312AbhIWDus (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 23:50:48 -0400
Received: by mail-pl1-f171.google.com with SMTP id t11so3115751plq.11
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 20:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnroerlrJfQOlxtLeMGl8hDYpX0iq3qmP1Trv9UIhOk=;
        b=P3CyFKocfsvD98+l2CZUfWiqtx7sUR7uetCdA5pIWsOp4qir9ePko8uqMcJTSSGjwo
         2sE6T7uuSHK75gnGm0ND5aA/iOwlpdkUfZBqmZ6DGXdC80QmUYHCStDWiIwXyypTVW0I
         okqcTAYMyzTqQPZCwnnDL2UXsmrijZr46pLMX5hMpwSVmHWvf0VNUTWvoS9VSZTDsP2w
         2SOHTAiEHlijAV7WyIQxVcatSrJrzX4y5pIZl3EnWazSAh8GGxzduXGQWaXjxbPTcBKR
         8OFc/YfrBkdArd3FOpODItBXg/VVZdSswdUAaz3vABjF7oB837VU2ZNzpbTdhyDoo7uO
         m2RA==
X-Gm-Message-State: AOAM533YyVGJXA7lVUObESlKpVNUZei7yKO/NJIVd8+bri8EzSDtvYVB
        hy4uqjU/iA3jzwVjATpplu12A8Rl+PD15A==
X-Google-Smtp-Source: ABdhPJytJdc5q4SY5+yHb023Ccgcm30t6mOKs14es+cgdehpWhTh0tYl7UpIC2tfnRPyOBH0SAirPw==
X-Received: by 2002:a17:903:1d1:b0:13c:897c:c04b with SMTP id e17-20020a17090301d100b0013c897cc04bmr1948873plh.76.1632368956939;
        Wed, 22 Sep 2021 20:49:16 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y204sm3045883pfc.100.2021.09.22.20.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 20:49:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH v4] ksmbd: fix invalid request buffer access in compound
Date:   Thu, 23 Sep 2021 12:48:54 +0900
Message-Id: <20210923034855.612832-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210923034855.612832-1-linkinjeon@kernel.org>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie reported invalid request buffer access in chained command when
inserting garbage value to NextCommand of compound request.
This patch add validation check to avoid this issue.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
  v2:
   - fix integer overflow from work->next_smb2_rcv_hdr_off.
  v3:
   - check next command offset and at least header size of next pdu at
     the same time.
  v4:
   - add next_cmd variable not to avoid repeat conversion.

 fs/ksmbd/smb2pdu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 90f867b9d560..301558a04298 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -459,13 +459,21 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 bool is_chained_smb2_message(struct ksmbd_work *work)
 {
 	struct smb2_hdr *hdr = work->request_buf;
-	unsigned int len;
+	unsigned int len, next_cmd;
 
 	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
 		return false;
 
 	hdr = ksmbd_req_buf_next(work);
-	if (le32_to_cpu(hdr->NextCommand) > 0) {
+	next_cmd = le32_to_cpu(hdr->NextCommand);
+	if (next_cmd > 0) {
+		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd + 64 >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("next command(%u) offset exceeds smb msg size\n",
+			       next_cmd);
+			return false;
+		}
+
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-- 
2.25.1

