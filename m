Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64652868A9
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463636; cv=none; b=laMO6bw0AvGCx2tmd3+RKlD+pW4DLTK4V+2Q8Uxfh8oCqfxjIIQKNZiD3SxyRMTpBOLgDDlyoZ1vv4TmcU3vOm85fUj0kKVHcQiqbp/G6/4aU63DTQhM/+SW2iBjqDDPPZEwY4tr464Bsd0t3Y3hrE+D0NNKfG+mKQJInbz1T0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463636; c=relaxed/simple;
	bh=D4KtcTcGvfcaQEsIUlatpzVdBl8nJSICK8CtCXKf1N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwrHgOHqAUgyCKPh/G/t8qkzDWy7Nwaents/hqirZnIrRGyKQo9QCC4stakOfYQgFufNQMdXh51KVOdJ5SN1Ty8snW3+Be4PqGG71Qq25Cr8QuI+0/7C1+3ACG9drMgNa0BJezw3uoY7WIp4pWfMeYkPAnBiE/FcudAnuMGXxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CYcqt/Vi; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CYcqt/Vi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TlYMyWseHM3TTHMpPUh5QYf3i4IaJix7XO2WCkfS81I=;
	b=CYcqt/ViLd+Tcmoe84k9+GM4jEpkxkuNIcyaP5H3mEfFes93wpCbPjfgqVW0C6e4WwzRmc
	ayokyXwnHxwKVxQ8QRDgUwIvl1irOUOYvAX18fCvr67o+l+RbR8hdXc5bUrX04o8ds3r4z
	VEyyVObTSAHfO6tPDeD9BBISjhYaalk=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 4/7] smb: move smb3_fs_vol_info into common/fscc.h
Date: Thu, 11 Dec 2025 22:32:25 +0800
Message-ID: <20251211143228.172470-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

The structure definition on the server side is specified in MS-CIFS
2.2.8.2.3, but we should instead refer to MS-FSCC 2.5.9, just as the
client side does.

Modify the following places:

  - filesystem_vol_info -> smb3_fs_vol_info
  - SerialNumber -> VolumeSerialNumber
  - VolumeLabelSize -> VolumeLabelLength

Then move it into common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/common/fscc.h       | 11 +++++++++++
 fs/smb/common/smb2pdu.h    | 11 -----------
 fs/smb/server/smb2pdu.c    | 10 +++++-----
 fs/smb/server/smb_common.h |  8 --------
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 0123f34db1e8..5949facd005a 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -138,6 +138,17 @@ typedef struct {
 	__le32 BytesPerSector;
 } __packed FILE_SYSTEM_SIZE_INFO;	/* size info, level 0x103 */
 
+/* volume info struct - see MS-FSCC 2.5.9 */
+#define MAX_VOL_LABEL_LEN	32
+struct smb3_fs_vol_info {
+	__le64	VolumeCreationTime;
+	__u32	VolumeSerialNumber;
+	__le32	VolumeLabelLength; /* includes trailing null */
+	__u8	SupportsObjects; /* True if eg like NTFS, supports objects */
+	__u8	Reserved;
+	__u8	VolumeLabel[]; /* variable len */
+} __packed;
+
 /* See MS-FSCC 2.5.10 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 28460c3d4979..5dfdf9ec11c7 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1938,17 +1938,6 @@ struct smb2_fs_control_info {
 	__le32 Padding;
 } __packed;
 
-/* volume info struct - see MS-FSCC 2.5.9 */
-#define MAX_VOL_LABEL_LEN	32
-struct smb3_fs_vol_info {
-	__le64	VolumeCreationTime;
-	__u32	VolumeSerialNumber;
-	__le32	VolumeLabelLength; /* includes trailing null */
-	__u8	SupportsObjects; /* True if eg like NTFS, supports objects */
-	__u8	Reserved;
-	__u8	VolumeLabel[]; /* variable len */
-} __packed;
-
 /* See MS-SMB2 2.2.23 through 2.2.25 */
 struct smb2_oplock_break {
 	struct smb2_hdr hdr;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f3184b217575..f58b212481e0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5507,11 +5507,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_VOLUME_INFORMATION:
 	{
-		struct filesystem_vol_info *info;
+		struct smb3_fs_vol_info *info;
 		size_t sz;
 		unsigned int serial_crc = 0;
 
-		info = (struct filesystem_vol_info *)(rsp->Buffer);
+		info = (struct smb3_fs_vol_info *)(rsp->Buffer);
 		info->VolumeCreationTime = 0;
 		serial_crc = crc32_le(serial_crc, share->name,
 				      strlen(share->name));
@@ -5520,14 +5520,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		serial_crc = crc32_le(serial_crc, ksmbd_netbios_name(),
 				      strlen(ksmbd_netbios_name()));
 		/* Taking dummy value of serial number*/
-		info->SerialNumber = cpu_to_le32(serial_crc);
+		info->VolumeSerialNumber = cpu_to_le32(serial_crc);
 		len = smbConvertToUTF16((__le16 *)info->VolumeLabel,
 					share->name, PATH_MAX,
 					conn->local_nls, 0);
 		len = len * 2;
-		info->VolumeLabelSize = cpu_to_le32(len);
+		info->VolumeLabelLength = cpu_to_le32(len);
 		info->Reserved = 0;
-		sz = sizeof(struct filesystem_vol_info) + len;
+		sz = sizeof(struct smb3_fs_vol_info) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
 		break;
 	}
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 89adfd190370..f47ce4a6719c 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -91,14 +91,6 @@ struct smb_negotiate_rsp {
 	__le16 ByteCount;
 } __packed;
 
-struct filesystem_vol_info {
-	__le64 VolumeCreationTime;
-	__le32 SerialNumber;
-	__le32 VolumeLabelSize;
-	__le16 Reserved;
-	__le16 VolumeLabel[];
-} __packed;
-
 #define EXTENDED_INFO_MAGIC 0x43667364	/* Cfsd */
 #define STRING_LENGTH 28
 
-- 
2.43.0

