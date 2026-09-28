Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841D74F93AA;
	Mon, 28 Sep 2026 20:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626195; cv=none; b=QrRt423nJcTUfa2YPjnLn21ihilHy+5qQO911L+btCUuFAH5rlnJ/cZvqBczlyLQsJ660uP4Hy44Goljj1/T/jKm5f7Z7fzx7LIifRoRpeDKPP1wzplZwXhHH8f/ZfuGqY4L6VnmcCvnuHxeO2N1UETH0cOlXfGNx2APl2aQZ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626195; c=relaxed/simple;
	bh=XtgXPbvqvMQ+hskJ2r57H4SaGe5VnYQZyYwLVvA6JTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMEAGwABHE3Q7303YaqhOank+oAjbkDNzPKTDDfa5MJgu1sQ/Vp00flSk8D3Te7v0PdGXLADZutSxYbOZPaDOccnN4U09I1NyQ+K+0vt2Zr+s+NB4LKvS+eTu/oBGQ/5/yXDYVo2Ueg4J1GWPsAJfNWxsvx55TMbMS8cNA3i88c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=74EjPrKZ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="74EjPrKZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=V8ox/IuAOvkr7xPfizrxTLdqzpsg8oYewy1FzbkI+nw=; b=74EjPrKZjbky1PhZrdvZCoP8X6
	tOvE0ieFWM98Mn1UB/FPimLFoGA7FQlwmDD0D5b0zxjW1JTeWVyRRZxI9OArV7TXZtlr2By+Gojnf
	3YnHmYO7MMDq7ReNRGZhD+ISZqyAn/fjsorJOpG0C+TDFY1xkFesm1ZkXCDwq0orVDDe65aadkWGC
	Od6fr2cv4c3mdqFbEQ/7mks8/PdoYD+JIYJuSOZu5w8JL2fV7c5XQlQvB6kQ9QqMdm/Co2ZoPYbQv
	c9o0cAPVgVoUDxmgZLMFf3hWlG7fS9ci4Dg+vzq2dquFp91MOZ4JSeMM7c/ndEiE1555LT7viywCa
	NUVS4h8A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfN-00000002UJb-2xoV;
	Mon, 28 Sep 2026 17:09:37 -0300
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
Subject: [PATCH 09/15] smb: client: drain and invalidate before server-side copy/clone
Date: Mon, 28 Sep 2026 17:09:28 -0300
Message-ID: <20260928200934.1040189-10-pc@manguebit.org>
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

cifs_file_copychunk_range() and the clone (FICLONE) path of
cifs_remap_file_range() do not serialise the destination page cache
against the server-side copy the way the other server-side range
operations (smb3_zero_range(), smb3_punch_hole(), smb3_collapse_range()
and smb3_insert_range()) do.

cifs_file_copychunk_range() invalidates the destination range with
filemap_invalidate_inode(), which takes and drops the mapping's
invalidate_lock internally, so the lock is no longer held when the
copychunk ioctl is issued.  It also never drains in-flight netfs I/O on
the target.  The clone path never takes the invalidate_lock at all (only
i_rwsem), uses a bare truncate_inode_pages_range() and likewise does not
drain outstanding I/O.

As a result an asynchronous destination writeback can complete after the
server-side copy/clone has run and reinstate stale data over the region
just written by the server, corrupting the file.  This is the same class
of corruption as commit d7d2adcd022b ("smb/client: flush dirty data
before punching a hole") and has been seen randomly in generic/363
against Windows Server.

Fix both paths to follow the established ordering: hold the target
mapping's invalidate_lock across the flush and invalidation of the
destination and the server ioctl, and call netfs_wait_for_outstanding_io()
on the target to drain in-flight writes before the ioctl is issued.  Only
the target inode's invalidate_lock is required, as the source is merely
flushed and not invalidated; i_rwsem (already held via
lock_two_nondirectories()) is acquired before the invalidate_lock,
matching the VFS lock ordering.

Fixes: 8101d6e112e2 ("cifs: Fix copy offload to flush destination region")
Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
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
 fs/smb/client/cifsfs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6410249f529a..a650c8022d0f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1412,6 +1412,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	if (len == 0) {
 		loff_t src_size = i_size_read(src_inode);
@@ -1475,6 +1476,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
 	truncate_inode_pages_range(&target_inode->i_data,
 				   min(fstart, i_size), fend);
+	netfs_wait_for_outstanding_io(target_inode);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL, i_size, 0);
 
@@ -1513,6 +1515,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (rc)
 		CIFS_I(target_inode)->time = 0;
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
@@ -1565,6 +1568,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * server could even support copy of range where source = target
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
+	filemap_invalidate_lock(target_inode->i_mapping);
 
 	cifs_dbg(FYI, "about to flush pages\n");
 
@@ -1590,11 +1594,15 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * Start at the old EOF when extending so the folio straddling it, which
 	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	rc = filemap_invalidate_inode(target_inode, true,
-				      min(destoff, i_size_read(target_inode)),
-				      destoff + len - 1);
+	rc = filemap_write_and_wait_range(target_inode->i_mapping,
+					  min(destoff, i_size_read(target_inode)),
+					  destoff + len - 1);
 	if (rc)
 		goto unlock;
+	invalidate_inode_pages2_range(target_inode->i_mapping,
+				      min(destoff, i_size_read(target_inode)) >> PAGE_SHIFT,
+				      (destoff + len - 1) >> PAGE_SHIFT);
+	netfs_wait_for_outstanding_io(target_inode);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL,
 			   i_size_read(target_inode), 0);
@@ -1626,6 +1634,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	CIFS_I(target_inode)->time = 0;
 
 unlock:
+	filemap_invalidate_unlock(target_inode->i_mapping);
 	/* although unlocking in the reverse order from locking is not
 	 * strictly necessary here it is a little cleaner to be consistent
 	 */
-- 
2.55.0

