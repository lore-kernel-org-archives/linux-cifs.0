Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D685C6FA90
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 01:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiINBQ6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiINBQ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 21:16:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E9E61B28
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 18:16:56 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MS2Q13J67zlVp1;
        Wed, 14 Sep 2022 09:12:57 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 09:16:54 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <tom@talpey.com>, <linkinjeon@kernel.org>,
        <hyc.lee@gmail.com>
Subject: [PATCH v6 5/5] cifs: Refactor dialects in validate_negotiate_info_req to variable array
Date:   Wed, 14 Sep 2022 10:17:41 +0800
Message-ID: <20220914021741.2672982-6-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The length of the message FSCTL_VALIDATE_NEGOTIATE_INFO is
depends on the count of the dialects, the dialects count is
depending on the smb version, so the dialects should be
variable array.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2pdu.c         | 7 ++++---
 fs/ksmbd/smb2pdu.c        | 5 ++---
 fs/smbfs_common/smb2pdu.h | 3 +--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 482ed480fbc6..70a3fce85e7c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1107,7 +1107,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
 		cifs_tcon_dbg(VFS, "Unexpected null user (anonymous) auth flag sent by server\n");
 
-	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_NOFS);
+	inbuflen = sizeof(*pneg_inbuf) +
+			sizeof(__le16) * server->vals->neg_dialect_cnt;
+
+	pneg_inbuf = kmalloc(inbuflen, GFP_NOFS);
 	if (!pneg_inbuf)
 		return -ENOMEM;
 
@@ -1131,8 +1134,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
 	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
 		server->vals->neg_dialect_cnt * sizeof(__le16));
-	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
-		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 		FSCTL_VALIDATE_NEGOTIATE_INFO,
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 09ae601e64f9..aa86f31aa2cd 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7392,7 +7392,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 	int ret = 0;
 	int dialect;
 
-	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
+	if (in_buf_len < sizeof(*neg_req) +
 			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
 		return -EINVAL;
 
@@ -7640,8 +7640,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
-					  Dialects)) {
+		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
index 2cab413fffee..4780c72e9b3a 100644
--- a/fs/smbfs_common/smb2pdu.h
+++ b/fs/smbfs_common/smb2pdu.h
@@ -1388,13 +1388,12 @@ struct reparse_symlink_data_buffer {
 } __packed;
 
 /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
-
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
 	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
 	__le16 SecurityMode;
 	__le16 DialectCount;
-	__le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
+	__le16 Dialects[];
 } __packed;
 
 struct validate_negotiate_info_rsp {
-- 
2.31.1

