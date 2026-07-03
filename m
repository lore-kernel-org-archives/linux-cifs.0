Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7067C2857F0
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056850; cv=none; b=IUZ7co1sMlY5fSoPcRv2oRBL8CXJEa3HnX1G38a3FMFk+htH0s6nWcuPtEhjGxQx9z8Rp4tE3ug86NP5M1zbRma5iNXdpRb21abssyB+zx7Xuucr1lrm5ESmo00IJum8EGkA1VMFizGVTF3ehpdk7IvvqpaZKPWA0ixFceTwmqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056850; c=relaxed/simple;
	bh=bX26thAmyh8ZwIgiR0XZmy2Vup9ZbvvV9KintGfvUkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e10m4OFDYBTDbuI7BhDMYCM7o82ZjUj4I38J2hRpSdYNwsSP5MfU6W9sEd5SgWNP6EvnNRPzbt+LBsZJJuWTBv7/P1ykZ7DdTuGYS7m0HEoDIgBF2kL9AVOBN6nOb5kWDbwHhWv7WZC7W2m9YHVZq5PnUkc0OyPkjRDbSq3hDP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C5wb2YLP; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C5wb2YLP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783056844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=clhVBgbWhWVlW7j9DSe+lluKnWet5Sm8zLqIP3V1H5k=;
	b=C5wb2YLP3KNBJAx/MI6x1r3117VL/4JLsCl/I5RYZAI1liNOIs0RZLvZufqZ/u6eLdyFYa
	5ljOzrxPXUmaP2pTRr1qvZ8RcdaJCl0bRF5UjiBBzVu6W/llxRB28KTPkQIl0oXaSRJwsj
	rRK2f5+w/NZ6Ydi06cDqauynPCmvHCk=
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
Subject: [PATCH v8 3/5] smb/client: reduce fallocate zero buffer allocation
Date: Fri,  3 Jul 2026 13:32:57 +0800
Message-ID: <20260703053300.913371-4-huiwen.he@linux.dev>
In-Reply-To: <20260703053300.913371-1-huiwen.he@linux.dev>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
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
index 380f4b4ddcd7..41c928bc23c2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3573,7 +3573,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3594,9 +3594,10 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
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
@@ -3626,7 +3627,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

