Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA92475E3
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 08:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771230107; cv=none; b=s/0FkHsw7vklep+YnSEwsmnPkcYAawbR04V6vh4y2hY85bD+YexdM0JUtQoBw8MH740dzbJw7qb33oVMeZiAyigF/SaMRmxxqNydpCg2qMf1Fmy6JA63/eGgScLnW7vCntOPYbZyfplQQpxeADOdyuSLawWXO7mJ6w7rj4j5vCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771230107; c=relaxed/simple;
	bh=xcnrTsEvQQsMwy7hD8XM2TFkMyIaYqb4InSp6f4BivE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNcz7e4+a31keD1fxZ9kJH28FJlWOCM7fNTpLoJ3e6LeQsWNEXECmMaMqfcOEWnVklQyGtqp6OcwCQzxtaoMwicoypz9eUmkjWheVM6BI2CovzqdnoX6C9xL4kbMYwFI9JH4efIXIz9yxrp591JwBSqN5JUFM4fx1f2DmYHuyaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RTKIJDON; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RTKIJDON"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771230103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyyGKWLBr+53PHddrYJXBTJYh5DtS8RIHbKNPXNkl1Q=;
	b=RTKIJDONou8BmbjEAS2ats7STiT+Lvd8SBLzF9ygBszZm4DHQtq00Zx+DXWtv0lbeDx7KE
	59EsdpHKwu5ntBhwe5EWaYGK/xCGxZLi82U9f/lmhDS+ssU1YvfJuWo3okj2kTqjhCKLql
	Ms2kUse4y4UWwiWrlRbV8aTBiCt91EE=
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
	chenxiaosong.chenxiaosong@linux.dev
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 1/5] smb: move smb3_fs_vol_info into common/fscc.h
Date: Mon, 16 Feb 2026 08:20:14 +0000
Message-ID: <20260216082018.156695-2-zhang.guodong@linux.dev>
In-Reply-To: <20260216082018.156695-1-zhang.guodong@linux.dev>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
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

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/fscc.h       | 11 +++++++++++
 fs/smb/common/smb2pdu.h    | 11 -----------
 fs/smb/server/smb2pdu.c    | 10 +++++-----
 fs/smb/server/smb_common.h |  8 --------
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index 0123f34db1e8..d2e00eba1a98 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -138,6 +138,17 @@ typedef struct {
 	__le32 BytesPerSector;
 } __packed FILE_SYSTEM_SIZE_INFO;	/* size info, level 0x103 */
 
+/* volume info struct - see MS-FSCC 2.5.9 */
+#define MAX_VOL_LABEL_LEN	32
+struct smb3_fs_vol_info {
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
index e482c86ceb00..69dd7c792804 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1942,17 +1942,6 @@ struct smb2_fs_control_info {
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
index cbb31efdbaa2..966a499d2eb8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5531,11 +5531,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
@@ -5544,14 +5544,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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

