Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746823;
	b=khhCRU9aZvmzJns6XF/6xU7E4BJFxwa0HxyTWyHVdaUT2STI61vMccaECWscZR7APrd4
	 fBhT3+apRRkq5uK2eAj6rP5VxzWxFDTkNOqLJpP8xdVgWnZh3mFJo/P3wS1OKwrKRmPF7
	 SuB0VWDFcsCUZtCDFkzxKCCp0WtfdLTmT665LD4r6ouuWa7FUZ1LxrzrTp1ff+9yYOYR2
	 CLJkJkoUq7qnXSilJ+UvQFpXubTR78N0e0ogQkb+y4pHubxPqfHuRXgiAHdaBfMXowdNL
	 +6rZ8MpBzkJX0AdXw94sHT4PmPp4chcCEt6A9MflxOAdD/h2IxsvdFvJUnGN+xP8fAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746823;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=QreL67SBNUq3aSjJHqsOUCwcjmTfFUaNlO00r4vs+w+onUfNEqyJ0EE6bG17YNvOwBSm
	 Gy33XmFeW/hoRkcvXnStnb+vJRKyALPVS9lz7GluvByNdyROEhtm9689QT1Ly1kR/11Ov
	 TC2gvg0AlhrLARevv3QAovVu4Iry5OAogmSLwI6yCJZpWL4ai5H02aaLsEkS4HdU5Jsq3
	 lh7zXKeIh9jzoXcUVJYlSTe2Ol/BxBRS/AQboyiikaQ2QtS+Ysy7o62Ke0u/NwQ+uIA9S
	 ItRDYqOt9l+QjdKaJjD0qGj700Yo4nYOCwOtEfJudZyUDTdzOrwyjETRNcHtHFVrc9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=FaDCPrGC;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A4606A31B;
	Tue,  3 Nov 2026 23:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B70A4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=FaDCPrGC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=FaDCPrGCsdTIBcTwqLWFhyNepy
	bdAoANw36pLy50TL5VRU082gMGgk9ilDCtiVB9WmjaXm3MUNwzpeqKN+oZgGyrZTmqjXRE/zHWNUy
	IgilW/OJiJqihGP0qkpc30ez6Iq5BJdwK1RfKW0P/uAxi7BGCQ/DJD+iRi7ERfHTCsXn9HYdInaw1
	/Fm3RQBt4zw3lTtQD43TZCQcABjQ7H7OQBGGZBhRk+pjZZjYWDXlZPQaOTIHr0XFArmRNX7tCEUQu
	rsksFdO3FayXCeyG7lIm1vt1NIhZ7SpjDklVw/AA6x64uevC0dQ2J37GmxTNKY4KDMDpftsMfJ32r
	KgSbKEJw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUK-00000000kMQ-0a8j;
	Tue, 03 Nov 2026 20:00:21 -0300
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
Subject: [PATCH v3 02/16] netfs: preserve prepare_write errno on reissue
Date: Tue,  3 Nov 2026 20:00:06 -0300
Message-ID: <20261103230020.1617748-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
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

