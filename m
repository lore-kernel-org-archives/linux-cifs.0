Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5213B2FC0;
	Fri, 28 Aug 2026 23:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787958736; cv=none; b=oq1yiMCqdz2B3/bFwzs4lfZujNRYfClVlFMediEwVu4IPTCeioLPEzH2EKDmUwlHaUFSKAFOTrmnb7OaQ0YjovfbR+v/MLxTEB/UXA52+01PSA80+7TxGlp2sGfe7P7da2cXt70kBZCiNkHdYHFPOM6RVaFhG/0qhT2pPYa6Cm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787958736; c=relaxed/simple;
	bh=aik7yEGuzFZ0G7w7mVb/h5YmMlqxfV562rhwKoGX3HY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EIthHbWHvzglF8lB0MpCUPXP8ZqvpDs2s88zLako3HKUFpd7ED3uONnwdg8OBUgeLWWLcFa0hgNblTD2kEMzOx4FLz/fiJ1KCXzbGg6wynFcfR2TdgAMF58YY0bVUJIz74vhINwTdJNmzjshad23smtQ/RrnjaZlagzLweluFLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=5bKO28nV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="5bKO28nV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=0ORYIgn8mBF2W/OooZJxk3ndtk6ERqX3GaJKPO2K5Bg=; b=5bKO28nVgD8g853Y+FLkmIdZSn
	m/DFb9YDoVYCjO+Q6lDmGwDtzzOJIJ6oXPR0qmhsNTHQNat+1iwlUxAOXmr+ErmUlvi2H36XMFVzI
	RtDmrGI4QfCKNtaFXVJRe3tc+pZ8ERva38WqIq5Uznyh9icXj2Dj1/sX+n7A5rO5+Hvv2b66t6HLP
	gOwfV0YzvEvX9VXas+eRUn0zSvKVycjC2m47Okq4af+dFN2KHEJh46VAkcQ0J0OpJkE+6AXy3Lupv
	MPZ0bpJIgpXaAZQzwlfxsroVSFgp4rAHAaieNRKYy6hPnVPkPTnYccSXbXPjtRO6ErwLIb+uMKY4h
	luB1Erzg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x05k3-00000000CNm-1Uu0;
	Fri, 28 Aug 2026 20:12:11 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix data corruption with concurrent writes and O_TRUNC
Date: Fri, 28 Aug 2026 20:12:11 -0300
Message-ID: <20260828231211.252093-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_do_truncate() flushes dirty pages with filemap_write_and_wait()
and truncates the file on the server, but in the old code both
operations ran without holding i_rwsem or invalidate_lock.  A
concurrent buffered write via netfs_perform_write() -- which only
needs i_rwsem shared -- could dirty new pages after the flush but
before the local truncation, and those pages would be silently
discarded by cifs_setsize() -> truncate_pagecache().

Fix by acquiring inode_lock (exclusive i_rwsem) and
filemap_invalidate_lock at the top of cifs_do_truncate(), so the
entire flush-truncate-resize sequence is atomic with respect to:

  - buffered writes (blocked by exclusive i_rwsem, since
    netfs_start_io_write takes i_rwsem shared),
  - read page faults (blocked by exclusive invalidate_lock, since
    filemap_fault takes it shared),
  - writeback collection (blocked by netfs_wb_begin/netfs_wb_end
    around the server truncate and local resize, since
    netfs_writepages also acquires the wb lock).

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 100acc76e9be..61f9c6ccc6be 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -999,42 +999,50 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 	struct cifs_tcon *tcon;
 	int rc;
 
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (is_interrupt_error(rc))
+	rc = inode_lock_killable(inode);
+	if (rc)
 		return -ERESTARTSYS;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	rc = filemap_write_and_wait(inode->i_mapping);
+	if (is_interrupt_error(rc)) {
+		rc = -ERESTARTSYS;
+		goto out;
+	}
 	mapping_set_error(inode->i_mapping, rc);
 
 	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {
 		if (cfile) {
+			struct netfs_inode *ictx = netfs_inode(inode);
+
 			tcon = tlink_tcon(cfile->tlink);
 			server = tcon->ses->server;
+			netfs_wb_begin(ictx, false);
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
 			if (!rc) {
-				inode_lock(inode);
-				filemap_invalidate_lock(inode->i_mapping);
 				netfs_resize_file(&cinode->netfs, 0, true);
 				cifs_setsize(inode, 0);
-				filemap_invalidate_unlock(inode->i_mapping);
-				inode_unlock(inode);
 				cifs_invalidate_cache(inode, 0);
 			}
+			netfs_wb_end(ictx);
 		} else {
 			/*
 			 * No cached handle; evict stale pages so they can't
 			 * be served after the file is later extended; let
 			 * the server's O_TRUNC open response set the i_size
 			 */
-			inode_lock(inode);
-			filemap_invalidate_lock(inode->i_mapping);
 			truncate_inode_pages(inode->i_mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-			inode_unlock(inode);
 			cifs_invalidate_cache(inode, 0);
 		}
 	}
+
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	if (cfile)
 		cifsFileInfo_put(cfile);
 	return rc;
-- 
2.55.0

