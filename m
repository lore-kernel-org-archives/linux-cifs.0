Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE8FC6FA8E
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 01:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiINBQ6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiINBQ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 21:16:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAF761B33
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 18:16:55 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MS2RT2YkpznV7H;
        Wed, 14 Sep 2022 09:14:13 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 09:16:53 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <tom@talpey.com>, <linkinjeon@kernel.org>,
        <hyc.lee@gmail.com>
Subject: [PATCH v6 4/5] cifs: Add neg dialects info to smb version values
Date:   Wed, 14 Sep 2022 10:17:40 +0800
Message-ID: <20220914021741.2672982-5-zhangxiaoxu5@huawei.com>
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
index 421be43af425..e1407124c761 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5664,6 +5664,12 @@ struct smb_version_values smb21_values = {
 	.create_lease_size = sizeof(struct create_lease),
 };
 
+static __le16 smb3any_neg_dialects[] = {
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
+static __le16 smbdefault_neg_dialects[] = {
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
+static __le16 smb30_neg_dialects[] = {
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
+static __le16 smb302_neg_dialects[] = {
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
+static __le16 smb311_neg_dialects[] = {
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

