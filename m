Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE631C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 12:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCFF60F41
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 12:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhIVMCg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 08:02:36 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:40556 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhIVMCf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 08:02:35 -0400
Received: by mail-pf1-f178.google.com with SMTP id y8so2518670pfa.7
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 05:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fl9EhmvPYMBoTjAozKiT3saVzelater/tJoJiDfWUpA=;
        b=0JFxwS3Hz+whUoReooD3rk64jMrB/jZOKLuOTxNDbhjMTPYeUZBgD7hpBWfwmpHrVc
         dlZLJEDlfRZviulw01vp30bJNmlB5aDLzx/UfPOTRlhUF5PX2vYIp2kqxIc0FEPeKqZu
         bG7iKUyUhUQVzCcJECSUX3UvjEDENOGiO6UyNNSoxuvH5EBy8hgWi/y5wbMqUhiH8vw6
         7T+c6VbV0bo5zdY5Zz/CHSFQpFxxUvTgIrRAir2mRJeWbMgX3qleoet3/4dEOPdsnvZI
         +G2AReQly2irCDWfcy4LFgGRByBUXUSkv/IrDun/mNlTgLQt3zbst6GCF3djXoDtEUKV
         TUGA==
X-Gm-Message-State: AOAM5300NqJ8Vs2YB9yfrWVrQ29gHto9xHJq3cKU+kT4SjX3/C257lVH
        KbH2sts3WEpMCVIGN8T5uICid+ViY+jjlA==
X-Google-Smtp-Source: ABdhPJzx4uNmV2PD+327IZGvzdxEB0FjyXm8OPvVkQn32NltlsJE+NmzBKVd8n92L9HxP6hEcnL1uQ==
X-Received: by 2002:a63:b241:: with SMTP id t1mr5564735pgo.154.1632312065688;
        Wed, 22 Sep 2021 05:01:05 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id g17sm2485015pfo.11.2021.09.22.05.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 05:01:05 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] ksmbd: check protocol id in ksmbd_verify_smb_message()
Date:   Wed, 22 Sep 2021 21:00:57 +0900
Message-Id: <20210922120057.45789-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When second smb2 pdu has invalid protocol id, ksmbd doesn't detect it
and allow to process smb2 request. This patch add the check it in
ksmbd_verify_smb_message() and don't use protocol id of smb2 request as
protocol id of response.

Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c    |  2 +-
 fs/ksmbd/smb_common.c | 13 +++++++++----
 fs/ksmbd/smb_common.h |  1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 3d250e2539e6..3be1493cb18d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -433,7 +433,7 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
 		work->compound_pfid = KSMBD_NO_FID;
 	}
 	memset((char *)rsp_hdr + 4, 0, sizeof(struct smb2_hdr) + 2);
-	rsp_hdr->ProtocolId = rcv_hdr->ProtocolId;
+	rsp_hdr->ProtocolId = SMB2_PROTO_NUMBER;
 	rsp_hdr->StructureSize = SMB2_HEADER_STRUCTURE_SIZE;
 	rsp_hdr->Command = rcv_hdr->Command;
 
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index da17b21ac685..ace8a1b02c81 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -129,16 +129,22 @@ int ksmbd_lookup_protocol_idx(char *str)
  *
  * check for valid smb signature and packet direction(request/response)
  *
- * Return:      0 on success, otherwise 1
+ * Return:      0 on success, otherwise -EINVAL
  */
 int ksmbd_verify_smb_message(struct ksmbd_work *work)
 {
-	struct smb2_hdr *smb2_hdr = work->request_buf;
+	struct smb2_hdr *smb2_hdr = work->request_buf + work->next_smb2_rcv_hdr_off;
+	struct smb_hdr *hdr;
 
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
 
-	return 0;
+	hdr = work->request_buf;
+	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
+	    hdr->Command == SMB_COM_NEGOTIATE)
+		return 0;
+
+	return -EINVAL;
 }
 
 /**
@@ -270,7 +276,6 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 	return BAD_PROT_ID;
 }
 
-#define SMB_COM_NEGOTIATE	0x72
 int ksmbd_init_smb_server(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index d7df19c97c4c..994abede27e9 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -202,6 +202,7 @@
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
 #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
+#define SMB_COM_NEGOTIATE		0x72
 
 #define SMB1_CLIENT_GUID_SIZE		(16)
 struct smb_hdr {
-- 
2.25.1

