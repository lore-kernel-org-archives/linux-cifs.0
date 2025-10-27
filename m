Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B022DEA6E
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549836; cv=none; b=bQUlxZFrn1okrI8/c9B415XQKJuL+wR9NvrN0VhTpaPTBRMOt9ilriIrQn38PNxgY0RXonufrVWDK5b5tQq7QaD/BPLv0NiDcFt+m7JOnnu25VdK9sm35NrPJGjg1DYxCF5IAZ+llIVz2v/LRfW/AmBcyzjHXT6SObXcUPXjY2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549836; c=relaxed/simple;
	bh=uU3RxIWpWa5zTm05EyOvK+mRjmycZNNkdHvlJfXlA68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUd7zmN886eUezmKW2kVxSmqoRdxjQXryAVa38GvKVsVXV0v3GdM7MGeTeVQby54xz3mQnrELCKcFdhiTUdkufeYkYP9mFUuvfAcChGQwrCjzFZyl5e188QlqK81m+LuqG8hJPF064UtbgYpwuxFnUinXVx7iBcKL7/Sc8ArdFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Etnax6FA; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Etnax6FA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+iB1uN011Y16tkrImck31hvIJclu0Z+Uvma3Z4/94g=;
	b=Etnax6FAsZPLGHqXaGKGj3JKLsJvYZlfeYmCq0MLg4aboycsMcCj3KjL6tcJjcRDeh9Jh5
	EctYUPTXWMprir3Fy5CJSxu6xmys4Ke5Vu5o60WEgf5mg2OAi+5oe8HZA26qDrhBwM/Jqg
	iKWZh/g1NHilKr3a/4jHM3SgeceVHsg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 20/24] smb: move smb2_file_network_open_info to common/smb2pdu.h
Date: Mon, 27 Oct 2025 15:22:02 +0800
Message-ID: <20251027072206.3468578-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename smb2_file_ntwrk_info to smb2_file_network_open_info,
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.h | 13 -------------
 fs/smb/common/smb2pdu.h | 14 ++++++++++++++
 fs/smb/server/smb2pdu.c |  6 +++---
 fs/smb/server/smb2pdu.h | 11 -----------
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index a0d2bb18d4cc..6def502f68b7 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -288,19 +288,6 @@ struct smb2_file_reparse_point_info {
 	__le32 Tag;
 } __packed;
 
-struct smb2_file_network_open_info {
-	struct_group_attr(network_open_info, __packed,
-		__le64 CreationTime;
-		__le64 LastAccessTime;
-		__le64 LastWriteTime;
-		__le64 ChangeTime;
-		__le64 AllocationSize;
-		__le64 EndOfFile;
-		__le32 Attributes;
-	);
-	__le32 Reserved;
-} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
-
 /* See MS-FSCC 2.4.21 */
 struct smb2_file_id_information {
 	__le64	VolumeSerialNumber;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c09045a33d34..704096c251b7 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1929,6 +1929,20 @@ struct smb2_lease_ack {
 	__le64 LeaseDuration;
 } __packed;
 
+/* See MS-FSCC 2.4.34 */
+struct smb2_file_network_open_info {
+	struct_group_attr(network_open_info, __packed,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le64 AllocationSize;
+		__le64 EndOfFile;
+		__le32 Attributes;
+	);
+	__le32 Reserved;
+} __packed; /* level 34 Query also similar returned in close rsp and open rsp */
+
 #define OP_BREAK_STRUCT_SIZE_20		24
 #define OP_BREAK_STRUCT_SIZE_21		36
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3e8344fa163b..06da751063b5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5133,7 +5133,7 @@ static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
 static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 				      struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_ntwrk_info *file_info;
+	struct smb2_file_network_open_info *file_info;
 	struct kstat stat;
 	u64 time;
 	int ret;
@@ -5149,7 +5149,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
-	file_info = (struct smb2_file_ntwrk_info *)rsp->Buffer;
+	file_info = (struct smb2_file_network_open_info *)rsp->Buffer;
 
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
@@ -5168,7 +5168,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_ntwrk_info));
+		cpu_to_le32(sizeof(struct smb2_file_network_open_info));
 	return 0;
 }
 
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 6c8102d5cea5..25c20b26315b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -263,17 +263,6 @@ struct smb2_file_stream_info {
 	char   StreamName[];
 } __packed;
 
-struct smb2_file_ntwrk_info {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;
-	__le64 EndOfFile;
-	__le32 Attributes;
-	__le32 Reserved;
-} __packed;
-
 struct smb2_file_standard_info {
 	__le64 AllocationSize;
 	__le64 EndOfFile;
-- 
2.43.0

