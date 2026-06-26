Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DDA3F7A84
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481684; cv=none; b=Nvs0CAGjgLV10eqB782WXTdhKbJavcKjunELD2AKFIAfBO+MkGmjY4nyCBCG5XG+C3GfFn1pGEiDJihIkJvloqZzghfG0YrmOq+LoD7JCa3vs/JqEWbpzlwZiL+HgS4N82R1wbeBUOni30m6VYvmB36ajqocwu62TXEKhX364hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481684; c=relaxed/simple;
	bh=AKxFgbdvk0wht9pcL5rPU9WWR91PRU2ihqJRXHiGw8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epMpdONHK26f8CJkQNiRaodR+/HvhzxVKeOQyRXs6ifa1g7svbCyqawaQ+FuAoDVdbQy6W6aOA+GrXIysDytO4pL3uTVaeA3x0j3pxYpth8Hs5TdWSHQ1kDHqfc9PXEMiQJp/Lek2Zz3qohEjI/mOoC5Bd9HET7X/Ex0pSYHWaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X98Nisl2; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X98Nisl2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jheHAPeAhzK+e9HSmJmEbjL7BMXtv2nU1RmPS93cnio=;
	b=X98Nisl21QavQ0xilqjwidrG42sIuQgMbZVMg6t+sw+Ysc54IWl3uteJhy7ZCpQapkOMmQ
	hMUWrDDXZUwJR5u3tlyVh19W1qtoLJLp/QlGj5uhUhcdb2y5Y71yoR8CHI+eKwzljXJs0T
	ZM5sbAPaRM8tfJCctkaU46YCDU2qsYE=
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
Subject: [PATCH v4 5/7] smb/client: reduce fallocate zero buffer allocation
Date: Fri, 26 Jun 2026 21:47:17 +0800
Message-ID: <20260626134719.158270-6-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-1-huiwen.he@linux.dev>
References: <20260626134719.158270-1-huiwen.he@linux.dev>
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
index 4cd0e578e3ce..311709d73798 100644
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
@@ -3612,7 +3613,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.43.0

