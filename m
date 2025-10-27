Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E508F2E2DFC
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549356; cv=none; b=QS/XBvf+UOv1MrFu/KO/Pah+L2HdGUu265OwBVyeFRZ5R0l/kMP6nN9H6qY1KDGxqYdmvGAgOpnRtrR/Z8MlaBvuWErkqBdhNdpRVrRhzLVfAR9uy6iy8E+JegIGSP13gofnBRXBRNg7cF9pbxAe05+slC1Bcj97+ojOtDXCOSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549356; c=relaxed/simple;
	bh=wunBsqhsP068NiMoELqQshZ2wU0PGypzj8sZSqysckI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzsdvYO029PHHVaGp2RPRPDvBt+Ks3A0oPQYTUk54J47LEVZhaSTBPiLpOcpBoZwUCKzPaoG5BcZT4maRex8+1WNb4hxISZkc9xzbm9SGZh6dWA7CIfbm2j5qreKCRZdx/CDE4bj2tQlT+TeraDjQWjjZqNutYqH1pD+QiyXzak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=loz9ZqSu; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="loz9ZqSu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/npw3UtVzzHKnhWtUxEh+GVZ5zLFBAoolGZR5y2DWw=;
	b=loz9ZqSu9aQa6azazaDz56X0xJQFykTZsgk6bOh47LE53uDB1j1gZ1Xd2Rj4rsYiXjiJVW
	N0uZT+96MIv236wpBNZjFAfciYFF9y7zIXmaFXTvOuf4PuPJfH+zBN3zSBfYklNmWsViOB
	Pp6B3QYhcRfxiW/3KMqPCpWSy6JSxQQ=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 14/24] smb: move SEARCH_ID_FULL_DIR_INFO to common/smb1pdu.h
Date: Mon, 27 Oct 2025 15:13:06 +0800
Message-ID: <20251027071316.3468472-15-chenxiaosong.chenxiaosong@linux.dev>
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

Rename "struct file_id_full_dir_info" to "SEARCH_ID_FULL_DIR_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 17 -----------------
 fs/smb/common/smb1pdu.h    | 18 ++++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 17 -----------------
 4 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 8aac0e04f9fd..d106c6850807 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2159,23 +2159,6 @@ typedef struct {
 	};
 } __attribute__((packed)) FILE_UNIX_INFO; /* level 0x202 */
 
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
-	__le32 EaSize; /* EA size */
-	__le32 Reserved;
-	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[];
-} __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
-
 typedef struct {
 	__u32  ResumeKey;
 	__le16 CreationDate; /* SMB Date */
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index 0bc1e2373210..82331a8f70e8 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -399,6 +399,24 @@ typedef struct {
 	char FileName[];
 } __packed FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
 
+/* See MS-SMB 2.2.8.1.2 */
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
+	__le32 EaSize; /* EA size */
+	__le32 Reserved;
+	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
+	char FileName[];
+} __packed SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
+
 /* See MS-CIFS 2.2.8.1.7 */
 typedef struct {
 	__le32 NextEntryOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b6daac1cd080..47fab72a3588 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3804,7 +3804,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_NAMES_INFORMATION:
 		return sizeof(struct file_names_info);
 	case FILEID_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_id_full_dir_info);
+		return sizeof(SEARCH_ID_FULL_DIR_INFO);
 	case FILEID_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_id_both_directory_info);
 	case SMB_FIND_FILE_POSIX_INFO:
@@ -3859,9 +3859,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->rptr;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(dinfo->NextEntryOffset);
 		d_info->name = dinfo->FileName;
 		d_info->name_len = le32_to_cpu(dinfo->FileNameLength);
@@ -4000,9 +4000,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)kstat;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)kstat;
 		dinfo->FileNameLength = cpu_to_le32(conv_len);
 		dinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4250,9 +4250,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILEID_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_id_full_dir_info *dinfo;
+		SEARCH_ID_FULL_DIR_INFO *dinfo;
 
-		dinfo = (struct file_id_full_dir_info *)d_info->wptr;
+		dinfo = (SEARCH_ID_FULL_DIR_INFO *)d_info->wptr;
 		memcpy(dinfo->FileName, d_info->name, d_info->name_len);
 		dinfo->FileName[d_info->name_len] = 0x00;
 		dinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 649b45695449..6141ca8f7e1c 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -108,23 +108,6 @@ struct file_id_both_directory_info {
 	char FileName[];
 } __packed;
 
-struct file_id_full_dir_info {
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
-	__le32 EaSize; /* EA size */
-	__le32 Reserved;
-	__le64 UniqueId; /* inode num - le since Samba puts ino in low 32 bit*/
-	char FileName[];
-} __packed; /* level 0x105 FF rsp data */
-
 struct filesystem_posix_info {
 	/* For undefined recommended transfer size return -1 in that field */
 	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
-- 
2.43.0

