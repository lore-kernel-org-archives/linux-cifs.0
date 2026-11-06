Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=QiDEY8AvIyHZS87vbOGQvN9150dTwy3p3Xv2HCBGNp8iC/79mvn9UU5H5VCuQXO9dNU9
	 kxSa2bITT+/Zod19UcTwD3Xoad1QWTKK6fWRU1CKoTKAu86MKEWUeUEO6cF9k025zloYS
	 Vfx9v5reW1Ae80MCZZ+LjsSm4xv1zkwspOi5tnbDYRxWCS5KG+fJhSJGMkYFcDyGo8Mo4
	 sZ/U0ZxwJMLcRP3/SX8+kvjUl27ZvQsByNbO/S7VOHM0ZcIMlIPwkJPD6xihURXYFlgRV
	 qEaTDlO/yBEFELFx8RC82oA8R9Sk0zpm3TmQ8MQnTGi8KWkA+NpLwTK7owMIa5+hGIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=;
	b=dqjF/BFkSrMuH9QLyzC8hprqA+B781r0Fv8n552eJr9HMvW6wsfuywQuLfXpY/SdDmjL
	 FP7L3aXlU9iPknxch6v/boKe1U4SdesE8PGAjTLxEkxevwJ3UIBsIle294JouEHFoQTv0
	 fPqgsgwxE/YDqDBTnyUbmFm5L/vEr+g5rGvUvOle/gQXUap0wJLOn4IPqW/GgwaSAwvT8
	 nE0SW1SDLgW9Lct2jxz/IQMDVvS819DveVdTsuSqNmufbw0uOSbdk90gAtajJRitzBiRl
	 8gUF8svIC859fd4ZH97wmzY4lnMoqlvA5Vcqyk9pbwfElwdXpeuSSAQcEFyqKHbFELA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="Q/7JFiKH";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AE1606A337;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64AE1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Q/7JFiKH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=vmRasZkESt+4ySlgiTwmAk3HvI6cvw3h3x2Z334MR2A=; b=Q/7JFiKHLZToVTb9j4ZsR8ieCT
	yPzkix9uvurAESmW6nIrsO6/CKA6eIcOp7vlZ0C+Z9sH7YmoWthvu2micotdIZzZngPUhphBr2b2p
	p+2iFNEz6sMdZg0CTkix8xr4iCz5X9u4fBy0OJKQ+kJ9l/IIJBeBkAo9Zp7dJW3XAc6J1r5qrEWCc
	2guUZaSb+5CwY+VMP9/pLvhuXpDcBDUite79GaEWAX7WoocULgHUS0snaQRxWlwmPLbFDknjOuJZo
	+ZYwH+0gphuBJvVIzXCOkj+r+frkJ51JXV3EJIEqz8SRB+35BtKwKsMlt8sCd3VrumKh0SH+PQsK1
	vgphBMag==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCX-000000014FA-3yeK;
	Fri, 06 Nov 2026 20:18:31 -0300
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
Subject: [PATCH v7 09/19] smb: client: don't block dying tasks waiting for writeback on close
Date: Fri,  6 Nov 2026 20:18:17 -0300
Message-ID: <20261106231827.2604956-10-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

