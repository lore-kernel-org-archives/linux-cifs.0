Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98BC3F44FC;
	Mon, 21 Sep 2026 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032085; cv=none; b=c0NYWQkQV8YkMAfMMwU9N7tTc2adiDwRysW28heGFHOE++e2ha1oFQvdseDj4JDIB42QGCaTTcb6br6BlxqtL+2fc6UPgYGa/cKghYQ2CaXyp2vrNibleMLw2F80JCehSKVPu01WtieIgTnkiGiMOd7PdrdYT0FiRYywxra4M+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032085; c=relaxed/simple;
	bh=mO1Q6o/KgWEmLo/X5UeOaKF3RGYwnhN8kQubbqxYmOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsuPU+J5Efor/cP1o4NwwahIYNr0hglw18TSzimK90PWgBXyBTrCkn+0QIg0lCSmSQ+kuQSTQ+7zBoCETf8neHj3SkWoSdXxjRt67ODUXP8krKbx30YZRgaU1l1Ti3gwO6qhT/DFu9zCkr1zgchkbn7KdFOpgmdF9YZWPx3n+ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GtEj5G0S; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GtEj5G0S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Qu3yhx/bEbobPer+L/YgEZ1ItCwhUqJNwO8CbwoEukM=; b=GtEj5G0ScyAH0ZUaZ8Wjuw5EqS
	fQelOp7qK/ho8w7koWPKWykLxEWiIn19TXu+0Cb3KDdHXZlFjupaznCIYP7zzi1SG8QfvpQv80ndQ
	+g93l+PadWBNL0VtO6j+EJBhc2F+ujvBxC9Swk0Hyb2CBspbPTy/vx0vPdoJ/TnrP8RHR9VgJpy1w
	Rk+lIABPuFMcF9fgVUh0ExPmy3tOpkTs8c1iMQ+mNlJupDapQ+mZ9PJLEDHfCaSzyTXgPVMeyJpjW
	coXK5ihJhwghKEe1AIdD5DtRV9CJyjOW8z8nohKcZDUs1bqjWrE8Iw/qVb+K1vLTBZicW1VYN9AEs
	fA30pZSQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8n77-00000001xpE-1gp5;
	Mon, 21 Sep 2026 20:07:57 -0300
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
Subject: [PATCH v2 4/5] smb: client: discard post-EOF pagecache when extending a file via copy range
Date: Mon, 21 Sep 2026 20:07:54 -0300
Message-ID: <20260921230755.1133425-4-pc@manguebit.org>
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

