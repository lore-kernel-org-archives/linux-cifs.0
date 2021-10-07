Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F7C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 07:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79710610C8
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 07:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbhJGHar (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 03:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhJGHar (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Oct 2021 03:30:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8EFC061746
        for <linux-cifs@vger.kernel.org>; Thu,  7 Oct 2021 00:28:54 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s11so4830611pgr.11
        for <linux-cifs@vger.kernel.org>; Thu, 07 Oct 2021 00:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ngu7Ul1QRLGwwRN4Y7BwXdv8P9bRv97KJocCSoe02Rw=;
        b=cyXe0zPmhUCBj4FTSyUXR6RD/iUCLRfKcn/WUrwbRGdENN4MtgEvPxGb+edf/rsN1m
         AePBdH69D9HXGXt/iAkdfl7QAMmq3S7NYH+w01S+xjOevRPL49FMYZevwM5JzD6tHcRs
         06H6LiCpHtEwKR9F89WdyMCv1ChlfwgpV+ZrPTE3svRc4vTU0uBC1a6vUFuGGaXvSjp/
         MRvQeFI/oZVaZ4GsT1PvDi6dTykAw/tpkpA+Z/AnGEyAU0lgmpEEW1D5+Uctugku/8Am
         w6Bbzwt2OQiAepHmu8PUrOjU8zjXAFkyCgAnD12kJIYyInCF9tJbNkmQMH89hCeHzb+0
         NhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ngu7Ul1QRLGwwRN4Y7BwXdv8P9bRv97KJocCSoe02Rw=;
        b=h+rmL7gptbMKR7GQ9TuBMQxnDMeFeHtRW7g5CFJUdUe0+j8vhhZ3+rqVLOpOn2yosk
         Oxs+TxmW3FulZSzFnL3rgk/afPwHW01KGmHABAVIobaa+KxYFBVkX+HQbBOOPhPW6O99
         vIXGHa5cAiDXsL9I8DILZnDwKatDea9Jt5x6Zem9//w0NQsXUjRuAwbTlfyjRPudM4gg
         2hIm+i8GIiF0zZhNciS1c/y42u0pSL55HPH6uU1fVx+lHJ04myLFs+4Abx9KB7Wwrb2b
         8so5NMVK8NgwBxWn0yXC+41l1rua0l0y+hZ1Df0dVFEro0XYOHeTI9frac223wRnfyFA
         faKA==
X-Gm-Message-State: AOAM532RVNPsnAUJnQ5lQDZ/YGK5FDMSS8iIoNvSXoIpkCV78hiJ+9HB
        sNSR32NLPlo//eXO7uT1NTP0OmoenArf2OFinVA=
X-Google-Smtp-Source: ABdhPJw5cywKCb0RbBuMSdfsoUDN9xZsxSC7uQTs3F+hNnzbmkq9wbo+ibwoANn7ygTZAlu5aL5Xuw==
X-Received: by 2002:a62:3204:0:b0:44c:8bea:4c8d with SMTP id y4-20020a623204000000b0044c8bea4c8dmr2806505pfy.64.1633591733436;
        Thu, 07 Oct 2021 00:28:53 -0700 (PDT)
Received: from localhost.localdomain ([210.123.88.105])
        by smtp.googlemail.com with ESMTPSA id t8sm17930229pgv.35.2021.10.07.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 00:28:53 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: improve credits management
Date:   Thu,  7 Oct 2021 16:26:58 +0900
Message-Id: <20211007072658.352494-1-hyc.lee@gmail.com>
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

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
Changes from v1:
 - move conn->total_credits = 1 into ksmbd_conn_alloc().
 - remove credits management related with an interim
   response.

 fs/ksmbd/connection.c |  2 ++
 fs/ksmbd/smb2misc.c   | 38 ++++++++++++++------
 fs/ksmbd/smb2pdu.c    | 81 ++++++++++++++++---------------------------
 3 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index af086d35398a..ed7e9330e89f 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -61,6 +61,8 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		conn->local_nls = load_nls_default();
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
+	conn->total_credits = 1;
+
 	init_waitqueue_head(&conn->req_running_q);
 	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->sessions);
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
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index dcf907738610..6a5af51f3c16 100644
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
@@ -320,49 +304,43 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
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
-		aux_credits = credits_requested - 1;
-		aux_max = 32;
-		if (hdr->Command == SMB2_NEGOTIATE)
-			aux_max = 0;
-		aux_credits = (aux_credits < aux_max) ? aux_credits : aux_max;
-		credits_granted = aux_credits + credit_charge;
+	/* according to smb2.credits smbtorture, Windows server
+	 * 2016 or later grant up to 8192 credits at once.
+	 *
+	 * TODO: Need to adjuct CreditRequest value according to
+	 * current cpu load
+	 */
+	aux_credits = credits_requested - 1;
+	if (hdr->Command == SMB2_NEGOTIATE)
+		aux_max = 0;
+	else
+		aux_max = conn->max_credits - credit_charge;
+	aux_credits = min_t(unsigned short, aux_credits, aux_max);
+	credits_granted = credit_charge + aux_credits;
 
-		/* if credits granted per client is getting bigger than default
-		 * minimum credits then we should wrap it up within the limits.
-		 */
-		if ((conn->total_credits + credits_granted) > min_credits)
-			credits_granted = min_credits -	conn->total_credits;
-		/*
-		 * TODO: Need to adjuct CreditRequest value according to
-		 * current cpu load
-		 */
-	} else if (conn->total_credits == 0) {
-		credits_granted = 1;
-	}
+	if (conn->max_credits - conn->total_credits < credits_granted)
+		credits_granted = conn->max_credits -
+			conn->total_credits;
 
 	conn->total_credits += credits_granted;
 	work->credits_granted += credits_granted;
@@ -371,7 +349,6 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 		/* Update CreditRequest in last request */
 		hdr->CreditRequest = cpu_to_le16(work->credits_granted);
 	}
-out:
 	ksmbd_debug(SMB,
 		    "credits: requested[%d] granted[%d] total_granted[%d]\n",
 		    credits_requested, credits_granted,
-- 
2.25.1

