Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8CE4B04B8;
	Fri, 25 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347062; cv=none; b=bftHWpSv2c1oENvploaqQRB8yrcPuBkDADRUQ2DmTITFS//JZsqin7GNfiD8eTMbzE0d+bFheK9tUUMfKy024TbCRkwW4jRxqyfZuHrHzQ9rU0dCND1BWhRLUOTtFbwGwaGhNX5w6d6FbIuG1bz6kV9r0CuqAS0oWzYIQp8klj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347062; c=relaxed/simple;
	bh=DXT8g1m++XN4aYMhoiOUIPBkvWZEjmV3myu30KBJ+64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXSN8kSKxbxPE2yyX6maKG8SKEB1NOqYZvT9Yip7iSW3sFLO+3A7cwoRY9FHR1i9HzCLpR3cckQL33rsX52XDQC0g0AScYJMzg7AiW5jr8rx53fCKDBuPHVZiCffNMpM9ALlur72xBuAQcf7W5z7lcwR+NLpJZ4YrnK5pI5Tj/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3EFG1EHb; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3EFG1EHb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/DzP/h0aYY0epI2sVCaTN5Ag/XOPgz/J0uFZU5sgpMg=; b=3EFG1EHbCRBAnc03o+mKlN5KEv
	BWXJUhEGbKnPliUFeJlTB/F6669TVxbhLou/EU7ovfmamyl3a9RQoUEQtW6+r32Uwk2aDgscYGq5X
	GduxsEWw1Hhk8FWHZud1bIR7IemwnUfpvBcNNmFAB4S8c+huh1kbTbR+za3Scc+CLk40SQeYgoJue
	bKO0OovNnId+4jLq8elVNP1uD7afFlMbofHS9y6f/LsHPN7CYUvO6hVmYHKFGZzNfklGOlIhWJIPj
	ZQP0kVoph9joKgcM+mTBdNBt5PHkfyyeKYH7cvskDXBZeHheOysKnG5FNKWyGQrZh1jfVuBJJNsZV
	Cm7xBAHw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xA739-00000002GxL-3xR9;
	Fri, 25 Sep 2026 11:37:19 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/5] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Fri, 25 Sep 2026 11:37:16 -0300
Message-ID: <20260925143719.2889518-2-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925143719.2889518-1-pc@manguebit.org>
References: <20260925143719.2889518-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_setsize() relied on pagecache_isize_extended() to zero the tail of
the folio straddling the old EOF, but that helper is a no-op on CIFS
(i_blkbits is 14), so data dirtied past EOF through an mmap survived and
became visible once the file was extended.

When extending, zero the tail of the folio straddling the old EOF with
netfs_clear_stale_post_eof() instead, mirroring what
pagecache_isize_extended() does for filesystems with a sub-page block
size.  Do this before updating i_size so that the helper, which clamps
its zeroing to the current EOF, zeroes the whole [old_size, offset)
hole.  truncate_pagecache() is then called as in truncate_setsize(): it
is essentially a no-op on extend and drops the pagecache beyond the new
EOF on shrink.

Closes: https://sashiko.dev/#/patchset/20260921230755.1133425-1-pc%40manguebit.org
Fixes: c510edb9734a ("cifs: call pagecache_isize_extended() in cifs_setsize() when extending")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---

v1 -> v2:
- Zero the folio straddling the old EOF via netfs_clear_stale_post_eof()
  instead of lowering the truncate_pagecache() boundary.
v2 -> v3:
- Call the helper before updating i_size (required by its clamp-to-EOF)
  and simplify the comment.  Dropped Dave's R-b as the code changed.

 fs/smb/client/inode.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1fe0ef0a95db..7988ddfd2bfd 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3060,8 +3060,19 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 
 	spin_lock(&inode->i_lock);
 	old_size = i_size_read(inode);
+	spin_unlock(&inode->i_lock);
+
+	/*
+	 * When extending, zero the tail of the folio straddling the old EOF
+	 * (before updating i_size) so data dirtied past EOF through an mmap
+	 * isn't exposed.  truncate_pagecache() then drops any pagecache beyond
+	 * the new EOF, as in truncate_setsize().
+	 */
+	if (offset > old_size)
+		netfs_clear_stale_post_eof(inode, old_size, offset, false);
+
+	spin_lock(&inode->i_lock);
 	i_size_write(inode, offset);
-
 	/*
 	 * Extending EOF does not allocate the intervening range. Only clamp
 	 * i_blocks on shrink; allocation growth comes from writes or from the
@@ -3071,8 +3082,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (offset > old_size)
-		pagecache_isize_extended(inode, old_size, offset);
+
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 }
-- 
2.55.0

