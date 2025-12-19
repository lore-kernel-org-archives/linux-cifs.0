Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62E2C21F9
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188545; cv=none; b=jlaON6MWgRXgVVJWdPv3OxtBDimMx3beRZOw5cmamkTlzvMgfplupRqMXyDPU/dROguvPx6hnH9X1W7MEd/1j7ZrFoU5J6IE2uTAwd1jBksSb9JwUdXg+IV+UbAXuaQE05TrpsPPGC9FM+IAJQZw1p1XsAPY6C4Idqb4GS+YUpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188545; c=relaxed/simple;
	bh=tFKjVlXzqjceOHeK7O5kE5TVZQgv6nCOjDPQZrPfocg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuT7c7AWcuMvMU/pPC3rKfmXIkNa2HZ9uW8oQY2UwNJ3KDDThc25QVu7ZGNKNn0PtvrBiB2XLbMBA1JWjLmJ5fBYsrLXc1W+7pPmH+sItMmydh9nygRUmBf/Ymp1NY3y0scdNSq71RDq2Ynkz8cVDQxRzEiDAmDfME1pdVZdMcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nWbPd8dj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nWbPd8dj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766188540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5QxYmQBsKFpyA35KMLBjauc5+QlBGY4mJgHLixtcMcI=;
	b=nWbPd8djaHNe9RndwIsCxh0N8BJhO8nIGLaLJzNxfngPGsrDY6PvKGyulmwBamJQg+N/qN
	kIzhEHGjxvjapmnfGj20VHsLNgprc90OUenqhQo59iZ+bd48NMNxvN6ASICVfseRGpHHtx
	J1IyIpTu/hX4xH6MsUAWxCFTDngt6G0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH RFC v3 1/3] smb/server: fix minimum SMB1 PDU size
Date: Sat, 20 Dec 2025 07:54:17 +0800
Message-ID: <20251219235419.338880-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Since the RFC1002 header has been removed from `struct smb_hdr`,
the minimum SMB1 PDU size should be updated as well.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Suggested-by: David Howells <dhowells@redhat.com>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb1pdu.h    | 5 +++++
 fs/smb/server/connection.c | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index df6d4e11ae92..3c5332a82ea7 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -53,4 +53,9 @@ typedef struct smb_negotiate_req {
 	unsigned char DialectsArray[];
 } __packed SMB_NEGOTIATE_REQ;
 
+struct smb_pdu {
+	struct smb_hdr;
+	__le16 ByteCount;
+} __packed;
+
 #endif /* _COMMON_SMB1_PDU_H */
diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6b4f1286b9c..f372486ebcc5 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -295,7 +295,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 	return true;
 }
 
-#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_pdu))
 #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
 
 /**
@@ -363,7 +363,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
 
-		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
 			break;
 
 		/* 4 for rfc1002 length field */
-- 
2.43.0

