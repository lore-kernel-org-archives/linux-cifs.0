Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632537;
	b=LFCaumDBqbVEQKMS6ONs0WWcAtBbT8+3LU7rlFPtd6oGSk8FZwnR9VDdeR3jZMhtAgNh
	 yjxDIsho9TgGvJ2dVGpi1f4Gw4MKuhSynGVi38vEd5r8PtngL/3M96CCWz5NjnQ5gmo4V
	 7N9FkMitp06SbU9UbLZ3a4dKYk9nWkqj0xpBBOI9mhiXbUFsP0p0IeA+SMu7IOpTHljmJ
	 FyPueEy/8muQcwhE9CRAULSkQpdFAOWodwDKUHy6/apOxnoawA84g92J/y2QxDBhd3oZd
	 n/QrifWwqGxAUMVv9uRSKp6evK/JLRCX9qqVT1uBeOWA4Rj/NJt4sUCJG3bKpD0EeIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632537;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cVRpwgSKGIY2FSQI9k40aux31e8Rz7SV3v2xV4SvGjU=;
	b=D5ZaKAI8MCp8YDzVsydQeNg0CPplJmvEdgz87c6Bwsj+gRqFIbzlh3N3VAQgymkeOtVU
	 hEsutVp+2q/lDFfsg/DjTccKKS/xJIJowls+1Rr6yQh/fcuTbq6waVQPULsLVwnrQrBHg
	 xkS+zyXSM5azUbCBEV2cIil8hMHzbw/E/gWLyT6uucm7JuZUkxM2A0ZqtBqeDCuPZdqsX
	 P1ie+UbZ/hOGYO/NU1yDKKEBSLuiQIwkZW0hGzSEzLiLV00h7XNHcDZ7i3bAot1awWf1H
	 HFaOMFQdu30d4XiG8l6BmGzBBJhSt6YE7gt9XbteVW90ieosjquKJl02YU4UVTzTcHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gu2E7Ccl;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309160B57DC;
	Mon,  2 Nov 2026 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0309160B57DC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=gu2E7Ccl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=cVRpwgSKGIY2FSQI9k40aux31e8Rz7SV3v2xV4SvGjU=; b=gu2E7Ccl5EVAFS0PkQJilfTwIc
	0YG+TIqj4HqA6fjISFftN0bgXpLkYgrWmgxhLzlyVLmRbY4U4RPjFX3lCI8sOP0koRJymIV0Om5b/
	JXbnUO3xW5BpOSbPKM6IUKLuusQ9hiCA3AZA16S7pBsKIFwrKS5P+c28MqFj5vwMBYPnCbLV8Objf
	y+PDlpn7K7qG7KY0VMBjaB70xmcZELbkUwkXa9NVUcAP2jBWkXlm1x0YXsP8rweod/HJ9+liDDwxZ
	nTbfUtV9eecxJeTJAsyHjxgJKwEHzsw50AwFbo3X11HrqNL0bsmyoZZgxbJ4M3rxKLO5PF65sJbdp
	6alnOScA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkr-00000000aQi-3H5l;
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
	stable@vger.kernel.org
Subject: [PATCH 03/15] netfs: don't retry writes while subrequests are still being prepared
Date: Mon,  2 Nov 2026 12:15:13 -0300
Message-ID: <20261102151525.925058-4-pc@manguebit.org>
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
Content-Transfer-Encoding: 8bit

netfs_prepare_write() calls ->prepare_write() before adding the new
subrequest to its stream, so netfs_retry_writes() doesn't wait for it
when quiescing the streams.  Both then set stream->sreq_max_len at the
same time, the issuer to size its new subrequest and the collector to
size the ones it retries, so either may use the other's limit.  For
cifs, a subrequest larger than the credits it got fails with
-EOPNOTSUPP, and a credit-less one larger than SMB2_MAX_BUFFER_SIZE gets
rejected by the server, failing writeback that only needed a retry.
->prepare_write() may block for long, e.g. waiting for credits or for a
handle to get reopened after a reconnect, which is when retries are
most likely.

Don't retry writes until all subrequests have been queued, and have
netfs_end_issue_write() and netfs_pgpriv2_end_copy_to_cache() wake up
the collector then, even if subrequests are left, as those may be
waiting for their retry to start.

Fixes: 52d55922e0f1 ("netfs: Move max_len/max_nr_segs from netfs_io_subrequest to netfs_io_stream")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_pgpriv2.c  |  3 +--
 fs/netfs/write_collect.c |  2 ++
 fs/netfs/write_issue.c   | 12 +++---------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/netfs/read_pgpriv2.c b/fs/netfs/read_pgpriv2.c
index 5280b606fda4..116f46216dfc 100644
--- a/fs/netfs/read_pgpriv2.c
+++ b/fs/netfs/read_pgpriv2.c
@@ -160,8 +160,7 @@ void netfs_pgpriv2_end_copy_to_cache(struct netfs_io_request *rreq)
 	netfs_issue_write(creq, &creq->io_streams[1]);
 	netfs_all_subreqs_queued(creq);
 	trace_netfs_rreq(rreq, netfs_rreq_trace_end_copy_to_cache);
-	if (list_empty_careful(&creq->io_streams[1].subrequests))
-		netfs_wake_collector(creq);
+	netfs_wake_collector(creq);
 
 	netfs_put_request(creq, netfs_rreq_trace_put_return);
 	creq->copy_to_cache = NULL;
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 6e8ea534230d..430b24e9ae51 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -403,6 +403,8 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 	 * that any partially completed op will have had any wholly transferred
 	 * folios removed from it.
 	 */
+	if (!netfs_are_all_subreqs_queued(wreq))
+		goto out;
 	_debug("retry");
 	netfs_retry_writes(wreq);
 	goto out;
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index f23364116421..66064a06394b 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -538,22 +538,16 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
  */
 static void netfs_end_issue_write(struct netfs_io_request *wreq)
 {
-	bool needs_poke = true;
-
 	netfs_all_subreqs_queued(wreq);
 
 	for (int s = 0; s < NR_IO_STREAMS; s++) {
 		struct netfs_io_stream *stream = &wreq->io_streams[s];
 
-		if (!stream->active)
-			continue;
-		if (!list_empty(&stream->subrequests))
-			needs_poke = false;
-		netfs_issue_write(wreq, stream);
+		if (stream->active)
+			netfs_issue_write(wreq, stream);
 	}
 
-	if (needs_poke)
-		netfs_wake_collector(wreq);
+	netfs_wake_collector(wreq);
 }
 
 /*
-- 
2.56.0

