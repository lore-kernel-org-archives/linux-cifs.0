Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D112C534
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182937; cv=none; b=HQPX9T+v2J9zAygqxMSD8O+/YL2k6lTT+TWyx6dPIaQUPGU6G7zmaN1D5Xgvx+PNQdCX5PZ1ZnUzTRFCsuTfYWXCXWguIOeSNYZfKeiLOzS2Xu7m5dw+Y7ejnsBfUsUkW8tMTp4X1Z3rAH6q4xIOFCLnqnac4yefjW0yVbCe2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182937; c=relaxed/simple;
	bh=R4IDD6UBANrKYwMaEgbs2KwGm+BQ8/RkTcTHL9urjb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ/JMN0Cws1XQPHI9qvzmN/tSbySFnEGra1nvc1pnJFA3NfngOzcp7vmPuzmFb5w9bhaUEcJcEyWkMbCPlZMPbYB0Zf8hpvOl58vggJTJxmrV/jmftSkjsUMrGxIedlq3MzUlntNDJAz47r6xoVKfy9rI9yXH9rtbdfDTxux59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c5IglSs8; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c5IglSs8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9/CmaxHpBMDO5U/SkNvuhzD1FxT0T11yKZOeUiovUI=;
	b=c5IglSs8kzTSL+la2pFp/Rgio2OdvtEXPf0FDJh/GHK5Pcmx4E3BBczzW3zPmsT13XbHsO
	mxOeLvD9XiNYh3q6mjkOgS2XDfMFufxcXFUQGGXOWTIVercVg/qFu8opUbK+xcPoFCO8jb
	olAKnLDPeoOIpZE8Td/+A4s0u77m5rI=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 6/7] smb/client: reduce fallocate zero buffer allocation
Date: Tue, 23 Jun 2026 10:46:18 +0800
Message-ID: <20260623024619.1360127-7-huiwen.he@linux.dev>
In-Reply-To: <20260623024619.1360127-1-huiwen.he@linux.dev>
References: <20260623024619.1360127-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

The fallocate emulation allocates a 1 MiB zero-filled buffer even though
each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE, which is
64 KiB. A high-order 1 MiB allocation is more likely to fail on a
fragmented system.

Allocate only the smaller of the requested range and
SMB2_MAX_BUFFER_SIZE, and reuse that zero-filled buffer for every write
request. Also reject a successful write that makes no progress to avoid
looping indefinitely.

This reduces the contiguous allocation required by fallocate emulation
without changing the written data or range semantics.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8b931581870a..4cab652d9696 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3543,7 +3543,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3564,9 +3564,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
 		if (rc)
 			break;
+		if (!nbytes)
+			return -EIO;
 		if (nbytes > len)
 			return -EINVAL;
-		buf += nbytes;
 		off += nbytes;
 		len -= nbytes;
 	}
@@ -3595,7 +3596,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

