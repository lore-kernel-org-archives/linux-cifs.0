Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3E2D7395;
	Sun, 12 Oct 2025 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282055; cv=none; b=uGP+a7X8Wqyh7os6tQkfcLPXRfSj+1Bc1Ht3TiulejCzDXHiDunPG49rIkPrv12cvoJtI4/yklAhKaTwJbIk7fD9ogM4dZ1JYVV8UJPhWp3rJkCCXKlp1IQJH4pVbT90HjG6zHDvP4EsQYhTzo8fndPoxvsVyOmwanawnLrZWSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282055; c=relaxed/simple;
	bh=F6Sq6Ie75/UTc0yIY1uQJ2UUmS8cT5UNdaUtmeFRic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRO69xDXJhNbUECfce4Vtxn8+Vh5dMSneTMlKKRCaEuDpahpj/VOcMcAWW7zyM7B/zfL6/VTVeBFjBTiEXXd31Ye84MdiDmkD/WPzGe3A01576fYaj8TJrEDVStSsGMBdQqCUd5PhREwhA+a3EW2xskJNCwaL8JpOZ0LjTI81W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281845t332b7d2f
X-QQ-Originating-IP: EQ8+eazKRppuB9E6Azt2sSlJ9bqLQmL3XZ8W8m05150=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11428189015172842347
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
Subject: [PATCH 18/22] smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:11 +0800
Message-ID: <30F7355E94F655A9+20251012150915.2992220-19-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M+znYroNOpVIQMivM2tSgMxm+zKsnkTmszkiVi/w9nWFOPIW+dLGku67
	k0KF/MjxPY3k5X14zd7apv/sjfWlT3QbSuIftX4FCgofN/8up/uEli9vSFEM/CYjpQO0bMM
	D7L0PI6HNwWUS9EkzixUILh5GvkurGVfAGw5lyLZPV0LFtuPNByygFhedIx7blYf+AXKQ73
	Q6WFZ9kEl4u9C1ubk87LIBQfe3btwX+q3pj26VRrCPy8FkYHccCCdVBfMNxK5ka0eBSXalS
	aSakJ059Op77Ls8bVopTqgYLbRylLdJDO3jdrrZcwBxntgOWOpvd2kXmfMd80YF47YUvTT4
	Bqf/MeusoiYfBoMjXS4C5+TpS8A8aaAbAofh1AxpQf5FFZbkOYOr0WCoToxAxGjFNyYFAA9
	l1iIoxOG32XSOKn++XFSD4/IwIyhzCD1Fcn2o1V+KUUqUsvLBlh9qoeaBaA9gtgiXqXEgyY
	A0DJmQD5iUXn9J/Pzd/EatjpSCSmWDIxPbjHPaSzTHZLd4JlQcWufDRMkzcoHNwHDVm5C2c
	SWa1L52Qbngg8/GKSmJ7gs24NbXcz9OaRqVJw+1kgowOiveDSfyhsh6MqoEdaF6DbXVoOuO
	kjrEPaEnopyh7Jzn7TbAIdrE4kPR1EDxFdaERWg5lUO/oitqemdDqwBn3DOMQyZhsJ8+Mu1
	bo4nate0jFOW0xiAbcAt2JlXi3RrI5wgz/IpS1oArFpD/XBHUoom6yBswCdvIWEg3BLnofy
	vppA3SRTlSgEgedsGX2TRmV93C9OkkClhb1EgpKKwW1q7g5j0VAvtc5JiDbDc0FjHi6Xo09
	GMvzWsO+pAtC3QujO8gLiJbxVRHOOf6BRy9SzMrjtAip0nkg03ZKcp8M/0FvpB09H9m0iRS
	5eBn3YQkXuRwJl1lhjnYBxq97QSyBJ2cloZV3ccml9iytd+JbC5U8XLoNDEsonL02+xTMAX
	Kw+P8vv4vqGYuPOq9PzONpeJaYnTkyOaC5mv6+ZxxORtd17QgHPd74czxYyX+tnF47fB1q+
	64Uzrt53rL7zbK3qCl+iwc6v834wo5/8+BcopHkA==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
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

