Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B125E2DEA93
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267462; cv=none; b=F0qq5o6JkNFMzd9oAsf9W04e7Kslo0JfNIu8vXUiUHSVoBBnDxSDSZafakWMuHvJ3loZM0hcli0lIporyDQNR+xJE5vTxJoeDUsuTTZupim2IhoWHYFfUyn+1oQ5AJ+F0tIPymBcZHsTi2m/HH6ZnbdE3vmNPhkQK8kSgH8d3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267462; c=relaxed/simple;
	bh=VeUUSFP35Y/sBxCcTkcHhG9hdbXeAS+xcT0SIKaL0L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsK3lSNCALV6IcoN4rCVi9CJyDIBM9qBzR5ljcBmpjLCpT+zw7UL8ig4tRUNvSk6WKJCDuwmCz0fXTpr+/SQPtWRicxjdKTMp79agzpre6LyTW+hEDwXP8TuOxxk/a5fRvuaaCvq4cL3e4pcLLrM4mUvf3tfHrMbXDfasrlMSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VabyzcHW; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VabyzcHW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbEyi55PiH5d/LEHTTDaFKsX9+fL4f4N3fH47rbWVSs=;
	b=VabyzcHWC8wb5XR3t1FAbpuRmcmYGusYRQCQvb4tLWbW8LI1HwuIp3U52a9eiNmi94nhiz
	5xyHpw/uifNVPBF+10PdljTd6HfThtwxe0Rx4B3F+/7RS+kzr2KhLTbUCrdXqWbMiGX4In
	rv/0pbyVHdDkOYuc58ANLOnqqoJXxQ4=
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
Subject: [PATCH v2 8/9] smb/client: reduce fallocate zero buffer allocation
Date: Wed, 24 Jun 2026 10:15:49 +0800
Message-ID: <20260624021550.1548952-9-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
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
index 3c0b47a41027..e0815805caca 100644
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

