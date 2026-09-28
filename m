Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB34F5DFA;
	Mon, 28 Sep 2026 20:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626196; cv=none; b=VcsAOQiI9xMDoP7acah3/ze/OgCxIHiH+KBJlUxWk7NIw/RYy0XTQ6jSY6cb4xzTtU57GsfVH3TkYc/mZxwLJEH4k6AFLrVpGZ9Qft8g3oHU7P2kS+evzxryaZ0J1BAAiblnhix8aSqZfTYUo30rehvtkqwE/s/s10VBQXREE1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626196; c=relaxed/simple;
	bh=2NeURRJMSyHBoHD4CIZpfI50KSXeazjDNsFobwF398M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTu9bpIyq1pJSus+lSay2Bx29hHtMDC7Pxb6jr4TLJ8XDgNCnN2AlxoRn9hzJgedrLNraX4ErzF7hWYOPZgx2oTu+5YDMB4G/NJH0c5/Y6ybnK5hjfrrlwPRYq/vcXspqxg7YeizJ/xhcDCtU0Hj0gZOFWpn4lBYV54stntcxdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KbBILG/I; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KbBILG/I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=iqlHHf0jOyr0gTGnVWlC75soomSjHfHCAg3Yf24Z8O8=; b=KbBILG/I3M0W5qaWDTpcDJvuG4
	eTe8sQptYavD7FBFxbnR4uVRglZOsKAVxU3vp/6+iGs7Ykw3vUvxwgIzaDUZmrYc1KbHMU98XXvzm
	XYGX2rQh5ZK1MrYoG792TxNe/wj7oL0uBjw7FO6aN14gIZ1kwA8ONzw0BzCrW7w4gFHRzzhYW/GzM
	XX09jpiUYDC4y4k1hqaOmMhGlKLsHfp8Mq7E/Hd1rrGZwFOzrDhsHlupnZB/vbqdbPVNB6rvKKnAF
	O0AJ+Z6LMMEYaLMUoS5t357GiwxnN8tZmIWhJZ2uX8uUge+jjn3DkXF8NnIkXvH9Pf37kK7fpXIJu
	4R/N0UZw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfO-00000002UL1-1cq7;
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
Subject: [PATCH 11/15] netfs: zero gaps in read-gaps folio to avoid writing back stale data
Date: Mon, 28 Sep 2026 17:09:30 -0300
Message-ID: <20260928200934.1040189-12-pc@manguebit.org>
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

netfs_read_gaps() leaves gaps around a streaming write's dirty region
unread on the server side, so a short/EOF response there left stale
folio content that later got written back.

Zero it after the read completes, not before: netfs_wait_for_read()
returns rreq->transferred once ret >= 0, so build an iterator over the
same bvec array the read used, advance past ret, and zero the rest.
The dirty region already maps to sink pages in that array rather than
the real folio, so this can't touch it, and only the actual shortfall
gets zeroed instead of the whole gap upfront.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
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
 fs/netfs/buffered_read.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 105194de6e13..e6506942aeda 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -541,6 +541,13 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
+		if (ret < flen) {
+			struct iov_iter iter;
+
+			iov_iter_bvec(&iter, ITER_DEST, bvec, i, flen);
+			iov_iter_advance(&iter, ret);
+			iov_iter_zero(flen - ret, &iter);
+		}
 		if (group)
 			folio_change_private(folio, group);
 		else
-- 
2.55.0

