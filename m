Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C2BECAAD6
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 09:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbiHZJk3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 05:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344100AbiHZJk0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 05:40:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B0C10FF1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 02:40:23 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MDZV82fKnzkWhD;
        Fri, 26 Aug 2022 17:36:48 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 17:40:20 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>
Subject: [PATCH -next 2/2] ksmbd: Use helper macro SMB2_CREATE_TAG_POSIX
Date:   Fri, 26 Aug 2022 18:39:27 +0800
Message-ID: <20220826103927.2802716-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220826103927.2802716-1-zhangxiaoxu5@huawei.com>
References: <20220826103927.2802716-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Posix tag already defined in fs/smbfs_common/smb2pdu.h, use
the helper macro SMB2_CREATE_TAG_POSIX here.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/ksmbd/oplock.c  | 18 +-----------------
 fs/ksmbd/smb2pdu.c | 18 +-----------------
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 9046cff4374b..1ca867c2a5fe 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1618,23 +1618,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 			(struct create_posix_rsp, Name));
 	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	buf->Name[0] = 0x93;
-	buf->Name[1] = 0xAD;
-	buf->Name[2] = 0x25;
-	buf->Name[3] = 0x50;
-	buf->Name[4] = 0x9C;
-	buf->Name[5] = 0xB4;
-	buf->Name[6] = 0x11;
-	buf->Name[7] = 0xE7;
-	buf->Name[8] = 0xB4;
-	buf->Name[9] = 0x23;
-	buf->Name[10] = 0x83;
-	buf->Name[11] = 0xDE;
-	buf->Name[12] = 0x96;
-	buf->Name[13] = 0x8B;
-	buf->Name[14] = 0xCD;
-	buf->Name[15] = 0x7C;
+	memcpy(buf->Name, SMB2_CREATE_TAG_POSIX, 16);
 
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c49f65146ab3..2686be12199b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -784,23 +784,7 @@ static void build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 {
 	pneg_ctxt->ContextType = SMB2_POSIX_EXTENSIONS_AVAILABLE;
 	pneg_ctxt->DataLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
-	/* SMB2_CREATE_TAG_POSIX is "0x93AD25509CB411E7B42383DE968BCD7C" */
-	pneg_ctxt->Name[0] = 0x93;
-	pneg_ctxt->Name[1] = 0xAD;
-	pneg_ctxt->Name[2] = 0x25;
-	pneg_ctxt->Name[3] = 0x50;
-	pneg_ctxt->Name[4] = 0x9C;
-	pneg_ctxt->Name[5] = 0xB4;
-	pneg_ctxt->Name[6] = 0x11;
-	pneg_ctxt->Name[7] = 0xE7;
-	pneg_ctxt->Name[8] = 0xB4;
-	pneg_ctxt->Name[9] = 0x23;
-	pneg_ctxt->Name[10] = 0x83;
-	pneg_ctxt->Name[11] = 0xDE;
-	pneg_ctxt->Name[12] = 0x96;
-	pneg_ctxt->Name[13] = 0x8B;
-	pneg_ctxt->Name[14] = 0xCD;
-	pneg_ctxt->Name[15] = 0x7C;
+	memcpy(pneg_ctxt->Name, SMB2_CREATE_TAG_POSIX, 16);
 }
 
 static void assemble_neg_contexts(struct ksmbd_conn *conn,
-- 
2.31.1

