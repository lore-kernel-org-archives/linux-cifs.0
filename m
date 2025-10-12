Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706042F0698;
	Sun, 12 Oct 2025 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282738; cv=none; b=B0myktWW0LYTpFZfiSKAlg/orrflno+YXfx+d6cg3HKYiFMBUEvYjk5/FWtE7LfskxpcXQSRmRYTWR4HTpwfE8pRFzDBZPx6J1A8mv35u1dXgOT+25+xfiN4dL/cUdhh+5vWgNc47vTSu3jcnyAnpOLYJc9w1bj2yXjH2P24HTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282738; c=relaxed/simple;
	bh=9fhG8rUC2Y67xiXJfY2hEFKpnkRKB2gNIMJ6ia+D7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1ntaMObnVZAa3N0A9NVvWkDUnvc19erCtlbymU2ocj7A/0WTN8Lbgld09SqUcgDSLvUtB+COOJ4nC4z+rPciZnMZ4uw/a8rOZGSkDMGWzCdRPZjel9eLJFfHQOqkg77fFtozB7SW8uQPqSni+YXqRrCpM/5I6wamEuB1xZHN4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282624t95909583
X-QQ-Originating-IP: UndUBmIpiL69zzPlRiaASNtuAwBQhQbKCRUWsr93fDQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13824566248690761441
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
Subject: [PATCH RESEND 19/22] smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:44 +0800
Message-ID: <9954C868A043E17A+20251012152247.2992573-20-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N1J2wcMArduWMf6o7EmVDmgJDJ4jYm2UdwjNfqGoFs6WHvEZ/Mv5m268
	UoJVKCs9lY0yPxov9AUdg0aYAojmAtVMWzbdykgfwb08UDOJDnnLsK6t99BA4IsJWzuO090
	FD6h4jtWKr58ExOIFNPbJghGdQjgrJDXHC/OQ6Fr2Ez13jRAUp+GvQGUpCuSOZzqFG/9Hiu
	eAPPJfFRS7GHZ9LJuR4R0e7QZyHW/Q4i0yl0udYdlXiFwayJ/xaLcu/F8bpmDh2qe3zBp5s
	t1mox7QZfuU1t+R5r0MmzauJK3mCPtALc1FWewtSKeAmX9NhVgVbAGoS5wCi9eJI/1YGXJT
	mwPwO8Ba0aUAaW6Ryt1i5TO/cPtCLP71nCJH8syy+lnqzw9mJHS57MW4WczEyq0E9+tUMRO
	XYXirdcTV58IepKLohiGF00cVEuXTnWA6lWzSyW1+rUtpmuny8fKg9yYRgCtd7XMr+PA/UL
	sUqxE8RGeZKfcLVa/oNJ+vTxGC369n6Iw1G7m7l0AXiqEbyMOtVbrqhkTITjRzKx19QI0P9
	HQgkI0gkuwRwRAAG4gn4SrYRcqt+OMT8FbSHDvs/D8HAJ5JdVf1o0O/pUI/xJRm4ApQPBli
	JjNyJ7ZmirAXrNhIilyV66cWDOj9yRyc4w0KJ13eUkQor938MCqbvYM8DVzZpUCtCDUjP7R
	P2C8iHqnzBNLKHVseUFFP1zJsfN5cDCCn8L/9OQ7+C2ACS0/jOjSCvIxY90vAxzygVU5Mbj
	wEUctuFtjN7fNqxbD4chd2ui1tflIHBWvyF68jjd83skBqdLw6xKuKqWcN6MB8n0x4zRWrW
	H1z9rIVt1llpE5sJj3m07365O5dG0rZJDQn1xX36u8X80mZwmaQJgSGHwEN3pnmuvV/bD72
	7mbhnsCiCCYFGlnG1jeuizRnWPaVWRMHI8wS2SMXzFEPvm+CgJGEgC2nCsSTTrcm2bxQxSG
	PO+FH0CK2YSo84VJk7xYtItKpMhOQfYgfHxrKYK5aJJcAMNKcMuL9K90g1jUBPcHHYnKDsO
	jbllgLtZZTOWcCoXQIZz0mkPrnnjmW2IvCnBJN23xflV3uL6DZ0vpg5BC+JyNORGERhWKhV
	JrVNVupy+u128mKDp1WDfTEYec3h6w5Hc4qkKZ5aQQHIn3A/sBTVqIl/RQNiQxZjQ==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct file_full_directory_info" to "FILE_FULL_DIRECTORY_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 15 ---------------
 fs/smb/common/cifspdu.h    | 16 ++++++++++++++++
 fs/smb/server/smb2pdu.c    | 14 +++++++-------
 fs/smb/server/smb_common.h | 15 ---------------
 4 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 8031e24234a9..f89abcb88dee 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2150,21 +2150,6 @@ typedef struct {
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
-	__le32 EaSize; /* length of the xattrs */
-	char FileName[];
-} __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
-
 typedef struct {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 82d57ba275ee..d7c9f17ed220 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -385,4 +385,20 @@ typedef struct {
 	char FileName[];
 } __attribute__((packed)) FILE_DIRECTORY_INFO;   /* level 0x101 FF resp data */
 
+/* See MS-CIFS 2.2.8.1.5 */
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
+	char FileName[];
+} __attribute__((packed)) FILE_FULL_DIRECTORY_INFO; /* level 0x102 rsp data */
+
 #endif /* _COMMON_CIFSPDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 679318afdce3..6121060d84ae 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3796,7 +3796,7 @@ static int readdir_info_level_struct_sz(int info_level)
 {
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
-		return sizeof(struct file_full_directory_info);
+		return sizeof(FILE_FULL_DIRECTORY_INFO);
 	case FILE_BOTH_DIRECTORY_INFORMATION:
 		return sizeof(struct file_both_directory_info);
 	case FILE_DIRECTORY_INFORMATION:
@@ -3819,9 +3819,9 @@ static int dentry_name(struct ksmbd_dir_info *d_info, int info_level)
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->rptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->rptr;
 		d_info->rptr += le32_to_cpu(ffdinfo->NextEntryOffset);
 		d_info->name = ffdinfo->FileName;
 		d_info->name_len = le32_to_cpu(ffdinfo->FileNameLength);
@@ -3944,9 +3944,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)kstat;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)kstat;
 		ffdinfo->FileNameLength = cpu_to_le32(conv_len);
 		ffdinfo->EaSize =
 			smb2_get_reparse_tag_special_file(ksmbd_kstat->kstat->mode);
@@ -4206,9 +4206,9 @@ static int reserve_populate_dentry(struct ksmbd_dir_info *d_info,
 	switch (info_level) {
 	case FILE_FULL_DIRECTORY_INFORMATION:
 	{
-		struct file_full_directory_info *ffdinfo;
+		FILE_FULL_DIRECTORY_INFO *ffdinfo;
 
-		ffdinfo = (struct file_full_directory_info *)d_info->wptr;
+		ffdinfo = (FILE_FULL_DIRECTORY_INFO *)d_info->wptr;
 		memcpy(ffdinfo->FileName, d_info->name, d_info->name_len);
 		ffdinfo->FileName[d_info->name_len] = 0x00;
 		ffdinfo->FileNameLength = cpu_to_le32(d_info->name_len);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index ea1c64f84ff1..e325c2e89aa5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -87,21 +87,6 @@ struct file_names_info {
 	char FileName[];
 } __packed;   /* level 0xc FF resp data */
 
-struct file_full_directory_info {
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
-	__le32 EaSize;
-	char FileName[];
-} __packed; /* level 0x102 FF resp */
-
 struct file_both_directory_info {
 	__le32 NextEntryOffset;
 	__u32 FileIndex;
-- 
2.43.0

