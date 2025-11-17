Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86C1328603
	for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378996; cv=none; b=izic1Z9Jj6xwW9sjHFDCPTJyIwWXgdDXiEHeNpzGsfTX1cFOAEXA+PGYQFFAcZtv3AW+Om17h+XxAwq+JQcxhx2xt7YGfZ72wBm2U0biFmlYuzKSWWQaOXTPheVtevYn1RiV3u7TJ7bk9R7GnEmPYRGfGme3zpJgKztXC6TbAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378996; c=relaxed/simple;
	bh=fpYGUO6n4DY2BJDZ8fwnOaG9MWW3M/g6Yrk/WARPENc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai2W6NiWXD139Cl06xi0AbREVhyVq0w4ocqlPmW1+r8/VNNj6IARHpA1HD1WOTvmzD3sv+199HyzUJD5oAXKJ/K8RXRCUZ/NNIShaCQ+Ke9vJlzVnVaDiWYC9DmtwxHN4y5iZqay8iq/0aGhVNTBY6bydTP0g+EQSi83iPpFQ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=THsG7jQy; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="THsG7jQy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763378992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/gJaK5daEK13gn0nSNn1LV4o2mZh0FHjw2t/MUGV7g=;
	b=THsG7jQy7EVa3xdY0qoMuMf98l1l113ry1o7NjbrwJLQHYQP/eRauCuadqx1Ks/emW2NXH
	TOGUpgIEGeL6dr8RXNspmyU0YpsJVmqVJTeMW6V00MvzC93FN3pA0m8F7qtKXTsG/Oc2jg
	eYApIm+W6auU17rOEZl70Q2Vw6Xraqs=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v9 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
Date: Mon, 17 Nov 2025 19:28:38 +0800
Message-ID: <20251117112838.473051-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Modify the following places:

  - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
  - Remove MIN_FS_ATTR_INFO_SIZE definition
  - Introduce MAX_FS_NAME_LEN
  - max_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN
  - min_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
  - SMB2_QFS_attr(): memcpy(..., min_len)

Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.

I have tested the relevant code related to FILE_SYSTEM_ATTRIBUTE_INFO (Link[1]).

Link[1]: https://chenxiaosong.com/en/FILE_SYSTEM_ATTRIBUTE_INFO.html
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 10 ----------
 fs/smb/client/smb2pdu.c    |  6 +++---
 fs/smb/common/fscc.h       |  9 +++++++++
 fs/smb/server/smb2pdu.c    |  6 +++---
 fs/smb/server/smb_common.h |  7 -------
 5 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d84e10b1477f..49f35cb3cf2e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2068,16 +2068,6 @@ typedef struct {
 #define FILE_PORTABLE_DEVICE			0x00004000
 #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
 
-/* minimum includes first three fields, and empty FS Name */
-#define MIN_FS_ATTR_INFO_SIZE 12
-
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
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 032b4b037f07..ef2c6ac500f7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5981,8 +5981,8 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		max_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
 		min_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
 	} else if (level == FS_ATTRIBUTE_INFORMATION) {
-		max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
-		min_len = MIN_FS_ATTR_INFO_SIZE;
+		max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN;
+		min_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
 	} else if (level == FS_SECTOR_SIZE_INFORMATION) {
 		max_len = sizeof(struct smb3_fs_ss_info);
 		min_len = sizeof(struct smb3_fs_ss_info);
@@ -6028,7 +6028,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (level == FS_ATTRIBUTE_INFORMATION)
 		memcpy(&tcon->fsAttrInfo, offset
 			+ (char *)rsp, min_t(unsigned int,
-			rsp_len, max_len));
+			rsp_len, min_len));
 	else if (level == FS_DEVICE_INFORMATION)
 		memcpy(&tcon->fsDevInfo, offset
 			+ (char *)rsp, sizeof(FILE_SYSTEM_DEVICE_INFO));
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index a0580a772a41..35dbacdbb902 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -94,6 +94,15 @@ struct smb2_file_network_open_info {
 	__le32 Reserved;
 } __packed; /* level 34 Query also similar returned in close rsp and open rsp */
 
+/* See MS-FSCC 2.5.1 */
+#define MAX_FS_NAME_LEN		52
+typedef struct {
+	__le32 Attributes;
+	__le32 MaxPathNameComponentLength;
+	__le32 FileSystemNameLen;
+	__le16 FileSystemName[]; /* do not have to save this - get subset? */
+} __packed FILE_SYSTEM_ATTRIBUTE_INFO;
+
 /* List of FileSystemAttributes - see MS-FSCC 2.5.1 */
 #define FILE_SUPPORTS_SPARSE_VDL	0x10000000 /* faster nonsparse extend */
 #define FILE_SUPPORTS_BLOCK_REFCOUNTING	0x08000000 /* allow ioctl dup extents */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c71f156cc64a..1c8935f61150 100644
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
index 4dd573c5f0b2..6c1607b43eb3 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -90,13 +90,6 @@ struct smb_negotiate_rsp {
 	__le16 ByteCount;
 } __packed;
 
-struct filesystem_attribute_info {
-	__le32 Attributes;
-	__le32 MaxPathNameComponentLength;
-	__le32 FileSystemNameLen;
-	__le16 FileSystemName[]; /* do not have to save this - get subset? */
-} __packed;
-
 struct filesystem_vol_info {
 	__le64 VolumeCreationTime;
 	__le32 SerialNumber;
-- 
2.43.0

