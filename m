Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF62C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D606136A
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354356AbhJAM1N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353431AbhJAM1M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0CEC061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=kAtciHOP6QyrU99e5spGof+UvOvqxpuqqrQn0N/XcRs=; b=D2QRkrU0wRYoXCzz4ttemaFX76
        ezSv2F7Cxjr1joFuWgHlB+07aLkTZ1L4a5KSslvABYuP40sn7uIaql0zeQBRYSRewmuzgtYPKAIps
        rCHy5wxcEWAjOFOZAW0lJO3aZnV7EXXqfvxzo33iRdO5MgyusOqeJCt7m1BflyhIDa6dhdbWbRQUW
        Ic60G6XQYoJhpFEpym1+SbsZWjNjgsvOLtqj1dRC88j6xvpwjYmB95OYwgYpR2kzVV/MkEaUHSbiX
        WkPiCUnihm5ebY4iQX1DdfQSCMmiNdXCtngFAEwSl0w55dTsb4ztSjFakLcgIMlI5FwrWTd15ciFI
        AoObdh8L96lqkNOsqHByNgDhmQfJrDNzVsR5mYBAZ8QxE6issnx7PSFp1j/d8V860giRcEYsIF25r
        6AjJmfy2LvOk1/pSTG1f2CoxjXhiik+riH1mlvIYIcYLvqgaXONLQ3mfrMhxRYb5lo5YC3/l602Al
        vHw/WFyWik3fYISgFKivsoiZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIS-0013Z3-Ty; Fri, 01 Oct 2021 12:05:49 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 14/20] ksmbd: add ksmbd_smb2_cur_pdu_buflen()
Date:   Fri,  1 Oct 2021 14:04:15 +0200
Message-Id: <20211001120421.327245-15-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c | 25 +++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.h  |  1 +
 2 files changed, 26 insertions(+)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 2cc031c39514..76f53db7db8d 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -427,3 +427,28 @@ int smb2_negotiate_request(struct ksmbd_work *work)
 {
 	return ksmbd_smb_negotiate_common(work, SMB2_NEGOTIATE_HE);
 }
+
+/**
+ * ksmbd_smb2_cur_pdu_buflen() - Get len of current SMB2 PDU buffer
+ * This returns the lenght including any possible padding.
+ * @work: smb work containing request buffer
+ */
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work)
+{
+	struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
+	unsigned int buf_len;
+	unsigned int pdu_len;
+
+	if (hdr->NextCommand != 0) {
+		/*
+		 * hdr->NextCommand has already been validated by
+		 * init_chained_smb2_rsp().
+		 */
+		return __le32_to_cpu(hdr->NextCommand);
+	}
+
+	buf_len = get_rfc1002_len(work->request_buf);
+	pdu_len = buf_len - work->next_smb2_rcv_hdr_off;
+	return pdu_len;
+}
+
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index a6dec5ec6a54..c5fa8256b0bb 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1680,6 +1680,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work);
 
 /* smb2 misc functions */
 int ksmbd_smb2_check_message(struct ksmbd_work *work);
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work);
 
 /* smb2 command handlers */
 int smb2_handle_negotiate(struct ksmbd_work *work);
-- 
2.31.1

