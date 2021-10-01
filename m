Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DC7C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D500B61A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhJAM1k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354361AbhJAM1j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7743C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=ImcoTzW6T/0ToK3dGY1uZiG8CTNii1vrIM1lJjydl40=; b=BR6XY3RjpZqBLeM6z4E2fBlx1A
        PoTZVnb34oOR86M1V5YKft6ba72m61BDVA0rbrVSNTQt9fKpenyrBh1RRa3htPax63We3OFHUF4qK
        0S4Uc8Q/E7Of5SeTWMNQnYntFVNhQ2mNwjy4ZJrP7qsSXFaX8epCrYhG8xa13sPP/qUdE2MVNdcQt
        1dqRG49z5WFy7hpSX/EUEXPhSPNW8JJhrw2kxmUqdJhi9T5SeuUsqQvrOyXvnJFRuJP4ZaMwUbFQU
        whCMNnxb49I95KJMLGSVx5IwY/rTUpEC42vogKB73pT2z60TQ8XGYuMBMre6vKJhkro+BQVtaa3Ga
        t7jE9ZNXyspp702lrACI8aslRLg+vSinDfD99GVK/xRy1McXgDIChM+XQzgzbPYEoRnBj7RP8MJ3v
        ofpo/MxXGYFCINxkzt8WCQ7eA/OllkJMMG/7MmlaXUJTxexf0n4P687hQEK3aZ2hJFcpeveqhqC0Y
        i8XRv0+aOEOa2v+1ajz5Wocf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIU-0013Z3-Ji; Fri, 01 Oct 2021 12:05:50 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 17/20] ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
Date:   Fri,  1 Oct 2021 14:04:18 +0200
Message-Id: <20211001120421.327245-18-slow@samba.org>
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
 fs/ksmbd/smb2pdu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b06361313889..7d3344b5519c 100644
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

