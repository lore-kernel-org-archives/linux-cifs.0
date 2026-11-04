Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827702;
	b=TJPZ3RDG4fqe82+dRQ+a+FojPR1Fb+7rLbZTYL9T5fMIjCwHrnw9WZdVtrb/5lPCB3cC
	 z0tIRG7YyA15Q0WWTG8ht+YjRCl32w0BvRIB0N8Mt/MdP1qRouH/p9YALfCVq+vbQD4iP
	 BFw1JrkB6xdU3esBtZ7biciKWMFznoYJqhFbv/yqEwE1As+7ZDF1bsOtvNEqi52dz01eH
	 T8FCSOyqqJa00Z0QMc/R5LFXteT5QiSokx/QOEjzBXQewevpn8yEbGeOWKZnpN16ni4nc
	 d6ONgF0u4Vpzw+t+dt5vaaPjZ5bQ3oyL+Zk4KHmz/plnmdhOwqTIq8fYNhssz0+4IHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827702;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=BbIgygp7Xj65j5vszWpR4P7MuwgE2mY4COoi0Dd+bY67VQatPl5OdFKer6Pzk5PIRwId
	 CtPquwybGvfFWUzCtYDJpRoBOXzFuFZx6nHGv9Wg5L2ICm0l9yody/4Qo6gRIE4YUDV8l
	 jCQATv1+yBIym96z21FPEqx/MKiZTDNYEKeK7GZpABQeIXQbMvv19tzVd4dlWYWs07Wdx
	 bSM4w9E5VQX32sNRrI8MHhNI8fAarytm6hukBZWlDcqTz0Oa2mVVFcO6dF39cz/W+EOan
	 UVJ+JihL7T87NAM4pm6qz8/pI9GyessOtVZsbjDzazBQxTXFvvuJzZ8RQL/6Aq0uAZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=L0majQIt;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D5C606C5A4;
	Wed,  4 Nov 2026 21:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30D5C606C5A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=L0majQIt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=L0majQItwkKyKDKSYwcDpv/bxu
	7rHJNjDHRUW7IUZBpMGj0HaEqt47ECr+ouG21RxIk+UbR6mscSN9fnpkfX7/aCuyAUk11yMizRWlz
	k0UPvX8MfNVBAisknZtDWPv/fxift83FxCadFpZgsIyj0zSO6+Kx3kt1lg2JlSoMXQKS/EqtY6rCQ
	VT4cruHBGb+mEJUczhPSFhXQfXKN7wGJeTNcduZXUPM8n1InyMqZqU/aZIPxMUpYvrXrSSO6sEZQF
	IGSxcx4WEQeVR7wr0CDX998mK+PvoAbxKEqQrQuVPzLt/V7VRf+G7C/YahPvkIpFVS/Mq2RXZ/JwX
	GCl/xXwg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWg-00000000rG0-20y2;
	Wed, 04 Nov 2026 18:28:11 -0300
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
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 02/17] netfs: preserve prepare_write errno on reissue
Date: Wed,  4 Nov 2026 18:27:55 -0300
Message-ID: <20261104212810.1935575-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

prepare_write() may call netfs_prepare_write_failed() (FAILED + errno)
before write_retry calls netfs_reissue_write().  Clearing subreq->error
to 0 for a clean I/O reissue (82e8885bd763) then makes
netfs_do_issue_write() terminate with 0.  The collector copies
front->error into stream->error and mapping_set_error(), which ignores
0, so writeback failure is silent.

Skip clearing error when NETFS_SREQ_FAILED is already set;
do_issue_write() already terminates FAILED subrequests.

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/write_issue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index b8237e1314d8..f23364116421 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -268,7 +268,9 @@ void netfs_reissue_write(struct netfs_io_stream *stream,
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
-	subreq->error = 0;
+	/* Keep prepare_write() errno; do_issue_write() terminates FAILED. */
+	if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+		subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);
-- 
2.56.0

