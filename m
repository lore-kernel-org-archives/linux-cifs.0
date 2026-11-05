Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=CcFBuIS+cAsjgDljYP0v7ykowzNxlEm/keUcUNbErYfgC0w00ezRvkXXD1yNltvpPavO
	 tjLXjFsjpAFOKvN3hSZFNc5xBT+WztPy3NSUQHatqvEZXZyELPZUnqYG6BHzbnFdPRupQ
	 LD7cEkXtdm8qi2qQHqGDnAyRJaoi5VP8ZwNb1Gj3QVBM5AmXozNL5PejdAWMa4o2Ac3c4
	 N9l/qz088NqrDorRlLF0ySHx/scdWFBozpNimRGagBddLFDy3x4vTaEEMcS0rEKZgfjoT
	 HXyzRqHqq73ygY/WIXe+vuV43PzDat4MGKsBk7QxzjwnE1p/4jtd25o9jiTpLbOYIaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=qetkej8NB7Oz+9z9orO8qRtuAyXwTc/Z46AIFegTbnu/jazZvNs3DUsbVplPlp3gnAKp
	 rFoiHBfy2NAh5lmi76JL5HZMhwwEBRcVpodyfinU+jVx670p6dCfXXorPYey6r54bBkbL
	 piEtLtSgpPT0I8rEBytnPg81pU991Fh30BhHqqbDK16eE8g9Lp9guNazGMCoIro1cwC4G
	 vSeIJH3YiwAtoa2O/Grg77/50V7tNdNddkN6erJXlc1FePvdsiVbPmg81y4rtgLj0eRbS
	 DP9b18avbqSX2pAuq5NosxCE1bUgsk26VElOI2uwCY3JsLunwPJ27/aU+k3Sb2Noy9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LZcZQxCa;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F9606A328;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F8F9606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LZcZQxCa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=LZcZQxCahIiT7unBx8wsoPTHLY
	OdhTwva7iYyjKgY/hlprc5HIS2lFBkAr/i2wyrCz8NkNWa+FdfMQ4VO/KL8By70ZcJ0q6yzLeg8s5
	iJXoP649LlRFfvGJD1B3pJUlFL/t3sedtcFvDYi0PxJeK6bI1lWpOLqE0MqCBeAAWlXXfxbMnUy55
	pf4Q2YDrwEIwpEvqz/skmrI1SDcy1/PmbQ2LE2zwIeyxHe9HwFDtXgyyxiPDFqvr1zJXEedIDu6ug
	QPfJc5+M2V9iLjvp5WUm74lu9rn1BnN9vUqlXnAGeGFfxnogKinI+zwETtpld6ZEmJA9EgO2aPHoZ
	xRFL/aYw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D5-00000000ymg-2vih;
	Thu, 05 Nov 2026 19:45:32 -0300
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
Subject: [PATCH v5 02/17] netfs: preserve prepare_write errno on reissue
Date: Thu,  5 Nov 2026 19:45:16 -0300
Message-ID: <20261105224531.2316211-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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

