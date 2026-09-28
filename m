Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC00F4D7D48;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626193; cv=none; b=SWgzDIdG3HHMMJchLHZ8wSGt0/AYER4qY/RDtTknZYfi7lWF9oUa3Z1kRwrdfwbqweH1vxK9rjJEhdzEhaDYRWHR86RLwXTUnnMoqQoG7tQFKnRxrMu/ceyK/3OgTwQg2bVAQ5w7WBy/vuottblAivrxpHH+r5R2YbZ0p4I1WeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626193; c=relaxed/simple;
	bh=aUAMiskV7BBWe1i8QtgrkbKJbU8eawJAi0cyE4KHY8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yvz35ci4ZkRsgJqub6hRVxWqijazo2pwuUpUAjnb6evqWD5IjDf0eHvt4/3gyUGHqLoxTu4CADI2WDFvvoifCBT3SuIze4zULLr9EnCc6iQtInjEo3r7pFKfERwZgqWNo9RLJo1nVtiHaYtW11FSosnc+YRgrl91sCzpNgLeg6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rbU+BLnV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rbU+BLnV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=t2NhoLZ9pqbNAZyYAKYLTM/ZaoIR3qEMdvPqqh/ziEA=; b=rbU+BLnVeMdmE/YTEqhkLZp6Cm
	S6rTeQpcJaeOPxmuwY5dep9iXD5DU0sOilo8+5yCVdh/M1uHbH7Q2j5+x16MUdWTDDP12y8V0ya8x
	HXh5TsKqeN6j9xqqndyfSlipuRshc1D/EHtOY04mGi1MjuvtQleSGc9zkcR4mU7FoRvlAobAW0o5M
	1kT7+v/V+kZntqy6XLb2yQYZojvlkXq/I0GE/Xw+KAWf7HxCUDwXEafIuK7zovuKmdxA2/zvCJmmv
	RXpxy40sUt5sQ8qmBO2rMVjJLQTUjJ/zWFcvOZj3fZIudWsHO32SVb7Rt7PdvaYzoLOcTP8w1UCWV
	PAvuedjA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfO-00000002UKp-0CAO;
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
Subject: [PATCH 10/15] smb: client: only require read lease for size-extending zero range
Date: Mon, 28 Sep 2026 17:09:29 -0300
Message-ID: <20260928200934.1040189-11-pc@manguebit.org>
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

smb3_zero_range() refuses any FALLOC_FL_ZERO_RANGE that clears
FALLOC_FL_KEEP_SIZE with -EOPNOTSUPP whenever the inode is not read
caching:

	/* if file not oplocked can't be sure whether asking to extend size */
	rc = -EOPNOTSUPP;
	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
		goto zero_range_exit;

The read lease is only needed to trust the cached i_size when deciding
whether the range extends the file. When it is not held, the size can
instead be fetched from the server, which is authoritative, rather than
refusing the request outright: query the server's end of file and take
the larger of it and the cached size for the interior-vs-extend
decision. The larger of the two is used because the server's end of
file reflects another client's growth while the cached size reflects
this client's own writes that may not have reached the server yet;
using the server size alone would wrongly shrink the file when the
range flush above left an extending write unwritten.

Rejecting interior ranges is observed as generic/363 randomly failing
against Windows Server with

	do_zero_range: fallocate: Operation not supported

fsx issues an interior, non-KEEP_SIZE zero range while the inode is
transiently not read caching: the server had just downgraded the file's
lease from RWH to RH after breaking the write caching, and the ensuing
handle reopen/revalidation left CIFS_CACHE_READ momentarily clear. The
range sat well within the server's end of file, so no extend was
needed, yet the range was refused and fsx aborted. This keeps the
emulation correct even when a genuine lease break from another client
leaves the inode without read caching -- the case the -EOPNOTSUPP guard
turned into a hard failure. The extra round trip only happens on the
no-lease path; the common cached case is unchanged.

Fixes: 30175628bf7f ("[SMB3] Enable fallocate -z support for SMB3 mounts")
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
 fs/smb/client/smb2ops.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6e1682dedb87..45d5c66f1ad9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3520,6 +3520,20 @@ static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
 			  0, NULL, NULL);
 }
 
+static long query_server_eof(const unsigned int xid, struct cifs_tcon *tcon,
+			     struct cifsFileInfo *cfile,
+			     unsigned long long *eof)
+{
+	struct smb2_file_all_info file_inf = {};
+	long rc;
+
+	rc = SMB2_query_info(xid, tcon, cfile->fid.persistent_fid,
+			     cfile->fid.volatile_fid, &file_inf);
+	if (!rc)
+		*eof = le64_to_cpu(file_inf.EndOfFile);
+	return rc;
+}
+
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    unsigned long long offset, unsigned long long len,
 			    bool keep_size)
@@ -3563,10 +3577,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
 
-	/* if file not oplocked can't be sure whether asking to extend size */
-	rc = -EOPNOTSUPP;
-	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
-		goto zero_range_exit;
+	if (!keep_size && !CIFS_CACHE_READ(cifsi)) {
+		rc = query_server_eof(xid, tcon, cfile, &remote_i_size);
+		if (rc)
+			goto zero_range_exit;
+		i_size = max(i_size, remote_i_size);
+	}
 
 	fscache_invalidate(cifs_inode_cookie(inode), NULL,
 			   i_size_read(inode), 0);
@@ -3578,7 +3594,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
+	if (!keep_size && i_size < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
 		if (rc >= 0) {
-- 
2.55.0

