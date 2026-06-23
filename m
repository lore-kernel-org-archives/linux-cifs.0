Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91B363C6C
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182921; cv=none; b=da+b8NCpaIxQCRHjBdWDyCLqd/2/TpSh5CSDjIGHlXv3EXjk5yB1shbh7OHFJWoTMLGh40nIH0rJFesD36/btN6dMSWnVBc4iPmjOQ6fnGPLycYrDIsNNZFdFaBAUVRfAMdKxF/yso6Iyfum1mS3NyAw81qO0ohNRER5okxkJhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182921; c=relaxed/simple;
	bh=gfCDKxy88QDlHAxP99WpiFRyM4FUVIpJ/kFvOf0zg5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJH2Rsn6RH2Z+gQgs3kfZV5wgomFxSII0kwY1RlieCyHfYmyY7ul9cyGQxGXwEEz0WP8u6BJgnM+hNMSJJYwgHbx0VwEOmjtWYPCqueuGskIDHdVnSWOb7ehyrItS6uptnCH1mEZd4P7kX3pVZLU5qZ1K+AE48uDLJiC5TzSx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vc6VxB1S; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vc6VxB1S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+MtMqy2fKInmfeyKnrFkSaehaVe03SP0QWXNsmzvhhw=;
	b=Vc6VxB1SbIo506FMhUDwAqyvQ5lRKqOh47jidEsSQJ8DEWbTF3q30VRQn0HkPZbf4tzMUn
	D1bqEqfjX3kQIQ888xswhjWiu5JYKGTsHpFQ/UgWi0d1w5fSAOV5iXAVjfJ4ZTP66/u8Je
	DkHpSJaa82+98xG1chkNwY+dorTtbvY=
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
Subject: [PATCH 4/7] smb/client: do not account EOF extension as allocation
Date: Tue, 23 Jun 2026 10:46:16 +0800
Message-ID: <20260623024619.1360127-5-huiwen.he@linux.dev>
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

cifs_setsize() updates the local inode size after SetEOF succeeds. It also
used the new EOF as a local i_blocks estimate, but extending EOF does not
prove that the intervening range was allocated.

For example, after writing 1 MiB and then extending EOF to 10 MiB, the
client can report the file as fully allocated even though the server still
reports a much smaller AllocationSize:

        $ dd if=/dev/zero of=test bs=1M count=1
        $ truncate -s 10M test && stat -c 'size=%s blocks=%b' test
        $ stat --cached=never -c 'size=%s blocks=%b' test

        client stat:                    size=10485760 blocks=20480
        server stat:                    size=10485760 blocks=2056
        client stat after revalidation: size=10485760 blocks=2056

A later attribute revalidation may correct i_blocks, but callers such as
xfstests generic/495 invoke swapon immediately after truncate. The swapfile
hole check can therefore observe the inflated local i_blocks value and
accept a sparse file.

Do not grow i_blocks from cifs_setsize() on EOF extension.  Only clamp it
on shrink; allocation growth must come from write completion or from
server-reported AllocationSize.

With this change, EOF extension no longer makes a sparse file appear
fully allocated before the next attribute revalidation, and xfstests
generic/495 no longer accepts it through the inflated local i_blocks value.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/inode.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0af93e881608..84d95d2c3ed9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3038,13 +3038,20 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
+	loff_t old_size;
+	u64 blocks = CIFS_INO_BLOCKS(offset);
+
 	spin_lock(&inode->i_lock);
+	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
+
 	/*
-	 * Until we can query the server for actual allocation size,
-	 * this is best estimate we have for blocks allocated for a file.
+	 * Extending EOF does not allocate the intervening range. Only clamp
+	 * i_blocks on shrink; allocation growth comes from writes or from the
+	 * server-reported AllocationSize.
 	 */
-	inode->i_blocks = CIFS_INO_BLOCKS(offset);
+	if (offset < old_size && (u64)inode->i_blocks > blocks)
+		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
-- 
2.43.0

