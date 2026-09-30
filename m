Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482152C032C;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728765; cv=none; b=lf2Nm2TCf0RsZkHrrwEUcHyn6C0Ah3dqUMYs5EPON0PNLfxhUYTRQc/Onbx9M7nn9jLPg/KkdbsD68e/P7GCI1gRnRYrrFrAFMCtGFl/lX3UJiIWweatEUqgDYEZULpuqMqlLlxC3rf6nIKPMSaB+fP6Vv4IRPuoFXxUqL35QK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728765; c=relaxed/simple;
	bh=yaJVTPHtQ02sIrFjoKd+Vz1kAFhULtHOgctWBOEq+QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWRJoe45wdJ4YIP/1Y3s04C2oYWWzVMH7q8RyCqMYVHdnNSdRQGxGvY7q//8CKQG1iY2cD69dcJI6xlOMu+/t4tdPP6TobHZWt47LPQizzlI6fMrFXGooX3O2o8MN1ksMGAA37wLz8KupFfKiUgL8bCy967GSK+QJ8qgAx6T/Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=n6qf0517; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="n6qf0517"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=h7o50vqTA3RDZdcBSLVELv1k7Wb9UQhu1h7Epuq2GW8=; b=n6qf0517fiZopxZeXSaRXdbN23
	i07LiBsrM76fXxwxEB6GCU+M8xRk79aL8YriCWwSaQJ8OYfjlp7t9NGUU8yjUJobFCwkgoIRu5oCi
	IjR7qeAChOSpARYCJWNJ6yt9ck89rYoM5/m9D3OlF1gX6LwglWhZfpaY/oh7mjJFBXqMsXgpdPRot
	RUDPNw0TSQJky4natP0F/p1K+wjQDOISyxfXMXQpAgNWRB9SOmLnqCvLaO1zotOUsMfo1DAEbUa5f
	lg2DeKaLKwJLjhDTRsuWBv1AXx1eericoICHRRjRBo4uUCYMrrb3QrQxWS5vSeCy2uwGL3lX7Xt69
	o3GKDQ1w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLm-00000002aDY-298x;
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
Subject: [PATCH v2 04/15] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Tue, 29 Sep 2026 21:38:57 -0300
Message-ID: <20260930003908.1703770-5-pc@manguebit.org>
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

