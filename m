Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952C4C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F84461A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354359AbhJAM1i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJAM1h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BA8C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Q0neQf3DKShcAntux8ELXSZVcbd+9OfbnnszLV4r0Y8=; b=Zw5/0nGZbPlJucB1qptaPkxzk8
        krfqiLxTnZN33IcGEbUd2mTULVDbfni115ZP/jsHH+sxEYBkor3b+e3Hz8dxl63NcjTQ17oZME760
        rZogi3wcKCTxf22aLZkwMPSWtJZtcNaqgiUaDCHirhaOwDTE6gIOXn5JbSfDRAVxoFCvkhzBLM+wv
        PsYZRvbhqJ6+VJb55E/EZV7h6o/etMKLtKaQm2GkvxFKqkwv7ODbvtMjNqalHQlbGScY3GRROO6+d
        3V8fpYqQi+Ospd94Bi91wAMJL/7zydOMYX4WzW0VklQJ2Duxfch/h6J16DaqkKgcD4gbkkgSsFBzR
        nBTXza3V1scheKROZI/Hd/0Fsozf42f8o8XJpA/S0MK+xp7GMkJ4TjG/6cWgFuq+JQm8pqFziQki7
        KgxWFWLVbLy4Iw4XkB41L4CXnlZjme7hEE/wwOzx+Tx3+SBSdLPHJDwYnf+IzoInb1ZxIlRNsJXF8
        3YYLHrDndiXc9dxgcfvsukKp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIR-0013Z3-4o; Fri, 01 Oct 2021 12:05:47 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 11/20] ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
Date:   Fri,  1 Oct 2021 14:04:12 +0200
Message-Id: <20211001120421.327245-12-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

No change in behaviour.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 9edd9c161b27..2cc031c39514 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -329,17 +329,12 @@ static int smb2_validate_credit_charge(struct smb2_hdr *hdr)
 
 int ksmbd_smb2_check_message(struct ksmbd_work *work)
 {
-	struct smb2_pdu *pdu = work->request_buf;
+	struct smb2_pdu *pdu = ksmbd_req_buf_next(work);
 	struct smb2_hdr *hdr = &pdu->hdr;
 	int command;
 	__u32 clc_len;  /* calculated length */
 	__u32 len = get_rfc1002_len(pdu);
 
-	if (work->next_smb2_rcv_hdr_off) {
-		pdu = ksmbd_req_buf_next(work);
-		hdr = &pdu->hdr;
-	}
-
 	if (le32_to_cpu(hdr->NextCommand) > 0) {
 		len = le32_to_cpu(hdr->NextCommand);
 	} else if (work->next_smb2_rcv_hdr_off) {
-- 
2.31.1

