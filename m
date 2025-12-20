Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3011D5CF2
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766237221; cv=none; b=lUok8ucjGOrsYCujNdeYAGk71h6ASXpcBIMg3juhU2e4ZQYXZH5soENlX/y87AsOKsaSS0HNhvWCXpJe8q8e0v5Cp/IvH3UT4uUWtk8tLo4nElIwMxwt91J+EvusgkuznqCrBcc1/oohf2XYnmwT5D7Sfq8belIe0c6DDija1O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766237221; c=relaxed/simple;
	bh=4Q/cyZIXMyaSna4WuiRHIvYZHWrstGnI+qXPAnMyluE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJJ13YilaJk/xgf0hVJgljxUI+GXNks0kzWtOlihmjhk7NaBijr7KE2QMAdYgAthuCtYH3jUQ/+Q8mswk7uZ+IveTllu+J+J0OUSVpX1+Ww+w56VWAdQW1RA6s24VuQN99Y2YEGUtVfQp9dP9om898uv+tf6hjMxskSMm56yID8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZFV4tuFC; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZFV4tuFC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766237216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygN+7FMOGlFznIo25Y2Ydwmm+ebD2rlWNC41X+dKM6Q=;
	b=ZFV4tuFCTWe0zct4S2JT6L4IdWi2xw9uFPuOuKhwQ002OTyLbt2XcXSlxQksw+ULEXcQ+D
	dgv/A/rzSb+BfcH5R/1xbhMVDL6A9fcawN1w4JblD8HGoI1cVnL+6MIfjX8nX6PNnZDwTT
	LgTm4xSi7xRxumyaRLE9ccAv9tVN+To=
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
Subject: [PATCH v4 1/2] smb/server: fix minimum SMB1 PDU size
Date: Sat, 20 Dec 2025 21:25:50 +0800
Message-ID: <20251220132551.351932-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
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
 fs/smb/server/connection.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b6b4f1286b9c..c801edd6f1ae 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -295,7 +295,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 	return true;
 }
 
-#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
+/* "+2" for BCC field (ByteCount, 2 bytes) */
+#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
 #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
 
 /**
@@ -363,7 +364,7 @@ int ksmbd_conn_handler_loop(void *p)
 		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
 
-		if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
+		if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
 			break;
 
 		/* 4 for rfc1002 length field */
-- 
2.43.0

