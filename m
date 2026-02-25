Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6B29D29E
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 04:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992734; cv=none; b=c5uNdI+/AdteC1tMk1suhjMySRfzwe8CXRLXD6yyxCpiBfWZ6ztvE9wS/3hp+ICYD8fK+htqgeZdoSmiIbQrB03HZA/OEk1ywYZA1PnPmOaiUFzsq72/yFenJ4ulF+lnbh0ghEpVPHAEXvrxHFAOx/MkpgWOeEeXhnzTQzA3Occ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992734; c=relaxed/simple;
	bh=PUTyaFtlJV3HRvEORlT/ny49VqR8+CpMwcn/N/2Y0d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7cM8wh++GOovrVyHIaMnmSMfbUv6Xu85XsYlOOSRl91faobvrkfHoPOQbjHXZErAwGzMsFg3uhtHZJNCL0/WaZSvLnil+BqthFFUVt3AYiMhGP1W1VrIKSDZMUfqTaTJHlrKCjTlkXb1yDTWLL7Zv5JhcjOwWpkUZB252cbmWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ScywcXZD; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ScywcXZD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771992730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3RAHty1p/4F2uRgfkmoVhDZqE/GNiEgBwDmfbRGyfk=;
	b=ScywcXZDE41p+Lgar4EOrnpFKHUeAFiJ0lvSBt9dnoBrNMvJxdvYXuy7hGMPBqBqBGeXbl
	EyPG2tUHTooYcZ4yhCSjNiEA4zQCHBirKyKa+m1oBuaeuxq3GvQA7zHvWlPXTWU3wBO//q
	wMLhJA4OvQbh3p+hjgfqwY7dMirWD9U=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 3/5] smb: move filesystem_vol_info into common/fscc.h
Date: Wed, 25 Feb 2026 04:10:58 +0000
Message-ID: <20260225041100.707468-4-zhang.guodong@linux.dev>
In-Reply-To: <20260225041100.707468-1-zhang.guodong@linux.dev>
References: <20260225041100.707468-1-zhang.guodong@linux.dev>
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
  - struct smb_mnt_fs_info: __le32  vol_serial_number
  - struct cifs_tcon: __le32  vol_serial_number

Then move it into common header file.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/cifs_ioctl.h |  2 +-
 fs/smb/client/cifsfs.c     |  2 +-
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/fscache.c    |  2 +-
 fs/smb/client/smb2pdu.c    |  6 +++---
 fs/smb/common/fscc.h       | 11 +++++++++++
 fs/smb/common/smb2pdu.h    | 11 -----------
 fs/smb/server/smb2pdu.c    |  5 +++--
 fs/smb/server/smb_common.h |  8 --------
 10 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 217444e3e6d0..8bb909a57edf 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -92,7 +92,7 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 	else
 		seq_printf(m, " type: %d ", dev_type);
 
-	seq_printf(m, "Serial Number: 0x%x", tcon->vol_serial_number);
+	seq_printf(m, "Serial Number: 0x%x", le32_to_cpu(tcon->vol_serial_number));
 
 	if ((tcon->seal) ||
 	    (tcon->ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA) ||
diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index 147496ac9f9f..b512d8af017f 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -11,7 +11,7 @@ struct smb_mnt_fs_info {
 	__u32	version; /* 0001 */
 	__u16	protocol_id;
 	__u16	tcon_flags;
-	__u32	vol_serial_number;
+	__le32	vol_serial_number;
 	__u32	vol_create_time;
 	__u32	share_caps;
 	__u32	share_flags;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 427558404aa5..93e9cfa042eb 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -373,7 +373,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	else
 		buf->f_namelen = PATH_MAX;
 
-	buf->f_fsid.val[0] = tcon->vol_serial_number;
+	buf->f_fsid.val[0] = le32_to_cpu(tcon->vol_serial_number);
 	/* are using part of create time for more randomness, see man statfs */
 	buf->f_fsid.val[1] =  (int)le64_to_cpu(tcon->vol_create_time);
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6f9b6c72962b..aa4462b0df25 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1270,7 +1270,7 @@ struct cifs_tcon {
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
-	__u32 vol_serial_number;
+	__le32 vol_serial_number;
 	__le64 vol_create_time;
 	__u64 snapshot_time; /* for timewarp tokens - timestamp of snapshot */
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
diff --git a/fs/smb/client/fscache.c b/fs/smb/client/fscache.c
index 01424a5cdb99..9801b7fa58ac 100644
--- a/fs/smb/client/fscache.c
+++ b/fs/smb/client/fscache.c
@@ -29,7 +29,7 @@ static void cifs_fscache_fill_volume_coherency(
 	memset(cd, 0, sizeof(*cd));
 	cd->resource_id		= cpu_to_le64(tcon->resource_id);
 	cd->vol_create_time	= tcon->vol_create_time;
-	cd->vol_serial_number	= cpu_to_le32(tcon->vol_serial_number);
+	cd->vol_serial_number	= tcon->vol_serial_number;
 }
 
 int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a2a96d817717..c7004b4eb87c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -6164,8 +6164,8 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -6220,7 +6220,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 		tcon->perf_sector_size =
 			le32_to_cpu(ss_info->PhysicalBytesPerSectorForPerf);
 	} else if (level == FS_VOLUME_INFORMATION) {
-		struct smb3_fs_vol_info *vol_info = (struct smb3_fs_vol_info *)
+		struct filesystem_vol_info *vol_info = (struct filesystem_vol_info *)
 			(offset + (char *)rsp);
 		tcon->vol_serial_number = vol_info->VolumeSerialNumber;
 		tcon->vol_create_time = vol_info->VolumeCreationTime;
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
index c787d9fd6dd2..b5dcd9cff2e2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5544,13 +5544,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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
2.53.0

