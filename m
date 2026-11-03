Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746824;
	b=sig5Y0URk34eCegaoa9WceweopTWuiFYZu0PFeksWEgKHC68HWT2i9otPkorH0Zy5yAS
	 aranKqWro6vEq0aIQaN0hDA8zmGIqqlPAMnWe9JEp1dpxdiWGQgNkZwpoF8xPXjp6RFNM
	 J2KaQ5tToRdcBcLyeEBxOKHNPJM8enyPdvSIX6Zq6CAgI3a6jYRdDuXiQaLQb4gJOGJt0
	 zQZJxUgPDD9ATDmpAfI40XMUpyoukauPbiefojZI+GamwXOWekYq6/hmvlJZaea2I1Z9w
	 rveeZfJfCpA+h8GHGZ9GfdYoKb8YBIGtd3r69QXhXiLPPsg1TUQVgg1qwxRdFA08zkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746824;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=;
	b=tHb8WGlS48BMUo7iBK9Dan6BGkHrnNgX5CDnLyDE4xprJlUzJJH2m5TcnifLuF3Uuyt/
	 HgUEeJHQEHG4CsX0R40PL8JJ+IHoa4t0Luazvwec5KR3wJXIs8TFPKmqdGjQJf5B54fMu
	 SN7rCH4gfOjjLrSqDbqiL54PW3C7nnSmST9CYj+Sa2/dg7u5/eO0fyD8b7x4dlg1/sD3h
	 olRgoJiJtSc60v7oL+s/pUavQL1OVdvQh92WXi/wl9LpnoOPru3ROMsU9+szgeyVgrnz/
	 VYThCDgw8emoCjzFaKhtS0EvDrwcDgVRPufDg5SjQYLhu23QeKNFwEX8TT4Y3apULAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=o0QLtSmR;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B195606A32D;
	Tue,  3 Nov 2026 23:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B195606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=o0QLtSmR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=; b=o0QLtSmRViNS/Wn897Z/7f56O+
	tEvya1I3OMWKFmfgP+j0AXrNr9o1VkZwDbWiowfkhkQSGlkU/YZu9GKrveE6pKhD39XdZKKs5g6Ls
	LvJc8uqAsJDxpjJp3UG9cljxFiXjCp3anJnyDrlSktmsqObvRMX6yGN8Ei2ICSKrShmb768Rj+2JU
	G7ll8jcOv6r58shOsOotKliy1fcLEOJXxRHGBvXLvGt+hjQFpoBvL3kifEzzm0eC3qnew8waX5l2+
	o+5ryqzpqMAbv/4ehFcPPp8k3jlPod3HdpnjcDwBKaoBYG9EWj7qDj/vwOusZ6I1Q/JrT7fcnK11z
	bg44GmKQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUK-00000000kMb-203z;
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
	stable@vger.kernel.org
Subject: [PATCH v3 03/16] netfs: keep the prepare_read errno when abandoning read retries
Date: Tue,  3 Nov 2026 20:00:07 -0300
Message-ID: <20261103230020.1617748-4-pc@manguebit.org>
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
Content-Transfer-Encoding: 8bit

When ->prepare_read() fails while retrying a read,
netfs_retry_read_subrequests() marks the subrequest failed and abandons
the rest, which overwrites the error of every failed subrequest with
-ENOMEM.  The reader then gets -ENOMEM for e.g. a handle that couldn't be
reopened (-EHOSTDOWN, -ENOENT), a credit wait interrupted by a signal
(-ERESTARTSYS) or umount -f (-EIO).  The first pass doesn't have this
problem, as netfs_cancel_read() keeps the errno.

Record the errno of ->prepare_read() in the subrequest and keep the error
of subrequests that already failed, using -ENOMEM only for those
abandoned while still waiting for a retry.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_retry.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index 5bd8dee5a834..8a722995fa9d 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -28,6 +28,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 	struct netfs_io_subrequest *subreq;
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct list_head *next;
+	int ret;
 
 	_enter("R=%x", rreq->debug_id);
 
@@ -140,8 +141,11 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 
 			/* Renegotiate max_len (rsize) */
 			stream->sreq_max_len = subreq->len;
-			if (rreq->netfs_ops->prepare_read &&
-			    rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = 0;
+			if (rreq->netfs_ops->prepare_read)
+				ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -221,7 +225,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 				part = netfs_limit_iter(&source, 0, part, stream->sreq_max_segs);
 
 			netfs_stat(&netfs_n_rh_download);
-			if (rreq->netfs_ops->prepare_read(subreq) < 0) {
+			ret = rreq->netfs_ops->prepare_read(subreq);
+			if (ret < 0) {
+				subreq->error = ret;
 				trace_netfs_sreq(subreq, netfs_sreq_trace_reprep_failed);
 				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 				goto abandon;
@@ -257,7 +263,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
-		subreq->error = -ENOMEM;
+		if (!subreq->error ||
+		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+			subreq->error = -ENOMEM;
 		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	}
-- 
2.56.0

