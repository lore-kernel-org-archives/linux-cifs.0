Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0276C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4CEC6137D
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 10:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhJEKCZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbhJEKCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 06:02:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCAEC06161C
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 03:00:34 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 145so16961663pfz.11
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 03:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VXwjAG9bt0ge+farGrKmrJvc2UWtLd+Vb1bvTL8hoik=;
        b=O+TD9P1yB0pb0mv5s5umMmuoYRCJXdcFjMiWUeLRGCuRWTFuahIgbXZjTDORRmOTVj
         x+nq13bLmImmeqP6hmapoCjaBgtWt1FqPOPlGlHHQjhxbz9j5ElLXoXAW4EcGEeMfGkE
         WuxitOGu0hGeDiY5CYp7o6YZkf/pu1hFkPamufFtqIIPdWk9y1LnHKh2s1Cbhw+5wORW
         TTOkaGF80GlUjMPRXNzJHcb9c8ssiqr6tGqoF6aKbcc0DqT1A0FJ7j5ZY9PCgP8ZkoqL
         iCjKSVcD+2F9eqAHHkfm7Xwn/5uSLI6hTixzJjd+Me5iFEhfpdkMm/mpjPYAgGgwTLRN
         aFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VXwjAG9bt0ge+farGrKmrJvc2UWtLd+Vb1bvTL8hoik=;
        b=AdgDvGTd2kZ9aqt1Wud7pjxQn/0FPDNbO8ucsoenlAlvPneKx9qZiDWfaMX6F1VrXD
         9GS+kyAojY+u3/xKuPN/6A+9XDkm3Z9vDsqpH8vBcYOS3HE/tZyUXbWIqwrmutfLGpE4
         f1fWDivCOAqyIgNL9kmPMlcHWeYiQbS4Imahns6nNibIqCyjSt0b/xsMAo0oGYLOJECi
         XY0Kvs+6cTjj1rvvzXv+f0UINS59S1NQTLU0pyEh40Hqwj/grUkopjtSqyjAojIfBBvL
         GrxOc+pYKQqIk6e+iTqzSXSLm0N0h0kmcleYJkJcG1pxDeR3+nF0YGdtw3JRcmrhK1GS
         ingA==
X-Gm-Message-State: AOAM530R7I+8PtnAYwXaFxgxlmRZ2Fwf7VhVaHeurIGIO4QxFv/LwRtt
        JTSuu48HjjcZV7BhkBSqddl75WH7HIzTu8Th
X-Google-Smtp-Source: ABdhPJzegERCIPMmLIdMgKhajDmANAEiaMZu2eQQDg1ONreEKgKhRciptsHVOxH5IpWkITnqgFTdPw==
X-Received: by 2002:a63:204a:: with SMTP id r10mr14884500pgm.365.1633428034140;
        Tue, 05 Oct 2021 03:00:34 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id u12sm2050638pjr.2.2021.10.05.03.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 03:00:33 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: improve credits management
Date:   Tue,  5 Oct 2021 19:00:26 +0900
Message-Id: <20211005100026.250280-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

* Requests except READ, WRITE, IOCTL, INFO, QUERY
DIRECOTRY, CANCEL must consume one credit.
* If client's granted credits are insufficient,
refuse to handle requests.
* Windows server 2016 or later grant up to 8192
credits to clients at once.
* For an asynchronous operation, grant credits
for an interim response and 0 credit for the
final response.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2misc.c | 38 ++++++++++++++------
 fs/ksmbd/smb2ops.c  |  4 +++
 fs/ksmbd/smb2pdu.c  | 86 ++++++++++++++++++++-------------------------
 3 files changed, 71 insertions(+), 57 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 9aa46bb3e10d..cbbea6937816 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -287,11 +287,13 @@ static inline int smb2_ioctl_resp_len(struct smb2_ioctl_req *h)
 		le32_to_cpu(h->MaxOutputResponse);
 }
 
-static int smb2_validate_credit_charge(struct smb2_hdr *hdr)
+static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
+				       struct smb2_hdr *hdr)
 {
-	int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
-	int credit_charge = le16_to_cpu(hdr->CreditCharge);
+	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
+	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
+	int ret;
 
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
@@ -313,21 +315,37 @@ static int smb2_validate_credit_charge(struct smb2_hdr *hdr)
 		req_len = smb2_ioctl_req_len(__hdr);
 		expect_resp_len = smb2_ioctl_resp_len(__hdr);
 		break;
-	default:
+	case SMB2_CANCEL:
 		return 0;
+	default:
+		req_len = 1;
+		break;
 	}
 
-	credit_charge = max(1, credit_charge);
-	max_len = max(req_len, expect_resp_len);
+	credit_charge = max_t(unsigned short, credit_charge, 1);
+	max_len = max_t(unsigned int, req_len, expect_resp_len);
 	calc_credit_num = DIV_ROUND_UP(max_len, SMB2_MAX_BUFFER_SIZE);
 
 	if (credit_charge < calc_credit_num) {
-		pr_err("Insufficient credit charge, given: %d, needed: %d\n",
-		       credit_charge, calc_credit_num);
+		ksmbd_debug(SMB, "Insufficient credit charge, given: %d, needed: %d\n",
+			    credit_charge, calc_credit_num);
+		return 1;
+	} else if (credit_charge > conn->max_credits) {
+		ksmbd_debug(SMB, "Too large credit charge: %d\n", credit_charge);
 		return 1;
 	}
 
-	return 0;
+	spin_lock(&conn->credits_lock);
+	if (credit_charge <= conn->total_credits) {
+		conn->total_credits -= credit_charge;
+		ret = 0;
+	} else {
+		ksmbd_debug(SMB, "Insufficient credits granted, given: %u, granted: %u\n",
+			    credit_charge, conn->total_credits);
+		ret = 1;
+	}
+	spin_unlock(&conn->credits_lock);
+	return ret;
 }
 
 int ksmbd_smb2_check_message(struct ksmbd_work *work)
@@ -386,7 +404,7 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	}
 
 	if ((work->conn->vals->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) &&
-	    smb2_validate_credit_charge(hdr)) {
+	    smb2_validate_credit_charge(work->conn, hdr)) {
 		work->conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
 		return 1;
 	}
diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index 197473871aa4..d7919f95be40 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -203,6 +203,7 @@ void init_smb2_1_server(struct ksmbd_conn *conn)
 	conn->ops = &smb2_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
+	conn->total_credits = 1;
 	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_HMAC_SHA256;
 
@@ -221,6 +222,7 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
+	conn->total_credits = 1;
 	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC;
 
@@ -246,6 +248,7 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
+	conn->total_credits = 1;
 	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC;
 
@@ -271,6 +274,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	conn->ops = &smb3_11_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
+	conn->total_credits = 1;
 	conn->max_credits = SMB2_MAX_CREDITS;
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC;
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index dcf907738610..6df0b0759d3f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -295,22 +295,6 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 	return 0;
 }
 
-static int smb2_consume_credit_charge(struct ksmbd_work *work,
-				      unsigned short credit_charge)
-{
-	struct ksmbd_conn *conn = work->conn;
-	unsigned int rsp_credits = 1;
-
-	if (!conn->total_credits)
-		return 0;
-
-	if (credit_charge > 0)
-		rsp_credits = credit_charge;
-
-	conn->total_credits -= rsp_credits;
-	return rsp_credits;
-}
-
 /**
  * smb2_set_rsp_credits() - set number of credits in response buffer
  * @work:	smb work containing smb response buffer
@@ -320,48 +304,51 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = ksmbd_resp_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned short credits_requested = le16_to_cpu(req_hdr->CreditRequest);
-	unsigned short credit_charge = 1, credits_granted = 0;
-	unsigned short aux_max, aux_credits, min_credits;
-	int rsp_credit_charge;
+	unsigned short credits_requested;
+	unsigned short credit_charge, credits_granted = 0;
+	unsigned short aux_max, aux_credits;
 
-	if (hdr->Command == SMB2_CANCEL)
-		goto out;
+	if (work->send_no_response)
+		return 0;
 
-	/* get default minimum credits by shifting maximum credits by 4 */
-	min_credits = conn->max_credits >> 4;
+	hdr->CreditCharge = req_hdr->CreditCharge;
 
-	if (conn->total_credits >= conn->max_credits) {
+	if (conn->total_credits > conn->max_credits) {
+		hdr->CreditRequest = 0;
 		pr_err("Total credits overflow: %d\n", conn->total_credits);
-		conn->total_credits = min_credits;
-	}
-
-	rsp_credit_charge =
-		smb2_consume_credit_charge(work, le16_to_cpu(req_hdr->CreditCharge));
-	if (rsp_credit_charge < 0)
 		return -EINVAL;
+	}
 
-	hdr->CreditCharge = cpu_to_le16(rsp_credit_charge);
+	credit_charge = max_t(unsigned short,
+			      le16_to_cpu(req_hdr->CreditCharge), 1);
+	credits_requested = max_t(unsigned short,
+				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
-	if (credits_requested > 0) {
+	/* We must grant 0 credit for the final response of an asynchronous
+	 * operation.
+	 */
+	if ((hdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) && !work->multiRsp) {
+		credits_granted = 0;
+	} else {
+		/* according to smb2.credits smbtorture, Windows server
+		 * 2016 or later grant up to 8192 credits at one.
+		 */
 		aux_credits = credits_requested - 1;
-		aux_max = 32;
 		if (hdr->Command == SMB2_NEGOTIATE)
 			aux_max = 0;
-		aux_credits = (aux_credits < aux_max) ? aux_credits : aux_max;
-		credits_granted = aux_credits + credit_charge;
+		else
+			aux_max = conn->max_credits - credit_charge;
+		aux_credits = min_t(unsigned short, aux_credits, aux_max);
+		credits_granted = credit_charge + aux_credits;
+
+		if (conn->max_credits - conn->total_credits < credits_granted)
+			credits_granted = conn->max_credits -
+				conn->total_credits;
 
-		/* if credits granted per client is getting bigger than default
-		 * minimum credits then we should wrap it up within the limits.
-		 */
-		if ((conn->total_credits + credits_granted) > min_credits)
-			credits_granted = min_credits -	conn->total_credits;
 		/*
 		 * TODO: Need to adjuct CreditRequest value according to
 		 * current cpu load
 		 */
-	} else if (conn->total_credits == 0) {
-		credits_granted = 1;
 	}
 
 	conn->total_credits += credits_granted;
@@ -371,7 +358,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 		/* Update CreditRequest in last request */
 		hdr->CreditRequest = cpu_to_le16(work->credits_granted);
 	}
-out:
 	ksmbd_debug(SMB,
 		    "credits: requested[%d] granted[%d] total_granted[%d]\n",
 		    credits_requested, credits_granted,
@@ -692,13 +678,18 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
-	struct smb2_hdr *rsp_hdr;
+	struct smb2_hdr *rsp_hdr = work->response_buf;
+
+	work->multiRsp = 1;
+	if (status != STATUS_CANCELLED) {
+		spin_lock(&work->conn->credits_lock);
+		smb2_set_rsp_credits(work);
+		spin_unlock(&work->conn->credits_lock);
+	}
 
-	rsp_hdr = work->response_buf;
 	smb2_set_err_rsp(work);
 	rsp_hdr->Status = status;
 
-	work->multiRsp = 1;
 	ksmbd_conn_write(work);
 	rsp_hdr->Status = 0;
 	work->multiRsp = 0;
@@ -1233,6 +1224,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 
 	conn->srv_sec_mode = le16_to_cpu(rsp->SecurityMode);
 	ksmbd_conn_set_need_negotiate(work);
+	conn->total_credits = 0;
 
 err_out:
 	if (rc < 0)
-- 
2.25.1

