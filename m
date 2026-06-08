Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475D33BB9ED
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927373; cv=none; b=VnjBLeEvkvNXi064Cm6vJ0F7+r60YZpOoOyO22xOliiR9Ke18LrSGA36HIWzV0i0fgd3TdL1P6aW6O9HD1pJOCfjXgbPPq0zMoT3wsYEDK9nrKVCncyHXdG6SgRWdY0ikUbpP5Rx+sE20djNwK2XzP31uzz5fIlv3YgtX7N/goU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927373; c=relaxed/simple;
	bh=3Ein2hXxA+FnlFtB1YVLpdZRoJ1N1WYjriplU8ZLia0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l60VBbAITAq+d67bjF3SqvlxwjMYTYXQOtHYQTyslSClVV/TXTNmONiP7Vpb+JOJTz3oV1ejVlvqNH+/DilKQ0KjBby72/BJMGg6u49V6iUh+DOfWOH2dGTHdqMY6iqG8xpzVSRAeOQBKkg53dZtVdU9GcAxvzBgYFxA02UBWrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=IQ0mvhIA; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="IQ0mvhIA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEzEfPKh9ydClB3Qu0YYvlnSgSPQJlGC5Ze+tH8eOsc=;
	b=IQ0mvhIA+g0mfusLA9YqmFk23zwgIzgDeCLOuy8umeGKiXjEDul5j8rzjNOs/LU/YBeuFz
	FqvTYW7FmDkBoowBg2uOFS9Uf0KmQClD00rjuP2M8XT86JE9f8t2ae2OuLXIC8L2z3ifBi
	EhBgK8BQh3YZU2gGzdWvhSsIAjTpz5NzInRrkhMT0MLO+mBgBtjSCB6qBdq9mJbSlcVg3u
	Q+4fKEuQ+Rg0vPD5EOY58AQzEEjF/xd1ajef5qVAiA4O8MHQiDuTMMo9ewo00m2OwbfLua
	7ZirnkCdHOM09KuSXluHapjcf+PDIfspcGAcIIrsxDYEb/cm42AKC4LKiVfJvA==
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
Subject: [PATCH v3 2/7] smb: move compression definitions into common/fscc.h
Date: Mon,  8 Jun 2026 14:01:23 +0000
Message-ID: <20260608140128.387844-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
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

