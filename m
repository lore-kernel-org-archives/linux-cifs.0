Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AFE2D3EE4
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427048; cv=none; b=N4Ifryu0djl2zM6zHWN8Rl4lQhijajJc0XiUiZkkEBh0Q0HkJaeJpjttyRONUiZHtHJ6XS+UARQjO7iWCEu21Awg1zsEYVwowt6EoksWFGq1qO+acLDx3Wijh8fFi/sk0HHnGc60RXFpL5JjfRS/HUyxS2BVn8LAVuFEecocHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427048; c=relaxed/simple;
	bh=KmGhgnmR0m6tPFO5dxwalQMc+FUg7axJAvjjwY79eSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtRRnxq/5ekYp/w9dsVcqHrLYI49xHn8VaI5//YgNahJV0AgMAtgzU7ewuSt4Rl5bY/DeBb+d/ra2wCXQ247ZKPXGhRx8cekkY9jCbRwP5aRy/KOMq1LjSDg04KxWJne+ZRBdQA/lEWQWSbAmFiX4W88bT5ft9doEZMZUqzQVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wntiSRKX; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wntiSRKX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EbD7TSp8y0cMbWADGY7E2D2n3hQ8T6cdIogC5MJNMBo=;
	b=wntiSRKXgbxyDO5Ugf+eaad5r+yGPO5Zq3z7ytz6m8ea0EBdfgjfvIjC4IXchjzv1hZCO4
	TOVAvoK2pPt9VhIukyU8zNT539kDlyI422BypUrrZQB9nf73jzrNev8BihN4YQ6gsd1ic4
	Nr9B4I+Fk5STAb1FFBQq7qz7aPytE/w=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 17/22] smb: move FILE_SYSTEM_INFO to common/cifspdu.h
Date: Tue, 14 Oct 2025 15:28:51 +0800
Message-ID: <20251014072856.3004683-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
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
 fs/smb/common/cifspdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 17255d7a4615..889be409146c 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1819,13 +1819,6 @@ struct aliasInfo92 {
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
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 055c6577b4e9..548d621ec233 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -321,6 +321,14 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __attribute__((packed)) SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.4 */
+typedef struct {
+	__le64 TotalAllocationUnits;
+	__le64 FreeAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
+
 /* See MS-CIFS 2.2.8.2.5 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 41167e7cca77..2ad46a11e7ef 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5539,9 +5539,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
index 86d18a8badff..d6351b0ee62a 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -64,13 +64,6 @@ struct filesystem_vol_info {
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

