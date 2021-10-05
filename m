Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F61FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 763EB61373
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJEF1J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhJEF1J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:27:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2426BC061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=kCIffVkTqm0C4KWFGoZnffHe/6WW9WX5+3VdjIPYhs8=; b=ZL8HrOL6xtZ1SbUKJACrKcv8xa
        m0iAcazZChbfrAgs8GApwsexB0981JSxBEWBDGp3x4LTBtx/j+m+tjCmf9t+sgqqD3nzfql0SZ7hb
        dQ09jtCZVzVjFHuhg8Hybb0Llri0hmy/te+loSKrdIktxNxNy1SoM5x+OQwy7Lv2juKFPOfeA3egN
        WEjj+L2iqDdCKaYtcFddfmYuFTRA2uY5Nswu4fP/jSAF1fzdBbxymK7ND2J3rugGnZfcjBojzrJz6
        a9tjfQNcuT/7Fb6/xtk8Qim6zcsksNHMen5qY+rxV4YlKhbivPJJLou/2XFlAAKq3fhoAc3CA3nWe
        4XYLzO8sA1eHzVXFK86e6y+8FG4hLh9oSuspiKZUDlMiUJnYzNOEBhd5V8WrVV5qlbGC9VW75CFw2
        D3O4zOTUZJnXgB8VBbxwyN4HNxaqcOoIsQnr+ZT7SBXetDz+2fYjH+a2RJo9o5Blg94e3sBrOBIvL
        o3sxyolq6jutiX3rBwsGDudz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccc-001Yyq-9q; Tue, 05 Oct 2021 05:04:10 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v7 6/9] ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
Date:   Tue,  5 Oct 2021 07:03:40 +0200
Message-Id: <20211005050343.268514-7-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
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
 fs/ksmbd/smb2pdu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ed8324f9c2bd..e10ddc1fce09 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -94,12 +94,13 @@ struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn
 int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 {
 	struct smb2_hdr *req_hdr = work->request_buf;
+	unsigned int cmd = le16_to_cpu(req_hdr->Command);
 	int tree_id;
 
 	work->tcon = NULL;
-	if (work->conn->ops->get_cmd_val(work) == SMB2_TREE_CONNECT_HE ||
-	    work->conn->ops->get_cmd_val(work) ==  SMB2_CANCEL_HE ||
-	    work->conn->ops->get_cmd_val(work) ==  SMB2_LOGOFF_HE) {
+	if (cmd == SMB2_TREE_CONNECT_HE ||
+	    cmd ==  SMB2_CANCEL_HE ||
+	    cmd ==  SMB2_LOGOFF_HE) {
 		ksmbd_debug(SMB, "skip to check tree connect request\n");
 		return 0;
 	}
-- 
2.31.1

