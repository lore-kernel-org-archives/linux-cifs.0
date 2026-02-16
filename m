Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB122475CB
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771230115; cv=none; b=IroW+pgYjm0JRSfUZkG82V/ht6qfhYPg5cX9naQzYRdlFMuvlN2ySUfDR6e7T37mH6XkoTo0/ChUjaKHPLoMsXSd9CB7/LNqeLxEZcGR/YqUaWgsTNsbhyWuRAzYABvJx0gcvYSbYWXQ+T1XPsI4DMEeQmiAcXzHQRzYWuAUAaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771230115; c=relaxed/simple;
	bh=kW0NZ3VURiZI5kFVaINntqWPzReH7mvPcxSDjdGbeKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwZ6Y6X3KSbYL3l/sKLr2vssoM6iEaZwGU4pAyIetiW2faytEnBtPpy8u5IFIvy4mo3wCOW06ruPBDKzMNHdiirLLgJuqh0YoiKv4JTtCeBz6tJwkoFxfnyZ42UnLN7AFZgPtqbnLq6aB2wMZhjRMCI360ZJQzvhUxG1Gz/JVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xeya6LSC; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xeya6LSC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771230112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GG5ya13+Zw7utW/8fmayeQSUgRPluhO4EyRv1y2z15k=;
	b=xeya6LSCGaelGXP9Rt29QCkKRk3SZsnPgpE4Ke4b3gI56yIU4e63e36rAz/kcMmyUtncdE
	dJKd4Xqr7c8h8F+Y8tVOVY2cUqyCfU8aygKQOJMcQGMYuT/ArMhKAbbvsjj9EKhJr7FHCK
	ldXWPoZVok2lg+FxtA/xsvRyVsdtWkE=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong.chenxiaosong@linux.dev
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: [PATCH v3 3/5] smb: move file_basic_info into common/fscc.h
Date: Mon, 16 Feb 2026 08:20:16 +0000
Message-ID: <20260216082018.156695-4-zhang.guodong@linux.dev>
In-Reply-To: <20260216082018.156695-1-zhang.guodong@linux.dev>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

This struct definition is specified in MS-FSCC, so move them into fscc.h.

Modify the following places:

  - smb2_file_basic_info -> file_basic_info
  - Pad1 -> Pad

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1pdu.h |  9 ---------
 fs/smb/common/fscc.h    | 10 ++++++++++
 fs/smb/server/smb2pdu.c | 14 +++++++-------
 fs/smb/server/smb2pdu.h |  9 ---------
 4 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smb1pdu.h b/fs/smb/client/smb1pdu.h
index 97f7e1244a8b..7584e94d9b2b 100644
--- a/fs/smb/client/smb1pdu.h
+++ b/fs/smb/client/smb1pdu.h
@@ -2061,15 +2061,6 @@ typedef struct {
 	__le32 EASize;
 } __packed FILE_INFO_STANDARD;  /* level 1 SetPath/FileInfo */
 
-typedef struct {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le32 Attributes;
-	__u32 Pad;
-} __packed FILE_BASIC_INFO;	/* size info, level 0x101 */
-
 struct file_allocation_info {
 	__le64 AllocationSize; /* Note old Samba srvr rounds this up too much */
 } __packed; /* size used on disk, for level 0x103 for set, 0x105 for query */
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index b209d818e95e..716864b173fd 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -216,6 +216,16 @@ struct smb2_file_all_info { /* data block encoding of response to level 18 */
 	};
 } __packed; /* level 18 Query */
 
+/* See MS-FSCC 2.4.7 */
+typedef struct file_basic_info { /* data block encoding of response to level 18 */
+	__le64 CreationTime;
+	__le64 LastAccessTime;
+	__le64 LastWriteTime;
+	__le64 ChangeTime;
+	__le32 Attributes;
+	__u32  Pad;
+} __packed FILE_BASIC_INFO;	/* size info, level 0x101 */
+
 /* See MS-FSCC 2.4.8 */
 typedef struct {
 	__le32 NextEntryOffset;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 966a499d2eb8..eb2129ab7156 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4838,7 +4838,7 @@ static void get_file_access_info(struct smb2_query_info_rsp *rsp,
 static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 			       struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_basic_info *basic_info;
+	struct file_basic_info *basic_info;
 	struct kstat stat;
 	u64 time;
 	int ret;
@@ -4854,7 +4854,7 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
-	basic_info = (struct smb2_file_basic_info *)rsp->Buffer;
+	basic_info = (struct file_basic_info *)rsp->Buffer;
 	basic_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
 	basic_info->LastAccessTime = cpu_to_le64(time);
@@ -4863,9 +4863,9 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	time = ksmbd_UnixTimeToNT(stat.ctime);
 	basic_info->ChangeTime = cpu_to_le64(time);
 	basic_info->Attributes = fp->f_ci->m_fattr;
-	basic_info->Pad1 = 0;
+	basic_info->Pad = 0;
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_basic_info));
+		cpu_to_le32(sizeof(struct file_basic_info));
 	return 0;
 }
 
@@ -6136,7 +6136,7 @@ static int smb2_create_link(struct ksmbd_work *work,
 }
 
 static int set_file_basic_info(struct ksmbd_file *fp,
-			       struct smb2_file_basic_info *file_info,
+			       struct file_basic_info *file_info,
 			       struct ksmbd_share_config *share)
 {
 	struct iattr attrs;
@@ -6418,10 +6418,10 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	switch (req->FileInfoClass) {
 	case FILE_BASIC_INFORMATION:
 	{
-		if (buf_len < sizeof(struct smb2_file_basic_info))
+		if (buf_len < sizeof(struct file_basic_info))
 			return -EMSGSIZE;
 
-		return set_file_basic_info(fp, (struct smb2_file_basic_info *)buffer, share);
+		return set_file_basic_info(fp, (struct file_basic_info *)buffer, share);
 	}
 	case FILE_ALLOCATION_INFORMATION:
 	{
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 257c6d26df26..9b3c4c9acb11 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -183,15 +183,6 @@ struct smb2_file_alignment_info {
 	__le32 AlignmentRequirement;
 } __packed;
 
-struct smb2_file_basic_info { /* data block encoding of response to level 18 */
-	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le32 Attributes;
-	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
-} __packed;
-
 struct smb2_file_alt_name_info {
 	__le32 FileNameLength;
 	char FileName[];
-- 
2.52.0

