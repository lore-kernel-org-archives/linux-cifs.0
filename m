Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D9373C00;
	Wed, 30 Sep 2026 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790738913; cv=none; b=fHxgnm6Td0g9LT232WeionPsy1VPkYcNUBJEOHdhj90cDhIlam1gP0j5siYLYes2T7TjV3rKH9HU4w/QmHYHxaJK7KydwB1wJs3R+CqxITKjbDZaJxxFJVyuFxfqT9P4G2q+QWJDZZc3euCxvQbR33gdm/TBvIa/BQ7dWz6UVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790738913; c=relaxed/simple;
	bh=VUVie2MWQi6X2KFIT8UZeemC/aGYXuqwzqhAzLOcKzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0pAoAHHj4NU54iqNSUD9AWmHbsDv/lBvyltJe021qF2Id23qMoL1b+JdEsriJzL9nEfT/+YIYsFWuLNchgLYlri2bjDzfq8B6dKyhoRXET0hG1P9f8Ur4/BlINKtgdWzEBBfv4DeJ5mE1TkIKfpEG+YS2JnF0oQfhcFjsE8eKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=nWb/mHWW; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="nWb/mHWW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=N/lP/whLBpJOFNuizvVIGkNRD6JoVxEHCDGh0QyoT08=; b=nWb/mHWWxLplsydVsj45aHiecJ
	3Jc/4VPrUbHFsuD/q988dTCe/ctyWWOIfaVLm7JYQRh1xdMBjJ6zXdzrDu2u3hvDV89Bwf5w5t1Oi
	ObgtSGSHWJ/MvqpqGSe04lG0ALWScpJ6GiFRid2e8X33FFXq7RIymDOVIyU7ssa6fGvtsiV0jy/Yo
	xYozDoS8xOoo3PXbZBld1lgjNTh1kUyhEc6I8DVif1bW76GzH8YSUi08FENb6KFcdQmMErY1x4X2e
	YSWK54BvZq20U5FBCW5TIH5VIWO7KA+kLgyrZcY9gHEBMqIwopG0ml5WOk5wOSfWyGBm0QVTqKa0S
	KwyUwGLQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBkza-00000002asU-079n;
	Wed, 30 Sep 2026 00:28:26 -0300
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
Subject: [PATCH v3 08/15] smb: client: flush dirty data before zeroing a range
Date: Wed, 30 Sep 2026 00:28:15 -0300
Message-ID: <20260930032822.1835287-9-pc@manguebit.org>
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

smb3_zero_range() emulates FALLOC_FL_ZERO_RANGE by invalidating the
page cache over the target range with truncate_pagecache_range() and
then issuing FSCTL_SET_ZERO_DATA to the server.

Dirty data was only flushed conditionally, when the range reached or
extended EOF.  For a purely interior zero range that does not reach
EOF, no flush happened, so a dirty folio overlapping the range could
be written back to the server after the FSCTL and refill the range
that was just zeroed with stale data.

Fix this by unconditionally flushing and waiting for dirty data in the
range before invalidating the page cache and issuing
FSCTL_SET_ZERO_DATA, exactly as was done for smb3_punch_hole() in
commit d7d2adcd022b ("smb/client: flush dirty data before punching a
hole"); the two paths are structurally identical here.

This is observed as generic/363 randomly reading stale data where a
zeroed range is expected against Windows Server.

Fixes: 91d1dfae4649 ("cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region")
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
 fs/smb/client/smb2ops.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1c41d3b24c6d..a0fcb564e7a3 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3549,13 +3549,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	netfs_read_sizes(inode, &i_size, &remote_i_size, &zero_point);
-	if (offset + len >= remote_i_size && offset < i_size) {
-		unsigned long long top = umin(offset + len, i_size);
 
-		rc = filemap_write_and_wait_range(inode->i_mapping, offset, top - 1);
-		if (rc < 0)
-			goto zero_range_exit;
-	}
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto zero_range_exit;
 
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
-- 
2.55.0

