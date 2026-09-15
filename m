Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0447E32AAA3
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454844; cv=none; b=Okv/vokuRyaT2H3Td4OLUBIa/FUrvcRMcFwQEdKVkIymzmbxXuuHZLR20Sd13GdLSqVAwRBwEVU7BIK7Qjgc2eseGZYt66voyqmWy3w+0bHYPpTd/F9YRoWU84DiWbWBHKKdrJfqu0jUhCew4Y3V2pcixRb5/O6lxc3sdlan+9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454844; c=relaxed/simple;
	bh=gU+YQWX+DwNqqzmSCVcXQ1CJTae+qZjl9phQ3iTk/1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuEGPf+zhU2GKbB5whsJSIqUuAirTtq43/PqAEHk+oSRoJ76VOxPdEmSTPDJji2psKyyRfEC6NGyD1jYenLJISqTK6oEGDbEsnK2YvN74G9er8ywoaBRel7m8wSdQn7xjkiN0RozcLkjKjblNrY6qnyUNP4NDuC5enJLpDWGGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NUh2OOtR; arc=none smtp.client-ip=91.218.175.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NUh2OOtR"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gU+YQWX+DwNqqzmSCVcXQ1CJTae+qZjl9phQ3iTk/1c=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454839; v=1; x=1790059639;
 b=NUh2OOtRYilQMNwhfOijH97l/8gnJ8u+jt/lOE+Af1uet39imNxrptgTD2uIxM/C2tdh6lXs
 ZY4m05rgPsd7GXRuESts91INlWtDYPqazsdYmPxMxgJBIdgB54WfVcgXnHAqFWw1xNCWou1shhH
 5l6qn9piz7NYe1WcGkDfcQNb7e0q1lIEi5CBKVxxmbNzsDlCMlwOLsNltMho72QdVUSRl2IIbOB
 TW6Yt4YPWH/uzjlcbcvUdQK+DfePx5EAyNTcKTmyiBC3REipaLv0syydiXeowJgVp0ZYQaZ3Q6Z
 0ZKiYznMfT5rT0igeg7YYbqUZUy3BkI3fxHZKY1czg7hw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1546f172be0cf62d;
	Tue, 15 Sep 2026 06:47:19 +0000
X-Mizu-Trace-ID: 1546f172be0cf62d
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 3/3] smb/server: rename smb2_file_alt_name_info to smb2_file_name_info
Date: Tue, 15 Sep 2026 06:46:57 +0000
Message-ID: <20260915064657.110687-4-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

FileAlternateNameInformation and FileNormalizedNameInformation
use the same structure.

Link: https://lore.kernel.org/linux-cifs/8360c969-33f5-4d96-a44d-c6fcb7a8a41f@chenxiaosong.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 12 ++++++------
 fs/smb/server/smb2pdu.h |  6 ++----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9d5f354417b8..15e2801a8ce1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6779,12 +6779,12 @@ static void get_file_alternate_info(struct ksmbd_work *work,
 				    void *rsp_org)
 {
 	struct ksmbd_conn *conn = work->conn;
-	struct smb2_file_alt_name_info *file_info;
+	struct smb2_file_name_info *file_info;
 	struct dentry *dentry = fp->filp->f_path.dentry;
 	int conv_len;
 
 	spin_lock(&dentry->d_lock);
-	file_info = (struct smb2_file_alt_name_info *)rsp->Buffer;
+	file_info = (struct smb2_file_name_info *)rsp->Buffer;
 	conv_len = ksmbd_extract_shortname(conn,
 					   dentry->d_name.name,
 					   file_info->FileName);
@@ -6831,7 +6831,7 @@ static int get_file_normalized_name_info(struct ksmbd_work *work,
 					 struct smb2_query_info_rsp *rsp,
 					 struct ksmbd_file *fp)
 {
-	struct smb2_file_alt_name_info *file_info;
+	struct smb2_file_name_info *file_info;
 	char *filename, *normalized, *stream_name;
 	int buf_free_len, conv_len, filename_len;
 
@@ -6865,7 +6865,7 @@ static int get_file_normalized_name_info(struct ksmbd_work *work,
 		return -EINVAL;
 	}
 
-	file_info = (struct smb2_file_alt_name_info *)rsp->Buffer;
+	file_info = (struct smb2_file_name_info *)rsp->Buffer;
 	conv_len = smbConvertToUTF16((__le16 *)file_info->FileName,
 				     normalized, filename_len,
 				     work->conn->local_nls, 0);
@@ -7333,10 +7333,10 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			fixed_len = FILE_ALL_INFORMATION_SIZE;
 			break;
 		case FILE_ALTERNATE_NAME_INFORMATION:
-			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
+			fixed_len = FILE_NAME_INFORMATION_SIZE;
 			break;
 		case FILE_NORMALIZED_NAME_INFORMATION:
-			fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
+			fixed_len = FILE_NAME_INFORMATION_SIZE;
 			req_output_len = round_down(req_output_len, 2);
 			break;
 		case FILE_STREAM_INFORMATION:
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index ca8e27f7b712..95c89087553b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -199,7 +199,7 @@ struct file_sparse {
 #define FILE_INTERNAL_INFORMATION_SIZE        8
 #define FILE_EA_INFORMATION_SIZE              4
 #define FILE_ACCESS_INFORMATION_SIZE          4
-#define FILE_NAME_INFORMATION_SIZE            9
+#define FILE_NAME_INFORMATION_SIZE            8
 #define FILE_RENAME_INFORMATION_SIZE          10
 #define FILE_LINK_INFORMATION_SIZE            11
 #define FILE_NAMES_INFORMATION_SIZE           12
@@ -211,8 +211,6 @@ struct file_sparse {
 #define FILE_ALL_INFORMATION_SIZE             104
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
-#define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
-#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24
@@ -259,7 +257,7 @@ struct smb2_file_alignment_info {
 	__le32 AlignmentRequirement;
 } __packed;
 
-struct smb2_file_alt_name_info {
+struct smb2_file_name_info {
 	__le32 FileNameLength;
 	char FileName[];
 } __packed;
-- 
2.55.0

