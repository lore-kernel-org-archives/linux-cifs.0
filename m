Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632536;
	b=0tkTAqU1dReO1/ocn7D0TmD/8fVe5p0vzs9zb5dessrq1StcMBVsZUYCS70Y/t4OKvo4
	 cquR3IVa5BvvxU2Yf2JL1S1JeGstHFT8QsZN/Iok0Jh38GqFT4ZBde1sMrpK5PqHrb4VU
	 9itlisjpdlJvAXQno6YnYPMovnDOYA4bnisJm2u0p9utzJMB+THMDoEocb6GhXNOD9npH
	 07baV+syePJP4SaWci50eTp5EJYvyM0i38fRQSmuYQUzfD7aqXW4qFVDDTYzUZmPt8T2o
	 fUNg+a3Z2GeyXg3IGasNLz557fpDTo/XDaYX4ku5t1NUOtMVoDRbwXkflFjfFeErdwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632536;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=;
	b=0aYpPW0ELQ/rclqV3a1IIxR2V3b187c9RlYtesYY9rOe34M2/X7KH/3tOJlxeOSDKZyb
	 IWltWih6W1s8GoKjrFClHfftfCJW+tND0RJfwWGkCoSbE8gN7hS5Es6RvidvCQ8I8mOiC
	 qi0Ddzq3V1k5eQ9FmxcogN6p77WEy11ldxiJF0GhCSM2ZFUkfD/JbMDKaAazBMRGoD4gW
	 dfmk0KE8+FrOBG3MWWPWhtlMuQWXmQnVtqNk//tg98fpRrzrVjrvCuWf3uZ5Mf8gL6AUt
	 +gqF/+4M6JnOY9i0r4FvQssFPKoY7v+9gz1JwzafD2ipmOg1djxCx8QyDt97WyDj/8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=GTcuC+zm;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0311960B57DE;
	Mon,  2 Nov 2026 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0311960B57DE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=GTcuC+zm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=hEIkeqoWPdbQaypcZth4KA+I68PjVvjpImUupE4Kw+Y=; b=GTcuC+zmO6N+/NPP9gSOJzJ/Ek
	lnpUuHotSAMwjbkPkuGbSRgd8BXZXxmi3VfdqiapiCTyw1tjjAzoh//Cy6P4i9e6dhkykheV+wb46
	6rxy+gIwSeZXm+NUKjQTEl6ygA6GfjyyJGvlslR8fx/aCXrMMhb5wuoB/TUVj+d7orMUIV+FzyJ+8
	jqztlh7AP3cJgiDDNNWqZzOw9L0+j4idfJ0ZrmD2loVgKTxOs+OudMXjIMWX0A8KOj44YOvysohdf
	U6JrBxXvhJO086XBoTJy8ffgWu17aiWe3WvV5G5Ypb8bqZTkmSJAlYDtBCjsNNk0OAT+BqU+WwPsc
	8LoKsxYw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkr-00000000aQd-1qVh;
	Mon, 02 Nov 2026 12:15:26 -0300
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
Subject: [PATCH 02/15] netfs: preserve prepare_write errno on reissue
Date: Mon,  2 Nov 2026 12:15:12 -0300
Message-ID: <20261102151525.925058-3-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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

