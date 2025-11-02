Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CDD26ED5F
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068771; cv=none; b=qlV7IChv7/EWRHoCkIQKBUJKopxl/gNHR3Mp6eIwIpAQ1EjjILpTUwpPPITAkQ3uCqtXi8kYS8l4CWszYenM5fD5vmcA5OmefIGqI/Ccun3QewpB2Ul6yjHqslfc5biPBOEMvL6NpkKfTPLYosJ4rydSBEQ6vo6RJfCjHMCPCDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068771; c=relaxed/simple;
	bh=0023sBdRPcprDQcpYHLMhuyqxAT6kqzzIa22A7j8YvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQccL9dW9LrzbheitGlz0pA5/y7xv99UQzWUuit3R2jnh4APRuKR+hxfScL8qM/+8aAkmi1cCkrbXwiaXkwRkB5tOBuWYOCJX3Y3DwAl5JEC2QuqcdcbtkdXvWH8uziEelZ3ZzxmZifRuvoLARtrDV+rwZjPJlcgykV+T1aPNA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m23CfcY+; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m23CfcY+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dPN/EJmc9aBkmsGhnAoWjGdU32TAhdREIo71qBTEZgQ=;
	b=m23CfcY+tRNoyOlQjarLXL38npGZ6k0AVZb2tJoDsMsssfanFIE2WU0i8j0QFXmnVZ0bvi
	JmmMyeDKCEqrmlauQYd+640v1VCDu0/Xob8833Uni4VrCddOeT0stu/snWomn+dHtIE+31
	JxUjzsGoChA3pltNrHZb7OInN3kEjg0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 11/14] smb: move FILE_SYSTEM_SIZE_INFO to common/fscc.h
Date: Sun,  2 Nov 2025 15:30:56 +0800
Message-ID: <20251102073059.3681026-12-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename the following places:

  - struct filesystem_info -> FILE_SYSTEM_SIZE_INFO
  - FILE_SYSTEM_INFO -> FILE_SYSTEM_SIZE_INFO
  - FreeAllocationUnits -> AvailableAllocationUnits: consistent with MS-FSCC 2.5.8

Then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/client/cifssmb.c    | 6 +++---
 fs/smb/common/fscc.h       | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 6 +++---
 fs/smb/server/smb_common.h | 7 -------
 5 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 39f431051860..a9a853b9011f 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1982,13 +1982,6 @@ struct aliasInfo92 {
 	int shareNameOffset;
 } __attribute__((packed));
 
-typedef struct {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
-
 typedef struct {
 	__le32 fsid;
 	__le32 SectorsPerAllocationUnit;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 0ef1d5024998..257a6beb4b7d 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4724,7 +4724,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 /* level 0x103 SMB_QUERY_FILE_SYSTEM_INFO */
 	TRANSACTION2_QFSI_REQ *pSMB = NULL;
 	TRANSACTION2_QFSI_RSP *pSMBr = NULL;
-	FILE_SYSTEM_INFO *response_data;
+	FILE_SYSTEM_SIZE_INFO *response_data;
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count;
@@ -4772,7 +4772,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
 			response_data =
-			    (FILE_SYSTEM_INFO
+			    (FILE_SYSTEM_SIZE_INFO
 			     *) (((char *) &pSMBr->hdr.Protocol) +
 				 data_offset);
 			FSData->f_bsize =
@@ -4789,7 +4789,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			FSData->f_blocks =
 			    le64_to_cpu(response_data->TotalAllocationUnits);
 			FSData->f_bfree = FSData->f_bavail =
-			    le64_to_cpu(response_data->FreeAllocationUnits);
+			    le64_to_cpu(response_data->AvailableAllocationUnits);
 			cifs_dbg(FYI, "Blocks: %lld  Free: %lld Block size %ld\n",
 				 (unsigned long long)FSData->f_blocks,
 				 (unsigned long long)FSData->f_bfree,
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 6fa7c65d304b..a0580a772a41 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -121,6 +121,14 @@ struct smb2_file_network_open_info {
 #define FILE_CASE_PRESERVED_NAMES	0x00000002
 #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 
+/* See MS-FSCC 2.5.8 */
+typedef struct {
+	__le64 TotalAllocationUnits;
+	__le64 AvailableAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __packed FILE_SYSTEM_SIZE_INFO;	/* size info, level 0x103 */
+
 /* See MS-FSCC 2.5.10 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 541732208c37..ae778ad99d30 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5546,11 +5546,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_SIZE_INFORMATION:
 	{
-		struct filesystem_info *info;
+		FILE_SYSTEM_SIZE_INFO *info;
 
-		info = (struct filesystem_info *)(rsp->Buffer);
+		info = (FILE_SYSTEM_SIZE_INFO *)(rsp->Buffer);
 		info->TotalAllocationUnits = cpu_to_le64(stfs.f_blocks);
-		info->FreeAllocationUnits = cpu_to_le64(stfs.f_bfree);
+		info->AvailableAllocationUnits = cpu_to_le64(stfs.f_bfree);
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
 		info->BytesPerSector = cpu_to_le32(stfs.f_bsize);
 		rsp->OutputBufferLength = cpu_to_le32(24);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 576c2ce591a5..e7298faa3c6a 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -112,13 +112,6 @@ struct filesystem_vol_info {
 	__le16 VolumeLabel[];
 } __packed;
 
-struct filesystem_info {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __packed;     /* size info, level 0x103 */
-
 #define EXTENDED_INFO_MAGIC 0x43667364	/* Cfsd */
 #define STRING_LENGTH 28
 
-- 
2.43.0

