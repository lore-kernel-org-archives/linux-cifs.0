Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096023AEF47
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403442; cv=none; b=Ye8ceefbYT/McaCg9oSQ9ABqEx1SIi1r6E7h8a5xBrHN2mGppSLJXCMbAQA/0UUSPJf881emuKyeeYdDUYU4YsVbg6P/8tdG+e282jU+0Eq8DMWilPXZWB4WgyI/d3M7R194zG5ZI+CUzRjqvHQQ/RWQL/KWLrV6jOiQSIMS8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403442; c=relaxed/simple;
	bh=dkaFwtpfgso/SCGPqZMg16AuwE+RKpcfHl4peWjNbfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT4g5ywV1PGVLvZSj2qGoUaOC1jWBmUY/vgsCwyugVuo9me9+4yL2ckD/raTg1nvUWq9u+ylgvKV3rpOMTZTTihMXtUMxpunpjAJUk48RRAihDhGmX2x60RTVnIh/a7zQKSMBosN/9ZLEcxyOTlLBeks92amewqTJaOdnKBaPtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pO1Q77zn; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pO1Q77zn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782403435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iv8yTdHfG4Kdkj3HOItwRLcEUjghrTsNd56hf6kZ590=;
	b=pO1Q77znyDJ43tlZogSPkSDhGRBEZaGJpPIBWFbc/l5k7s9Y8QNN8a88Dt368na1AXakxk
	xSar+Ed6782imO3UTENWiePnhDf8St1OAq+lFWuHr2S91POqEtWe93OLt7bMYpIpwAcRFA
	sBTYrI8xYgiqKixJe8CZn2Gu537o4KU=
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
Subject: [PATCH v3 7/9] smb/client: reduce fallocate zero buffer allocation
Date: Fri, 26 Jun 2026 00:01:52 +0800
Message-ID: <20260625160154.104450-8-huiwen.he@linux.dev>
In-Reply-To: <20260625160154.104450-1-huiwen.he@linux.dev>
References: <20260625160154.104450-1-huiwen.he@linux.dev>
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
index a260e85ad1c8..5f2e4a0722a6 100644
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
@@ -3596,7 +3597,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

