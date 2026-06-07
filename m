Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90722D7A1
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 02:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780799289; cv=none; b=pviwbBQda3NKy9SndPEL9dKF1ZOnxKtKXDWj3zdA4fFy5sf37MrMcRwZqTQTMA4JdKrKtRQSlSSx1fdaO5X2uWQQPSIvTb/nMIsdxX62L+qR6xLeBddQp30wS4zDHXUEpK8wNWpfmfkT/48Dl4Ras6zrSDNEe2/l8zx7rZNr1cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780799289; c=relaxed/simple;
	bh=3Ein2hXxA+FnlFtB1YVLpdZRoJ1N1WYjriplU8ZLia0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEspmkWD7pudaYrWVLadjeEKAUhDxGR5FGe1VrSdKMLkvkx4U5GLe1+77AfAX26BrZ3odu7qI1KXaTtKCUeakg40THlNXMlkxTQtc2eRfHNqY6v9pGbYAZNSVHRX6KjuAbPk3t+wVqNVKVfnVYlfd+dkAL8O3ag2pGsscjeehaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mw23vl/Z; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mw23vl/Z"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780799284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEzEfPKh9ydClB3Qu0YYvlnSgSPQJlGC5Ze+tH8eOsc=;
	b=mw23vl/ZFAXXCSAQMwWnf0KIq+JqEBUtZcn7Ow/UijjzBozUC2cMfHGO3+nH1hZrGPHtjc
	s21MPUlOy1T+NWcIyE8RQviBoVn1hDgXAwq7IzWepYnqfI78i/bSKSDjNdoj/LpXHOAJpp
	elkVSabDGSIIRk2LQdL0+ZPgQV6uDike6y3ABv4hYX3FKJH0seSNwLcK9Rw3C8oOzMKSFv
	WH4tDTj320vy2n1ZamknB8HYtk7jynhQ9UoWiz6LYMhfaS83aVD23UcBpxD7O7qLNyrBFm
	3sc4fbwWCDrzwiyKq1pbNjFqChAUZhSXBlKtUtYpnd5UI2E5cf40YgMaXfgyBQ==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 1/5] smb: move compression definitions into common/fscc.h
Date: Sun,  7 Jun 2026 02:27:01 +0000
Message-ID: <20260607022705.317863-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260607022705.317863-1-chenxiaosong@chenxiaosong.com>
References: <20260607022705.317863-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These definitions will also be used by ksmbd, move them into
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1pdu.h |  5 -----
 fs/smb/client/smb2pdu.h |  4 ----
 fs/smb/common/fscc.h    | 18 ++++++++++++++++++
 fs/smb/server/smb2pdu.h |  3 ---
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb1pdu.h b/fs/smb/client/smb1pdu.h
index 7584e94d9b2b..0870949144ab 100644
--- a/fs/smb/client/smb1pdu.h
+++ b/fs/smb/client/smb1pdu.h
@@ -1211,11 +1211,6 @@ typedef struct smb_com_transaction_compr_ioctl_req {
 	__le16 compression_state;  /* See below for valid flags */
 } __packed TRANSACT_COMPR_IOCTL_REQ;
 
-/* compression state flags */
-#define COMPRESSION_FORMAT_NONE		0x0000
-#define COMPRESSION_FORMAT_DEFAULT	0x0001
-#define COMPRESSION_FORMAT_LZNT1	0x0002
-
 typedef struct smb_com_transaction_ioctl_rsp {
 	struct smb_hdr hdr;	/* wct = 19 */
 	__u8 Reserved[3];
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 30d70097fe2f..b9bf2fa989d5 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -195,10 +195,6 @@ struct network_resiliency_req {
 
 #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not to file */
 
-struct compress_ioctl {
-	__le16 CompressionState; /* See cifspdu.h for possible flag values */
-} __packed;
-
 /*
  * Maximum number of iovs we need for an ioctl request.
  * [0] : struct smb2_ioctl_req
diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index bc3012cc295d..7e68de834e8b 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -100,6 +100,24 @@ struct duplicate_extents_to_file_ex {
 	__le32 Reserved;
 } __packed;
 
+/*
+ * compression state flags
+ * See MS-FSCC 2.3.18
+ *     MS-FSCC 2.3.67
+ *     MS-FSCC 2.4.9
+ */
+#define COMPRESSION_FORMAT_NONE		0x0000
+#define COMPRESSION_FORMAT_DEFAULT	0x0001
+#define COMPRESSION_FORMAT_LZNT1	0x0002
+
+/*
+ * See MS-FSCC 2.3.18
+ *     MS-FSCC 2.3.67
+ */
+struct compress_ioctl {
+	__le16 CompressionState;
+} __packed;
+
 /* See MS-FSCC 2.3.20 */
 struct fsctl_get_integrity_information_rsp {
 	__le16	ChecksumAlgorithm;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index e7cf573e59f0..3bed676bb5ad 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -230,9 +230,6 @@ struct smb2_file_mode_info {
 	__le32 Mode;
 } __packed;
 
-#define COMPRESSION_FORMAT_NONE 0x0000
-#define COMPRESSION_FORMAT_LZNT1 0x0002
-
 struct smb2_file_comp_info {
 	__le64 CompressedFileSize;
 	__le16 CompressionFormat;
-- 
2.54.0

