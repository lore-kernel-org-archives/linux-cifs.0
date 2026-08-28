Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007C71EB19B
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901680; cv=none; b=PXV6Z8K43oOuxLKwXB/9/yQwKr99oAHNkfnwcEsndvpI+CCV7S+7cHgPXSvE3U2WszwhBYKE+9AsrgbHBYbgDXngSJzfD1L4tRFs8jbnOa+WpTMhCTsl65vMXEW8kBSZ6GZrn2KY6KKQ7X0Ld1eVrVU497yDpajEAjy6CgFk0rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901680; c=relaxed/simple;
	bh=PGePezBk/xvUQY5ZNIditdEUME8z6z3/Rs2su0Hsza4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6xWhscV2Gdp+zgz14J7E0e/wS5lIog/NzDlLszfLdBfzyMvmIIlLamS5xSsKCH4Qpj8qxftPS5pRVHmpG0RrOyDrAd4f4o4FsXaOPUcHNDR5TB24kXVPGO8h46aW4KWib3gEPiCKbaq3VkHEaDxN8DGakzOsKDXovGGw6KG2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YYW+HvuG; arc=none smtp.client-ip=95.215.58.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YYW+HvuG"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PGePezBk/xvUQY5ZNIditdEUME8z6z3/Rs2su0Hsza4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901676; v=1; x=1788506476;
 b=YYW+HvuGWTNd2Th2zKRRFa1pUOH0Zpv3HBAFe8J0nq3rJWL6h4cWvmoZ6sKQgmr1o7OYUqOl
 5MMAr3Cnxl2+YM7JGXjrjsZeWSJaRbEy4EfgZ1zKeLSEaOErKiG24GCgd6vLgcCb97adTQbeHXz
 jTk/FVWKIpgGfRs+Mo5sKzS0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cea9759dcd8f5b90;
	Fri, 28 Aug 2026 07:21:16 +0000
X-Mizu-Trace-ID: cea9759dcd8f5b90
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 5/7] smb/client: fix integer truncation in collapse range
Date: Fri, 28 Aug 2026 15:19:33 +0800
Message-ID: <20260828071935.552165-6-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828071935.552165-1-huiwen.he@linux.dev>
References: <20260828071935.552165-1-huiwen.he@linux.dev>
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
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6f17d83c0aec..4676c5fe54ba 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4036,8 +4036,8 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
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

