Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=T4mYe01GvrAz0l80S4Vim0H/5I0pyQOVf/nO2EJShjL4dVFnS0mhXoEJWd/J4WMaH8EE
	 1z+bNWg4FoQwwELp21+ygBePWwQ5BYYh008oo6AnQWl1swSKyAL7SEzcnG3zEwfeWas0u
	 XPUE31EWgUKR/UqpHn1Fec4Onga586r8p2YmfSd4OoHyfRtSqMNvZZ16ldvGtMnAW84bA
	 DjadYysc5Z+LRQjI2ngG5tDiP+VigUQSwSLdJGPCO3oDdczqB8+LEx4m9E5VA5cYWm8GZ
	 fHLMSXFZYs1khb5gEerDAtY502ASKd6ggK7iw5SncqJJ43J7jH08Z8yJioChiuutU/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=qR8cFVrsP75U0JXOA1JYyQHqIoukGAFyLphN6Ylgk2kXXecsNBwhf1+KFCTJDTIVwJ0f
	 HX9UmRfl/zvwVOmdtZO0dj+oDqrb6NiZvKoVS9GHWIlHycxGCfO4rlQDFgsh6Tskd+WgB
	 yiI34Aif+tcsK5tBrHS7CS5y94InvObKDJxP5jEkSiPuXAd6/UjGwDxjrmtpYh58AXRxB
	 LItWc557qJ6cC0EGa5wOf9Fos0Hbd0Rjd+kUQ6WLIjZbHamESLcePjmU4tkOP+UckAyZ3
	 Gd2KjL16IEWIvKuT+ut5aT1pMm/9TBxiBV7LjQR2C6tyhQdub1HhTNjyQ1OKhXhw2lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=rFxLhzw4;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8D2606A32C;
	Sat,  7 Nov 2026 04:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E8D2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=rFxLhzw4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=rFxLhzw4bTF96lQleMi6mO0OgW
	3CmBQ62D7O36QflS74golbwaXErNKD8uFtiQDd6VB+e8AwwoLJ6+R9TX0jsmK7n5a+dDxgK9hxx2M
	msxKgEiBSyOB0TfRIC7XDO0s+3+SZpv2NbCinfZqXfZlyNsYFQ5cC/h2ebDo+v5IqxBNZVNfkUIp0
	8OeX4Ssh4SaGNyHD5NUYY2dDEi0xiu26MYgno3H5Lw6mYAhmYF1uhcnTrcqs8YNyWWP2ksofPaoMw
	TXl7eJkV0xeWqkC9iLB6lIcyJ+hlwFHAUO7eI/6LudrtJcMSXihwnDhAfYdGcmq93t/zxuLfbb4zP
	PW3vWTIA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkK-000000015LS-32RE;
	Sat, 07 Nov 2026 01:09:41 -0300
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
Subject: [PATCH v8 02/19] netfs: preserve prepare_write errno on reissue
Date: Sat,  7 Nov 2026 01:09:23 -0300
Message-ID: <20261107040940.2692656-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
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

