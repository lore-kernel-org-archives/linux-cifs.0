Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C98175A80;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728766; cv=none; b=ckvhno8LOrtA1wwYn9rATAUanZ6AH4kOTvkL6JySUASlEHFOCG+mwu6sHKfwuE1pBIH+NiBLQoz2Z0hgtni/8vF1v8jERkiBdj9/+uUH5Vaskb0S1Aqva37D1qBy3awL1ZtKZfGpC8JBJVtZWc8TyfRHuDJBA5vRh+4m8uTHD6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728766; c=relaxed/simple;
	bh=VYetu5GlmkBYCupVxCStW4KeCkFuwTmWqXDo/0jIqYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbETMVQ3Wjh55FnwLhiahkCDUAFaRZgMrr1DY0n/z6fDjZNqWxWZpiyzWcWAEAZm+lI7u+V1nyYPTYolVD6cbi/p6KHhyKHOLLbFoy7uf3u+crGHkaTPDx2x7uSNGbUfvmh/OKpclxQZ8x0DJY0/1lRF8tRgP6ovZzKCyONbhYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=ykjzdSdv; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="ykjzdSdv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=nigYM/lqtXWmFwckd/9335OFQ7Pfwm1I9E8/VT9wEoc=; b=ykjzdSdvAuMMx7o2teORTxsKxC
	Y5D23UQMtkSTDI5gF1ULcx14akCY/P11kRUfAvw3X+87zfoSLcu0rtgkGKV+6XAwIBLtJo7lP3Huo
	SMR8o7ArSjjziIKxY4/qPucyUwKMP8VHZynKUjqiGIX6bWZb7h43iQgUnvVRNntXp5Gc0lLgfEiP6
	z6kBpoGI1j03nn6i4RRmDpCeTC6qj2pIkc9VAoC+z4hxcT+si0756sLjbWu5EsH9Wxt/Mi7brOvgp
	Qiw0a1UNv2g8/A0JlmZX+gbQ8aGALHEo8Uz3oTg19KRIygVW4WPD2AbKg81uviFZI6uYpYqEw1DSJ
	nIAlFAXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLm-00000002aDd-3Z8S;
	Tue, 29 Sep 2026 21:39:10 -0300
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
Subject: [PATCH v2 05/15] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Tue, 29 Sep 2026 21:38:58 -0300
Message-ID: <20260930003908.1703770-6-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_remap_file_range() discarded the pagecache only for the folios
overlapping the destination region, so when a clone extends the file the
folio straddling the old EOF - which may hold data dirtied past EOF
through an mmap - was never dropped and became visible as file content
once the file was extended.

Start the discard at the smaller of fstart and the old EOF.  i_size is
still old here, so nothing past the old EOF is flushed to the server.

Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
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
 fs/smb/client/cifsfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f1fb4b7b7b7c..6410249f529a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1467,9 +1467,14 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	i_size = target_inode->i_size;
 	spin_unlock(&target_inode->i_lock);
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min(fstart, i_size), fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL, i_size, 0);
 
-- 
2.55.0

