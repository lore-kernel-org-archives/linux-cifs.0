Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EDBC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE60F610F7
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 02:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243852AbhIXCO6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:14:58 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:40550 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243813AbhIXCO6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 22:14:58 -0400
Received: by mail-pf1-f169.google.com with SMTP id y8so7509310pfa.7
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 19:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rAxEmtuTUm9znkvUo6NWgvmjqAsSvc9YCSz6ELvR7PI=;
        b=d4JBV5GEtkCmdikb21guGuVXyoawS+zo79fc2Q4uXP9kvmM5LDR7Q79VutDP6ZX0Ti
         8sEj32eCFcGqa3Irmk0oIPau2E/ReIFa48OYO16OU9/bbBm+Niqql5Mmo3a9AHUeii5J
         YOiLycdCZigSmNu1KvMN5hb7FoVbmUsAf9zzPhP98lLwqnWpxzK1tZL6MS4CB2j03vUG
         JUAfEkDGqjVW67QNWaXyhd/MpI+6opjpxO6llK1EKMwGdgAtUnGan7Us4TSJwxo+X8sX
         tNx5QoRbJtGFdpaA6u673ObujtOyCQ+coAAOQK/06qeWxAM9ouNroUTjwibv70P2ktbX
         BvHw==
X-Gm-Message-State: AOAM5300OyhaNr6wd51F5gyUxawvXAT27jInlh9G01NIw4fCoxQfoWR9
        dq5f+t8Wc4WpFR2fZYMuIFolXHbfcQe48g==
X-Google-Smtp-Source: ABdhPJz0TSkbg7kjtJG2yTL9md+Bm0hoQbrRpOMk+YI5XZK77scHY8Nd3gCYLPieFGn6+4iY0WMV1w==
X-Received: by 2002:a05:6a00:248c:b0:447:52ee:f646 with SMTP id c12-20020a056a00248c00b0044752eef646mr7652251pfv.75.1632449605419;
        Thu, 23 Sep 2021 19:13:25 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id c16sm6724746pfo.163.2021.09.23.19.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 19:13:24 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6/7] ksmbd: fix invalid request buffer access in compound
Date:   Fri, 24 Sep 2021 11:12:53 +0900
Message-Id: <20210924021254.27096-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924021254.27096-1-linkinjeon@kernel.org>
References: <20210924021254.27096-1-linkinjeon@kernel.org>
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
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a930838fd6ac..4f7b5e18a7b9 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -459,13 +459,22 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
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
+		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
+			__SMB2_HEADER_STRUCTURE_SIZE >
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

