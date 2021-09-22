Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CDAC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 12:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6112860FE6
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 12:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhIVMDX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 08:03:23 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:41704 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhIVMDW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 08:03:22 -0400
Received: by mail-pl1-f175.google.com with SMTP id v2so1591662plp.8
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 05:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jo8uXsEWn8O4G8+ikxDQ8kMUvdzkae4UFWZEkwZkLBo=;
        b=OZxC9zPFPa99FKFF2ozvdiZSuJhx7+2LRnzex0+HFco1wLeDAYpJ/Ca/7FBWYrHRAf
         YJWwHNo2HSzQ3Pl6m9htNqYOWxGTiIxUU3ink+qdEECrMKaoVGC6UYB+pA1ikwBmWjHa
         9UF40Qa17gvfVzL6UAyzsUUrf+8CZ1sHILUfpdcYvExnVnui2QHRs0zPnZ0whGOSyuaj
         FeqkC4pVSBQoWRVQHvF0WVDZiDyAFKQhPaQ9RtD5sI/m8MObtIe/IciP29MF7Wd0bnm2
         7YWSEcnyxkmyGk+AATktsZSAdep/CKdO0vP3UmsF30nxtUGU5MNHp8+CG8M9OJwv9iZD
         HAxg==
X-Gm-Message-State: AOAM532UrRt4JSJMT2d6HnNDzsA278HIpntDLRzFFEVtz0IRd1yr70X/
        a3FBBc6XG7BQUJ6WmSDaBrEAcXLR3cPxCg==
X-Google-Smtp-Source: ABdhPJz5De7eOqJ4SeJfm3Lev9cD4P022PKVrlijtveq09nL3OdSN/IJtp02FqPuLkJeYvjByC6CVA==
X-Received: by 2002:a17:902:784c:b0:138:f4e5:9df8 with SMTP id e12-20020a170902784c00b00138f4e59df8mr31989334pln.14.1632312112554;
        Wed, 22 Sep 2021 05:01:52 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id d22sm2634295pgi.73.2021.09.22.05.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 05:01:52 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH v3] ksmbd: fix invalid request buffer access in compound request
Date:   Wed, 22 Sep 2021 21:01:43 +0900
Message-Id: <20210922120143.45953-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
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
  v3:
   - check next command offset and at least header size of next pdu at
     the same time.
 fs/ksmbd/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4f11eb85bb6b..3d250e2539e6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 
 	hdr = ksmbd_req_buf_next(work);
 	if (le32_to_cpu(hdr->NextCommand) > 0) {
+		if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->NextCommand) + 64 >
+		    get_rfc1002_len(work->request_buf)) {
+			pr_err("next command(%u) offset exceeds smb msg size\n",
+			       le32_to_cpu(hdr->NextCommand));
+			return false;
+		}
+
 		ksmbd_debug(SMB, "got SMB2 chained command\n");
 		init_chained_smb2_rsp(work);
 		return true;
-- 
2.25.1

