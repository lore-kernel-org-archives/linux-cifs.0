Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296122EDD60;
	Sun, 12 Oct 2025 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286098; cv=none; b=N3nro91RZn7QlBVaBIidSbif76c7EwjM6+60aNn+mPr/fKTirGhbpGf0irtXtx2mWeDrgR2IAZHVCn4H+4guj7XIRgD5Kmgdlxb0IcIBlv9eNZt5PWTZ7+YAQ0SghCv66KQMOKsakYYjk+StaUBScC/irX2iZhXrFNdLZ1WxMGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286098; c=relaxed/simple;
	bh=9fhG8rUC2Y67xiXJfY2hEFKpnkRKB2gNIMJ6ia+D7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D08JErVdrCD9NLsLvUBkP56OubEI4guYnMbrp+LXRX0m1L6jy9u45KEenj3IEGp7OvD1YzWTyX5ggnfbhvfQIIOxPOVkFkvGIiZB9X0DQ0GOK20/4A/tbqR4315YGyBZRbit9N6io8K6sond6Zs7/a9QFN8oU56q0Bal24YAJB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285933tc610b134
X-QQ-Originating-IP: /4cfSS4ktiKQgYTYIE4+JSRQg4hqFdWkgjDrZ20eysY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:52 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12836935226787148282
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
Subject: [PATCH v2 19/22] smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:46 +0800
Message-ID: <6AB5D8395BDE540A+20251012161749.2994033-20-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: ODape9HLJUgbGBwkxf/wMfLAht7vsmqlMO9wDWWdYV+r79LXn3ZiSbT1
	WBANJi1+ic0cgf0uvGQjr66R+zbTRtH3LaydKSFGJwKInV4yg7oel20tCdLu9J7/FXmAT3h
	ARBba6EnBszEuci9PZYzPxsqIqDx0m18hovtOz8nI2vh3kHNfQGHZnpxKEAYhoVahcVrMrL
	p8wDOSp6TpOIHrAVvT9AL5eQXdGsVYISmzqueuyNS88RqCqmiebXbwHU4/Js5Cwos7YRwQa
	TnId+DOieVuuEIARs55DuIFXWxgv5uHLyDWxJP33eYcNoo6lx4XfFjd3vXGSgf4cGqJ/W3u
	7T/SIMjIwKoSS4hmDLMdduze/BA/cn5pXVQz3myGohWjyCxr4Ny1zpHuicCWECp5obfmeWm
	6NyCfm5Oe8NkyXg21zcGYrnEcxzEd/Mu5PsAJSlk4NjPoy4k5i+iZv1/AluVl96R4j4EPD/
	8EE2NVUinowoOL2d6sMe1wDxqXndwrZsNlQonWvizzTVgzNcyBd2sX8OFFB3LLGFqx1DI4u
	WCl1vIG5bG1OM/Aww9dag+kA2oA0VQ4XG6mO1uzSblzqJXbjqJbB30dNY+HZ8+7GNQ5IJCJ
	vTbCkchj6TvpuJvGBRiPyKTazt57mMoif3vew7DEe1dWhcMfNlytlC+idW4Erq2J8aa5Ksd
	r3+nZ3qaAMSRen7YjQ8uy9MRSUuA5qKHBu/EmpHQEL7BBZu0qlURyjwKQjADUJy3d4cczZg
	/t9IAEtEUkgaTAxWpCmG5DC/5355f0481BZW7aBDkoI1aaooc20BL4svbqsyrPmILglhPWf
	TPyPf3cfD/zjBmyOtt7mVPO1vTTIMK53i7NrrhMKD8jX8s/Cg4Xhx1vjuY/g130tnYEkTLZ
	5slHnt/iIzuxPNUHTftpcydM+T6kMr/J0RDib8KPjGtdOwiKu4ap5X0Kv2c6CzSkXwPpOwa
	XGBVHTGbfWXuUwop6ivr5IQY+vX8mACCPCMr+vlfKREMFhwdDm/BXuwolaKne7BM++uGInP
	PPeFBIi0E4mYpaDOeuQuz8Z5+5O1jOxftbD6JozbzNvQGkFiwZfnIgOSIZTXCaQxXCzQDP5
	AHw7glnJS4uNUAIvgUvx4MccGyF88L0YQ==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
X-QQ-RECHKSPAM: 0

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

