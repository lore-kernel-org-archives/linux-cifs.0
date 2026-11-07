Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=T4/jbKLqJ7EUlqCpeJYqscNQepNNAKsr0ZsP4SaF990vl6egTof6i813vYAnecAqeJG6
	 0heR1BLkSb73bTnvrgkSVyw7A/inm1Y4nJnZu9DbqarmnOOGJvLkcRIz+4DekXjvtniLK
	 r/3w4tPKqPT4lW2OX6ccfUYG0ozlJx0hr5q1TJ+yYrJrczUFdE5kWDw0zbWDc5OXggm2u
	 krJdlHbN8B85Wfu659b7HwTGYBo1pNF6qL3stKa4qpgCMk0Nr5IRs93xPN+ipUoKTdQAw
	 5gaUp3cZbKmFwytix0CB+zVxPICsbE3o2+P3zGcNMIywGkTg7v3WXVdooFH3eses0/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=;
	b=QfuhW0pOB8iTofquYH9v+WggIZ4nLCbEfPa5KEciDs3WU0em1AHfSScHceIqs959ig6N
	 avow7Lrs6jEF+W66Scd7lqtus5vD54mj0805qYrv5M6vOcDvbmC5iF2mkcvo/z9jVKBTm
	 OeenERto+zeuk57HUqErGstFYWxE4eoq8oYk1tuJK/rsLhHK3ZVacpcIslmzQ4qqcoKq9
	 RfcCPgXsk+eRDvJptyKFVY6sL1MKiWdGzz0axgwg4uq+PF6aWJ7qNWVUSA0T3WLbwdoAL
	 mZW4zTaGzq6ppOt/ukWH+Fp0eCogueQXN4/jZCWPo/s5jePWx9rAIbTYPzRqpBtWabw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=F02JqFGr;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9E606A331;
	Sat,  7 Nov 2026 04:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA9E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=F02JqFGr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=/kHN44ZQ7spcitdWxiKL3R8VBCf+tiohYYozD2JcOnc=; b=F02JqFGru03yrHC7OyksZDIqLr
	BFrQHvHgSXPCGlMbQZH6u4bShoSW1/HtGKO6xUqtULggEsDULqz9nHdIVQcJiOWIrrAUb5Hw/IDrk
	GMi4sLOjZwHqR1coZ3cGRJzfF993qp381BikPLFT/1Ka+cmC7OgyL1x/mPOpQWTmBbU6FruCsMjQc
	uJIsxPUP7WbpHnwgVV7Mscb1egr6lCv6MeMH6VXlXVFrGZK9D5lThnqUfZToo1vb0R73ejwKCgYvD
	2U/ukjotAif43Fo6+NdKeBVhUOH5cBRaKzdBRTEP1r8P8AUkAcZ7dALRU+vGOErBsRur6UOiomFZf
	kz+VsbSA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkL-000000015Lc-1jWz;
	Sat, 07 Nov 2026 01:09:42 -0300
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
	stable@vger.kernel.org
Subject: [PATCH v8 04/19] netfs: don't hang a read whose retry is abandoned
Date: Sat,  7 Nov 2026 01:09:25 -0300
Message-ID: <20261107040940.2692656-5-pc@manguebit.org>
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
Content-Transfer-Encoding: 8bit

When ->prepare_read() fails while retrying a read, or a subrequest can't
be allocated, netfs_retry_read_subrequests() marks the remaining
subrequests failed without reissuing them.  If none was reissued in that
pass, nothing is in progress any more to wake the collector, which
returned after the retry, so an offloaded read (readahead, async direct
I/O) never completes and its folios stay locked.

Wake the collector after abandoning, so it collects the failed
subrequests and completes the request.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_retry.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 8a722995fa9d..bfaaebea12df 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -269,6 +269,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}
+	netfs_wake_collector(rreq);
 }
 
 /*
-- 
2.56.0

