Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD523749F6;
	Wed, 30 Sep 2026 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790738912; cv=none; b=mejzxEGFEshbgP/Fp0QcR1EpEC0XGWIZx/WDExIjMlBYiVAymtfP0tnCffkcrwObx9HSIqlGyA3Y5pf0bvSchCz9RUSWqL0m1DRmjnEcM75/p9kXcDhnbX0BFpdRY/RRMmPFrTmhZo2ZJTueHkxaddmLy6YNXvIR8CUkAAIwbO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790738912; c=relaxed/simple;
	bh=0tnEn1bDI3qFevjxwiTHDIfa5aI8cDl75A1XHNtNhRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASkIfkA1ha0XQQOPG710K0GxflacCgEBM0L+Xb0Jjwmv1nLbtCtLgNp8JerWwDlGMtBW8rUbXOAEJSQS1TctrzkeE60iRp5LPa5W6JvAn2JKkTqvZvnPbriAdmzxjpjPiEQ2oxwNDGqOOYzVb/BUDGwm14D84IzbJU3NKwWpkfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=kM6Eh8nC; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="kM6Eh8nC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=3lQExb4eI1F2JhY6HrkcA4Img8VSvnTyH8rAbiN/V2M=; b=kM6Eh8nCW1IZuqiIv4RKd2tjIN
	3TWAu4WQR6nReNd01VHAHtEWc+T2tjHzjarTWmc/8OiuZaRfx24hB+RMEQ6xed4vuItGRqegbrfwQ
	uDcj4V+1TwVx9uwlHcaK5JwRrM6ycTX5H1bxbK8nrKQzhCztSrMc7bkzkNUx83rIMhLRjQChgAeU2
	rj9oW+K2igwk3nle+p5J20cJSXUpuaa5n0eOEH71Gw67HpY6qH2JpKNqrFwO//t6DRT7vKqyYEZwK
	4PwOwmeB/GMmak3cP69w0zRZ7lSH/rm0j+FvEeS9yqrTx2rhUnAmd4ZJ3kINoVDr25abQAMiNc4Fi
	Q3R8Gxxw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBkzZ-00000002asP-2qyH;
	Wed, 30 Sep 2026 00:28:25 -0300
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
	Frank Sorenson <sorenson@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 07/15] smb: client: drain outstanding I/O before truncating on O_TRUNC open
Date: Wed, 30 Sep 2026 00:28:14 -0300
Message-ID: <20260930032822.1835287-8-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930032822.1835287-1-pc@manguebit.org>
References: <20260930032822.1835287-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_do_truncate() flushes the pagecache with filemap_write_and_wait()
before resetting the file size to zero, but that does not wait for
direct/async I/O that was already in flight, which can complete after the
truncate and reinstate stale data past the new EOF.

Drain outstanding netfs I/O with netfs_wait_for_outstanding_io()
before resizing the file.

Reported-by: Frank Sorenson <sorenson@redhat.com>
Fixes: a8603b52b39f ("smb: client: fix data corruption with concurrent writes and O_TRUNC")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
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
 fs/smb/client/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 4bcb87610897..11355d6bf89d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,6 +1012,8 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 	}
 	mapping_set_error(inode->i_mapping, rc);
 
+	netfs_wait_for_outstanding_io(inode);
+
 	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {
-- 
2.55.0

