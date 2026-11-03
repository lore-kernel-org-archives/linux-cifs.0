Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728987;
	b=niX1vOvCql05COA5Z3ZnGChLvmBa0n1qHE9Dx7dFDH/x48Jd+0IERxzeb9xy5oKaK3R+
	 q09xaFdD5ua36/DChs7A3G93GejVCNLI5fcVCEz/rrvsrmlQmv2CMboOhyFjXnwjRb3Xn
	 /xY6njHDi00nrGD3ietivtBnJ/69U6ydE4TZ+V8G0sl6OhC2WYY4yuyZ8YAPtXSfX+jZd
	 X4GDxG9VX9nOqFZAXJbQ/tdaNgRHqiP5Ge+T4nhwZcu78M7Z2wcTD4Kab84Oa1lRrsu9S
	 4Kj4QOlFzvRiot+fsKuzQ100ymA/91E6GbQaYKqKV1bofazp6T0cjcXq0qFERDEf/dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728987;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=YbMR912+HFE3absK2056HtFEaJeXRnfvY9WTRDctmyob8Vv+Qzn3IUd92ybaURVtA3KU
	 QI+f4bklO9IAN0b8NQ4Waw1z2cnqKS34wMa7mXEG7Mcsxsz5r++5AY0SHnkegjPETRUUa
	 2sbt6Dj6fx3Qoj0vqgdeFAF4oX9IstNoJrkgeRVWQBiFfpERVbNuD/iVKeJjz916Ps/uI
	 iJDBtyHNgyhzL03t+/POus2WyTZu0uVBquvN8JmwFOJkRFvdxrA3zFFUWUK9dBg0QBIvz
	 1H5mo1DNBWLjuHSzfKyWOauvaBc0MYtPBjnr35uGUxP3dCofSnWpITeFf93nF6gwWHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Z7oMwPyN;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A7606A331;
	Tue,  3 Nov 2026 18:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E9A7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Z7oMwPyN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=Z7oMwPyNYw95D7QUq+RTniQMm3
	4GHn1FRV1EQoo6n94lnAgpTkSkLs7l1IKk2uSr3JvtiOhl2ZcL62RBfl9Gs5aVsnzVMzwK41/FEBD
	57YiaLWxHLqn68mdMSBWzvOkthdroZBKH8XbIaZ9cN4VAA/z69vPF3QgxvpqBajpVYkwHe4w1xEeG
	ZNMi9eXFN0Axz5RtuaidgmAkNZoChoIKxRA+8cU5CpDM0YYsJ/Nqv+uk63Rja8EiC5vPkwwBY2Xf5
	7JqUizrUjIDtV1nzxn/6ldmhx+x4p5mx3bSTinrofHkmeQdtWfFdiDwfcnlQDtQ7udEiwxZVIPc+D
	mM8BdIVQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqV-00000000itf-26F3;
	Tue, 03 Nov 2026 15:02:56 -0300
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
Subject: [PATCH v2 02/16] netfs: preserve prepare_write errno on reissue
Date: Tue,  3 Nov 2026 15:02:41 -0300
Message-ID: <20261103180255.1482516-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
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

