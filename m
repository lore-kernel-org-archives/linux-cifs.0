Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7DBC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679D361B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhJBN06 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN05 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:26:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD29AC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=QpGs2DgXxGuTIpK2NWlT87Xsetv+cUnKN0xFbJPFDYU=; b=JYclVPCfweytXgpzL0PMnTYD8Q
        PkRq1jYWOjjgCCI3KW5p7h1jSwzl8T14rqvRDlvRlfFuAbYNPPiRkZQukF7X4OZ84tlplWE9HZf8W
        F0WiYl0zwmVlpmIskfyx950mVahJ37gGBp2caUO0rAmIX7M1+NY/U2WM6TcvDdukflGpbP2/ZPiiL
        CnTiO0lgwzY0fse4fMqIvK5VoHXJU7Yjtw4EpdODtbE2u7oq8I2oDT9qpq8OR2oGNSm+rXqg55aRg
        WeycTNAR4eFnuz8hHXutHt3Zl4TgbAB89L+7BS9plG6/i4wIc/8j6jOdqlnHVuaLK3+FIpGhOXhJa
        xHxmbxnK+LJfSOb5viCo4+egw+LOMvkD8+OzkBF7ZleV21b4sXhBaW0QNr2anG8H+fZNMSxT+NC5Z
        eIwPjb8FdT1M7U6m/e37zKTlahNP2W+FuWRW9tfRWmNxUABx0C1mejOgwtfDf0Z8kAfv+85XooFcO
        metNzMzGjCgz5xHCijut/TCS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoT-001DcY-B2; Sat, 02 Oct 2021 13:12:25 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 11/14] ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
Date:   Sat,  2 Oct 2021 15:12:09 +0200
Message-Id: <20211002131212.130629-12-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
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
 fs/ksmbd/ksmbd_work.h |  1 +
 fs/ksmbd/smb2pdu.c    | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

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
index 7d3344b5519c..8cbce9a9c2e0 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -97,7 +97,6 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 	unsigned int cmd = le16_to_cpu(req_hdr->Command);
 	int tree_id;
 
-	work->tcon = NULL;
 	if (cmd == SMB2_TREE_CONNECT_HE ||
 	    cmd ==  SMB2_CANCEL_HE ||
 	    cmd ==  SMB2_LOGOFF_HE) {
@@ -110,13 +109,26 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 		return -ENOENT;
 	}
 
+	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS) {
+		if (!work->tcon) {
+			pr_err("Missing tcon\n");
+			return -EINVAL;
+		}
+		return 1;
+	}
+
+	work->tcon = NULL;
+	work->compound_tid = 0;
+
 	tree_id = le32_to_cpu(req_hdr->Id.SyncId.TreeId);
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

