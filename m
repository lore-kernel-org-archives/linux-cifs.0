Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8F51E633C
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040849; cv=none; b=m2ht9w3ytRG2RIs12egstR5fz+NLYocMxs0/Mm4DAhyQCsBOmzrEi+CVoV2JMksa5OIBoqa3n1rhJOupWYJlZYHVTOY7xkeKBNN5GoMRPRdX2yOT5a9OlIjeNx6DXzQYqYEhigunIHWRipzVshhxfI3HpO/SOrNa3nzoen+W8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040849; c=relaxed/simple;
	bh=PeI+2W+NiXg4sp9glo+EpxJAuM3Lv4gWQ8XpVqVxJ+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjSQpMvV0scQeKVzKrGJ8GtnRBHlQ+mwAA/KEMJwdqfbtyFxKZcfJETSRl3WeFo7ihA5fP7L9TdLnTGUXa171Grf6y6OfzcHFBHiz9jbqS28tsp+EhpaBP1VvNlGA/jNKLpGMe026XMv86q1G2u9GzFs4sM6a3BMz5mNtt8dtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tS857Aqm; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tS857Aqm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763040844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZjKiVFY8WXWqOPVZql9XMH15jXpX6knrtwzayvzn934=;
	b=tS857AqmRPXqKNpVzjyR3NG2E+rAv2XLbpQzwcU8hYZqIOGH+kiDHyLnvZQShqNpVp8QBq
	3MmtW1mQ6YWD3JxC2/rCVdWtJyTH1elwpLDvSN7D9kjXuP2RpzouBHRKGRGUWt4Nzez4XS
	eL/Fw8UqlATOfcttxeVlaYcWf/eqQsc=
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
Subject: [PATCH v7 2/2] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
Date: Thu, 13 Nov 2025 21:32:52 +0800
Message-ID: <20251113133252.145867-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev>
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
index 30c391424022..4ccc8d1e130d 100644
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
index e7edb52e6e40..383fecacfd06 100644
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

