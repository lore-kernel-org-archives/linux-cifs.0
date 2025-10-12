Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E642D7813;
	Sun, 12 Oct 2025 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282143; cv=none; b=ivrz8ZxakPaXYcg/FAzUjuk27QZ1sGCslu7vdykjfXBdLhoG/tlq+l8NuywVWB+2Qpxct2OfWzxfTj/Y3C52IYsrtpu1tdK/12r9sHkKZkgo8SmdOt/1O+dbYTlBRDhIhIQ/TbIF/K0fG4kUc+gnneGN2sRsag8IzHU0gaMow+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282143; c=relaxed/simple;
	bh=oBWHsb5ZrCzAgydcykXvb0C1NNG8ufvsu6D1kbmawFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2NcKg/bb5XH4BJ9CGrGe/vJGPqzdAvLmavIYD+w1kwm72HA0DGLSuUKIU0LMUjIoUClgqMOMuAFe0d4hij18pCYhdh+zubghrmF8aBUztk6Q8RlUl3pPK+yjIcPkuYYShFumORwKJp6ppZwV3SQ4A4m0DqM9qAihIOfaVN4O4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281849t26cc5e19
X-QQ-Originating-IP: rxK9gF6jd/5yml2QKbsVIZVMOQRDMWO6LSwISpe3TOY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:48 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7713201603210895249
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
Subject: [PATCH 20/22] smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:13 +0800
Message-ID: <9C9A6E7C8B3D4819+20251012150915.2992220-21-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NRYSeI3Ux+UPdkoGIKGn+J8Iek9V8smFgxDs5CHHmtlRReZCGmmU3YiV
	dZ8MqsDdLRpnlY/blf1Wg9TT7bVy8luS3AGgSW/mo6SmTN3b9YDsP/IgxndtrTAmg0RwQ+D
	eA0lqrb+felMKJCK/YpqQ7KvkEV9RUYyum8VTrA4I3ZCXHEURH1JIJbfAILePUSawamnrNW
	O2z8JzE0zl3pRzT2uAZ+SyyM5HUVKF1IZ1f+krtgOu9X9WQqPJQG1F483MYaXDwlSImUhKy
	O7Otib3xsqpqiM8s3q7quoH9qVTdIJvxfowFG9mSjt9sbYk1jxWM7+YaKL/0uozK1GQTECO
	MFZto3nP94mUEBHGv0qUhCTDtOb0yVeybDiAuHtGfvoaaxNpntw2ZWZ8pvXyiiduzFoBMle
	mN2cRLaV9pRTvzI0PkQyzNIpadz1zsMGV0IvjDgJQoVVfEllOYori6+buMvb+zZPh7O5h+B
	GKGsWaqSpD3ocOkwp9zJiUX6tHttOUNb0lAA4E06mmc3uCmKWK6YMRgX54k3LluwpRgUvsw
	dfoa+wH4aNEcPME/bBFoEAVBj2VqgJhfq62J6kxCQY3MIXO4a9uWg/8RE3uP/4SDryEfsqq
	dmVKs22ZHdgpI+pSRT89KygsND3v689g92hyv4oCxZjRm12iDlYYhRzgH6N8Gd4yhSBPq0O
	oYA38bwylItdVevPIUt5QtDt0146ozkefv2oiExJwF84IXlHbvchOkNgeeJxRR15wN7tkic
	kjMa4JqB8dwdDFDQPvzsVNfurMilO+dpZQn2rgiM/N7adR4uVkuXVLYOWVljl5smS7Uqz04
	LTtHfbMiBZ/ZgRaz2yZ6WexoGMYPVbUwRdBIQ/gX5kKm+nkJkSRoM2XKG30ptavn37qOsE/
	SZ//lN1o0Q0IcmiTGh/IyFID2it7S5C2TwvUdaqNC4ZTq+L2eJJlspBsM7wC8EwD3c+Laav
	IotkEtBbM0yUhqqicQGyt74EPL6mNLv2ScYgMLzZkwrJE3iLUo1DvPmaop/jdKjT4Bmz4sh
	gQGNoOLJa8043MlSc8NLxxP9tuyFAOP+fd07I4+Q==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

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

