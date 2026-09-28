Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000DC4F85CD;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626190; cv=none; b=kQaUavP0YUWUnC2jV2HlY1R7xRudFBp2pHUiX42APGnrLJI1goeqa9P6NHJP6NCo+nMVr+mUoj3Dweo3RWP52vyutV8aWuVDOR/3TfdPG/8WeaLEL869CPvKjC991F2gt/dYawVhgGhdUho0FDprfCeKTv1G1tunkx6IBOntyq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626190; c=relaxed/simple;
	bh=8mE48U+17Ds5BPxux26B8fm57AwWxUI9Xsfr5dh8sk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKYVM5ypa/D8AUSj+iTfwON6HdhRFSwwqoi9gj2RobiJx/kI2/2JEBealb6u1/eLZnUwNkgUrh72mqkVzDxAugcSLj7Ee0vKtwYWRa7PjecP+xniAzVbi00KbEXbE5J1i/BADIesY7RTQAxs6PlA6TjHlCGZuDWooHpk2UHt9As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3t90P89s; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3t90P89s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Wp7NquTqjhY8gHnr493aStX017U5CWWUKPMBaZ2Qhp8=; b=3t90P89se5zY2ooyCmRiDYtqY4
	eRsBNQG0RiZRaNLxQVs/hKc7HdhOYSCmj7KlE2LrEspcrcqQidXh6aAI75lJ50uPs/Dp9zsRlFZFb
	qVclM/KsTuci7ewZ1rWtpeYSfhEU8Y+qHl5jlojM2Sm6bJ8KTu0GNGimsAiHNOpwYC4dZtYZtO2PH
	QmU7IgNv58iXMua3ijWZdbViwfLLdfhMgWzcaIXeJndzliMF2y87IKr3F0K+AQtD3SQW69wEVOeHu
	BqXZemCWO2fPgSw4mJhy/5EdCl+qrBVqcwP9x9kcFtKpbFfqN7zcGvoAo2rfLVyI2d5UxqkOXugR8
	KqxwLaJQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfL-00000002UJ7-2eG7;
	Mon, 28 Sep 2026 17:09:35 -0300
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
Subject: [PATCH 03/15] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Mon, 28 Sep 2026 17:09:22 -0300
Message-ID: <20260928200934.1040189-4-pc@manguebit.org>
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

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
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
 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index aa142420dae2..e55e081e47b9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3558,8 +3558,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
-- 
2.55.0

