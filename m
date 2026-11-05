Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=RV2NuH5MvVTy+A/81TEadMhkpKpUJZP2r563j4Ui9QMrfT7w4hd9Ygtu70DY1F2zkyAk
	 uYb3rhyfpw1ww2ytdxFSghIif3kZ06Uxi8XTVYbR4yR0Bw2m8dnBB/eGr3j0Q4cnSWZjM
	 ZySOgHoHN4ElX7Mw7ncxU/UFDKugKcl94iuxhXolGidlSbwZQ0i+sOz4O8Ag6gnPUpXyo
	 N1Vf+k3NTBCxgcgWIhj4fsw0q8kyHOpHwkSyBm7ppWz2H0s3dx795vwhFHz9RaCcIGK9T
	 fcX604NXGglmAxnyVmz1Jx7JYvi7YObBPeEOZHiSUwDtJzZPskhzXM56HDBeG8+WsFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pSSvjUHixkiJ+BWiT7OYxD4v58sUh/VX4fp4VpFF4OA=;
	b=Do3OALKclyIQfV1hmb9XrB+csKfMRUMtqgVTnuw/3Mfm9TRHTZdtTpYxgAwXrMuyFtWY
	 Y6r2bjC7x52aff626+DnYLQ9u2MHKPnaxRDvCFoNcESbZB2YQy3yFO76GMBXczmuHG1Iu
	 blImBF0TXtnTmGzhMP6eYJVJSIPAGoTttACXzP9n9xhXovidHylJ7dB2NarWOMN7mnxeA
	 L9WCSDE+B6JJJux1Q+W9vYSLa0A3qdyQHfjD1osUouU3rhON/JNmCZiqxI/A/VeKA7OJC
	 fthbASEckay9joE2cq/+XaGCY80qsnBRKIr9fWqZAa6hZdGdR6y/IaSlzjGavKTRD2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=EFyh9ubz;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FABE606A330;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FABE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=EFyh9ubz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=pSSvjUHixkiJ+BWiT7OYxD4v58sUh/VX4fp4VpFF4OA=; b=EFyh9ubz4smrNyJhY+UXM1Y6bj
	+a3kKtNCFq0uzNcjWrEsBCZvbdmEANfxpfAiV4z22RYka5y3eB7G1zPYZRQL9/Kyie2aFYgZfWYnF
	PArPGGlMtl/eUILjjCOel2e8NB0tQYNTFXzMWOxcVdukM3/srmOYYUv5MKjyon14ivkXaQl8HOFgN
	YlE5uMv3JTA2cfCyQaeKL8xGNibCbTI8fpTeiz7fxNL/u59KUycQ1kI7lHX+NZxNq4SwcuwtMkptm
	uGfzigqgS8wYfQtaOqMZ/wRJmcZx3qhEMRG8A3Ocu+b1jFmTgyoARiMmMFRvv6OiOyn2lyjRgTOpb
	6+2SWabw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D7-00000000ynl-1lHE;
	Thu, 05 Nov 2026 19:45:34 -0300
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
Subject: [PATCH v5 07/17] smb: client: don't block dying tasks waiting for writeback on close
Date: Thu,  5 Nov 2026 19:45:21 -0300
Message-ID: <20261105224531.2316211-8-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
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

