Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95621C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7601161AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhJBN1T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:19 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C74C0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=ImcoTzW6T/0ToK3dGY1uZiG8CTNii1vrIM1lJjydl40=; b=VwU4oakccOoZE7LGDznSAaewEG
        kmdThQHJ9jnWEW95LOrjmlDIE5ni7VyqGR6knMsuAjIejvVLwDi+tzOvPXo3hOQLcfCz029lgbkwD
        Az/wW05g0zZQBfRHP7Z85L+TQphoHeuONACir1R1GAYIc19rfsIgYYodDyuM0o7D5veNydDq+d4xU
        +uiEywVmf32gnxZpXzAvC4Ct6+VhC5WuqdHLxIVgvOqf8vvlbw1ByKKtJWYHnk2RASqUgWos2rqsm
        7RGLfpuFaI533df2QyMIOdx7wfov6mlUs7+2djHhxokbZKxFtfLeShZdgUoJaecbG4yVT3RINSX6x
        zBeCl0inYAIKjR4NVdMKCSCHk4X87vA9HLcu3H1WxLayQRaas2mDJYZ9Isgkr9UZ1D44h2Re/Ejvu
        eEy8svQY9N69NezV5z4MAoo9+Lj/ak7oE5Pr1RaVZWOv+2jYaOy5ADG6fEmvFK8CCyztpmcAjt225
        l19uIsfjFjy4eukqxaDMJ1ZG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoS-001DcY-Lq; Sat, 02 Oct 2021 13:12:24 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 10/14] ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
Date:   Sat,  2 Oct 2021 15:12:08 +0200
Message-Id: <20211002131212.130629-11-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
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

