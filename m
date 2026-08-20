Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568033C1D4D
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210187; cv=none; b=qFcpBFGU+fMAZb1JhlZtfzwyefdMnDihJfNJjqcjrExwtDZjxjAnPlJyMcSu3xyYb+2WuqeJa++5rlD1dclSl6hqMYHIp+maKNjtZLbkHuuVY5QM0xNaE81lW4z2YfdVR/DtLze1nQl/Jnw22Dh0cRchVNPXQ3kM63PNSnsVhqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210187; c=relaxed/simple;
	bh=VaI0h0Ml05wdZ/ESOdXMWLEbUzKyfv0i4kvzjChQr3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1QZXZTCHteTcS8s/KWWnmqYidC8y7l+Sfrr9ft9Vz1DqxVcOkPtxDTMo+6q7gWsEVNu059cozIPyckelTzn3zFM2Wrb3YAaMlndeLAUi16zfbbOSHZFL/+nssAvhwel5zNDNEj4z+76yiwubvfWSOYI+1ZzrsLweuXDZCqqRNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G6F9Q0oj; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G6F9Q0oj"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VaI0h0Ml05wdZ/ESOdXMWLEbUzKyfv0i4kvzjChQr3Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210183; v=1; x=1787814983;
 b=G6F9Q0ojtgpSGhClAxSefFyOpHkWYAGtQPTq1DrDd04WDzXaUVkcEWvbZQDmdOJ1COtV0Ila
 XBvOmqiYNBfmcBFnO+A1PwM290tsU2hDbOQLt1RNoli0o2/8LbfmJRpq4GKAK0W4qWErOIUdSsE
 9SPc4cl3H34CmSUHmm3kYHks=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from harry-WUJIE-Series.. (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 86df5b93de82ff13;
	Thu, 20 Aug 2026 07:16:23 +0000
X-Mizu-Trace-ID: 86df5b93de82ff13
X-Migadu-Flow: FLOW_OUT
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
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 5/6] smb/client: fix integer truncation in collapse range
Date: Thu, 20 Aug 2026 15:15:25 +0800
Message-ID: <20260820071526.826926-6-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820071526.826926-1-huiwen.he@linux.dev>
References: <20260820071526.826926-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_collapse_range() stores the ssize_t return value of
smb2_copychunk_range() in an int. A successful copy larger than
INT_MAX is truncated to a negative value and treated as an error.

Reproducer:

	MNT=/mnt/scratch

	truncate -s 2056M "$MNT/file"
	fallocate --collapse-range -o 1M -l 1M "$MNT/file"

Fix this by using __smb2_copychunk_range(), which reports success as
zero instead of returning the copied byte count.

Before this change, the reproducer fails with:

	fallocate: fallocate failed: Success

and the file size remains unchanged at 2056 MiB. After this change, the
reproducer succeeds and the file size becomes the expected 2055 MiB.

Fixes: 5476b5dd82c8 ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1a1ff0f33288..ee0f646d1aa2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4035,8 +4035,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	spin_unlock(&inode->i_lock);
 	netfs_wait_for_outstanding_io(inode);
 
-	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  old_eof - off - len, off);
+	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
+				    old_eof - off - len, off);
 	if (rc < 0)
 		goto out_2;
 
-- 
2.43.0

