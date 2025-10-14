Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440EE30E0C8;
	Tue, 14 Oct 2025 07:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427022; cv=none; b=a1e9Td2YGbXp5IHUqIM7XolUv3xLxYivSP88ba88uQsiLA+iOUJ12LNbWUS+V4ErdhWJfLjjJfD2mojUHNRulVo8B1EH8ySsT06S+VFZ/kcSj1+jmcKxoIS4DGBs5SN4/EtJB/5wf+ZBU3uxs994oXhKAAoIFx23MNp5RC2aiX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427022; c=relaxed/simple;
	bh=Y9wrdmUvcRzPjtXYSUCxLg+ZW9FFrwdIQIEu9DqTqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfMv+xa86DuEoCEOCPd2/L2mHZz/D4wLn0RXJa0pR50cJ4ZuyZThUeiWdzpGAROwc0fFhcVtbqpWeAljiO40tPgUj+QjHY1e7HGXEygR8JC8sF7Dv2IbXflLYgOIYYMxvaxffu58kvgefdibNNMI+2nWoIF94tCDWQLmjXoBDVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gVHDqUl8; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gVHDqUl8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGmrmS9XSVdUbqKauACcJUtC1VuQQK6aTAG/jSyoSwY=;
	b=gVHDqUl8CFE3xd0Rx3T+4aezHgNPMVrTzoYO1CujhiRddmymLVDqz36OSs1QQCF98WTbDT
	niimpEm9YdRQOS0emyA5v2bIIavF5gSFR2zk8n0AvHMBvGuWnzpvW/gs8nM/ZaJXiZijfy
	H2lP0f+wB4bbP9F40Q+nfvXQKYtdT+8=
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
Subject: [PATCH v3 11/22] smb: move smb2_file_network_open_info to common/smb2pdu.h
Date: Tue, 14 Oct 2025 15:28:45 +0800
Message-ID: <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
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

