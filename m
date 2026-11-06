Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=HuH53Nof22/R3Ce6/FZn2Ru5KMHZZMFZTapCXO+ATAEBP3oEf94bBA9O1D9CNtyXgf05
	 0TpV10Uv0f3xBPCM0BU+wxKOvL9rQ5knIWbmJdiB4mc08WsUDuCTHCbQguyyJv8u2UfNG
	 FH2htFrY5S3B6VAF+IWmoL0TxA1vn/QVfFaDRhyiRkL143yz24p5cPJqqWdkGo0g3rHUI
	 jpQTBmwSfx30mb4aTYqOst5EPq32CwEa9cQijjGoweQBE6YFcuAAiNEstBbLm5U5K9mxf
	 D+q13J4ZuJj2ak3p3yiPFgjqH9q2ZwdU+qShjG2E59fSQB+QsTagA8nMdW0mJ8xQylA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=eMQCmBHMrlGzV1AAmieT4lED/W546pfeICp+5u4kinGp4fwDKo7b+WGKF/XvS/wF07C/
	 Wg5ivwFkqJyBZMdmKU8ur4dyPAW+x2zng8vxejvfwYpImV3fQRBVSbnMPsNsLt8WqloV4
	 sjM5IB3mqXBvSTpTGeUjQR98UKyJQ5/VcNWMycMCgdkAdT8HKX0lc2E005hE5Afl5AoDo
	 iBP5lMn5/VR9yH+gZL4N/sFSyF7ezQPhSwZ4IFdT08Wgh+mXdWysyYx9Wj5TobF/ASj0n
	 nn7cuaqVXFLX2AHtb5gQUR9v2teaX9IgW6HFd8AkD/+zcvV34ItIiAaoABM88HjXhgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=UNyPWFP2;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A8E606A335;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64A8E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=UNyPWFP2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=UNyPWFP2RyphYadHBk7mqTGSo2
	/JKzWuST+SvodnSSRYGrCMHU/TDj5hOuAVZAGDW1e7uAPfPpkVKPtOgUpb/ooTtot4vZHucm+jAij
	tZHbpurVDegm2Bv9qICxNoPsLB7Gwpn3zay9o9MrBS8WzJVSRjYqcjSjm4+mgWhoWRizHAZrGpJKv
	S10SZShGMb0+gBS4t9TPHch0qdLk4scut9e999PDLs61nrFU3Eh3BkM3PGkIT4+gd/AwpxPM8aSBk
	mIomM2eCryfDnFMwP8Wp7U4F5/GmCEGaKR5ulUw3RfH+taVDSkS/jHayYNNqFzwgLm+5UimcUP+Cr
	Ce+iZzhw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCV-000000014Dj-2OjF;
	Fri, 06 Nov 2026 20:18:28 -0300
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
Subject: [PATCH v7 02/19] netfs: preserve prepare_write errno on reissue
Date: Fri,  6 Nov 2026 20:18:10 -0300
Message-ID: <20261106231827.2604956-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

