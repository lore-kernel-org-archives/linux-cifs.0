Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071590;
	b=gAaM+89C6F0L6Udffb5nbngpYye4QpVZzZmyYTJvZPlmZgEQ9ycNREpgnMc+SWzIVAT7
	 tSUaxhEwBcP3BvmBuA6OehKq1cHOjVMH42MfVv2CfxInR0AuCkqn9qU0hAKkogdwZQkNy
	 bql+NJg7KMHTRGxPivaFDak8MaQ1oxcySKynxFtTkxM7t6slvKevQ7mWQVL3aJo/KQoeH
	 aJXcdyIrjydkac2FSxdloGjgMFst0BGE6xmLcqnpVsSRqPNSbWtTuKako51DY6RvkPbQP
	 yqMc6GA8ocH7BHZem93WgDkRJsttyxmG/BXIIdXf0m6SYHlnSpkkx5RtV0tpkKeJ4fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071590;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=FPtptAoVpRUEStNAuUs8rm1sldJUzyAVykb1TyhT2tv7WO4++0JJchjLMCq+YBXSBFfi
	 3woA+5jaBJAlQ6SnLtFpgGJD8/PaFochN0bFI7PVZKtWYk18/UDHO9Ic8kR9ag6SawHOW
	 8FQol5MB49776OEOh88lXj3sWlcHbumYHz77dJbs43jx26ryHfVjhVpSv44SttFQhmgR9
	 pjz44s9xTe6VrQ5MYTZXut/Wuugypj2ioUWRUAPj/Lp5wf8P5kVjV0IoAsbt9EWANagwH
	 kI6h6Sr8td8pH8miTZ+gsIgxggQmFgeefTRnrIBMHdwsu6c2m6TZL4Pfvx9ccJ3eJiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gN0CdWZV;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4359606A334;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4359606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gN0CdWZV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=gN0CdWZVUJUrjCJSkGvjhSjdW6
	aVTUgxFt+DTXQXV4LlH2T1lMDFdU8PkraEnbl7SezKygDN7bO7HKRIgyyZeWvEv9p3BY/ORXCK8E6
	GNTOEqHzCQ7HKd76XfrL7FC4mzFwbiIUcqeYw4CgPUfBob9HwqpMVk+eLgoxEM4/ag1YH6Sr+5OOi
	mXxcvDMP3UA0kswsJHDlc8fA9Gg5wk5Toqw4D5UPE/KUd2PjComaWehkTN3bAnFRN+gGSegWklBG5
	suZgUFRdfS2HFRPmx9U+P6B+gTf2WRCyXkhKWd3nx/6jsHdFbxggsq+ThHUn5Fd3IQL12NfhgrMQj
	QOUtBm2A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyT-000000017f5-0x0M;
	Sat, 07 Nov 2026 14:13:06 -0300
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
Subject: [PATCH v9 02/19] netfs: preserve prepare_write errno on reissue
Date: Sat,  7 Nov 2026 14:12:48 -0300
Message-ID: <20261107171305.2847361-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

