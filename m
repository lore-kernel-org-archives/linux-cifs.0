Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC34A30E859
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427064; cv=none; b=Rp3XDf+rdr/9cdJcUwPAhbAjRWCeM8uXqoqYHuEGklT0MSjfOZeVc14rxPjEUkxzkkVnP3U7wOptw0kE2NDYJ+ZJ3xOCTvGXMu/4+w8LdtrU40kF4eECl4fjaXoHHWsyVTpA6dw34HyC0WEWo6qiXzcFjVjIFn05AHcAZB3fj5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427064; c=relaxed/simple;
	bh=oBWHsb5ZrCzAgydcykXvb0C1NNG8ufvsu6D1kbmawFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghvgRwO0VV0HCRZssIIeUgpxWsPT5mVMBNDO6sOzJUj9H2dsm7yrYhtKmO36F7rzq4MWv3yJTeIiIf1rDrerZbqzTiHDuuvnB90gx5Yc5XgfLVyGg1ok75BkOvjgRT/R/dmLo9QYZ4kbOJpkkI8yNPqRMPuDea+itrp1hQpFCls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QFg6gbt2; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QFg6gbt2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=id2gx6Q2/ekEzaepGLYaw2eJ/2EtAa9+sxPsv0v9VY0=;
	b=QFg6gbt22U24VjFjsc12JX2neXDKov0QYC1zwupgyoyGO0rq9yGmcpSLbZibfkUSXI5aty
	DGIzQmaROOfq4TldRqXtsEZ/6vQH/xLOmXUaAkaO8KCo+D8A4Qp4M+avgwN7DRKmldjBhR
	Jeea7BWXa2NSfPKGKrgsaiBSnTNTvYM=
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
Subject: [PATCH v3 20/22] smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
Date: Tue, 14 Oct 2025 15:28:54 +0800
Message-ID: <20251014072856.3004683-10-chenxiaosong.chenxiaosong@linux.dev>
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

Rename "struct file_both_directory_info" to "FILE_BOTH_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 18 ------------------
 fs/smb/common/cifspdu.h    | 19 +++++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 18 ------------------
 4 files changed, 26 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index f89abcb88dee..3db5e7e6172e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2167,24 +2167,6 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
 
-typedef struct {
-	__le32 NextEntryOffset;
-	__u32 FileIndex;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 ExtFileAttributes;
-	__le32 FileNameLength;
-	__le32 EaSize; /* length of the xattrs */
-	__u8   ShortNameLength;
-	__u8   Reserved;
-	__u8   ShortName[24];
-	char FileName[];
-} __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
-
 typedef struct {
 	__u32  ResumeKey;
 	__le16 CreationDate; /* SMB Date */
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index d7c9f17ed220..cf5e3ee577d0 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -401,4 +401,23 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
 
+/* See MS-CIFS 2.2.8.1.7 */
+typedef struct {
+	__le32 NextEntryOffset;
+	__u32 FileIndex;
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le64 EndOfFile;
+	__le64 AllocationSize;
+	__le32 ExtFileAttributes;
+	__le32 FileNameLength;
+	__le32 EaSize; /* length of the xattrs */
+	__u8   ShortNameLength;
+	__u8   Reserved;
+	__u8   ShortName[24];
+	char FileName[];
+} __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6121060d84ae..8c5700102cc6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3798,7 +3798,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_FULL_DIRECTORY_INFORMATION:
 		return sizeof(FILE_FULL_DIRECTORY_INFO);
 	case FILE_BOTH_DIRECTORY_INFORMATION:
-		return sizeof(struct file_both_directory_info);
+		return sizeof(FILE_BOTH_DIRECTORY_INFO);
 	case FILE_DIRECTORY_INFORMATION:
 		return sizeof(FILE_DIRECTORY_INFO);
 	case FILE_NAMES_INFORMATION:
@@ -3829,9 +3829,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)d_info->rptr;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(fbdinfo->NextEntryOffset);
 		d_info->name = fbdinfo->FileName;
 		d_info->name_len = le32_to_cpu(fbdinfo->FileNameLength);
@@ -3960,9 +3960,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)kstat;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)kstat;
 		fbdinfo->FileNameLength = cpu_to_le32(conv_len);
 		fbdinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4217,9 +4217,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 	{
-		struct file_both_directory_info *fbdinfo;
+		FILE_BOTH_DIRECTORY_INFO *fbdinfo;
 
-		fbdinfo = (struct file_both_directory_info *)d_info->wptr;
+		fbdinfo = (FILE_BOTH_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(fbdinfo->FileName, d_info->name, d_info->name_len);
 		fbdinfo->FileName[d_info->name_len] = 0x00;
 		fbdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index e325c2e89aa5..9e72c45c100b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -87,24 +87,6 @@ struct file_names_info {
 	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
-struct file_both_directory_info {
-	__le32 NextEntryOffset;
-	__u32 FileIndex;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 EndOfFile;
-	__le64 AllocationSize;
-	__le32 ExtFileAttributes;
-	__le32 FileNameLength;
-	__le32 EaSize; /* length of the xattrs */
-	__u8   ShortNameLength;
-	__u8   Reserved;
-	__u8   ShortName[24];
-	char FileName[];
-} __packed; /* level 0x104 FFrsp data */
-
 struct file_id_both_directory_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
-- 
2.43.0

