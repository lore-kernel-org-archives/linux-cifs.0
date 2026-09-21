Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5A3EE1E0;
	Mon, 21 Sep 2026 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032083; cv=none; b=cxx6gQsNEobgmRIz3frL/EUumvck/YhOV79kODZOxwax1nHJ1SQ9fwNXD3CevIVdnG/5fIXtbHXNekURaO8jqL5UMfRNdgFHXBIIw7vj7lB6usU/mrjzxMe3WqVJu4AqH2lOGm1WU9cnrBo3c21Y9Ox6kg+iGd9XtgekOH6YNLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032083; c=relaxed/simple;
	bh=JNO9zRcAw+0R3oJ8FWMo1TVyKaGKDVDjaf/7k/msVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN0+deogRXwYPhM5Y6UzT7Mlv38PpEgu2peMyxNhHZ82639kRd6FgeGT8bG2oyJG0En4bC7++CPiBUEn6VTfOlMYISQAmvKZd4ItxBBDitJlCqxc6L2+N5b6sQryw6yZ/+vd+/IWn2IbC6UhYeEE3OagYGlYT215d0pYBx5sybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=lHJuC7xw; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="lHJuC7xw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=jrRx8Cvzw+bnHwyDHddwxlbm0/0JqY22aukGXSqOrWA=; b=lHJuC7xwJ2vWhleI8GHTd9hFR8
	JW6gP6OJ5od9+N5IPZqdfWK9+WcmPD7cKJq5WF2Yx1tT4CQ0qBSzib4QJcsZYc44UnaJxGtxdLg5Y
	njVMjuO+kQ46tq/2T7vdqud3rXDNEQMXT9ylqdg0t6tFnWovMek+oo18fI5DdLycmCFbDcKIZ95AJ
	EluaUseYUzMd/H//z6KyyQ3K8hny914Y9F6Yign08Hm3zXlNqpDbD8itZbuSJbHn62e3ZWE5/czuE
	JCOK8XOJ0otxROa17U7HISd4idr4mVftEg6R35XTJFGVSYfW+xDcm8qKgAakF6PUnP5FSDbu0Yhji
	QY4RuoLw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8n76-00000001xp4-2zGn;
	Mon, 21 Sep 2026 20:07:56 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/5] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Mon, 21 Sep 2026 20:07:52 -0300
Message-ID: <20260921230755.1133425-2-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921230755.1133425-1-pc@manguebit.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
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
size.  truncate_pagecache() is then called as in truncate_setsize(): it
is essentially a no-op on extend and drops the pagecache beyond the new
EOF on shrink.

Closes: https://sashiko.dev/#/patchset/20260921154957.903891-1-pc%40manguebit.org
Fixes: c510edb9734a ("cifs: call pagecache_isize_extended() in cifs_setsize() when extending")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1fe0ef0a95db..9abb40f871c6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3071,8 +3071,16 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	/*
+	 * When extending, zero the tail of the folio straddling the old EOF
+	 * so that data dirtied past EOF through an mmap isn't exposed once the
+	 * file is extended.  This mirrors pagecache_isize_extended(), which
+	 * can't be used here as it is a no-op when the block size is >=
+	 * PAGE_SIZE, as on CIFS.  truncate_pagecache() then drops the
+	 * pagecache beyond the new EOF, as in truncate_setsize().
+	 */
 	if (offset > old_size)
-		pagecache_isize_extended(inode, old_size, offset);
+		netfs_clear_stale_post_eof(inode, old_size, offset, false);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 }
-- 
2.55.0

