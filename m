Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81A5C38A02
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 07:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiJ2Hzz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Oct 2022 03:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJ2Hzn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Oct 2022 03:55:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAB86D9F3
        for <linux-cifs@vger.kernel.org>; Sat, 29 Oct 2022 00:55:37 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mzs8Z2Rz4zFqSY;
        Sat, 29 Oct 2022 15:52:46 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 15:55:35 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2 1/7] cifs: Use helper macro SMB2_CREATE_* instead of assignment one by one
Date:   Sat, 29 Oct 2022 17:00:05 +0800
Message-ID: <20221029090011.79367-2-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
References: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The create context macros has defined in fs/smbfs_common/smb2pdu.h,
use SMB2_CREATE_* instead of the assignment one by one to simplify
the codes, no functional changed.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2ops.c | 12 ++-----
 fs/cifs/smb2pdu.c | 89 ++++++++---------------------------------------
 2 files changed, 16 insertions(+), 85 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4f53fa012936..5d537a4c6881 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4106,11 +4106,7 @@ smb2_create_lease_buf(u8 *lease_key, u8 oplock)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct create_lease, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_REQUEST_LEASE is "RqLs" */
-	buf->Name[0] = 'R';
-	buf->Name[1] = 'q';
-	buf->Name[2] = 'L';
-	buf->Name[3] = 's';
+	memcpy(buf->Name, SMB2_CREATE_REQUEST_LEASE, 4);
 	return (char *)buf;
 }
 
@@ -4132,11 +4128,7 @@ smb3_create_lease_buf(u8 *lease_key, u8 oplock)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct create_lease_v2, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_REQUEST_LEASE is "RqLs" */
-	buf->Name[0] = 'R';
-	buf->Name[1] = 'q';
-	buf->Name[2] = 'L';
-	buf->Name[3] = 's';
+	memcpy(buf->Name, SMB2_CREATE_REQUEST_LEASE, 4);
 	return (char *)buf;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a5695748a89b..3a0c34e43a9d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -518,23 +518,7 @@ build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
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
 
 static void
@@ -800,23 +784,7 @@ create_posix_buf(umode_t mode)
 		cpu_to_le16(offsetof(struct create_posix, Name));
 	buf->ccontext.NameLength = cpu_to_le16(16);
 
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
 	buf->Mode = cpu_to_le32(mode);
 	cifs_dbg(FYI, "mode on posix create 0%o\n", mode);
 	return buf;
@@ -2034,11 +2002,8 @@ create_durable_buf(void)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct create_durable, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DHnQ" */
-	buf->Name[0] = 'D';
-	buf->Name[1] = 'H';
-	buf->Name[2] = 'n';
-	buf->Name[3] = 'Q';
+	memcpy(buf->Name, SMB2_CREATE_DURABLE_HANDLE_REQUEST, 4);
+
 	return buf;
 }
 
@@ -2059,11 +2024,8 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 	buf->ccontext.NameLength = cpu_to_le16(4);
 	buf->Data.Fid.PersistentFileId = fid->persistent_fid;
 	buf->Data.Fid.VolatileFileId = fid->volatile_fid;
-	/* SMB2_CREATE_DURABLE_HANDLE_RECONNECT is "DHnC" */
-	buf->Name[0] = 'D';
-	buf->Name[1] = 'H';
-	buf->Name[2] = 'n';
-	buf->Name[3] = 'C';
+	memcpy(buf->Name, SMB2_CREATE_DURABLE_HANDLE_RECONNECT, 4);
+
 	return buf;
 }
 
@@ -2124,11 +2086,6 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 	unsigned int next;
 	unsigned int remaining;
 	char *name;
-	static const char smb3_create_tag_posix[] = {
-		0x93, 0xAD, 0x25, 0x50, 0x9C,
-		0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
-		0xDE, 0x96, 0x8B, 0xCD, 0x7C
-	};
 
 	*oplock = 0;
 	data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
@@ -2150,7 +2107,7 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
 			parse_query_id_ctxt(cc, buf);
 		else if ((le16_to_cpu(cc->NameLength) == 16)) {
 			if (posix &&
-			    memcmp(name, smb3_create_tag_posix, 16) == 0)
+			    memcmp(name, SMB2_CREATE_TAG_POSIX, 16) == 0)
 				parse_posix_ctxt(cc, buf, posix);
 		}
 		/* else {
@@ -2222,12 +2179,8 @@ create_durable_v2_buf(struct cifs_open_parms *oparms)
 	buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
 	generate_random_uuid(buf->dcontext.CreateGuid);
 	memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
+	memcpy(buf->Name, SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2, 4);
 
-	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
-	buf->Name[0] = 'D';
-	buf->Name[1] = 'H';
-	buf->Name[2] = '2';
-	buf->Name[3] = 'Q';
 	return buf;
 }
 
@@ -2255,12 +2208,8 @@ create_reconnect_durable_v2_buf(struct cifs_fid *fid)
 	buf->dcontext.Fid.VolatileFileId = fid->volatile_fid;
 	buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
 	memcpy(buf->dcontext.CreateGuid, fid->create_guid, 16);
+	memcpy(buf->Name, SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2, 4);
 
-	/* SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2 is "DH2C" */
-	buf->Name[0] = 'D';
-	buf->Name[1] = 'H';
-	buf->Name[2] = '2';
-	buf->Name[3] = 'C';
 	return buf;
 }
 
@@ -2357,12 +2306,9 @@ create_twarp_buf(__u64 timewarp)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct crt_twarp_ctxt, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_TIMEWARP_TOKEN is "TWrp" */
-	buf->Name[0] = 'T';
-	buf->Name[1] = 'W';
-	buf->Name[2] = 'r';
-	buf->Name[3] = 'p';
+	memcpy(buf->Name, SMB2_CREATE_TIMEWARP_REQUEST, 4);
 	buf->Timestamp = cpu_to_le64(timewarp);
+
 	return buf;
 }
 
@@ -2450,11 +2396,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 	buf->ccontext.DataOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, sd));
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_SD_BUFFER_TOKEN is "SecD" */
-	buf->Name[0] = 'S';
-	buf->Name[1] = 'e';
-	buf->Name[2] = 'c';
-	buf->Name[3] = 'D';
+	memcpy(buf->Name, SMB2_CREATE_SD_BUFFER, 4);
 	buf->sd.Revision = 1;  /* Must be one see MS-DTYP 2.4.6 */
 
 	/*
@@ -2535,11 +2477,8 @@ create_query_id_buf(void)
 	buf->ccontext.NameOffset = cpu_to_le16(offsetof
 				(struct crt_query_id_ctxt, Name));
 	buf->ccontext.NameLength = cpu_to_le16(4);
-	/* SMB2_CREATE_QUERY_ON_DISK_ID is "QFid" */
-	buf->Name[0] = 'Q';
-	buf->Name[1] = 'F';
-	buf->Name[2] = 'i';
-	buf->Name[3] = 'd';
+	memcpy(buf->Name, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
+
 	return buf;
 }
 
-- 
2.31.1

