Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A6F2EF673;
	Sun, 12 Oct 2025 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286111; cv=none; b=WYye+RFzyGxs9RsuYY4vlBlf/R+k/dp5K+hkO7saX60Gem/kFX/r9Zj7nqubvl+MO+LwKKzX62McRkqCyKxKFp97vKLvGeeekT3Y/A0vQ+KZK06cVQ6v+o5sSppSrLi7c+ge24RLUyWp43DOynPV2VK5i6e3MMA4mPlP6JxMV9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286111; c=relaxed/simple;
	bh=bGSjiGhKrW0fwcd2uFIhvIfrxchHrqrL9vlAAJS9bRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHZAsy6Dmd2xp1RThC6pgSkMCxToXyMLS1I0L0guI1D2qv+vtXhaITTVf2U9aMH7fSCyBaSDo0JKPX1+o/hVcLjHsoFdvcYAUar1eLcGB+ke/F6oLQTxHAVBvjHyMcCZqq9ayqAlDYQQJ7f5uLWnFxgfy+vOFI6BCpN2Sq3zaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285938t314b477e
X-QQ-Originating-IP: TV7h4rmG7pnX5V0YiMHECAvHTr8OhHoisUbJnk7yTuw=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2071705661989020812
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
Subject: [PATCH v2 21/22] smb: move SEARCH_ID_FULL_DIR_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:48 +0800
Message-ID: <B8D562FC8E37D575+20251012161749.2994033-22-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NPQe6+e0Tm239adMQHT+I4PzJVhF1vNfrqf0VktYcOC4Ka5h5jktJQRy
	K1xAT0qtRpQoUZnhPZd+3G0LMas82qY0olROsw2MBmir2aNmxUiha1QQZh+C9/5vBysz7xj
	gQUDApbniQttjuA8MbW6/pLVxI7H94GD82hkouoeJRLvx71PEBbCc97abdtcOF9YJ1ayzo/
	iI64N/B4+fs5svR3tsOoXU7yGbl2rmPmwsf16eA+EsjbfAl52f/0eqFT+nHzpCwxaQhHrR7
	0U/ZAGIExtFVQ+SW+neZVdVrHwG/JrYFjMJYXZr9u5GJc2KleOEBF2J9luvilrAWr1f/UeA
	0sQizQ/kOjlPMUxbryunCVMliAlPpLWr8D9D5MY3aWVZdN9J9t1wpnG9MALKidvh5jVj8pH
	kYdNz6qLBXqJxtketPoZeNeDVj0LE2L8k3nbvTxrjDiEX3U28yiqTwxPKtTM9gfZGv/WWXM
	oCaz0DtOhaYosgx6AEs+IL/YomxbbfDTQPi5mWhlvZpP14k3gpgYUroG91iJXb+uawMOIPw
	2NcMVCXFjRbAQ8YKjEQO3L/dF0bTjIHvaGT3v1ik0J7G45OE5khB0QJuXqcWtH0VRLX9BGN
	zneCVhq86Odil89OEnHQU34XoDvF34KY7sRP4ZAJaM5LtAWM+X9FUQDx6i0U75FIwK1Z05O
	5iD/cIGxXTCFE9ptGsFVFJJTpuiqaGg0BH44ZFWBClENl8oN592Kb4lSVkzgAGxXDGHXkgG
	4oF3eHKd2qLnsG/Lb6jpH1/w2IN5xRhojW7cMbbbbGjREfoaiVyxTqTeg+7TnazLi6R0j5L
	ElPKSl0mS99V1LHjc+z7bfgUtgAC1G5IvlB6ytCcfkQPcp3BL8yUoPAP3GQsRiqHwf9/wIz
	LWGwYF2J2HPxVE/vACmPNho/8jsRltjtYFsMAdPnGcxQSv3DOIQRC52IvEMtvZgSpD1iyX8
	nadSKkRgTGaWLcoRzOz6j0TYXEC1+Ab4P7IPnSj8KKp4tdMZ91pso0jRKbPspPvm2M/s3Xh
	OaE0EaOLKuuB29fDv2ZsqksHBh79o+uU2Oq5VZ5moixHWGkkPjJtSGL8zoF9n8ZG8/w+rqp
	28Xo9D0My3si+PIt8wOz1wV0Y0iBljPnQ==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
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

