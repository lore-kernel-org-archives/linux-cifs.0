Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918743;
	b=zcU7G+vyGnGlFoUdYmG4/qB3Gojl4aiAsImxOpJx6ewj5i2kGT/Oa8hY7yVob6ME8Gt6
	 9tq0NRVFIXpy16ahjOBcDaKpRpLQeT7QnJNOuJenZ0PfImD2lct0AORESrx1kWaIkAIss
	 u0Xh1KyoIxC6lOS5qSVZNovY+zrMdSOwx8NwsWjukk4Udxo1cnvr6zOJUUpeFZvnMu+Yr
	 BHAXEWCnO8ZuBBrHiHuFeIkNY7+W/4WJ00DfTGBGaVe44H33ZwJQ+e1jR0Lz0iMF1tu0b
	 +fohdzcUxBynU6wqY8xUTrmcQu06rZNjWZl0G9X3+cClF4dyVyca97lWXNFZnS3Esag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=;
	b=SQqOr+Y9Gwpe1rVi2+JFDID48+rkFbSg3SqD1cGsa1OATtPgdKei6Ot8dnxWNJkejQCf
	 s4wt83NSddBauFrz2OimDLJfnXCa6ZIvNtd+aIcMV8BOLkV6v9xReefanvUMW2IPZfKo2
	 vZQJEIuDGaYrgYN00239eT4iMbKuLWOEjU6fpaYE7XNYfaP8v+uQOMVVNRB/b2VRzilh3
	 5jAThrN3WMNFvCFkBvCsgxU2MaHz81+r2UlOYjnRY9lYlIulfSJivwfFXrvjtw/cfWycU
	 w5Sm4XbXlRMcQfgJ+qh/84seLDggNXAb6NLDWja5qgkEYPrDGFnq9MNGv30s2MJcfsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kKstYBYZ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6D606A332;
	Thu,  5 Nov 2026 22:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FB6D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=kKstYBYZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=; b=kKstYBYZQ2DUIsejsU8w5L6bsk
	Q3BotTJKwNvcF1moifwY8c3dC1HEuK+189LgPS0IftQWtmqS/Hb0zYB816ddBQOxVAcMhYnw3FOAY
	w+yc1sTKhh3p6crkDwainCi/z4Log+cS0sSkK13QO54QsFyUn6HyJlCpOpxrP9NZeTOpdzHBDi6b1
	/S56bpn+VDpLFFuCpA5yWF7+8s4WWUh+/6pq0r3zRTeMM687pvgWg+2u1E36d8bzj7PVCoJYTv7gj
	qfHGiaKDxdCQ7Y9FezCQupQwxsEBDNDX9uUfAtoZlDVFdsTNSEpjS3YBJSHgGbZtCPwSm1yXvDcgZ
	kT536gLw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D6-00000000yml-0AOO;
	Thu, 05 Nov 2026 19:45:33 -0300
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
Subject: [PATCH v5 03/17] netfs: keep the prepare_read errno when abandoning read retries
Date: Thu,  5 Nov 2026 19:45:17 -0300
Message-ID: <20261105224531.2316211-4-pc@manguebit.org>
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

