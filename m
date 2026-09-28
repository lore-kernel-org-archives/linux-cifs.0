Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D494F85D4;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626190; cv=none; b=LFFqX5Z2YOVRGoUMhpl9UtBBm+mw9+P9akFFzcS1YTiYKPP0JyWoiE434p1HnmpmN2SbXmwHR122RRKicHgmpRd2b22uBmfQr/xNxNpiZ9pfGJILPFoOhRXScPYYUErwAYVcGTWgJh/gGPDkYIZx2f2/t/2aN9tb433Gj2FvNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626190; c=relaxed/simple;
	bh=mDBHZPF8zj8e0WXLyrp6O9RhymdnjYnwcDQyCnRkrhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJV/wbsIQoOv0N1umKVdHFoeNc1XkabnCjbojitsKYlx6eF6xIARi4vcAyWWNADt9+UIQAfTfmY/3hqbVA7fO85IS7iQDgRHyCXIYsOLXKvUxsgZ1fDQWLd3vpsmfJb+NMYWx+olKJP586KOWT9yizb0gqhkMXy+Wp9ZnYcNGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=5XzT11+6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="5XzT11+6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=5RH6PGe6vhJqEKuFZvv0BM6ojHDK12l+VcnI08KERlQ=; b=5XzT11+6hO1n4SyNXg2jkks0QW
	LGz9ipoBLo1AzgjygHciZitR8us1Dyakco7mRklcANLQ4wA9zHU37ZBNK0/CXnJWn6GqBEaPdgQ5U
	1wQxyTyEIM6G6cvVSjohoBjOnJ8DdUZV+MSPlOmxLQ5K7fkXqJ26YJTPj81bl48bxqInJhNjLpb2b
	tpFqDQJIFX45gjHTXeKi/bSuhU6VktOC97dzeQdRmYiTbJ8JHRXMjfC86vk0PhOE2dkrQqNq6iG/N
	aOwNi5e7YMx1JjfqC+tswtczfc3G3dI7qdItltNCCd7zD9u3m0YR8+DtDsqsqP2anUafE4+5Ti9w1
	FlwL9ivQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfL-00000002UJC-460y;
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
Subject: [PATCH 04/15] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Mon, 28 Sep 2026 17:09:23 -0300
Message-ID: <20260928200934.1040189-5-pc@manguebit.org>
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

cifs_file_copychunk_range() invalidated the pagecache only for the
destination region, so when a copy extends the file the folio straddling
the old EOF - which may hold data dirtied past EOF through an mmap - was
never dropped and became visible as file content once the file was
extended.

Start the invalidation at the smaller of the destination offset and the
old EOF.  filemap_invalidate_inode() writes back before invalidating
while i_size is still old, so nothing past the old EOF is flushed to the
server.

Fixes: 8101d6e112e2 ("cifs: Fix copy offload to flush destination region")
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
 fs/smb/client/cifsfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 7ecd70efdfea..f1fb4b7b7b7c 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1581,8 +1581,13 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	/* Flush and invalidate all the folios in the destination region.  If
 	 * the copy was successful, then some of the flush is extra overhead,
 	 * but we need to allow for the copy failing in some way (eg. ENOSPC).
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	rc = filemap_invalidate_inode(target_inode, true, destoff, destoff + len - 1);
+	rc = filemap_invalidate_inode(target_inode, true,
+				      min(destoff, i_size_read(target_inode)),
+				      destoff + len - 1);
 	if (rc)
 		goto unlock;
 
-- 
2.55.0

