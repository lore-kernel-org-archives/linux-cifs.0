Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827712;
	b=AF3C/lU9lREn+EAVjdWYmK6f4e8iqqvwG6ZssFAjVNsCqP59dX/MPl/Y0cKP9oKKDyNA
	 v/iTf+/jMf4yCnpVyAxo/g6tQkVtpr+2arOil3+3s7DhY90YlL+98sGf9/asrA2pDUpqc
	 Oa7cOWPtw/LbSr5/UeUopRNL6rdy2SamfWCbcFHRNzIIVzwrdtTL9Q3gCNd4jGIq7GNHO
	 ybNEWbQmI2q+tdjrXSArdmpQb7kmmb50UwoYME+lzmV0iYR1OpHYJIDtswh+bG+2Q3Sil
	 V2V2Qx9GCVJRTno0BzzvcrIsdO2COA0mRARROdRiaAldpbHy8Ll2V4a+D3eG8KZWLVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827712;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=;
	b=LxaA970FMLWT80rMEqBNMlw+MN8FicJhkGXpUWlSnoa0VYVuklTWN9R3CDnxe4H7GKIj
	 en7To0k2BUdANbR3WZjiv3sdZVJlVcwiHf4G7IrxNWJ6y0vLrpAKMK42PJCl2M4ZqsOCR
	 CISLhAJvvnNrXSbY+zy+nZa65BmJoeAr2e7mypLSOLlEYnpfm+LeATXOKHEh+/VZOUnaj
	 vJwIfNQED07af3G0jMjp4kyGLgwkrbT7D1bArR1MDyb/nHrS5FMnD6vlO4DkQ7wClNSHr
	 WS+Nx3wQetu9taDLXKsdChjL2o/avwQ4gFJMCQeXqzDE6VQXO94RJmkpBCkinVM9LdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34D606C5A1;
	Wed,  4 Nov 2026 21:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F34D606C5A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=z45gJVenqDQdfqsulcVzTmokKGR0+PriaPFVgi6XmGI=; b=jiMwf424bI14qwVs4HrT71NjU3
	XhYjdDthx7XQNT2lS3P+602hTIevDS8+vQtYQQc0EerKzyQfIYlLwDXSIPHcOxuQh/PQuzh6wgW0j
	DjaCIN0gpQXJxx8mGz2HsQFnnfGAniOKQt1mfnF5amO8a1lF7NwBHuKpipaFR9xsVxCEL5BM0mKf8
	NqLFEoxmf42sxJpeS5CtvrX2i6yR4+zJKGeuC9f2kxD0SyIw41j1lJsJPgPZnHzwxnzUNYoMTRfaQ
	gUUgDssPCwfL+V3naFdHWddhSZOPqEt0/Kr7O8gpu8/HArMpOAOQ6A8gr6Jd88K9sRYmHKmoN9Vzc
	Mp/K0dJQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWg-00000000rG5-3RyU;
	Wed, 04 Nov 2026 18:28:12 -0300
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
Subject: [PATCH v4 03/17] netfs: keep the prepare_read errno when abandoning read retries
Date: Wed,  4 Nov 2026 18:27:56 -0300
Message-ID: <20261104212810.1935575-4-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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

