Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D973D3329;
	Mon, 28 Sep 2026 20:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626198; cv=none; b=m0KGl9cGUpwPrnFl7+vEoiLG8tQAPkCHowGncbMIy8+TqS456YmoUG5Kvy0ahjWwYiEhuEiziwuZQ7exmUEHWqwOTk5tLBOnRA+Ptf02VFemAlFkaniDN9jD5TQl6jLE9FJceLMm0SLyQQ1fvLO7b0+Pp617KJWqpbNl3dok3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626198; c=relaxed/simple;
	bh=0LO1RHt4Pq+qBgzr5nVQwtooVTfZJu4UtIHTlpcs81Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nd2jS2uVpkB+cz3+PvsQDZGZOpmXl4fTnnD5iQmGm2J97Cl9pflS31eSHtaSpgRn2ZtMNi299e5u82tTCU5u8PZg68YoEG6Oot4d1EmpKe0CyjGm+bts8iJ43tVo+Hxv4xetxppVqZ94kHphBfdLycnkKJKS6OpyP7NokNRSoXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=tx+Jz++o; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="tx+Jz++o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=2PvsbJq0joI/eev6mtK6X6CXDL0Cnn/N0tKmL1Ep8QQ=; b=tx+Jz++orUW1qZutxBRng7W3/Q
	NYjLkvPYsD8a8m5B6iJZM1+Mxel6DCWEua7uGnqf9idM2rO1PFDlsSkknSmtH0d7HkPlH4oF7mHnc
	Y3uNPARRPLT6IqYIKt2i9faq4mRwX/FNFxyazRb5yfT+JcT5VZKZLYShWn5tBm8gCyoFJ9BZUZycS
	RDSXwkKzx7hPLhu+b8zu8vntlYTLl1P35XtlnqtNKbpGFFiRcnFtKbUrB9u7V1KvrFGbHfzoyNeWe
	HMvKlquaCW7rOB3qa4MYdqxOO5sV3yejqYTmVvEb9+kgV3EY6QtjZPUUvvYyluiw2JH6yeqXPnk9S
	bowLwpsw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfO-00000002ULD-31oN;
	Mon, 28 Sep 2026 17:09:38 -0300
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
Subject: [PATCH 12/15] smb: client: only require read lease for size-extending preallocate
Date: Mon, 28 Sep 2026 17:09:31 -0300
Message-ID: <20260928200934.1040189-13-pc@manguebit.org>
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

smb3_simple_falloc() refuses any fallocate that clears FALLOC_FL_KEEP_SIZE
with -EOPNOTSUPP whenever the inode is not read caching:

	/* if file not oplocked can't be sure whether asking to extend size */
	if (!CIFS_CACHE_READ(cifsi))
		if (!keep_size) {
			...
			return rc;
		}

As with smb3_zero_range(), the read lease is only needed to trust the
cached size when deciding whether the request extends the file. When it
is not held, the size can instead be fetched from the server, which is
authoritative, rather than refusing the request outright: after
flushing, query the server's end of file and take the larger of it and
the cached size for the interior-vs-extend decision. The larger of the
two is used because the server's end of file reflects another client's
growth while the cached size reflects this client's own writes that may
not have reached the server yet; using the server size alone would
wrongly treat an interior request as extending when a range flush left
an extending write unwritten.

Rejecting interior requests is observed as generic/363 randomly failing
against Windows Server with

	do_preallocate: fallocate: Operation not supported

fsx issues an interior, non-KEEP_SIZE preallocate while the inode is
transiently not read caching: the server had just downgraded the file's
lease from RWH to RH after breaking the write caching, and the ensuing
handle reopen/revalidation left CIFS_CACHE_READ momentarily clear. The
range sat within the server's end of file, so no extend was needed, yet
it was refused and fsx aborted. This keeps the emulation correct even
when a genuine lease break from another client leaves the inode
without read caching -- the case the -EOPNOTSUPP guard turned into a
hard failure. The extra flush and round trip only happen when both
keep_size is false and no read lease is held; every other case is
unchanged.

Fixes: 9ccf3216238c ("Add support for original fallocate")
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
 fs/smb/client/smb2ops.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 45d5c66f1ad9..c97d5a9db575 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3880,14 +3880,28 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
-	/* if file not oplocked can't be sure whether asking to extend size */
-	if (!CIFS_CACHE_READ(cifsi))
-		if (!keep_size) {
+
+	if (!keep_size && !CIFS_CACHE_READ(cifsi)) {
+		unsigned long long server_eof;
+
+		rc = filemap_write_and_wait(inode->i_mapping);
+		if (rc) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
 			return rc;
 		}
+		netfs_wait_for_outstanding_io(inode);
+
+		rc = query_server_eof(xid, tcon, cfile, &server_eof);
+		if (rc) {
+			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
+				tcon->tid, tcon->ses->Suid, off, len, rc);
+			free_xid(xid);
+			return rc;
+		}
+		old_eof = max_t(loff_t, old_eof, server_eof);
+	}
 
 	/*
 	 * Extending the file
@@ -4013,7 +4027,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 	}
 
-	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+	if (keep_size || old_eof >= off + len) {
 		/*
 		 * At this point, we are trying to fallocate an internal
 		 * regions of a sparse file. Since smb2 does not have a
@@ -4042,7 +4056,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		 * ie potentially making a few extra pages at the beginning
 		 * or end of the file non-sparse via set_sparse is harmless.
 		 */
-		if ((off > 8192) || (off + len + 8192 < i_size_read(inode))) {
+		if (off > 8192 || off + len + 8192 < old_eof) {
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
-- 
2.55.0

