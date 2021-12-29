Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C56C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 14:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbhL2OPM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 09:15:12 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39628 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbhL2OPM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 09:15:12 -0500
Received: by mail-pf1-f173.google.com with SMTP id s15so18881432pfk.6
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 06:15:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MXkc4rG77Or5uEa2IcG5mvzOiR4GXaButuOy0vaxCk=;
        b=6V/9eWpQYxTamkWx27GB34s097es3PCTshRQRk+TqoNRnjc3LjOHMY9hu+NgRv8n/m
         xASPqcXXUFqgUaHwnMP+Ji5WXdIhpOoi5YAhap+IUi2acXwAqZLG6jTYmJPcVLMeBpMe
         QTKYPu4V+PAiyiw7ZZsaUaHZbydrcLkYYJVn1myecEtJv9nHbMH4jck51wxOpD5Tj0wL
         lR6+j5BKz8RQQe7eImMyRxsrDwwFGFUsxsH/aHDiQbfxiNfw6gYB0TpbAx1voZBEA9IK
         iskYW9FDovrpwqqgc2RPApNRivNyT317PmeWGCXTCYvglYFaj8/0xPEnYwxnGwyiq1bR
         KS0A==
X-Gm-Message-State: AOAM531781OmbG2/tIbRzjhfqeSGX3pQoYkrWOYqwR9bMajP4VW4EhvC
        ipKiwL0sy6qGIb2B9kq7imfu9nQ+uAg=
X-Google-Smtp-Source: ABdhPJxBGBMhOP8zrbP/eVidra4v+CWcs01yNJroxbQryPF/xQYqLVXy58vktlrb+mqyCM7F03PrEw==
X-Received: by 2002:a63:ab0d:: with SMTP id p13mr23390649pgf.570.1640787311562;
        Wed, 29 Dec 2021 06:15:11 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s9sm15822287pfw.174.2021.12.29.06.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:15:11 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/4] ksmbd: move credit charge deduction under processing request
Date:   Wed, 29 Dec 2021 23:14:57 +0900
Message-Id: <20211229141457.11636-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229141457.11636-1-linkinjeon@kernel.org>
References: <20211229141457.11636-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Moves the credit charge deduction from total_credits under the processing
a request. When repeating smb2 lock request and other command request,
there will be a problem that ->total_credits does not decrease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c |  7 ++-----
 fs/ksmbd/smb2pdu.c  | 16 ++++++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 6892d1822269..fedcb753c7af 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -289,7 +289,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	unsigned int req_len = 0, expect_resp_len = 0, calc_credit_num, max_len;
 	unsigned short credit_charge = le16_to_cpu(hdr->CreditCharge);
 	void *__hdr = hdr;
-	int ret;
+	int ret = 0;
 
 	switch (hdr->Command) {
 	case SMB2_QUERY_INFO:
@@ -332,10 +332,7 @@ static int smb2_validate_credit_charge(struct ksmbd_conn *conn,
 	}
 
 	spin_lock(&conn->credits_lock);
-	if (credit_charge <= conn->total_credits) {
-		conn->total_credits -= credit_charge;
-		ret = 0;
-	} else {
+	if (credit_charge > conn->total_credits) {
 		ksmbd_debug(SMB, "Insufficient credits granted, given: %u, granted: %u\n",
 			    credit_charge, conn->total_credits);
 		ret = 1;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 860fe3a03ad7..b6b418e77a1f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -299,9 +299,8 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = ksmbd_resp_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned short credits_requested;
+	unsigned short credits_requested, aux_max;
 	unsigned short credit_charge, credits_granted = 0;
-	unsigned short aux_max, aux_credits;
 
 	if (work->send_no_response)
 		return 0;
@@ -316,6 +315,13 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 
 	credit_charge = max_t(unsigned short,
 			      le16_to_cpu(req_hdr->CreditCharge), 1);
+	if (credit_charge > conn->total_credits) {
+		ksmbd_debug(SMB, "Insufficient credits granted, given: %u, granted: %u\n",
+			    credit_charge, conn->total_credits);
+		return -EINVAL;
+	}
+
+	conn->total_credits -= credit_charge;
 	credits_requested = max_t(unsigned short,
 				  le16_to_cpu(req_hdr->CreditRequest), 1);
 
@@ -325,13 +331,11 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	 * TODO: Need to adjuct CreditRequest value according to
 	 * current cpu load
 	 */
-	aux_credits = credits_requested - 1;
 	if (hdr->Command == SMB2_NEGOTIATE)
-		aux_max = 0;
+		aux_max = 1;
 	else
 		aux_max = conn->vals->max_credits - credit_charge;
-	aux_credits = min_t(unsigned short, aux_credits, aux_max);
-	credits_granted = credit_charge + aux_credits;
+	credits_granted = min_t(unsigned short, credits_requested, aux_max);
 
 	if (conn->vals->max_credits - conn->total_credits < credits_granted)
 		credits_granted = conn->vals->max_credits -
-- 
2.25.1

