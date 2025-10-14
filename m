Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD1C2DAFBD
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 07:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427059; cv=none; b=UQQPGJk1aPkQOzD7r7I3i8iuh7FpCDgwBLjFr6lln87DyfT5l4Sam3W8jxgVKqfcMGXXiUQ4vFlgn10eDPEMwURONNcBr6tl9wtArMN0hq3s8TVavKkmSDuuAIrTGoJuXBmfnzy+608tdWCGCOUTxFFiyn9v4J1dzEH4keBOY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427059; c=relaxed/simple;
	bh=9fhG8rUC2Y67xiXJfY2hEFKpnkRKB2gNIMJ6ia+D7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhEZq8ubL+hvgeNk0DxwHrk6254G1IR7X527fym5CtOqal2WkqLhP6UDlw6CRqR4htUNn2gJGQT9G4Giz438qT8dqt0TrErGuyyolWMDNzeeq4rIzKXU+AMGmXgAIgsg0/DLi7qtNmCfMY6n07o2s6hCECB9rwwMaWpmMu5KMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IUjy3Tmd; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IUjy3Tmd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+tzxzW8Abu3QUewGxNCPl/qIRLjE4zkyUjfV9SqNwY=;
	b=IUjy3Tmd2pN4pYbn6I3qhbA3SgKuY9+wGQC6m5QXqw1/AxJrGsOd65tlVJosZ9JTkTWw+m
	sXD2oNaH0nhftopOJTSPVyNd/RWpZZRQJCOXN2QvRVtcd9EkjQiLQxg2qeMxOY66JDE7yY
	rfujsxJ8V7xcbCuxedKlLSr1UrRhnuQ=
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
Subject: [PATCH v3 19/22] smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
Date: Tue, 14 Oct 2025 15:28:53 +0800
Message-ID: <20251014072856.3004683-9-chenxiaosong.chenxiaosong@linux.dev>
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

