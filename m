Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5395E2EDD78;
	Sun, 12 Oct 2025 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282692; cv=none; b=PQ064CEaI1ihNh5V8FBky9inHt5pwqKcDEX0iXC2z8xue7LPiNuqBu6BOLdng+9KMxwFa8+IZ/m4/itbW79oKpk2eC6toESXvsISVFaQnAjMzSgziI8XjaG/cw3eMA4sdO6rXUUI0hQlpqF8dACwCT/EYAUt+o2B9VdCigNJl6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282692; c=relaxed/simple;
	bh=F6Sq6Ie75/UTc0yIY1uQJ2UUmS8cT5UNdaUtmeFRic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZwTWfXfiAjP9afs5vqsaWR0h0BGnYTyUeLeyHWGbDc/OxDM1bPqpwmvJ0Onn/mZ0+2CnbtafquJim+DVmwbtMi+xMkiUftstI7xKnKsM+NaXbEPkutyKJX1aLQeWtC0izzBTSOj3//Ea8VibOsF/5DnZ81L1pd0M2XZwl0JHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282622t928a955d
X-QQ-Originating-IP: h8cIt058RywDXfq/bcQL2UF7QvNzgqOLMQrvUGKGMU4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:41 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17113931618655962784
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
Subject: [PATCH RESEND 18/22] smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:43 +0800
Message-ID: <06C5CAD7303EB04F+20251012152247.2992573-19-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: OKgraWJYmkAvm0XUoJXrGiGClxIOC/gnQGNJZx0jJXrTg0hz7XVjYdJG
	1xHFI2J28cz625JhGUttk23PjOqol7eM64lswq/Emvbm/53xO999PaBBJMzNh2oB7wV7M11
	YT0UAkgnkBmyH/tXT95CdOljxZK4Wy5BSEizp6+8g9M4G4KHnLQAE08qa3Twa9gfZy89ik4
	Ig4rTV3aXgXUBem2NMemU02Clhfndb+ECegeuO4ZamLSako8diGhggI33SCe0NtYpXt9x6E
	ojUZK7Mq6elXoefckRDB699jzW1HvcTa1I81BVSxDBGTvOLWeM8rvkxPe/6KwzZuAXj5e06
	Om3uhusw8a3CjRm104np3BtnXSOV5a4dOfbekGHyAl6z531RXmcKc2q2NDVM43RF15leLRi
	beuyLKzgs4frp2ZgwnuosmgWsrEmF2EonAytFsQa61/DzMtiPwhxT6sYeN1t94zmzSzyeRM
	0UK6uCCSDD8yfelR4gU7aURY0AkDTGe35GGIJfy5/i7D1BRtLKD3F1Px591IIVIv8/St+cV
	JVWKUZl15X+JOdh+qIbSCVBUdTHBLqwWaPZx47GTyDNHquZpmIdQRsJArlt3LVkoHqPib6z
	IkbOlINzBMC3g1RA1u6NL/1uQmN16bKA50ct7Z7bOvqLez2G6OYfRWn5947fQ7Dr2EqUNK9
	MFhJ9sKBER6Tl+drfEC+qnTDQ60RzuH8lskSECZ369+pV2wVcUi40xmGYjbZDv1VGiChSCt
	37Dppyvhq+c4ULnVIeAUuOeM3E/pP4wg89LWWePnTPTakey3GpJ4li38XAEXOdLmSRirQaq
	p+fFR3HPmuEB6iUnifJwcclGlBUwcWPWmGwayNCoXNMAgUu885TPgbRY5qyNKWm2+fg90Mb
	UtyWvwP/l5sl7L42K/vNuzSHs4W+EujFgbwg9y0eoaTAGcQZtGIHj4gp4mPUsAEdb78hG2d
	jvfIbDfoe7Z/hFpTbvWahmy1x5jV/ZpJzzvB6+N4Nc74eCvOWN4K3LMiVBlx7w5LbuD29ot
	bJNawx/uymo7RWfJXoP6u1FkdfnbYnfy/31RT9z6CzymGqrEn52j5fWC2UhyWkW9ll5JOHH
	LZiiGciuO8jbmqT45hZtw6Hl0kkXhr8lAuvehKuIG9k62fuj7inSw4=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

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

