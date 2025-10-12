Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE36D2D4811;
	Sun, 12 Oct 2025 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282163; cv=none; b=h/am8PruVsSLgh8m8Huhk9gjtL4GGFV/JpTAWOvcu330YJBlyV6C51Zz8Gi1LsWnTN/PcnF7Z4qaa3pUk50mnDloJg7pgwPwWPss9yewlWR9Gk02shPryitLkAj1phMgsCIrkSpsDaw1xbVgZbm/7zAdV6/GTRdU0kZ9tboiTVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282163; c=relaxed/simple;
	bh=bGSjiGhKrW0fwcd2uFIhvIfrxchHrqrL9vlAAJS9bRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMeiHeLAZ9UpT8W41DcOIWJVoxS9VE76K3b27jL+2g/xL+r4aQ25hzjbkPQXsEZtRmr3RnnQkxRf/3DY5E0QVa20WpWSc7YCurMgtiZUZUSefRG2z1Df5lkV5xWjiPAtlfmr8kIDFEWEcsHzgaD0QxuOET4Fxoxb/b6lHO8T4tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281852tde07e286
X-QQ-Originating-IP: 77lQIiJosqpwuI4VU2mxWKLGyHnGI2I7Yh3Cv2GSWKo=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11395859545877594353
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
Subject: [PATCH 21/22] smb: move SEARCH_ID_FULL_DIR_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:14 +0800
Message-ID: <12483B28EEABC0D1+20251012150915.2992220-22-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: MjtcwOZJa0njIfk2v8p1xKvGOjFxQnZclEKMjWM0X8KtCc2N9MQ/CcX0
	EHS4oP3O1Dpl5st8npE0IVldPxMaZigRH6iwQ0KeIkgWhHSUVLh5fy7vGiRlGdOlTC212Xt
	JbAiEa14xxALldgLF6oTMFoUqTNo+9Vd8UQGuR5YA57rWyoaZNUkdre3eCM0eRlY5rkpbf2
	VNqgVj7x5pnYRXDqSAdcyhF21adlK59kAcd58idbRSXboV2nd5NsrKWhRrsNLh56ttJlGmK
	zKuk4T0Gaoc5Ym2VEmXOjXfK4arurQwlLVFp0Om+GgyzOTC05sD0eLSyVrllRXZ9TBOoo9E
	mET6XKuG39QGl7XstspDmvtIAXBg1szJjenBLzaKmjR5wd7l0UmGYoAL0Pt0IK1nCcMdXug
	TtLGktC5NAdz3PJxBgh2iRIn/lotSLfsgDpRpqYGj7D0qepmK7RD9xU3BoM1xhK9nbqkX1X
	3oSr5UaUzGW6lWO+PfbL3BsQD3gWE5nw5HTmVe5s4RRGnbgU/cEVmkFwGTuyv/MjuQLBjHI
	EpcosIgyaEw8kyPgNTWu1UJgat5eVFRh2RBAB0yD5ZADNVt7978MyeG2lNpqDtY6ouunteF
	+v2pkqGqtIpDsiHDn54KPJaPZhJFWfBxZiq10Kl71/7ew4KYxfXK/YjHHlMoXO9GwRoepS3
	z+0yNv/z//0Rz+nqHEK8sMU43v+gAxRgr/Rp4p1xoM2Q/cD42Je/54je6ZOOB9JyiYkmqtE
	Dy+LeeuZxDzVbbabUSvkBtqh66ATQRCzfvGORQa7OCDz+0OlvMCk8nEWJh5Dd232+JjEHUQ
	rHdIGOPu8guqRkg7bBomIDKllghI/DV0Yf3bvoaqGalsyp6G6JegXiz6jPZKk0HP4dn06QL
	1sZ99oS01ax0/6NJEs1sZJX4kvMdNPfbHmFwKLNfP87x1zSMUPlKkPRnrUFkKgv7QDlekvx
	APy7Dfqianx9NyTYg6q//8AZpdiPXpJ4CZhy+SGlTiVk7deI+mgwzaVKHMQ8L4ySzumTg/k
	bIRY0T4/vemQ1T6ztx+ZoLb/dWW0yIGIWm7ZYGFw==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_id_full_dir_info" to "SEARCH_ID_FULL_DIR_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 17 -----------------
 fs/smb/common/cifspdu.h    | 18 ++++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 17 -----------------
 4 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 3db5e7e6172e..68e3af176add 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,23 +2150,6 @@ typedef struct {
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
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index cf5e3ee577d0..b4ca0c36cf84 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -401,6 +401,24 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
 
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
+} __attribute__((packed)) SEARCH_ID_FULL_DIR_INFO; /* level 0x105 FF rsp data */
+
 /* See MS-CIFS 2.2.8.1.7 */
 typedef struct {
 	__le32 NextEntryOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8c5700102cc6..065e0daaa91b 100644
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
index 9e72c45c100b..4f48dbf9c13b 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -107,23 +107,6 @@ struct file_id_both_directory_info {
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

