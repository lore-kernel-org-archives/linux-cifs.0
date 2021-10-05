Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FC0C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE1761381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 05:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhJEF1V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJEF1U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 01:27:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B4AC061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 22:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=SFlPCGxJhT7S8Y9nmDzpW7DdvXgifH+PEARq7tlvL+g=; b=o+TJuVVDLAmDkQe6N8TruhjWBq
        z+0oXXD7/bD0lc8D0PIOjqVTEgoRed04ICNdulO8kAo9/SLoIzDHtrCU1ztRLJM/3t0FgMZBPaTg9
        TezrbHBBJysXp2DazDsTK20HsMxa/IeFhYYcWH0OoW3I2+CCKLg8ItXdbPba+BEmGh8LVWxXbr7bf
        zegsv8b3CUpoPN8sa3VRTXARFhw0DMYNAbF0ngrJoHgZSHrFvArmIVk3EIStk4XpcXCcWXdPf9VWR
        fidxVf3FYC0awe/7D+3qaIzd77aDJOTWVC6u/873ElAIw8K7t/7sPtONkLhxfE/8eXALYv68bExYQ
        1WRJWGqPXDrOlnLkGUQ3lghCIdXC3SEItZFp8LKOW4KTZ4UeS77ucXNFhrc4lv/scuz1G/CYBK1vZ
        vvQB6Dpn0NygVNIrll5BH5pdMx7clJmHPSVdJpDZ8rBl90yp7D4o0k+jthvbwfbkyOZ+E0FicO3CN
        r2I6ZQe+b75xsLMeLwFjXhbV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXccc-001Yyq-Sl; Tue, 05 Oct 2021 05:04:11 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v7 7/9] ksmdb: make smb2_get_ksmbd_tcon() callable with chained PDUs
Date:   Tue,  5 Oct 2021 07:03:41 +0200
Message-Id: <20211005050343.268514-8-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005050343.268514-1-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org>
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
index e10ddc1fce09..1755a524beb3 100644
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

