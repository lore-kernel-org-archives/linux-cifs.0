Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501ED48A2C3
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782919368; cv=none; b=F62owmBhRIcEq4RdM7JpLErT3SOJvDlzg5whM11PU2+VJwO3e8F1HUH0lHCXyyAWjdrAbY7IRa2tA80j0E8Glz1YkHPAXcHu0MmIeja5IJSyC/pDNSKb7DngaboypbdF1sJDcF9GTPKb8K+93bshFqX2AloJwHyOMH5432DR/gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782919368; c=relaxed/simple;
	bh=PJeuIBVyHEUB9iEtpBqd5iUDfkHhsFzodLbTo0Uzfv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1araScHuL+wsNCRJxQChSsKIBQ9PVzCoK/UJFLRr9/tBEELGdNawG1hOi6+3yc7Bj06nby8p5i76jHTqDU4VGYUBO/I0L12Gg9xGaZ3S5imsoehUUv7/jX5nCTa2TubJYLlZruTygEyT+ovEG69WbqdkhmTXyeFG6ZyB/+egVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gNBIOwXe; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gNBIOwXe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782919365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DdrPFOM9ZnxBG1aKBzq415lF8gBqBb64jDm9SlnGFHU=;
	b=gNBIOwXeR7N7+a/MwvwQnj6CA5Vddtx7Y8qITcpvuEjlYgaV+Hp8FG80cVPxKOKkvv6WNl
	O/1RgZ/MEJD1BoJQVgMYGMUmNXXA4PPAVZMJqFd4fHORi0hzPccZOfoUSDOLw4bIZB6f98
	+lRFUqM5+a2uwtLKrp6+D/faCLJJEVI=
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
Subject: [PATCH v6 2/5] smb/client: reduce fallocate zero buffer allocation
Date: Wed,  1 Jul 2026 23:21:54 +0800
Message-ID: <20260701152157.822207-3-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-1-huiwen.he@linux.dev>
References: <20260701152157.822207-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

The fallocate emulation allocates a 1 MiB zero-filled buffer even
though each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE,
which is 64 KiB. A high-order 1 MiB allocation is more likely to
fail on a fragmented system.

Allocate only the smaller of the requested range and SMB2_MAX_BUFFER_SIZE,
and reuse that zero-filled buffer for every write request. Also reject
a successful write that makes no progress to avoid looping indefinitely.

This reduces the contiguous allocation required by fallocate emulation
without changing the written data or range semantics.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cc8e0595e504..23505ae9bd81 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3559,7 +3559,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3580,9 +3580,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
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
@@ -3611,7 +3612,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

