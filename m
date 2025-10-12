Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13912ECD0E;
	Sun, 12 Oct 2025 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286024; cv=none; b=EzTMQ6dedKS4XCr1IJhVhdb+yT5QmEcMx9f0xMSyxh5QE7FYhrWtH6zuKSsWDass+3avfoAZMEcslwu+h1ekRngPxu5bYayM6wmu7BtwoCVIzHFyPMf2LYUYREjr3hS20wW54v8CuJbNh1RNaGXUUuiGc1kKwfYOLVtYFm5b0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286024; c=relaxed/simple;
	bh=Y9wrdmUvcRzPjtXYSUCxLg+ZW9FFrwdIQIEu9DqTqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiFhdmEJ0yCh8SP7Xz2P2qpKi1JrFAtLPe7M5Uh0IJKeGS6TpnbZTKDnrwiZPfFMtRtbz+Zw/vW8B8FkEMDvO8gGaY08Zl8QF786kBtew+5UboXdR0Jo9Db6eGV22DxIiqGVQ0VopoLa4v1sCkT6W1bMFTlaDTSQ2VArNuI+G6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285916t13d0cb69
X-QQ-Originating-IP: Em0EoLSQGb3CkCTZqafzGL4WAM5S0MFJ7TTgrXKvGHQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4413192177518479682
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
Subject: [PATCH v2 11/22] smb: move smb2_file_network_open_info to common/smb2pdu.h
Date: Mon, 13 Oct 2025 00:17:38 +0800
Message-ID: <FA746CB8D2DF9B66+20251012161749.2994033-12-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: NbH88W0ktn5sFBtCwKfMGfZJU1YEsp2JKZl0geOjwgmDEuB/oKkbbDw8
	nD1BZaKdTbgpHNYLFyvMwddqi0gtosY0GzV3bTRfuMxRuOLK3kwZuFPO8KuY+0Gr4QbCb95
	5x0Utcegr4dzuEyog0Vac30jLfpPk4ercTIE6izU5PFCpgAcdfWYvzT4k9gRMYLjaJRU4PJ
	yEIuY+l2F7YLGFp1KGe4No4uUmWiYz3txf4rSgsudt8aamRGmhSLShEC+93EwN1lVKGV/vE
	dCJ7r/kFfbjTeMEtAPAWFcJJ9AusVqVZMoecyzqAg3Wh2T0bZjSojLhSLm0QruJJsKYGuev
	Mky15mI5dpIvYKWhU5T9MtMh0YIhwDL/N+cGZXL3XxVVpZxwhUBFn4yfDRZ7TKQOqx+8tco
	XhCWmOZHtKVuVkhvruLeLubFioqSxJSu/Ky1ep3ArKMCFTSJkcFEsZcWnSaOqArDJBK8NRs
	hTMZ5RiRhkWXh3GBkO6K2+o2p+22O3s1hMsw1uwCf4IaV9KVuDNodvK0CfiQjasl3W2x8T8
	MpyBYf3jc2LY0OUGH3H0o3HOsqK0mTGaAO9LBbaVssqyXc7srKmE5D0Ey7b+ifRtJwEGZSg
	PHHmWiNQcBUQxetyl4UheyVsq1dmr2J5IrU5ahShZzbI5S3O9JX3R81Zu9wAgibNDrWy6jX
	QTropRBMPGZflMsxbJffiAwVNonLJWlOR1NPVHG2yJsTL1zl+4lxIJ9lg/7kBII7afFWNRN
	K1pZO0Q58fT8zSya2Btn4LKelfzb2Nd2nbEeBGzgoFNxTVCW56ujvXlYLS6dkwNLtw9V8YV
	X4lfoTMUkQiqjNEao82T8sK67E1FTYFJkkz9NZnhBGNVVcJ9dFlxOLHacu/Grdix+lz1mgz
	GO2VuFmdYLc896MQ3LKVThgEfG3xiGR65EybR1vHNuJY8Y88bmZehaKNQk1Dmyf5+incPp8
	pAmxyGykkao8ayeNCoOK0W+ZD49mje3avTW36TAy3Zf7ZLiswYrov93pYaoTrT9aHE+6n+D
	NDBNydOlmUykLrgCT7ngvlMdkK+UT/wg4v0dTxVQ==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
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


