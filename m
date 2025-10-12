Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779252D47E6;
	Sun, 12 Oct 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282044; cv=none; b=mzGazwgWjbtt31BUKp/H8XvSnflm09E+XuCZYxts0i3SSwLKDYCos4xkrSWOwc8tQMLNYi2NM/1+wiOJvR8CndsimqXJz40YavL9sT/QDHlyJHbPnzkSkyQQEjvmTbx5onPZQ+gLfGIHrqkWoOtmqIVuTog5mmHVEqYzr7z5q/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282044; c=relaxed/simple;
	bh=Y9wrdmUvcRzPjtXYSUCxLg+ZW9FFrwdIQIEu9DqTqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSxRANZOduNb/MHEG9zTlVbkAZzMIi+3Fe64Xh4uesmaYy4gbnjMexHFaZKKKgT/gb2m9fIR9TvV0lngBX1pTPntlgSxYcXWnSAq7x1TV1yZ5y15xLys5knl2e9PBHiDi7O0y30ctQpxkvNbHgk0N4FC/AWwdRCmG9JPtdMYUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281829ta67c3fd2
X-QQ-Originating-IP: 4ssMrAPLNa9GnsQoQi7xsUtBO3ZGgIsnMaW0lc/3swA=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 6945570235626380267
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
Subject: [PATCH 11/22] smb: move smb2_file_network_open_info to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:09:04 +0800
Message-ID: <CFD2D6B95991D33F+20251012150915.2992220-12-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: N8nNIaELF1sdrz6enEXuGFeHk2mXBJv4C3dk2ldX8nIsl0+XNwgTuTEf
	nKXoqGQvC8/ERr2pVVD8xxBNCV60MN/heZc/lVTX7eSHYzUcfXGl9Q8oBXaw/nd+XcibZA7
	3yRo4TCiZ8Xe2fJFhgPPJP97xv0pGguSqLua6YbZlIRgjKNdhEoxo0BAlje6Qed6+bK4PYX
	b1nI4Oa5palXEWpciOMSzJdZrPRS+8C8K3aTLKeZAjZAuQTsj3mQ6EzaqDTwBenLNXlAmaS
	yAMnqTFDe3DhDwx5lyQba1qmbsTWz02wfoeZQO6ptKBaJMeS75U+hH8ohX5j/2oGFV0B5pU
	L2zu9z0GLs07crRy1F9vzi4pxIqpwzVL0AkuyW5HuRTx9CHcwSnwf5FQwU9hq4iRcf5ypYn
	Bga9IqbjbWvTS74uSXLUYQMLRW808hpV7nIPgmuufTK1B8co9izDqfR0ddv8mkwyFxJnB4g
	t/tpcaLmjR5k1U7I5szVDUHK6PUdQi9e/nZrV2ouOTyNNibSTXMpekltVrUY0yroP0SngPb
	CP1GZjx+59Fc8mkd3MQFtH67kgU55G0bPsjwSG/dfWS/boHq1kGx0khwxG6GXR0xAAV8j4R
	q3NFiWGkQcRO8eHm8fZ4En4JqP1JQsVATYziOxt5IupvDIGoM9xyODh3NclR4NLOH4Gsvpp
	d0b4G7niB5AN/lQvX9uiCDJM9ipsWm48y/mWIW3TXswPmTDksBk/C1d47KpYnSUYKLCogKX
	8qBFpkEZ2w6ryBhmeSXHRNuQ9juASp7vFjz1zO79OoOxjaDe4WeyuT1ftLzDe7aNqCEF8ao
	WZbmnfdW6gUeXIoSrnU9sCOhIZq8orLFPqql7EN9czlDA6uOqwD6qCqYs9Y9LGiZ9XZUR85
	NMeVNLmzb/wZRDOx5uRrmDVKY8l/xCrSot2Sa8ZECR/XsfiSUmeJPBn37eDgfzoREzyHfgE
	d6/7kukBLweaPk8aQ8PcYZSFY4+QkH1wzmxaK8D3nyHN/1bnjKJy3HE8MPFl0o2Oap+1Dht
	YVpBAN1rbhJNKmZYrGUd+7bA2zs+I=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

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
index 77dceca20240..70976a212128 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -262,19 +262,6 @@ struct smb2_file_reparse_point_info {
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
index 15932ee05c98..f5c8c72b8959 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1971,6 +1971,20 @@ struct smb2_lease_ack {
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
index 200bce13b467..a46d4ddade9e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5126,7 +5126,7 @@ static int get_file_internal_info(struct smb2_query_info_rsp *rsp,
 static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 				      struct ksmbd_file *fp, void *rsp_org)
 {
-	struct smb2_file_ntwrk_info *file_info;
+	struct smb2_file_network_open_info *file_info;
 	struct kstat stat;
 	u64 time;
 	int ret;
@@ -5142,7 +5142,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	if (ret)
 		return ret;
 
-	file_info = (struct smb2_file_ntwrk_info *)rsp->Buffer;
+	file_info = (struct smb2_file_network_open_info *)rsp->Buffer;
 
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
 	time = ksmbd_UnixTimeToNT(stat.atime);
@@ -5161,7 +5161,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb2_file_ntwrk_info));
+		cpu_to_le32(sizeof(struct smb2_file_network_open_info));
 	return 0;
 }
 
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 3d000c5d964b..8c8e775b601e 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -245,17 +245,6 @@ struct smb2_file_stream_info {
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


