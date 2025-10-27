Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684082DF143
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549343; cv=none; b=j7QPZtL4wzzU2i1IYLoeOdIEo0/nH6RD2BMPLimBNa9KRLFAgGE4LGu1+8RTN8aE/sneqxCIslQaxt3EHdlluIrv2KiipflclDgq2h3NGzEyAikONmOgIqzQoN5giB51Cfd+xnT+px4V0NFYQqwuTFZQ1mAVmcOb5BSmVfowjGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549343; c=relaxed/simple;
	bh=lWJpJwPCA3LmMj1b9IFDHULaZ/lTlKKjmd4GJ2LcM6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ju25uZZ4PmSAgwnu8zGLjoxBhXOTIZFDR2xLXMFh1H/lXsRLnqBYYWyyvv9zOZnnNBpgqIJQNDVpKHENqEvirZZruE+8T1mPE9pZ5AuJ81il2o95yM1FRg2bKUbffJUDZ3VJAMIsjHRT8fYXUKdgSC47VyRIphlDLihdCcbQ684=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hkl5hsxv; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hkl5hsxv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XTyWqvcZownGMfluUY7RFs/jCUMEoJJYYWBhvMAtxM=;
	b=hkl5hsxvOSIGcOUQZPFCw9MPw6V6NlltYMB2eCGE4MuXyrurtseJHWfDsAFQuqlFWvPqRh
	CcI3bdBC88uVvaCdDrk/H8+HnuaVYoCWGVxC3bh9EIAKXBKeAF+XmpkDk4ww4k2hRRR4Lg
	k9fWxA6/QeA9Rhu6jw0DwupSI1EapxI=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 08/24] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/smb1pdu.h
Date: Mon, 27 Oct 2025 15:13:00 +0800
Message-ID: <20251027071316.3468472-9-chenxiaosong.chenxiaosong@linux.dev>
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

Rename "struct filesystem_attribute_info" to "FILE_SYSTEM_ATTRIBUTE_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/common/smb1pdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 6 +++---
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d40683c7fdc3..7c781b17f73b 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1946,13 +1946,6 @@ typedef struct {
 /* minimum includes first three fields, and empty FS Name */
 #define MIN_FS_ATTR_INFO_SIZE 12
 
-typedef struct {
-	__le32 Attributes;
-	__le32 MaxPathNameComponentLength;
-	__le32 FileSystemNameLen;
-	char FileSystemName[52]; /* do not have to save this - get subset? */
-} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
-
 /******************************************************************************/
 /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
 /******************************************************************************/
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index 6e6ea48fd376..37d1eb0b1fbe 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -346,4 +346,12 @@ typedef struct server_negotiate_rsp {
 #define FILE_CASE_PRESERVED_NAMES	0x00000002
 #define FILE_CASE_SENSITIVE_SEARCH	0x00000001
 
+/* See FS-FSCC 2.5.1 */
+typedef struct {
+	__le32 Attributes;
+	__le32 MaxPathNameComponentLength;
+	__le32 FileSystemNameLen;
+	__le16 FileSystemName[]; /* do not have to save this - get subset? */
+} __packed FILE_SYSTEM_ATTRIBUTE_INFO;
+
 #endif /* _COMMON_SMB1_PDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2c435836e005..d0a077730387 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5492,10 +5492,10 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_ATTRIBUTE_INFORMATION:
 	{
-		struct filesystem_attribute_info *info;
+		FILE_SYSTEM_ATTRIBUTE_INFO *info;
 		size_t sz;
 
-		info = (struct filesystem_attribute_info *)rsp->Buffer;
+		info = (FILE_SYSTEM_ATTRIBUTE_INFO *)rsp->Buffer;
 		info->Attributes = cpu_to_le32(FILE_SUPPORTS_OBJECT_IDS |
 					       FILE_PERSISTENT_ACLS |
 					       FILE_UNICODE_ON_DISK |
@@ -5514,7 +5514,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 					"NTFS", PATH_MAX, conn->local_nls, 0);
 		len = len * 2;
 		info->FileSystemNameLen = cpu_to_le32(len);
-		sz = sizeof(struct filesystem_attribute_info) + len;
+		sz = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
 		break;
 	}
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 546125e1886c..09861be254c6 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -57,13 +57,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-struct filesystem_attribute_info {
-	__le32 Attributes;
-	__le32 MaxPathNameComponentLength;
-	__le32 FileSystemNameLen;
-	__le16 FileSystemName[]; /* do not have to save this - get subset? */
-} __packed;
-
 struct filesystem_device_info {
 	__le32 DeviceType;
 	__le32 DeviceCharacteristics;
-- 
2.43.0

