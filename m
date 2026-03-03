Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE2B481FBC
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550870; cv=none; b=jZCaEE0OsuhFmhxOC6XtYUANcrxV3nZJOLsOJfC/15titz8toLu0oufoL8SjiyDvU5rrdRasUaMJRA/U1XONvjXyU21sRiKbuypRYr9D5jNl640EfmvikiQrpV/YbQQ2lXNm5pF5ntJCxsWWlmu62IPGe2huvTrKA0J3YipNwLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550870; c=relaxed/simple;
	bh=zDLi3fP8yrMqNDHD/dbfCABvsYdtc8/pf1Tseb8GBOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arKaPu6jX2tvN90DAPRaKVMt2yTJ3y6Vqk3MmFFUWf5KHhzIifRLVyUaW6JkEkgagxiA8Fj8uBBdNPF+Oj7oe+I8M8w+gkYtEfMe2o1dLF+E7egz/i0WV3RH7He54wxewz9Carblt3roNrzkV0SiZfSRVLMD8cYgob1uVU3Te3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YVbH0Wsp; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YVbH0Wsp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772550866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOWYvFnIGt/XUGylPgTtESdrjcn7fxLkXOUWG8533kU=;
	b=YVbH0WspKXoc7W6F53Ykxkz+VKkrNVTUaGCbPO86rv02QOD+0BVB12eRBElvdbH89UKT9V
	QUsYPpNjY66PHw3DghbLH5eDwbdZsKrBgVZYkO57HseS24MtLfEUOn53dF5Hg9VafgG7gg
	BbCJTIKggm2bPxRV3QHdIr2p2CYiUt4=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v5 6/7] smb: move filesystem_vol_info into common/fscc.h
Date: Tue,  3 Mar 2026 15:13:16 +0000
Message-ID: <20260303151317.136332-7-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-1-zhang.guodong@linux.dev>
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
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

  - smb3_fs_vol_info -> filesystem_vol_info
  - SerialNumber -> VolumeSerialNumber
  - VolumeLabelSize -> VolumeLabelLength

Then move it into common header file.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smb2pdu.c    |  8 ++++----
 fs/smb/common/fscc.h       | 11 +++++++++++
 fs/smb/common/smb2pdu.h    | 11 -----------
 fs/smb/server/smb2pdu.c    |  5 +++--
 fs/smb/server/smb_common.h |  8 --------
 5 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c43ca74e8704..1c917f80f19d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -6144,8 +6144,8 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		max_len = sizeof(struct smb3_fs_ss_info);
 		min_len = sizeof(struct smb3_fs_ss_info);
 	} else if (level == FS_VOLUME_INFORMATION) {
-		max_len = sizeof(struct smb3_fs_vol_info) + MAX_VOL_LABEL_LEN;
-		min_len = sizeof(struct smb3_fs_vol_info);
+		max_len = sizeof(struct filesystem_vol_info) + MAX_VOL_LABEL_LEN;
+		min_len = sizeof(struct filesystem_vol_info);
 	} else {
 		cifs_dbg(FYI, "Invalid qfsinfo level %d\n", level);
 		return -EINVAL;
@@ -6200,9 +6200,9 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		tcon->perf_sector_size =
 			le32_to_cpu(ss_info->PhysicalBytesPerSectorForPerf);
 	} else if (level == FS_VOLUME_INFORMATION) {
-		struct smb3_fs_vol_info *vol_info = (struct smb3_fs_vol_info *)
+		struct filesystem_vol_info *vol_info = (struct filesystem_vol_info *)
 			(offset + (char *)rsp);
-		tcon->vol_serial_number = vol_info->VolumeSerialNumber;
+		tcon->vol_serial_number = le32_to_cpu(vol_info->VolumeSerialNumber);
 		tcon->vol_create_time = vol_info->VolumeCreationTime;
 	}
 
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 076cbcffa26a..b4ccddca9256 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -447,6 +447,17 @@ typedef struct {
 	__le32 BytesPerSector;
 } __packed FILE_SYSTEM_SIZE_INFO;	/* size info, level 0x103 */
 
+/* volume info struct - see MS-FSCC 2.5.9 */
+#define MAX_VOL_LABEL_LEN	32
+struct filesystem_vol_info {
+	__le64	VolumeCreationTime;
+	__le32	VolumeSerialNumber;
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
index 538e7a12ea93..85a4248d4f29 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1635,17 +1635,6 @@ struct smb311_posix_qinfo {
 	 */
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
index 5126394337bc..f73ea4d1db8f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5545,13 +5545,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
+		info->SupportsObjects = 0;
 		sz = sizeof(struct filesystem_vol_info) + len;
 		rsp->OutputBufferLength = cpu_to_le32(sz);
 		break;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index ca7e3610d074..b090b56743c4 100644
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
2.52.0

