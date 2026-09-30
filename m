Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489272C21FD;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728765; cv=none; b=nttkMLO/wPMKlyk4P6LV3Zo3axxhq/4hlAuvT7ic2X1566kIZi4d14bVZF/560KyrZwr2ecWfd3TMAuduJczE2uaPH9TDyc2KzrVfkMXtHJL1Enp/7i3IINAytgRmMZBDB/ZMQvkKQpGgzjGg5KCJJqEBaGo3snJFgFbtJHOAxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728765; c=relaxed/simple;
	bh=T9LUOL0xRWtAnfZ/plfBMRhq5YsPlcEp8yIv4qG6Qbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGPavA8pWRHD8jGpQHnZvehO1gHGtTETs6UwgBwMnvfbhaWrci4ZNcL6n+lkF8yc/7L8wvua7OhQmzcyf05qsyQJG+Fe14rr/H2m533J0dWJpHVgZFN/HlSom8xIkt63RCZsl60gj6VRmjAwt5e54Qwnj/1OZsyIUawZ4zDWuFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=KPKTDZpp; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="KPKTDZpp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=VX1GsVURtMx0AcAd5F90EUOQVkRrx8GKSS+iMNJHFuk=; b=KPKTDZppzCYiQmHCjJ+nMzBzNU
	zznWdn9m/Ry4s73MKZUa0GkchICGFe/J/PDx/OJEeoFZROoYWRFLIvPllMMO8iXUKtsTI5/ikBoHZ
	vl2dtqlW8OwELM4NXvVTcXzyrBdO86n7BKULDKcez9XM6LP0U0cPSqu1Ylzag1Xf/Jc/P2JCn8jhB
	kcpVxdM4rxVVC9h4jc1Mh91WH1Bwepg8Gs2BW838ruK2GkIwhj0vNaEzs3Bu7MWsDmE1j4loP6uPK
	L19+HBDfglipqmbTI+dJpr78Y4Efkk+Mv3zzfGVnMnCj6FceC8tMqmQOZc2GfWP8+uMUELI25HFFx
	fUz+vekw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLo-00000002aE7-3u3I;
	Tue, 29 Sep 2026 21:39:12 -0300
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
Subject: [PATCH v2 11/15] netfs: zero gaps in read-gaps folio to avoid writing back stale data
Date: Tue, 29 Sep 2026 21:39:04 -0300
Message-ID: <20260930003908.1703770-12-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
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

