Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4412DF71D
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549347; cv=none; b=O4rokYe6KthjVEG6b0Ed0aCO386bMRFJSW3qDBclSH8+dQ6sBCR/NSwb2bKfiQaaMDk1/Q/ib+RwoqQ9Sk8MfXm1NYe85wKrHKCJrJZU381pj/SQNXkZOn59l2r4cKf9YRckd/jOs9ygDGVmkh8ovq+MDeUJrTmVd6VhJU8szHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549347; c=relaxed/simple;
	bh=sSgvySHYn73WVcHABWrP++pKx0AaJJc0ZR1U3i59mJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfvmSHDXIgOxvg+1HYQXV1O3WK/m+iqZgwBq+ddOku3PLh3lUso3WE3lxuPfY86FfclpkCO4HrHjh8YSDMGa2lkqcVPBZgGGJVZCDAICB0DOBEwO72mbCLf4BLMBH2AR2F0SFCbioNolw3wxJlQXZGUcoDByrPHe4xTsTUlo7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lfes5LtE; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lfes5LtE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fln7RtN3sttj6OJ+hiE2faOu7AwAyLYF8lSUcaF6FGY=;
	b=Lfes5LtEhoEDy2j3VpWTjL1tv6AKX6tDvsjaFgFMomwOBvBFNS5M33XROBgzUULS+9bJu6
	SJFmZshMv1YZiHC8PEGpfvuGbve4SWb0B7p/sG2V0WQOlavUlcFJMpR0Njl90h1IFxaV3O
	vAaond/4+wt6aHkmyFDmbFgZsfu9e+4=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 10/24] smb: move FILE_SYSTEM_INFO to common/smb1pdu.h
Date: Mon, 27 Oct 2025 15:13:02 +0800
Message-ID: <20251027071316.3468472-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_info" to "FILE_SYSTEM_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/common/smb1pdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 731cec5ab8a9..d4addb0d7942 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1828,13 +1828,6 @@ struct aliasInfo92 {
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
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index aa15825706d3..02b8cda74f47 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -319,6 +319,14 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __packed SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.4 */
+typedef struct {
+	__le64 TotalAllocationUnits;
+	__le64 FreeAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __packed FILE_SYSTEM_INFO;	/* size info, level 0x103 */
+
 /* See MS-CIFS 2.2.8.2.5 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index eea7d4c89063..d063d2827868 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5546,9 +5546,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_SIZE_INFORMATION:
 	{
-		struct filesystem_info *info;
+		FILE_SYSTEM_INFO *info;
 
-		info = (struct filesystem_info *)(rsp->Buffer);
+		info = (FILE_SYSTEM_INFO *)(rsp->Buffer);
 		info->TotalAllocationUnits = cpu_to_le64(stfs.f_blocks);
 		info->FreeAllocationUnits = cpu_to_le64(stfs.f_bfree);
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 3f90f0999549..d8aeab6115f5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -65,13 +65,6 @@ struct filesystem_vol_info {
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

