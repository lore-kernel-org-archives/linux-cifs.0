Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752344F55B5;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626190; cv=none; b=LG0/IOoGVNSsJrsDQhsKCqobruD0XsvJrTdBjK7WpMSGJ9MCFpByd6jeTdbn05a0KC19tSONGG3+z0H946laTiz8n337CACrXx542WPl82XalCB/XCgntzJ+Pdq9mhbl5H32735P5EyQLRfCmSUjhWjMs9DFOu4h/KHm/qIVQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626190; c=relaxed/simple;
	bh=SjfWwRRL78AZq1F8aO5ICjQNnc2qsi7X4g4S9JvrNNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/EzPZCEILt8GuI+PmNPv1S4Z+aa4eB6VcQdWzUQ3fXU82yuj/OGryGVTGwGsXBfLG3tL/aQnZsoPGhb0Bu6UKgTxAzfuByV2tWSjtkia2Qf1CuHBGQ3gHrvs/XF54f/dC/HqnARxakIcUf2AslQO524NHJysd521Q3uJde6m9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=OkOCYT/2; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="OkOCYT/2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=iK+XJajufQllYNemxs3SQ/XoqSAgjSfVZ4M9RYI8csY=; b=OkOCYT/2kzgPLc4tgRWhZ5Unzm
	qz3AZ1WBuOUcrX9D5+JlojIxETeEIeRbqL7W55ChNUUAKtIDnhw6A9O9lu2V4Jz4pCb5zPC1uM0A8
	fXMZlrfe6r1FfIiaNtQmbq2JLnxasNlcGEzTtuq+tuVeDBdpokG6M38x7Ff5lmMm/Sch5CZoAMF20
	8bajEAnwDgWnq2CcsabbAdXBc/JCwrOwQxPKBxka+RL5UGYr0UmccJxQeRjYqBn4X1XEWZerCM6X1
	PWkkyXlbynP8CDQSqhxGaOpoeAp9iX868dNdDC7jQwf5Z8+BycCupRyVl3qh7P/Q6XAMjWCjiKVqA
	i0ni1FWg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfL-00000002UJ2-1Bkt;
	Mon, 28 Sep 2026 17:09:35 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 02/15] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Mon, 28 Sep 2026 17:09:21 -0300
Message-ID: <20260928200934.1040189-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
References: <20260928200934.1040189-1-pc@manguebit.org>
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
Reviewed-by: David Howells <dhowells@redhat.com>
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
 fs/smb/client/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1fe0ef0a95db..ebc620c166a9 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3055,13 +3055,20 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 
 void cifs_setsize(struct inode *inode, loff_t offset)
 {
-	loff_t old_size;
+	loff_t old_size = i_size_read(inode);
 	u64 blocks = CIFS_INO_BLOCKS(offset);
 
+	/*
+	 * When extending, zero the tail of the folio straddling the old EOF
+	 * (before updating i_size) so data dirtied past EOF through an mmap
+	 * isn't exposed.  truncate_pagecache() then drops any pagecache beyond
+	 * the new EOF, as in truncate_setsize().
+	 */
+	if (offset > old_size)
+		netfs_clear_stale_post_eof(inode, old_size, offset, false);
+
 	spin_lock(&inode->i_lock);
-	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
-
 	/*
 	 * Extending EOF does not allocate the intervening range. Only clamp
 	 * i_blocks on shrink; allocation growth comes from writes or from the
@@ -3071,8 +3078,7 @@ void cifs_setsize(struct inode *inode, loff_t offset)
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

