Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9683B2EC56F;
	Sun, 12 Oct 2025 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286078; cv=none; b=fFegP71XL/2ZOcLRbmKtEZQszjyd4YKt46zOv2EQAjUaS8BqAM4+ApuEzzCGRJOq+0LX4qeskEalx7NMyaMlmc1y6CXwc62zM6oCMF/2hoBwb5tsG0OL92oKt/YysX3qd00zCe/MDxHPoBFRFFysqrmPowxPYhbyhhOVNuHDSDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286078; c=relaxed/simple;
	bh=F6Sq6Ie75/UTc0yIY1uQJ2UUmS8cT5UNdaUtmeFRic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3StTu/9tuzzvLSbDQcBgMRGWGkrTMsnqQCrxh9gFv9Ho5DIPDmdbDADclrWrB2IrY24RLlLRMQ2Vdi8D1sJhIKHD6hrmEN7coJV2duRklg/2+AXz1Xlx5xG55/X3H0jc2sutFSBjC2xScAJ64wCzPYSAQGhgnrpKsrvQ3GmcgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285931tb4f7890c
X-QQ-Originating-IP: AV0LBOmKF5cpSCvrpO1+Yi9uuEjRWFwQIEuMNPtKqV8=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17409360235789610132
From: chenxiaosong@chenxiaosong.com
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
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 18/22] smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:45 +0800
Message-ID: <7DCF4063CAD357B2+20251012161749.2994033-19-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NStkX+agXEYc2MZrKGn0sjzqkdp3SJxaWMg82FGEuMRz6pqVNbeS/yr2
	+RIL2SV+YQLLoNLXr5KY7lSnkLSYjcFobHSvgJU4278h93wTDRbeNI48xuUPkkB0VgG6zmo
	9pTsJ54t0ee87TOlq6uX9ppuwur9/GMohoSRKbCalcrHyKmP6jpAYifWRu6OMfwNvyJckNT
	+Fqm1RFmJJgA76LT9Em2MSXzDLHdA4z2M7Qnx7f4c/o491j5yO0B7jrX0HQz+L4r7/MuZSE
	Mv7CMhNJzk6SYNEntfPh6DBv9QAKSlBI4VRG8m+CXcCVRGTT2WuLoDtjUpO7MFdEe1Dhi/q
	WtTZ1Jvq9rFEGbK4fa3zDTTuyIxMBVDnMqiFV6OzdAIDC/ebjhSgvIWan2cOrTbeIkFR/dB
	czktMckBBvTkgo3YAMG+QZWJi7nQ77FxF42mNHPIfbIDvVh545hUrjQvEdTjBPcG58TCACA
	+4b4DGBKdZDbImGa8ngEzUUxhgtKHf2Qt0Ur13WhAnVM+rxmbZKyTkpVFzODzZYeiKzNeSX
	JPb/NCV6cD0Q0p1/4WcnsQ+gZNCUiieyZZqaQ383bUO8CHWI2Oq3TGRPpeOLT2g+iOX+9mS
	Lko+9B2iWXb1yJt/qEJnO5gRWoU9p+Yd8iHtaTwEsPWv5EfyzfzDU4+Bg6/Z8m30GTao7aM
	L3OQ3757ICOhNccT48nvhWXqdgj5wMQjfaE3XpfpikD6/sO6pFbivAXa0iIzVsCR/nL19M1
	CLUgjzPS0Zlaga4/WNcgFU2Hx06VaR2I0ZZ/XeW7F9nqeu2iHsj/nwdTcg1iwhDRqjwlGdr
	xZBQwwalBQeONXYdbaW4t30QxfGaHaRilGjJKdTaDWemazTiY5AXHtsv8iPgLh6qIxFaf8N
	EgRrjIlwfTtaqQbepHk1ChuDBhWFLAD20x37H7urUbFY45ZL3Hu6px1+1+sjVJunzTZGdu2
	YrtGEArYj9PA2KXunqXD57pVp5Y8MJqUAQAi1+Z9hnFVS1W2duO7K/OXAHFHjc/3r+e4VSL
	jsEBNtWv1VDghsz3f4T4qz/Ei3BJPqrTz8oJlHKNaeOlIEZwjtx38edX3ScxZXN3kwYaAoI
	XxlBOOYYOww/bh8Jk+6e8s=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_directory_info" to "FILE_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 14 --------------
 fs/smb/common/cifspdu.h    | 15 +++++++++++++++
 fs/smb/server/smb2pdu.c    | 16 ++++++++--------
 fs/smb/server/smb_common.h | 14 --------------
 fs/smb/server/vfs.c        |  2 +-
 5 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 889be409146c..8031e24234a9 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,20 +2150,6 @@ typedef struct {
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
-	char FileName[];
-} __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
-
 typedef struct {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 548d621ec233..82d57ba275ee 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -370,4 +370,19 @@ typedef struct {
 	__le16 FileSystemName[]; /* do not have to save this - get subset? */
 } __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
 
+/* See MS-CIFS 2.2.8.1.4 */
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
+	char FileName[];
+} __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2ad46a11e7ef..679318afdce3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3800,7 +3800,7 @@ static int readdir_info_level_struct_sz(int info_level)
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_both_directory_info);
 	case FILE_DIRECTORY_INFORMATION:
-		return sizeof(struct file_directory_info);
+		return sizeof(FILE_DIRECTORY_INFO);
 	case FILE_NAMES_INFORMATION:
 		return sizeof(struct file_names_info);
 	case FILEID_FULL_DIRECTORY_INFORMATION:
@@ -3839,9 +3839,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)d_info->rptr;
+		fdinfo = (FILE_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(fdinfo->NextEntryOffset);
 		d_info->name = fdinfo->FileName;
 		d_info->name_len = le32_to_cpu(fdinfo->FileNameLength);
@@ -3978,9 +3978,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)kstat;
+		fdinfo = (FILE_DIRECTORY_INFO *)kstat;
 		fdinfo->FileNameLength = cpu_to_le32(conv_len);
 		if (d_info->hide_dot_file && d_info->name[0] == '.')
 			fdinfo->ExtFileAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
@@ -4228,9 +4228,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	}
 	case FILE_DIRECTORY_INFORMATION:
 	{
-		struct file_directory_info *fdinfo;
+		FILE_DIRECTORY_INFO *fdinfo;
 
-		fdinfo = (struct file_directory_info *)d_info->wptr;
+		fdinfo = (FILE_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(fdinfo->FileName, d_info->name, d_info->name_len);
 		fdinfo->FileName[d_info->name_len] = 0x00;
 		fdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
@@ -4514,7 +4514,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 			goto err_out;
 	} else {
 no_buf_len:
-		((struct file_directory_info *)
+		((FILE_DIRECTORY_INFO *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
 		if (d_info.data_count >= d_info.last_entry_off_align)
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d6351b0ee62a..ea1c64f84ff1 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -80,20 +80,6 @@ struct object_id_info {
 	struct fs_extended_info extended_info;
 } __packed;
 
-struct file_directory_info {
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
-	char FileName[];
-} __packed;   /* level 0x101 FF resp data */
-
 struct file_names_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..a8660487e4ae 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1654,7 +1654,7 @@ int ksmbd_vfs_get_dos_attrib_xattr(struct mnt_idmap *idmap,
  */
 void *ksmbd_vfs_init_kstat(char **p, struct ksmbd_kstat *ksmbd_kstat)
 {
-	struct file_directory_info *info = (struct file_directory_info *)(*p);
+	FILE_DIRECTORY_INFO *info = (FILE_DIRECTORY_INFO *)(*p);
 	struct kstat *kstat = ksmbd_kstat->kstat;
 	u64 time;
 
-- 
2.43.0

