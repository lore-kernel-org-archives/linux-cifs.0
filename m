Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358052D5A07
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 09:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763026043; cv=none; b=FFeQUR8cgpKF8rsvTQfmRepYQjDjCno12NhicATS5jXQ9TQKqrbHygMGvAFxzIFnoZObPrywuFCquDCfUIYYAUtkAZpk9LxqQgfXmWN2tZJVVC9MssynMoVSywVi27PbLEAaYDVL1aXwwBhF9A2SG554/hAnMX+e6630WccySRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763026043; c=relaxed/simple;
	bh=LccbU0TtT2qQgElmlYyPgFwJj4du5x/XKUSTAEaVarc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0j6gheRdfzvUYlwLo4IQ2REYkeI8Y028sWrhRvRWF1/rh1H9jB+KDZl4c7wusmb11u5O1mDlUsb7nA/JZ0BRQ6PaZkpR9Q0DZ5ebBhcAhgOJ/mh30AcKa8KVtDSjnUGbsL85gW23pss+fNK2F1qh3papWk2X+LjET8ngOs2qK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n22o8R07; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n22o8R07"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763026037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7vvCsHI5nElxztzx6XgOfvmGPZZkj/fhVJA4sYQEuQ=;
	b=n22o8R07jAQzv0WHCh2exlY32I1DRJZXumtBD25xeDfD0QOrFKeW9BnaTlSgEZfMjH2ByU
	otvSu9qfCKU9jt0b2XvWmTSYw8IUK5H4XK+AuXbQtV7VEFMQIGGm471++HYJqHWBjVC++Y
	xnQKSrOo1vGxsJRF+T4ITVat+XFUrU4=
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
Subject: [PATCH v6 2/2] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
Date: Thu, 13 Nov 2025 17:26:02 +0800
Message-ID: <20251113092602.24733-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113092602.24733-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251113092602.24733-1-chenxiaosong.chenxiaosong@linux.dev>
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
  - client: remove MIN_FS_ATTR_INFO_SIZE definition,
            MIN_FS_ATTR_INFO_SIZE -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)

Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 10 ----------
 fs/smb/client/smb2pdu.c    |  2 +-
 fs/smb/common/fscc.h       |  8 ++++++++
 fs/smb/server/smb2pdu.c    |  6 +++---
 fs/smb/server/smb_common.h |  7 -------
 5 files changed, 12 insertions(+), 21 deletions(-)

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
index 5cf724ccdc75..7ee17f77db95 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5982,7 +5982,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		min_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
 	} else if (level == FS_ATTRIBUTE_INFORMATION) {
 		max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
-		min_len = MIN_FS_ATTR_INFO_SIZE;
+		min_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
 	} else if (level == FS_SECTOR_SIZE_INFORMATION) {
 		max_len = sizeof(struct smb3_fs_ss_info);
 		min_len = sizeof(struct smb3_fs_ss_info);
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index a0580a772a41..7eb3f715466d 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -94,6 +94,14 @@ struct smb2_file_network_open_info {
 	__le32 Reserved;
 } __packed; /* level 34 Query also similar returned in close rsp and open rsp */
 
+/* See FS-FSCC 2.5.1 */
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
index 780cdb7dc6cf..58327896e7d1 100644
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

