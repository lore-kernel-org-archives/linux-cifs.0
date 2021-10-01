Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECC6C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6739C61A55
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354358AbhJAM1Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhJAM1Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:27:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D42C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=XjLAfYtbAJ9nqNCj/XwXpc6ybkGmyX2pqfFAxoM+IBQ=; b=0SokKsw87EKCF6ePhg/6D/iec2
        Rr1Rpyw9Xra4p1OTTynSVIiULkJPuJT8jAJmml0Tdz+1WtHVXgYP3ZU2KJU95ybM4EXSQsMIaSPps
        HheXlDoxs8YqURIHwbUh3pP9Ye4VnFH6VPzIAoMflljRzLjt+zWEQKjVHDz1Q4gmjWUXgRZsMgacT
        GHxJZm+buTzWxsoyDEKPGE4QodaFKaWinsTpa/v9JiOqd3QH0zOZBRKsqlWw3jBtS7U2W1NwW+/cm
        qX/LvdJw+zSdJ+Lm8a7hyg9LRYGaQkxRd5uf8ko/FnIOBYkQqOqOQHJyHmZEWYpYVp7zBjAiTogAo
        Js66CjlEZMYLZKVCzRN9XQ9DXwA/RxBeLKggN0rFflnWR1acIDiPwqTa441mjOfi2iHvb8GKKOZjB
        /L1TI+zm2Dw5C3aCDXNSqHpQPI/fQ58a9O0YwDB0kSOH2/HZHesby8rmQnU5HxL0EDNp4QeLW9Uzq
        QwOAGC8qG6iRxjxeTWSYKMzU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIV-0013Z3-4e; Fri, 01 Oct 2021 12:05:51 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 18/20] ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
Date:   Fri,  1 Oct 2021 14:04:19 +0200
Message-Id: <20211001120421.327245-19-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also track the tcon id of compound requests.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/ksmbd_work.h | 1 +
 fs/ksmbd/smb2pdu.c    | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
index f7156bc50049..91363d508909 100644
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -46,6 +46,7 @@ struct ksmbd_work {
 	u64				compound_fid;
 	u64				compound_pfid;
 	u64				compound_sid;
+	u32				compound_tid;
 
 	const struct cred		*saved_cred;
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7d3344b5519c..5b1fead05c49 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -98,6 +98,8 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 	int tree_id;
 
 	work->tcon = NULL;
+	work->compound_tid = 0;
+
 	if (cmd == SMB2_TREE_CONNECT_HE ||
 	    cmd ==  SMB2_CANCEL_HE ||
 	    cmd ==  SMB2_LOGOFF_HE) {
@@ -110,13 +112,18 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 		return -ENOENT;
 	}
 
-	tree_id = le32_to_cpu(req_hdr->Id.SyncId.TreeId);
+	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
+		tree_id = work->compound_tid;
+	else
+		tree_id = le32_to_cpu(req_hdr->Id.SyncId.TreeId);
+
 	work->tcon = ksmbd_tree_conn_lookup(work->sess, tree_id);
 	if (!work->tcon) {
 		pr_err("Invalid tid %d\n", tree_id);
 		return -EINVAL;
 	}
 
+	work->compound_tid = tree_id;
 	return 1;
 }
 
-- 
2.31.1

