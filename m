Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B5B25F99B
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068763; cv=none; b=ESjaMNlgqIsndDmT6ODLfR0Ci/YI7paX7u4HfWuZGudr1T9Bh/ZbjGHu/G7Yu5GjuEjuVJe3FGUVzCBIv0dPYGyDs2yPULKrGju9AeFCLVHBf0+d27Rgv6X2LOoXSyZ/u5Sz8ofVJ354MpLq3w+LU2/3TgyzzKABZym7c4Ub0Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068763; c=relaxed/simple;
	bh=VhiuHJ+4Z1zt+EjxXBhb1ne7K2AcpYll96v0f6qnnHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7OyX86rhXf4bwHHfoWB4bNgWnz5uBE7jNRIYXt27XbHoN6znXcB36t/PkXDTaeeauTJ+DGZ27pUzC6ZF6/1ygYuTcWTbMiDFQiPUj2b107izZuBcLKj+a8oD9c/iTMjaCuZcsFqdoca7OOaZjnTji/qrCAmu5jB8a2pRNKRsqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EoXWni7v; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EoXWni7v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZflUcJpsdunBm7vBOEpuEG3ld8wGTw8JDDmFYKRo34U=;
	b=EoXWni7vwjyko7CkPqvj1/cVoH+Lt/FNInf8Q7qgFdjbt8VZjEPifobWrPrGe4emMQO9uy
	QhmP7X8n0lT3lp1+vQ8M4V2Qh7MgWOkXxySyx/6JIPzEUWRI185dcXRx3W3CwMqE9Cb2n4
	1UoUXR5ypCs1wmcrOjZf4Jxv7G7vE2g=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 08/14] smb: move SMB_NEGOTIATE_REQ to common/smb2pdu.h
Date: Sun,  2 Nov 2025 15:30:53 +0800
Message-ID: <20251102073059.3681026-9-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Modify the following places:

  - negotiate_req -> smb_negotiate_req
  - NEGOTIATE_REQ -> SMB_NEGOTIATE_REQ
  - negotiate_rsp -> smb_negotiate_rsp
  - NEGOTIATE_RSP -> SMB_NEGOTIATE_RSP

Then move SMB_NEGOTIATE_REQ to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 12 ++++--------
 fs/smb/client/cifssmb.c    |  6 +++---
 fs/smb/common/smb2pdu.h    |  7 +++++++
 fs/smb/server/smb_common.h |  7 +------
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 99cdba9f68dc..1e16ef6f0ff5 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -388,19 +388,15 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
  *
  */
 
-typedef struct negotiate_req {
-	struct smb_hdr hdr;	/* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __attribute__((packed)) NEGOTIATE_REQ;
-
 #define MIN_TZ_ADJ (15 * 60) /* minimum grid for timezones in seconds */
 
 #define READ_RAW_ENABLE 1
 #define WRITE_RAW_ENABLE 2
 #define RAW_ENABLE (READ_RAW_ENABLE | WRITE_RAW_ENABLE)
 #define SMB1_CLIENT_GUID_SIZE (16)
-typedef struct negotiate_rsp {
+
+/* See MS-CIFS 2.2.4.52.2 */
+typedef struct smb_negotiate_rsp {
 	struct smb_hdr hdr;	/* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
 	__u8 SecurityMode;
@@ -426,7 +422,7 @@ typedef struct negotiate_rsp {
 			unsigned char SecurityBlob[];
 		} __attribute__((packed)) extended_response;
 	} __attribute__((packed)) u;
-} __attribute__((packed)) NEGOTIATE_RSP;
+} __packed SMB_NEGOTIATE_RSP;
 
 /* SecurityMode bits */
 #define SECMODE_USER          0x01	/* off indicates share level security */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 703c5a8ed924..0ef1d5024998 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -361,7 +361,7 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 }
 
 static int
-decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
+decode_ext_sec_blob(struct cifs_ses *ses, SMB_NEGOTIATE_RSP *pSMBr)
 {
 	int	rc = 0;
 	u16	count;
@@ -419,8 +419,8 @@ CIFSSMBNegotiate(const unsigned int xid,
 		 struct cifs_ses *ses,
 		 struct TCP_Server_Info *server)
 {
-	NEGOTIATE_REQ *pSMB;
-	NEGOTIATE_RSP *pSMBr;
+	SMB_NEGOTIATE_REQ *pSMB;
+	SMB_NEGOTIATE_RSP *pSMBr;
 	int rc = 0;
 	int bytes_returned;
 	int i;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index be1e652bb474..824d27297bec 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -2151,4 +2151,11 @@ struct smb_hdr {
 #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
 				| READ_CONTROL | SYNCHRONIZE)
 
+/* See MS-CIFS 2.2.4.52.1 */
+typedef struct smb_negotiate_req {
+	struct smb_hdr hdr;	/* wct = 0 */
+	__le16 ByteCount;
+	unsigned char DialectsArray[];
+} __packed SMB_NEGOTIATE_REQ;
+
 #endif				/* _COMMON_SMB2PDU_H */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 1928b66d309f..cd21756379b5 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -116,12 +116,7 @@
 #define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
 #define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
 
-struct smb_negotiate_req {
-	struct smb_hdr hdr;     /* wct = 0 */
-	__le16 ByteCount;
-	unsigned char DialectsArray[];
-} __packed;
-
+/* See MS-CIFS 2.2.4.52.2 */
 struct smb_negotiate_rsp {
 	struct smb_hdr hdr;     /* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-- 
2.43.0

