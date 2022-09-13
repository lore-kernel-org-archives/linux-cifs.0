Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923B6C6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 09:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiIMJkO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 05:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiIMJkH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 05:40:07 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EB6EE24
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 02:40:04 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MRdgR0TvszK63p
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 17:38:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgC3VW_uTyBjIj4hAw--.48825S9;
        Tue, 13 Sep 2022 17:40:03 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: [PATCH v5 5/5] cifs: Refactor dialects in validate_negotiate_info_req to variable array
Date:   Tue, 13 Sep 2022 18:40:59 +0800
Message-Id: <20220913104059.2545304-6-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220913104059.2545304-1-zhangxiaoxu5@huawei.com>
References: <20220913104059.2545304-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgC3VW_uTyBjIj4hAw--.48825S9
X-Coremail-Antispam: 1UD129KBjvJXoWxAF17tFy7XF43ZFy3GFWDCFg_yoW5AFWxpr
        9agFn7GF93Jr4xur18trn8Wa4Ygrn5Wr1jkr4DG34SqF9avr1Uu3ZYy3s8Gw1FkayDAr40
        qw4vva12yay5AaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPmb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
        xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
        1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY
        6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZE
        Xa7IUbX4S5UUUUU==
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
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

