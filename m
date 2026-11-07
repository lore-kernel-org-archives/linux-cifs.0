Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024588;
	b=dbqCcER8M43MyKDD4D+Ng+v7qEE2gydzuws0tj8kKg58B2Bj31TNL8ePdJYMQo1/6mwy
	 nRKwH3WR0qBXLq6COxvqmygQe1thvX1FQVcspRty5jAvUkdDzi4s940+YbKwfLKq7KVNZ
	 dqIy1NWA3s+/hgz49TNF/my6oBotY2zA84CFZIiZnElHghEdZRYCqM5/xP71mSfVpKuDm
	 lUrx+yprYD7SnDledRl4dYX7RigUEE+3lK0uTcB8t3EayQoPlw4NNMSkwWz/XRT273rDy
	 HfGGRvCNU9dngDPT3wsZAZOhdokfRYBAUo6FK2h0vZZFs9bo0GxYYqlQUoZ0Tc89lMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024588;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=;
	b=TvEEaQ7aKy0/tXgKgMRKun3WV+gRZ3QO5Hf/TCSixoGl/CRBUTedrmFIKVjg7lLCp30x
	 xAZubxr3ntbJSnni/YngC0OEJ/FlA52g6QygrLGtc4Doejyk806DeWa/RM8QDu8m7j7Lu
	 i3zzj6Zzb550sZOz/kXxva0pHCOSBPImeoTdN8ZaLZbFxw72Ugdw8nnA2Jdl6YaIaYZsJ
	 w1AqZCOYDkuydjWFwW3mXgU0GBjfmAkXp6acAOSJiwZvdp1/UxEwkQqRTsGyhu9mXLT60
	 razlZH0wAMmPtp8tYA9M6RjfGfMrVwwUS3bAB/PldvPVved8TDLbgjQGvnY0zdY0uCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="PNaYVi/6";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E936606A32E;
	Sat,  7 Nov 2026 04:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E936606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=PNaYVi/6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=; b=PNaYVi/6SbkxoGO1EJ3wjzHGZx
	rod9maRi/wacHKsWCJxgfmW0i84lsJS//AdWLDRBvG3gJya8bBGe9FNEqmiHc4HhF0p5SbkvPjFnZ
	WjJIeebfqcc1s72H2D3kZP0mB+Z+c53K/k+IK3gfEjoAnOLLw71BUbOdzPC7mHGgnkeL9Yl7a9Xo1
	3hBHkHji0z+1uJlr0ckG3QEldNBDBG9jAM883d4qEaiVlVqSp3XngZxCziH7nb+sJMMHw273pWVHy
	HS92oN/WX/0kMKXPeTeMBsNZI73MuZq0dpVAoayJ2NzXT7bHytCLr6PlXkWbh+RRznBoIqOLsWcwc
	Q88p63EQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkN-000000015Mt-0e6X;
	Sat, 07 Nov 2026 01:09:44 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v8 09/19] smb: client: don't block dying tasks waiting for writeback on close
Date: Sat,  7 Nov 2026 01:09:30 -0300
Message-ID: <20261107040940.2692656-10-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_flush() waits uninterruptibly for the writeback it starts.  A task
that gets killed while closing a file on a hard mount with an
unresponsive server is stuck in D state until the server comes back.  It
also consumes any writeback error for a caller that is about to exit,
hiding it from everyone else.

Wait killably instead.  If the closer gets killed, stop waiting and leave
the error bits in the mapping for others to see; writeback already in
flight completes on its own.

This is also needed before letting dying tasks issue their writes from a
worker, which would otherwise make them wait for every one of them.

Fixes: d3f1322af8f8 ("cifs: wait for writeback to complete in cifs_flush")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index e8557c670dc3..0d2db0dd43f2 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3043,17 +3043,43 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return rc;
 }
 
+static int cifs_wait_writeback_killable(struct address_space *mapping)
+{
+	struct folio_batch fbatch;
+	pgoff_t index = 0;
+	int rc = 0;
+
+	folio_batch_init(&fbatch);
+	while (!rc &&
+	       filemap_get_folios_tag(mapping, &index, (pgoff_t)-1,
+				      PAGECACHE_TAG_WRITEBACK, &fbatch)) {
+		for (unsigned int i = 0;
+		     !rc && i < folio_batch_count(&fbatch); i++)
+			rc = folio_wait_writeback_killable(fbatch.folios[i]);
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+	return rc;
+}
+
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
  */
 int cifs_flush(struct file *file, fl_owner_t id)
 {
+	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file_inode(file);
-	int rc = 0;
+	int rc = 0, rc2;
 
-	if (file->f_mode & FMODE_WRITE)
-		rc = filemap_write_and_wait(inode->i_mapping);
+	if (file->f_mode & FMODE_WRITE) {
+		rc = filemap_fdatawrite(mapping);
+		if (cifs_wait_writeback_killable(mapping))
+			return 0;
+		rc2 = filemap_check_errors(mapping);
+		if (!rc)
+			rc = rc2;
+	}
 
 	cifs_dbg(FYI, "Flush inode %p file %p rc %d\n", inode, file, rc);
 	if (rc) {
-- 
2.56.0

