Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071590;
	b=XqUqMtHnCZ6bXvPX6J3+Df6mKnTrIfQ45x/0cLn75M7g2jn+hmxPgboqjjKYr/MrwITq
	 Md97jUrGYCVxh+E5zbYnRgHeLait9C2V3aKMqs64u/PWkKWNJy6cuS2NB1IVHJ63pIeNx
	 qiT6eTyLtvdX+QZ6M9dwZbLccfcTba1lz/Y+3EiHehD8Wa5Zyze7/q8xC6+TDKfuFVwX1
	 8zOZEJJ6zMxlE5I5osfh7eccRAHK+cRBgKUzcoWGXj3wLTARpr6vvUteqxHEhR3dYxgQf
	 GkB1ivldZHW/32TJQBf/5X4SxmgmUMALGGB4/W4jYyJjmWMCtG5kJ+uem2YdYBAI1SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071590;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=;
	b=4h+nmzfTsUAi/TwujwwZtotmT3fVsYqwH79JBt8064l94oqovbaT1EbTRWXHi/XCW79O
	 0fvXLkUcKhSwP0pJYKZ3Hkw77OJhIydUH/hP54SweZ0h79E16auYbohGDWVluiBhsLx5k
	 Q9DBrZqxfM0CCD/Vfhp6gWJd2nbUjSbQqO2up/2ErEOzcF0u5CAWzhSTBwM6HeYzWAzE/
	 i2G+9GUc7E7XNdfLgmQg1qrU3lGgRJclkDZyGwbY3NludYMQyaZRpZZzXlnLrbxDsrKSB
	 q4dfSgajUVRg8qdl/Eo0PZ7Sb2LYUDm5a5Gr/EEQ1xbALlbitIsz8AzpNMTm4O2Bwag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zsvDE6bQ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A69D606A339;
	Sat,  7 Nov 2026 17:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A69D606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zsvDE6bQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=; b=zsvDE6bQMvx6U5nBZroF2kZhoa
	F1ZIx6+ZmIjXP3OU9gm7R5m1B5ri8RWgyMB8VqkbkiQpzdDAI5bQsfrrrMuNBaiS+D052qmmQDY9o
	VYw6e+ulvAyM6lIk+ANLy24WgvBf02FtRiHEnBjWu722t3UOdsmVJw58XLXcdvP9xvfwDxADAIKU1
	+VcHFLeo33wIxwzxKWVqq5JmCunAqRhKSUz+a+r1dJmwa3+Dbu6aJtBHI8sD+UrZzis4KJG9c9jw0
	Qalg0YvhX86xwfCwU4Br4FmTP6OZdoPRi0zcCgmAOv3aYWw5cmh2ESTDIwEp9bAepmXdUMtTZUJ5B
	nyWW9p5Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyV-000000017gW-2USR;
	Sat, 07 Nov 2026 14:13:08 -0300
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
Subject: [PATCH v9 09/19] smb: client: don't block dying tasks waiting for writeback on close
Date: Sat,  7 Nov 2026 14:12:55 -0300
Message-ID: <20261107171305.2847361-10-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

