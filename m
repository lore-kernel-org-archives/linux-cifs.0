Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6DF4BEE4A;
	Fri, 25 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347058; cv=none; b=JvKpX0ws+cJXKe27n9xjpAgd62OmYZZZz/gQUYEyE7V94HG7z79Y4qbplaG3HNbWZ3vW4jR48xYlqxEWHUwVlNlzqXEs3WIUh03X8I6b3YkMyJd2Zc2JNykuEyn+MkhQxmkqUW2trAMuO3RPA7Lcp/inlWEL5/R3/JZ3ggJiAk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347058; c=relaxed/simple;
	bh=ew78zaNyP56x+pkuoc101SRLge9BZJxUTpFPQpoLJ1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx3EYHviqQPR2wyPu6vT6DQZQgeBhdMVjCpeOF8BnOivbQvcrbZZJ5Yf1Cl+rUf2GYga3xB96OxVNRtK+SXdXRSrd77Mt+4LdebFq68FmDyO4Uopjxf6hmTNOvTXQrmEXCS6bqESufC+R3WbyyJRzbGbPiChvZKVDrIIm6YFkRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=U3Nnjgky; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="U3Nnjgky"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Rvurhxniq0PoIct8iMYqYpxfD7GQEhsvQofN8jToenk=; b=U3NnjgkyyI0XJfe/FY8cE8KuO2
	TbLs/Phe+qVQ/z7We1ypB+FkwC57KhJFLnrKKiEreHxi7/IVB4yAg4WDn9Wn5rFVXe3spLTzcqRiV
	VTF+5zAbSPOUuw2inc2az3nUrHGGgZQO2orgn5TXaDnA6sdmUtxj7uRFapL+HTnZat4nAQ9h47wK5
	5NzdfP4ZveXf/4PqUdSQegqpF8fJe0BcchNWZXVk2GygPCuEcV6yWIyE4DIm2uphnB35of+3znAdY
	YcrmOM+/hw5HTS9v+Cg7vFPfJdVqi+jE8fS791/oLckS23lLBJrRyNBO1MPdm2XkOhqE+tTsnqzZH
	eNJEaK1g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xA73A-00000002GxV-2emz;
	Fri, 25 Sep 2026 11:37:20 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 4/5] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Fri, 25 Sep 2026 11:37:18 -0300
Message-ID: <20260925143719.2889518-4-pc@manguebit.org>
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

v1 -> v2: no changes
v2 -> v3: no changes

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

