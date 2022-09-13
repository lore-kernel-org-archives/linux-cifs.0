Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A596C6FA89
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 09:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiIMJkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 05:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiIMJkH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 05:40:07 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E252F007
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 02:40:04 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MRdgR2TlTz6PYlf
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 17:38:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgC3VW_uTyBjIj4hAw--.48825S8;
        Tue, 13 Sep 2022 17:40:02 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: [PATCH v5 4/5] cifs: Add neg dialects info to smb version values
Date:   Tue, 13 Sep 2022 18:40:58 +0800
Message-Id: <20220913104059.2545304-5-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220913104059.2545304-1-zhangxiaoxu5@huawei.com>
References: <20220913104059.2545304-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgC3VW_uTyBjIj4hAw--.48825S8
X-Coremail-Antispam: 1UD129KBjvJXoW3GFWkuw1ftr4rCrW8ArWxCrg_yoW3GFy3pF
        s09rWxGF4fXay7Zw13Ary8CFZ5Kw1fWw1xKrWqk34Fgryq9w4FqFyktryDX3sYy3yUtrWY
        qw4qva1j9w40vr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
        1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
        6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZE
        Xa7IUbX4S5UUUUU==
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The dialects information when negotiate with server is
depends on the smb version, add it to the version values
and make code simple.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Tom Talpey <tom@talpey.com>
---
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/smb2ops.c  | 35 ++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c  | 58 +++++++---------------------------------------
 3 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ae7f571a7dba..376421b63738 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -553,6 +553,8 @@ struct smb_version_values {
 	__u16		signing_enabled;
 	__u16		signing_required;
 	size_t		create_lease_size;
+	int		neg_dialect_cnt;
+	__le16		*neg_dialects;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 421be43af425..3df330806490 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5664,6 +5664,12 @@ struct smb_version_values smb21_values = {
 	.create_lease_size = sizeof(struct create_lease),
 };
 
+__le16 smb3any_neg_dialects[] = {
+	cpu_to_le16(SMB30_PROT_ID),
+	cpu_to_le16(SMB302_PROT_ID),
+	cpu_to_le16(SMB311_PROT_ID)
+};
+
 struct smb_version_values smb3any_values = {
 	.version_string = SMB3ANY_VERSION_STRING,
 	.protocol_id = SMB302_PROT_ID, /* doesn't matter, send protocol array */
@@ -5683,6 +5689,15 @@ struct smb_version_values smb3any_values = {
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease_v2),
+	.neg_dialect_cnt = ARRAY_SIZE(smb3any_neg_dialects),
+	.neg_dialects = smb3any_neg_dialects,
+};
+
+__le16 smbdefault_neg_dialects[] = {
+	cpu_to_le16(SMB21_PROT_ID),
+	cpu_to_le16(SMB30_PROT_ID),
+	cpu_to_le16(SMB302_PROT_ID),
+	cpu_to_le16(SMB311_PROT_ID)
 };
 
 struct smb_version_values smbdefault_values = {
@@ -5704,6 +5719,12 @@ struct smb_version_values smbdefault_values = {
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease_v2),
+	.neg_dialect_cnt = ARRAY_SIZE(smbdefault_neg_dialects),
+	.neg_dialects = smbdefault_neg_dialects,
+};
+
+__le16 smb30_neg_dialects[] = {
+	cpu_to_le16(SMB30_PROT_ID),
 };
 
 struct smb_version_values smb30_values = {
@@ -5725,6 +5746,12 @@ struct smb_version_values smb30_values = {
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease_v2),
+	.neg_dialect_cnt = ARRAY_SIZE(smb30_neg_dialects),
+	.neg_dialects = smb30_neg_dialects,
+};
+
+__le16 smb302_neg_dialects[] = {
+	cpu_to_le16(SMB302_PROT_ID),
 };
 
 struct smb_version_values smb302_values = {
@@ -5746,6 +5773,12 @@ struct smb_version_values smb302_values = {
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease_v2),
+	.neg_dialect_cnt = ARRAY_SIZE(smb302_neg_dialects),
+	.neg_dialects = smb302_neg_dialects,
+};
+
+__le16 smb311_neg_dialects[] = {
+	cpu_to_le16(SMB311_PROT_ID),
 };
 
 struct smb_version_values smb311_values = {
@@ -5767,4 +5800,6 @@ struct smb_version_values smb311_values = {
 	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease_v2),
+	.neg_dialect_cnt = ARRAY_SIZE(smb311_neg_dialects),
+	.neg_dialects = smb311_neg_dialects,
 };
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 223056097b54..482ed480fbc6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -897,27 +897,10 @@ SMB2_negotiate(const unsigned int xid,
 	memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 	memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 
-	if (strcmp(server->vals->version_string,
-		   SMB3ANY_VERSION_STRING) == 0) {
-		req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
-		req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
-		req->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
-		req->DialectCount = cpu_to_le16(3);
-		total_len += 6;
-	} else if (strcmp(server->vals->version_string,
-		   SMBDEFAULT_VERSION_STRING) == 0) {
-		req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
-		req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
-		req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
-		req->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
-		req->DialectCount = cpu_to_le16(4);
-		total_len += 8;
-	} else {
-		/* otherwise send specific dialect */
-		req->Dialects[0] = cpu_to_le16(server->vals->protocol_id);
-		req->DialectCount = cpu_to_le16(1);
-		total_len += 2;
-	}
+	req->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
+	memcpy(req->Dialects, server->vals->neg_dialects,
+		sizeof(__le16) * server->vals->neg_dialect_cnt);
+	total_len += sizeof(__le16) * server->vals->neg_dialect_cnt;
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (ses->sign)
@@ -1145,34 +1128,11 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	else
 		pneg_inbuf->SecurityMode = 0;
 
-
-	if (strcmp(server->vals->version_string,
-		SMB3ANY_VERSION_STRING) == 0) {
-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
-		pneg_inbuf->DialectCount = cpu_to_le16(3);
-		/* SMB 2.1 not included so subtract one dialect from len */
-		inbuflen = sizeof(*pneg_inbuf) -
-				(sizeof(pneg_inbuf->Dialects[0]));
-	} else if (strcmp(server->vals->version_string,
-		SMBDEFAULT_VERSION_STRING) == 0) {
-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
-		pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
-		pneg_inbuf->DialectCount = cpu_to_le16(4);
-		/* structure is big enough for 4 dialects */
-		inbuflen = sizeof(*pneg_inbuf);
-	} else {
-		/* otherwise specific dialect was requested */
-		pneg_inbuf->Dialects[0] =
-			cpu_to_le16(server->vals->protocol_id);
-		pneg_inbuf->DialectCount = cpu_to_le16(1);
-		/* structure is big enough for 4 dialects, sending only 1 */
-		inbuflen = sizeof(*pneg_inbuf) -
-				sizeof(pneg_inbuf->Dialects[0]) * 3;
-	}
+	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
+	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
+		server->vals->neg_dialect_cnt * sizeof(__le16));
+	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
+		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 		FSCTL_VALIDATE_NEGOTIATE_INFO,
-- 
2.31.1

