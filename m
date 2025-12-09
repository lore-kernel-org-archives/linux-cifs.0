Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DAE26E165;
	Tue,  9 Dec 2025 01:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242728; cv=none; b=taLr2qCrjkZeT5Lv9M3zRMH+RnEPVYgTT+/q7TUeDIXE0/yXAc3LyO2r5ysaVFLR2GVnV0Bfoh/GYsDgnykx1kUeQq8l+mdDKJwYAfzl4i1858mBeApP14B/y+HLOQPKYeP3ZTsub+qhDBQn4Hgyqe8yheSOShDFz+gRwJnkpEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242728; c=relaxed/simple;
	bh=h9swG2Sn1/N7SAoh3vexKvtBj73ElbG68IbcQv8XzIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOveNgcVj8YLV2D96hDlL3cq+RVh59zhdrOvm+sqSNWGPidJXMkqIinMNhCmhZORwvi72ss6zRdo3ikz5UseyQwKeNUuFCO+PizalYEG2FQMqEkfsP3wVNHO2A9V4liWVpZrRHUcy1IVudiJGRB3STYVORGHcbbk8JiQQd5Z8DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n8ZoRayx; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n8ZoRayx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5h3H8pUEdZS05EyxRSv3cu6M0M3YALyEMG4moL+MYwk=;
	b=n8ZoRayxLL5m9vUgXn+x9pLIy1YrTnthoO3ewUoQVrPhK72W8/P6XcCHUYXikeF/byc3W+
	ywTwFoJysZbMsbnJgKFqvlLuYuxhv2GUCkhoS3cuFChRIGucNRa5obN5Yr6eHbD2qq8Scq
	lhH6L0ieGdR0DrdBt7TF6m0fUMj07sU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 08/13] smb: move smb3_fs_vol_info into common/fscc.h
Date: Tue,  9 Dec 2025 09:10:14 +0800
Message-ID: <20251209011020.3270989-9-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
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
index 5bf6c82e27f7..bd1e0824ac4a 100644
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
index 5d6ca221d4b6..a4804674aaba 100644
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
index ddd031ad7689..4faa44fa9875 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5514,11 +5514,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
@@ -5527,14 +5527,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
index 2baf4aa330eb..b8da31cdbfd1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -90,14 +90,6 @@ struct smb_negotiate_rsp {
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

